function [old_files not_found] = update_check(fpath, rec, crit, ext, replace)
% 
% Check for updates and replace old files.
% 
% 
%USAGE
%-----
% update_check(fpath)
% old_files = update_check(fpath)
% [old_files not_found] = update_check(fpath)
% 
% [...] = update_check(fpath)
% [...] = update_check(fpath, rec)
% [...] = update_check(fpath, rec, crit)
% [...] = update_check(fpath, rec, crit, ext)
% [...] = update_check(fpath, rec, crit, ext, replace)
% 
% 
%INPUT
%-----
% - FPATH  : parent folder to search for changes (the original files are
%   expected to be in the MATLAB search path)
% - REC    : 1 (search for files recursively, i.e., include all FPATH
%   subfolders), 0 (only FPATH) [default: 0]
% - CRIT   : criterion: 'time' (compare the modification date) or 'size'
%   (compare the file size) [default: 'time']
% - EXT    : cell array containing the file extension [default: {'m' 'mat' 'fig'}]
% - REPLACE: 1 (replace old files), 0 (don't replace) [default: 0]
% 
% If any of the input variables is empty or missing, the default value will
% be used.
% 
% 
%OUTPUT
%------
% - OLD_FILES: cell array with the name and path of the old files
% - NOT_FOUND: cell array with the name and path of the files that were not
%   found in the search path
% 

% Guilherme Coco Beltramini - 2014-Jul-13, 12:58 pm


% Input
%==========================================================================
if nargin<5 || isempty(replace)
    replace = 0;
end
if nargin<4 || isempty(ext)
    ext = {'m' 'mat' 'fig'};
else
    ext = cellstr(ext);
end
if nargin<3 || isempty(crit)
    crit = 1; % time
else
    switch lower(crit)
        case 'time'
            crit = 1;
        case 'size'
            crit = 2;
        otherwise
            error('Invalid criterion')
    end
end
if nargin<2 || isempty(rec)
    rec = 0;
end
if nargin<1 || exist(fpath, 'dir')~=7
    error('Unknown file path')
end


disp('Checking for updates...')


% Get all the folders inside "fpath"
%==========================================================================
if rec
    fpath = genpath(fpath);
    fpath = regexp(fpath, pathsep, 'split')';
    fpath(cellfun(@isempty, fpath)) = []; % remove empty cells
else
    fpath = cellstr(fpath);
end


% Check for updates
%==========================================================================
cnt = 0;
old = {};
not_found = {};
for ff=1:length(fpath) % loop for the folders
    
    for ee=1:length(ext) % loop for the file extensions
        
        files = dir(fullfile(fpath{ff}, sprintf('*.%s', ext{ee})));
        
        for ii=1:length(files) % loop for the files
            
            tmp = dir(which(files(ii).name));
            
            if isempty(tmp)
                not_found = [not_found ; fullfile(fpath{ff}, files(ii).name)];
                continue
            end
            
            if crit==1
                
                % Check for newer versions
                %-------------------------
                if tmp.datenum > files(ii).datenum % file in fpath is older
                    cnt = cnt + 1;
                    old{cnt} = fullfile(fpath{ff}, files(ii).name);
                    if cnt==1
                        fprintf('The following files need to be updated:\n')
                    end
                    fprintf('%d) %s', cnt, files(ii).name)
                    if replace
                        sts = copyfile(which(files(ii).name), old{cnt});
                        if sts
                            fprintf('... updated!')
                        else
                            fprintf('... unable to update')
                        end
                    end
                    fprintf('\n')
                end
                
            elseif crit==2
                
                % Check the file size
                %--------------------
                if tmp.bytes ~= files(ii).bytes
                    cnt = cnt + 1;
                    old{cnt} = fullfile(fpath{ff}, files(ii).name);
                    if cnt==1
                        fprintf('The following files need to be updated:\n')
                    end
                    fprintf('%d) %s', cnt, files(ii).name)
                    if replace
                        sts = copyfile(which(files(ii).name), old{cnt});
                        if sts
                            fprintf('... updated!')
                        else
                            fprintf('... unable to update')
                        end
                    end
                    fprintf('\n')
                end
                
            end
            
        end
        
    end
    
end

if cnt==0
    disp('Everything is up to date.')
end

if ~isempty(not_found)
    fprintf('\nThe following files were not found in the search path:\n')
    fprintf('%s\n', not_found{:})
end

if nargout>0
    old_files = old;
end
