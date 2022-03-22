function [varGAT] = vst_validation(img_noisy_Red, Tau, Lambda, Sigma_E, lamb_invert, M_img)

    %% Variance stabilization
    s = (double(img_noisy_Red(:,:,:)) - Tau)./Lambda;
    fz =2.*sqrt(s + 3/8 + Sigma_E^2);
    varGAT_prof = (var(fz,[],3));

    if lamb_invert == 1
        varGAT = mean2(varGAT_prof(round(M_img/2)-250:round(M_img/2)+250,end-500:end-100));    
    else
        varGAT = mean2(varGAT_prof(round(M_img/2)-250:round(M_img/2)+250,101:501));
    end

    if (varGAT <= 0.9) || (varGAT >= 1.1)
        disp('STABILIZATION ERROR!!!')
        disp(['GAT variance: ' num2str(varGAT)])
        return;
    else
        disp('CORRECT STABILIZATION!!!')
        disp(['GAT variance: ' num2str(varGAT)])
    end

end