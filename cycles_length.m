% Purpose of the function
% takes a matrix of power and find the maximum of each column
%
%
% INPUTS of the function
%
% input_matrix - matrix of power, we wish to find maximum of that column and corresponding window length
% window length is the same as the number of max entry in each column
%
% OUTPUTs of the function
%
% vector of max power for each window length

function output = cycles_length(input)

	% compute time index

	time_index = 1:1:length(input);

	% add time index to the matrix

	A_input = [time_index' input];

	% find and store length of the strongest cycle for each window length

	size_in = size(A_input);

	output  = zeros(1,size_in(1,2)-1);

	for ka = 2:size_in(1,2)

		for kb = 1:size_in(1,1)

			if max(A_input(:,ka)) - A_input(kb,ka) == 0

				output(1,ka) = A_input(kb,1);

			end

		end

	end

end


