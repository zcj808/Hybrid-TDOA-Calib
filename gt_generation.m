% the true values configuration
function [g] = gt_generation(tdoa_sigma,traj_id,Mic_num)
    M=8;  % number of microphones
    m=5;  % parameters number of each microphone
    off=0.1; % maximum of time offset and unit is second
    fs=16000;
    max_n=1e-4;
    Mic_loc=[0,1,1,0,0,0,1,1;  % quick start
            0,0,1,1,1,0,0,1;
            0,0,0,0,1,1,1,1]+[1;1;1]*ones(1,M);
    x_gt=[Mic_loc',-off+2*off*rand(M,1),-max_n+2*max_n*rand(M,1)]; % quick start
    if traj_id==1
        M=Mic_num;
        x_gt=[3*rand(M,3),-off+2*off*rand(M,1),-max_n+2*max_n*rand(M,1)]; % traj1
    elseif traj_id==2
        M=Mic_num;
        x_gt=[2*rand(M,1),6*rand(M,1),2*rand(M,1),-off+2*off*rand(M,1),-max_n+2*max_n*rand(M,1)]; % traj2
    elseif traj_id==3
        M=Mic_num;
        x_gt=[-2+4*rand(M,1),4*rand(M,1),2*rand(M,1),-off+2*off*rand(M,1),-max_n+2*max_n*rand(M,1)]; % traj3
    end
    x_gt(1,4)=0; % time offset is relative and clock drift is absoulte

    % traj1
    gt_loc=3*[0,1,1,0,0,0,1,1;
            0,0,1,1,1,0,0,1;
            0,0,0,0,1,1,1,1];
    K=8; % number of sound sources
    if traj_id==2
        % traj2
        gt_loc=[0,2,2,2,2,2,2,2,2,0;
                0,0,2,4,6,6,4,2,0,0;
                0,0,0,0,0,2,2,2,2,2];
        K=10;
    elseif traj_id==3
        gt_loc=2*[0,1,1,1,0,-1,-1,-1,-1,-1,-1,0,1,1;
                0,0,1,2,2,2,1,0,0,1,2,2,2,1;
                0,0,0,0,0,0,0,0,1,1,1,1,1,1];
        K=14;
    end

    n=3; % parameters number of each microphone
    dt=[0;10*rand(K-1,1)]; % my method starts from 2, su starts from 1

    g.x_gt = [x_gt;[gt_loc',zeros(K,2)]];
    g.x=zeros(size(g.x_gt));

    % generate TDOA for adjacent sound events
    g.tdoa = zeros(K-1,M);
    g.tdoa_sigma=tdoa_sigma;
    cc = 340;  % sound speed，unit is m/s
    for i=1:M
        mic_loc = g.x_gt(i,1:3);
        dri = g.x_gt(i,5);
        for j=2:K
            s_loc = g.x_gt(M+j,1:3);
            pre_s_loc = g.x_gt(M+j-1,1:3);
            g.tdoa(j-1,i) = (norm(mic_loc-s_loc)-norm(mic_loc-pre_s_loc))/cc+(1+dri)*dt(j)+normrnd(0,g.tdoa_sigma);
        end
    end

    % generate odometry measurement
    g.odo_sigma = 1e-2;
    s_noise=normrnd(0,g.odo_sigma,3,1);
    g.S = [g.x_gt(M+1,1:3)',g.x_gt(M+2,1:3)'+[s_noise(1);0;0]];
    for j=3:K
        s_noise=s_noise+normrnd(0,g.odo_sigma,3,1); % 
        if j==3
            g.S=[g.S,g.x_gt(M+j,1:3)'+[s_noise(1);s_noise(2);0]];
        else
            g.S=[g.S,g.x_gt(M+j,1:3)'+s_noise];
        end
    end
    
    % generate noise convariance matrix
    g.W=g.tdoa_sigma^2*eye(M*(K-1)+(M-1)*K+n*(K-1));
    tdoa_id=M*(K-1)+(M-1)*K;
    g.W(tdoa_id+1:end,tdoa_id+1:end)=g.odo_sigma^2*eye(n*(K-1));
    
    % other configuration
    g.cc = cc;g.fs=fs;g.dt=dt;g.M = M;g.m = m;g.K = K;g.n = n;
    g.label="my";g.dk_p=1e-2;g.f_p=30;

    % generate su tdoa
    sg=g;
    sg.x_gt(2:sg.M,5)=sg.x_gt(2:g.M,5)-sg.x_gt(1,5);
    sg.x_gt(1,5)=0;
    g.su_tdoa=zeros(sg.M-1,sg.K);
    mic1_loc=sg.x_gt(1,1:3);
    for j=1:sg.K
        s_loc = sg.x_gt(g.M+j,1:3);
        for i=2:sg.M
            mic_loc = sg.x_gt(i,1:3);
            off=sg.x_gt(i,4); % assume it's relative to mic1
            dri=sg.x_gt(i,5); % assume it's relative to mic1
            % sound and all mics open simultaneously and after delta T emitting
            % a sound and so on...
            g.su_tdoa(i-1,j)=(norm(mic_loc-s_loc)-norm(mic1_loc-s_loc))/sg.cc+off+sum(sg.dt(1:j))*dri+normrnd(0,sg.tdoa_sigma);
        end
    end
end