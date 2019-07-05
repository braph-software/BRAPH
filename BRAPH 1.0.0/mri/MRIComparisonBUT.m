classdef MRIComparisonBUT < MRIMeasureBUT
    % MRIComparisonBUT < MRIMeasureBUT : Fixed threshold binary undirected MRI comparison 
    %   MRIComparisonBUT represents MRI comparison of binary undirected graph with fixed threshold.
    %
    % MRIComparisonBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % MRIComparisonBUT properties (Constants):
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
    %   THRESHOLD           -   threshold numeric code < MRIMeasureBUT
    %   THRESHOLD_TAG       -   threshold tag < MRIMeasureBUT
    %   THRESHOLD_FORMAT    -   threshold format < MRIMeasureBUT
    %   THRESHOLD_DEFAULT   -   threshold default < MRIMeasureBUT
    %
    %   DENSITY1            -   density 1 numeric code < MRIMeasureBUT
    %   DENSITY1_TAG        -   density 1 tag < MRIMeasureBUT
    %   DENSITY1_FORMAT     -   density 1 format < MRIMeasureBUT
    %   DENSITY1_DEFAULT    -   density 1 default < MRIMeasureBUT
    %
    %   dTHRESHOLD          -   d threshold value < MRIMeasureBUT
    %   THRESHOLD_LEVELS    -   level of threshold < MRIMeasureBUT
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
    % MRIComparisonBUT methods:
    %   MRIComparisonBUT    -   constructor
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
    % MRIComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIMeasureBUT, MRIComparisonBUD, MRIComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = MRIMeasureBUT.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2
        
        % measure values group 2
        VALUES2 = MRIMeasureBUT.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % density 2
        DENSITY2 = MRIMeasureBUT.propnumber() + 3
        DENSITY2_TAG = 'density2'
        DENSITY2_FORMAT = BNC.NUMERIC
        DENSITY2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = MRIMeasureBUT.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = MRIMeasureBUT.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = MRIMeasureBUT.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function c = MRIComparisonBUT(varargin)
            % MRICOMPARISONBUT() creates binary undirected MRI comparisons with fixed threshold.
            %
            % MRICOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIComparisonBUT.CODE         -   numeric
            %     MRIComparisonBUT.PARAM        -   numeric
            %     MRIComparisonBUT.NOTES        -   char
            %     MRIComparisonBUT.GROUP1       -   numeric
            %     MRIComparisonBUT.VALUES1      -   numeric
            %     MRIComparisonBUT.DENSITY1     -   numeric
            %     MRIComparisonBUT.THRESHOLD    -   numeric
            %     MRIComparisonBUT.GROUP2       -   numeric
            %     MRIComparisonBUT.VALUES2      -   numeric
            %     MRIComparisonBUT.DENSITY2     -   numeric
            %     MRIComparisonBUT.PVALUE1      -   numeric
            %     MRIComparisonBUT.PVALUE2      -   numeric
            %     MRIComparisonBUT.PERCENTILES  -   numeric
            %
            % See also MRIComparisonBUT.
            
            c = c@MRIMeasureBUT(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also MRIComparisonBUT. 
            
            d = c.getProp(MRIComparisonBUT.VALUES2)-c.getProp(MRIComparisonBUT.VALUES1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also MRIComparisonBUT. 
            
            p = round(p);
            percentiles = c.getProp(MRIComparisonBUT.PERCENTILES);
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
            % See also MRIComparisonBUT. 
            
            code = c.getProp(MRIComparisonBUT.CODE);
            g1 = c.getProp(MRIComparisonBUT.GROUP1);
            g2 = c.getProp(MRIComparisonBUT.GROUP2);
            t = round((c.getProp(MRIComparisonBUT.THRESHOLD)+1)/MRIComparisonBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also MRIComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also MRIComparisonBUT, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIComparisonBUT, isMeasure, isComparison.
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIComparisonBUT.
            %
            % See also MRIComparisonBUT.

            N = MRIMeasureBUT.propnumber() + 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIComparisonBUT.
            %
            % See also MRIComparisonBUT, ListElement.
            
            tags = [ MRIMeasureBUT.getTags() ...
                MRIComparisonBUT.GROUP2_TAG ...
                MRIComparisonBUT.VALUES2_TAG ...
                MRIComparisonBUT.DENSITY2_TAG ...
                MRIComparisonBUT.PVALUE1_TAG ...
                MRIComparisonBUT.PVALUE2_TAG ...
                MRIComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIComparisonBUT.
            %
            % See also MRIComparisonBUT, ListElement.
            
            formats = [MRIMeasureBUT.getFormats() ...
                MRIComparisonBUT.GROUP2_FORMAT ...
                MRIComparisonBUT.VALUES2_FORMAT ...
                MRIComparisonBUT.DENSITY2_FORMAT ...
                MRIComparisonBUT.PVALUE1_FORMAT ...
                MRIComparisonBUT.PVALUE2_FORMAT ...
                MRIComparisonBUT.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIComparisonBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIComparisonBUT, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of MRIComparisonBUT.
            %
            % See also MRIComparisonBUT, ListElement.
            
            defaults = [MRIMeasureBUT.getDefaults() ...
                MRIComparisonBUT.GROUP2_DEFAULT ...
                MRIComparisonBUT.VALUES2_DEFAULT ...
                MRIComparisonBUT.DENSITY2_DEFAULT ...
                MRIComparisonBUT.PVALUE1_DEFAULT ...
                MRIComparisonBUT.PVALUE2_DEFAULT ...
                MRIComparisonBUT.PERCENTILES_DEFAULT];
        end
    end
end