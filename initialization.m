function [U,UE,M,Etmin,Ecmin,parameter] = initialization(N)

%COMEC
UE.N        =   N;                                 % number of devices                      
UE.fd       =   load(['MD\ufd_',num2str(N),'.dat']);            
U.H         =   load(['MD\H_',num2str(N),'.dat']);            
U.F         =   load(['TD\F_',num2str(N),'.dat']);               
U.D         =   load(['TD\D_',num2str(N),'.dat']);              
U.B         =   load(['TD\B_',num2str(N),'.dat']);             
UE.fc       =   2e11;                                                   
UE.f        =   [UE.fc;UE.fd]';                                         
UE.pt       =   1.3;                                                   
UE.pr       =   0.8;                                                    %
UE.Tmax     =   1;                                                      % MAX T
parameter.W =   20*10^6;                                                %bandwidth
parameter.wn=   10^(-13);                                               %noise power
parameter.alpha =   10^(-27);


parameter.popsize           =   50;                                           
parameter.maxEvaluations    =   15000;                                         
parameter.maxIteration      =   parameter.maxEvaluations/parameter.popsize;
parameter.curIteration      =   0;
parameter.pheromoneIni      =   load(['TD\pheromoneIni_',num2str(N),'.dat']);
parameter.pheromoneIni      =   1/(UE.N*parameter.pheromoneIni);
parameter.pheromone         =   parameter.pheromoneIni*ones(UE.N,UE.N+1);
parameter.beta              =   2;
parameter.q                 =   0.9;
parameter.phi               =   0.1;
parameter.rho               =   0.1;

Rmax    =   parameter.W*log2(1+UE.pt*U.H/parameter.wn);                                     
T_t     =   repmat(U.D,1,UE.N+1)./Rmax + repmat(U.B,1,UE.N+1)./Rmax;                        %time
fmin    =   repmat(U.F,1,UE.N+1)./(repmat(UE.Tmax,1,UE.N+1)-T_t);                           %resource
M       =   (fmin>=0&fmin<=repmat(UE.f,UE.N,1));                                            %offloading decision 

Etmin = (UE.pt.*repmat(U.D,1,UE.N)+UE.pr.*repmat(U.B,1,UE.N))./Rmax(:,2:end)+(UE.pr.*repmat(U.D,1,UE.N)+UE.pt.*repmat(U.B,1,UE.N))./Rmax(:,2:end); %energy consumption
Ecmin   =   parameter.alpha.*fmin(:,2:end).^2.*repmat(U.F,1,UE.N);                                                                                 %
end
