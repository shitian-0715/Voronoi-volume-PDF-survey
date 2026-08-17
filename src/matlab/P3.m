function [x, y] = P3(a, b, c)
    % Function to calculate and return x and y values based on the specified mathematical expression
    % Inputs:
    %   a - parameter a
    %   b - parameter b
    %   c - parameter c

    x = 0:0.01:7; % Create x values from 0 to 5 with a step of 0.01
    
    % Calculate y values based on the given equation
    y = (c * b^(a/c) / gamma(a/c)) .* (x.^(a - 1)) .* exp(-b .* (x.^c));
end

