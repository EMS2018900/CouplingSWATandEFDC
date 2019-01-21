function runEFDC_fun(base,outputdir,inputdir,start,fin,pause_time)
cd(base); % ...\EFDC_run\base
outbase = outputdir; % ...\EFDC_run
for j=start:fin
    if exist([base '\qser.inp'], 'file')==2
         delete([base '\qser.inp']);
    end
    if exist([base '\sdser.inp'], 'file')==2
         delete([base '\sdser.inp']);
    end
    if exist([base '\snser.inp'], 'file')==2
         delete([base '\snser.inp']);
    end
    copyfile([inputdir '\qser_' num2str(j) '.inp'],[base '\qser.inp']);
    copyfile([inputdir '\sdser_' num2str(j) '.inp'],[base '\sdser.inp']);
    copyfile([inputdir '\snser_' num2str(j) '.inp'],[base '\snser.inp']);
    % EFDC run
    folderName = extractAfter(base,'run\');
    s = strcat('EFDC_DS_',folderName,'.exe &');
    h=system(s);
    pause(pause_time);
    % EFDC window closing; You should change name of the exe file same as the base folder
    % e.g. ~\run\base1\EFDC_DS_base1.exe
    [status1]=system(['"C:\Windows\System32\taskkill.exe" /F /im EFDC_DS_' folderName '.exe /im cmd.exe &']);
    % Water Surace Elevation & Thickness (m) - 1st and 4th col
    copyfile([base '\SURFCON.OUT'],[outbase '\timeseriesOUT\SURFCON_' num2str(j) '.OUT']);
    % Sediment concentration (mg/L) - 2nd col
    % copyfile([base '\SEDCONH.OUT'],[outbase '\timeseriesOUT\SEDCONH\SEDCONH_' num2str(j) '.OUT']);
end
end
