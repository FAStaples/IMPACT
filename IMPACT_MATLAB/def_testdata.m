function [j] = def_testdata(E,pa,time)
%DEF_EFLUX Creates a synthetic incident energy flux array for testing
%
%   j = def_testdata(E, pa, time) generates a 3D test array representing
%   the incident number flux of electrons as a function of energy and 
%   pitch angle, constant in time.
%
%   INPUTS:
%       E    - Vector of energies (keV)
%       pa   - Vector of pitch angles (degrees)
%       time - Vector of time points (s)
%
%   OUTPUT:
%       J   - 3D array of size [nt x nAlpha x nE] representing 
%              incident energy flux in (cm^-2 s^-1)
%
%   The flux is defined as:
%       j_E(E)      ~ exp(-E/kT)
%       j_alpha(pa) ~ sin^2(pa) + 1
%   and is constant over time.

% Energy dependence: exponential decay with characteristic energy 500 keV
j_E = 1e6 .* exp(-E / 500);   % [1 x nE] particles / cm^2 / s / keV / sr

% Pitch angle dependence: sin^2(pa) + 1
j_alpha = (sind(pa)).^2 + 1;       % [1 x nAlpha]

% Create 2D grid of j_E and j_alpha
j_EA = j_E' * j_alpha;             % [nE x nAlpha]

% Replicate across time dimension
j = repmat(j_EA, 1, 1, length(time)); % [nE x nAlpha x nt]

% Permute to [nt x nAlpha x nE]
j = permute(j, [3, 2, 1]);


end

