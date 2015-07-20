clc;
close all;
clear all;

%%                           TLE ANALYSIS
% Earth radius [km]
Re = 6371;

% The value of mu is for the earth [km3s-2]
mu = 398600.4418;

% Open the TLE file and read TLE elements
fid = fopen('TLE_list.txt', 'rb');

% Loop on each TLE
j = 1;
while ~feof(fid)
    % Read lines & parse elements
    name = char(fgetl(fid));
    line_1 = fgetl(fid);
    line_2 = fgetl(fid);
    [a e i Om w year days] = tle2oe(line_1, line_2);
    
    % Orbital parametres
    T = 2*pi*sqrt(a^3/mu)/60; % Period in [min]
    h_p = (1 - e)*a - Re;     % Perigee Altitude [km]
    h_a = (1 + e)*a - Re;     % Apogee Altitude [km]
    A(j) = a;
    I(j) = i*180/pi;
    
    % Compute Epoch
    if (year < 57)
        Eyear= year + 2000;
    else
        Eyear= year + 1900;
    end
    [Emon,Eday,Ehr,Emin,Esec] = days2mdh(year,days);
    UTsec = Ehr*3600+Emin*60+Esec;
        
    % Display orbit characteristics
    fprintf('Spacecraft Name: %s\n', name);
    fprintf('Epoch Year     : %5i\n', Eyear);
    fprintf('Epoch Month    : %5i\n', Emon);
    fprintf('Epoch Day      : %5i\n', Eday);
    fprintf('UT             : %5.2f [s]\n', UTsec);
    fprintf('Semi-major axis (a): %.3f [km]\n', a);
    fprintf('Eccentricity (e)   : %f\n', e);
    fprintf('Inclination (i)    : %f [deg]\n', i*180/pi);
    fprintf('Argument of Perigee (w) : %f [deg]\n', w*180/pi);
    fprintf('Right Ascension of the Ascending Node (Om): %f [deg]\n', Om*180/pi);
    fprintf('Periode (T)      : %.1f [min]\n', T);
    fprintf('Perigee Altitude : %.3f [km]\n', h_p);
    fprintf('Apogee Altitude  : %.3f [km]\n', h_a);
    fprintf('\n');
    
    j = j+1;
end
fclose(fid);

% SSO condition (-9.97*((Re/a)^(7/2))*cos(i) = 0.985�/day)
a = min(A):1:max(A);
i = zeros(1,length(a));
i = acos((0.985)./(-9.97.*((Re./a).^(7./2))));

% My Spacecraft data
spacecraft_a = 7020.1;
spacecraft_i = 98.0088;
spacecraft_e = 0.001058;
spacecraft_w = 90;
T = 2*pi*sqrt(spacecraft_a^3/mu)/60; % Period in [min]
h_p = (1 - spacecraft_e)*spacecraft_a - Re;     % Perigee Altitude [km]
h_a = (1 + spacecraft_e)*spacecraft_a - Re;     % Apogee Altitude [km]
fprintf('Spacecraft Name: %s\n', 'SPACECRAFT');
fprintf('Semi-major axis (a): %.3f [km]\n', spacecraft_a);
fprintf('Eccentricity (e)   : %f\n', spacecraft_e);
fprintf('Inclination (i)    : %f [deg]\n', spacecraft_i);
fprintf('Argument of Perigee (w) : %f [deg]\n', spacecraft_w);
fprintf('Periode (T)      : %.1f [min]\n', T);
fprintf('Perigee Altitude : %.3f [km]\n', h_p);
fprintf('Apogee Altitude  : %.3f [km]\n', h_a);
fprintf('\n');

% Plot points and SSO graph
figure(1);
plot (a, i*180/pi, '-r', spacecraft_a, spacecraft_i, 'or')
legend('SSO', 'SPACECRAFT');
hold on;
scatter(A,I,'b*');
grid on;
xlabel('Semi-major axis [km]');
ylabel('Inclination [deg]');
title('Inclination against semi-major axis and SSO requirement');
