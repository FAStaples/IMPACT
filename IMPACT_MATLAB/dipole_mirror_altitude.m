function [mirror_altitude] = dipole_mirror_altitude(alpha_eq_in,Lshell)
%DIPOLE_MIRROR_ALTITUDE Compute mirror altitude (km) in a dipole field
%   INPUTS:
%       alpha_eq_in : Array of equatorial pitch angles (degrees)
%       Lshell      : Scalar of L-shell values 
%
%   OUTPUT:
%       mirror_altitude : Altitude above Earth's surface (km) where each 
%                         particle will mirror
%

% Define mirror latitudes and compute corresponding equatorial pitch angles
mirror_latitude = deg2rad(linspace(90, 0, 500)); 
B_ratio = (cos(mirror_latitude).^6)./sqrt(1 + 3*sin(mirror_latitude).^2);
alpha_eq = asin(sqrt(B_ratio));

 
% Clip input pitch angles to [0, 90]
alpha_eq_in(alpha_eq_in > 90) = 180 - alpha_eq_in(alpha_eq_in > 90);
% Convert pitch angles to query into radians 
alpha_eq_query = deg2rad(alpha_eq_in); 

% Interpolate to get corresponding mirror latitudes
mirror_lat_query = interp1(alpha_eq, mirror_latitude, alpha_eq_query);

% Calculate the mirror altitude (km) for query points
r = Lshell.*6371.* cos(mirror_lat_query).^2;
mirror_altitude = r - 6371;

end

