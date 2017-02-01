function MouseClickHandler(obj,evt)
persistent chk
if isempty(chk)
      chk = 1;
      pause(1); %Add a delay to distinguish single click from a double click
      if chk == 1
          fprintf(1,'\nI am doing a single-click.\n\n');
          chk = [];
      end
else
      chk = [];
      fprintf(1,'\nI am doing a double-click.\n\n');
end

% function MouseClickHandler(handle,cbData)
% % handle ~ java object UITablePeer
% % cbData ~ callback data for the MouseClickedCallback event
% 
%     switch get(cbData,'ClickCount')
%         case 1
%             % SingleClickHandler(handles,cbData);
%             disp('1 click')
%         case 2
%             % DoubleClickHandler(handles,cbData);
%             disp('2 click')
%         otherwise
%             % unhandled for now
%     end
% end

% function main()
%     h=figure;
%     table = uitable;
%     set(table,'Data',rand(3))
%     
%     uitablepeer = findjobj(h, '-nomenu', 'class', 'uitablepeer');
%     set(uitablepeer,'MouseClickedCallback',@MouseClickHandler)
% end