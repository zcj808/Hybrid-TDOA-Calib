% transform g.x into the unknown parameter vector
function [low] = high2low(g)
    low=[];
    if g.label=="my"
        high=g.x(1:g.M,:)';
        low=high(:);
        low=[low(1:3);low(5:end)];
        low=[low;g.x(g.M+2,1);g.x(g.M+3,1:2)'];
        high=g.x(g.M+4:end,1:3)';
        low = [low;high(:)];
    elseif g.label=="su"
        high=g.x(4:g.M,:)';
        low=[g.x(2,1);g.x(2,4:5)';g.x(3,1:2)';g.x(3,4:5)';high(:)]; % mic. loc.
        high=g.x(g.M+1:end,1:3)';
        low=[low;high(:)]; % s. loc.
    end
end