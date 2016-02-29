
filename = '/Users/mimi/Code/DisPerSE/test_images/test.fits';
[file_dir,name,ext] = fileparts( filename );

cutoff = 18;
Nsmooth = 3;

%% Calculate Morse Smale complex, cut at cutoff, and convert the filament structure:

mse_cmds = strjoin({ ...
    'mse' , filename, ...
    '-outDir', file_dir, ...
    '-cut', num2str(cutoff), ...
    ' -dumpArcs CUD'} , ' ');

[status,result] = system(mse_cmds)

%%
skl_filename = [filename '_c' num2str(cutoff) '.CUD.NDskl'];

skl_cmds = strjoin({ ...
    'skelconv', skl_filename, ...
    '-outDir', file_dir, ...
    '-smooth', num2str(Nsmooth), ...
    '-to', 'NDskl_ascii'}, ' ');

[status,result] = system(skl_cmds);
%

%%

output_filename = [filename ...
    '_c' num2str(cutoff) ...
    '.CUD.NDskl.S003.a.NDskl'];
% filepattern = strjoin({filename,'.CUD.NDskl.S100.a.NDskl'},'');

% skelfile = strjoin({mdir, '/', ddir,'/', filepattern},'');

MSC = parseNDskl(output_filename);

%%

mask = MSC2mask(MSC, size(im,1),size(im,2));
imshow(imoverlay(im,mask,[1 0 0]))
save([file_dir, '/MSC.c_' num2str(cutoff) '.CUD.NDskl.S003.a.NDskl.mat'],'MSC');
