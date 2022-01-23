function config_updated = conservative_share (config_current, previousConfigFile)
    
    disp("knob");
    
    share_threshold=0.2;
    
    try 
        fileID = fopen(previousConfigFile,'r');
        A = fscanf(fileID,'%f');
        fclose(fileID);
        [row, ~]=size(A);
        A=A((row-8):row,:);
        previousConfig=A';
        
        previousTotal=previousConfig(1)+sum(previousConfig(2:4).*previousConfig(7:9))+sum(previousConfig(5:6));
        currentTotal=config_current(1)+sum(config_current(2:4).*config_current(7:9))+sum(config_current(5:6));
        
        disp(previousTotal);
        disp(currentTotal);
       
        
        diff=abs(previousTotal-currentTotal);
        pct_change=diff/previousTotal;
        disp(pct_change);
  
        if  pct_change <= share_threshold
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