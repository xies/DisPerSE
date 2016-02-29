clear all;
cd /math/home/stoopn/Stokes_Micro/Matlab/;
mdir = '/math/home/stoopn/Stokes_Micro/Simulations/FINAL/';
ddirs = dir([mdir,'r=*']);
rvals=[];
psuffix='SIM_pillars_hex_a=0.012_';
ppostfix= '_p=0.842488398331_rs=1.0.dat';
GSx=8650;   
GSy=0;
GLx=150;
GUx=3850;
spacex=200;
filepattern='speed';
filename=strjoin({filepattern,'.fits'},'');
%%
for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    rvals(d)=str2num(ddir(3:end));
%     pillarfile=strjoin({mdir, 'PILLARS/', psuffix, ddir, ppostfix},'')
%     pdata=dlmread(pillarfile,',',1,0);
%     sgrains=pdata;
%     sgrains(:,1) = pdata(:,1) + GSx;
%     sgrains(:,2) = pdata(:,2) + GSy;
%     pradius = sgrains(1,3);
    
    data=dlmread(strjoin({mdir, '/', ddir,'/data.csv'},''),',',1,0);
    u = data(:,1);
    v = data(:,2);
    grain = data(:,5);
    x = data(:,9);
    y = data(:,10);
    width=abs(max(y)-min(y));
    length=abs(max(x)-min(x));
  
%     grains = sgrains(sgrains(:,1)+sgrains(:,3) > spacex-50 & sgrains(:,1)-sgrains(:,3) < length-spacex+50 & sgrains(:,2) - sgrains(:,3) < width+50 & sgrains(:,2) + sgrains(:,3) > 0-50,:);
     for idx=1:size(x)
        if grain(idx)==100
             u(idx)=0;
             v(idx)=0;
        end
     end

    [xq,yq] = meshgrid(spacex:1:length-spacex, 0:1:width);
    vq = griddata(x,y,v,xq,yq);
    uq = griddata(x,y,u,xq,yq);  
    
    speed=sqrt(uq.^2 + vq.^2);
  %  imshow(mat2gray(speed));
    fitswrite(speed,strjoin({mdir, '/', ddir,'/speed.fits'},''));
    imwrite(mat2gray(speed),strjoin({mdir, '/', ddir,'/speed.jpg'},''));
    % Speed fluctuations around mean:
    speedfluct=sqrt((uq+1).^2 + vq.^2);
    fitswrite(speedfluct,strjoin({mdir, '/', ddir,'/speedfluct.fits'},''));
    imwrite(mat2gray(speedfluct),strjoin({mdir, '/', ddir,'/speedfluct.jpg'},''));
    % Speed fluctuations around mean, x coordinate only:
    speedfluctx=uq+1;
    fitswrite(speedfluctx,strjoin({mdir, '/', ddir,'/speedfluctx.fits'},''));
    imwrite(mat2gray(speedfluctx),strjoin({mdir, '/', ddir,'/speedfluctx.jpg'},''));
end
 
%%
% Call this on alan to run disperse wrapper script on each subfolder r=* in mdir

cd /math/home/stoopn/Stokes_Micro/Matlab/;
ddirs = dir([mdir,'r=*']);
cutoff=1.02;
%cutoff=0.5;  % Disperse cutoff
%cutoff=0.9;
reload=1;
skconvargs = strjoin({' -smooth 100 -to NDskl_ascii'},'');
%filename=strjoin({filepattern,'.fits'},'');
if reload==1
    args=strjoin({'-loadMSC ', filename, '.MSC -cut ',num2str(cutoff),' -dumpArcs CUD'},'');
else
args = strjoin({'-cut ',num2str(cutoff),' -dumpArcs CUD'},'');
end

% Calculate Morse Smale complex, cut at cutoff, and convert the filament structure:

for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    cdir = strjoin({mdir, '/', ddir},'');
    cd(cdir);    
    cmds = strjoin({mdir,'disperse.sh "', filename, ' ',args,'"'},'');
    [status,result] = system(cmds);
    skfilename=strjoin({filename,'_c', num2str(cutoff), '.CUD.NDskl'},'');    
    cmds = strjoin({mdir,'skelconv.sh "', skfilename, ' ',skconvargs,'"'},'');
    [status,result] = system(cmds);
end
%%


%% Dump skeleton structure at zero cutoff (in order to avoid huge files, make sure the pillars have 0 velocity)
args = strjoin({'-loadMSC ', filename, '.MSC -dumpArcs CUD'},'');
for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    cdir = strjoin({mdir, '/', ddir},'');
    cd(cdir);    
    cmds = strjoin({mdir,'disperse.sh "', filename, ' ',args,'"'},'');
    [status,result] = system(cmds);
    skfilename=strjoin({filename, '.CUD.NDskl'},'');    
    cmds = strjoin({mdir,'skelconv.sh "', skfilename, ' ',skconvargs,'"'},'');
    [status,result] = system(cmds);
end

%% Parse the filemane structure for a given cutoff and store it as matlab structure
cd /math/home/stoopn/Stokes_Micro/Matlab/;
cutoff=0.5;
cutoff=1.02;
%c=0.9;
filepattern = strjoin({filename,'_c', num2str(cutoff),'.CUD.NDskl.S100.a.NDskl'},'');
for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    skelfile = strjoin({mdir, '/', ddir,'/', filepattern},'');
    MSC = parseNDskl(skelfile);
    save(strjoin({mdir, '/', ddir,'/MSC_C',num2str(cutoff),'.mat'},''),'MSC');
end

%% Parse the filemane structure for zero cutoff and store it as matlab structure
cd /math/home/stoopn/Stokes_Micro/Matlab/;
filepattern = strjoin({filename,'.CUD.NDskl.S100.a.NDskl'},'');
for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    skelfile = strjoin({mdir, '/', ddir,'/', filepattern},'');
    MSC = parseNDskl(skelfile);
    save(strjoin({mdir, '/', ddir,'/MSC_C0.mat'},''),'MSC');
end
