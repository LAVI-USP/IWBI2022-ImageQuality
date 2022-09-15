# IWBI2022-ImageQuality
It contains the codes for the paper "Using virtual clinical trials to assess objective image quality metrics in the task of microcalcification localization in digital mammography", submitted to the IWBI 2022 conference. We used the OpenVCT from the University of Pennsylvania, available [here](https://sourceforge.net/p/openvct/wiki/Home/). We also used The Laboratory for Individualized Breast Radiodensity Assessment ([LIBRA](https://www.med.upenn.edu/sbia/libra.html)), a software package developed by the University of Pennsylvania.

Disclaimer: For education purposes only.

## Abstract:

Many works have investigated methods to assess the quality of mammography images using objective image quality metrics. However, few studies have evaluated the ability of these metrics to predict the performance of human observers on specific tasks related to mammographic examination that are highly dependent on image quality. The propose of this work is to evaluate the quality of digital mammography acquired at a range of radiation doses through a set of objective metrics and to compare the results with the performance of human observers in the task of locating microcalcification clusters in these images. A dataset of 100 synthetic mammograms was simulated using a virtual clinical trials software. Microcalcification clusters of different sizes and contrasts were computationally inserted into the images. Acquisitions with five different radiation doses were simulated using a noise injection method proposed in a previous work. Four medical physicists with experience in analysis of mammographic images participated in the microcalcification cluster localization tests. The quality of digital mammography images was assessed considering nine well-known objective metrics. The metrics were calculated on both the raw data (DICOM ‘for processing’ tag) and the processed images (DICOM ‘for presentation’ tag). Finally, the association between readers performance and image quality index was conducted by calculating the percentage variation of all metrics as a function of radiation dose, taking the standard dose as a reference. Although the Structural Similarity Index Measure (SSIM) and Peak Signal-to-Noise Ratio (PSNR) are the most used in the literature, our results showed that Quality Index based on Local Variance (QILV) is the objective metric that best describes the behavior of human visual perception with the variation of radiation dose in digital mammography.

## Reference:

If you use the codes, we will be very grateful if you refer to this [paper](http://dx.doi.org/10.1117/12.2625745):

Lucas E. Soares, Lucas R. Borges, Bruno Barufaldi, Andrew D. A. Maidment, Marcelo A. C. Vieira, "Using virtual clinical trials to assess objective image quality metrics in the task of microcalcification localization in digital mammography," Proc. SPIE 12286, 16th International Workshop on Breast Imaging (IWBI2022), 1228603 (13 July 2022); https://doi.org/10.1117/12.2625745

```
@inproceedings{10.1117/12.2625745,
author = {Lucas E. Soares and Lucas R. Borges and Bruno Barufaldi and Andrew D. A. Maidment and Marcelo A. C. Vieira},
title = {{Using virtual clinical trials to assess objective image quality metrics in the task of microcalcification localization in digital mammography}},
volume = {12286},
booktitle = {16th International Workshop on Breast Imaging (IWBI2022)},
editor = {Hilde Bosmans and Nicholas Marshall and Chantal Van Ongeval},
organization = {International Society for Optics and Photonics},
publisher = {SPIE},
pages = {1228603},
keywords = {Digital mammography, Image quality assessment, Virtual clinical trials, Human observer study},
year = {2022},
doi = {10.1117/12.2625745},
URL = {https://doi.org/10.1117/12.2625745}
}
```

## Acknowledgments:

This work was supported in part by the São Paulo Research Foundation ([FAPESP](http://www.fapesp.br/) grant 2021/12673-6). The authors would also like to thank Real Time Tomography for providing access to the image processing software, and the team of medical physicists who volunteered to participate in the stair-case and localization studies.

---
Laboratory of Computer Vision ([Lavi](http://iris.sel.eesc.usp.br/lavi/))  
Department of Electrical and Computer Engineering  
São Carlos School of Engineering, University of São Paulo  
São Carlos - Brazil
