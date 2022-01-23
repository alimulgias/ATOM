function ga_optimize_cont(init_pop)

% if max(size(gcp)) == 0 % parallel pool needed
%     parpool % create the parallel pool
% end



fprintf('Program starts at %s\n', datestr(now,'HH:MM:SS.FFF'));
%% number of variables
n = 9;
WMAX=[1 1 1];
cmax_1=4;
cmax_2=4;

max_util=0.9;

global N_conc;
global Z_think;

tps_max=N_conc/Z_think;
%u_min=4.8;

%edge, front, carts, catalog, catalog-db, carts-db
% memory_units=[1 1 3 1 0.5 1];
% mmax_1=62.0;
% mmax_2=15.0;

%global cpu_share_unit;
share_unit=1;

global tps_weights;
y=tps_weights;

cacheFitness=containers.Map('KeyType','char','ValueType','char');

% first six shares edge, front, carts, catalog, catalog-db, carts-db

XLB = [0.01 0.01 0.01 0.01 0.01 0.01 1 1 1]; % lower bounds on x variables
XUB = [1 1 1 1 1 1 3 3 3]; % upper bounds on x variables

IntCon = [7 8 9];
%options = optimoptions('ga','OutputFcn',@gaoutfnc, 'PlotFcn','gaplotbestf','MaxGeneration',50);
options = optimoptions('ga','OutputFcn',@gaoutfnc, 'InitialPopulation', init_pop, 'MaxTime',120);%'InitialPopulation', init_pop,);%,'MaxTime',120);%'InitialScores',init_score,%'MaxGeneration',3,
%% optimization program
[x, f]=ga(@objfun,n,[],[],[],[],XLB,XUB,@nnlcon,IntCon,options);

    function [a, b, c] = get_cache(x)
        tmp=eval(cacheFitness(mat2str(x)));
        a=tmp(1:4);% 1 to 4 throughput
        b=tmp(5:7);
        c=tmp(8:14);
    end
    
    function [c,ceq]=nnlcon(x)
       
        x_share=zeros(1,6);
        for i=1:6
            x_share(i)=x(i)*share_unit;        
        end
        x_new=horzcat(x_share,x(7:9));
        
        if(isKey(cacheFitness,mat2str(x)))
            [t, w, u]=get_cache(x);
        else
            [t, w, u]=model_solver(x_new);
            cacheFitness(mat2str(x))=mat2str(horzcat(t,w,u),6);
        end
        
        %c = [(x_new(1)*1) + (x_new(2)*x_new(7)) + (x_new(6)*1)-cmax_1; (x_new(3)*x_new(8)) + (x_new(4)*x_new(9)) + (x_new(5)*1)-cmax_2; (memory_units(1)*1) + (memory_units(2)*x_new(7)) + (memory_units(6)*1)-mmax_1; (memory_units(3)*x_new(8)) + (memory_units(4)*x_new(9)) + (memory_units(5)*1)-mmax_2; w(1)-WMAX(1);w(2)-WMAX(2);w(3)-WMAX(3)];
        pos_cons1=(x_new(1)*1) + (x_new(2)*x_new(7)) + (x_new(6)*1)-cmax_1;
        pos_cons2=(x_new(3)*x_new(8)) + (x_new(4)*x_new(9)) + (x_new(5)*1)-cmax_2;
        
        %neg_cons1=cmax_1 - (x_new(1)*1) - (x_new(2)*x_new(7)) - (x_new(6)*1);
        %neg_cons2=cmax_2 - (x_new(3)*x_new(8)) - (x_new(4)*x_new(9)) - (x_new(5)*1);
        
        %u_con=u_min-sum(u(2:7));
        
        %c = [pos_cons1;pos_cons2 ; neg_cons1; neg_cons2; w(1)-WMAX(1);w(2)-WMAX(2);w(3)-WMAX(3)];
        %c = [pos_cons1; pos_cons2; w(1)-WMAX(1);w(2)-WMAX(2);w(3)-WMAX(3)];       
        c = [pos_cons1; pos_cons2; w(1)-WMAX(1);w(2)-WMAX(2);w(3)-WMAX(3); u(2)-max_util; u(3)-max_util; u(4)-max_util; u(5)-max_util; u(6)-max_util; u(7)-max_util];
        %c = [-(x_new(1)*1) - (x_new(2)*x_new(7)) - (x_new(6)*1)+cmax_1; -(x_new(3)*x_new(8)) - (x_new(4)*x_new(9)) - (x_new(5)*1)+cmax_2;(x_new(1)*1) + (x_new(2)*x_new(7)) + (x_new(6)*1)-cmax_1; (x_new(3)*x_new(8)) + (x_new(4)*x_new(9)) + (x_new(5)*1)-cmax_2;w(1)-WMAX(1);w(2)-WMAX(2);w(3)-WMAX(3)];

        ceq = [];
        
    end

    function f = objfun(x)
       
        x_share=zeros(1,6);
        for i=1:6
            x_share(i)=x(i)*share_unit;        
        end
        x_new=horzcat(x_share,x(7:9));
       
        if(isKey(cacheFitness,mat2str(x)))
            [t, w, u]=get_cache(x);
        else
            [t, w, u]=model_solver(x_new);
            cacheFitness(mat2str(x))=mat2str(horzcat(t,w,u),6);
        end
        
        tps=((t(1)*y(1)) + (t(2)*y(2)) + (t(3)*y(3)));
        tps_norm=tps/tps_max;
        
        replica=horzcat(1,x_new(7:9),[1 1]);
        total_share=sum(x_new(1:6).*replica);
        total_share_norm=total_share/(cmax_1+cmax_2);
        
        %w1=1;
        %w2=35;

        f=total_share_norm-tps_norm;
        
    end

    function [state,options,optchanged] = gaoutfnc(options,state,flag)
        
        global solutionsFile;
        fileName=solutionsFile;
        
        optchanged = false;
        
        [M,N]=size(state.Population);
        fid = fopen(fileName,'a+');

        for i=1:M
            for j=1:N
                value=state.Population(i,j);
                if(j<7)
                    value=value*share_unit;
                end
                fprintf(fid,'%f, ', value);
            end
            fprintf(fid,'%f\n',-state.Score(i));
        end
        fclose(fid);
        
    end

fprintf('Program ends at %s, unique evaluations %f\n', datestr(now,'HH:MM:SS.FFF'),size(cacheFitness,1));

end