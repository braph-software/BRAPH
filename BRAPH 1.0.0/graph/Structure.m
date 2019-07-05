classdef Structure < handle & matlab.mixin.Copyable
    % Structure < handle & matlab.mixin.Copyable : Creates and implements structure
    %   Structure represents a custom structure or a set of parameters that 
    %   define how a structure should be calculated.
    %
    % Structure properties (Constant):
    %
    %   CI_DEFAULT          -   default community structure
    %   ALGORITHM_LOUVAIN   -   specification of 'Louvain' algorithm 
    %   ALGORITHM_NEWMAN    -   specification of 'Newman' algorithm
    %   ALGORITHM_FIXED     -   specification of 'fixed' algorithm
    %   ALGORITHM_DEFAULT   -   default algorithm
    %   GAMMA_DEFAULT       -   default gamma value
    %   NOTES_DEFAULT       -   default notes
    %
    % Structure properties (Access = protected):
    %   Ci                  -   custom structure
    %   algorithm           -   algorithm
    %   gamma               -   gamma value
    %   notes               -   notes
    %
    % Structure properties:
    %   Structure       - constructor
    %   disp            - displays structure
    %   setCi           - sets community structure
    %   getCi           - gets community structure
    %   getLength       - gets length of structure
    %   getAlgorithm    - gets algorithm
    %   setAlgorithm    - sets algorithm
    %   getGamma        - gets gamma
    %   setGamma        - sets gamma
    %   getNotes        - gets community notes
    %   setNotes        - sets community notes
    %   isFixed         - check if structure is fixed
    %   isDynamic       - check if structure is dynamic
    %   extract         - extracts community structure
    %
    % See also Graph, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % structure
        CI_DEFAULT = []
        
        % algorithm
        ALGORITHM_LOUVAIN = 'Louvain'
        ALGORITHM_NEWMAN = 'Newman'
        ALGORITHM_FIXED = 'fixed'
        ALGORITHM_DEFAULT = Structure.ALGORITHM_LOUVAIN

        % gamma
        GAMMA_DEFAULT = 1
        
        % notes
        NOTES_DEFAULT = '---'
    end
    properties (Access = protected)
        Ci  % community structure
        algorithm
        gamma
        notes
    end
    methods
        function ci = Structure(varargin)
            % STRUCTURE() creates a structure with default properties.
            %   It defines a custom structure or a set of parameters that define
            %   how a structure should be calculated.
            %
            % STRUCTURE(Property1,Value1,Property2,Value2,...) initializes property
            %   Property1 to Value1, Property2 to Value2, ... .
            %   Admissible properties are:
            %       Ci          -   custom community structure (default = [])
            %       algorithm   -   ALGORITHM_LOUVAIN (default) | ALGORITHM_NEWMAN
            %                       ALGORITHM_FIXED
            %       gamma       -   modularity resolution parameter
            %                       gamma=1     -   'classic' modularity (default)
            %                       gamma>1     -   detects smaller modules
            %                       0<=gamma<1  -   detects larger modules
            %       notes       -   structure notes
            %   If a custom community structure is specified, ALGORITHM_FIXED parameter
            %   should also provided as an input.
            %
            % See also Structure.

            ci.Ci = Structure.CI_DEFAULT;
            ci.gamma = Structure.GAMMA_DEFAULT;
            ci.algorithm = Structure.ALGORITHM_DEFAULT;
            ci.notes = Structure.NOTES_DEFAULT;
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'ci'
                        ci.Ci = varargin{n+1};
                    case 'gamma'
                        ci.gamma = varargin{n+1};
                    case 'algorithm'
                        ci.algorithm = varargin{n+1};
                    case 'notes'
                        ci.notes = varargin{n+1};
                end
            end
        end
        function disp(cs)
            % DISP displays structure
            %
            % DISP(CS) displays the community structure of CS and its properties.
            %
            % See also Structure.

            if cs.isFixed()
                disp(['<a href="matlab:help Structure">Structure</a> (fixed; ' num2str(cs.Ci) '; notes=' cs.getNotes() ')'])
            else
                disp(['<a href="matlab:help Structure">Structure</a> (algorithm=' cs.getAlgorithm() '; gamma=' num2str(cs.getGamma()) '; notes=' cs.getNotes() ')'])
            end
        end        
        function setCi(cs,ci)
            % SETCI sets community structure
            %
            % SETCI(CS,CI) sets the community structure of the object CS to 
            %   the custom structure defined by CI.
            %   The CI should be an array of positive integers.
            %
            % See also Structure.
            
            Check.isinteger('The structure must be a vector of positive integers',ci,'>',0)
            
            if isrow(ci)
                cs.Ci = ci;
            elseif iscolumn(ci)
                cs.Ci = ci';                
            else
                error('Ci must be a row vector of positive integers')
            end
        end
        function Ci = getCi(cs)
            % GETCI gets community structure
            %
            % S = GETCI(CS) gets the community structure of the object CS and returns it as Ci.
            %
            % See also Structure.
            
            Ci = cs.Ci;
        end
        function L = getLength(cs)
            % GETLENGTH gets length
            %
            % L = GETLENGTH(CS) gets the length of the community structure of the
            %   object CS and returns it as L.
            %
            % See also Structure, length.
            
            L = length(cs.Ci);
        end
        function algorithm = getAlgorithm(cs)
            % GETALGORITHM gets algorithm
            %
            % ALGORITHM = GETALGORITHM(CS) gets the algorithm property of the
            %   object CS and returns it as ALGORITHM.
            %
            % See also Structure.
            
            algorithm = cs.algorithm;
        end
        function setAlgorithm(cs,algorithm)
            % SETALGORITHM sets algorithm
            %
            % SETALGORITHM(CS,ALGORITHM) sets the algorithm property of the
            %   object CS as ALGORITHM.
            %   Admissible inputs are:
            %       ALGORITHM_LOUVAIN   -   Louvain algorithm (default)
            %       ALGORITHM_NEWMAN    -   Newman algorithm
            %       ALGORITHM_FIXED     -   fixed community structure algorithm
            %
            % See also Structure.
            
            if strcmp(algorithm,Structure.ALGORITHM_LOUVAIN) || strcmp(algorithm,Structure.ALGORITHM_NEWMAN)
                cs.algorithm = algorithm;
            else
                cs.algorithm = Structure.ALGORITHM_FIXED;
            end
        end
        function gamma = getGamma(cs)
            % GETGAMMA gets gamma
            %
            % GAMMA = GETGAMMA(CS) gets the gamma property of the
            %   object CS and returns it as GAMMA.
            %
            % See also Structure.
            
            gamma = cs.gamma;
        end
        function setGamma(cs,gamma)
            % SETGAMMA sets gamma
            %
            % SETGAMMA(CS,GAMMA) sets the gamma property of the object CS as GAMMA.
            %   Gamma is the modularity resolution parameter and should be a positive
            %   number.
            %
            % See also Structure.
            
            Check.isnumeric('Gamma should be a positive number',gamma,'>=',0)
            cs.gamma = gamma;
        end
        function note = getNotes(cs)
            % GETNOTES gets community notes
            %
            % NOTE = GETNOTES(CS) gets the notes about the object CS and returns them as NOTE.
            %
            % See also Structure.
            
            note = cs.notes;
        end
        function setNotes(cs,notes)
            % SETNOTES sets community notes
            %
            % SETNOTES(CS,NOTES) sets the notes about the object CS as
            %   NOTES.
            %
            % See also Structure.
            
            if ischar(notes)
                cs.notes = notes;
            end
        end
        function bool = isFixed(cs)
            % ISFIXED returns if structure is fixed
            %
            % BOOL = ISFIXED(CS) returns true if CS's algotrithm is 'fixed' 
            %   and false otherwise.
            %
            % See also Structure.
            
            if strcmp(cs.getAlgorithm(),Structure.ALGORITHM_FIXED)
                bool = true;
            else
                bool = false;
            end
        end
        function bool = isDynamic(cs)
            % ISDYNAMIC returns if structure is dynamic
            %
            % BOOL = ISDYNAMIC(CS) returns true if CS's algotrithm is not 'fixed'
            %   and false otherwise.
            %
            % See also Structure.

            bool = ~cs.isFixed();
        end
        function scs = extract(cs,brs)
            % EXTRACT extracts subcommunity structure
            %
            % SCS = EXTRACT(CS,BRS) makes a copy SCS of community structure CS
            % 	that include all elements BRS in the case of fixed structure.
            %   In the case of dynamic structure, it just makes a copy.
            %
            % See also Structure.

            scs = copy(cs);
            
            if cs.isFixed()
                scs.Ci = scs.Ci(brs);
            end
        end
    end
end