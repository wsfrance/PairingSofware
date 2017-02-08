function [ answer, msg ] = contactUs(  )
%CONTACTUS Summary of this function goes here
%   Detailed explanation goes here

global option

prompt      = {'Enter your name:','Enter your email address', 'Enter your problem'};
dlg_title   = 'Contact us';
num_lines   = 1;
defaultans  = {option.userInfo.name, option.userInfo.email, 'my problem'};
answer      = inputdlg(prompt,dlg_title,num_lines,defaultans);




if isempty(answer) == 0
    disp('- Extract the date of now')
    formatOut = 'yyyy/mm/dd';
    date2 = datestr(datetime('today'),formatOut);

    disp('- Configure the mail adress to send :')
    recipients  = 'caotri.do88@gmail.com';
    subject     = [date2 ' Bug Report by ' answer{1} ' (' answer{2} ')' ];
    message     = answer{3};

    disp(['-- ' recipients])
    disp(['-- ' subject])
    disp(['-- ' message])

    disp('- Send with the Gmail adress pairing.software@gmail.com')
    try
        sendGmail( recipients, subject, message )
        msg = ['Report has been sent successfully to: ' recipients];
    catch
        msg = ['FAIL : Report cannot be sent to: ' recipients];
    end
else
    msg = '- User information are void. Quitting contact us';
    % disp(msg)
end

end

