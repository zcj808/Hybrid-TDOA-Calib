% Plot trajectory of estimated values and true values of g
function []=plot_g(g,label) % label='gt' means visualize only true values
    if label=='gt'
        plot3(g.x_gt(1:g.M,1), g.x_gt(1:g.M,2), g.x_gt(1:g.M,3), 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
        hold on;
        plot3(g.x_gt(g.M+1:end,1), g.x_gt(g.M+1:end,2), g.x_gt(g.M+1:end,3), 'LineStyle','none','Marker','x', 'MarkerSize', 4.5,'MarkerEdgeColor','b', 'LineWidth',1);
        legend('Mic. gt.','Sound source gt.');
        xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
        grid on;
        view(30,30);
        hold off;
        grid on; axis equal;
    else
        plot3(g.x_gt(1:g.M,1), g.x_gt(1:g.M,2), g.x_gt(1:g.M,3), 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','r', 'LineWidth',2);
        hold on;
        plot3(g.x(1:g.M,1), g.x(1:g.M,2), g.x(1:g.M,3), 'LineStyle','none','Marker','o', 'MarkerSize', 4,'MarkerEdgeColor','g','MarkerFaceColor','g');
        hold on;
        plot3(g.x_gt(g.M+1:end,1), g.x_gt(g.M+1:end,2), g.x_gt(g.M+1:end,3), 'LineStyle','none','Marker','x', 'MarkerSize', 4.5,'MarkerEdgeColor','b', 'LineWidth',1);
        hold on;
        plot3(g.x(g.M+1:end,1), g.x(g.M+1:end,2), g.x(g.M+1:end,3), 'LineStyle','none','Marker','square', 'MarkerSize', 4.5,'MarkerEdgeColor','c');
        hold on;
        plot3(g.S(1,:), g.S(2,:), g.S(3,:), 'LineStyle','none','Marker','square', 'MarkerSize', 4.5,'MarkerEdgeColor','y');
        legend('Mic. gt.','Mic. est.','Sound source gt.','Sound source est.','Odometry');
        xlabel('X (m)');ylabel('Y (m)');zlabel('Z (m)');
        grid on;
        view(30,30);
        hold off;
        grid on; axis equal;
    end
end