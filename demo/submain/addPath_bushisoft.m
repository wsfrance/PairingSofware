function [ pathstr ] = addPath_bushisoft( verbose )
%ADDPATH_M2TML Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    verbose = 1;
end

% [pathstr,name,ext] = fileparts(pwd); 
[pathstr,tmpname] = fileparts(pwd);
if strcmp(tmpname,'demo')==0
    error('Please launch this program in the demo folder !!')
end
if max(ismember(strsplit(path,';'), [pathstr,'/subFunctions'])) == 0
    addpath(genpath([pathstr,'/subFunctions']));
end

if max(ismember(strsplit(path,';'), [pathstr,'/data'])) == 0
    addpath(genpath([pathstr,'/data']));
end

if max(ismember(strsplit(path,';'), [pathstr,'/classes'])) == 0
    addpath(genpath([pathstr,'/classes']));
end

if max(ismember(strsplit(path,';'), [pathstr,'/externalLibs'])) == 0
    addpath(genpath([pathstr,'/externalLibs']));
end

if max(ismember(strsplit(path,';'), [pathstr,'/main'])) == 0
    addpath(genpath([pathstr,'/main']));
end

if max(ismember(strsplit(path,';'), [pathstr,'/demo'])) == 0
    addpath(genpath([pathstr,'/demo']));
end


% if max(ismember(strsplit(path,';'), [pwd,'\externalToolbox'])) == 0
%     addpath(genpath([pwd,'\externalToolbox']));
% end

if max(ismember(strsplit(path,';'), [pathstr,'/externalLibs'])) == 0
    addpath(genpath([pathstr,'/externalLibs']));
end

if max(ismember(strsplit(path,';'), [pathstr,'\results'])) == 0
    addpath(genpath([pathstr,'/results']));
end

end

