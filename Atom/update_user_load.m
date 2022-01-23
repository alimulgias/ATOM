function update_user_load(concurrent_load)
%function update_user_load(user_load, duration)

    global modelFile;
    fileName=modelFile;
    
%     X=user_load/duration;
%     R=1;
%     Z=7;
%     N=X*(R+Z);
%     
%     concurrent_load=uint32(N);
%     
%     disp(concurrent_load);
    
    %user_load=uint32(user_load);
    xDoc = xmlread(fileName);
    
    taskTag = xDoc.getElementsByTagName('task');
    for i=0:taskTag.getLength-1
        activityTagName= taskTag.item(i).getAttribute('name');
        %disp(taskTagName);
        if(strcmp(activityTagName,"T0"))
            taskTag.item(i).setAttribute('multiplicity',int2str(concurrent_load));
        end
    end
    xmlwrite(fileName,xDoc);
end