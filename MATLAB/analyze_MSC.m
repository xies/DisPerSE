%% Analyze MSC structure
clear all;
cd /math/home/stoopn/Stokes_Micro/Matlab/;
mdir = '/math/home/stoopn/Stokes_Micro/Simulations/FINAL/';
ddirs = dir([mdir,'r=*']);
rvals=[];
spacex=200;
length=4000-spacex;
width=2500;
delta=100;
close all;
figure(1);
figure(2);

for d=1:size(ddirs,1)
    ddir=ddirs(d).name;
    ddir
    rvals(d)=str2num(ddir(3:end));
% This loads the Morse-Smale-complex  (matlab struct) that we obtained previously using parseNDskl.m (to avoid
% doing it again and again, we saved the struct as a matlab .mat file and just read it back in here).
    load(strjoin({mdir,ddir,'/MSC_C0.mat'},''));
    
P0=[];
ctr0=0;
P2=[];
ctr2=0;
Ncp=size(MSC.CriticalPoints,2);
for cpi=1:Ncp
   if MSC.CriticalPoints(cpi).type==1
       continue;
   elseif MSC.CriticalPoints(cpi).type==0
       if MSC.CriticalPoints(cpi).CPIndex ~= cpi && MSC.CriticalPoints(cpi).persistence<10E100
          cp2=MSC.CriticalPoints(cpi).CPIndex;
          if MSC.CriticalPoints(cp2).X<delta || MSC.CriticalPoints(cp2).X>length-delta || MSC.CriticalPoints(cp2).Y<delta || MSC.CriticalPoints(cp2).Y>width-delta   || MSC.CriticalPoints(cpi).X<delta || MSC.CriticalPoints(cpi).X>length-delta || MSC.CriticalPoints(cpi).Y<delta || MSC.CriticalPoints(cpi).Y>width-delta
            continue;
          end
          ctr0=ctr0+1;
        P0(ctr0)=MSC.CriticalPoints(cpi).persistence;
       end
    elseif MSC.CriticalPoints(cpi).type==2
        if MSC.CriticalPoints(cpi).CPIndex ~= cpi && MSC.CriticalPoints(cpi).persistence<10E100
         cp2=MSC.CriticalPoints(cpi).CPIndex;
          if MSC.CriticalPoints(cp2).X<delta || MSC.CriticalPoints(cp2).X>length-delta || MSC.CriticalPoints(cp2).Y<delta || MSC.CriticalPoints(cp2).Y>width-delta   || MSC.CriticalPoints(cpi).X<delta || MSC.CriticalPoints(cpi).X>length-delta || MSC.CriticalPoints(cpi).Y<delta || MSC.CriticalPoints(cpi).Y>width-delta
            continue;
          end
         ctr2=ctr2+1;
         P2(ctr2)=MSC.CriticalPoints(cpi).persistence;
        end
   end 
end
P0=sort(P0);
P2=sort(P2);
maxP0 = max(P0);
maxP2 = max(P2);

 [a,b]=hist(P0,50);

 pcutoffs = [b, maxP0];
 pairs=[cumsum(a,2,'reverse'),0];
 figure(1)
 plot(pcutoffs,smooth(pairs));
 hold on;
 
 [a,b]=hist(P2,50);
%  figure(20);
% hist(P2,50);
 pcutoffs = [b, maxP2];
 pairs=[cumsum(a,2,'reverse'),0];
 figure(2)
 plot(pcutoffs,smooth(pairs));
 hold on;
end