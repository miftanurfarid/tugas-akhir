function itdaverage=averageitd(corrT)

[nfilter,ndelay]=size(corrT);

for delay=1:ndelay,
   integratedccfunctionT(delay) = 0;   
   for filter=1:nfilter,
      integratedccfunctionT(delay) = integratedccfunctionT(delay) + corrT(filter, delay);   
   end;
end;

itdaverage=integratedccfunctionT;