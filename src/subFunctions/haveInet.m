function tf = haveInet()
% return 0 (false) is no internet and 1 (true) if there is an internet
% connection
  tf = false;
  try
    address = java.net.InetAddress.getByName('www.google.fr');
    tf = true;
  end
end