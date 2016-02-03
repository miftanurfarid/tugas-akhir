function [ out ] = makeMask(ITD,ILD,Region,D)
%%Compute estimated binary mask from from ITD/ILD features using 
% the learned decisionrules



N=Region(5,1);

l=size(ILD,2);
max_channel=size(ILD,1);

ITD=ITD-17;     

mask=zeros(size(ITD));
        
for i=1:l
    for j=1:max_channel
                
         L = round(1/(Region(4,j)-Region(3,j))*...
      ((N-1)*ILD(j,i)+Region(4,j)-N*Region(3,j)));  
         P = round(1/(Region(2,j)-Region(1,j))*...
      ((N-1)*ITD(j,i)+Region(2,j)-N*Region(1,j)));
  
        P = min(max(1,P),N);
        L = min(max(1,L),N);
      
        mask(j,i)=D(L,P,j);
    end
end
 out=mask;
end

