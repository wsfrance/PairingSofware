function [ subtable, msg ] = qrcode_reader_Cao( img )
%QRCODE_READER_CAO Summary of this function goes here
%   Detailed explanation goes here

% imread('cQT475.png')

msg = decode_qr(img);
C = strsplit(msg,';');
for i = 1:length(C)
    tmp = strsplit(C{i},':');
    D(:,i) = tmp;
end
variableName=D(1,:);
data = D(2:end,:);
subtable = cell2table(data,'Variable',variableName);


end

