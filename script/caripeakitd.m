function [ out ] = caripeakitd( itdchanframeM )
%Cari Peak ITD - mencari nilai peak dari output itdchanframe

[row,col,zz]=size(itdchanframeM);
ITDtempm=zeros(row,col);
for i=1:row
    for j=1:col
        [a,b]=max(itdchanframeM(i,j,:));
        ITDtempm(i,j)=b;
    end
end
out=ITDtempm;

end