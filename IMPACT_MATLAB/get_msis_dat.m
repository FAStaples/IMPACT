
function [rho_out,H_out] = get_msis_dat(alt, compile_msis)
    %function which loads relevant msis data for Fang2010 ionization model
    % Input:
    %   geoderic altitudes, from 0 to 1000km
    % (1) defines msis inputs, 
    % (2) runs msis 2.1, 
    % (3) loads msis outputs
    % (4) calculates scale hight
    % (5) returns 
    %       rho = atmospheric mass density (g cm-3), 
    %       T = atmospheric Temperature (K), 
    %       H = scale height (cm) 
    %   Optional name-value arguments:
    %       'Compile_msis'  : true/false, whether to compile msis before 
    %           running (default false)
    %
    %To DO: add date, F10.a and Ap as user inputs when calling function

    msisDIR = '~/Projects/nrlmsis2.1/';

    %%%%%%%%%
    % first make .txt file with data inputs for the MSIS2.1 model
    %date, YYDDD (DDD is day of year)
    %universal time (seconds)
    %geodetic latitude (deg)
    %geodetic longitude (deg)
    %local solar time (Ignored; calculated from universal time,SEC, and GLONG)
    %81-day average of F10.7 solar flux
    %daily F10.7 solar flux for previous day
    %Daily magnetic Ap index



    % Specify input variables

    %geoderic altitudes, from 0 to 1000km
    nalt=length(alt);
    
    % Values to loop over
    glats  = [60, 70, 80];
    glongs = [0, 90, 180, 270];
    iyds   = [99079, 99172, 99266, 99356];  % dates in YYDDD
    % Constant parameters
    sec    = 64800;  % 18:00 UT
    stl    = 21.67;
    f107a  = 50.0;
    f107   = 50.0;
    Ap     = 5.0;
    
    %open file to write into
    fid = fopen(sprintf('%smsisinputs.txt', msisDIR), 'w');
    
    % Write header
    fprintf(fid, 'iyd    sec    alt   glat  glong    stl  f107a   f107     Ap\n');
    
    % Loop through all combinations
    for d = 1:length(iyds)
        for g = 1:length(glats)
            for h = 1:length(glongs)
                 for i = 1:nalt
                     fprintf(fid, '%7d %6d %6.1f %6.1f %6.1f %7.2f %7.1f %7.1f %6.1f\n', ...
                         iyds(d), sec, alt(i), glats(g), glongs(h), stl, f107a, f107, Ap);
                 end
            end
        end
    end
    
    % Close the file
    fclose(fid);

    %%%%%%%%%%%%%%%%%

    %compile msis
    if compile_msis 
        system(sprintf('%scompile_msis.sh', msisDIR));
    else
        disp('using compiled version of MSIS2.1')
    end

    %then run msis model
    cmd = sprintf('cd %s && ./msis2.1_test.exe', msisDIR);
    system(cmd);

    %%%%%%%%
    %read msis outputs    
    % Open the output file for reading
    fid = fopen(sprintf('%smsisoutputs.txt',msisDIR),'r');
    % Skip the header line
    fgetl(fid);
    % Read the numeric data
    data = textscan(fid, '%7d %6d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'); 
    % Close the file
    fclose(fid);
    
    % Extract variables from the cell array
%     iyd   = data{1};
%     sec   = data{2};
%     alt   = data{3};
%     glat  = data{4};
%     glong = data{5};
%     stl   = data{6};
%     f107a = data{7};
%     f107  = data{8};
%     Ap    = data{9}; 
    nHe    = data{10}; % He number density (cm-3)
    nO     = data{11}; % O number density (cm-3)
    nN2    = data{12}; % N2 number density (cm-3)
    nO2    = data{13}; % O2 number density (cm-3)
    nAr    = data{14}; % Ar number density (cm-3)
    rho   = data{15}; % Total mass density (g cm-3)
    nH     = data{16}; % H number density (cm-3)
    nN     = data{17}; % N number density (cm-3)
    nOa    = data{18}; % Anomalous oxygen number density (cm-3)
    nNO    = data{19}; % NO number density (cm-3)
    T     = data{20}; % Temperature at altitude (K)
    
    % calculate average molecular weight in kg
    Mav = 1.66e-27*(nHe*4.0 + nO*16.0 + nN2*28.02 + nO2*32.0 + nAr*39.95 + nH*1.0 ...
        + nOa*16.0 + nNO*30)./ (nHe + nO + nN2 + nO2 + nAr + nH +nOa + nNO); 
    
    % calculate graitational acceleration 
    g0 = 9.80665;    % m/s^2 at sea level
    Re = 6371;       % Earth's radius in km
    g_alt = g0 * (Re ./ (Re + alt)).^2; %gravitational acceleration in m s-2 by altitude
    %repeat vector to match length of msis output data
    nblocks = length(T) / nalt;   
    g = repmat(g_alt',nblocks,1);
    
    %scale height H
    kb = 1.38e-23; %boltzman's constant in J K-1
    H = kb * T ./ (Mav .* g); %scale height in m
    
    %transpose vectors to return
    % convert H to cm (needed for Fang equations since rho is in g cm-1 )
    H = H' *100;
    rho = rho';


    %now average H and rho across days, latitude, and longitude
    %output data will be a column vector with 
    % nalt x nglat x nglong x ndate rows
    
    %get dimensions of inputs
    nglat  = length(glats);
    nglong = length(glongs);
    ndate  = length(iyds);

    %reshape H into a array, seperated by altitude, long, lat, date
    H_arr = reshape(H, [nalt, nglong, nglat, ndate]);
    rho_arr = reshape(rho, [nalt, nglong, nglat, ndate]);

    %average over long, lat, date dimensions 
    H_out = mean(H_arr, [2 3 4]);
    rho_out = mean(rho_arr, [2 3 4]);

end







