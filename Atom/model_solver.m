function [t, r, u] = model_solver(x)

    demand_update(x(1:6));
    replica_update(x(7:9));
    [t, r, u]=lqns_run();

end
