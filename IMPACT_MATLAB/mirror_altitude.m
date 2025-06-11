function [altitude_mirror] = mirror_altitude(pa_eq,L_shell)
    %MIRROR_ALTITUDE 
    %simple function script to calculate the magnetic mirror altitude 
    % of a particle in Earth's dipolar field
    % inputs:
    %   pa_eq = equatorial pitch angle in degrees
    %   L_shell = magnetic L shell in Earth radii
    % outputsL
    %   altitude_mirror = mirror altitude in km
    
    %FUTURE ADAPTATIONS:
    % - change input values to any pitch angle, radial distance/latitude, and azimuth
    % (or MLT)
    % - use realistic magnetic field (with MLT inpit)
    
    % Define constants
    Re = 6371; % Earth radius in km
    
    % Convert pitch angle to radians
    pa_eq_rad = deg2rad(pa_eq);
    
    % Compute the mirror radial distance using the dipole field relation
    r_mirror = L_shell * Re * (1 / sin(pa_eq_rad)^2)^(1/6); % in km
    
    % Compute altitude above Earth's surface
    altitude_mirror = r_mirror - Re;

end

