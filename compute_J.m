% Compute Jacobian of non-linear least square of TDOA and odometry
function [J,r] = compute_J(g) % Compute Jacobian
    if g.label=="my"
        J = [];
        r = [];
        for i=1:g.M
            J_mic = zeros(g.K-1,g.m*g.M-1);
            J_s = zeros(g.K-1,g.n*(g.K-1)-3);
            for j=1:g.K-1
                pre_dx = g.x(i,1:3)-g.x(g.M+j,1:3);
                dx = g.x(i,1:3)-g.x(g.M+j+1,1:3);
                dri = g.x(i,5);
                if i==1
                    J_mic(j,g.m*(i-1)+1:4)=[(dx/norm(dx)-pre_dx/norm(pre_dx))/g.cc,g.dt(j+1)];
                else
                    J_mic(j,4+g.m*(i-2)+1:4+g.m*(i-1))=[(dx/norm(dx)-pre_dx/norm(pre_dx))/g.cc,0,g.dt(j+1)];
                end
                if j==1
                    J_s(j,1)=-dx(1)/norm(dx)/g.cc;
                elseif j==2
                    J_s(j,1)=pre_dx(1)/norm(pre_dx)/g.cc;
                    J_s(j,2:3)=[-dx(1)/norm(dx),-dx(2)/norm(dx)]/g.cc;
                elseif j==3
                    J_s(j,2:3)=[pre_dx(1)/norm(pre_dx),pre_dx(2)/norm(pre_dx)]/g.cc;
                    J_s(j,3+g.n*(j-3)+1:3+g.n*(j-3)+3)=-dx/norm(dx)/g.cc;
                else
                    J_s(j,3+g.n*(j-4)+1:3+g.n*(j-4)+3)=pre_dx/norm(pre_dx)/g.cc;
                    J_s(j,3+g.n*(j-3)+1:3+g.n*(j-3)+3)=-dx/norm(dx)/g.cc;
                end
                r = [r;(norm(dx)-norm(pre_dx))/g.cc+(1+dri)*g.dt(j+1)-g.tdoa(j,i)];
            end
            J = [J;[J_mic,J_s]];
        end

        for j=1:g.K
            J_mic = zeros(g.M-1,g.m*g.M-1);
            J_s = zeros(g.M-1,g.n*(g.K-1)-3);
            s_loc = g.x(g.M+j,1:3);
            mic_loc1 = g.x(1,1:3);
            dx1=mic_loc1-s_loc;
            dri1 = g.x(1,5);
            J_mic(:,1:g.m-1)=ones(g.M-1,1)*[-dx1/norm(dx1)/g.cc,-sum(g.dt(1:j))];
            for i=2:g.M
                mic_loc = g.x(i,1:3);
                dx=mic_loc-s_loc;
                off = g.x(i,4);
                dri = g.x(i,5);
                J_mic(i-1,4+g.m*(i-2)+1:4+g.m*(i-1))=[dx/norm(dx)/g.cc,1,sum(g.dt(1:j))]; 
                if j==2
                    J_s(i-1,1)=(dx1(1)/norm(dx1)-dx(1)/norm(dx))/g.cc;
                elseif j==3
                    J_s(i-1,2:3)=(dx1(1:2)/norm(dx1)-dx(1:2)/norm(dx))/g.cc;
                elseif j>3
                    J_s(i-1,g.n*(j-4)+1+3:g.n*(j-3)+3)=(dx1/norm(dx1)-dx/norm(dx))/g.cc;
                end
                r = [r;(norm(mic_loc-s_loc)-norm(mic_loc1-s_loc))/g.cc+off+sum(g.dt(1:j))*(dri-dri1)-g.su_tdoa(i-1,j)];
            end
            J = [J;[J_mic,J_s]];
        end
        J_odo=zeros(g.n*(g.K-1),g.n*(g.K-1)-3);
        for j=1:g.K-1
            if j==1
                J_odo(g.n*(j-1)+1:g.n*(j-1)+3,1)=[1;0;0];
            elseif j==2
                J_odo(g.n*(j-1)+1:g.n*(j-1)+3,1:3)=[-1,1,0;0,0,1;0,0,0];
            elseif j==3
                J_odo(g.n*(j-1)+1:g.n*(j-1)+3,2:6)=[-1,0,1,0,0;0,-1,0,1,0;0,0,0,0,1];
            else
                J_odo(g.n*(j-1)+1:g.n*(j-1)+3,4+g.n*(j-4):4+g.n*(j-2)-1)=[-eye(3),eye(3)];
            end
            s_now = g.x(g.M+j,1:3)';
            s_next = g.x(g.M+j+1,1:3)';
            r = [r;s_next-s_now-(g.S(:,j+1)-g.S(:,j))];
        end
        J_odo=[zeros(g.n*(g.K-1),g.m*g.M-1),J_odo];
        J=[J;J_odo];
    elseif g.label=="su"
        J = [];
        r = [];
        for j=1:g.K
            J_mic = zeros(g.M-1,g.m*g.M-8);
            J_s = zeros(g.M-1,g.n*g.K);
            s_loc = g.x(g.M+j,1:3);
            for i=2:g.M
                mic_loc = g.x(i,1:3);
                dx=mic_loc-s_loc;
                off = g.x(i,4);
                dri = g.x(i,5);
                if i==2
                    J_mic(i-1,1:3)=[dx(1)/norm(dx)/g.cc,1,sum(g.dt(1:j))];
                elseif i==3
                    J_mic(i-1,4:7)=[dx(1)/norm(dx)/g.cc,dx(2)/norm(dx)/g.cc,1,sum(g.dt(1:j))];
                else
                    J_mic(i-1,7+g.m*(i-4)+1:7+g.m*(i-3))=[dx/norm(dx)/g.cc,1,sum(g.dt(1:j))];
                end
                J_s(i-1,g.n*(j-1)+1:g.n*j)=(-dx/norm(dx)-s_loc/norm(s_loc))/g.cc;
                r = [r;(norm(mic_loc-s_loc)-norm(s_loc))/g.cc+off+sum(g.dt(1:j))*dri-g.tdoa(i-1,j)];
            end
            J = [J;[J_mic,J_s]];
            if j<g.K
                J_odo=zeros(3,g.m*g.M+g.n*g.K-8);
                J_odo(:,g.m*g.M-8+g.n*(j-1)+1:g.m*g.M-8+g.n*j)...
                    =-eye(3);
                J_odo(:,g.m*g.M-8+g.n*j+1:g.m*g.M-8+g.n*(j+1))...
                    =eye(3);
                s_now = g.x(g.M+j,1:3)';
                s_next = g.x(g.M+j+1,1:3)';
                r = [r;s_next-s_now-g.S(:,j+1)+g.S(:,j)];
                J = [J;J_odo];
            end
        end
    end
end