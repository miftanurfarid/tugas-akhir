function [ meanild ] = meanild(hcL,hcR)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

[numChan,sigLength]=size(hcL);

a = zeros(numChan,1);
b = zeros(numChan,1);
for i=1:numChan
    a(i,:)=hcR(i,:)*hcR(i,:)';
    b(i,:)=hcL(i,:)*hcL(i,:)';
    c=20*log10(a./b);
end

meanild = c;

end

