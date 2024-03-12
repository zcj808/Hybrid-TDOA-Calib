function [my_qua,su_qua] = tdoa_detection(g,sg)
    % estimate standard deviation of TDOA-M noise
    su_det=zeros(sg.M-1,sg.K);
    A=[];
    for j=1:sg.K
        s_loc = sg.x_gt(sg.M+j,1:3);
        A=[A;[1,sum(sg.dt(1:j))]];
        for i=2:sg.M
            mic_loc = sg.x_gt(i,1:3);
            su_det(i-1,j)=sg.su_tdoa(i-1,j)-(norm(mic_loc-s_loc)-norm(s_loc))/sg.cc; 
        end
    end
    su_qua=[];
    noise_est=[];
    for i=1:size(su_det,1)
        b=su_det(i,:)';
        x=(A'*A)\A'*b;
        tau=x(1);
        delta=x(2);
        for j=1:sg.K
            noise_est=[noise_est,su_det(i,j)-tau-sum(sg.dt(1:j))*delta];
        end
        su_qua=[su_qua;abs(std(noise_est))];
    end

    % estimate standard deviation of TDOA-S noise
    my_det=zeros(g.M,g.K-1);
    for j=2:g.K
        for i=1:g.M
            pre_dx = g.x_gt(i,1:3)-g.x_gt(g.M+j-1,1:3);
            dx = g.x_gt(i,1:3)-g.x_gt(g.M+j,1:3);
            my_det(i,j-1)=g.tdoa(j-1,i)-g.dt(j)-(norm(dx)-norm(pre_dx))/g.cc;
        end
    end
    my_qua=[];
    for i=1:size(my_det,1)
        dri_est=sum(my_det(i,:))/sum(g.dt);
        new_sample=my_det(i,:)-dri_est*g.dt(2:end);
        my_qua=[my_qua;abs(std(new_sample))];
    end
end