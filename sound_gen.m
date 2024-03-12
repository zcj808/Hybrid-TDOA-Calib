function [g] = sound_gen(mic_ids,id)
    gt_mic_locs=[];
    % generate real experiment data
    arr_loc_ids=[ones(3,1)*[8,7,3];ones(3,1)*[8,7,6];
        ones(3,1)*[2,4,6];ones(3,1)*[2,5,6];
        ones(3,1)*[2,6,1]]; % [loc. id selected by 1-st mic., loc. id selected by 2-st mic., ...]
    arr_loc_id=arr_loc_ids(id,:);
    % compute microphones locations on abs. frame
    arr_M=[6,6,6];
    M=sum(mic_ids>0,'all');
    p_list=[];
    p4_list=[];
    ex_locs=[-56,0,-48,0;-56,-56,-48,-56;
        0,-55,7,-55;58,-55,65,-55;
        58,0,65,0;-3.5,0,3.5,0;
        25,-27,32,-27;-27,-31,-34,-31]/100;
    hig_list=[2,6,12]/100;
    for i=1:length(arr_loc_id)
        p_list=[p_list,[ex_locs(arr_loc_id(i),1:2)';hig_list(i)]];
        p4_list=[p4_list,[ex_locs(arr_loc_id(i),3:4)';hig_list(i)]];
    end
    a=0.035;
    c=cos(pi/3);
    s=sin(pi/3);
    % array shape
    ori_arr_locs=[0,0,0;
        0,-a*c,-a*s;
        0,-a*(1+c),-a*s;
        0,-2*a,0;
        0,-a*(1+c),a*s;
        0,-a*c,a*s];
    R_list=[];
    for i=1:length(arr_M)
        p1=p_list(:,i);
        p4=p4_list(:,i);
        Ry=p1-p4;
        Ry=Ry/norm(Ry);
        Rx=[0;0;1];
        Rz=cross(Rx,Ry);
        R=[Rx,Ry,Rz];
        R_list=[R_list,R];
    end
    for j=1:length(mic_ids(i,:))
        for i=1:length(arr_M)
            R=R_list(:,3*(i-1)+1:3*i);
            p=p_list(:,i)*ones(1,arr_M(i));
            t_arr_locs=R*ori_arr_locs'+p;
            if mic_ids(i,j)>0
                gt_mic_locs=[gt_mic_locs,t_arr_locs(:,mic_ids(i,j))];
            end
        end
    end
    displace=[];
    K=14; % number of sound sources
    % compute and transform sound locations from abs. frame to s. frame
    gt_s_locs=[-92.5+5.5,-92.5+5.5,-36.5-1,40.5-1,92-5.5,43+1,-37+1;
        0+1,-52+1,-86+5.5,-86+5.5,-26-1,38-5.5,38-5.5];
    gt_s_locs=[[gt_s_locs;80*ones(1,7)],[gt_s_locs;43*ones(1,7)]]/100;
    load(sprintf('displacement/displacement_%d.mat',id));
    S=[0;0;0];
    for i=1:K-1
        S=[S,S(:,i)+displace(i,:)'];
    end
    S(3,1:7)=S(3,1:7)+0.8;
    S(3,8:end)=S(3,8:end)+0.43;
    
    % scatter3(gt_s_locs(1,:),gt_s_locs(2,:),gt_s_locs(3,:));
    % hold on
    % scatter3(gt_mic_locs(1,:),gt_mic_locs(2,:),gt_mic_locs(3,:));
    % legend('gt.s','gt.mic')
    
    [R_mea,t_mea]=any2s(S(:,1),S(:,2),S(:,3));
    g.S=R_mea*S+t_mea*ones(1,K);
    
    [R_gt,t_gt]=any2s(gt_s_locs(:,1),gt_s_locs(:,2),gt_s_locs(:,3));
    g.x_gt=[(R_gt*gt_mic_locs+t_gt*ones(1,M))';(R_gt*gt_s_locs+t_gt*ones(1,K))'];
    g.x_gt=[g.x_gt,zeros(M+K,2)];
    g.x=zeros(size(g.x_gt));
    
    load('dt.mat')
    g.dt=dt(id,:);
    g.tdoa=[];
    g.su_tdoa=[];

    load(sprintf('audio/my_tdoa%d.mat',id))
    if M==2
        for ii=1:3
            if mic_ids(ii)>0
                g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii))];
            end
        end
    elseif M==4
        for ii=1:3
            if ii<3
                g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,1))];
            else
                g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,1))];
                g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,2))];
            end
        end
    elseif M==6
        for j=1:3
            for ii=1:3
                if mic_ids(ii,j)>0
                    g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,j))];
                end
            end
        end
    elseif M==8
        for j=1:4
            for ii=1:3
                if mic_ids(ii,j)>0
                    g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,j))];
                end
            end
        end
    elseif M==10
        for j=1:5
            for ii=1:3
                if mic_ids(ii,j)>0
                    g.tdoa=[g.tdoa,my_tdoa(:,6*(ii-1)+mic_ids(ii,j))];
                end
            end
        end
    end
    load(sprintf('audio/su_tdoa%d.mat',id))
    if M==2
        i=mic_ids(1);
        j=mic_ids(2);
        k=mic_ids(3);
        if j==0
            j=1;
            su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
            g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
        elseif k==0
            k=1;
            su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
            g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
        end
    elseif M==4
        i=mic_ids(1,1);
        j=mic_ids(2,1);
        k=mic_ids(3,1);
        su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
        k=mic_ids(3,2);
        su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
    elseif M==6
        i=mic_ids(1,1);
        j=mic_ids(2,1);
        k=mic_ids(3,1);
        su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
        for ii=2:3
            if mic_ids(2,ii)>0
                j=mic_ids(2,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
            end
            if mic_ids(3,ii)>0
                k=mic_ids(3,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
            end
        end
    elseif M==8
        i=mic_ids(1,1);
        j=mic_ids(2,1);
        k=mic_ids(3,1);
        su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
        for ii=2:4
            if mic_ids(2,ii)>0
                j=mic_ids(2,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
            end
            if mic_ids(3,ii)>0
                k=mic_ids(3,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
            end
        end
    elseif M==10
        i=mic_ids(1,1);
        j=mic_ids(2,1);
        k=mic_ids(3,1);
        su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
        g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
        for ii=2:5
            if mic_ids(2,ii)>0
                j=mic_ids(2,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id,:)];
            end
            if mic_ids(3,ii)>0
                k=mic_ids(3,ii);
                su_id=2*36*(i-1)+2*6*(j-1)+2*(k-1)+1;
                g.su_tdoa=[g.su_tdoa;su_tdoa(su_id+1,:)];
            end
        end
    end
    
    % other parameters configuration
    g.M = M;
    g.m = 5;
    g.K = K;
    g.n = 3;
    g.tdoa_sigma=1e-4;
    g.odo_sigma=1e-2;
    % noise convariance matrix
    g.W=g.tdoa_sigma^2*eye(g.M*(g.K-1)+(g.M-1)*g.K+g.n*(g.K-1));
    tdoa_id=g.M*(g.K-1)+(g.M-1)*g.K;
    g.W(tdoa_id+1:end,tdoa_id+1:end)=g.odo_sigma^2*eye(g.n*(g.K-1));
    g.cc = 340;
    g.label='my';
    g.dk_p=1e-2;
    g.f_p=30;
end