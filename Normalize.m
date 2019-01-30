function [a] = Normalize(a,varargin)
% Normalizes the vector a
%   The normalization can be done in a number of ways:
%   'abs' (default) sets the largest magnitude to 1,
%   'max' sets the max value to 1, 'min' sets the min value to -1,
%   'zero_to_one' sets the max value to 1 and the min value to 0,
%   'first' sets the first value to 1, 'end' sets the last value to 1

if isempty(varargin)
    key = 'abs';
else
    key = varargin{1};
end

if strcmp(key,'max')
    a = a/max(a);
elseif strcmp(key,'min')
    a = a/abs(min(a));
elseif strcmp(key,'zero_to_one')
    a = (a-min(a))/max(a-min(a));
elseif strcmp(key,'first')
    a = a/a(1);
elseif strcmp(key,'end')
    a = a/a(end);
else
    a = a/max(abs(a));
end

end

