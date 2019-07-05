classdef EEGComparisonBUD < EEGMeasureBUD
    % EEGComparisonBUD < EEGMeasureBUD : Fixed density binary undirected EEG comparison 
    %   EEGComparisonBUD represents EEG comparison of binary undirected graph with fixed density.
    %
    % EEGComparisonBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGComparisonBUD properties (Constants):
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
    %   DENSITY             -   density numeric code < EEGMeasureBUD
    %   DENSITY_TAG         -   density tag < EEGMeasureBUD
    %   DENSITY_FORMAT      -   density format < EEGMeasureBUD
    %   DENSITY_DEFAULT     -   density default < EEGMeasureBUD
    %
    %   THRESHOLD1          -   threshold numeric code < EEGMeasureBUD
    %   THRESHOLD1_TAG      -   threshold tag < EEGMeasureBUD
    %   THRESHOLD1_FORMAT   -   threshold format < EEGMeasureBUD
    %   THRESHOLD1_DEFAULT  -   threshold default < EEGMeasureBUD
    %
    %   dDENSITY            -   d density value < EEGMeasureBUD
    %   DENSITY_LEVELS      -   density intervals < EEGMeasureBUD
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
    %   THRESHOLD2          -   threshold2 numeric code
    %   THRESHOLD2_TAG      -   threshold2 tag
    %   THRESHOLD2_FORMAT   -   threshold2 format
    %   THRESHOLD2_DEFAULT  -   threshold2 default
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
    % EEGComparisonBUD methods:
    %   EEGComparisonBUD   -   constructor
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
    % EEGComparisonBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasureBUD, EEGComparisonBUT, EEGComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = EEGMeasureBUD.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        VALUES2 = EEGMeasureBUD.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % threshold 2
        THRESHOLD2 = EEGMeasureBUD.propnumber() + 3
        THRESHOLD2_TAG = 'threshold2'
        THRESHOLD2_FORMAT = BNC.NUMERIC
        THRESHOLD2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = EEGMeasureBUD.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = EEGMeasureBUD.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = EEGMeasureBUD.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN

    end
    methods
        function c = EEGComparisonBUD(varargin)
            % EEGCOMPARISONBUD() creates binary undirected EEG comparisons with fixed density.
            %
            % EEGCOMPARISONBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGComparisonBUD.CODE         -   numeric
            %     EEGComparisonBUD.PARAM        -   numeric
            %     EEGComparisonBUD.NOTES        -   char
            %     EEGComparisonBUD.GROUP1       -   numeric
            %     EEGComparisonBUD.VALUES1      -   numeric
            %     EEGComparisonBUD.DENSITY      -   numeric
            %     EEGComparisonBUD.THRESHOLD1   -   numeric
            %     EEGComparisonBUD.GROUP2       -   numeric
            %     EEGComparisonBUD.VALUES2      -   numeric
            %     EEGComparisonBUD.THRESHOLD2   -   numeric
            %     EEGComparisonBUD.PVALUE1      -   numeric
            %     EEGComparisonBUD.PVALUE2      -   numeric
            %     EEGComparisonBUD.PERCENTILES  -   numeric
            %
            % See also EEGComparisonBUD.
            
            c = c@EEGMeasureBUD(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also EEGComparisonBUD. 
            
            d = mean(c.getProp(EEGComparisonBUD.VALUES2),1)-mean(c.getProp(EEGComparisonBUD.VALUES1),1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also EEGComparisonBUD. 
            
            p = round(p);
            percentiles = c.getProp(EEGComparisonBUD.PERCENTILES);
            if p==50
                ci = percentiles(51,:);
            elseif p>=0 && p<50
                ci = [percentiles(p+1,:); percentiles(101-p,:)];
            else
                ci = NaN;
            end
        end
        function [code,g1,g2,d] = hash(c)
            % HASH hash values of the hash list element
            %
            % [CODE,G1,G2,D] = HASH(C) returns the code CODE, the groups G1 and G2 and the conversion 
            %   parameter D of the comparison given by C.
            %   D is calculated as a function of the density to density levels ratio.
            %
            % See also EEGComparisonBUD. 
            
            code = c.getProp(EEGComparisonBUD.CODE);
            g1 = c.getProp(EEGComparisonBUD.GROUP1);
            g2 = c.getProp(EEGComparisonBUD.GROUP2);
            d = round(c.getProp(EEGComparisonBUD.DENSITY)/EEGComparisonBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also EEGComparisonBUD, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also EEGComparisonBUD, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also EEGComparisonBUD, isMeasure, isComparison.            
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD.

            N = EEGMeasureBUD.propnumber() + 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            tags = [EEGMeasureBUD.getTags() ...
                EEGComparisonBUD.GROUP2_TAG ...
                EEGComparisonBUD.VALUES2_TAG ...
                EEGComparisonBUD.THRESHOLD2_TAG ...
                EEGComparisonBUD.PVALUE1_TAG ...
                EEGComparisonBUD.PVALUE2_TAG ...
                EEGComparisonBUD.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            formats = [EEGMeasureBUD.getFormats() ...
                EEGComparisonBUD.GROUP2_FORMAT ...
                EEGComparisonBUD.VALUES2_FORMAT ...
                EEGComparisonBUD.THRESHOLD2_FORMAT ...
                EEGComparisonBUD.PVALUE1_FORMAT ...
                EEGComparisonBUD.PVALUE2_FORMAT ...
                EEGComparisonBUD.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGComparisonBUD.
            %
            % See also EEGComparisonBUD, ListElement.
            
            defaults = [EEGMeasureBUD.getDefaults() ...
                EEGComparisonBUD.GROUP2_DEFAULT ...
                EEGComparisonBUD.VALUES2_DEFAULT ...
                EEGComparisonBUD.THRESHOLD2_DEFAULT ...
                EEGComparisonBUD.PVALUE1_DEFAULT ...
                EEGComparisonBUD.PVALUE2_DEFAULT ...
                EEGComparisonBUD.PERCENTILES_DEFAULT];
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