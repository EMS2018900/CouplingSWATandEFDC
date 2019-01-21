%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Coupling SWAT and EFDC (09/09/2018 Satbyeol Shin, UF/IFAS ABE)%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;
dirBase = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes';
%%% number of model runs %%%
sim_n=500;
%%% SWAT run for YANG watershed %%%
outletYANG = 3; % no. of subbasin outlet
subbasinYANG = 17; % total no. of subbasin
dirYANG = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes\testYANG';
addpath(genpath(dirYANG));
savepath;
SWATrun(dirYANG,sim_n,outletYANG,subbasinYANG,'YANG');
%%% SWAT run for NNM watershed %%%
outletNNM = 1; % no. of subbasin outlet 
subbasinNNM = 1; % total no. of subbasin
dirNNM = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes\testNNM';
addpath(genpath(dirNNM));
savepath;
SWATrun(dirNNM,sim_n,outletNNM,subbasinNNM,'NNM');
%%% Combine YANG and NNM SWAT outputs %%%
cd(dirBase);
SWAT_combine (dirNNM,sim_n,'NNM')
cd(dirBase);
SWAT_combine (dirYANG,sim_n,'YANG')
%%% SWAT Uncertainty Analysis %%%
sim_days = 365;
cd(dirBase);
SWAT_UA(dirNNM,'NNM',sim_n,sim_days);
cd(dirBase);
SWAT_UA(dirYANG,'YANG',sim_n,sim_days);
%%% EFDC input file preparation %%%
cd(dirBase);
snser_sdser(dirBase,dirNNM,dirYANG,'NNM','YANG',sim_n);
%%% MASA model run for spillway release and irrigation water supply %%%
MASA_run_reservoir_Shin(dirBase,dirNNM,dirYANG,'NNM','YANG',sim_n,sim_days);
%%% qser.inp %%%
qser(dirBase,dirNNM,dirYANG,'NNM','YANG',sim_n);
%%% EFDC run %%%
clc; clear;
core = 4; % number of cores to use
simstart = 1;
simend = 4;
%parpool(core); % parallel computing
increment = (simend-simstart+1)/core;
start_vec = [simstart:increment:simend];
fin_vec = [simstart+increment-1:increment:simend];
%%% Define directory to run EFDC %%%
EFDCrun_base = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes\EFDC_run\base';
outputdir = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes\EFDC_run';
inputdir = 'C:\Users\satbyeol.shin\Desktop\test\coupling_codes\EFDC_run\EFDC_input';
parfor i=1:core
    % Define directories for EFDC simulation (depend on the number of cores)
    base_array(i) = string(['C:\Users\satbyeol.shin\Desktop\test\coupling_codes\EFDC_run\base',num2str(i)]);
    base = char(base_array(i));
    start = start_vec(i);
    fin = fin_vec(i);
    pause_time = 17000; % +4.5hr; 365 days(using 1 core)
    runEFDC_fun(base,outputdir,inputdir,start,fin,pause_time);
end
