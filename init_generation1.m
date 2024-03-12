function [g] = init_generation1(g,traj_id)
    if g.label=="my"
        g.x(:,1:3)=3*rand(g.M+g.K,3);  % traj1
        if traj_id==2
            g.x(:,1:3)=[2*rand(g.M+g.K,1),6*rand(g.M+g.K,1),2*rand(g.M+g.K,1)];  % traj2
        elseif traj_id==3
            g.x(:,1:3)=[-2+4*rand(g.M+g.K,1),4*rand(g.M+g.K,1),2*rand(g.M+g.K,1)];  % traj3
        elseif traj_id==4
            g.x(:,1:3)=[-.8+1.6*rand(g.M+g.K,1),2*rand(g.M+g.K,1),-1*rand(g.M+g.K,1)]; % real traj
        end
        g.x(g.M+1,1:3)=[0,0,0];
        g.x(g.M+2,2:3)=[0,0];
        g.x(g.M+3,3)=0;
        g.x(1:g.M,4:5)=zeros(g.M,2);
    else
        disp('False')
    end
end

