function [q_cum,q_tot] = calc_ionization(Qe,z,f,H)
%CALC_IONIZATION 
%
%Inputs:
% Qe(e) is incident electron energy flux by energy (e) (keV cm-2 s-1)
% z is altitude (z, km)
% f(z,e) is energy disspiation by altitude,z, and energy,e
% H(z) is scale height (cm)
%
%Output
%   q_cum(z,e) = cumulative integral of total ionization rate over altitude

    %make arrays of the same dimensions (z,e)
    [H_grid, Qe_grid] = ndgrid(H, Qe);
    
    %calculate total ionization rate (cm-3 s-1)
    q_tot = (Qe_grid / 0.035 ).* f ./ H_grid ;
    
    %integrate total ionization rate (cm-2 s-1)
    %use cumulative integral of the flipped vectors to represent cumulative
    %ionoization by altitude from top of the atmosphere to bottom 
    
    q_cum = -flip(cumtrapz(flip(z), flip(q_tot, 1), 1), 1);


%     %alternatively could just loop over dimensions:
%     [nz, ne] = size(q_tot);
%     q_cum = zeros(nz,ne);
%     for k = 1:ne
%         q_cum(:,k) = -flip(cumtrapz(flip(z), flip(q_tot(:,k))));
%     end

end

