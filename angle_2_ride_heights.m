clc
clear
close all
%#ok<*NOPTS>

%% Add Paths

addpath("np_data\","np_data\input_data\","m_functions\","m_memory\")

%% Variable Inputs

alpha = readmatrix('alpha_data.txt')'
h = readmatrix('h_data.txt')'

if size(h,2)==1
    h=ones(1,size(alpha,2))*h
end

%% Fixed Inputs
faxle=150;
raxle=3000;

%% Calc

axleheight=[];
for i=1:size(alpha,2)
    axleheight(i,1)=faxle*tan(deg2rad(alpha(i)))+h(i);
    axleheight(i,2)=(raxle-faxle)*tan(deg2rad(alpha(i)))+axleheight(i,1);
end
disp('   fheight   rheight')
disp(axleheight)
%% Plot

it_plot=10;

figure (1)
plot([faxle,faxle],[0,axleheight(it_plot,1)],'k')
hold on
plot([raxle,raxle],[0,axleheight(it_plot,2)],'k')
plot([0,0],[0,h(it_plot)],'k')
plot([0,20],[h(it_plot),h(it_plot)],'k')
plot([0,raxle],[h(it_plot),axleheight(it_plot,2)],'k')
xlim([-10 raxle+10])
ylim([h(it_plot)-20 axleheight(it_plot,2)+20])
hold off

%% Write Run File
spaces1000="    "
spaces100="     "
spaces10="      "

for i=1:size(axleheight,1)
    if axleheight(i,1)>=1000
        front_=strcat(spaces1000,num2str(round(axleheight(i,1),7,'significant'),'%04.3f'))
    elseif axleheight(i,1)>=100
        front_=strcat(spaces100,num2str(round(axleheight(i,1),6,'significant'),'%03.3f'))
    else
        front_=strcat(spaces10,num2str(round(axleheight(i,1),5,'significant'),'%02.3f'))
    end
    
    if axleheight(i,2)>=1000
        rear_=strcat(spaces1000,num2str(round(axleheight(i,2),7,'significant'),'%04.3f'))
    elseif axleheight(i,2)>=100
        rear_=strcat(spaces100,num2str(round(axleheight(i,2),6,'significant'),'%03.3f'))
    else
        rear_=strcat(spaces10,num2str(round(axleheight(i,2),5,'significant'),'%02.3f'))
    end

    writeheights(i,1)=strcat(front_,rear_,spaces100,"0")
end
n=size(axleheight,1)

writeheights=["    2    2";strcat("    ",num2str(n));writeheights]
writematrix(writeheights,'m_memory/run_file')






