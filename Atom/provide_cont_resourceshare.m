function config = provide_cont_resourceshare (current_load)
    
    global demandMapUpdated;
    global activityEntryMap;
    global tps_weights;
    %global collectionDuration;
    %global cpu_share_unit;
    global N_conc;
    global Z_think;   
   
    global modelFile;
    global resultFile;
    global solutionsFile;
    global NFile;
%     global backupResultsDir;
%     global backupResultsFile;

    modelFile = 'path-to-atom\sockshop-line-opt.lqnx';
    resultFile = 'path-to-atom\sockshop-result.xml';
    solutionsFile ='path-to-atom\sockshop-agg-result.dat';
    NFile='path-to-atom\conc-user.in';
    
    %cpu_share_unit=0.2;
    %collectionDuration=30; % change for burst load
    
    fileID = fopen(NFile,'r');
    N_conc = fscanf(fileID,'%d');
    fclose(fileID);
    update_user_load(N_conc);
    
    
    Z_think=7.0; %7 for normal 0.875 for burstiness considering front-end bottleneck
    
    tps_weights=[1 1 1]; 
    
    
    previousConfigFile='path-to-atom\previous-config.txt';
    previousWorkloadFile='path-to-atom\previous-workload.txt';
    
    backupResultsDir='path-to-atom';
    backupResultsFile='sockshop-agg-result-';
    
    activities={'AS2', 'AH2', 'AH4', 'AH6', 'AH8', 'AH10', 'AH12', 'AS4', 'AS6', 'AH14', 'AH16'};
    entries={'E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9', 'E10', 'E11'};
    activityEntryMap=containers.Map(activities,entries);
    
    demand_activity={'AS2', 'AH2', 'AH4', 'AH6', 'AH8', 'AH10', 'AH12', 'AS4', 'AS6', 'AH14', 'AH16'};
    %demand_value=[0.001 0.0017 0.003 0.0041 0.0048 0.0174 0.0056 0.0022 0.0019 0.0014 0.0041];
    %demand_value=[0.001 0.0017 0.003 0.0041 0.0023 0.00937 0.0026 0.0022 0.0019 0.0014 0.0019];
    %demand_value_ordering_old_or_browsing=[0.0012 0.0021 0.0037 0.0051 0.0048 0.0174 0.0056 0.0022 0.0019 0.0013 0.0022];    
    %demand_value_ordering=[0.0012 0.0021 0.0037 0.0051 0.0022 0.0092 0.0025 0.0022 0.0019 0.0013 0.0022];    
    %demand_value_shopping=[0.0012 0.0021 0.0037 0.0051 0.0022 0.0092 0.0025 0.0022 0.0019 0.0013 0.0022];    
    demand_value=[0.0012 0.0021 0.0037 0.0051 0.0022 0.0092 0.0025 0.0022 0.0019 0.0013 0.0022];    
    demandMapUpdated =containers.Map(demand_activity,demand_value);

    %current_load= [14100 3420 3400 1260 1202 1290];%3000
    %current_load= [9305 2260 2245 830 820 860];%2000
    %current_load= [18800 4570 4540 1680 1642 1680];
    %current_load= [3524 960 912 118 131 114];
    %current_load= [13100 2420 2400 1860 1802 1890];%3000
    
    %good for continuous monitoring check
    %current_load= [396 108 101 203 194 207];
    %current_load= [2572 706 670 203 194 207];
    %current_load= [2572 706 670 1319 1280 1340];

    %current_load= [396 108 101 203 194 207];
    %current_load= [630 161 161 16 16 16];
    %current_load= [53 13 13 7 7 7];
    %current_load= [330 86 86 166 166 166];

    
    %for testing
    %userload_microservice=current_load;

    %for runtime
    userload_microservice=mean(current_load);
    
    fileID = fopen(previousWorkloadFile,'a');
    fprintf(fileID,'%d\n',uint32(userload_microservice));
    fclose(fileID);
        
    %check total is updated or not
    update_model_init(userload_microservice);

        
    %init_pop=[];
    %init_pop=load_init_pop(previousConfigFile);
    init_pop=load_previous_config(previousConfigFile);

        
    ga_optimize_cont(init_pop);
    %ga_optimize_cont();
        
    config=get_config;
    %fault_tolerance=0;
    %config=get_minimum_config(fault_tolerance);
      
    total_cpu=config(1)+sum(config(2:4).*config(7:9))+sum(config(5:6));
    disp(total_cpu);
      
    config=check_previous_config(config, previousConfigFile);
    
    config=replica_reduce(config);
       
    total_cpu=config(1)+sum(config(2:4).*config(7:9))+sum(config(5:6));
    disp(total_cpu);
       
    %knob 
    %config=conservative_tps (config, previousConfigFile);
    %config=conservative_share (config, previousConfigFile);
    
    
    fileID = fopen(previousConfigFile,'a');
    fprintf(fileID,'%f\n',config);
    fclose(fileID);
        
    backupResultsFile=strcat(backupResultsFile,datestr(datetime('now')));
    backupResultsFile=strcat(backupResultsFile,'.csv');
    backupResultsFile=strrep(backupResultsFile,':','-');
    backupResultsFile=strrep(backupResultsFile,' ','-');
    backupResultsFile=strcat(backupResultsDir,backupResultsFile);
    movefile(solutionsFile, backupResultsFile);
     
    %for scaler experiment only. remove it for burstiness experiment
    init_clean();
    
                
        
    %else
    %    config=zeros(1,9);
    %end

end
