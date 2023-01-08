clc
clear
close all
%#ok<*NOPTS>

%% Add Paths

addpath("np_data\","m_functions\","m_memory\")

%% Read

filename1='vary_alpha_cen_inv_pressures_.txt'  % Mid Flap

%{
alpha = readmatrix('alpha_data.txt')'
h = readmatrix('h_data.txt')'

if size(h,2)==1
    h=ones(1,size(alpha,2))*h
end
%}

[output_m,output_f]=np_h_read(filename1)

%% Top Bottom Split

round(size(output_m,1)/2)

m_up=output_m(1:round(size(output_m,1)/2),:)
m_lo=output_m(round(size(output_m,1)/2):end,:)

f_up=output_f(1:round(size(output_f,1)/2),:)
f_lo=output_f(round(size(output_f,1)/2):end,:)

m_ch=atan((m_lo(end,2)-m_lo(1,2))/(m_lo(end,1)-m_lo(1,1)))
f_ch=atan((f_lo(end,2)-f_lo(1,2))/(f_lo(end,1)-f_lo(1,1)))

m_ch_l=[m_up(1,1),m_up(1,2);m_up(end,1),m_up(end,2)]
f_ch_l=[f_up(1,1),f_up(1,2);f_up(end,1),f_up(end,2)]

figure (1)
hold on
plot(m_up(:,1),m_up(:,2))
plot(m_lo(:,1),m_lo(:,2))
plot(f_up(:,1),f_up(:,2))
plot(f_lo(:,1),f_lo(:,2))
plot(m_up(1,1),m_up(1,2),'ok')
plot(m_up(end,1),m_up(end,2),'ok')
plot(m_ch_l(:,1),m_ch_l(:,2),'k')
plot(f_up(1,1),f_up(1,2),'ok')
plot(f_up(end,1),f_up(end,2),'ok')
plot(f_ch_l(:,1),f_ch_l(:,2),'k')
xlim([-50 400])
ylim([-200 250])
hold off

%% Coordinate Change

m_lo_s=[]
f_lo_s=[]

for i=1:size(m_lo,1)
    m_lo_s(1:2,i)=[cos(-m_ch),-sin(-m_ch);sin(-m_ch),cos(-m_ch)]*m_lo(i,1:2)'
end

for i=1:size(f_lo,1)
    f_lo_s(1:2,i)=[cos(-f_ch),-sin(-f_ch);sin(-f_ch),cos(-f_ch)]*f_lo(i,1:2)'
end

m_lo_s=m_lo_s'
f_lo_s=f_lo_s'

m_lo_s(:,1)=m_lo_s(:,1)-ones(size(m_lo_s,1),1)*m_lo_s(1,1)
f_lo_s(:,1)=f_lo_s(:,1)-ones(size(f_lo_s,1),1)*f_lo_s(1,1)

m_lo=[m_lo_s(:,1:2),m_lo(:,3:end)]
f_lo=[f_lo_s(:,1:2),f_lo(:,3:end)]

figure (2)
plot(m_lo_s(:,1),m_lo_s(:,2))
hold on
plot(f_lo_s(:,1),f_lo_s(:,2))
hold off
xlim([-50 400])
ylim([-200 250])

%% Seperation Test

ct=1

m_sep=[]
f_sep=[]

m_lo
f_lo

for j=3:2:size(m_lo,2)
    for i=round(size(m_lo,1)/2):size(m_lo,1)
        if m_lo(i,j)>=2.6
            m_sep(i,j)=ct;
            ct=ct+1;
        else
            m_sep(i,j)=0;
        end
    end
    ct=1;
end

for j=3:2:size(f_lo,2)
    for i=round(size(f_lo,1)/2):size(f_lo,1)
        if f_lo(i,j)>=2.6
            f_sep(i,j)=ct;
            ct=ct+1;
        else
            f_sep(i,j)=0;
        end
    end
    ct=1;
end

m_sep
f_sep
%% Seperation Percentage Chord

m_sep_per=[]
f_sep_per=[]

m_sep

for i=1:2:size(m_sep,2)
    pos=max(m_sep(:,i));
    m_sep_per(:,ct)=(-m_lo(end-pos,1)+m_lo(end,1))/m_lo(end,1);
    ct=ct+1;
end

ct=1

for i=1:2:size(f_sep,2)
    pos=max(f_sep(:,i));
    f_sep_per(:,ct)=(-f_lo(end-pos,1)+f_lo(end,1))/f_lo(end,1);
    ct=ct+1;
end

m_sep_per=m_sep_per(1,2:end)
f_sep_per=f_sep_per(1,2:end)

%key=["h750 ","h225 ","h150 ","h100 ","h80 ","h70 ","h65 ","h60 ","h55 ","h50 ","h45 ","h40 ","h37 ","h35 ","h32 ","h30 ","h27 ","h25 ","h22 ","h20 ","h17 ","h15";
%    "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22"]



%% Output

writematrix(round(m_sep_per',4),'m_memory/main_plane_seperation')
writematrix(round(f_sep_per',4),'m_memory/flap_seperation')
