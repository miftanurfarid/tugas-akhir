function [ildchanframe] = ildchanframe(hcl,hcr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

winLength = 320;
[numChan,sigLength] = size(hcr);
winShift = winLength/4;
increment = winLength/winShift;
M = floor(sigLength/winShift);

c = zeros(numChan,M);

for m = 1:M      
    for i = 1:numChan
        if m < increment        % shorter frame lengths for beginning frames
            a1 = hcr(i,1:m*winShift)*hcr(i,1:m*winShift)';
            b1 = hcl(i,1:m*winShift)*hcl(i,1:m*winShift)';
            c(i,m) = 20*log10(a1./b1);
        else
            startpoint = (m-increment)*winShift;
            a2 = hcr(i,startpoint+1:startpoint+winLength)*hcr(i,startpoint+1:startpoint+winLength)';
            b2 = hcl(i,startpoint+1:startpoint+winLength)*hcl(i,startpoint+1:startpoint+winLength)';
            c(i,m) = 20*log10(a2./b2);
        end
        ildchanframe = c;
    end
end


end