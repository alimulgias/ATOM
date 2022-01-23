function config_updated = check_previous_config(config_current, previousConfigFile)
    

    
    global N_conc;
    global Z_think;
    
    tps_threshold=(N_conc/Z_think)*0.05;
    
    global tps_weights;
    y=tps_weights;
    
    try 
        fileID = fopen(previousConfigFile,'r');
        A = fscanf(fileID,'%f');
        fclose(fileID);
        [row, ~]=size(A);
        A=A((row-8):row,:);
        previousConfig=A';
        
        %default init
        config_updated=config_current;
        config_high=config_current;
        config_low=previousConfig;        
        
        [t, ~, ~]=model_solver(previousConfig);
        disp(previousConfig);
        t_previous=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        disp(t_previous);
        
        [t, ~, ~]=model_solver(config_current);
        disp(config_current);
        t_current=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        disp(t_current);
        
        if  t_previous > t_current
            config_updated=previousConfig;
            config_high=previousConfig;
            config_low=config_current;
            t_current=t_previous;
        end
                    
        for i = [1 5 6]
            if config_high(i) > config_low(i)
            
                config_updated(i)=config_low(i);
                disp(config_updated);
            
%                 [t, ~, ~]=model_solver(config_high);
%                 t_high=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
%                 disp(t_high);
            
                [t, ~, ~]=model_solver(config_updated);
                t_updated=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
                disp(t_updated);
           
                if (t_current-t_updated) > tps_threshold
                    config_updated(i)=config_high(i);
                end
                
            end
        end
        
        
        for i = 2:4
            if config_high(i)*config_high(i+5) > config_low(i)*config_low(i+5)
            
                config_updated(i)=config_low(i);
                config_updated(i+5)=config_low(i+5);
                disp(config_updated);
            
%                 [t, ~, ~]=model_solver(config_current);
%                 t_current=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
%                 disp(t_current);
            
                [t, ~, ~]=model_solver(config_updated);
                t_updated=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
                disp(t_updated);
            
                if (t_current-t_updated) > tps_threshold
                    config_updated(i)=config_high(i);
                    config_updated(i+5)=config_high(i+5);
                end
                
            end
        end
                     
    catch
        config_updated=config_current;
    end
end