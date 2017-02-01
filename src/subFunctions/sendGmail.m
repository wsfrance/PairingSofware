function [ ] = sendGmail( recipients,subject,message, attachments )
%SENDGMAIL Summary of this function goes here
%   Detailed explanation goes here
% Define these variables appropriately:


mail = 'pairing.software@gmail.com'; %Your GMail email address
password = 'pairing2016'; %Your GMail password

% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

if nargin < 4
    sendmail(recipients,subject,message)
else
    sendmail(recipients,subject,message, attachments)
end

end

