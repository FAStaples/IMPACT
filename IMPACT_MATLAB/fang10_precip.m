% Model for electron loss due to atmospheric precipitation
% Fang 2010 model is used to represent loss rates

%TODO: add energy range enforcement, and MSIS height limitations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%define energy and pitch angle grid, Lshell, and time steps:

%set Lshell 
Lshell=3;
% Define energy and pitch angle ranges
E = linspace(1, 1000, 100); % Energy in keV
%E=[0.1,1,10,100,1000];
pa = linspace(0, 180, 181); % Pitch angle in deg
time = linspace(0, 1, 10000); %time 
dt = time(2)-time(1); %timestep

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define a sample distribution function f(t,E,pa):
%!NB: f is an energy flux
% exponential in energy (f_E ~ E * exp(-E/kT))
f_E = 6.2415e8 .* exp(-E/500);  
% Pitch angle dependence (e.g., sin^2(alpha))
f_alpha = (sind(pa)).^2+1;    
% Create full 3D distribution: f(t, alpha, E)
f_EA = f_E' * f_alpha;         
f = repmat(f_EA, 1, 1, length(time)); % Replicate across time dimension
f = permute(f, [3, 2, 1]); % rearrange array to [nt x nAlpha x nE]

%%using this for testing: set all f to 1 erg cm^-2 s^-1
%f(:) = 6.2415e8; % in keV cm^-2 s^-1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate bounce orbit times for E and alpha grid:

%resize pa and E to match dimensions
[pa_arr, E_arr] = meshgrid(pa,E);
%resize Lshell to an array
L_arr = Lshell*ones(size(E_arr)); 
%calculate bounce time
t_b = bounce_time_arr(Lshell,E_arr./1000,deg2rad(pa_arr),'e');
%rearrange array 
t_b = permute(t_b, [2,1]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate energy dissipation for the specified energy grid:

%TODO: this should be evolved over time as well
%specify atmospheric conditions through MSIS
alt   = 0:1:1000; %(altitude in km)
[rho,H] = get_msis_dat(alt, false); 
%calculate energy dissipation for the specified energy grid
f_diss = calc_Edissipation(rho,H,E); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%loop over time to calculate and apply loss rates to f:

for  t=1:10%length(time)-1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %calculate loss factor:

    %initialize loss rate array (nalpha x nE)
    lossfactor = zeros(length(pa),length(E));

    %loop over pitch angle
    for a=1:length(pa)
    
        %calculate mirror point
        mirr_alt = 100; 
        %mirr_alt = mirror_altitude(pa(a),Lshell); %need to fix this
        
        %first check if mirror point is within the atmosphere
        if mirr_alt > alt(end) 
            lossfactor(a,:) = zeros(length(E));
        else
            %calculate loss rates for electrons mirroring within atmosphere
            
            % Find index closest to mirr_alt
            [~, idx] = min(abs(alt - mirr_alt));
              
            %calculate cumulative ionization as function of altitude
            %TODO: use j as number flux, and convert to energy flux as
            %input Qe
            [q_cum,q_tot] = calc_ionization(f(t,a,:),alt,f_diss,H); %rename function to cumulative ionisation
             
            % Get cumulative ionization rate down to mirr_alt
            q_to_mirr_alt = q_cum(idx,:);
             
            %calculate the fraction flux lost
            lossfactor(a,:) = q_to_mirr_alt./q_cum(1,:); 

        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %apply loss factor:
    f_evol = squeeze(f(t,:,:));
    f_tmp = squeeze(lossfactor.*f_evol); 
    dfdt = abs(2*f_tmp./t_b); % apply loss rate over half bounce period
    %if uneven time steps, here define dt=time(t+1)-time(t) 
    
    %apply loss to distribution at each time step of simulation 
    f(t+1,:,:) = f_evol - dfdt.*dt; 

    %check if f becomes negative and set to zero
    f(f<0) = 0;

    semilogy(pa, f(t,:,50))
    %ylim([min(f_evol(t,1:5,50)),max(f_evol(t,1:5,50))])
    hold on
    %f_evol(t,3,1)

end

hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test ionization profiles %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     semilogx(q_tot(:,1),alt)
%     hold on
%     for e=2:length(E)
%         semilogx(q_tot(:,e),alt)
%     end    
%     
%     xlim([10,1e5])
%     ylim([50,400])
%     
%     % Axis labels
%     xlabel('Ionization Rate (cm^{-3} s^{-1})')
%     ylabel('Altitude (km)')
%     
%     % Add minor ticks
%     ax = gca;               % get current axes handle
%     ax.YMinorTick = 'on';   % turn on minor ticks on y-axis
%     ax.XMinorTick = 'on';   % optional — minor ticks on x-axis too
%     
%     legendStrings = strings(1,length(E));
%     for n = 1:length(E)
%         legendStrings(n) = sprintf('%.1f keV', E(n));
%     end
%     legend(legendStrings, 'Location', 'best')
%     
%     title('f_{10.7} = 50.0, Ap = 5.0, incident energy = 1 erg cm^{-2} s^{-1}')
%     
%     hold off




