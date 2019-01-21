function SWAT_UA(dir,name,sim_n,sim_days)
cd(dir);
flowsimdf = textread(['output_SWAT/combine_' name '_flow.txt']);
sedsimdf = textread(['output_SWAT/combine_' name '_SED.txt']);
flowobsdf = textread(['user_inputs/obs_daily_' name '.csv'],'','delimiter',',','headerlines',1);
sedobsdf = textread(['user_inputs/obs_daily_SED_' name '.csv'],'','delimiter',',','headerlines',1);
flowobs = flowobsdf(:,4);
sedobs = sedobsdf(:,4);
valid = find(flowobs);
for i=1:sim_n
    flowsim = flowsimdf(:,i+2);
    sedsim = sedsimdf(:,i+2);
    % calculate NSE
    flowNSE = (1-sumsqr((flowsim(valid)-flowobs(valid)))/sumsqr(flowobs(valid)-mean(flowobs(valid))));
    sedNSE = (1-sumsqr((sedsim(valid)-sedobs(valid)))/sumsqr(sedobs(valid)-mean(sedobs(valid))));
    % calculate combined NSE
    comNSE(1,i) = flowNSE*sedNSE;
end
for i=1:sim_n
    % calculate weights
    weight(1,i) = comNSE(1,i)/sum(comNSE);
    for j=1:365
    fsim(1:sim_n,j) = flowsimdf(j,3:sim_n+2)';
    ssim(1:sim_n,j) = sedsimdf(j,3:sim_n+2)';
    end
end
for i=1:sim_days
    % sort ascending
    df = fsim(:,i);
    ds = ssim(:,i);
    tempf = [df,weight'];
    temps = [ds,weight'];
    tempf = sortrows(tempf,1);
    temps = sortrows(temps,1);
    % calculate cumulative weights
    cumf = cumsum(tempf(:,2));
    cums = cumsum(temps(:,2));
    % find quantile 0.025. 0.5, 0.975
    [~,idf1] = min(abs(cumf-0.025));
    qf1(i) = tempf(idf1,1);
    [~,idf2] = min(abs(cumf-0.5));
    qf2(i) = tempf(idf2,1);
    [~,idf3] = min(abs(cumf-0.975));
    qf3(i) = tempf(idf3,1);
    [~,ids1] = min(abs(cums-0.025));
    qs1(i) = temps(ids1,1);
    [~,ids2] = min(abs(cums-0.5));
    qs2(i) = temps(ids2,1);
    [~,ids3] = min(abs(cums-0.975));
    qs3(i) = temps(ids3,1);
end
qf = [qf1', qf2', qf3'];
qs = [qs1', qs2', qs3'];
%%% Uncertainty bounds %%%
dlmwrite(['output_SWAT/UA_flow' name '.txt'],qf,'delimiter',' ');
dlmwrite(['output_SWAT/UA_sed' name '.txt'],qs,'delimiter',' ');
