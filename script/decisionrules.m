function decisionrules(ITD,ILD,RATIO,decisions_name)
% mapping ratio -> itd&ild

Npoints=100;
max_channel=128;
D=zeros(Npoints,Npoints,max_channel);
Region=zeros(5,max_channel);

for chan=1:max_channel
    
I1=find(RATIO(chan,:)>0.5); %cari letak RATIO target
I2=find(RATIO(chan,:)<=0.5); %cari letak RATIO masker
len1=length(I1);len2=length(I2);

%potong panjang data jadi 2000
if len1>6000
      len1=6000;
end
if len2>6000
      len2=6000;
end
             
features=[ITD(chan,1:(len1+len2))-17;ILD(chan,1:(len1+len2))]; %kolom 1=itd, kolom2=ild
targets=(RATIO(chan,1:(len1+len2))>0.5); %nilai RATIO, target->1, masker->0

region=[min(features(1,:)),max(features(1,:)),min(features(2,:)),max(features(2,:)),Npoints];
d=decisionRegion(features,targets,region);
D(:,:,chan)=d;
Region(:,chan)=region';

end

save(decisions_name,'D','Region')

end

