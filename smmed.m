function [ym, em] = smmed(y, l)
ym = smooth(y, 'med', l);
ym0 = smooth(y, 'med', l, 'h');
em = y - ym0;