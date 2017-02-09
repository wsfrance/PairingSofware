function printPlayerSlips(TABLE,option)
% Make player slips

    disp('- Quit the Application')
    quitApplication ();
    
    warning('off','all')
    % Delete old pdf files in \subPDF
    % delete('export/subPDF/*.pdf')
    output = ['PlayerSlips_Round_' num2str(option.no_round) '.pdf'];
    new_file = ['export/' output];
    delete(new_file)
    
    % Load template
    A = imread('slips_template1.png');
    B = imread('slips_template2.png');
    
    % Allocate Matrice
    RGB = cell(4,1);
    counter = 1;
    id_count = 1;
    % Loop to generate the slips and create PDFs
    nb_table = size(TABLE.pairingTable, 1);
    for i = 1:nb_table
        % Create texts
        name_player1 = TABLE.pairingTable.Player1{i};
        name_player2 = TABLE.pairingTable.Player2{i};
        tournament_name = 'Tournament Name';
        no_table = sprintf('%03d',TABLE.pairingTable.Table(i));
        tableNo = ['Table ' num2str(TABLE.pairingTable.Table(i))];
        stringTableNumber = ['(' no_table ')'];
        roundNo = ['Round no.' num2str(option.no_round)];
        dateTournament = option.tournamentInfo.date;
        text_str = {name_player1, name_player2, name_player1, name_player2, tournament_name, tableNo, stringTableNumber, roundNo, dateTournament};

        % Define the positions of the text boxes.
        position = [232 500; 1105 500; 443 228; 443 307; 53 60; 53 98; 812 120; 1400 60; 1400 98];

        RGB{id_count} = insertText(A,position,text_str,'FontSize',22,'AnchorPoint','LeftBottom');
        id_count = id_count +1;
        
        % Last page, fill with blancks
        if i == nb_table &&  mod(i,4) ~= 0
            for j = id_count:4
                RGB{j} = B;
            end
        end
        
        % Every 4 slips, generate a PDF file
        if mod(i,4) == 0 || i == nb_table
            new_image = [RGB{1};RGB{2};RGB{3};RGB{4}];
            input_list{counter} = ['tmpPlayerSlips_' num2str(counter) '.pdf'];
            filename = ['/' input_list{counter}];
            printingPDFSlips(new_image, filename)
            counter = counter +1;
            RGB = cell(4,1);
            id_count = 1;
        end
    end

    % Assemble all pdf into one file
    append_pdfs(output, input_list{:})
    movefile(output,new_file, 'f')
    delete('*.pdf')
    winopen(new_file)
    warning('on','all')
end

function printingPDFSlips(new_image, filename)
    % centimeters units
    X = 21; % 42.0;                  % A3 paper size
    Y = 29.7; % 29.7;                  % A3 paper size
    xMargin = 0;               % left/right margins from page borders
    yMargin = 0.5;               % bottom/top margins from page borders
    xSize = X - 2*xMargin;     % figure size on paper (widht & hieght)
    ySize = Y - 2*yMargin;     % figure size on paper (widht & hieght)

    % create figure/axis
    hFig = figure('Menubar','none');
    set(hFig, 'Visible', 'off');
    image(new_image);
    % plot([0 1 nan 0 1], [0 1 nan 1 0])
    axis tight
    axis off
    set(gca, 'XTickLabel',[], 'YTickLabel',[], ...
        'Units','normalized', 'Position',[0 0 1 1])

    % figure size displayed on screen (50% scaled, but same aspect ratio)
    set(hFig, 'Units','centimeters', 'Position',[0 0 xSize ySize]/2)
    movegui(hFig, 'center')

    % figure size printed on paper
    set(hFig, 'PaperUnits','centimeters')
    set(hFig, 'PaperSize',[X Y])
    set(hFig, 'PaperPosition',[xMargin yMargin xSize ySize])
    set(hFig, 'PaperOrientation','portrait')

    % export to PDF and open file
    print(hFig,'-dpdf','-r0',[pwd filename])
%     winopen(filename)
    
end

