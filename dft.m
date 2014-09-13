% Purpose of the function
% compute Fast Fourier Transform (FFT) of a given matrix.
% code takes each column as an input
%
% INPUTS of the function
%
% input_matrix - matrix which columns we wish to transform using FFT
%
% OUTPUTs of the function
%
% Fourier_T is a matrix of the same dimmension as an input matrix. Each column of 
% the output matrix is an FFT of the respective column of input matrix
% This function does exactly the same as matlab's built in function fft().

function Fourier_T = dft(input)

	n           = length(input);
	size_in     = size(input);
	Fourier_T   = zeros(size_in);


	for g = 1 : size_in(1,2)

		a = input(:,g);

		for k = 0 : n - 1  % For each output element

  		s = 0;

			for j = 0 : n - 1  % For each input element
    
      		s = s + (1/sqrt(n))*(a(j + 1) * exp(i * 2 * pi * j * k / n));
    
    		end


    	Fourier_T(k+1,g) = s;


		end

		disp('No of Columns Done -->')
		g

	end

end

