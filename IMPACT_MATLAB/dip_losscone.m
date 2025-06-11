function [losscone_deg] = dip_losscone(L_shell,h_loss)
    %DIP_LOSSCONE 
    %function to calculate the loss cone in a dipolar field for a given
    %L-shell and fixed ionisation altitude 
    % H = ionization altitude in km, usually 100km
    % L = magnetic L shell in Earth radii
    
    Re = 6371; % Earth radius in km
    L=L_shell*Re; %l-shell 
    h=Re+h_loss;

    sin2_alpha_LC = h^3/sqrt(4*L^6 - 3*h*L^5); 
    losscone = asin(sqrt(sin2_alpha_LC));
    losscone_deg = rad2deg(losscone);

end
