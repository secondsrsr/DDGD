function [trial]=DEgenerator(p,objF,minVar,maxVar)

[popsize,n]=size(p);


mutant=zeros(popsize,n);

flag=zeros(popsize,1);


CR=ones(popsize,1)*0.1;
randArray=rand(popsize,1);
oneIndex= randArray <= 1/3;
CR(oneIndex)=1.0;
point2Index= randArray > 1/3 & randArray <= 2/3;
CR(point2Index)=0.2;

F=zeros(popsize,1);
randPerm=randperm(popsize)';
F(randPerm(1:round(popsize/3)))=1.0;
F(randPerm(round(popsize/3)+1:round(popsize/3*2)))=0.8;
F(randPerm(round(popsize/3*2)+1:popsize))=0.6;


for i=1:popsize
    
    randOper=rand;
    if  randOper < 0.5

       [~,minObjFIndex]=min(objF);  
       bestTarget=p(minObjFIndex,:); 
       
       indexset=1:popsize;
       indexset(i)=[];
       r1=floor(rand*(popsize-1))+1;
       xr1=indexset(r1);
       indexset(r1)=[];
       r2=floor(rand*(popsize-2))+1;
       xr2=indexset(r2);
       indexset(r2)=[];
       r3=floor(rand*(popsize-3))+1;
       xr3=indexset(r3);

       flag(i)=0; 

       mutant(i,:)=p(xr1,:)+rand*(bestTarget-p(xr1,:))+F(i)*(p(xr2,:)-p(xr3,:));
       
    else
         
       index=[i];
       indexset=1:popsize;
       indexset(index)=[];
       r1=floor(rand*(popsize-1))+1;
       xr1=indexset(r1);
       indexset(r1)=[];
       r2=floor(rand*(popsize-2))+1;
       xr2=indexset(r2);
       indexset(r2)=[];
       r3=floor(rand*(popsize-3))+1;
       xr3=indexset(r3);
       

       flag(i)=1; 

       mutant(i,:)=p(i,:)+rand*(p(xr1,:)-p(i,:))+F(i)*(p(xr2,:)-p(xr3,:));
     end     
end

  minMatrix=repmat(minVar,popsize,1); 
  maxMatrix=repmat(maxVar,popsize,1); 

  maxnum=find(mutant>maxMatrix);
  mutant(maxnum)=max((2*maxMatrix(maxnum)-mutant(maxnum)), minMatrix(maxnum));
  minnum=find(mutant< minMatrix);
  mutant(minnum)=min((2* minMatrix(minnum)-mutant(minnum)),maxMatrix(minnum));
  clear num;

 index=find(flag==1);
 term=mutant(index,:);
 t=rand(popsize,n)<repmat(CR,1,n);
 jrand=floor(rand(popsize,1)*n)+1;
 jrand=([1:popsize]'-1)*n+jrand;
 t_T=t';
 t_T(jrand)=1;
 t=t_T';
 t_=1-t;
 trial=mutant.*t+p.*t_;    
 trial(index,:)=term;