function [g] = init_generation2(g,sigma) % add noises to initial value of locations
    if g.label=="my"
        g.x(:,1:3)=g.x_gt(:,1:3)+normrnd(0,sigma,g.M+g.K,3);
        g.x(g.M+1,1:3)=[0,0,0];
        g.x(g.M+2,2:3)=[0,0];
        g.x(g.M+3,3)=0;
        g.x(1:g.M,4:5)=zeros(g.M,2);
    else
        disp('False')
    end
end

