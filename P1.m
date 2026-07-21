function [x, y] = P1(d)
    % Function to calculate and return x and y values based on the specified mathematical expression
    % Inputs:
    %   a - parameter a
    %   b - parameter b
    %   c - parameter c

    x = 0:0.01:7; % Create x values from 0 to 5 with a step of 0.01
    
    % Calculate y values based on the given equation
    y = ((3 * d + 1)/2)^((3 * d + 1)/2) / gamma((3 * d + 1)/2) .* x.^((3 * d - 1)/2) .* exp(-(3 * d + 1)/2 .* x);
end

