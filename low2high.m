% Update g.x using parameter vector of non-linear least square in TDOA-GN
function [g] = low2high(low,g)
    if g.label=="my"
        % Update mic. loc.
        high=low(5:g.m*g.M-1);
        g.x(1:g.M,:) = [[low(1:3)',g.x(1,4),low(4)];reshape(high,5,g.M-1)'];
        % Update s. loc.
        g.x(g.M+2,1) = low(g.m*g.M-1+1);
        g.x(g.M+3,1:2) = low(g.m*g.M-1+2:g.m*g.M-1+3)'; 
        g.x(g.M+4:end,1:3)=reshape(low(g.m*g.M-1+4:end),3,g.K-3)';
    elseif g.label=="su"
        % Update mic. loc & mic. off.
        g.x(2,1)=low(1);g.x(2,4:5)=low(2:3)';g.x(3,1:2)=low(4:5);g.x(3,4:5)=low(6:7);
        g.x(4:g.M,:)=reshape(low(8:g.m*g.M-8),5,g.M-3)';
        % Update s. loc.
        g.x(g.M+1:end,1:3)=reshape(low(g.m*g.M-7:end),3,g.K)';
    end
end
