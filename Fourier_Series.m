% Purpose of the function
% - compute Fourier Series approximation for given matrix in 'input_matrix'
% approximation is done for each column
% function uses various interval lengths specified in L and computes approximation
% for each number in L with a given stepsize in variable L_step_size
%
% INPUTS of the function
%
% input_matrix - matrix which columns we wish to approximate
% L - intervals of length of cycles in time series 
% L_step_size - stepsize of the interval of L
% n - is approximation accuracy. Must be EVEN number
%
% OUTPUTs of the function
%
% output_matrix is 2 by length(input_matrix) matrix which consists of the lowest MSE for each column and the
% corresponding L (length of cycle)

function output_matrix = Fourier_Series(input_matrix, L, L_step_size, n)

	% if we call coefficient matrix c, then we have: f(x) = Fc and c = F\f(x)
	% where F is a matrix of sin and cos evaluations and f(x) are the values of a function

	% Number of L's

	L_No = length(10:L_step_size:L);

	% pick up each of column of the input matrix

	input_size = size(input_matrix);

	for t = 1:input_size(1,2)

		% index

		L_index = 0;

		for j = 10:L_step_size:L % choose L from the interval

			L_index = L_index + 1;

			L = j;

			% create matrix fo f(x)

			f = input_matrix(1:n,t);

			% create matrix c for Fourier coefficients

			c = zeros(n,1);

			% create separate matrices for cosine and sine

			Fcos = zeros(n,n/2);

			Fsin = zeros(n,n/2);

			% evaluate both matrices

			for r = 1:n/2 % column

				for k = 1:n % row

					Fcos(k,r) = cos(pi*r*f(k,1)/L);

					Fsin(k,r) = sin(pi*r*f(k,1)/L);

				end

			end

			% put the matrices together

			F = [Fcos Fsin];

			% calculate coefficients c

			c = pinv(F)*f;

			% build Fourier series using c. By construction of vector c we know that
			% from 1:length(c)/2 are coefficients for cos and length(c)/2:end are coefs for sin

			a = c(1:n/2);
			b = c(n/2+1:end);

			% compute Fourier series using the coeffiecients

			F_series = zeros(input_size(1,1),1);

			for h = 1:length(F_series)

				Four_series = 0;

				for d = 1:n/2

					Four_series = mean(input_matrix(:,t)) + sum(a(d,1)*cos(d*pi*h/L)) + sum(b(d,1)*sin(d*pi*h));

				end

				F_series(h,1) = Four_series;

			end

			% compute MSE (Mean Square Error)

			MSE = mean((input_matrix(:,t)-F_series).^2);

			% construct the vector of MSE's for different L's

			L_MSE(L_index,1) = MSE;
			L_MSE(L_index,2) = L;

		end % end L's

		% find & save the lowest MSE with corresponding L

		size_L_MSE = size(L_MSE);

		for kb = 1:size_L_MSE(1,1)

			if min(L_MSE(:,1)) - L_MSE(kb,1) == 0

				Lowest_MSE = L_MSE(kb,:);

			end

		end

		% store output for each column

		output_matrix(t,:) = Lowest_MSE;

		disp('No of Columns Finished -->');

		t

	end % end columns of input matrix

end % end of function

