%script to make .txt file with data inputs for the MSIS2.1 model

% Specify input variables
%geoderic altitudes, from 0 to 1000km
alt   = 0:10:1000;
n=length(alt);
%date, YYDDD (DDD is day of year)
iyd   = 70178 * ones(1,n) ; 
%time of day, second
sec   = 64800 * ones(1,n) ; 
%geodetic latitude
glat  = 50.0 * ones(1,n) ; ;
%geodetic longitude
glong = 55.0 * ones(1,n);
%local apparent solar time
stl   = 21.67 * ones(1,n) ; 
%81-day average of F10.7 solar flux
f107a = 153.3 * ones(1,n) ; 
% daily F10.7 solar flux for previous day
f107  = 146.5 * ones(1,n) ; 
%Daily magnetic Ap index
Ap    = 35.0 * ones(1,n) ; ;

% Open the file for writing
fid = fopen('~/Projects/nrlmsis2.1/msisinputs.txt', 'w');

% Write the header line
fprintf(fid, 'iyd    sec    alt   glat  glong    stl  f107a   f107     Ap\n');


% Write data line by line
for i = 1:n
    fprintf(fid, '%7d %6d %6.1f %6.1f %6.1f %7.2f %7.1f %7.1f %6.1f\n', ...
        iyd(i), sec(i), alt(i), glat(i), glong(i), stl(i), f107a(i), f107(i), Ap(i));
end

% Close the file
fclose(fid);

