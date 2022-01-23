function update_model_init(userload_microservice)

    global callsMeanMapUpdated;
   
    total_user_request=0;
    
    for i=1:length(userload_microservice)
        total_user_request=total_user_request+userload_microservice(i);
    end
    
    %global collectionDuration;
    %duration=collectionDuration;
    
    %update_user_load(total_user_request, duration); %multiplicity of T0
   
    calls_mean_dest={'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9'};%, 'E10', 'E11'}; %databases always remains 1
    calls_mean_value=[0.57 0.29 0.14 0.33 0.34 0.33 0.5 0.5];% 1 1];
    
    calls_mean_value(1)=round(userload_microservice(1)/total_user_request,2);
    calls_mean_value(2)=round((userload_microservice(2)+userload_microservice(3))/total_user_request,2);
    calls_mean_value(3)=round((userload_microservice(4)+userload_microservice(5)+userload_microservice(6))/total_user_request,2);
    
    calls_mean_value(4)=round(userload_microservice(4)/(userload_microservice(4)+userload_microservice(5)+userload_microservice(6)),2);
    calls_mean_value(5)=round(userload_microservice(5)/(userload_microservice(4)+userload_microservice(5)+userload_microservice(6)),2);
    calls_mean_value(6)=round(userload_microservice(6)/(userload_microservice(4)+userload_microservice(5)+userload_microservice(6)),2);

    calls_mean_value(7)=round(userload_microservice(2)/(userload_microservice(2)+userload_microservice(3)),2);
    calls_mean_value(8)=round(userload_microservice(3)/(userload_microservice(2)+userload_microservice(3)),2);

    callsMeanMapUpdated = containers.Map(calls_mean_dest,calls_mean_value);

end
