classdef PETRandomComparisonBUD < PETMeasureBUD
    % PETRandomComparisonBUD < PETMeasureBUD : Fixed density binary undirected PET random comparison
    %   PETRandomComparisonBUD represents PET comparison of binary undirected graph with fixed density with random graphs.
    %
    % PETRandomComparisonBUD properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % PETRandomComparisonBUD properties (Constants):
    %   CODE                -   code numeric code < PETMeasure
    %   CODE_TAG            -   code tag < PETMeasure
    %   CODE_FORMAT         -   code format < PETMeasure
    %   CODE_DEFAULT        -   code default < PETMeasure
    %
    %   PARAM               -   parameters numeric code < PETMeasure
    %   PARAM_TAG           -   parameters tag < PETMeasure
    %   PARAM_FORMAT        -   parameters format < PETMeasure
    %   PARAM_DEFAULT       -   parameters default < PETMeasure
    %
    %   NOTES               -   notes numeric code < PETMeasure
    %   NOTES_TAG           -   notes tag < PETMeasure
    %   NOTES_FORMAT        -   notes format < PETMeasure
    %   NOTES_DEFAULT       -   notes default < PETMeasure
    %
    %   GROUP1              -   group1 numeric code < PETMeasure
    %   GROUP1_TAG          -   group1 tag < PETMeasure
    %   GROUP1_FORMAT       -   group1 format < PETMeasure
    %   GROUP1_DEFAULT      -   group1 default < PETMeasure
    %
    %   VALUES1             -   values1 numeric code < PETMeasure
    %   VALUES1_TAG         -   values1 tag < PETMeasure
    %   VALUES1_FORMAT      -   values1 format < PETMeasure
    %   VALUES1_DEFAULT     -   values1 default < PETMeasure
    %
    %   DENSITY             -   density numeric code < PETMeasureBUD
    %   DENSITY_TAG     	-   density tag < PETMeasureBUD
    %   DENSITY_FORMAT      -   density format < PETMeasureBUD
    %   DENSITY_DEFAULT     -   density default < PETMeasureBUD
    %
    %   THRESHOLD1          -   threshold numeric code < PETMeasureBUD
    %   THRESHOLD1_TAG      -   threshold tag < PETMeasureBUD
    %   THRESHOLD1_FORMAT   -   threshold format < PETMeasureBUD
    %   THRESHOLD1_DEFAULT  -   threshold default < PETMeasureBUD
    %
    %   dDENSITY            -   d density value < PETMeasureBUD
    %   DENSITY_LEVELS      -   density intervals < PETMeasureBUD
    %
    %   RANDOM_COMP_VALUES  -   random graph values numeric code
    %   RANDOM_COMP_TAG     -   random graph values tag
    %   RANDOM_COMP_FORMAT  -   random graph values format
    %   RANDOM_COMP_DEFAULT -   random graph values default
    %
    %   PVALUE1             -   one tailed p-value numeric code
    %   PVALUE1_TAG         -   one tailed p-value tag
    %   PVALUE1_FORMAT      -   one tailed p-value format
    %   PVALUE1_DEFAULT     -   one tailed p-value default
    %
    %   PVALUE2             -   two tailed p-value numeric code
    %   PVALUE2_TAG         -   two tailed p-value tag
    %   PVALUE2_FORMAT      -   two tailed p-value format
    %   PVALUE2_DEFAULT     -   two tailed p-value default
    %
    %   PERCENTILES         -   percentiles numeric code
    %   PERCENTILES_TAG     -   percentiles tag
    %   PERCENTILES_FORMAT  -   percentiles format
    %   PERCENTILES_DEFAULT -   percentiles default
    %
    % PETRandomComparisonBUD methods:
    %   PETRandomComparisonBUD  -   constructor
    %   setProp                 -   sets property value < ListElement
    %   getProp                 -   gets property value, format and tag < ListElement
    %   getPropValue            -   string of property value < ListElement
    %   getPropFormat           -   string of property format < ListElement
    %   getPropTag              -   string of property tag < ListElement
    %   diff                    -   difference between two measures
    %   CI                      -   confidence interval calculated for a comparison
    %   isMeasure               -   return true if measure
    %   isComparison            -   return true if comparison
    %   isRandom                -   return true if comparison with random graphs
    %
    % PETRandomComparisonBUD methods (Static):
    %   cleanXML    -   removes whitespace nodes from xmlread < ListElement
    %   propnumber  -   number of properties
    %   getTags     -   cell array of strings with the tags of the properties
    %   getFormats  -   cell array with the formats of the properties
    %   getDefaults -   cell array with the defaults of the properties
    %   getOptions  -   cell array with options (only for properties with options format)
    %
    % See also PETMeasureBUD, PETRandomComparisonBUT, PETRandomComparisonWU.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values random graphs
        RANDOM_COMP_VALUES = PETMeasureBUD.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = PETMeasureBUD.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = PETMeasureBUD.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = PETMeasureBUD.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = PETRandomComparisonBUD(varargin)
            % PETRANDOMCOMPARISONBUD() creates binary undirected with fixed density PET comparisons with random graphs.
            %
            % PETCOMPARISONBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       PETRandomComparisonBUD.CODE                 -   numeric
            %       PETRandomComparisonBUD.PARAM                -   numeric
            %       PETRandomComparisonBUD.NOTES                -   char
            %       PETRandomComparisonBUD.GROUP1               -   numeric
            %       PETRandomComparisonBUD.VALUES1              -   numeric
            %       PETRandomComparisonBUD.DENSITY              -   numeric
            %       PETRandomComparisonBUD.THRESHOLD1           -   numeric
            %       PETRandomComparisonBUD.RANDOM_COMP_VALUES   -   numeric
            %       PETRandomComparisonBUD.PVALUE1              -   numeric
            %       PETRandomComparisonBUD.PVALUE2              -   numeric
            %       PETRandomComparisonBUD.PERCENTILES          -   numeric
            %
            % See also PETRandomComparisonBUD.

            n = n@PETMeasureBUD(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also PETRandomComparisonBUD.
            
            d = n.getProp(PETRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(PETRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also PETRandomComparisonBUD.

            p = round(p);
            percentiles = n.getProp(PETRandomComparisonBUD.PERCENTILES);
            if p==50
                ci = percentiles(51,:);
            elseif p>=0 && p<50
                ci = [percentiles(p+1,:); percentiles(101-p,:)];
            else
                ci = NaN;
            end
        end
        function bool = isMeasure(n)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(N) returns false for comparison with random graphs.
            %
            % See also PETRandomComparisonBUD, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also PETRandomComparisonBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also PETRandomComparisonBUD, isMeasure, isComparison.
            
            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETRandomComparisonBUD.
            %
            % See also PETRandomComparisonBUD.

            N = PETMeasureBUD.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETRandomComparisonBUD.
            %
            % See also PETRandomComparisonBUD, ListElement.
            
            tags = [ PETMeasureBUD.getTags() ...
                PETRandomComparisonBUD.RANDOM_COMP_TAG ...
                PETRandomComparisonBUD.PVALUE1_TAG ...
                PETRandomComparisonBUD.PVALUE2_TAG ...
                PETRandomComparisonBUD.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETRandomComparisonBUD.
            %
            % See also PETRandomComparisonBUD, ListElement.
            
            formats = [PETMeasureBUD.getFormats() ...
                PETRandomComparisonBUD.RANDOM_COMP_FORMAT ...
                PETRandomComparisonBUD.PVALUE1_FORMAT ...
                PETRandomComparisonBUD.PVALUE2_FORMAT ...
                PETRandomComparisonBUD.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETRandomComparisonBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETRandomComparisonBUD, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PETRandomComparisonBUD.
            %
            % See also PETRandomComparisonBUD, ListElement.
            
            defaults = [PETMeasureBUD.getDefaults() ...
                PETRandomComparisonBUD.RANDOM_COMP_DEFAULT ...
                PETRandomComparisonBUD.PVALUE1_DEFAULT ...
                PETRandomComparisonBUD.PVALUE2_DEFAULT ...
                PETRandomComparisonBUD.PERCENTILES_DEFAULT];
        end
    end
    
end