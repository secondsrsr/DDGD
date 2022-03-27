function [s,fit,Etmin,Ecmin,parameter] = popUpdate(UE,U,M,Etmin,Ecmin,parameter)

s = -1*ones(UE.N,parameter.popsize);                % offloading decisions
f = zeros(UE.N,parameter.popsize);                  % computing resource
R = zeros(UE.N,parameter.popsize);                  % uplink data rate


%Constrcut offloading decision
for k=1:parameter.popsize
    table = M;
    Rtemp0 = [];
    Rtemp1 = [];

  [~,selectionOrder] = sort(sum(M,2));
    for i = 1:UE.N
        currentTask = selectionOrder(i);
        if s(currentTask,k)==-1
            allowMode = find(table(currentTask,:)==1);
            if ismember(1,allowMode)
                cloudTask = find(s(:,k) == 0);
                archive = [cloudTask;currentTask];
                Hsum = repmat(sum(U.H(archive,1)),size(archive,1),1)-U.H(archive,1);
                Rtemp = parameter.W*log2(1+UE.pt*U.H(archive,1)./(parameter.wn+Hsum));
                ftemp = U.F(archive)./(UE.Tmax-(U.D(archive)+U.B(archive))./Rtemp);
                if sum(ftemp)>UE.f(1) || sum(ftemp<0)>0
                    allowMode(1)=[];
                else
                    Rtemp1 = Rtemp;
                end
            end
            
            if ~isempty(allowMode)
                detalE = zeros(1,size(allowMode,2));
                if ismember(1,allowMode)
                    detalE(1) = sum((UE.pt.*U.D(archive)+UE.pt.*U.B(archive))./Rtemp1)-sum((UE.pt.*U.D(cloudTask)+UE.pt.*U.B(cloudTask))./Rtemp0);
                else
                    detalE(1) = Etmin(currentTask,allowMode(1)-1)+Ecmin(currentTask,allowMode(1)-1);
                end
                detalE(2:end) = Etmin(currentTask,allowMode(2:end)-1)+Ecmin(currentTask,allowMode(2:end)-1);
                Eta = 1./detalE;
                p = parameter.pheromone(currentTask,allowMode).*Eta.^parameter.beta;
                if rand<parameter.q
                    index = find(p==max(p));
                else
                    p = p/sum(p);
                    pc = cumsum(p);
                    index = find(pc > rand);
                end
                targetMode = allowMode(index(1));
                s(currentTask,k) = targetMode(1)-1;
                if targetMode(1)~=1
                    table(:,targetMode(1)) = 0;
                else
                    Rtemp0 = Rtemp;
                    cloudTask = [cloudTask;currentTask];
                end
                % Local management
                parameter.pheromone(currentTask,s(currentTask,k)+1) = (1-parameter.rho)*parameter.pheromone(currentTask,s(currentTask,k)+1)+parameter.rho*parameter.pheromoneIni;
            end
        end
    end
    
    %Resource allocation
    Hsum = sum(U.H(s(:,k)==0,1));
    R1 = R;
    for i = 1:UE.N
        if s(i,k)==0
            R(i,k) = parameter.W*log2(1+UE.pt*U.H(i,1)/(parameter.wn+Hsum-U.H(i,1)));
            R1(i,k) = inf;
            f(i,k) = U.F(i)/(UE.Tmax-(U.D(i)+U.B(i))/R(i,k));
        elseif s(i,k)==i
            R(i,k) = inf;
            R1(i,k) = inf;
            f(i,k) = U.F(i)/UE.Tmax;
        elseif s(i,k)>0
            R(i,k) = parameter.W*log2(1+UE.pt*U.H(i,s(i,k)+1)/parameter.wn);
            R1(i,k) = R(i,k);
            f(i,k) = U.F(i)/(UE.Tmax-(U.D(i)+U.B(i))/R(i,k));
        elseif s(i,k)==-1
            R(i,k) = inf;
            R1(i,k) = inf;
            f(i,k)  = 0;
        end
    end
end

%Fitness evalution
fit(1,:) = sum(s~=-1);                                                                                         
Ec = parameter.alpha.*f.^2.*repmat(U.F,1,parameter.popsize).*(s>0);
Et = ((UE.pt.*repmat(U.D,1,parameter.popsize)+UE.pr.*repmat(U.B,1,parameter.popsize))./R+(UE.pt.*repmat(U.B,1,parameter.popsize)+UE.pr.*repmat(U.D,1,parameter.popsize))./R1).*(s~=-1);
fit(2,:) = sum(Ec+Et);                                                                                       

end

