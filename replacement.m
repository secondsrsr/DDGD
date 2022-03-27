function  [p,objF,conV]=replacement(p,objF,conV,recordp,recordobjF,recordconV)

 [popsize,n]=size(p);
 

 N=round(max(5,n/2)); 
 

 Nf=round(popsize/N);

 [~,sortindex]=sort(-objF); 

 for i=1:floor(popsize/Nf)

   len=length(recordobjF);

   if len~=0 

      clear minRecordconVIndex maxSubConVIndex; 

      subConV=conV(sortindex((i-1)*Nf+1:(i-1)*Nf+Nf));
      [~,maxIndex]=max(subConV);     
      maxIndex=(i-1)*Nf+maxIndex;
      maxSubConVIndex=sortindex(maxIndex);  

      [~,minRecordconVIndex]=min(recordconV);

      if recordobjF(minRecordconVIndex) < objF(maxSubConVIndex)

          p(maxSubConVIndex,:)=recordp(minRecordconVIndex,:);
          objF(maxSubConVIndex)=recordobjF(minRecordconVIndex);
          conV(maxSubConVIndex)=recordconV(minRecordconVIndex);

          recordconV(minRecordconVIndex)=[];
          recordobjF(minRecordconVIndex)=[];
          recordp(minRecordconVIndex,:)=[];
          
      end   
  end
end