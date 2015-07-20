% [a e i Om w year days] = tle2oe(line_1, line_2)
%      line_1 is the content of the first line of the
%            two-line element sets (TLE)
%      line_2 is the content of the second line of the
%            two-line element sets (TLE)
%      return a 1x7 matrix containing the orbital elements
%             and Epoch [a e i Om w year days]
% This function returns the orbital elements from a TLE.
function [a e i Om w year days] = tle2oe(line_1,line_2)
% The value of mu is for the earth
mu = 3.98601e5;

% Parse first line
tle.satnum = str2double(line_1(3:7));
tle.classification = line_1(8);
tle.international_designator = line_1(10:17);
tle.epoch_year = str2double(line_1(19:20));
tle.epoch_days = str2double(line_1(21:32));

% Parse second line
tle.i = str2double(line_2(9:16));   % inclinaison [Deg]
tle.Om = str2double(line_2(18:25)); % Right Ascension of the Ascending Node [Deg]
tle.e = str2double(line_2(27:33));  % Eccentricity
tle.w = str2double(line_2(35:42));  % Argument of Perigee [Deg]
tle.M = str2double(line_2(44:51));  % Mean Anomaly [Deg]
tle.n = str2double(line_2(53:63));  % Mean Motion [Revs/day]
   
% Assign variables to the orbital elements
i  = tle.i * (pi/180);           % Inclination
Om = tle.Om * (pi/180);          % Right Ascension of the Ascending Node
e  = tle.e / (1e7);              % Eccentricity
w = tle.w * (pi/180);            % Argument of periapsis
M  = tle.M * (pi/180);           % Mean anomaly
n  = tle.n * (2*pi) / (24*3600); % Mean motion
a = (mu/n^2)^(1/3);              % Semi-major axis
year = tle.epoch_year;
days = tle.epoch_days;