%% Simulation results for CRLB (Table II)
clear
clc
load('sim0.mat')
mean_values = zeros(3,2);
data_id=3; % 1,2,3 represent Loc. err., Off. err. and Dri. err respectively
for i=1:3
    mics=zeros(400,2);
    lens=[];
    my_su_mic1 = [sim0(i).my_su_CRLBs(:,data_id);sim0(i+3).my_su_CRLBs(:,data_id);sim0(i+6).my_su_CRLBs(:,data_id)];
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = [sim0(i).su_CRLBs(:,data_id);sim0(i+3).su_CRLBs(:,data_id);sim0(i+6).su_CRLBs(:,data_id)];
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=3;
    for j=1:2
        mic_data=mics(1:lens(j),j);
        q1=quantile(mic_data,0.25);
        q3=quantile(mic_data,0.75);
        low=q1-1.5*(q3-q1);
        hig=q3+1.5*(q3-q1);
        mean_values(i,j)=mean(mic_data(mic_data>low  & mic_data<hig));
    end
end
if data_id==1
    mean_values=round(mean_values,3); % unit
elseif data_id==2
    mean_values=round(1000*mean_values,3); % unit
elseif data_id==3
    mean_values=round(1000000*mean_values,3); % unit
end
%% Simulation results under various microphone number (Fig.3a-c)
clear
clc
load('sim1.mat')
mean_values = zeros(4,2);
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=3;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6; % 6,7,8 represent Loc. err., Off. err. and Dri. err respectively
upper_n=10;
if data_id==7
    upper_n=1e-2;
elseif data_id==8
    upper_n=1e-4;
end
for i=1:4
    mics=zeros(400,2);
    lens=[];
    my_su_mic1 = [sim1(i).my_su_err(:,data_id);sim1(i+4).my_su_err(:,data_id);sim1(i+8).my_su_err(:,data_id)];
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = [sim1(i).su_err(:,data_id);sim1(i+4).su_err(:,data_id);sim1(i+8).su_err(:,data_id)];
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=5;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
xTickLabel=["4","6","8","10"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 1.25],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('Mic. number')
if data_id==6
    ylabel('Loc. err. (m)')
elseif data_id==7
    ylabel('Off. err. (s)')
elseif data_id==8
    ylabel('Dri. err.')
end
grid on;
%% Simulation results under various initial value noises (Fig.3d-f)
clear
clc
load('sim2.mat')
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=3;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6;  % 6,7,8 represent Loc. err., Off. err. and Dri. err respectively
upper_n=1;
if data_id==7
    upper_n=1e-3;
elseif data_id==8
    upper_n=1e-4;
end
for i=1:4
    mics=zeros(400,2);
    lens=[];
    my_su_mic1 = [sim2(i).my_su_err(:,data_id);sim2(i+4).my_su_err(:,data_id);sim2(i+8).my_su_err(:,data_id)];
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = [sim2(i).su_err(:,data_id);sim2(i+4).su_err(:,data_id);sim2(i+8).su_err(:,data_id)];
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=5;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
xTickLabel=["0/0","1/2","2/4","3/6"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 1.25],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('\sigma_{init}(m)')
if data_id==6
    ylabel('Loc. err. (m)')
elseif data_id==7
    ylabel('Off. err. (s)')
elseif data_id==8
    ylabel('Dri. err.')
end
grid on;
%% Simulation results under various TDOA noises (Fig.3g-i)
clear
clc
load('sim3.mat')
mean_values = zeros(4,2);
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=3;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6;  % 6,7,8 represent Loc. err., Off. err. and Dri. err respectively
upper_n=7;
if data_id==7
    upper_n=1e-2;
elseif data_id==8
    upper_n=1e-4;
end
for i=1:3
    mics=zeros(400,2);
    lens=[];
    my_su_mic1 = [sim3(i).my_su_err(:,data_id);sim3(i+3).my_su_err(:,data_id);sim3(i+6).my_su_err(:,data_id)];
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = [sim3(i).su_err(:,data_id);sim3(i+3).su_err(:,data_id);sim3(i+6).su_err(:,data_id)];
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=5;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
mean_values=round(mean_values,3);
xTickLabel=["$5\times10^{-5}s$","$10^{-4}s$","$5\times10^{-4}s$"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 0.95],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('\sigma_{tdoa}(s)')
if data_id==6
    ylabel('Loc. err. (m)')
elseif data_id==7
    ylabel('Off. err. (s)')
elseif data_id==8
    ylabel('Dri. err.')
end
grid on;
%% TDOA noise evaluation
clear
clc
load('my_tdoa_errs.mat')
load('su_tdoa_errs.mat')
mean_values = zeros(5,2);
std_values = zeros(5,2);
for i=1:5
    tdoa_err=[my_tdoa_errs(i).my_tdoa_err,su_tdoa_errs(i).su_tdoa_err];
    box_line_w=3;
    for j=1:2
        tdoa_e=tdoa_err(:,j);
        q1=quantile(tdoa_e,0.25);
        q3=quantile(tdoa_e,0.75);
        low=q1-1.5*(q3-q1); % filter out outliers
        hig=q3+1.5*(q3-q1);
        tdoa_e=tdoa_e(tdoa_e>low  & tdoa_e<hig);
        mean_values(i,j)=mean(tdoa_e);
        std_values(i,j)=std(tdoa_e);
    end
end
mean_values=round(100000*mean_values,1);
std_values=round(100000*std_values,1);
%% Real-world experiment results under various microphone number (Fig.5a)
load('real1.mat')
mean_values = zeros(4,2);
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=3;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6;
upper_n=10;
for i=1:4
    lens=[];
    my_su_mic1 = real1(i).my_su_err(:,data_id);
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = real1(i).su_err(:,data_id);
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=5;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
mean_values=round(mean_values,3);
% edge color
xTickLabel=["4","6","8","10"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 1.25],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('Mic. number')
ylabel('Loc. err. (m)')
grid on;
%% Real-world experiment results under various initial value noises (Fig.5b)
clear
clc
load('real2.mat')
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=3;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6;
upper_n=2;
for i=1:4
    lens=[];
    my_su_mic1 = real2(i).my_su_err(:,data_id);
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = real2(i).su_err(:,data_id);
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=5;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
xTickLabel=["0","0.5","1","2"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 1.25],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('\sigma_{init}(m)')
ylabel('Loc. err. (m)')
grid on;
%% Real-world experiment results under various TDOA noises (Fig.5c)
clear
clc
load('real3.mat')
colors=[1,0,0,0,0,1];
wid=0.1;
noise_n=4;
ini_p=wid;
n_p=3*wid;
end_p=ini_p+noise_n*n_p;
data_id=6;
upper_n=10;
for i=1:5
    lens=[];
    my_su_mic1 = real3(i).my_su_err(:,data_id);
    my_su_mic1(my_su_mic1>upper_n|isnan(my_su_mic1))=upper_n;
    mics(1:length(my_su_mic1),1)=my_su_mic1;
    lens=[lens,length(my_su_mic1)];
    su_mic1 = real3(i).su_err(:,data_id);
    su_mic1(su_mic1>upper_n|isnan(su_mic1))=upper_n;
    mics(1:length(su_mic1),2)=su_mic1;
    lens=[lens,length(su_mic1)];
    box_line_w=4;
    for j=1:2
        position = ini_p+(j-0.5)*wid:n_p:end_p+(j-0.5)*wid;
        mic_data=mics(1:lens(j),j);
        box = boxplot(mics(1:lens(j),j),'Whisker',1.5,'positions',position(i),'colors',colors(j:2:end),'width',wid,'symbol','+','outliersize',3);
        set(box,'Linewidth',box_line_w);
        set(gca,'yscale','log');
        hold on;
    end
end
xTickLabel=["Case A","Case B","Case C","Case D","Case E"];
set(gca,'XTick', ini_p+1*wid:n_p:end_p+1*wid,'XTickLabel',xTickLabel,'Xlim',[0.05 1.55],'Ylim',[0 upper_n],'TickLabelInterpreter','latex','FontSize',30,'FontWeight','bold');
set(gcf,'unit','normalized','position',[0.2,0.2,0.32,0.48]);
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([2,1]), {'Our Method','[15]'},'location','NorthOutside','orientation','horizontal');
set(hLegend,'FontSize',35);
xlabel('TDOA Noise Cases')
ylabel('Loc. err. (m)')
grid on;