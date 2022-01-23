function config = get_minimum_config(tolerance_limit)
        
    global solutionsFile;
    file=solutionsFile;

    %for testing
    %tolerance_limit=10;

    result= csvread(file);
    sorted_result=sortrows(result,10);
     
    maximum = max(sorted_result(:,10));
    tolerantValue = maximum-tolerance_limit;
    sorted_result= sorted_result(sorted_result(:,10) >= tolerantValue, :);
   
    [row, dcol]= size(sorted_result);
    tables = zeros(row,(dcol+1));
    
    for i=1:row
        x = sorted_result(i,2:4).* sorted_result(i,7:9);
        x=sum(x);
        x=x+ sorted_result(i,1)+sorted_result(i,5)+sorted_result(i,6);
        tables(i,:) = [sorted_result(i,:) x];
    end
    
    minValue = min(tables(:,11));
    minValueRows = find(tables(:,11) == minValue);  
    
    tables=tables(minValueRows,:);    
    tables=sortrows(tables,10);
    
    disp(tables);
    [row,~]=size(tables);
    
    config=tables(row,1:9);

end