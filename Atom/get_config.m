function config = get_config
    
    global solutionsFile;
    file=solutionsFile;

    result= csvread(file);
    sorted_result=sortrows(result,10);
    [row,~]=size(sorted_result);
    config=sorted_result(row,1:9);
end