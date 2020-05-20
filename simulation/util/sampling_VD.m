function [sampling_grid] = sampling_VD(size_f, u, sigma)
    mu = size_f(1)/2;
    
    %a = round( normrnd(mu,sigma,1,round(size_f(1)*u))  );
    %a(end+1) = floor(size_f(1)/2);
    %a(floor(size_f(1)/2))=1;
    %a(a<1)=1 ; a(a>size_f(1))=size_f(1); 
   
    n_lines = round(sigma*mu*2);
    a = randperm(n_lines,round(n_lines*u)) + round(mu-n_lines/2); 
    
    if (any(a == mu)) == 0
        a = [a mu];
    end
    sampling_grid = zeros(size_f(1), size_f(2));

    for i =1:length(a)    
        sampling_grid(a(i),:)=ones(1,size_f(2));
    end
end