function [ out ] = itdchanframe( hcl,hcr )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

hcTL = hcl;
hcTR = hcr;
fs = 16000;
winLength = 320;
maxdelay = 1000; %1 ms
mindelay = -1000; % -1 ms
onesample = 1000000/fs; %nilai time tiap sample
maxdelay_samples = maxdelay/onesample;
mindelay_samples = mindelay/onesample;
delaystep = 1;
delayindex_samples = mindelay_samples:delaystep:maxdelay_samples;
ndelay = length(delayindex_samples);

winShift = winLength/4; 
increment = winLength/winShift;


[numChan,sigLength]=size(hcTL);
M=floor(sigLength/winShift);
c=zeros(numChan,M,ndelay);


for n=1:numChan
    for m=1:M        
        for l=1:ndelay
            delay=delayindex_samples(l);
            if m < increment
                if delay<0
                    delayed_L1(1,1:abs(delay))=0;
                    delayed_L1(1,abs(delay)+1:m*winShift)=hcTL(n,1:(m*winShift)-abs(delay));
%                     mean_L1=mean(hcTL(n,1:m*winShift));
                    delayed_R1(1,1:m*winShift)=hcTR(n,1:m*winShift);
%                     mean_R1=mean(hcTR(n,1:m*winShift));
                elseif delay == 0
                    delayed_L1(1,1:m*winShift)=hcTL(n,1:m*winShift);
%                     mean_L1=mean(hcTL(n,1:m*winShift));
                    delayed_R1(1,1:m*winShift)=hcTR(n,1:m*winShift);
%                     mean_R1=mean(hcTR(n,1:m*winShift));
                else
                    delayed_R1(1,1:abs(delay))=0;
                    delayed_R1(1,abs(delay)+1:m*winShift)=hcTR(n,1:(m*winShift)-abs(delay));
%                     mean_R1=mean(hcTR(n,1:m*winShift));
                    delayed_L1(1,1:m*winShift)=hcTL(n,1:m*winShift);
%                     mean_L1=mean(hcTL(n,1:m*winShift));
                end
%                 temp_left1=(delayed_L1-mean_L1);
%                 temp_right1=(delayed_R1-mean_R1);
%                 temp1=(temp_left1*temp_right1')/((sqrt(temp_left1*temp_left1'))*(sqrt(temp_right1*temp_right1')));
                temp1=mean(delayed_R1.*delayed_L1);
                c(n,m,l)=temp1;
            else
                startpoint = (m-increment)*winShift;
                if delay<0
                    delayed_L2(1,1:abs(delay))=0;
                    delayed_L2(1,abs(delay)+1:winLength)=hcTL(n,startpoint+1:startpoint+winLength-abs(delay));
%                     mean_L2=mean(hcTL(n,startpoint+1:startpoint+winLength));
                    delayed_R2(1,1:winLength)=hcTR(n,startpoint+1:startpoint+winLength);
%                     mean_R2=mean(hcTR(n,startpoint+1:startpoint+winLength));
                elseif delay == 0
                    delayed_L2(1,1:winLength)=hcTL(n,startpoint+1:startpoint+winLength);
%                     mean_L2=mean(hcTL(n,startpoint+1:startpoint+winLength));
                    delayed_R2(1,1:winLength)=hcTR(n,startpoint+1:startpoint+winLength);
%                     mean_R2=mean(hcTR(n,startpoint+1:startpoint+winLength));
                else
                    delayed_R2(1,1:abs(delay))=0;
                    delayed_R2(1,abs(delay)+1:winLength)=hcTR(n,startpoint+1:startpoint+winLength-abs(delay));
%                     mean_R2=mean(hcTR(n,startpoint+1:startpoint+winLength));
                    delayed_L2(1,1:winLength)=hcTL(n,startpoint+1:startpoint+winLength);
%                     mean_L2=mean(hcTL(n,startpoint+1:startpoint+winLength));
                end
%                 temp_left2=mean(delayed_L2-mean_L2);
%                 temp_right2=mean(delayed_R2-mean_R2);
%                 temp2=(temp_left2*temp_right2')/((sqrt(temp_left2*temp_left2'))*(sqrt(temp_right2*temp_right2')));
                temp2=mean(delayed_R2.*delayed_L2);
                c(n,m,l)=temp2;
            end     
        end
    end
end
out = c;
end