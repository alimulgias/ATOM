function init_pop = load_previous_config(previousConfigFile)
    
    try
    fileID = fopen(previousConfigFile,'r');
    A = fscanf(fileID,'%f');
    fclose(fileID);
    [row, ~]=size(A);
    A=A((row-8):row,:);
    init_pop=A';
    catch
        init_pop=[];
    end
end