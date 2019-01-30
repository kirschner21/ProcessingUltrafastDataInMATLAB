function [color] = ColorGenerator(total_colors,color_index)
%   Make the color_index color from a total_colors jet gradient

all_color = jet(total_colors);
color = all_color(color_index,:);

end

