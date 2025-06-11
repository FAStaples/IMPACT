function [bt] = bounce_time_arr(L,pc,alpha,varargin)
%adapted from Adam's bounce_time_new function, but added a .* to use for
%matrix arrays
% can specify electrons 'e', or protons, 'p'
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


Re = 6.371e6;
%exp1 = 2.7183;
%B_0 = 0.311;
c_si = 2.998e8;

bt = 4.0 .* L .* Re .* mc2 ./ pc ./ c_si .* T(alpha) / 60 / 60 / 24;