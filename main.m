
clc;
clear;

N =20;                                                
runNum = 2;

Num = zeros(runNum,300);
Energy = zeros(runNum,300);
EnergyArchive = zeros(runNum,300);

for run = 1:runNum
   
    [U,UE,M,Etmin,Ecmin,parameter] = initialization(N);
    
    
    while parameter.curIteration < parameter.maxIteration
        [s,fit,Etmin,Ecmin,parameter] = popUpdate(UE,U,M,Etmin,Ecmin,parameter);
        
        maxnumdev = find(fit(1,:)==max(fit(1,:)));
        [~,best] = min(fit(2,maxnumdev));
        best = maxnumdev(best);
        
        
        if fit(1,best)==UE.N
            [fit(2,best),s(:,best)] = Search(UE,fit(2,best),s(:,best),Ecmin,Etmin,M);
        end
        
        
        for i = 1:UE.N
            if s(i,best)~=-1
                parameter.pheromone(i,s(i,best)+1) = (1-parameter.phi)*parameter.pheromone(i,s(i,best)+1)+parameter.phi*1/fit(2,best);
            end
        end
        
        
        parameter.curIteration = parameter.curIteration+1;
        
        Num(run,parameter.curIteration) =  fit(1,best);
        if fit(1,best)==UE.N
            Energy(run,parameter.curIteration) =  fit(2,best);
            if parameter.curIteration>1
                if Energy(run,parameter.curIteration)<EnergyArchive(run,parameter.curIteration-1)
                    schive = s(:,best);
                end
            end
        else
            Energy(run,parameter.curIteration) =  inf;
        end
        EnergyArchive(run,parameter.curIteration) = min(Energy(run,1:parameter.curIteration));
    end
end
