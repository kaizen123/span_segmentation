function generate_pbs_from_file_full(pbsBaseFolderName, scriptName, segmentFile, firstLine, lastLine, frameRate, templateFileName, coilSensitivityFile, hpcFolder)
lineCount = 0;

bashFileName = sprintf('%s/%s.sh', pbsBaseFolderName, scriptName);
 
fid = fopen(segmentFile);
fidout = fopen(bashFileName,'w');
fprintf(fidout, '#!/bin/bash\n');

while lineCount<firstLine - 1
    
    fgetl(fid);
    lineCount = lineCount + 1;
    
end;

while lineCount<lastLine
    
    str = fgetl(fid);
    celldata = textscan(str,'%s','Delimiter',',');
    strdata = celldata{1};
    videoFileName = char(strdata(1));
    pbsCoreFolderName = char(strdata(2));
    outFileName = pbsCoreFolderName;
    
    
    generate_pbs(pbsBaseFolderName, pbsCoreFolderName, videoFileName,...
        [], templateFileName, outFileName,...
        coilSensitivityFile, hpcFolder);
    
    fprintf(fidout, 'qsub -A lc_sn %s/pbs; sleep 5\n',pbsCoreFolderName);
    
    lineCount = lineCount + 1;
    
end;

fclose(fid);
fclose(fidout);



