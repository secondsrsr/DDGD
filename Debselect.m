function  [p,objF,conV,recordp,recordobjF,recordconV]=Debselect(p,objF,conV,trial,objFtrial,conVtrial)

   termconV=conV; 
   termobjF=objF;
   

   recordIndex=find(conVtrial > termconV & objFtrial < termobjF); 
   recordp=trial(recordIndex,:);
   recordobjF=objFtrial(recordIndex);
   recordconV=conVtrial(recordIndex); 

   betterIndex=find(conVtrial < termconV);
   p(betterIndex,:)=trial(betterIndex,:);
   objF(betterIndex)=objFtrial(betterIndex);
   conV(betterIndex)=conVtrial(betterIndex);

   betterIndex=find(conVtrial==termconV & objFtrial < termobjF);      
   p(betterIndex,:)=trial(betterIndex,:);
   objF(betterIndex)=objFtrial(betterIndex);
   conV(betterIndex)=conVtrial(betterIndex);

