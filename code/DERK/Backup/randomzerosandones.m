num_geladas = 12;

num_males = 11;
gender = zeros(num_geladas,1)  % set all to zero
ix = randperm(numel(gender)) % randomize the linear indices
ix = ix(1:num_males) % select the first 
gender(ix) = 1 % set the corresponding positions to 1
