function util=get_util()    

    global resultFile;
    outfile=resultFile;
    xDoc = xmlread(outfile);

    processorTag = xDoc.getElementsByTagName('result-processor');
    
    util=zeros(1,7);

    for i=0:processorTag.getLength-1
        util(i+1)=str2double(processorTag.item(i).getAttribute('utilization'));
    end
end