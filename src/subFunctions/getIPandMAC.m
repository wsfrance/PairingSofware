function [MyExternalIP, linkIPLocation, mac, bool_getIP] = getIPandMAC()

disp('- Get IP Adress')
try
    MyExternalIP = regexp(urlread('http://checkip.dyndns.org'),'(\d+)(\.\d+){3}','match');
    linkIPLocation = ['http://www.infosniper.net/index.php?ip_address=' ...
                      MyExternalIP ...
                      '&map_source=1&overview_map=1&lang=1&map_type=1&zoom_level=7'];
    linkIPLocation = strjoin(linkIPLocation,'');
    bool_getIP = true;          
catch
    warning('No internet connection !')
    MyExternalIP = {'NoIP'};
    linkIPLocation = 'NoIP';
    bool_getIP = false;
end

disp('- Get Mac Adress of the Machine')
[status,result] = dos('getmac');
mac = result(160:176);