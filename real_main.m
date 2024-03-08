%% Select and put TDOA data into .mat
clear
clc
load('thres.mat');
for i=1:15
    i
    my_tdoa = get_tdoa(i,thres(i),'my');
    save(sprintf('audio/my_tdoa%d.mat',i),'my_tdoa');
    su_tdoa = get_tdoa(i,thres(i),'su');
    save(sprintf('audio/su_tdoa%d.mat',i),'su_tdoa');
end
%% Real-world experiment under various microphone number (Part A)
clear
clc
% prepare data
g_lists=[];
my_tdoa_errs=[];
su_tdoa_errs=[];
Mic_nums=[4,6,8,10];
Map=[1,2,3,4,5,6,1,2,3,4,5,6];
for ii=1:4
    M=Mic_nums(ii);
    g_list=[];
    my_tdoa_err=[];
    su_tdoa_err=[];
    for id=1:15
        for i=1:6
            for j=1:6
                for k=1:6
                    mic_ids=[];
                    if M==4
                        mic_ids=[i,0;j,0;k,Map(k+3)];
                    elseif M==6
                        mic_ids=[i,0,0;j,Map(j+3),0;k,Map(k+1),Map(k+3)];
                    elseif M==8
                        mic_ids=[i,0,0,0;j,Map(j+1),Map(j+3),0;k,Map(k+1),Map(k+2),Map(k+3)];
                    elseif M==10
                        mic_ids=[i,0,0,0,0;j,Map(j+1),Map(j+2),Map(j+3),0;k,Map(k+1),Map(k+2),Map(k+3),Map(k+4)];
                    end
                    if length(mic_ids)>0
                        g=sound_gen(mic_ids,id);
                        sg=sg_generation(g);
                        [my_qua,su_qua] = tdoa_detection(g,sg);
                        mean(my_qua)
                        mean(su_qua)
                        if abs(mean(my_qua)-mean(su_qua))<1e-5
                            my_tdoa_err=[my_tdoa_err;mean(my_qua)];
                            su_tdoa_err=[su_tdoa_err;mean(su_qua)];
                            g_list=[g_list;g];
                        end
                    end
                end
            end
        end
    end
    g_lists(ii).g_list=g_list;
    my_tdoa_errs(ii).my_tdoa_err=my_tdoa_err;
    su_tdoa_errs(ii).su_tdoa_err=su_tdoa_err;
end

for ii=1:4
    su_err=[];
    my_su_err=[];
    lim_t=2;
    g_list=g_lists(ii).g_list;
    for i=1:size(g_list,1)
        ori_g=g_list(i);
        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation1(ori_g,3);
            [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
            if norm_dk<g.dk_p || value_f<g.f_p
                my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                g.rec(6)
                break
            end
        end

        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation1(ori_g,3);
            sg=sg_generation(g);
            [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
            if norm_dk<sg.dk_p || value_f<sg.f_p
                su_err=[su_err;[sg.rec,toc(total_t)]];
                sg.rec(6)
                break
            end
        end
    end
    real1(ii).my_su_err=my_su_err;
    real1(ii).su_err=su_err;
end
save('real1.mat','real1')
%% Real-world experiment under various initial value noises (Part B) and TDOA noises (Part C)
clear
clc
% prepare data
for i=1:5
    g_lists(i).g_list=[];
    my_tdoa_errs(i).my_tdoa_err=[];
    su_tdoa_errs(i).su_tdoa_err=[];
end
Map=[1,2,3,4,5,6,1,2,3,4,5,6];
M=6;
for id=1:15
    for i=1:6
        for j=1:6
            for k=1:6
                mic_ids=[i,0,0;j,Map(j+3),0;k,Map(k+1),Map(k+3)];
                g=sound_gen(mic_ids,id);
                sg=sg_generation(g);
                [my_qua,su_qua] = tdoa_detection(g,sg);
                if mean(my_qua)<1e-4 && mean(su_qua)<1e-4
                    g_lists(1).g_list=[g_lists(1).g_list;g];
                    my_tdoa_errs(1).my_tdoa_err=[my_tdoa_errs(1).my_tdoa_err;mean(my_qua)];
                    su_tdoa_errs(1).su_tdoa_err=[su_tdoa_errs(1).su_tdoa_err;mean(su_qua)];
                elseif mean(my_qua)>1e-4 && mean(su_qua)>1e-4 && mean(my_qua)<1.5e-4 && mean(su_qua)<1.5e-4
                    g_lists(2).g_list=[g_lists(2).g_list;g];
                    my_tdoa_errs(2).my_tdoa_err=[my_tdoa_errs(2).my_tdoa_err;mean(my_qua)];
                    su_tdoa_errs(2).su_tdoa_err=[su_tdoa_errs(2).su_tdoa_err;mean(su_qua)];
                elseif mean(my_qua)>1.5e-4 && mean(my_qua)<5e-4 && mean(su_qua)>1.5e-4 && mean(su_qua)<5e-4
                    g_lists(3).g_list=[g_lists(3).g_list;g];
                    my_tdoa_errs(3).my_tdoa_err=[my_tdoa_errs(3).my_tdoa_err;mean(my_qua)];
                    su_tdoa_errs(3).su_tdoa_err=[su_tdoa_errs(3).su_tdoa_err;mean(su_qua)];
                end
                if abs(mean(my_qua)-mean(su_qua))<1e-5
                    g_lists(4).g_list=[g_lists(4).g_list;g];
                    my_tdoa_errs(4).my_tdoa_err=[my_tdoa_errs(4).my_tdoa_err;mean(my_qua)];
                    su_tdoa_errs(4).su_tdoa_err=[su_tdoa_errs(4).su_tdoa_err;mean(su_qua)];
                end
                g_lists(5).g_list=[g_lists(5).g_list;g];
                my_tdoa_errs(5).my_tdoa_err=[my_tdoa_errs(5).my_tdoa_err;mean(my_qua)];
                su_tdoa_errs(5).su_tdoa_err=[su_tdoa_errs(5).su_tdoa_err;mean(su_qua)];
            end
        end
    end
    mean(my_qua)
    mean(su_qua)
end
save('my_tdoa_errs.mat','my_tdoa_errs')
save('su_tdoa_errs.mat','su_tdoa_errs')

% under various initial value noises
init_noise=[0,0.5,1,2];
g_list=g_lists(4).g_list;
for ii=1:4
    su_err=[];
    my_su_err=[];
    lim_t=2;
    for i=1:size(g_list,1)
        ori_g=g_list(i);
        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation2(ori_g,init_noise(ii));
            [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
            if norm_dk<g.dk_p || value_f<g.f_p
                my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                g.rec(6)
                break
            end
        end

        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation2(ori_g,init_noise(ii));
            sg=sg_generation(g);
            [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
            if norm_dk<sg.dk_p || value_f<sg.f_p
                su_err=[su_err;[sg.rec,toc(total_t)]];
                sg.rec(6)
                break
            end
        end
    end
    real2(ii).my_su_err=my_su_err;
    real2(ii).su_err=su_err;
end
save('real2.mat','real2')

% under various TDOA noises
for ii=1:5
    su_err=[];
    my_su_err=[];
    g_list=g_lists(ii).g_list;
    lim_t=1;
    for i=1:size(g_list,1)
        ori_g=g_list(i);
        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation1(ori_g,3);
            [g,norm_dk,value_f] = GN_Solver(g,i,lim_t);
            if norm_dk<g.dk_p || value_f<g.f_p
                my_su_err=[my_su_err;[g.rec,toc(total_t)]];
                g.rec(6)
                break
            end
        end

        total_t=tic;
        while toc(total_t)<lim_t
            g = init_generation1(ori_g,3);
            sg=sg_generation(g);
            [sg,norm_dk,value_f] = GN_Solver(sg,i,lim_t);
            if norm_dk<sg.dk_p || value_f<sg.f_p
                su_err=[su_err;[sg.rec,toc(total_t)]];
                sg.rec(6)
                break
            end
        end
    end
    real3(ii).my_su_err=my_su_err;
    real3(ii).su_err=su_err;
end
save('real3.mat','real3')