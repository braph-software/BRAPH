classdef Check
    % Check : Input validation
    %
    % Check methods:
	%   samesize        -   (Static) Validate same size variables
    %   samelength      -   (Static) Validate same length variables
    %   isnumeric       -   (Static) Validate number
    %   isreal          -   (Static) Validate real number
    %   isinteger       -   (Static) Validate integer number
    %   isa             -   (Static) Validate object class

	%   Author: Giovanni Volpe
    %   Date: 2016/01/01

    methods (Static)
        function samesize(msg,x,y,varargin)
            % SAMESIZE Validate same size variables
            %
            % SAMESIZE(MSG,X,Y) returns the error message MSG 
            %   if the sizes of X and Y are not equal.
            %
            % More than two variables can be checked at once, e.g., 
            %   SAMESIZE(MSG,X,Y,Z,W,T)
            %
            % See also Check.
            
            if ~isequal(size(x),size(y))
                error(msg);
            end
            for n = 1:1:length(varargin)
                if ~isequal(size(x),size(varargin{n}))
                    error(msg);
                end
            end
            
        end
        function samelength(msg,x,y,varargin)
            % SAMELENGTH Validate same length variables
            %
            % SAMELENGTH(MSG,X,Y) returns the error message MSG 
            %   if the lengths of X and Y are not equal.
            %
            % More than two variables can be checked at once, e.g., 
            %   SAMELENGTH(MSG,X,Y,Z,W,T)
            %
            % See also Check.
            
            if ~isequal(length(x),length(y))
                error(msg);
            end
            for n = 1:1:length(varargin)
                if ~isequal(length(x),length(varargin{n}))
                    error(msg);
                end
            end
            
        end
        function isnumeric(msg,x,varargin)
            % ISNUMERIC Validate number
            %
            % ISNUMERIC(MSG,X) returns the error message MSG if X is not a number.
            %
            % ISNUMERIC(MSG,X,'~=',Y) returns the error message MSG if X~=Y is not verified.
            %
            % ISNUMERIC(MSG,X,'<',Y) returns the error message MSG if X<Y is not verified.
            %
            % ISNUMERIC(MSG,X,'<=',Y) returns the error message MSG if X<=Y is not verified.
            %
            % ISNUMERIC(MSG,X,'>',Y) returns the error message MSG if X>Y is not verified.
            %
            % ISNUMERIC(MSG,X,'>=',Y) returns the error message MSG if X>=Y is not verified.
            %
            % Multiple couples of relation and value are also allowed, e.g., 
            %   ISNUMERIC(MSG,X,'>',0,'<',10)
            %
            % See also Check.

            if ~isnumeric(x)
                error(msg);
            end
            
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'~=')
                    tmp = ~(x~=varargin{n+1});
                    if sum(tmp(:))
                        error(msg);
                    end
                end
                if strcmpi(varargin{n},'>')
                    tmp = ~(x>varargin{n+1});
                    if sum(tmp(:))
                        error(msg);
                    end
                end
                if strcmpi(varargin{n},'>=')
                    tmp = ~(x>=varargin{n+1});
                    if sum(tmp(:))
                        error(msg);
                    end
                end
                if strcmpi(varargin{n},'<')
                    tmp = ~(x<varargin{n+1});
                    if sum(tmp(:))
                        error(msg);
                    end
                end
                if strcmpi(varargin{n},'<=')
                    tmp = ~(x<=varargin{n+1});
                    if sum(tmp(:))
                        error(msg);
                    end
                end
            end
        end
        function isreal(msg,x,varargin)
            % ISREAL Validate real number
            %
            % ISREAL(MSG,X) returns the error message MSG if X is not a real number.
            %
            % ISREAL(MSG,X,'~=',Y) returns the error message MSG if X~=Y is not verified.
            %
            % ISREAL(MSG,X,'<',Y) returns the error message MSG if X<Y is not verified.
            %
            % ISREAL(MSG,X,'<=',Y) returns the error message MSG if X<=Y is not verified.
            %
            % ISREAL(MSG,X,'>',Y) returns the error message MSG if X>Y is not verified.
            %
            % ISREAL(MSG,X,'>=',Y) returns the error message MSG if X>=Y is not verified.
            %
            % Multiple couples of relation and value are also allowed, e.g., 
            %   ISREAL(MSG,X,'>',0,'<',10)
            %
            % See also Check.
            
            Check.isnumeric(msg,x,varargin{:});
            
            if ~isreal(x)
                error(msg);
            end
        end
        function isinteger(msg,x,varargin)
            % ISINTEGER Validate integer number
            %
            % ISINTEGER(MSG,X) returns the error message MSG if X is not an integer number.
            %
            % ISINTEGER(MSG,X,'~=',Y) returns the error message MSG if X~=Y is not verified.
            %
            % ISINTEGER(MSG,X,'<',Y) returns the error message MSG if X<Y is not verified.
            %
            % ISINTEGER(MSG,X,'<=',Y) returns the error message MSG if X<=Y is not verified.
            %
            % ISINTEGER(MSG,X,'>',Y) returns the error message MSG if X>Y is not verified.
            %
            % ISINTEGER(MSG,X,'>=',Y) returns the error message MSG if X>=Y is not verified.
            %
            % Multiple couples of relation and value are also allowed, e.g., 
            %   ISINTEGER(MSG,X,'>',0,'<',10)
            %
            % See also Check.
            
            Check.isnumeric(msg,x,varargin{:});
            
            if x~=round(x)
                error(msg);
            end
        end
        function isa(msg,obj,class,varargin)
            % ISA Validate same size
            %
            % ISA(MSG,OBJ,CLASS) returns the error message MSG 
            %   if the class of the object OBJ is not CLASS.
            %
            % More than one class can be checked at once, e.g., 
            %   ISA(MSG,OBJ,CLASS1,CLASS2,CLASS3)
            %
            % See also Check.

            check = false;
            if isa(obj,class)
                check = true;
            end
            for n = 1:1:length(varargin)
                if isa(obj,varargin{n})
                    check = true;
                end
            end
            if ~check
                error(msg);
            end
        end
    end
end