classdef PETComparisonBUT < PETMeasureBUT
    % PETComparisonBUT < PETMeasureBUT : Fixed threshold binary undirected PET comparison 
    %   PETComparisonBUT represents PET comparison of binary undirected graph with fixed threshold.
    %
    % PETComparisonBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETComparisonBUT properties (Constants):
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
    %   THRESHOLD           -   threshold numeric code < PETMeasureBUT
    %   THRESHOLD_TAG       -   threshold tag < PETMeasureBUT
    %   THRESHOLD_FORMAT    -   threshold format < PETMeasureBUT
    %   THRESHOLD_DEFAULT   -   threshold default < PETMeasureBUT
    %
    %   DENSITY1            -   density 1 numeric code < PETMeasureBUT
    %   DENSITY1_TAG        -   density 1 tag < PETMeasureBUT
    %   DENSITY1_FORMAT     -   density 1 format < PETMeasureBUT
    %   DENSITY1_DEFAULT    -   density 1 default < PETMeasureBUT
    %
    %   dTHRESHOLD          -   d threshold value < PETMeasureBUT
    %   THRESHOLD_LEVELS    -   level of threshold < PETMeasureBUT
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
    % PETComparisonBUT methods:
    %   PETComparisonBUT    -   constructor
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
    % PETComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also PETMeasureBUT, PETComparisonBUD, PETComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = PETMeasureBUT.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2
        
        % measure values group 2
        VALUES2 = PETMeasureBUT.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % density 2
        DENSITY2 = PETMeasureBUT.propnumber() + 3
        DENSITY2_TAG = 'density2'
        DENSITY2_FORMAT = BNC.NUMERIC
        DENSITY2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = PETMeasureBUT.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = PETMeasureBUT.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = PETMeasureBUT.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function c = PETComparisonBUT(varargin)
            % PETCOMPARISONBUT() creates binary undirected PET comparisons with fixed threshold.
            %
            % PETCOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETComparisonBUT.CODE         -   numeric
            %     PETComparisonBUT.PARAM        -   numeric
            %     PETComparisonBUT.NOTES        -   char
            %     PETComparisonBUT.GROUP1       -   numeric
            %     PETComparisonBUT.VALUES1      -   numeric
            %     PETComparisonBUT.DENSITY1     -   numeric
            %     PETComparisonBUT.THRESHOLD    -   numeric
            %     PETComparisonBUT.GROUP2       -   numeric
            %     PETComparisonBUT.VALUES2      -   numeric
            %     PETComparisonBUT.DENSITY2     -   numeric
            %     PETComparisonBUT.PVALUE1      -   numeric
            %     PETComparisonBUT.PVALUE2      -   numeric
            %     PETComparisonBUT.PERCENTILES  -   numeric
            %
            % See also PETComparisonBUT.
            
            c = c@PETMeasureBUT(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also PETComparisonBUT. 
            
            d = c.getProp(PETComparisonBUT.VALUES2)-c.getProp(PETComparisonBUT.VALUES1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also PETComparisonBUT. 
            
            p = round(p);
            percentiles = c.getProp(PETComparisonBUT.PERCENTILES);
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
            % See also PETComparisonBUT. 
            
            code = c.getProp(PETComparisonBUT.CODE);
            g1 = c.getProp(PETComparisonBUT.GROUP1);
            g2 = c.getProp(PETComparisonBUT.GROUP2);
            t = round((c.getProp(PETComparisonBUT.THRESHOLD)+1)/PETComparisonBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also PETComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also PETComparisonBUT, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also PETComparisonBUT, isMeasure, isComparison.
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETComparisonBUT.
            %
            % See also PETComparisonBUT.

            N = PETMeasureBUT.propnumber() + 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETComparisonBUT.
            %
            % See also PETComparisonBUT, ListElement.
            
            tags = [ PETMeasureBUT.getTags() ...
                PETComparisonBUT.GROUP2_TAG ...
                PETComparisonBUT.VALUES2_TAG ...
                PETComparisonBUT.DENSITY2_TAG ...
                PETComparisonBUT.PVALUE1_TAG ...
                PETComparisonBUT.PVALUE2_TAG ...
                PETComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETComparisonBUT.
            %
            % See also PETComparisonBUT, ListElement.
            
            formats = [PETMeasureBUT.getFormats() ...
                PETComparisonBUT.GROUP2_FORMAT ...
                PETComparisonBUT.VALUES2_FORMAT ...
                PETComparisonBUT.DENSITY2_FORMAT ...
                PETComparisonBUT.PVALUE1_FORMAT ...
                PETComparisonBUT.PVALUE2_FORMAT ...
                PETComparisonBUT.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETComparisonBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETComparisonBUT, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PETComparisonBUT.
            %
            % See also PETComparisonBUT, ListElement.
            
            defaults = [PETMeasureBUT.getDefaults() ...
                PETComparisonBUT.GROUP2_DEFAULT ...
                PETComparisonBUT.VALUES2_DEFAULT ...
                PETComparisonBUT.DENSITY2_DEFAULT ...
                PETComparisonBUT.PVALUE1_DEFAULT ...
                PETComparisonBUT.PVALUE2_DEFAULT ...
                PETComparisonBUT.PERCENTILES_DEFAULT];
        end
    end
end