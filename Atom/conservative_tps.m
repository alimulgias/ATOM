function config_updated = conservative_tps (config_current, previousConfigFile)
    
    disp("knob");

    global N_conc;
    global Z_think;
    
    tps_threshold=(N_conc/Z_think)*0.2;
    
    global tps_weights;
    y=tps_weights;
    
    try 
        fileID = fopen(previousConfigFile,'r');
        A = fscanf(fileID,'%f');
        fclose(fileID);
        [row, ~]=size(A);
        A=A((row-8):row,:);
        previousConfig=A';
        
        [t, ~, ~]=model_solver(previousConfig);
        disp(previousConfig);
        t_previous=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        disp(t_previous);
        
        [t, ~, ~]=model_solver(config_current);
        disp(config_current);
        t_current=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        disp(t_current);
        
        if  (t_current-t_previous) >= tps_threshold
            config_updated=config_current;
            total_cpu=config_updated(1)+sum(config_updated(2:4).*config_updated(7:9))+sum(config_updated(5:6));
            disp("Current selected");
            disp(total_cpu);
        else
            config_updated=previousConfig;
            total_cpu=config_updated(1)+sum(config_updated(2:4).*config_updated(7:9))+sum(config_updated(5:6));
            disp("Previous selected");
            disp(total_cpu);
        end
        
    catch
        config_updated=config_current;
        total_cpu=config_updated(1)+sum(config_updated(2:4).*config_updated(7:9))+sum(config_updated(5:6));
        disp("Current selected");
        disp(total_cpu);
    end
end