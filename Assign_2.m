clear all  
warning('off', 'all')
R=[];
n = input('Enter the no. of elements (n) :'); %Takes no. of elements in grid as input
q=1; %Assuming the value of q = 1 for simplicity
h = 1/n; 
X=0:h:1; 
f = @(x) q*x; 
K = zeros(n, n); %Inititalizing K & F matrices (Global) with zeros. 
F = zeros(n,1); 
k = (1/h)*[1 -1; -1 1]; %Local Stiffness Matrix 
i=1;
%
%
% Assembly and Solution of Matrix Form
for i=1:n-1
    K(i,i) = K(i, i) + 1; 
    K(i, i+1) = K(i, i+1) - 1;
    K(i+1, i) = K(i+1, i) - 1; 
    K(i+1, i+1) = K(i+1, i+1) + 1; 
    F(i, 1) = F(i, 1) + (2*f(X(i))+f(X(i+1)));
    F(i+1, 1) = F(i+1, 1) + (f(X(i)) + 2*f(X(i+1))); 
end
for i=n
    K(i,i) = K(i, i) + 1;
    F(i, 1) = F(i, 1) + (2*f(X(i))+f(X(i+1))); 
end 
K1 = (1/h)*K;
F1 = (h/6)*F;
d = linsolve(K1,F1); %Solves system of linear eqns of form AX = B
%fprintf("Stiffness Matrix (K) \n")
%disp(K1)
%fprintf("Force Vector (F) \n")
%disp(F1)
%fprintf("Displacement Vector (d) \n")
%disp(d)
%%
q=1; 
N = zeros(n+1 , 1); %Initializing a zero matrix to generate shape functions
Uh = [];  %Empty Array to contain the value of approx soln at nodes
X=0:h:1; 
%
%
%Generating Shape Functions
for x=0:h:1
    uh = 0;
    N = shapefunc(n, x);         %Call out the defined function
    for i = 1:length(d)
        uh = uh + d(i)*double(N(i));      %Generate approx soln (uh)
    end
    Uh(end+1, 1) = uh; %Store uh corresponding to every nodes in Uh for particular n
end
%fprintf("Approximate Solution at nodes \n")
%disp(Uh);
%
%
%Plotting exact vs approximate solns
ue = @(x) (q/6)*(1-x^3); %Define the exact soln
fplot(ue, [0 1], 'LineWidth', 1.5) %Plot exact soln
hold on 
plot(X, Uh, 'LineWidth', 1.5) %plot approx soln for given n.
%legend('exact', sprintf('n = %d', n));
%
%
%Relative Error in u_x
x = 1/(2*n); %Evaluate Error at the midpoints of elements
ue_x = -(q*x*x)/2;
U_diff = [Uh(1,1) Uh(2,1)];
X_diff = [X(1,1) X(1,2)];
uh_x = (U_diff(2) - U_diff(1))/(X_diff(2)-X_diff(1)); %can be calculated from slope of uh in a given element interval
re_x = norm((uh_x - ue_x)/(q/2)); %Relative Error
sprintf('for n = %d', n)
fprintf("Relative Error in derievative at middle of elements is (re_x):")
disp(re_x) 
%
%
%Code to define function and generate shape functions for given n & x
%value
function N = shapefunc(n, p) 
R = [];
X = 0:1/n:1; 
i=1;
while i<=n+1 
if i == 1
    if (X(1) <= p) && (p <= X(2))
        N(i) = (X(2) - p) / (X(2) - X(1));
    else 
        N(i) = 0;
    end 
end
if i == n + 1
    if (X(n) <= p) && (p <= X(n + 1))
        N(i) = (p - X(n)) / (X(n + 1) - X(n));
    else 
        N(i) = 0;
    end 
end
if (2<=i) && (i<=n) 
     if (X(i-1) <= p) && (p <= X(i)) 
         N(i) = (p - X(i-1)) / (X(i) - X(i-1));
     elseif (X(i) <= p) && (p <= X(i + 1))
         N(i) = (X(i + 1) - p) / (X(i + 1) - X(i));
     else 
         N(i) = 0;
     end 
end
i=i+1;
end
end