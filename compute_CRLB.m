function [mic_CRLB,off_CRLB,dri_CRLB] = compute_CRLB(g)
    g.x=g.x_gt;
    [J,r] = compute_J(g);
    CRLB_matrix = inv(J'/g.W*J);

    m1=g.x_gt(1,1:3)';
    m2=g.x_gt(2,1:3)';
    m3=g.x_gt(3,1:3)';
    [R0,t0]=any2s(m1,m2,m3);
    Asm=zeros(g.m*g.M+g.n*g.K-8,g.m*g.M+g.n*g.K-7);
    for i=1:g.M
        if i==1
            Asm(1:3,1:3)=R0;
        else
            id=4+g.m*(i-2);
            Asm(id:id+2,id+1:id+3)=R0;
            Asm(id+4,4)=-1;
            Asm(id+3,id+4)=1;
            Asm(id+4,id+5)=1;
        end
    end
    Asm(g.m*g.M-1:end,g.m*g.M:end)=eye(g.n*g.K-6);
    if g.label=="my"
        CRLB_matrix=Asm*CRLB_matrix*Asm';
    end
    CRLB = diag(CRLB_matrix);
    mic_CRLB = [];
    off_CRLB = [];
    dri_CRLB = [];
    if g.label=="su"
        mic_CRLB = [CRLB(1);sum(CRLB(4:5))];
        off_CRLB = [CRLB(2);CRLB(6)];
        dri_CRLB = [CRLB(3);CRLB(7)];
        for i=4:g.M
            mic_CRLB = [mic_CRLB;sum(CRLB(7+g.m*(i-4)+1:7+g.m*(i-4)+3))];  % mic. loc. CRLB
            off_CRLB = [off_CRLB;CRLB(7+g.m*(i-4)+4)];
            dri_CRLB = [dri_CRLB;CRLB(7+g.m*(i-4)+5)];
        end
        mic_CRLB = sqrt(mean(mic_CRLB));
        off_CRLB = sqrt(mean(off_CRLB));
        dri_CRLB = sqrt(mean(dri_CRLB));
    elseif g.label=="my"
        mic_CRLB=[CRLB(4);sum(CRLB(9:10))];
        off_CRLB=[CRLB(7);CRLB(12)];
        dri_CRLB=[CRLB(8);CRLB(13)];
        for i=4:g.M
            mic_CRLB = [mic_CRLB;sum(CRLB(13+g.m*(i-4)+1:13+g.m*(i-4)+3))];  % mic. loc. CRLB
            off_CRLB = [off_CRLB;CRLB(13+g.m*(i-4)+4)];
            dri_CRLB = [dri_CRLB;CRLB(13+g.m*(i-3))];
        end
        mic_CRLB = sqrt(mean(mic_CRLB));
        off_CRLB = sqrt(mean(off_CRLB));
        dri_CRLB = sqrt(mean(dri_CRLB));
    end
end