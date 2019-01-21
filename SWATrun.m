%%% Run SWAT - sample model NNM watershed %%%
function SWATrun (dir,sim_n,outlet,n,name)
cd(dir);
global VarName n_sub file_id
n_sub=n;
VarName = {'Flow(cms)';'Org N(kg)';'NO3N(kg)';'NH4N(kg)';'NO2N(kg)';...
    'TN(kg)';'Org P(kg)';'Min P(kg)';'TP(kg)';'Sediment(tons)';...
    'Sol. Pst.(mg/L)';'Sor. Pst.(mg/L)';'Pesticide(mg/L)'};
iVars = [1 10];
start_year = 2017;
n_years = 1;
%%% Uncertainty Analysis Period %%%
UncStartDate = datenum(2017,1,1);
UncEndDate=datenum(2017,12,31);
[x0 par_f bl bu] = tex-tread('parameter_flow_SED.prn','%*d %*s %*s %*s %f %d %f %f',...
    'headerlines',2);
nPars = 24;
par_f = ones(nPars,1);
par_n = (1:nPars)';
x = load(['user_inputs/bestpar_' name '.dat']);
   for iRun = 1:sim_n
    y=x(:,iRun);
     file_id = id_func(n_sub);
     par_alteramalgam_seq(par_n,par_f,y);
    !SWAT_64rel
    for outlet=[outlet]
        model_evaluation(iVars,n_sub,outlet,start_year,n_years);
        copyfile(['sim_daily' num2str(outlet) '.dat'], ['output_SWAT/' name '_sim_daily_' num2str(iRun) '.dat']);
        copyfile(['sim_daily_SED' num2str(outlet) '.dat'], ['output_SWAT/' name '_sim_daily_SED_' num2str(iRun) '.dat']);
    end
   end   
return;
