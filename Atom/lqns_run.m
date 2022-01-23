function [a, b, c] = lqns_run

global modelFile;
global resultFile;
filename=modelFile;
outfile=resultFile;

%lqnsRun;
system(['lqns ', '-a ', '-f ', '-x ', '-o ', outfile,' ', filename]);
%system(['lqns ', '-a ', '-x ', '-o ', outfile,' ', filename]);
%system(['lqns ', '-a ', '-x ', '-o ', outfile,' ', filename]);
%java.lang.Thread.sleep(5000);

tmp=[];

xDoc = xmlread(outfile);

entryTag = xDoc.getElementsByTagName('entry');

for i=0:entryTag.getLength-1
    entryTagName= entryTag.item(i).getAttribute('name');
    if(strcmp(entryTagName,'E2'))
        childNodes=entryTag.item(i).getChildNodes;
        tmp(1)=str2double(childNodes.item(1).getAttribute('throughput'));
    elseif(strcmp(entryTagName,'E3'))
        childNodes=entryTag.item(i).getChildNodes;
        tmp(2)=str2double(childNodes.item(1).getAttribute('throughput'));
    elseif(strcmp(entryTagName,'E4'))
        childNodes=entryTag.item(i).getChildNodes;
        tmp(3)=str2double(childNodes.item(1).getAttribute('throughput'));
    elseif(strcmp(entryTagName,'E1'))
        childNodes=entryTag.item(i).getChildNodes;
        tmp(4)=str2double(childNodes.item(1).getAttribute('throughput'));
    end
end

sum=0;
for i=1:3
    sum=sum+tmp(i);
end
a=zeros(1,4);
for i=1:3
    a(i)=tmp(4)*(tmp(i)/sum);
end
a(4)=tmp(4); % the last throughput is total, represents throughput of edge router
%fprintf('%f %f %f %f\n', a);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%response time

router_pwt=0;
router_demand=0;

activityTag = xDoc.getElementsByTagName('activity');

for i=0:activityTag.getLength-1
    childNodes=activityTag.item(i).getChildNodes;
    node = childNodes.getFirstChild;
    proceed=0;
    while ~isempty(node)
        if strcmpi(node.getNodeName, 'result-activity')
            proceed=1;
            break;
        else
            node = node.getNextSibling;
        end
    end
    if proceed == 1
        activityTagName= activityTag.item(i).getAttribute('name');
        router_demand=str2double(activityTag.item(i).getAttribute('host-demand-mean'));
        if(strcmp(activityTagName,'AS2'))
            router_pwt=str2double(node.getAttribute('proc-waiting'));
            break;
        end
    end
end

router_qt=0;
qt=zeros(1,3);

callTag = xDoc.getElementsByTagName('synch-call');

for i=0:callTag.getLength-1
    childNodes=callTag.item(i).getChildNodes;
    node = childNodes.getFirstChild;
    proceed=0;
    while ~isempty(node)
        if strcmpi(node.getNodeName, 'result-call')
            proceed=1;
            break;
        else
            node = node.getNextSibling;
        end
    end
    if proceed == 1
        callDest= callTag.item(i).getAttribute('dest');
        if(strcmp(callDest,'E1'))
            router_qt=str2double(node.getAttribute('waiting'));
        elseif(strcmp(callDest,'E2'))
            qt(1)=str2double(node.getAttribute('waiting'));
        elseif(strcmp(callDest,'E3'))
            qt(2)=str2double(node.getAttribute('waiting'));
        elseif(strcmp(callDest,'E4'))
            qt(3)=str2double(node.getAttribute('waiting'));
        end
    end
end


entryTag = xDoc.getElementsByTagName('entry');

st=zeros(1,3);

for i=0:entryTag.getLength-1
    childNodes=entryTag.item(i).getChildNodes;
    node = childNodes.getFirstChild;
    proceed=0;
    while ~isempty(node)
        if strcmpi(node.getNodeName, 'result-entry')
            proceed=1;
            break;
        else
            node = node.getNextSibling;
        end
    end
    if proceed == 1
        entryTagName= entryTag.item(i).getAttribute('name');
        if(strcmp(entryTagName,'E2'))
            st(1)=str2double(node.getAttribute('phase1-service-time'));
        elseif(strcmp(entryTagName,'E3'))
            st(2)=str2double(node.getAttribute('phase1-service-time'));
        elseif(strcmp(entryTagName,'E4'))
            st(3)=str2double(node.getAttribute('phase1-service-time'));
        end
    end
end

b=zeros(1,3);
for i=1:3
    b(i)=router_qt+router_pwt+router_demand+qt(i)+st(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%utilization

processorTag = xDoc.getElementsByTagName('result-processor');

util=zeros(1,7);

for i=0:processorTag.getLength-1
    util(i+1)=str2double(processorTag.item(i).getAttribute('utilization'));
end

c=util;

%delete outfile;
%     fid = fopen('replicas_result2.txt', 'a+');
%         fprintf(fid, '%d %d %d\n', a);
%         fclose(fid);
end

