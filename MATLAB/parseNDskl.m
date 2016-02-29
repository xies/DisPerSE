function [ MSC ] = parseNDskl( filename )
%parseNDskl Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(filename);
tline = fgetl(fid);
while 1-strcmp(tline,'[CRITICAL POINTS]')
    tline = fgetl(fid);
end
Ncrit = str2num(fgetl(fid));
Critical_Points = struct();

for Crit = 1:Ncrit
    % Reading the characterization line of the current point
    Characterization = fgetl(fid);
    C_Char = textscan(Characterization,'%d %f %f %f %d %d');
    Critical_Points(Crit).type = C_Char{1};
    Critical_Points(Crit).X = C_Char{2};
    Critical_Points(Crit).Y = C_Char{3};
    Critical_Points(Crit).Value = C_Char{4};
    Critical_Points(Crit).CPIndex = C_Char{5}+1;
    Critical_Points(Crit).Boundary = C_Char{6};
    % Number of filaments
    NfilamentsSTR = fgetl(fid);
    Nfil = str2num(NfilamentsSTR);
    Critical_Points(Crit).Nfil = Nfil;
    
    %    'Creating the substructure'
    Fil = struct();
    for FIL = 1:Nfil
        % Reading the filament's other critical point and filament ID
        FilStr = fgetl(fid);
        FilCell = textscan(FilStr,'%d %d');
        Fil(FIL).CP = FilCell{1}+1;
        Fil(FIL).FilID = FilCell{2}+1;
    end
    Critical_Points(Crit).Filaments = Fil;
    
end

disp('Parsing filaments')
while 1-strcmp(tline,'[FILAMENTS]')
    tline = fgetl(fid);
end
Nfilaments = fgetl(fid);
Nfil = str2num(Nfilaments);
Filaments = struct();

for FIL = 1:Nfil
    Characterization = fgetl(fid);
    F_Char = textscan(Characterization,'%d %d %d');   
    Filaments(FIL).CPstart = F_Char{1}+1;
    Filaments(FIL).CPend = F_Char{2}+1;
    
    %Number of sampling points for this filament
    N_SP = F_Char{3};    
    Filaments(FIL).Nsample = N_SP;
    %  'Creating the position vectors'
    XX = zeros(1,N_SP);
    YY = zeros(1,N_SP);
    for sample = 1:N_SP
        % Reading the Samples positions
        SP_string = fgetl(fid);
        SPCell = textscan(SP_string,'%f %f');
        XX(sample) = SPCell{1};
        YY(sample) = SPCell{2};
    end
    Filaments(FIL).X = XX;
    Filaments(FIL).Y = YY;
end

% Next: the critical point data
while 1-strcmp(tline,'[CRITICAL POINTS DATA]')
    tline = fgetl(fid);
end
Ncols = str2double(fgetl(fid));
for i=1:Ncols
    tmp =fgetl(fid);
end

for p = 1:Ncrit
    Characterization = fgetl(fid);    
    F_Char = textscan(Characterization,'%f %d %d %f %f %d');
    Critical_Points(p).persistence = F_Char{1};
    %Critical_Points(p).persistence_pair = F_Char{2}+1;
    Critical_Points(p).parent_index = F_Char{3}+1;
    %Critical_Points(p).log_field_value = F_Char{4};
    %Critical_Points(p).field_value = F_Char{5};
    Critical_Points(p).cell = F_Char{6};
end

while 1-strcmp(tline,'[FILAMENTS DATA]')
    tline = fgetl(fid);
end
% ENTERING THE [FILAMENTS DATA] HEADER
Ncols = str2double(fgetl(fid));
for i=1:Ncols
    tmp =fgetl(fid);
end
for FIL = 1:Nfil
    Characterization = fgetl(fid);
    F_Char = textscan(Characterization,'%f %d %f %f %d');   
    Filaments(FIL).field_value = F_Char{1};
    Filaments(FIL).orientation = F_Char{2};
    Filaments(FIL).cell = F_Char{3};
    Filaments(FIL).log_field_value = F_Char{4};
    Filaments(FIL).type = F_Char{5};    
end

MSC.CriticalPoints = Critical_Points;
MSC.Filaments = Filaments;
end

