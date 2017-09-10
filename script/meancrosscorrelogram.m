function [itd,corr] = meancrosscorrelogram(hcTL,hcTR,mindelay,maxdelay,samplerate)

% hcTL = outout dari meddis hair cells telinga kiri
% hcTR = outout dari meddis hair cells telinga kanan
% mindelay & maxdelay = minimum dan maksimum delay dalam mikrodetik

powervector_TL = (sqrt(mean(power(hcTL, 2)')))';
powervector_TR = (sqrt(mean(power(hcTR, 2)')))';

onesample = 1000000/samplerate; % us
maxdelay = round(maxdelay/onesample) * onesample;
mindelay = round(mindelay/onesample) * onesample;
maxdelay_samples = maxdelay/onesample;
mindelay_samples = mindelay/onesample;
delaystep = 1;
delayindex_samples = mindelay_samples:delaystep:maxdelay_samples;
ndelays = length(delayindex_samples);
npoints = length(hcTL);
denominator = (powervector_TL .* powervector_TR);
delayedoutput_TL = zeros(size(hcTL));
delayedoutput_TR = zeros(size(hcTR));

for delay=1:ndelays;
    delay_samples=delayindex_samples(delay);
       if delay_samples < 0
          delayedoutput_TL(:,1:abs(delay_samples)) = 0;
          delayedoutput_TL(:,abs(delay_samples)+1:npoints) = hcTL(:,1:(npoints-abs(delay_samples)));
          delayedoutput_TR = hcTR;
       elseif delay_samples == 0
          delayedoutput_TL = hcTL;
          delayedoutput_TR = hcTR;
       else
          delayedoutput_TR(:,1:abs(delay_samples)) = 0;
          delayedoutput_TR(:,abs(delay_samples)+1:npoints) = hcTR(:,1:(npoints-abs(delay_samples)));
          delayedoutput_TL = hcTL;
       end;
      corrT(:, delay) = mean(delayedoutput_TL .* delayedoutput_TR, 2);
      corrT(:, delay) = corrT(:, delay) ./ denominator;
      corrT(:, delay) = sqrt(corrT(:, delay));
      
      corr = corrT;
      
      
end
[a,b]=max(corr'); %mencari max peak sebagai ITD
c=b-(((length(corr(1,:))-1)/2)+1);
d=c*onesample;
itd=d;