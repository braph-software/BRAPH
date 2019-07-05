function [I1,I2] = reg2int(R,MAXI2)
% REG2INT Returns the indices associated to a register number
%
% [I1,I2] = REG2INT(R,MAXI2) returns the indices I1 and I2 associated to
%   register numebr R.
%   R must be an positive integer matrix.
%   MAXI2 must be a positive integer.
%
% See also int2reg.

% Author: Giovanni Volpe
% Date: 2016/01/01

Check.isinteger('The index R must be a positive integer',R,'>',0)
Check.samesize('The maximum index MAXI2 must be a scalar.',MAXI2,0)
Check.isinteger('The maximum index MAXI2 must be a positive integer',MAXI2,'>',0)

I1 = ceil(R/MAXI2);
I2 = R - (I1-1).*MAXI2;