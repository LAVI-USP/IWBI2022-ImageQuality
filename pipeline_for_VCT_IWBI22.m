close all
clear
clc

%% Main Parameters
lesion = 1;
full_dose = 0;
validation = 0; % full_dose must be 1
metrics = 1;

%% Noise Parameters
addpath('Parameters')

% OFFSET
Tau = 50;

% HOLOGIC KERNEL
load('Kernel_Hologic_FFDM')

% RADIATION DOSE LEVELS
% 50% ---> 0.5
doses = [2; 1.5; 1; 0.5; 0.25];

% REALIZATIONS
realizations = 10;

%% Microcalcifications contrast
% Contrast=0.4;
% for k=2:15
%     Contrast(k)=Contrast(k-1)*0.85;
% end
Contrast=0.068;

%% Images
ImgFolder = ['Phantoms'];
theFiles = dir(fullfile(ImgFolder, '*.dcm'));

for im = 1:length(theFiles)
    disp('1º Image reading...')
    fullFileName = fullfile(theFiles(im).folder, theFiles(im).name);
    phanVCT = double(dicomread(fullFileName)) - Tau;
    
    %% Noise parameters
    for d=1:length(doses)
        Reduc = doses(d);
        if Reduc == 1
            load('Parameters_Hologic_FFDM_160mAs');
        elseif Reduc == 0.87
            load('Parameters_Hologic_FFDM_140mAs');
        elseif Reduc == 0.75
            load('Parameters_Hologic_FFDM_120mAs');
        elseif Reduc == 0.50
            load('Parameters_Hologic_FFDM_80mAs');
        else
            load('Parameters_Hologic_FFDM');
        end

        %% Lambda adjustment
        disp('2º Noise parameters adjustment...')
        [M_img N_img] = size(phanVCT);
        [M_Lamb N_Lamb] = size(Lambda_e);

        dif_M = abs(M_Lamb - M_img);
        dif_N = abs(N_Lamb - N_img);

        % Breast position
        med1 = mean2(phanVCT(:,1:round(N_img/2)));
        med2 = mean2(phanVCT(:,round(N_img/2):end));

        if med1 > med2
            % Reduced dose
            Lambda_e = Lambda_e(1+fix(dif_M/2):end-ceil(dif_M/2),1+dif_N:end);
            Lambda = fliplr(Lambda_e);
            lamb_invert = 1;
            
            % QUANTUM AND ELECTRONIC NOISE HOLOGIC (FULL-DOSE)
            if full_dose == 1 && d == 1
                % Full-dose
                params_fd = load('Parameters_Hologic_FFDM_160mAs');
                Lambda_e_fd = params_fd.Lambda_e(1+fix(dif_M/2):end-ceil(dif_M/2),1+dif_N:end);
                params_fd.Lambda_e = fliplr(Lambda_e_fd);
            end
        else
            % Reduced dose
            Lambda_e = Lambda_e(1+fix(dif_M/2):end-ceil(dif_M/2),1:end-dif_N);
            Lambda = Lambda_e;
            lamb_invert = 0;

            if full_dose == 1 && d == 1
                % Full-dose
                params_fd = load('Parameters_Hologic_FFDM_160mAs');
                Lambda_e_fd = params_fd.Lambda_e(1+fix(dif_M/2):end-ceil(dif_M/2),1:end-dif_N);
                params_fd.Lambda_e = Lambda_e_fd;
            end
        end

        clear N_img M_Lamb N_Lamb dif_M dif_N med1 med2 Lambda_e Lambda_e_fd

        %% Gray level correction
        if d == 1
            disp('3º Gray level correction...')
            
            % -------------- REAL PHANTOM ------------------
            ImgPath='Anthro_Raw';

            % GT
            ind = 1;
            for k=1:2:21
                if(k~=3)
                    z_GT(:,:,ind)=double(dicomread([ImgPath '/160_mAs/160_' num2str(k,'%02d') '_Mammo_R_CC.dcm']));
                    ind = ind + 1;
                end
            end

            gt_real = mean(z_GT,3) - Tau;
            Stencil=imerode(gt_real<7000,strel('disk',20));
            real_roi = gt_real(1500:1500+250,100:100+250);
            meanPixelReal = mean2(nonzeros(real_roi));

            % ----------- VIRTUAL PHANTOM ------------------

            mask_VCT=phanVCT<1300;
            
            if lamb_invert
                vct_roi = phanVCT(2130:2130+250,2848:2848+250);
            else
                vct_roi = phanVCT(2130:2130+250,250:250+250);
            end
            meanPixelVCT = mean2(nonzeros(vct_roi));

            % ----------------------------------------------

            fator = meanPixelReal / meanPixelVCT;
            phanVCT = phanVCT .* fator;

            clear ImgPath ind k gt_real real_roi meanPixelReal
            clear vct_roi meanPixelVCT fator
        
            %% Lesion insertion
            if lesion == 1
                disp('4º Lesion insertion...')

                % LIBRA
                addpath('LesionInsert')
                [res] = LibraAnalysis(fullFileName,ImgFolder);

                disp('5º Inserção de lesão...')
                ImgOutput = [ImgFolder '\Images_Output\']; mkdir(ImgOutput);

                addpath('LesionInsert')
                [ImgL,SimulationInfo] = LesionInsert(phanVCT,Contrast,res,1,fullFileName,ImgOutput);
                
                ImgL = double(ImgL);
                
                for c=1:length(Contrast)
                    phanVCT = ImgL(:,:,c);
                end

                clear ImgOutput res newfolder k
            end
        end

        %% Noise insertion
        disp('4º Noise insertion...')      

        if lesion == 1
            if full_dose == 1 && d == 1
                % Full-dose
                for i=1:realizations
                    [img_noisy_100pcrt(:,:,i)] = NoiseInsert(ImgL(:,:,1),params_fd.Sigma_E,params_fd.Lambda_e,Tau,Ke);
                end
            end

            % Reduced/increased dose
            for c=1:length(Contrast)
                phanVCT_Red = ImgL(:,:,c).*Reduc;
                
                for i=1:realizations
                    [img_noisy_Red(:,:,i,c)] = NoiseInsert(phanVCT_Red,Sigma_E,Lambda,Tau,Ke);
                end
            end
        else
            if full_dose == 1 && d == 1
                % Full-dose
                for i=1:realizations
                    [img_noisy_100pcrt(:,:,i)] = NoiseInsert(phanVCT,params_fd.Sigma_E,params_fd.Lambda_e,Tau,Ke);
                end
            end

            % Reduced/increased dose
            phanVCT_Red = phanVCT.*Reduc;
            for i=1:realizations
                [img_noisy_Red(:,:,i)] = NoiseInsert(phanVCT_Red,Sigma_E,Lambda,Tau,Ke);
            end
        end
        clear mask phanVCT_Red i

        %% Signal and noise validations
        if validation == 1
            disp('5º Signal and noise validations...')

            %% Variance stabilization
            addpath('Validations')
            [varGAT] = vst_validation(img_noisy_Red, 0, Lambda, Sigma_E, lamb_invert, M_img);

            %% SNR FFDM Hologic (real x simulated phantoms)
            [mean_snr_map, mean_snr_map_vct] = snr_ffdm_hologic_validation(z_GT, Stencil, img_noisy_100pcrt, mask_VCT, 0);

            if full_dose == 1
                %% FFDM Hologic NPS (real x simulated uniform images)
                nps_ffdm_hologic_validation(params_fd, Tau, Ke);
            end
        end
        clear M_img z_GT Stencil

        %% Objective metrics
        if metrics == 1
            disp('6º Objective quality metrics...')
            
            img_noisy_Red = img_noisy_Red./Reduc;
            
            if lesion == 0
                [mnse_noisy(im,d), res_noise_noisy(im,d), bias_noisy(im,d), ssim_index_noisy(im,d), qilv_index_noisy(im,d), naqi_index_noisy(im,d), psnr_index_noisy(im,d), snr_index_noisy(im,d), uiqi_index_noisy(im,d), piqe_index_noisy(im,d), brisque_index_noisy(im,d), niqe_index_noisy(im,d)] = metrics_calc(phanVCT, mask_VCT, img_noisy_Red);
            end
            
            if lesion == 1
                for c=1:length(Contrast)
                    [mnse_noisy(im,d,c), res_noise_noisy(im,d,c), bias_noisy(im,d,c), ssim_index_noisy(im,d,c), qilv_index_noisy(im,d,c), naqi_index_noisy(im,d,c), psnr_index_noisy(im,d,c), snr_index_noisy(im,d,c), uiqi_index_noisy(im,d,c), piqe_index_noisy(im,d,c), brisque_index_noisy(im,d,c), niqe_index_noisy(im,d,c)] = metrics_calc(ImgL(:,:,c), mask_VCT, img_noisy_Red(:,:,:,c));
                end
            end
        end
    end
end