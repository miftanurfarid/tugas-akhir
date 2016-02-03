function [ratiochanframe] = ratiochanframe(hct,hcm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

winLength = 320;
[numChan,sigLength] = size(hcm);
winShift = winLength/4;
increment = winLength/winShift;
M = floor(sigLength/winShift);

c = zeros(numChan,M);

for m = 1:M      
    for i = 1:numChan
        if m < increment        % shorter frame lengths for beginning frames
            a1 = sqrt(hct(i,1:m*winShift)*hct(i,1:m*winShift)');
            b1 = sqrt(hcm(i,1:m*winShift)*hcm(i,1:m*winShift)');
            c(i,m) = a1./(a1+b1);
        else
            startpoint = (m-increment)*winShift;
            a2 = sqrt(hct(i,startpoint+1:startpoint+winLength)*hct(i,startpoint+1:startpoint+winLength)');
            b2 = sqrt(hcm(i,startpoint+1:startpoint+winLength)*hcm(i,startpoint+1:startpoint+winLength)');
            c(i,m) = a2./(a2+b2);
        end
        ratiochanframe = c;
    end
end

end

