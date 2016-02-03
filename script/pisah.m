function pisah
% pisah.m - pisah data suara target dari masker berdasarkan data training
% yang sudah ada.
tic
azimuth_target=0;
azimuth_masker=30;
pow=0;
gender_target='mmht';
gender_masker='fena';
%% Data training

[ITD,ILD,RATIO]=kumpulkandata(azimuth_target,azimuth_masker,pow);

%% Mapping
dire='/';
dir_map = sprintf('t%dm%dpow%d%s',azimuth_target,azimuth_masker,pow,dire);
mkdir(dir_map);
mapping_name = sprintf('%smappingt%dm%dpow%d',dir_map,azimuth_target,azimuth_masker,pow);
decisionrules(ITD,ILD,RATIO,mapping_name);

%% Pisah data suara
fprintf('Proses data TA Mifta\nPemisahan Data Suara...');
load nomer_kalimat
indeks_nomer_suara=nomer_kalimat;
load(mapping_name);
for n=1:length(indeks_nomer_suara)
    nomer_suara=indeks_nomer_suara(n);
    fprintf('%02d%%',floor((nomer_suara-320)/(500-320)*100));
    s1 = sprintf('wav%s%s%s%s_%04d.wav',dire,gender_target,dire,gender_target,nomer_suara);
    target = wavread(s1);
    nomer_masker=320;
    s2 = sprintf('wav%s%s%s%s_%04d.wav',dire,gender_masker,dire,gender_masker,nomer_masker);
    masker = wavread(s2);
    target=resample(target,16000,48000);
    masker=resample(masker,16000,48000);
    [itd,ild,campur_kiri,kiri] = lakukanbinaural(target,masker,azimuth_target,azimuth_masker,pow);
    ebmask = makeMask(itd,ild,Region,D);
    resynth=synthesis(campur_kiri,ebmask);
    nama_resynth=sprintf('%s%s_%04d_resynth.wav',dir_map,gender_target,nomer_suara);
    nama_asli=sprintf('%s%s_%04d_ori.wav',dir_map,gender_target,nomer_suara);
    resynth = resynth./(max(abs(resynth*2)));
    kiri = kiri./(max(abs(kiri*2)));
    wavwrite(resynth,16000,nama_resynth);
    wavwrite(kiri,16000,nama_asli);
    addpath('PESQ');
    pval=pesq(nama_asli,nama_resynth);
    nama_pval=sprintf('%s%s_%04d_pesq_val.txt',dir_map,gender_target,nomer_suara);
    save(nama_pval,'pval','-ascii');
    fprintf('\b\b\b');
    
    
end
fprintf('\bSelesai!\n');
toc
end
