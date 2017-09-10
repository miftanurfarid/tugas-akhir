fRange  = [80, 5000];
numChan = 128;
cfs     = erb2hz(linspace(hz2erb(fRange(1)), hz2erb(fRange(2)), numChan));
chan    = 40; % chan 40 = 500Hz, 63 = 1000 Hz
cfs(chan)
Npoints = 100;
max_channel = 128;
D           = zeros(Npoints,Npoints,max_channel);
Region      = zeros(5,max_channel);
I1          = find(RATIO(chan,:)>0.5); %cari letak RATIO target
I2          = find(RATIO(chan,:)<=0.5); %cari letak RATIO masker
len1        = length(I1);len2=length(I2);

%potong panjang data jadi 2000
if len1>6000
      len1=6000;
end
if len2>6000
      len2=6000;
end
             
features    =[ITD(chan,1:(len1+len2))-17;ILD(chan,1:(len1+len2))]; %kolom 1=itd, kolom2=ild
targets     =(RATIO(chan,1:(len1+len2))>0.5); %nilai RATIO, target->1, masker->0

region  = [min(features(1,:)),max(features(1,:)),min(features(2,:)),max(features(2,:)),Npoints];
N		= region(5); %Number of points on the grid -> nilai npoints
x		= ones(N,1) * linspace (region(1),region(2),N); %linspace->array dari region(1) sampai region(2) sebanyak N data. -> x-axis ITD,nilai ITD sama sepanjang y-axis
y		= linspace (region(3),region(4),N)' * ones(1,N); %y-axis ild terendah sampai tertinggi, nilai iid sama sepanjang x-axis
V0		= zeros(N);
V1		= zeros(N);

class1  = find(targets == 1); %posisi target
class0  = find(targets == 0); %posisi masker %targets->%nilai R, target->1, masker->0

%% class0 -> masker

P0  = length(class0)/length(features); %panjang data letak masker/ panjang data fitur(ITD,ILD)
n   = length(class0); %panjang data letak masker

sigma   = cov(features(1,class0),features(2,class0)); %matriks kovarian antara matriks nilai ITD&ILD pada matriks posisi masker

hstart1=n^(-1/6)*sqrt(sigma(1,1)); %autovariance ITD
hstart2=n^(-1/6)*sqrt(sigma(2,2)); %autovariance ILD

h01=hstart1;
h02=hstart2;

%landa estimation

f_X=zeros(1,n);


for i = 1:n
    
   temp = (features(1,class0)-features(1,class0(i))).^2/(2*h01^2) + (features(2,class0)-features(2,class0(i))).^2/(2*h02^2);
   f_X   = f_X + exp(-temp);
   
end

f_X = 1/(2*pi*h01*h02)*f_X/n;


g=exp(sum(log(f_X))/n);

alpha=-0.5;

landa=(f_X/g).^alpha;

% density estimation

for i = 1:n,
   temp = ((x - features(1,class0(i))).^2/(2*h01^2) + (y - features(2,class0(i))).^2/(2*h02^2))/(landa(i)^2);   
   V0   = V0 + 1/(h01*h02*landa(i)^2)*exp(-temp);
end

V0 = 1/(2*pi)*V0/n;

clear landa f_X g

%% class1 -> target

P1 = length(class1)/length(features);
n  = length(class1);

sigma=cov(features(1,class1),features(2,class1));

hstart1=n^(-1/6)*sqrt(sigma(1,1));
hstart1=n^(-1/6)*sqrt(sigma(1,1));

h11=hstart1;
h12=hstart2;

%landa estimation

f_X=zeros(1,n);

for i = 1:n
    
   temp = (features(1,class1)-features(1,class1(i))).^2/(2*h11^2) + (features(2,class1)-features(2,class1(i))).^2/(2*h12^2);
   f_X   = f_X + exp(-temp);
   
end

f_X = 1/(2*pi*h11*h12)*f_X/n;

g=exp(sum(log(f_X))/n);

alpha=-0.5;

landa=(f_X/g).^alpha;

% density estimation

for i = 1:n,
   temp = ((x - features(1,class1(i))).^2/(2*h11^2) + (y - features(2,class1(i))).^2/(2*h12^2))/(landa(i)^2);   
   V1   = V1 + 1/(h11*h12*landa(i)^2)*exp(-temp);
end

V1 = 1/(2*pi)*V1/n;

clear landa f_X g

fg1=figure(1);
subplot(121)
mesh(V1*P1)
%zlabel('P(H1)|P(x|H1)');
zlabel('Probability Target Dominant', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('ITD (ms)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('ILD (dB)', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'XTick',0:20:100);
set(gca, 'XTickLabel',linspace(region(1)*0.0625,region(2)*0.0625,length(0:20:100)));
set(gca, 'YTick',0:20:100);
set(gca, 'YTickLabel',linspace(region(3),region(4),length(0:20:100)));
subplot(122)
mesh(V0*P0)
%zlabel('P(H2)|P(x|H2)');
zlabel('Probability Masker Dominant', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('ITD (ms)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('ILD (dB)', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'XTick',0:20:100);
set(gca, 'XTickLabel',linspace(region(1)*0.0625,region(2)*0.0625,length(0:20:100)));
set(gca, 'YTick',0:20:100);
set(gca, 'YTickLabel',linspace(region(3),region(4),length(0:20:100)));
% set(fg1,'PaperPosition', [0 0 16 9])
% print(fg1,'-djpeg','bab4_probability_density_03010_500Hz.jpeg')


%%%%%%%%%%%%



% n=1;
% cfs(n)
% figure(1);
%     subplot(121);
%         scatter(RATIO(n,:),ITD(n,:));
%         xlabel('Relative Strength');
%         ylabel('Interaural Time Difference (ms)');
%         set(gca, 'YTick',-50:10:50);
%         set(gca, 'YTickLabel',linspace(-1,1,length(-50:10:50)));
%     subplot(122);
%         scatter(RATIO(n,:),ILD(n,:));
%         xlabel('Relative Strength');
%         ylabel('Interaural Level Difference (dB)');