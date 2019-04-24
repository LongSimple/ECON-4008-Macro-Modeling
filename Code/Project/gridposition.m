function [position] = gridposition(grid, value)
%%% this function is to look up value that falls in between two grid
%%% points, and return the position of the lower grid bound. 
%%% grid: the original grid rule (one dimensional) 
%%% value: the value that falls on the grid
unit = ones(size(grid));
resource = value*unit - grid;
position = sum(resource > 0);
if position <= 0
    position = 1;
end
