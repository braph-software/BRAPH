classdef EEGRandomComparisonBUD < EEGMeasureBUD
    % EEGRandomComparisonBUD < EEGMeasureBUD: Fixed density binary undirected EEG random comparison
    %   EEGRandomComparisonBUD represents EEG comparison of binary undirected graph with fixed density
    %   with random graphs.
    %
    % EEGRandomComparisonBUD properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % EEGRandomComparisonBUD properties (Constants):
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
    %   DENSITY                 -   density numeric code < EEGMeasureBUD
    %   DENSITY_TAG             -   density tag < EEGMeasureBUD
    %   DENSITY_FORMAT          -   density format < EEGMeasureBUD
    %   DENSITY_DEFAULT         -   density default < EEGMeasureBUD
    % 
    %   THRESHOLD1              -   threshold numeric code < EEGMeasureBUD
    %   THRESHOLD1_TAG          -   threshold tag < EEGMeasureBUD
    %   THRESHOLD1_FORMAT       -   threshold format < EEGMeasureBUD
    %   THRESHOLD1_DEFAULT      -   threshold default < EEGMeasureBUD
    % 
    %   dDENSITY                -   d density value < EEGMeasureBUD
    %   DENSITY_LEVELS          -   density intervals < EEGMeasureBUD
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
    % EEGRandomComparisonBUD methods:
    %   EEGRandomComparisonBUD -   constructor
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
    % EEGRandomComparisonBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasureBUD, EEGRandomComparisonBUT, EEGRandomComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values group 2
        RANDOM_COMP_VALUES = EEGMeasureBUD.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = EEGMeasureBUD.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = EEGMeasureBUD.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = EEGMeasureBUD.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = EEGRandomComparisonBUD(varargin)
            % EEGRANDOMCOMPARISONBUD() creates binary undirected with fixed density EEG comparisons with random graphs.
            %
            % EEGCOMPARISONBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       EEGRandomComparisonBUD.CODE                -   numeric
            %       EEGRandomComparisonBUD.PARAM               -   numeric
            %       EEGRandomComparisonBUD.NOTES               -   char
            %       EEGRandomComparisonBUD.GROUP1              -   numeric
            %       EEGRandomComparisonBUD.VALUES1             -   numeric
            %       EEGRandomComparisonBUD.DENSITY             -   numeric
            %       EEGRandomComparisonBUD.THRESHOLD1          -   numeric
            %       EEGRandomComparisonBUD.RANDOM_COMP_VALUES  -   numeric
            %       EEGRandomComparisonBUD.PVALUE1             -   numeric
            %       EEGRandomComparisonBUD.PVALUE2             -   numeric
            %       EEGRandomComparisonBUD.PERCENTILES         -   numeric
            %
            % See also EEGRandomComparisonBUD.

            n = n@EEGMeasureBUD(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also EEGRandomComparisonBUD.
            
            d = n.getProp(EEGRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(EEGRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also EEGRandomComparisonBUD.

            p = round(p);
            percentiles = n.getProp(EEGRandomComparisonBUD.PERCENTILES);
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
            % See also EEGRandomComparisonBUD, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also EEGRandomComparisonBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also EEGRandomComparisonBUD, isMeasure, isComparison.
            
            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD.

            N = EEGMeasureBUD.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            tags = [ EEGMeasureBUD.getTags() ...
                EEGRandomComparisonBUD.RANDOM_COMP_TAG ...
                EEGRandomComparisonBUD.PVALUE1_TAG ...
                EEGRandomComparisonBUD.PVALUE2_TAG ...
                EEGRandomComparisonBUD.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            formats = [EEGMeasureBUD.getFormats() ...
                EEGRandomComparisonBUD.RANDOM_COMP_FORMAT ...
                EEGRandomComparisonBUD.PVALUE1_FORMAT ...
                EEGRandomComparisonBUD.PVALUE2_FORMAT ...
                EEGRandomComparisonBUD.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            defaults = [EEGMeasureBUD.getDefaults() ...
                EEGRandomComparisonBUD.RANDOM_COMP_DEFAULT ...
                EEGRandomComparisonBUD.PVALUE1_DEFAULT ...
                EEGRandomComparisonBUD.PVALUE2_DEFAULT ...
                EEGRandomComparisonBUD.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGComparisonBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGComparisonBUD, ListElement.
            
            options = {};
        end
    end
end