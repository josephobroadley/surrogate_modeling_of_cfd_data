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

Cl=np_force_read("vary_alpha_forces.csv");
Cl=table2array(Cl);
Cl=Cl(:,2:3)

alpha_boundary_norm=0.4003

%% Plot
figure (1)
plot(alpha,Cl(:,1))
hold on
plot(alpha,Cl(:,2),'o')
set(gca,'Ydir','reverse')
hold off

%% Inputs
transfer.alpha_norm_val=max(alpha)
transfer.Cl_norm_val=max(-Cl(:,2))
alpha_norm_val=max(alpha)
Cl_norm_val=max(-Cl(:,2))

X=alpha./alpha_norm_val
y=-Cl(:,2)./Cl_norm_val

k=size(X,2)
n=size(X,1)

%% First Polynomial
X
y
[BestOrder,Coeff,S,MU]=polynomial_Cl(X,-y);


[solution,objectiveValue] = fmincon(@(xx) polyval(Coeff,xx,S,MU),0.5,[],[],[],[],[0,0],[alpha_boundary_norm,1],[])

hold on
%plot([alpha_boundary_norm*alpha_norm_val alpha_boundary_norm*alpha_norm_val],[-3 -1],'k--')
%plot(solution*alpha_norm_val,objectiveValue*Cl_norm_val,'ok',LineWidth=2)
ylabel('C_L   ',Rotation=0,VerticalAlignment='middle')
xlim([0 25])
ylim([-3 -1])
max_alpha=solution*alpha_norm_val

Max_Cl=objectiveValue*Cl_norm_val

BestOrder