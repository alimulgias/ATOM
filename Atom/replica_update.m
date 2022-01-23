function replica_update(replica)

    %calls_mean_dest={'E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9'};%, 'E10', 'E11'};
    %calls_mean_value=[0.57 0.29 0.14 0.33 0.34 0.33 0.5 0.5];% 1 1];
    %callsMeanMap = containers.Map(calls_mean_dest,calls_mean_value);
     
    %replica=[1 1 1];

    global callsMeanMapUpdated;
    callsMeanMap=callsMeanMapUpdated;
    replica=uint8(replica);
    
    replica=horzcat(1,replica,[1 1]);
    
    global modelFile;
    fileName=modelFile;
    
    xDoc = xmlread(fileName);
    
    processorTag = xDoc.getElementsByTagName('processor');
    for i=0:processorTag.getLength-1
        processorTagName= processorTag.item(i).getAttribute('name');
        %disp(processorTagName);
        if(strcmp(processorTagName,"P2_1"))
            processorTag.item(i).setAttribute('replication',int2str(replica(1)));
        elseif(strcmp(processorTagName,"P2_2"))
            processorTag.item(i).setAttribute('replication',int2str(replica(2)));
        elseif(strcmp(processorTagName,"P2_3"))
            processorTag.item(i).setAttribute('replication',int2str(replica(6)));
        elseif(strcmp(processorTagName,"P3_1"))
            processorTag.item(i).setAttribute('replication',int2str(replica(3)));
        elseif(strcmp(processorTagName,"P3_2"))
            processorTag.item(i).setAttribute('replication',int2str(replica(4)));
        elseif(strcmp(processorTagName,"P3_3"))
            processorTag.item(i).setAttribute('replication',int2str(replica(5)));
        end
    end
    
    
    taskTag = xDoc.getElementsByTagName('task');
    for i=0:taskTag.getLength-1
        taskTagName= taskTag.item(i).getAttribute('name');
        %disp(taskTagName);
        if(strcmp(taskTagName,"T1"))
            taskTag.item(i).setAttribute('replication',int2str(replica(1)));
        elseif(strcmp(taskTagName,"T2"))
            taskTag.item(i).setAttribute('replication',int2str(replica(2)));
        elseif(strcmp(taskTagName,"T3"))
            taskTag.item(i).setAttribute('replication',int2str(replica(3)));
        elseif(strcmp(taskTagName,"T4"))
            taskTag.item(i).setAttribute('replication',int2str(replica(4)));
        elseif(strcmp(taskTagName,"T5"))
            taskTag.item(i).setAttribute('replication',int2str(replica(5)));
        elseif(strcmp(taskTagName,"T6"))
            taskTag.item(i).setAttribute('replication',int2str(replica(6)));
        end
    end    
    
    sourceTag = xDoc.getElementsByTagName('fan-in');
    for i=0:sourceTag.getLength-1
        source= sourceTag.item(i).getAttribute('source');
        %disp(source);
        if(strcmp(source,"T1"))
           sourceTag.item(i).setAttribute('value',int2str(replica(1)));
        elseif(strcmp(source,"T2"))
           sourceTag.item(i).setAttribute('value',int2str(replica(2)));
        elseif(strcmp(source,"T3"))
           sourceTag.item(i).setAttribute('value',int2str(replica(3)));
        elseif(strcmp(source,"T4"))
           sourceTag.item(i).setAttribute('value',int2str(replica(4)));
        end
    end
    
    destTag = xDoc.getElementsByTagName('fan-out');
    for i=0:destTag.getLength-1
        dest= destTag.item(i).getAttribute('dest');
        %disp(dest);
        if(strcmp(dest,"T2"))
           destTag.item(i).setAttribute('value',int2str(replica(2)));
        elseif(strcmp(dest,"T3"))
           destTag.item(i).setAttribute('value',int2str(replica(3)));
        elseif(strcmp(dest,"T4"))
           destTag.item(i).setAttribute('value',int2str(replica(4)));
        elseif(strcmp(dest,"T5"))
           destTag.item(i).setAttribute('value',int2str(replica(5)));
        elseif(strcmp(dest,"T6"))
           destTag.item(i).setAttribute('value',int2str(replica(6)));
        end
    end
    replica=double(replica);
    synchCallTag = xDoc.getElementsByTagName('synch-call');
    for i=0:synchCallTag.getLength-1
        synchCallTagDest= synchCallTag.item(i).getAttribute('dest');
        if(strcmp(synchCallTagDest,'E2')||strcmp(synchCallTagDest,'E3')||strcmp(synchCallTagDest,'E4'))
            value=callsMeanMap(synchCallTagDest.char());
            value=value/replica(2);%right dest replica of T1. wrong - (fanin of E2s Task)*(replica of E2s Task)
            synchCallTag.item(i).setAttribute('calls-mean', num2str(value));
        elseif(strcmp(synchCallTagDest,'E5')||strcmp(synchCallTagDest,'E6')||strcmp(synchCallTagDest,'E7'))
            value=callsMeanMap(synchCallTagDest.char());
            value=value/replica(3);
         synchCallTag.item(i).setAttribute('calls-mean', num2str(value));
         elseif(strcmp(synchCallTagDest,'E8')||strcmp(synchCallTagDest,'E9'))
            value=callsMeanMap(synchCallTagDest.char());
            value=value/replica(4);
         synchCallTag.item(i).setAttribute('calls-mean', num2str(value));
%          elseif(strcmp(synchCallTagDest,'E10'))
%             value=callsMeanMap(synchCallTagDest.char());
%             value=value/(replica(4)*replica(5));
%          synchCallTag.item(i).setAttribute('calls-mean', num2str(value));        
%          elseif(strcmp(synchCallTagDest,'E11'))
%             value=callsMeanMap(synchCallTagDest.char());
%             value=value/(replica(3)*replica(6));
%          synchCallTag.item(i).setAttribute('calls-mean', num2str(value));
        end
    end
    
    xmlwrite(fileName,xDoc);
    
end