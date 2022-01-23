function init_pop = load_init_pop(previousConfigFile)

    
    global solutionsFile;
    global backupResultsDir;
    global backupResultsFile;
    backupResultsFileTmp=backupResultsFile;
    
    try
    data= csvread(solutionsFile);
    
    all_data = data(:,1:10);
    %all_data(:,1:6)=all_data(:,1:6)./share;
    unique_data=unique(all_data,'rows','stable');
%     unique_data(:,1:6)=unique_data(:,1:6)./share;
    
    
    sorted_result=sortrows(unique_data,-10);


    init_pop=sorted_result(1,1:9);
    %init_score=sorted_result(1,10);
    
    fileID = fopen(previousConfigFile,'r');
    A = fscanf(fileID,'%f');
    fclose(fileID);
    [row, ~]=size(A);
    A=A((row-8):row,:);
    previousConfig=A';

    init_pop=vertcat(init_pop,previousConfig);
    init_pop=unique(init_pop,'rows','stable');

    
    backupResultsFileTmp=strcat(backupResultsFileTmp,datestr(datetime('now')));
    backupResultsFileTmp=strcat(backupResultsFileTmp,'.csv');
    backupResultsFileTmp=strrep(backupResultsFileTmp,':','-');
    backupResultsFileTmp=strrep(backupResultsFileTmp,' ','-');
    backupResultsFileTmp=strcat(backupResultsDir,backupResultsFileTmp);
    movefile(solutionsFile, backupResultsFileTmp);
    catch
        init_pop=[];
        %init_score=[];
    end
end