s=az20L;
s2=az20L;
thresh0=0.5;
div1=2;
doDisplay=1;
nargin=4;

if nargin < 4, doDisplay = 0; end
if nargin < 3, div1 = 2; end
if nargin < 2, thresh0 = 1; end
div1 = max([div1 1]); 
thresh = thresh0;
if doDisplay, fPos = [631    33   644   919]; end

cFS = 16000;        % minimum stimulus sampling rate (Hz)
nChannels = 30;     % number of cochlear channels
lowF = 100;         % lowest channel centre frequency (Hz)
highF = 8000;       % highest channel centre frequency (Hz)
xFloor = 0.35;      % non-zero floor for calculating transient response
cochlearFS = 1000;  % sampling rate for cochlear response (Hz)
saliencyFS = 200;   % sampling rate for saliency response (Hz)
%doNormalise = 1;
nPeriods = 8;       % Frequency dependent time window for transient    
                    % analysis = nPeriods/cf
minPeriod = 1.25;   % minimum time window for transient analysis in ms

cfCort = 100;
nCortPeriods = 4;
minCortPeriod = 1;

% if findstr(fName,'.au') 
%     [s,fs] = auread(fName);
% elseif findstr(fName,'.wav') 
%     [s,fs] = wavread(fName);
% else
%     disp('** Not a valid sound file')
%     return
% end

fs=16000;
% Ignore stereo
s = s(:,1);

% Resample if necessary
if fs < cFS
    s = resample(s,cFS,fs);
    fs = cFS;
end
% if doNormalise, s = s/max(abs(s)); end

% Get sampling times
ns = length(s);
dt = 1/fs;
ts = [0:dt:(ns-1)*dt];

% ......................................................Cochlear Processing
[eResp,fx,cf,tx] = scm(s,fs,[nChannels lowF highF],1000/cochlearFS);
[eResp2,fx2,cf2,tx2] = scm(s2,fs,[nChannels lowF highF],1000/cochlearFS);

% .............................................................. Transients
[y,ty] = skv(eResp,cf,fx,nPeriods,minPeriod,1000/saliencyFS);
tResp = y.*(y>0);
[y2,ty] = skv(eResp2,cf2,fx2,nPeriods,minPeriod,1000/saliencyFS);
tResp2 = y2.*(y2>0);

%............................................................ STRF response
cortResp = getResponse(tResp,'strfsSorted200',1);
cortResp2 = getResponse(tResp2,'strfsSorted200',1);

%........................................................ Perceptual Onsets
saliency = skv(sum(cortResp)+xFloor,cfCort,saliencyFS,nCortPeriods, ...
    minCortPeriod,1000/saliencyFS);
saliency2 = skv(sum(cortResp2)+xFloor,cfCort,saliencyFS,nCortPeriods, ...
    minCortPeriod,1000/saliencyFS);
tShift = nCortPeriods/saliencyFS;
pOnsets = getPOnsets(saliency,thresh,div1,1/saliencyFS,tShift);

% Make event track
sDet = getEventTrack(ts,pOnsets(:,1));

t = [0:(length(saliency)-1)]/saliencyFS;
figure(4);
subplot(211)
plot(ts,s*max(abs(saliency)),'c',t,saliency,'r')
subplot(212)
plot(ts,s*max(abs(saliency2)),'c',t,saliency2,'r')