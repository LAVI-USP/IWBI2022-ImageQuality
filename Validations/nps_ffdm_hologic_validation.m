function [] = nps_ffdm_hologic_validation(params_fd, Tau_nominal, Ke)

%% FFDM Hologic NPS (real x simulated uniform image)
ImgPath='Validations';
uniforme_real = double(dicomread([ImgPath '/MG03']));
uniforme_real=fliplr(uniforme_real);
uniforme_real=uniforme_real(1025:end-1024,1537:end);
H=fspecial('average',80);
uniforme_real_gt=imfilter(uniforme_real,H,'symmetric');
% imtool(uniforme_real_gt,[]);

Lambda_nps=params_fd.Lambda_e(1025:end-1024,1537:end);

ImgPath='Validations';
uniforme_simulada_vct = double(dicomread([ImgPath '/phPMMA25x4x29cm_gain0.17_propconst0.003_kVp31_mAs30_nonoise_noinvsq_7.dcm']));
% imtool(uniforme_simulada_vct,[]);

img_uniforme_simulada=reshape(polyval(polyfit(uniforme_simulada_vct,uniforme_real_gt,1),uniforme_simulada_vct),size(uniforme_real_gt));
img_noisy_uniforme_100_dose = NoiseInsert(img_uniforme_simulada,params_fd.Sigma_E,Lambda_nps,Tau_nominal,Ke);
% imtool(img_noisy_uniforme_100_dose,[]);

addpath('Metrics\NPS')
[~, NNPS1D_S, f1D_S] = NPS_FAB(img_noisy_uniforme_100_dose, 256, 0.07, 0, 0); %Hologic
[~, NNPS1D_R, f1D_R] = NPS_FAB(uniforme_real, 256, 0.07, 0, 0); %Hologic
figure
semilogy(f1D_R(2:end),NNPS1D_R(2:end),'--')
hold on
semilogy(f1D_S(2:end),NNPS1D_S(2:end),'*')
legend('Real','Simulated')  
title('Real x Simulated NNPS (Uniform Image)')
axis([0 10 10^-7 10^-5])
xlabel('Frequency (cycles/mm)')
ylabel('NNPS (mm²)')

end