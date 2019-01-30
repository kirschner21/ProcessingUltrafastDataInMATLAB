function [fi,li] = DetermineIndices(inarray,first,last)
% finds indices in an array

fi = find(inarray>first,1); %find lower bound
li = find(inarray>last,1)-1; %find upper bound

% check for when the values can't be found
if isempty(fi)
    fi = 1;
end

if isempty(li)
    li = length(inarray);
end


end

