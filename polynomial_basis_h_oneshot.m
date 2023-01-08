clc
clear
close all
%#ok<*NOPTS>

%% Add Paths

addpath("np_data\","np_data\input_data\","m_functions\","m_memory\")

%% Read Inputs

global transfer

alpha = readmatrix('alpha_data.txt')

h = readmatrix('h_data.txt')

if size(h,1)==1
    h=ones(size(alpha,1),1)*h
end

m_sep=readmatrix("main_plane_seperation.txt")
s_sep=readmatrix("flap_seperation.txt")

transfer.alpha_norm_val=max(alpha)

alpha_norm_val=transfer.alpha_norm_val

X=alpha./alpha_norm_val
y=m_sep

%% Inputs
k=size(X,2)
n=size(X,1)

%% Cuttoff Data

sz=size(find(y>=0.5),1)

restX=X(end-sz+2:end,:)
resty=y(end-sz+2:end,:)

X(end-sz+2:end,:)=[]
y(end-sz+2:end,:)=[]
%% First Polynomial

[BestOrder,Coeff,S,MU]=polynomial(X,y);
hold on
%plot(9.6083,13,'ok',LineWidth=2)
%plot([0 16],[13 13],'k--')
ylabel('S (%)');
xlim([0 16])
xticks([0 4 8 12 16])
%plot(restX*alpha_norm_val,resty*100,'*k')
hold off
%% Finding Boundary

fun = @(xx) polyval(Coeff,xx,S,MU)-0.13

alpha_boundary_norm=fzero(fun,0.4)

alpha_boundary=alpha_boundary_norm*alpha_norm_val
% fslove for n dimensions

BestOrder
%% Nice Output




