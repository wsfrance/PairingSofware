function code = generateWScode ()

    symbols = ['A':'Z' '0':'9'];
    % MAX_ST_LENGTH = 5;
    % stLength = randi(MAX_ST_LENGTH);
    stLength = 5;
    nums = randi(numel(symbols),[1 stLength]);
    code = symbols (nums);
 
end