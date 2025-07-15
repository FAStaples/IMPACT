function [q_cum,q_tot] = calc_ionization(Qe,z,f,H)

%CALC_IONIZATION Calculate ionization rates from precipitating electron flux
%
%   [q_cum, q_tot] = calc_ionization(Qe, z, f, H) computes the altitude-dependent 
%   ionization rate in the atmosphere caused by a precipitating monoenergetic or 
%   electron flux, following the parameterization of Fang et al. (2010).
%
%   INPUTS:
%       Qe(E) - Incident electron energy fluxes (keV cm^-2 s^-1)
%               for each energy bin e.
%       z     - Vector of altitudes (km) corresponding to f(z, e) and H(z)
%       f(z,e)- 2D array of energy dissipation fractions as a function of 
%               altitude (z) and energy (E), dimension [nz x nE]
%       H(z)  - Vector of atmospheric scale heights (cm) as a function of altitude
%
%   OUTPUTS:
%       q_tot(z,e) - 2D array of local ionization production rates 
%                    (cm^-3 s^-1) at each altitude and energy
%
%       q_cum(z,e) - 2D array of cumulative integrated ionization rates 
%                    (cm^-2 s^-1) as a function of altitude and energy. 
%
%   METHOD:
%
%       - The cumulative ionization rate q_cum is computed by vertically 
%         integrating q_tot from the top of the atmosphere downward, 
%         using a cumulative trapezoidal integration.


    %make arrays of the same dimensions 
    [H_grid, Qe_grid] = ndgrid(H, Qe);
    
    %calculate total ionization rate 
    q_tot = (Qe_grid / 0.035 ).* f ./ H_grid ;
    
    %integrate total ionization rate 
    q_cum = -flip(cumtrapz(flip(z), flip(q_tot, 1), 1), 1);

end

