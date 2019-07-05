classdef EEGRandomComparisonWU < EEGMeasureWU
    % EEGRandomComparisonWU < EEGMeasureWU : Weighted undirected EEG random comparison
    %   EEGRandomComparisonWU represents EEG comparison of weighted undirected graph with random graphs.
    %
    % EEGRandomComparisonWU properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % EEGComparisonBUT properties (Constants):
    %   CODE                    -   code numeric code < EEGMeasure
    %   CODE_TAG                -   code tag < EEGMeasure
    %   CODE_FORMAT             -   code format < EEGMeasure
    %   CODE_DEFAULT            -   code default < EEGMeasure
    %
    %   PARAM                   -   parameters numeric code < EEGMeasure
    %   PARAM_TAG               -   parameters tag < EEGMeasure
    %   PARAM_FORMAT            -   parameters format < EEGMeasure
    %   PARAM_DEFAULT           -   parameters default < EEGMeasure
    %
    %   NOTES                   -   notes numeric code < EEGMeasure
    %   NOTES_TAG               -   notes tag < EEGMeasure
    %   NOTES_FORMAT            -   notes format < EEGMeasure
    %   NOTES_DEFAULT           -   notes default < EEGMeasure
    %
    %   GROUP1                  -   group1 numeric code < EEGMeasure
    %   GROUP1_TAG              -   group1 tag < EEGMeasure
    %   GROUP1_FORMAT           -   group1 format < EEGMeasure
    %   GROUP1_DEFAULT          -   group1 default < EEGMeasure
    %
    %   VALUES1                 -   values1 numeric code < EEGMeasure
    %   VALUES1_TAG             -   values1 tag < EEGMeasure
    %   VALUES1_FORMAT          -   values1 format < EEGMeasure
    %   VALUES1_DEFAULT         -   values1 default < EEGMeasure
    %
    %   RANDOM_COMP_VALUES      -   random graph values numeric code
    %   RANDOM_COMP_TAG         -   random graph values tag
    %   RANDOM_COMP_FORMAT      -   random graph values format
    %   RANDOM_COMP_DEFAULT     -   random graph values default
    %
    %   PVALUE1                 -   one tailed p-value numeric code
    %   PVALUE1_TAG             -   one tailed p-value tag
    %   PVALUE1_FORMAT          -   one tailed p-value format
    %   PVALUE1_DEFAULT         -   one tailed p-value default
    %
    %   PVALUE2                 -   two tailed p-value numeric code
    %   PVALUE2_TAG             -   two tailed p-value tag
    %   PVALUE2_FORMAT          -   two tailed p-value format
    %   PVALUE2_DEFAULT         -   two tailed p-value default
    %
    %   PERCENTILES             -   percentiles numeric code
    %   PERCENTILES_TAG         -   percentiles tag
    %   PERCENTILES_FORMAT      -   percentiles format
    %   PERCENTILES_DEFAULT     -   percentiles default
    %
    % EEGRandomComparisonWU methods:
    %   EEGRandomComparisonWU  -   constructor
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
    % EEGRandomComparisonWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasureWU, EEGRandomComparisonBUD, EEGRandomComparisonBUT.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values group 2
        RANDOM_COMP_VALUES = EEGMeasureWU.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = EEGMeasureWU.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = EEGMeasureWU.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = EEGMeasureWU.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = EEGRandomComparisonWU(varargin)
            % EEGRANDOMCOMPARISONWU() creates weighted undirected EEG comparisons with random graphs.
            %
            % EEGRANDOMCOMPARISONWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       EEGRandomComparisonWU.CODE                 -   numeric
            %       EEGRandomComparisonWU.PARAM                -   numeric
            %       EEGRandomComparisonWU.NOTES                -   char
            %       EEGRandomComparisonWU.GROUP1               -   numeric
            %       EEGRandomComparisonWU.VALUES1              -   numeric
            %       EEGRandomComparisonWU.RANDOM_COMP_VALUES   -   numeric
            %       EEGRandomComparisonWU.PVALUE1              -   numeric
            %       EEGRandomComparisonWU.PVALUE2              -   numeric
            %       EEGRandomComparisonWU.PERCENTILES          -   numeric
            %
            % See also EEGRandomComparisonWU.

            n = n@EEGMeasureWU(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also EEGRandomComparisonWU.

            d = n.getProp(EEGRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(EEGRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also EEGRandomComparisonWU.
            
            p = round(p);
            percentiles = n.getProp(EEGRandomComparisonWU.PERCENTILES);
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
            % See also EEGRandomComparisonWU, isComparison, isRandom.

            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also EEGRandomComparisonWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also EEGRandomComparisonWU, isMeasure, isComparison.

            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGComparisonBUD.
            %
            % See also EEGComparisonWU.

            N = EEGMeasureWU.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonWU, ListElement.
            
            tags = [ EEGMeasureWU.getTags() ...
                EEGRandomComparisonWU.RANDOM_COMP_TAG ...
                EEGRandomComparisonWU.PVALUE1_TAG ...
                EEGRandomComparisonWU.PVALUE2_TAG ...
                EEGRandomComparisonWU.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGComparisonWU.
            %
            % See also EEGComparisonWU, ListElement.
            
            formats = [EEGMeasureWU.getFormats() ...
                EEGRandomComparisonWU.RANDOM_COMP_FORMAT ...
                EEGRandomComparisonWU.PVALUE1_FORMAT ...
                EEGRandomComparisonWU.PVALUE2_FORMAT ...
                EEGRandomComparisonWU.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGComparisonWU.
            %
            % See also EEGComparisonWU, ListElement.
            
            defaults = [EEGMeasureWU.getDefaults() ...
                EEGRandomComparisonWU.RANDOM_COMP_DEFAULT ...
                EEGRandomComparisonWU.PVALUE1_DEFAULT ...
                EEGRandomComparisonWU.PVALUE2_DEFAULT ...
                EEGRandomComparisonWU.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGComparisonWU.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGComparisonWU, ListElement.
            
            options = {};
        end
    end
end