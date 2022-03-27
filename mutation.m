function [p,objF,conV,FES]=mutation(p,objF,conV,minVar,maxVar,problem,aaa,FES)



[popsize,n]=size(p);

 minConV=min(conV);

 if  minConV ~= 0 

    [~,maxConVIndex]=max(conV);

    randIndex=floor(rand*popsize)+1;
    term=p(randIndex,:);

    randD=floor(rand*n)+1; 
    term(randD)=minVar(randD)+rand.*(maxVar(randD)-minVar(randD)); 

    [objFterm,conVterm]=fitness(term,problem,aaa);
    FES=FES+1;

    if  objFterm < objF(maxConVIndex)
       p(maxConVIndex,:)=term; 
       objF(maxConVIndex)=objFterm; 
       conV(maxConVIndex)=conVterm; 
    end

 end
  
 end