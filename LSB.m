 clear
 clc
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Encoding Process

 msg = 'Hello'; % Secret message to be hidden
 enc_key=uint8(377);  %encryption key; addition of our roll numbers = 377
 img = imread('CMCK.jpg'); %Reading the cover image file; three images are there for three different sizes
 
 tic  %to find execution time of encoding process
  msg_temp = double(msg);     % Converting from ASCII to Integer Values.
    msg_dim = num2str(length(msg_temp)); %Converting to String
    msg_length = length(msg_dim);
    k = 0;
    if msg_length < 7
        padtext = 7 - msg_length;
        for k = 1:padtext
            msg_dim = horzcat('0',msg_dim); % Zero padding the message 
        end
        
        msg_temp_head = horzcat(msg_dim,msg_temp);  % Attaching the dimension to the beginning of the message to be hidden.
    end
    
msg_enc = bitxor(uint8(msg_temp_head),uint8(enc_key)); % Encrypting the message with enc_key using XOR

msg_enc_set = dec2bin(msg_enc, 8);  %converting the encrypted message into an 8-bit binary number

img_prep = im2uint8(img); %Hiding or Cover image 


%Using RGBBGRRG order to hide message in the hiding image pixel by pixel

rm = 1; gm = 1; bm = 1;     % Counters for the corresponding R, G and B pixels 
rn = 1; gn = 1; bn = 1;

[maxM,maxN] = size(img_prep);
k = 0;

run_time = length(msg_enc_set); % indicates the number of Message "Words" that need to be encoded in the hiding image

for k = 1:run_time;
    temp_code = msg_enc_set(k,:);
    % Bit 1: Red
    if str2double(temp_code(1)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    
    rm = rm + 1;
    if rm > maxM    %to determine whether or not we have reached the end of the image
        rn = rn + 1;
        rm = 1;
    end
    % Bit 2: Green
    if str2double(temp_code(2)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    % Bit 3: Blue
    if str2double(temp_code(3)) == 0
        img_prep(bm,bn,3) = bitand(img_prep(bm,bn,3),uint8(254));
    else
        img_prep(bm,bn,3) = bitor(img_prep(bm,bn,3),uint8(1));
    end
    
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Bit 4: Blue
    if str2double(temp_code(4)) == 0
        img_prep(bm,bn,3) = bitand(img_prep(bm,bn,3),uint8(254));
    else
        img_prep(bm,bn,3) = bitor(img_prep(bm,bn,3),uint8(1));
    end
    
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Bit 5: Green
    if str2double(temp_code(5)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    % Bit 6: Red
    if str2double(temp_code(6)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
    % Bit 7: Red
    if str2double(temp_code(7)) == 0
        img_prep(rm,rn,1) = bitand(img_prep(rm,rn,1),uint8(254));
    else
        img_prep(rm,rn,1) = bitor(img_prep(rm,rn,1),uint8(1));
    end
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
    end
    % Bit 8: Green
    if str2double(temp_code(8)) == 0
        img_prep(gm,gn,2) = bitand(img_prep(gm,gn,2),uint8(254));
    else
        img_prep(gm,gn,2) = bitor(img_prep(gm,gn,2),uint8(1));
    end
    
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
    end
    
end

J = img_prep;       % Altered image
toc %end of encoding execution time 

imwrite(J,'small_LSB_alter.bmp','BMP');

[a,b,c]=size(img);
ms=abs(J(1:a,1:b,1)-img(:,:,1));
ms=ms.*ms;
ms=mean(mean(ms)); %to calculate Mean Square Error

ps=(255*255)/ms;
ps=10*log10(ps) %to calculate PSNR

subplot(2,1,1)
imshow('CMCK.jpg');
title('Original Image')
subplot(2,1,2)
imshow('small_LSB_alter.bmp');
title('Steganographically Altered Image')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Decoding Process

enc_key = uint8(377); %same encryption key as encoding
img=imread('small_LSB_alter.bmp');

tic  %start of decoding execution time
rm = 1; gm = 1; bm = 1;     % Counters for the corresponding R, G and B pixels 
rn = 1; gn = 1; bn = 1;

header = [];
[maxM, maxN] = size(img);

for z = 1:7;
    temp = zeros(1,8);
    % Red    
    temp(1,1) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
        if rm > maxM  %to determine whether or not we have reached the end of the image
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Green
    temp(1,2) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    % Blue
    temp(1,3) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Blue
    temp(1,4) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Green
    temp(1,5) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    % Red    
    temp(1,6) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Red    
    temp(1,7) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Green
    temp(1,8) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end      
    tempstr = num2str(temp);
    header = vertcat(header,tempstr);
end

msg_head_set = bin2dec(header);  %decrypting the message based on the dimension attached in the beginning
temp_head = bitxor(uint8(msg_head_set),uint8(enc_key));

    dim1 = char(temp_head(1:7));
    m = str2double(dim1);
      
z = 0;

enc_msg = [];
% to reverse the RGBBGRRG process using MODULO arithmetic.
for z = 1:m
    temp = zeros(1,8);
    % Red    
    temp(1,1) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
       if rm > maxM  %to determine whether or not we have reached the end of the image
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Green
    temp(1,2) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    % Blue
    temp(1,3) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Blue
    temp(1,4) = mod(img(bm,bn,3),2);
    bm = bm + 1;
    if bm > maxM
        bn = bn + 1;
        bm = 1;
    end
    % Green
    temp(1,5) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end
    % Red    
    temp(1,6) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Red    
    temp(1,7) = mod(img(rm,rn,1),2);    
    rm = rm + 1;
    if rm > maxM
        rn = rn + 1;
        rm = 1;
        if rn > maxN
            break
        end
    end
    % Green
    temp(1,8) = mod(img(gm,gn,2),2);
    gm = gm + 1;
    if gm > maxM
        gn = gn + 1;
        gm = 1;
        if gn > maxN
            break
        end
    end      
    tempstr = num2str(temp);
    enc_msg = vertcat(enc_msg,tempstr);
end

msg_dec_set = bin2dec(enc_msg);  %decryption 
msg_dec = bitxor(uint8(msg_dec_set),uint8(enc_key));

msg_set = msg_dec;
 msg_out = char(msg_set');

msg = msg_out %final decoded message

toc %stop of decoding execution time
