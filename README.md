# ATOM: Autoscaler for Microservices

This is the repository for ATOM, an autoscaler for microservices, which we presented in [ICDCS 2019](https://ieeexplore.ieee.org/document/8884900). ATOM has four components:
+ The main autoscaling engine (Atom folder)
+ The scaling executors (AtomExecutorServer1 and AtomExecutorServer2 folders)
+ The scaling planner (AtomAnalyzerPlanner)
+ The monitoring component (AtomMonitor)

This version of ATOM is targeted for the [Sock Shop Application](https://microservices-demo.github.io/). We have deployed it in two different servers and thus we have two executors. The autoscaling engine is developed with Matlab and it is tested with version 2018a. To execute the engine, we need to put the Atom folder in Matlab's default path and start Matlab in a [shared session](https://www.mathworks.com/help/matlab/ref/matlab.engine.shareengine.html).

The planner is written using the Java programming language and it needs to communicate with the matlab session. This can be done using the [functionality](https://www.mathworks.com/help/matlab/matlab_external/setup-environment.html) provided by Matlab. The monitoring component monitors the communication among the microservices (the *filters.txt* file specifies which communications to track) and pass this monitoring data to the planner. The planner communicates with the autoscaling engine and sends the scaling config to the executors. The executors runs the scaling command.

A demo of ATOM can be found [here](https://www.youtube.com/watch?v=67JAc49afWw).

N.B.: The relevant file paths and server names should be updated according to the local environment.
