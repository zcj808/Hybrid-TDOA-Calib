function [g,norm_dk,value_f] = GN_Solver(g,i,GN_t)
    [ini_mic_err,ini_off_err,ini_dri_err,ini_s_err] = compute_error(g);
    [J,r] = compute_J(g);
    ini_value_f = 1/2*r'/g.W*r;
    tic
    while toc<GN_t/10
        [J,r] = compute_J(g);
        dk = -(J'/g.W*J)\J'/g.W*r;
        value_f = 1/2*r'/g.W*r;
        norm_dk = norm(dk);
        xk = high2low(g);
        xk = xk+dk;
        g = low2high(xk,g);
        if norm_dk < g.dk_p || value_f<g.f_p % use && lead gt_rec low conv. in large TDOA noise
            [mic_err,off_err,dri_err,s_err] = compute_error(g);
            g.rec=[i,ini_value_f,value_f,ini_mic_err,ini_s_err,mic_err,off_err,dri_err,s_err,toc];
            disp("convergence");
            break
        elseif value_f/ini_value_f>1e5 || isnan(value_f)
            disp("divergence");
            break
        end
    end
end