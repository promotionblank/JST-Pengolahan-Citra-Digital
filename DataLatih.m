clc; clear; close all; warning off all;
 
image_folder = 'data latih';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);
 
data_latih = zeros(6,total_images);
 
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
     
    % Pembentukan data latih
    data_latih(1,n) = CiriR;
    data_latih(2,n) = CiriG;
    data_latih(3,n) = CiriB;
    data_latih(4,n) = CiriMEAN;
    data_latih(5,n) = CiriENT;
    data_latih(6,n) = CiriVAR;
end

% Pembentukan target latih
target_latih = ones(1,total_images);
target_latih(1:total_images/2) = 0;
 
% performance goal (MSE)
error_goal = 1e-6;
 
% choose a spread constant
spread = 1;
 
% choose max number of neurons
K = 5;
 
% number of neurons to add between displays
Ki = 20;
 
% create a neural network
net = newrb(data_latih,target_latih,error_goal,spread,K,Ki);
 
% Proses training
net.trainFcn = 'traingdx';
[net_keluaran,tr,~,E] = train(net,data_latih,target_latih);
 
save net_keluaran net_keluaran
 
% Hasil identifikasi
hasil_latih = round(sim(net_keluaran,data_latih));
[m,n] = find(hasil_latih==target_latih);
akurasi = sum(m)/total_images*100