function config_updated = replica_reduce(config_current)
    
    disp("replica reduce");
    %tps_threshold=10;
    
    global N_conc;
    global Z_think;
    
    tps_threshold=(N_conc/Z_think)*0.05;
    
    global tps_weights;
    y=tps_weights;
    
    [t, ~, ~]=model_solver(config_current);
    disp(config_current);
    t_current=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
    disp(t_current);
    
    config_updated=config_current;
    
    for i = 2:4
        cpu_share=config_current(i)*config_current(i+5);
        if cpu_share < 1
            config_updated(i)=cpu_share;
            config_updated(i+5)=1;
        elseif cpu_share < 2
            config_updated(i)=cpu_share/2;
            config_updated(i+5)=2;
        elseif cpu_share < 3
            config_updated(i)=cpu_share/3;
            config_updated(i+5)=3;
        end
        
        [t, ~, ~]=model_solver(config_updated);
        disp(config_updated);
        t_updated=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        disp(t_updated);
        
        if (t_current-t_updated) > tps_threshold
            config_updated(i)=config_current(i);
            config_updated(i+5)=config_current(i+5);
        end
        
    end
    
end