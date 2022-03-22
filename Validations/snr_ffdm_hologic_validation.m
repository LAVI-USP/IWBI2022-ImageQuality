function [mean_snr_map, mean_snr_map_vct] = snr_ffdm_hologic_validation(z_GT, Stencil, img_noisy_100pcrt, mask_VCT, Tau)

%% Full Dose SNR (Real Phantom)
mean_snr_fd = mean(z_GT,3) - Tau;
std_snr_fd = sqrt(var(z_GT,[],3));
H=fspecial('average',15);
SNR_Map_Orig = imfilter(mean_snr_fd,H,'symmetric')./imfilter(std_snr_fd,H,'symmetric');
mean_snr_map = mean(SNR_Map_Orig(Stencil));
% imtool(SNR_Map_Orig.*Stencil,[])

%% Full Dose SNR (Simulated Phantom)
mean_snr_fd_vct = mean(img_noisy_100pcrt,3) - Tau;
std_snr_fd_vct = sqrt(var(img_noisy_100pcrt,[],3));
SNR_Map_Orig_vct = imfilter(mean_snr_fd_vct,H,'symmetric')./imfilter(std_snr_fd_vct,H,'symmetric');
mean_snr_map_vct = mean(SNR_Map_Orig_vct(mask_VCT));
% imtool(SNR_Map_Orig_vct.*mask_VCT,[])

disp('SNR FFDM Hologic (real x simulated phantoms)')
disp(['Real: ' num2str(mean_snr_map)])
disp(['Simulated: ' num2str(mean_snr_map_vct)])

end