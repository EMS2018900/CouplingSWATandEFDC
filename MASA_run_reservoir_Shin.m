function MASA_run_reservoir_Shin(dir0,dir1,dir2,name1,name2,sim_n,sim_days)
%%% read SWAT results - flow(CMS) %%%
cd(dir1);
nnmf = textread(['output_SWAT/combine_' name1 '_flow.txt'],'');
cd(dir2);
yangf = textread(['output_SWAT/combine_' name2 '_flow.txt'],'');
cd(dir0);
load('MASA_input_2017.mat');
%%% flow unit change (SWAT:cms -> MASA:mm/d) %%%
MASA_inputf = (nnmf + yangf)/((5.681+1.054)*1000000)*3600*24*1000;
spillf = [sim_days sim_n+2];
irrif = [sim_days sim_n+2];
spillf(1:sim_days,1:2)=nnmf(:,1:2);
irrif(1:sim_days,1:2)=nnmf(:,1:2);
for j=1:sim_n
    j;
    % SWAT output -> MASA input
    Swat=MASA_inputf(:,j+2);
    option.SrcWorkspace = 'current'; 
    result=sim('MASA_RES_FOR_IJ.slx',option);
    out_res_stage_m_time=get(result,'out_res_stage_m');
    out_res_stage_m=out_res_stage_m_time.data;
    out_res_stage_m(1)=[];
    % MASA output (m3/day)
    spill_d = result.out_res_limit_m3+result.out_res_pool_m3;
    irri_d = result.out_res_supply_m3;
    % convert time sereis data to matrix
    spilltemp = spill_d.data;
    spilltemp(1,:) = []; % delete the first row
    irritemp = irri_d.data;
    irritemp(1,:) = []; % delete the first row
    % Unit chnage (m3/day -> m3/s)
    spillf(1:sim_days,j+2) = spilltemp/86400;
    irrif(1:sim_days,j+2) = irritemp/86400;
end
dlmwrite('EFDC_run/EFDC_input/combine_spillf.txt',spillf,'delimiter',' ');
dlmwrite('EFDC_run/EFDC_input/combine_irrif.txt',irrif,'delimiter',' ');
