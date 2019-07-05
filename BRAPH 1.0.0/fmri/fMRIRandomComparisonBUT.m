classdef fMRIRandomComparisonBUT < fMRIMeasureBUT
    % fMRIRandomComparisonBUT < fMRIMeasureBUT : Fixed threshold binary undirected fMRI random comparison
    %   fMRIRandomComparisonBUT represents fMRI comparison of binary undirected graph with fixed threshold
    %   with random graphs.
    %
    % fMRIRandomComparisonBUT properties (Access = protected):
    %   props   -   cell array of object properties < ListElement
    %
    % fMRIRandomComparisonBUT properties (Constants):
    %   CODE                    -   code numeric code < fMRIMeasure
    %   CODE_TAG                -   code tag < fMRIMeasure
    %   CODE_FORMAT             -   code format < fMRIMeasure
    %   CODE_DEFAULT            -   code default < fMRIMeasure
    %
    %   PARAM                   -   parameters numeric code < fMRIMeasure
    %   PARAM_TAG               -   parameters tag < fMRIMeasure
    %   PARAM_FORMAT            -   parameters format < fMRIMeasure
    %   PARAM_DEFAULT           -   parameters default < fMRIMeasure
    %
    %   NOTES                   -   notes numeric code < fMRIMeasure
    %   NOTES_TAG               -   notes tag < fMRIMeasure
    %   NOTES_FORMAT            -   notes format < fMRIMeasure
    %   NOTES_DEFAULT           -   notes default < fMRIMeasure
    %
    %   GROUP1                  -   group1 numeric code < fMRIMeasure
    %   GROUP1_TAG              -   group1 tag < fMRIMeasure
    %   GROUP1_FORMAT           -   group1 format < fMRIMeasure
    %   GROUP1_DEFAULT          -   group1 default < fMRIMeasure
    %
    %   VALUES1                 -   values1 numeric code < fMRIMeasure
    %   VALUES1_TAG             -   values1 tag < fMRIMeasure
    %   VALUES1_FORMAT          -   values1 format < fMRIMeasure
    %   VALUES1_DEFAULT         -   values1 default < fMRIMeasure
    %
    %   THRESHOLD               -   threshold numeric code < fMRIMeasureBUT
    %   THRESHOLD_TAG           -   threshold tag < fMRIMeasureBUT
    %   THRESHOLD_FORMAT        -   threshold format < fMRIMeasureBUT
    %   THRESHOLD_DEFAULT       -   threshold default < fMRIMeasureBUT
    %
    %   DENSITY1                -   density 1 numeric code < fMRIMeasureBUT
    %   DENSITY1_TAG            -   density 1 tag < fMRIMeasureBUT
    %   DENSITY1_FORMAT         -   density 1 format < fMRIMeasureBUT
    %   DENSITY1_DEFAULT        -   density 1 default < fMRIMeasureBUT
    %
    %   dTHRESHOLD              -   d threshold value < fMRIMeasureBUT
    %   THRESHOLD_LEVELS        -   level of threshold < fMRIMeasureBUT
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
    % fMRIRandomComparisonBUT methods:
    %   fMRIRandomComparisonBUT -   constructor
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
    % fMRIRandomComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasureBUT, fMRIRandomComparisonBUD, fMRIRandomComparisonWU.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % measure values group 2
        RANDOM_COMP_VALUES = fMRIMeasureBUT.propnumber() + 1
        RANDOM_COMP_TAG = 'random graph values'
        RANDOM_COMP_FORMAT = BNC.NUMERIC
        RANDOM_COMP_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = fMRIMeasureBUT.propnumber() + 2
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = fMRIMeasureBUT.propnumber() + 3
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN
        
        % percentiles
        PERCENTILES = fMRIMeasureBUT.propnumber() + 4
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function n = fMRIRandomComparisonBUT(varargin)
            % FMRIRANDOMCOMPARISONBUT() creates binary undirected with fixed threshold fMRI comparisons with random graphs.
            %
            % FMRIRANDOMCOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1,
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %       FMRIRandomComparisonBUT.CODE                -   numeric
            %       FMRIRandomComparisonBUT.PARAM               -   numeric
            %       FMRIRandomComparisonBUT.NOTES               -   char
            %       FMRIRandomComparisonBUT.GROUP1              -   numeric
            %       FMRIRandomComparisonBUT.VALUES1             -   numeric
            %       FMRIRandomComparisonBUT.DENSITY1            -   numeric
            %       FMRIRandomComparisonBUT.THRESHOLD           -   numeric
            %       FMRIRandomComparisonBUD.RANDOM_COMP_VALUES  -   numeric
            %       FMRIRandomComparisonBUT.PVALUE1             -   numeric
            %       FMRIRandomComparisonBUT.PVALUE2             -   numeric
            %       FMRIRandomComparisonBUT.PERCENTILES         -   numeric
            %
            % See also fMRIRandomComparisonBUT.

            n = n@fMRIMeasureBUT(varargin{:});
        end
        function d = diff(n)
            % DIFF difference between two measures
            %
            % D = DIFF(N) returns the difference D between the two measures that are constituents
            %   of the comparison with random graphs N.
            %
            % See also fMRIRandomComparisonBUT.
            
            d = n.getProp(fMRIRandomComparisonBUD.RANDOM_COMP_VALUES)-n.getProp(fMRIRandomComparisonBUD.VALUES1);
        end
        function ci = CI(n,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(N,P) returns the confidence interval CI of the comparison
            %   with random graphs N given the P-quantiles of the percentiles of N.
            %
            % See also fMRIRandomComparisonBUT.
            
            p = round(p);
            percentiles = n.getProp(fMRIRandomComparisonBUT.PERCENTILES);
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
            % See also fMRIRandomComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(n)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(N) returns false for comparison with random graphs.
            %
            % See also fMRIRandomComparisonBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(n)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(N) returns true for comparison with random graphs.
            %
            % See also fMRIRandomComparisonBUT, isMeasure, isComparison.
            
            bool = true;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT.

            N = fMRIMeasureBUT.propnumber() + 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            tags = [ fMRIMeasureBUT.getTags() ...
                fMRIRandomComparisonBUT.RANDOM_COMP_TAG ...
                fMRIRandomComparisonBUT.PVALUE1_TAG ...
                fMRIRandomComparisonBUT.PVALUE2_TAG ...
                fMRIRandomComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            formats = [fMRIMeasureBUT.getFormats() ...
                fMRIRandomComparisonBUT.RANDOM_COMP_FORMAT ...
                fMRIRandomComparisonBUT.PVALUE1_FORMAT ...
                fMRIRandomComparisonBUT.PVALUE2_FORMAT ...
                fMRIRandomComparisonBUT.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            defaults = [fMRIMeasureBUT.getDefaults() ...
                fMRIRandomComparisonBUT.RANDOM_COMP_DEFAULT ...
                fMRIRandomComparisonBUT.PVALUE1_DEFAULT ...
                fMRIRandomComparisonBUT.PVALUE2_DEFAULT ...
                fMRIRandomComparisonBUT.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIComparisonBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIComparisonBUT, ListElement.
            
            options = {};
        end
    end    
end