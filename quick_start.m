clear
clc
traj_id=0; % 0 belongs to scenario in "quick start"
tdoa_sigma=1e-4; % TDOA noise sigma
init_sigma=2; % Initial value noise sigma, you can increase it, i.e. 0.5, 1, 2, ...
Mic_num=8; % Mic. Number
lim_t=2; % Time upper limit
ori_g=gt_generation(tdoa_sigma,traj_id,Mic_num);
total_t=tic;
while toc(total_t)<lim_t
    g = init_generation2(ori_g,init_sigma);
    init_g=g;
    [g,norm_dk,value_f] = GN_Solver(g,1,lim_t);
    if norm_dk<g.dk_p || value_f<g.f_p
        my_su_err=[g.rec,toc(total_t)];
        subplot(2,2,1);
        plot_g(init_g,'no');
        title('our method init.','FontSize',20)
        subplot(2,2,3);
        plot_g(g,'no');
        title('our method result','FontSize',20)
        g.rec(6)
        break
    end
end

total_t=tic;
while toc(total_t)<lim_t
    g = init_generation2(ori_g,init_sigma);
    sg=sg_generation(g);
    init_sg=sg;
    [sg,norm_dk,value_f] = GN_Solver(sg,1,lim_t);
    if norm_dk<sg.dk_p || value_f<sg.f_p
        su_err=[sg.rec,toc(total_t)];
        subplot(2,2,2);
        plot_g(init_sg,'no');
        title('method [12] init.','FontSize',20)
        subplot(2,2,4);
        plot_g(sg,'no');
        title('method [12] result','FontSize',20)
        sg.rec(6)
        break
    end
end
clc
sprintf('Loc. err. of my method: %f m',round(my_su_err(6),3))
sprintf('Loc. err. of method [12]: %f m',round(su_err(6),3))