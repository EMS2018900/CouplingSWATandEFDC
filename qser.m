function qser(dir0,dir1,dir2,name1,name2,sim_n)
%%% read SWAT results & MASA results - flow(CMS) %%%
cd(dir2);
yangf = textread(['output_SWAT/combine_' name1 '_flow.txt'],'');     
cd(dir1);
nnmf = textread(['output_SWAT/combine_' name2 '_flow.txt'],'');       
cd(dir0);
spillf = textread(['EFDC_run/EFDC_input/combine_spillf.txt'],'');   
irrif= textread(['EFDC_run/EFDC_input/combine_irrif.txt'],'');   
spillf = -spillf/3;   % 1st
irrif = -irrif/3;     % 2nd
yangf = yangf/3;      % 3rd
nnmf = nnmf/3;        % 4th
%%% write qser.inp %%%
sim = sim_n;
[row, col] = size(nnmf);
for j=1:sim
    copyfile('EFDC_run/EFDC_input/!qser_header.txt', ['EFDC_run/EFDC_input/qser_' num2str(j) '.inp']);
    fsd = fopen(['EFDC_run/EFDC_input/qser_' num2str(j) '.inp'],'a+');
    % write spillway
fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,0,' '' *** spillwayOUT');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
fprintf(fsd,'%16.4f%16.4f%16.4f',spillf(i,j+2),spillf(i,j+2),spillf(i,j+2));        
    end
    % write irrigation
fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,0,' '' *** irrigationOUT');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
        fprintf(fsd,'%16.4f%16.4f%16.4f',irrif(i,j+2),irrif(i,j+2),irrif(i,j+2));        
    end
    % write yang
fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,0,' '' *** yangIN');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
fprintf(fsd,'%16.4f%16.4f%16.4f',yangf(i,j+2),yangf(i,j+2),yangf(i,j+2));        
    end
    % write nnm
fprintf(fsd,'\r\n%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%8.0f%s',0,row,86400,0,1,0,0,' '' *** nnmIN');
    for i=1:row
        fprintf(fsd,'\r\n%16.0f',i);    
fprintf(fsd,'%16.4f%16.4f%16.4f',nnmf(i,j+2),nnmf(i,j+2),nnmf(i,j+2));        
    end
    fclose(fsd);
end
