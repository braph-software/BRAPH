function R = int2reg(I1,I2,MAXI2)
% INT2REG Returns the register number associated to some indices
%
% R = INT2REG(I1,I2,MAXI2) returns the register number R associated to
%   indices I1 and I2.
%   I1 and I2 must be positive integer matrices (I2<=MAXI2).
%   MAXI2 must be a positive integer.
%
% See also reg2int.

% Author: Giovanni Volpe
% Date: 2016/01/01

Check.samesize('The indices I1 and I2 must have the same size.',I1,I2)
Check.isinteger('The index I1 must be a positive integer',I1,'>',0)
Check.isinteger('The index I2 must be a positive integer <= I2',I2,'>',0,'<=',MAXI2)
Check.samesize('The maximum index MAXI2 must be a scalar.',MAXI2,0)
Check.isinteger('The maximum index MAXI2 must be a positive integer',MAXI2,'>',0)

R = (I1-1).*MAXI2 + I2;