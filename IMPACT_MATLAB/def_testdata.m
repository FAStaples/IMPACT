function [Qe] = def_testdata(E,pa,time)
%DEF_EFLUX Creates a synthetic incident energy flux array for testing
%
%   q = def_Eflux(E, pa, time) generates a 3D test array representing
%   the incident energy flux of electrons as a function of energy and 
%   pitch angle, constant in time.
%
%   INPUTS:
%       E    - Vector of energies (keV)
%       pa   - Vector of pitch angles (degrees)
%       time - Vector of time points (s)
%
%   OUTPUT:
%       Qe   - 3D array of size [nt x nAlpha x nE] representing 
%              incident energy flux in (keV cm^-2 s^-1)
%
%   The flux is defined as:
%       q_E(E)      ~ exp(-E/kT)
%       q_alpha(pa) ~ sin^2(pa) + 1
%   and is constant over time.

% Energy dependence: exponential decay with characteristic energy 500 keV
q_E = 6.2415e8 .* exp(-E / 500);   % [1 x nE]

% Pitch angle dependence: sin^2(pa) + 1
q_alpha = (sind(pa)).^2 + 1;       % [1 x nAlpha]

% Create 2D grid of q_E and q_alpha
q_EA = q_E' * q_alpha;             % [nE x nAlpha]

% Replicate across time dimension
Qe = repmat(q_EA, 1, 1, length(time)); % [nE x nAlpha x nt]

% Permute to [nt x nAlpha x nE]
Qe = permute(Qe, [3, 2, 1]);


end

