classdef EEGComparisonBUT < EEGMeasureBUT
    % EEGComparisonBUT < EEGMeasureBUT : Fixed threshold binary undirected EEG comparison 
    %   EEGComparisonBUT represents EEG comparison of binary undirected graph with fixed threshold.
    %
    % EEGComparisonBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGComparisonBUT properties (Constants):
    %   CODE                -   code numeric code < EEGMeasure 
    %   CODE_TAG            -   code tag < EEGMeasure 
    %   CODE_FORMAT         -   code format < EEGMeasure
    %   CODE_DEFAULT        -   code default < EEGMeasure
    %
    %   PARAM               -   parameters numeric code < EEGMeasure
    %   PARAM_TAG           -   parameters tag < EEGMeasure
    %   PARAM_FORMAT        -   parameters format < EEGMeasure
    %   PARAM_DEFAULT       -   parameters default < EEGMeasure
    %
    %   NOTES               -   notes numeric code < EEGMeasure
    %   NOTES_TAG           -   notes tag < EEGMeasure
    %   NOTES_FORMAT        -   notes format < EEGMeasure
    %   NOTES_DEFAULT       -   notes default < EEGMeasure
    %
    %   GROUP1              -   group1 numeric code < EEGMeasure
    %   GROUP1_TAG          -   group1 tag < EEGMeasure
    %   GROUP1_FORMAT       -   group1 format < EEGMeasure
    %   GROUP1_DEFAULT      -   group1 default < EEGMeasure
    %
    %   VALUES1             -   values1 numeric code < EEGMeasure
    %   VALUES1_TAG         -   values1 tag < EEGMeasure
    %   VALUES1_FORMAT      -   values1 format < EEGMeasure
    %   VALUES1_DEFAULT     -   values1 default < EEGMeasure
    %
    %   THRESHOLD           -   threshold numeric code < EEGMeasureBUT
    %   THRESHOLD_TAG       -   threshold tag < EEGMeasureBUT
    %   THRESHOLD_FORMAT    -   threshold format < EEGMeasureBUT
    %   THRESHOLD_DEFAULT   -   threshold default < EEGMeasureBUT
    %
    %   DENSITY1            -   density 1 numeric code < EEGMeasureBUT
    %   DENSITY1_TAG        -   density 1 tag < EEGMeasureBUT
    %   DENSITY1_FORMAT     -   density 1 format < EEGMeasureBUT
    %   DENSITY1_DEFAULT    -   density 1 default < EEGMeasureBUT
    %
    %   dTHRESHOLD          -   d threshold value < EEGMeasureBUT
    %   THRESHOLD_LEVELS    -   level of threshold < EEGMeasureBUT
    %
    %   GROUP2              -   group2 numeric code
    %   GROUP2_TAG          -   group2 tag
    %   GROUP2_FORMAT       -   group2 format
    %   GROUP2_DEFAULT      -   group2 default
    %
    %   VALUES2             -   values2 numeric code
    %   VALUES2_TAG         -   values2 tag
    %   VALUES2_FORMAT      -   values2 format
    %   VALUES2_DEFAULT     -   values2 default
    %    
    %   DENSITY2            -   density2 numeric code
    %   DENSITY2_TAG        -   density2 tag
    %   DENSITY2_FORMAT     -   density2 format
    %   DENSITY2_DEFAULT    -   density2 default
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
    % EEGComparisonBUT methods:
    %   EEGComparisonBUT   -   constructor
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   mean                -   mean of measure < EEGMeasure
    %   std                 -   standard deviation of measure < EEGMeasure 
    %   var                 -   variance of measure < EEGMeasure
    %   diff                -   difference between two measures   
    %   CI                  -   confidence interval calculated for a comparison
    %   hash                -   hash values of the hash list element   
    %   isMeasure           -   return true if measure
    %   isComparison        -   return true if comparison 
    %   isRandom            -   return true if comparison with random graphs
    %
    % EEGComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasureBUT, EEGComparisonBUD, EEGComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = EEGMeasureBUT.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        VALUES2 = EEGMeasureBUT.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % density 2
        DENSITY2 = EEGMeasureBUT.propnumber() + 3
        DENSITY2_TAG = 'density2'
        DENSITY2_FORMAT = BNC.NUMERIC
        DENSITY2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = EEGMeasureBUT.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = EEGMeasureBUT.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = EEGMeasureBUT.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function c = EEGComparisonBUT(varargin)
            % EEGCOMPARISONBUT() creates binary undirected EEG comparisons with fixed threshold.
            %
            % EEGCOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGComparisonBUT.CODE         -   numeric
            %     EEGComparisonBUT.PARAM        -   numeric
            %     EEGComparisonBUT.NOTES        -   char
            %     EEGComparisonBUT.GROUP1       -   numeric
            %     EEGComparisonBUT.VALUES1      -   numeric
            %     EEGComparisonBUT.DENSITY1     -   numeric
            %     EEGComparisonBUT.THRESHOLD    -   numeric
            %     EEGComparisonBUT.GROUP2       -   numeric
            %     EEGComparisonBUT.VALUES2      -   numeric
            %     EEGComparisonBUT.DENSITY2     -   numeric
            %     EEGComparisonBUT.PVALUE1      -   numeric
            %     EEGComparisonBUT.PVALUE2      -   numeric
            %     EEGComparisonBUT.PERCENTILES  -   numeric
            %
            % See also EEGComparisonBUT.
            
            c = c@EEGMeasureBUT(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also EEGComparisonBUT. 
            
            d = mean(c.getProp(EEGComparisonBUT.VALUES2),1)-mean(c.getProp(EEGComparisonBUT.VALUES1),1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also EEGComparisonBUT. 
            
            p = round(p);
            percentiles = c.getProp(EEGComparisonBUT.PERCENTILES);
            if p==50
                ci = percentiles(51,:);
            elseif p>=0 && p<50
                ci = [percentiles(p+1,:); percentiles(101-p,:)];
            else
                ci = NaN;
            end
        end
        function [code,g1,g2,t] = hash(c)
            % HASH hash values of the hash list element
            %
            % [CODE,G1,G2,T] = HASH(C) returns the code CODE, the groups G1 and G2 and the conversion 
            %   parameter T of the comparison given by C.
            %   T is calculated as a function of the threshold to threshold levels ratio.
            %
            % See also EEGComparisonBUT. 
            
            code = c.getProp(EEGComparisonBUT.CODE);
            g1 = c.getProp(EEGComparisonBUT.GROUP1);
            g2 = c.getProp(EEGComparisonBUT.GROUP2);
            t = round((c.getProp(EEGComparisonBUT.THRESHOLD)+1)/EEGComparisonBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also EEGComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also EEGComparisonBUT, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also EEGComparisonBUT, isMeasure, isComparison.            
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT.

            N = EEGMeasureBUT.propnumber() + 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            tags = [ EEGMeasureBUT.getTags() ...
                EEGComparisonBUT.GROUP2_TAG ...
                EEGComparisonBUT.VALUES2_TAG ...
                EEGComparisonBUT.DENSITY2_TAG ...
                EEGComparisonBUT.PVALUE1_TAG ...
                EEGComparisonBUT.PVALUE2_TAG ...
                EEGComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            formats = [EEGMeasureBUT.getFormats() ...
                EEGComparisonBUT.GROUP2_FORMAT ...
                EEGComparisonBUT.VALUES2_FORMAT ...
                EEGComparisonBUT.DENSITY2_FORMAT ...
                EEGComparisonBUT.PVALUE1_FORMAT ...
                EEGComparisonBUT.PVALUE2_FORMAT ...
                EEGComparisonBUT.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGComparisonBUT.
            %
            % See also EEGComparisonBUT, ListElement.
            
            defaults = [EEGMeasureBUT.getDefaults() ...
                EEGComparisonBUT.GROUP2_DEFAULT ...
                EEGComparisonBUT.VALUES2_DEFAULT ...
                EEGComparisonBUT.DENSITY2_DEFAULT ...
                EEGComparisonBUT.PVALUE1_DEFAULT ...
                EEGComparisonBUT.PVALUE2_DEFAULT ...
                EEGComparisonBUT.PERCENTILES_DEFAULT];
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