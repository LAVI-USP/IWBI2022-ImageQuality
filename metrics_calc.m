function [mnse, res_noise, bias, ssim_index, qilv_index, naqi_index, psnr_index, snr_index, uiqi_index, piqe_index, brisque_index, niqe_index] = metrics_calc(phanVCT, mask_VCT, img_noisy_Red)
    addpath('Metrics')
    mnse=1;
    res_noise=0;
    bias=0;
    ssim_index=1;
    qilv_index=1;
    naqi_index=1;
    psnr_index=1;
    snr_index=1;
    uiqi_index=1;
    piqe_index=1;
    brisque_index=1;
    niqe_index=1;
    
    %%
    for k=1:size(img_noisy_Red,3)
        Img = img_noisy_Red(:,:,k);
        ImgNoisy(:,:,k) = reshape(polyval(polyfit(Img(mask_VCT),phanVCT(mask_VCT),1),Img),size(phanVCT));
        Img_temp = ImgNoisy(:,:,k);
        img_noisy_norm(:,:,k) = mat2gray(Img_temp, [min(Img_temp(mask_VCT)) max(Img_temp(mask_VCT))]);
    end
    noisy_red = img_noisy_norm(:,:,1);

    %% GT Normalization
    phanVCT_norm = mat2gray(phanVCT, [min(phanVCT(mask_VCT)) max(phanVCT(mask_VCT))]);

    %% MNSE
    if mnse==1 || res_noise==1 || bias==1
        [mnse, res_noise, bias] = calcMNSE(phanVCT,mask_VCT,img_noisy_Red);
    end

    %% SSIM
    if ssim_index==1
        [ssim_index] = calcSSIM(phanVCT_norm,mask_VCT,img_noisy_norm);
    end

    %% QILV
    if qilv_index==1
        qilv_index=qilv_a(phanVCT,Img_temp,0,mask_VCT);
    end

     %% NAQI
     if naqi_index==1
        addpath('Metrics\aqi')

        se = strel('disk',20);
        Mask=imerode(mask_VCT,se);
        [~,naqi_index,~]=aqindex_mask(Img_temp,16,4,0,'degree','gray',Mask);
     end

    %% PSNR
    if psnr_index==1
        [psnr_index, snr_index] = psnr(Img_temp(mask_VCT)-50,phanVCT(mask_VCT)-50,max(Img_temp(mask_VCT)-50));
    end
    
    %% UIQI
    if uiqi_index==1
        [~, uiqi_map] = img_qi(noisy_red, phanVCT_norm);
        uiqi_index = mean(uiqi_map(uiqi_map~=1));
    end
    
    %% PIQUE
    if piqe_index==1
        piqe_index = piqe(Img_temp(mask_VCT));
    end
    
    %% BRISQUE
    if brisque_index==1
        brisque_index = brisque(noisy_red);
    end
    
    %% NIQE
    if niqe_index==1
        niqe_index = niqe(noisy_red);
    end
end