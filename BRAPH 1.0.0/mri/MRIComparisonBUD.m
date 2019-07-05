classdef MRIComparisonBUD < MRIMeasureBUD
    % MRIComparisonBUD < MRIMeasureBUD : Fixed density binary undirected MRI comparison 
    %   MRIComparisonBUD represents MRI comparison of binary undirected graph with fixed density.
    %
    % MRIComparisonBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % MRIComparisonBUD properties (Constants):
    %   CODE                -   code numeric code < MRIMeasure 
    %   CODE_TAG            -   code tag < MRIMeasure 
    %   CODE_FORMAT         -   code format < MRIMeasure
    %   CODE_DEFAULT        -   code default < MRIMeasure
    %
    %   PARAM               -   parameters numeric code < MRIMeasure
    %   PARAM_TAG           -   parameters tag < MRIMeasure
    %   PARAM_FORMAT        -   parameters format < MRIMeasure
    %   PARAM_DEFAULT       -   parameters default < MRIMeasure
    %
    %   NOTES               -   notes numeric code < MRIMeasure
    %   NOTES_TAG           -   notes tag < MRIMeasure
    %   NOTES_FORMAT        -   notes format < MRIMeasure
    %   NOTES_DEFAULT       -   notes default < MRIMeasure
    %
    %   GROUP1              -   group1 numeric code < MRIMeasure
    %   GROUP1_TAG          -   group1 tag < MRIMeasure
    %   GROUP1_FORMAT       -   group1 format < MRIMeasure
    %   GROUP1_DEFAULT      -   group1 default < MRIMeasure
    %
    %   VALUES1             -   values1 numeric code < MRIMeasure
    %   VALUES1_TAG         -   values1 tag < MRIMeasure
    %   VALUES1_FORMAT      -   values1 format < MRIMeasure
    %   VALUES1_DEFAULT     -   values1 default < MRIMeasure
    %
    %   DENSITY             -   density numeric code < MRIMeasureBUD
    %   DENSITY_TAG         -   density tag < MRIMeasureBUD
    %   DENSITY_FORMAT      -   density format < MRIMeasureBUD
    %   DENSITY_DEFAULT     -   density default < MRIMeasureBUD
    %
    %   THRESHOLD1          -   threshold numeric code < MRIMeasureBUD
    %   THRESHOLD1_TAG      -   threshold tag < MRIMeasureBUD
    %   THRESHOLD1_FORMAT   -   threshold format < MRIMeasureBUD
    %   THRESHOLD1_DEFAULT  -   threshold default < MRIMeasureBUD
    %
    %   dDENSITY            -   d density value < MRIMeasureBUD
    %   DENSITY_LEVELS      -   density intervals < MRIMeasureBUD
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
    % MRIComparisonBUD methods:
    %   MRIComparisonBUD    -   constructor
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   diff                -   difference between two measures   
    %   CI                  -   confidence interval calculated for a comparison
    %   hash                -   hash values of the hash list element   
    %   isMeasure           -   return true if measure
    %   isComparison        -   return true if comparison 
    %   isRandom            -   return true if comparison with random graphs
    %
    % MRIComparisonBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIMeasureBUD, MRIComparisonBUT, MRIComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = MRIMeasureBUD.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        VALUES2 = MRIMeasureBUD.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % threshold 2
        THRESHOLD2 = MRIMeasureBUD.propnumber() + 3
        THRESHOLD2_TAG = 'threshold2'
        THRESHOLD2_FORMAT = BNC.NUMERIC
        THRESHOLD2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = MRIMeasureBUD.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = MRIMeasureBUD.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = MRIMeasureBUD.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN

    end
    methods
        function c = MRIComparisonBUD(varargin)
            % MRICOMPARISONBUD() creates binary undirected MRI comparisons with fixed density.
            %
            % MRICOMPARISONBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIComparisonBUD.CODE         -   numeric
            %     MRIComparisonBUD.PARAM        -   numeric
            %     MRIComparisonBUD.NOTES        -   char
            %     MRIComparisonBUD.GROUP1       -   numeric
            %     MRIComparisonBUD.VALUES1      -   numeric
            %     MRIComparisonBUD.DENSITY      -   numeric
            %     MRIComparisonBUD.THRESHOLD1   -   numeric
            %     MRIComparisonBUD.GROUP2       -   numeric
            %     MRIComparisonBUD.VALUES2      -   numeric
            %     MRIComparisonBUD.THRESHOLD2   -   numeric
            %     MRIComparisonBUD.PVALUE1      -   numeric
            %     MRIComparisonBUD.PVALUE2      -   numeric
            %     MRIComparisonBUD.PERCENTILES  -   numeric
            %
            % See also MRIComparisonBUD.
            
            c = c@MRIMeasureBUD(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also MRIComparisonBUD. 
            
            d = c.getProp(MRIComparisonBUD.VALUES2)-c.getProp(MRIComparisonBUD.VALUES1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also MRIComparisonBUD. 
            
            p = round(p);
            percentiles = c.getProp(MRIComparisonBUD.PERCENTILES);
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
            % See also MRIComparisonBUD. 
            
            code = c.getProp(MRIComparisonBUD.CODE);
            g1 = c.getProp(MRIComparisonBUD.GROUP1);
            g2 = c.getProp(MRIComparisonBUD.GROUP2);
            d = round(c.getProp(MRIComparisonBUD.DENSITY)/MRIComparisonBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also MRIComparisonBUD, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also MRIComparisonBUD, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIComparisonBUD, isMeasure, isComparison.
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIComparisonBUD.
            %
            % See also MRIComparisonBUD.

            N = MRIMeasureBUD.propnumber() + 5;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIComparisonBUD.
            %
            % See also MRIComparisonBUD, ListElement.
            
            tags = [ MRIMeasureBUD.getTags() ...
                MRIComparisonBUD.GROUP2_TAG ...
                MRIComparisonBUD.VALUES2_TAG ...
                MRIComparisonBUD.THRESHOLD2_TAG ...
                MRIComparisonBUD.PVALUE1_TAG ...
                MRIComparisonBUD.PVALUE2_TAG ...
                MRIComparisonBUD.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIComparisonBUD.
            %
            % See also MRIComparisonBUD, ListElement.
            
            formats = [MRIMeasureBUD.getFormats() ...
                MRIComparisonBUD.GROUP2_FORMAT ...
                MRIComparisonBUD.VALUES2_FORMAT ...
                MRIComparisonBUD.THRESHOLD2_FORMAT ...
                MRIComparisonBUD.PVALUE1_FORMAT ...
                MRIComparisonBUD.PVALUE2_FORMAT ...
                MRIComparisonBUD.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIComparisonBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIComparisonBUD, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of MRIComparisonBUD.
            %
            % See also MRIComparisonBUD, ListElement.
            
            defaults = [MRIMeasureBUD.getDefaults() ...
                MRIComparisonBUD.GROUP2_DEFAULT ...
                MRIComparisonBUD.VALUES2_DEFAULT ...
                MRIComparisonBUD.THRESHOLD2_DEFAULT ...
                MRIComparisonBUD.PVALUE1_DEFAULT ...
                MRIComparisonBUD.PVALUE2_DEFAULT ...
                MRIComparisonBUD.PERCENTILES_DEFAULT];
        end
    end
end