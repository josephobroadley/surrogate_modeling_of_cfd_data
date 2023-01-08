%% 1D test Function Kriging Surrogate Modling Optimizing

clc
clear
close all
%#ok<*NOPTS>

%% Add Paths

addpath("np_data\","np_data\input_data\","m_functions\","m_memory\")

%% Asign Global Variable
global ModelInfo

%% Read Inputs

alpha = readmatrix('alpha_data.txt')

h = readmatrix('h_data.txt')

if size(h,1)==1
    h=ones(size(alpha,1),1)*h
end

m_sep=readmatrix("main_plane_seperation.txt")
s_sep=readmatrix("flap_seperation.txt")

ModelInfo.X=alpha./max(alpha)
ModelInfo.y=m_sep

alpha_norm_val=max(alpha)

%% Inputs
k=size(ModelInfo.X,2)
n=size(ModelInfo.X,1)

%% First Kriging

% Tune Kriging model of objective
options=optimoptions('ga','PopulationSize',100);
[ModelInfo.Theta,MaxLikelihood]=ga(@likelihood,k,[],[],[],[],ones(1,k).*-1,ones(1,k).*2,[],options);

% Put Cholesky factorization of Psi into ModelInfo
[NegLnLike,ModelInfo.Psi,ModelInfo.U]=likelihood(ModelInfo.Theta);

x=(0:0.01:1)'

f_pred=zeros(size(x,1),1);

for i=1:size(x,1)
    f_pred(i,1)=pred(x(i,1));
end

%% First Plot

figure(1)
plot(ModelInfo.X,ModelInfo.y,'ob')
hold on
plot(x,f_pred,'b-')
hold off
ylim([0 1])
title('Main Plane Seperation of Lower Surface')
xlabel('Normalised \alpha (0\circ - 24\circ)')
ylabel('Fraction Seperated')

%% Finding Boundary

fun = @(xx) pred(xx)-0.135

alpha_boundary_norm=fzero(fun,0.4)

alpha_boundary=alpha_boundary_norm*alpha_norm_val
% fslove for n dimensions





