function demand_update(cpu_share)
    
%     demand_activity={'AS2', 'AH2', 'AH4', 'AH6', 'AH8', 'AH10', 'AH12', 'AS4', 'AS6', 'AH14', 'AH16'};
%     %demand_value_old=[0.001 0.0017 0.003 0.0041 0.0048 0.0056 0.0174 0.0022 0.0019 0.0009 0.0076];
%     demand_value=[0.001 0.0017 0.003 0.0041 0.0048 0.0174 0.0056 0.0022 0.0019 0.0014 0.0041];
%     demandMap = containers.Map(demand_activity,demand_value);
%      
%     cpu_share=[1.0 0.4 1.0 1.0 1.0 1.0];
%     cpu_share=[0.6 1.0 1.0 1.0 0.8 0.4];
    
    global demandMapUpdated;
    demandMap=demandMapUpdated;
    
    global modelFile;
    fileName=modelFile;
    
    xDoc = xmlread(fileName);

    activityTag = xDoc.getElementsByTagName('activity');
    for i=0:activityTag.getLength-1
        activityTagName= activityTag.item(i).getAttribute('name');
        %disp(taskTagName);
        if(strcmp(activityTagName,"AS2"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(1);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));
        elseif(strcmp(activityTagName,"AH2")||strcmp(activityTagName,"AH4")||strcmp(activityTagName,"AH6"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(2);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));
        elseif(strcmp(activityTagName,"AH8")||strcmp(activityTagName,"AH10")||strcmp(activityTagName,"AH12"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(3);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));
        elseif(strcmp(activityTagName,"AS4")||strcmp(activityTagName,"AS6"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(4);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));
        elseif(strcmp(activityTagName,"AH14"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(5);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));
        elseif(strcmp(activityTagName,"AH16"))
            value=demandMap(activityTagName.char());
            value=value/cpu_share(6);
            activityTag.item(i).setAttribute('host-demand-mean',num2str(value));    
        end
    end
    
    xmlwrite(fileName,xDoc);

end