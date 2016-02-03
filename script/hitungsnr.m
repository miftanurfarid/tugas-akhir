function [out,out2]=hitungsnr(target,masker,azimuth_target,azimuth_masker,pow)
% Menghitung SNR hasil pemisahan suara
%   target = jenis sinyal target, 'fena','mmht'
%   masker = jenis sinyal masker, 'fena','mmht'
%   azimuth_target/masker = lokasi azimuth target/masker
%   pow = snr target terhadap masker, (dB);

dir='D:\scene_farid\';
dire='\';
folder=sprintf('%starget_%s_masker_%s%st%dm%dpow%d',dir,target,masker,dire,azimuth_target,azimuth_masker,pow);
nomer='D:\berkas\tugas_akhir\nomer_kalimat.mat';
load(nomer);
snr_val=[];
for n=1:length(nomer_kalimat)
    kalimat=nomer_kalimat(n);
    if kalimat==455
    else
    sinyal_ori=sprintf('%s%s%s_%04d_ori.wav',folder,dire,target,kalimat);
    ori=audioread(sinyal_ori);
    sinyal_res=sprintf('%s%sresynth%s%s_%04d_resynth.wav',folder,dire,dire,target,kalimat);
    res=audioread(sinyal_res);
    val_snr=snr(ori,ori-res);
    snr_val=[snr_val val_snr];
%     nama_snr=sprintf('%s%snilai_snr_%04d.txt',folder,dire,kalimat);
%     save(nama_snr,'snr_val','-ascii');
    end
end

out = snr_val;
out2=mean(snr_val);
end

