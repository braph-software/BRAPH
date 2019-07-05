classdef EEGRandomComparisonBUT < EEGMeasureBUT
    % EEGRandomComparisonBUT < EEGMeasureBUT : Fixed threshold binary undirected EEG random comparison
    %   EEGRandomComparisonBUT represents EEG comparison of binary undirected graph with fixed threshold
    %   with random graphs.
    %
    % EEGRandomComparisonBUT properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % EEGRandomComparisonBUT properties (Constants):
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
    %   THRESHOLD               -   threshold numeric code < EEGMeasureBUT
    %   THRESHOLD_TAG           -   threshold tag < EEGMeasureBUT
    %   THRESHOLD_FORMAT        -   threshold format < EEGMeasureBUT
    %   THRESHOLD_DEFAULT       -   threshold default < EEGMeasureBUT
    %
    %   DENSITY1                -   density 1 numeric code < EEGMeasureBUT
    %   DENSITY1_TAG            -   density 1 tag < EEGMeasureBUT
    %   DENSITY1_FORMAT         -   density 1 format < EEGMeasureBUT
    %   DENSITY1_DEFAULT        -   density 1 default < EEGMeasureBUT
    %
    %   dTHRESHOLD              -   d threshold value < EEGMeasureBUT
    %   THRESHOLD_LEVELS        -   level of threshold < EEGMeasureBUT
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
    % EEGRandomComparisonBUT methods:
    %   EEGRandomComparisonBUT -   constructor
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
    % EEGRandomComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasureBUT, EEGRandomComparisonBUD, EEGRandomComparisonWU.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values group 2
        RANDOM_COMP_VALUES = EEGMeasureBUT.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = EEGMeasureBUT.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = EEGMeasureBUT.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = EEGMeasureBUT.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = EEGRandomComparisonBUT(varargin)
            % EEGRANDOMCOMPARISONBUT() creates binary undirected with fixed threshold EEG comparisons with random graphs.
            %
            % EEGRANDOMCOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       EEGRandomComparisonBUT.CODE                -   numeric
            %       EEGRandomComparisonBUT.PARAM               -   numeric
            %       EEGRandomComparisonBUT.NOTES               -   char
            %       EEGRandomComparisonBUT.GROUP1              -   numeric
            %       EEGRandomComparisonBUT.VALUES1             -   numeric
            %       EEGRandomComparisonBUT.DENSITY1            -   numeric
            %       EEGRandomComparisonBUT.THRESHOLD           -   numeric
            %       EEGRandomComparisonBUD.RANDOM_COMP_VALUES  -   numeric
            %       EEGRandomComparisonBUT.PVALUE1             -   numeric
            %       EEGRandomComparisonBUT.PVALUE2             -   numeric
            %       EEGRandomComparisonBUT.PERCENTILES         -   numeric
            %
            % See also EEGRandomComparisonBUT.

            n = n@EEGMeasureBUT(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also EEGRandomComparisonBUT.
            
            d = n.getProp(EEGRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(EEGRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also EEGRandomComparisonBUT.
            
            p = round(p);
            percentiles = n.getProp(EEGRandomComparisonBUT.PERCENTILES);
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
            % See also EEGRandomComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also EEGRandomComparisonBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also EEGRandomComparisonBUT, isMeasure, isComparison.
            
            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT.

            N = EEGMeasureBUT.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            tags = [ EEGMeasureBUT.getTags() ...
                EEGRandomComparisonBUT.RANDOM_COMP_TAG ...
                EEGRandomComparisonBUT.PVALUE1_TAG ...
                EEGRandomComparisonBUT.PVALUE2_TAG ...
                EEGRandomComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            formats = [EEGMeasureBUT.getFormats() ...
                EEGRandomComparisonBUT.RANDOM_COMP_FORMAT ...
                EEGRandomComparisonBUT.PVALUE1_FORMAT ...
                EEGRandomComparisonBUT.PVALUE2_FORMAT ...
                EEGRandomComparisonBUT.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            defaults = [EEGMeasureBUT.getDefaults() ...
                EEGRandomComparisonBUT.RANDOM_COMP_DEFAULT ...
                EEGRandomComparisonBUT.PVALUE1_DEFAULT ...
                EEGRandomComparisonBUT.PVALUE2_DEFAULT ...
                EEGRandomComparisonBUT.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGComparisonBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGComparisonBUT, ListElement.
            
            options = {};
        end
    end    
end