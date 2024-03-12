%% Simulation under various microphone number (Part A)
clear
clc
M_nums=[4,6,8,10];
for j=1:3
    traj_id=j;
    for ii=1:4
        lim_t=2;
        su_err=[];
        my_su_err=[];
        su_CRLBs=[];
        my_su_CRLBs=[];
        for i=1:200
            ori_g=gt_generation(1e-4,traj_id,M_nums(ii));
            total_t=tic;
            while toc(total_t)<lim_t
                g = init_generation1(ori_g,traj_id);
                [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
                if norm_dk<g.dk_p || value_f<g.f_p
                    my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                    g.rec(6)
                    break
                end
            end
    
            total_t=tic;
            while toc(total_t)<lim_t
                g = init_generation1(ori_g,traj_id);
                sg=sg_generation(g);
                [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
                if norm_dk<sg.dk_p || value_f<sg.f_p
                    su_err=[su_err;[sg.rec,toc(total_t)]];
                    sg.rec(6)
                    break
                end
            end
            sim1(4*(j-1)+ii).su_err=su_err;
            sim1(4*(j-1)+ii).my_su_err=my_su_err;
        end
    end
end
save('sim1.mat','sim1')
%% Simulation under various initial value noises (Part B)

clcclear
init_noise=[0,1,2,3;0,2,4,6;0,2,4,6];
for j=1:3
    traj_id=j;
    for ii=1:4
        lim_t=2;
        su_err=[];
        my_su_err=[];
        su_CRLBs=[];
        my_su_CRLBs=[];
        for i=1:200
            ori_g=gt_generation(1e-4,traj_id,6);
            total_t=tic;
            while toc(total_t)<lim_t
                g = init_generation2(ori_g,init_noise(j,ii));
                [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
                if norm_dk<g.dk_p || value_f<g.f_p
                    my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                    g.rec(6)
                    break
                end
            end
    
            total_t=tic;
            while toc(total_t)<lim_t
                g = init_generation2(ori_g,init_noise(j,ii));
                sg=sg_generation(g);
                [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
                if norm_dk<sg.dk_p || value_f<sg.f_p
                    su_err=[su_err;[sg.rec,toc(total_t)]];
                    sg.rec(6)
                    break
                end
            end
            sim2(4*(j-1)+ii).su_err=su_err;
            sim2(4*(j-1)+ii).my_su_err=my_su_err;
        end
    end
end
save('sim2.mat','sim2')
%% Simulation under various TDOA noises (Part C&D)
clear
clc
noises=[5e-5,1e-4,5e-4];
lim_t=2;
for j=1:3
    traj_id=j;
    for ii=1:3
        su_err=[];
        my_su_err=[];
        su_CRLBs=[];
        my_su_CRLBs=[];
        for i=1:200
            ori_g=gt_generation(noises(ii),traj_id,6);
            [mic_CRLB,off_CRLB,dri_CRLB]=compute_CRLB(ori_g);
            my_su_CRLBs=[my_su_CRLBs;[mic_CRLB,off_CRLB,dri_CRLB]];
            total_t=tic;
            while toc(total_t)<lim_t
                g = init_generation1(ori_g,traj_id);
                [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
                if norm_dk<g.dk_p || value_f<g.f_p
                    my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                    g.rec(6)
                    break
                end
            end

            ori_sg=sg_generation(ori_g);
            [mic_CRLB,off_CRLB,dri_CRLB]=compute_CRLB(ori_sg);
            su_CRLBs=[su_CRLBs;[mic_CRLB,off_CRLB,dri_CRLB]];
            total_t=tic;
            while toc(total_t)<lim_t
                g=init_generation1(ori_g,traj_id);
                sg=sg_generation(g);
                plot_g(sg,'no')
                [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
                if norm_dk<sg.dk_p || value_f<sg.f_p
                    su_err=[su_err;[sg.rec,toc(total_t)]];
                    sg.rec(6)
                    break
                end
            end
        end
        sim0(3*(j-1)+ii).su_CRLBs=su_CRLBs;
        sim0(3*(j-1)+ii).my_su_CRLBs=my_su_CRLBs;
        sim3(3*(j-1)+ii).su_err=su_err;
        sim3(3*(j-1)+ii).my_su_err=my_su_err;
    end
end
save('sim0.mat','sim0')
save('sim3.mat','sim3')