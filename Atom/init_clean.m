
currentDir='path-to-atom';
fileExtension1='*.txt';
fileExtension1=strcat(currentDir,fileExtension1);
fileExtension2='*.csv';
fileExtension2=strcat(currentDir,fileExtension2);
newdir='path-to-tmpFolder';
N=500;

global NFile;

conc_file=NFile;

counterFile='path-to-atom\counter.in';
fileID = fopen(counterFile,'r');
counter = fscanf(fileID,'%d');
fclose(fileID);

counter=counter+1;
fileID = fopen(counterFile,'w');
fprintf(fileID,'%d',counter);
fclose(fileID);

% 6 for normal,7 (or 6 if started 2 min later) for 2min, 2 for 10 min
if counter==6
    update_user_load(N);
    fileID = fopen(conc_file,'w');
    fprintf(fileID,'%d',N);
    fclose(fileID);
    movefile(fileExtension1, newdir);
    movefile(fileExtension2, newdir);
end