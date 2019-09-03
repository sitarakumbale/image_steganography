%% DWT Algorithm implemented to Hide Text in an imgage
% DSP Lab Project by Sitara Kumbale (16EE248) and Adarsh Malapaka
% (16EE129)
clc;
clear all;
%% Specify the Cover Image, Text to Hide and Wave Transform Type
im=imread ('CMCK.jpg'); %Input the Cover Image
dataToHide = 'Hello';    %Input the Text message to hide
wavename = 'haar';   %Waveform type for DWT

figure()
imshow(im);
title('Original Image');  %Display Original Image

%% Process the Text Data to Encrypt it easily
data = zeros(1,length (dataToHide)); %Convert the Text Characters into their corresponsing ASCII Values
for i =1 : length(dataToHide);
    d = dataToHide (i)+0;
    data (i) = d;
end

 M=max(data);
 normalize = data/M; %Text ASCII values are normalized
 n=length(data);

 %% Implement DWT on the Image and perform Steganography
 tic
 [cA1, cH1,cV1, cD1]= dwt2(im,wavename); %Perform Discrete Wavelet Transform on the Image
 cH1(1,1) = -1*(n/10);
 cH1(1,2) = -1*(M/10);

[~ , y] =size(cH1);

 for i = 1 : ceil(n/2)
     cV1(i,y) = normalize(i);
 end

 for i= ceil(n/2)+1 :n;
    cD1(i,y) = normalize(i);
 end

stg_img=idwt2(cA1,cH1,cV1,cD1,wavename); %Apply inverse DWT on the coeffecients to get the steganographically altered image 
toc
figure()
subplot(2,1,1)
imshow(im);
title('Original Image');  %Display Original Image
subplot(2,1,2)
imshow(uint8(stg_img));
title('Steganographically Altered Image'); %Display Steganographic Image

figure()
imshow(uint8(stg_img));
title('Steganographically Altered Image'); %Display Steganographic Image

imwrite(uint8(stg_img), 'StegImage_DWT.bmp','BMP');

%% Measure the performance of the DWT encoding algorithm

[a,b,c]=size(im);
ms=abs(stg_img(1:a,1:b,1)-double(im(:,:,1)));
ms=ms.*ms;
ms=mean(mean(ms)); %Calculate Mean Square Error

ps=(255*255)/ms;
ps=10*log10(ps); %Calculate PSNR
%% Perform DWT to get the coefficients of the steganographically altered image and obtain normalized hidden data
tic
[cA11,cH11,cV11,cD11] = dwt2(stg_img,wavename);

n1=abs(cH11(1,1)*10); %Length of the Hidden Data
M1=abs(cH11(1,2)*10); %Maximum Value of Hidden Data

for i=1:ceil(n1/2)
    data_normalize(i)=cV11(i,y);
end

for i=ceil(n1/2)+1:n1+1
    data_normalize(i)=cD11(i,y);
end
toc
%% Obtain hidden data from the normalized data
msg='';
data1=uint8(data_normalize*M1);
char(data1)
