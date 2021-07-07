function y = smooth(x, method, range, holey)
if(nargin<3 || nargin>4)
    error('Wrong number of arguments');
end
if(nargin == 3)
    holey = 0;
end
if( min(size(x))>1)
    error('Argument x must be one dimensional vector');
end
if(size(x,1)>size(x,2))
    x=x';
end

if(isa(method, 'char'))
    if(strcmp(method, 'med') || strcmp(method, 'median'))
        method = 0;
    elseif(strcmp(method,'ave') || strcmp(method, 'mean') || strcmp(method, 'avg'))
        method = 1;
    else
        error('Uncorrect method (argument 2). Use "med" for median or "ave" for average');
    end
end
if(isa(holey, 'char'))
    if(strcmp(holey, 'h') || strcmp(holey, 'holey'))
        holey = 1;
    elseif(strcmp(holey, 'w'))
        holey=2;
    else
        holey = 0;
    end
else
    if(holey ~= 0 && holey ~=1 && holey~=2)
        error('Wrong value for parameter holey');
    end
end

if(mod(range,2) == 0)
    error('range must be an odd number');
end

% -------------------------------------------------------------------------
if(method == 1) % averaging filters
    if(holey~=2)
        h = ones(1, range);
        if(holey == 1)
            h(ceil(range/2)) = 0;
        end
        h = h/sum(h);
        y = filter2(h, x);
    else % wypelnienie
        h = ones(1, range);
        h = h/sum(h);
        yn = filter2(h, x);
        yn = yn./range;
        
        h = ones(1, range);
        h(ceil(range/2)) = 0;
        h = h/range; % here is the change
        yh = filter2(h, x);
        
        y = yh + yn;
    end
else
    if(holey == 0)
        h = ones(1,range);
        y = ordfilt2(x, ceil(range/2), h, 'symmetric');
    elseif(holey==1)
        h = ones(1,range);
        h(ceil(range/2)) = 0;
        y1 = ordfilt2(x, floor(range/2), h, 'symmetric');
        y2 = ordfilt2(x, floor(range/2) + 1, h, 'symmetric');
        y = (y1+y2)/2;
    else
        h = ones(1,range);
        yn = ordfilt2(x, ceil(range/2), h, 'symmetric');
        
        d= floor(range/2);
        ypad = padarray(x, [0, d], 'replicate', 'both');
        y = zeros(size(x));
        for i=1+d : length(x) + d
            tmp = ypad(i-d:i+d);
            tmp(d+1) = yn(i-d);
            y(i-d) = median(tmp);
        end
    end 
end