%%%Mu Controller Design %%%
%Author: Thanushan Ambalavanan (100662304)%
%This simulation example is from MathWorks: https://www.mathworks.com/help/robust/ref/uss.musyn.html#d124e33228%
%Obtained Date:11/15/2022%
%Modified Date:11/15/2022%

clc
close all
format compact %line spacing option
echo on; %Command echoing is useful for debugging or for demonstrations, allowing the commands to be viewed as they execute

%% Nominal Plant %%
G0 = tf([1 2],[1 -1 -20 -30 50]);

%% Uncertainty of Plant %%
Wu = 0.15*tf([1/2 1 3],[1/25 1 2]); 
InputUnc = ultidyn('InputUnc',[1 1]);
G = G0*(1+InputUnc*Wu);

%% Capturing Disturbance Rejection Goal %%
Wp = makeweight(100,[1 0.5],0.15);

%% Constructing the Plant %%
G.InputName = 'u';
G.OutputName = 'y1';
Wp.InputName = 'y';
Wp.OutputName = 'e';
SumD = sumblk('y = y1 + d');
inputs = {'d','u'};
outputs = {'e','y'};
P = connect(G,Wp,SumD,inputs,outputs);

%% Designing Controller K %%
C0 = tunableSS('K',5,1,1);
CL0 = lft(P,C0)
[CL,CLperf,info] = musyn(CL0);

%% Simulating System %%
K = getBlockValue(CL, 'K');
figure(1)
step(K)
xlabel('time (s)')
ylabel('Output of System')
grid
title('Mu Synthesis Step Response','fontsize',16)
legend('Mu Synthesis','fontsize',14)





