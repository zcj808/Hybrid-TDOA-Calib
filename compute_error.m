% Mean Square Error of microphone positions, time offsets, clock drift
% rates and sound event locations
function [mic_err,off_err,dri_err,s_err] = compute_error(g)
    if g.label=="my"
        m1=g.x_gt(1,1:3)';
        m2=g.x_gt(2,1:3)';
        m3=g.x_gt(3,1:3)';
        [R0,t0]=any2s(m1,m2,m3);
        g.x_gt(:,1:3)=(R0*g.x_gt(:,1:3)'+t0*ones(1,g.M+g.K))';

        m1=g.x(1,1:3)';
        m2=g.x(2,1:3)';
        m3=g.x(3,1:3)';
        [R_est,t_est]=any2s(m1,m2,m3);
        g.x(:,1:3)=(R_est*g.x(:,1:3)'+t_est*ones(1,g.M+g.K))';
        
        mic_err=g.x(2:g.M,1:3)'-g.x_gt(2:g.M,1:3)';
        mic_err=sum(mic_err.^2);
        mic_err=sqrt(mean(mic_err));
        off_err=sqrt(mean((g.x(2:g.M,4)-g.x_gt(2:g.M,4)).^2));
        dri_err=sqrt(mean((g.x(2:g.M,5)-g.x(1,5)-(g.x_gt(2:g.M,5)-g.x_gt(1,5))).^2));
        s_err=g.x(g.M+1:end,1:3)'-g.x_gt(g.M+1:end,1:3)';
        s_err=sum(s_err.^2);
        s_err=sqrt(mean(s_err));
    elseif g.label=="su"
        mic_err=g.x(2:g.M,1:3)'-g.x_gt(2:g.M,1:3)';
        mic_err=sum(mic_err.^2);
        mic_err=sqrt(mean(mic_err));
        off_err=sqrt(mean((g.x(2:g.M,4)-g.x_gt(2:g.M,4)).^2));
        dri_err=sqrt(mean((g.x(2:g.M,5)-g.x_gt(2:g.M,5)).^2));
        s_err=g.x(g.M+1:end,1:3)'-g.x_gt(g.M+1:end,1:3)';
        s_err=sum(s_err.^2);
        s_err=sqrt(mean(s_err));
    end
end