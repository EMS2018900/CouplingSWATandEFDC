function SWAT_combine (dir,sim_n,name)
for i=1:sim_n
    cd(dir);
    df1 = textread(['output_SWAT/' name '_sim_daily_' num2str(i) '.dat'],'','headerlines',1);
    df2 = textread(['output_SWAT/' name '_sim_daily_SED_' num2str(i) '.dat'],'','headerlines',1);
    df1_f = df1(:,3);
    df2_f = df2(:,3);
    dcombine1(:,1:2) = df1(:,1:2);
    dcombine1(:,i+2) = df1_f;
    dcombine2(:,1:2) = df2(:,1:2);
    dcombine2(:,i+2) = df2_f;
end
dlmwrite(['output_SWAT/combine_' name '_flow.txt'],dcombine1,'delimiter',' ');
dlmwrite(['output_SWAT/combine_' name '_SED.txt'],dcombine2,'delimiter',' ');




