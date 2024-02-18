clc; clear; close all;
 
image_folder = 'data uji';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);
 
data_uji = zeros(6,total_images);
 
for n = 1:total_images
    full_name= fullfile(image_folder, filenames(n).name);
    Img = imread(full_name);
    Img = im2double(Img);
     
    % Ekstraksi Ciri Warna RGB
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
     
    CiriR = mean2(R);
    CiriG = mean2(G);
    CiriB = mean2(B);
     
    % Ekstraksi Ciri Tekstur Filter Gabor
    I = (rgb2gray(Img));
    wavelength = 4;
    orientation = 90;
    [mag,phase] = imgaborfilt(I,wavelength,orientation);
     
    H = imhist(mag)';
    H = H/sum(H);
    I = [0:255]/255;
     
    CiriMEAN = mean2(mag);
    CiriENT = -H*log2(H+eps)';
    CiriVAR = (I-CiriMEAN).^2*H';
     
    % Pembentukan data uji
    data_uji(1,n) = CiriR;
    data_uji(2,n) = CiriG;
    data_uji(3,n) = CiriB;
    data_uji(4,n) = CiriMEAN;
    data_uji(5,n) = CiriENT;
    data_uji(6,n) = CiriVAR;
end
 
% Pembentukan target uji
target_uji = ones(1,total_images);
target_uji(1:total_images/2) = 0;
 
load net_keluaran
hasil_uji = round(sim(net_keluaran,data_uji));
 
[m,n] = find(hasil_uji==target_uji);
akurasi = sum(m)/total_images*100