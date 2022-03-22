function [Results] = calcSSIM(GT,mask,img_noisy)
rl=size(img_noisy,3);
for k=1:rl
    [~, ssimmap] = ssim(img_noisy(:,:,k),GT);
    ssim_mask(k) = mean(ssimmap(mask));
%     imtool(ssimmap,[]);
end

Results=mean(ssim_mask);

end