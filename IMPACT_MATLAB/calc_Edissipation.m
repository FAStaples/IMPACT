function [f] = calc_Edissipation(rho,H,E)
%calc_Edissipation calculates energy dissipation, f(z), due to atmospheric
% ionoization from a monoenergetic electron beam 
% (valid for E from 100eV to 1MeV)- Fang+ 2010
% 
% Inputs :
%   rho(z) = atmospheric mass density (g cm^-3)
%   H(z)   = scale height (cm)
%   E(n) = vector of electron energies (keV)
%   
% Outputs:
%   f(y,n) = energy disspation as a function of altitude 
%       where y(z) is column mass and n in num of energies


    %load Pij from file
    coeff = load('coeff_fang10.mat');

    f=nan(length(rho),length(E));

    for eidx=1:length(E)

        y = (2./E(eidx)) * (rho .* H).^ 0.7 * (6e-6)^-0.7; %column mass as function of altitude
    
        %calculate each coefficient Ci(i=1,...8)
        c = zeros(1,8);
        for i=1:8
            cij = zeros(1,4);
            for j=0:3
                cij(j+1) = coeff.Pij(i,j+1)*(log(E(eidx)))^j ; %need to use j+1 for index since j is defining third order polynomial (i.e. 0-3)
            end  
            c(i) = exp(sum(cij));
        end
        
        %calculate f
        f(:,eidx) = c(1) * y.^c(2) .* exp(-c(3) * y.^c(4)) + ...
            c(5) * y.^c(6) .* exp(-c(7) * y.^c(8) );
    end


end

