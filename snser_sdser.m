function snser_sdser(dir0,dir1,dir2,name1,name2,sim_n)
%%% read SWAT results - flow and sediment %%%
cd(dir1);
nnmf = textread(['output_SWAT/combine_' name1 '_flow.txt'],'');
nnms = textread(['output_SWAT/combine_' name1 '_SED.txt'],'');
cd(dir2);
yangf = textread(['output_SWAT/combine_' name2 '_flow.txt'],'');
yangs = textread(['output_SWAT/combine_' name2 '_SED.txt'],'');
%%% tss = mg/L [sed(tons)*10^9]/[flow(cms)*86400*10^3] %%%
nnms = nnms*(10^9);
nnmf = nnmf*86400*(10^3);
nnmtss = nnms./nnmf;
nnmtss(isnan(nnmtss)) = 0;
yangs = yangs*(10^9);
yangf = (yangf*86400*(10^3)).^(-1);
yangtss = yangs.*yangf;
yangtss(isnan(yangtss)) = 0;
%%% SS concentration fraction %%%
n_silt_f = 0.490;
n_sand_f = 0.510;
y_silt_f = 0.642;
y_sand_f = 0.358;
%%% tss -> silt & sand %%%
nnmsilt = nnmtss*n_silt_f;      % 2nd series
nnmsand = nnmtss*n_sand_f;      % 2nd series
yangsilt = yangtss*y_silt_f;    % 1st series
yangsand = yangtss*y_sand_f;    % 1st series
%%% write sdser.inp (silt) %%%
cd(dir0);
sim = sim_n;
[row, col] = size(nnmsilt);
for j=1:sim
    copyfile('EFDC_run\EFDC_input\!sdser_header.txt', ['EFDC_run\EFDC_input\sdser_' num2str(j) '.inp']);
    fsd = fopen(['EFDC_run\EFDC_input\sdser_' num2str(j) '.inp'],'a+');
    % write nnmsilt
    fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,' '' *** yangsilt');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
        fprintf(fsd,'%16.4f%16.4f%16.4f',yangsilt(i,j+2),yangsilt(i,j+2),yangsilt(i,j+2));        
    end
    % write yangsilt
    fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,' '' *** nnmsilt');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
fprintf(fsd,'%16.4f%16.4f%16.4f',nnmsilt(i,j+2),nnmsilt(i,j+2),nnmsilt(i,j+2));
    end
    fclose(fsd);
end
%%% write snser.inp (sand) %%%
[row, col] = size(nnmsand);
for j=1:sim
    copyfile('EFDC_run\EFDC_input\!snser_header.txt', ['EFDC_run\EFDC_input\snser_' num2str(j) '.inp']);
    fsn = fopen(['EFDC_run\EFDC_input\snser_' num2str(j) '.inp'],'a+');
    % write nnmsand
    fprintf(fsn,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,' '' *** yangsand');
    for i=1:row
        fprintf(fsn,'\r\n%16.0f',i);    
        fprintf(fsn,'%16.4f%16.4f%16.4f',yangsand(i,j+2),yangsand(i,j+2),yangsand(i,j+2));        
    end
    % write yangsand
    fprintf(fsn,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,' '' *** nnmsand');
    for i=1:row
        fprintf(fsn,'\r\n%16.0f',i);    
fprintf(fsn,'%16.4f%16.4f%16.4f',nnmsand(i,j+2),nnmsand(i,j+2),nnmsand(i,j+2));
    end
    fclose(fsn);
end
