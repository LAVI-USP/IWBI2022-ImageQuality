function [ProjNoisyOffset] = NoiseInsert(phantomVCT,sigmaE,alpha,tau,K)

poissonNoise = sqrt(alpha.*phantomVCT) .* gather(imfilter(gpuArray(randn(size(phantomVCT))),K,'symmetric')); %randn(size(phantomVCT));

electronicNoise = sigmaE .* randn(size(phantomVCT));

imageNoisePoissonGaussian = phantomVCT + poissonNoise + electronicNoise;

ProjNoisyOffset= imageNoisePoissonGaussian; %+ tau;

end

