clc
clear all 
re_x = [8.3333e-04 3.3333e-05 8.3333e-06]; %Retrieving the values from our error calc
h = [1/10 1/50 1/100]; %h = 1/n
plot(log(h), log(re_x))
fprintf("Slope and Y-Intercept are")
polyfit(log(h), log(re_x), 1) %returns slope and y-intercept for the plot

%%Comments on Slope and Y-Intercept%%
%As seen from the graph the slope is a constant and equal to 2. By fitting
%the polynomial of form re_x = C*h^n, we get a value of 2 which shows 2nd
%order convergence in relative error of the derievative at midpoints. 