function [bt] = bounce_time_arr(L,E,pa,varargin)
%BOUNCE_TIME_ARR Calculates the bounce period of charged particles in Earth's dipole field
%
%   bt = bounce_time_arr(L, E, pa, particle)
%
%   Computes the bounce period (in seconds) for a charged particle (electron or proton)
%   trapped in Earth's dipolar magnetic field, using a relativistic formulation.
%   The function operates element-wise on matrix arrays of energies and pitch angles.
%
%   INPUTS:
%       L        - L-shell parameter (can be scalar or array)
%       E        - Kinetic energy of particle in MeV (array)
%       alpha    - Equatorial pitch angle in radins (array)
%       particle - (optional) 'e' for electrons [default], 'p' for protons
%
%   OUTPUT:
%       bt       - Bounce period in seconds (same size as E and alpha)
%
%   adapted from Adam Kallerman's bounce_time_new function


switch nargin
    case 4
        input=lower(varargin{1});
        if strcmp(input,'e');
            mc2=0.511; %MeV
        elseif strcmp(input,'p');
            mc2=938; %MeV
        else
            error('no option %s',input)
        end
    otherwise
        %default is electrons
        mc2=0.511; %MeV
end

%convert energy to pc
pc = sqrt( (E ./ mc2 + 1).^2 - 1) .* mc2;

%set constants
Re = 6.371e6;
c_si = 2.998e8;

%calculate pitch angle scaling factor T_pa for the bounce period in dipole
y = sin(pa);
T_pa = 1.38 + 0.055 .* y.^(1.0/3.0) - 0.32 .* y.^(1.0/2.0) - 0.037 .* y.^(2.0/3.0) - 0.394 ...
    .* y + 0.056 .* y.^(4.0/3.0);

%calculate bounce period
bt = 4.0 .* L .* Re .* mc2 ./ pc ./ c_si .* T_pa / 60 / 60 / 24;



