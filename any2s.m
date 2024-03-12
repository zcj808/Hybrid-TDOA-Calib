% R,t can transform current frame into frame established by s1,s2,s3
function [R,t] = any2s(s1,s2,s3) % s1,s2,s3 are column vectors
    t=s1;
    Rx=s2-s1;
    Rx=Rx/norm(Rx);
    Ry=(s3-s1)-(s3-s1)'*Rx*Rx;
    Ry=Ry/norm(Ry);
    Rz=cross(Rx,Ry);
    R=[Rx,Ry,Rz];
    t=-R'*t;
    R=R';
end

