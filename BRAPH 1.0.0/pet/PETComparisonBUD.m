classdef PETComparisonBUD < PETMeasureBUD
    % PETComparisonBUD < PETMeasureBUD : Fixed density binary undirected PET comparison 
    %   PETComparisonBUD represents PET comparison of binary undirected graph with fixed density.
    %
    % PETComparisonBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETComparisonBUD properties (Constants):
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
    %   DENSITY_TAG         -   density tag < PETMeasureBUD
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
    % PETComparisonBUD methods:
    %   PETComparisonBUD    -   constructor
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
    % PETComparisonBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also PETMeasureBUD, PETComparisonBUT, PETComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = PETMeasureBUD.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        VALUES2 = PETMeasureBUD.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % threshold 2
        THRESHOLD2 = PETMeasureBUD.propnumber() + 3
        THRESHOLD2_TAG = 'threshold2'
        THRESHOLD2_FORMAT = BNC.NUMERIC
        THRESHOLD2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = PETMeasureBUD.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = PETMeasureBUD.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = PETMeasureBUD.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN

    end
    methods
        function c = PETComparisonBUD(varargin)
            % PETCOMPARISONBUD() creates binary undirected PET comparisons with fixed density.
            %
            % PETCOMPARISONBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETComparisonBUD.CODE         -   numeric
            %     PETComparisonBUD.PARAM        -   numeric
            %     PETComparisonBUD.NOTES        -   char
            %     PETComparisonBUD.GROUP1       -   numeric
            %     PETComparisonBUD.VALUES1      -   numeric
            %     PETComparisonBUD.DENSITY      -   numeric
            %     PETComparisonBUD.THRESHOLD1   -   numeric
            %     PETComparisonBUD.GROUP2       -   numeric
            %     PETComparisonBUD.VALUES2      -   numeric
            %     PETComparisonBUD.THRESHOLD2   -   numeric
            %     PETComparisonBUD.PVALUE1      -   numeric
            %     PETComparisonBUD.PVALUE2      -   numeric
            %     PETComparisonBUD.PERCENTILES  -   numeric
            %
            % See also PETComparisonBUD.
            
            c = c@PETMeasureBUD(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also PETComparisonBUD. 
            
            d = c.getProp(PETComparisonBUD.VALUES2)-c.getProp(PETComparisonBUD.VALUES1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also PETComparisonBUD. 
            
            p = round(p);
            percentiles = c.getProp(PETComparisonBUD.PERCENTILES);
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
            % See also PETComparisonBUD. 
            
            code = c.getProp(PETComparisonBUD.CODE);
            g1 = c.getProp(PETComparisonBUD.GROUP1);
            g2 = c.getProp(PETComparisonBUD.GROUP2);
            d = round(c.getProp(PETComparisonBUD.DENSITY)/PETComparisonBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also PETComparisonBUD, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also PETComparisonBUD, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also PETComparisonBUD, isMeasure, isComparison.
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETComparisonBUD.
            %
            % See also PETComparisonBUD.

            N = PETMeasureBUD.propnumber() + 5;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETComparisonBUD.
            %
            % See also PETComparisonBUD, ListElement.
            
            tags = [ PETMeasureBUD.getTags() ...
                PETComparisonBUD.GROUP2_TAG ...
                PETComparisonBUD.VALUES2_TAG ...
                PETComparisonBUD.THRESHOLD2_TAG ...
                PETComparisonBUD.PVALUE1_TAG ...
                PETComparisonBUD.PVALUE2_TAG ...
                PETComparisonBUD.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETComparisonBUD.
            %
            % See also PETComparisonBUD, ListElement.
            
            formats = [PETMeasureBUD.getFormats() ...
                PETComparisonBUD.GROUP2_FORMAT ...
                PETComparisonBUD.VALUES2_FORMAT ...
                PETComparisonBUD.THRESHOLD2_FORMAT ...
                PETComparisonBUD.PVALUE1_FORMAT ...
                PETComparisonBUD.PVALUE2_FORMAT ...
                PETComparisonBUD.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETComparisonBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETComparisonBUD, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PETComparisonBUD.
            %
            % See also PETComparisonBUD, ListElement.
            
            defaults = [PETMeasureBUD.getDefaults() ...
                PETComparisonBUD.GROUP2_DEFAULT ...
                PETComparisonBUD.VALUES2_DEFAULT ...
                PETComparisonBUD.THRESHOLD2_DEFAULT ...
                PETComparisonBUD.PVALUE1_DEFAULT ...
                PETComparisonBUD.PVALUE2_DEFAULT ...
                PETComparisonBUD.PERCENTILES_DEFAULT];
        end
    end
end