%% Test QR encoding and decoding
%
% Please download and build the core and javase parts of zxing
% from here - http://code.google.com/p/zxing/
%
% javaaddpath('.\3rd_party\zxing-1.6\core\core.jar');
% javaaddpath('.\3rd_party\zxing-1.6\javase\javase.jar');

javaaddpath('QRCodeGenerator1.1\qrcode_gen\jarfiles\core-3.2.0.jar');
javaaddpath('QRCodeGenerator1.1\qrcode_gen\jarfiles\javase-3.2.0.jar');

% encode a new QR code
test_encode = encode_qr('la la la', [32 32]);
figure;imagesc(test_encode);axis image;

% decode
message = decode_qr(imread('test_qr.jpg'));
