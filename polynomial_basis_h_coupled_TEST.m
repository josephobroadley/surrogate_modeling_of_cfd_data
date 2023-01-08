clc
clear
close all
%#ok<*NOPTS>

%% Add Paths

addpath("np_data\","np_data\input_data\","m_functions\","m_memory\")

%% Read Inputs

alpha = readmatrix('alpha_data.txt')

h = readmatrix('h_data.txt')

if size(h,1)==1
    h=ones(size(alpha,1),1)*h
end

m_sep=readmatrix("main_plane_seperation.txt")
s_sep=readmatrix("flap_seperation.txt")

alpha_norm_val=max(alpha)

X=alpha./alpha_norm_val
y=m_sep

%% Inputs
k=size(X,2)
n=size(X,1)

%% Cuttoff Data

sz=size(find(y>=0.5),1)

X(end-sz+2:end,:)=[]
y(end-sz+2:end,:)=[]

%{
X_ref=-flip(X)
y_ref=flip(y)

X_test=[X_ref(1:end-1,1);X]
y_test=[y_ref(1:end-1,1);y]
%}

%% First Polynomial

[BestOrder,Coeff,S,MU]=polynomial(X,y);

%% Finding Boundary

fun = @(xx) polyval(Coeff,xx,S,MU)-0.20

alpha_boundary_norm=fzero(fun,0.4*10)

alpha_boundary=alpha_boundary_norm*alpha_norm_val
% fslove for n dimensions





