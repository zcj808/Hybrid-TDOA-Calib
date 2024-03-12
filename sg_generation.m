function [sg] = sg_generation(g)
    sg = g;
    mic1=sg.x_gt(1,1:3)';
    mic2=sg.x_gt(2,1:3)';
    mic3=sg.x_gt(3,1:3)';
    [R,t]=any2s(mic1,mic2,mic3);
    sg.x_gt(:,1:3)=(R*sg.x_gt(:,1:3)'+t*ones(1,sg.M+sg.K))'; % True values transformation
    
    % Initial values transformation
    sg.x(:,1:3)=(R*sg.x(:,1:3)'+t*ones(1,sg.M+sg.K))';
    sg.x(1,1:3)=[0,0,0];
    sg.x(2,2:3)=[0,0];
    sg.x(3,3)=0;
    sg.x(1:sg.M,4:5)=zeros(sg.M,2);
    
    sg.x_gt(2:sg.M,5)=sg.x_gt(2:g.M,5)-sg.x_gt(1,5);
    sg.x_gt(1,5)=0;
    sg.tdoa=g.su_tdoa;
    sg.S=R*sg.S+t*ones(1,sg.K);
    W=zeros((g.M-1)*g.K+3*(g.K-1));
    for j=1:sg.K
        id=(sg.M-1)*(j-1)+3*(j-1)+1;
        if j~=sg.K  
            W(id:id+sg.M-2,id:id+sg.M-2)=sg.tdoa_sigma^2*eye(sg.M-1);
            W(id+sg.M-1:id+sg.M+1,id+sg.M-1:id+sg.M+1)=sg.odo_sigma^2*eye(3);
        else
           W(id:id+sg.M-2,id:id+sg.M-2)=sg.tdoa_sigma^2*eye(sg.M-1);
        end
    end
    sg.W = W;
    sg.label="su";
end