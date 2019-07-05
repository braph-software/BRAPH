classdef MRIComparisonWU < MRIMeasureWU
    % MRIComparisonWU < MRIMeasureWU : Weighted undirected MRI comparison 
    %   MRIComparisonWU represents MRI comparison of weighted undirected graph.
    %
    % MRIComparisonWU properties (Access = protected):
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
    % MRIComparisonWU methods:
    %   MRIComparisonWU    -   constructor
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
    % MRIComparisonWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIMeasureWU, MRIComparisonBUD, MRIComparisonBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % group 2
        GROUP2 = MRIMeasureWU.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2
        
        % measure values group 2
        VALUES2 = MRIMeasureWU.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = MRIMeasureWU.propnumber() + 3
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN
        
        % two-tailed p-value
        PVALUE2 = MRIMeasureWU.propnumber() + 4
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = MRIMeasureWU.propnumber() + 5
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN

    end
    methods
        function c = MRIComparisonWU(varargin)
            % MRICOMPARISONWU() creates weighted undirected MRI comparisons.
            %
            % MRICOMPARISONWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIComparisonWU.CODE         -   numeric
            %     MRIComparisonWU.PARAM        -   numeric
            %     MRIComparisonWU.NOTES        -   char
            %     MRIComparisonWU.GROUP1       -   numeric
            %     MRIComparisonWU.VALUES1      -   numeric
            %     MRIComparisonWU.GROUP2       -   numeric
            %     MRIComparisonWU.VALUES2      -   numeric
            %     MRIComparisonWU.PVALUE1      -   numeric
            %     MRIComparisonWU.PVALUE2      -   numeric
            %     MRIComparisonWU.PERCENTILES  -   numeric
            %
            % See also MRIComparisonWU.
            
            c = c@MRIMeasureWU(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also MRIComparisonWU. 
            
            d = c.getProp(MRIComparisonWU.VALUES2)-c.getProp(MRIComparisonWU.VALUES1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also MRIComparisonWU. 
            
            p = round(p);
            percentiles = c.getProp(MRIComparisonWU.PERCENTILES);
            if p==50
                ci = percentiles(51,:);
            elseif p>=0 && p<50
                ci = [percentiles(p+1,:); percentiles(101-p,:)];
            else
                ci = NaN;
            end
        end
        function [code,g1,g2] = hash(c)
            % HASH hash values of the hash list element
            %
            % [CODE,G1,G2] = HASH(C) returns the code CODE, the groups G1 and G2 of the comparison 
            %   given by C.
            %   
            % See also MRIComparisonWU. 
            
            code = c.getProp(MRIComparisonWU.CODE);
            g1 = c.getProp(MRIComparisonWU.GROUP1);
            g2 = c.getProp(MRIComparisonWU.GROUP2);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also MRIComparisonWU, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also MRIComparisonWU, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIComparisonWU, isMeasure, isComparison.
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIComparisonWU.
            %
            % See also MRIComparisonWU.

            N = MRIMeasureWU.propnumber() + 5;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIComparisonWU.
            %
            % See also MRIComparisonWU, ListElement.
            
            tags = [ MRIMeasureWU.getTags() ...
                MRIComparisonWU.GROUP2_TAG ...
                MRIComparisonWU.VALUES2_TAG ...
                MRIComparisonWU.PVALUE1_TAG ...
                MRIComparisonWU.PVALUE2_TAG ...
                MRIComparisonWU.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIComparisonWU.
            %
            % See also MRIComparisonWU, ListElement.
            
            formats = [MRIMeasureWU.getFormats() ...
                MRIComparisonWU.GROUP2_FORMAT ...
                MRIComparisonWU.VALUES2_FORMAT ...
                MRIComparisonWU.PVALUE1_FORMAT ...
                MRIComparisonWU.PVALUE2_FORMAT ...
                MRIComparisonWU.PERCENTILES_FORMAT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIComparisonWU.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIComparisonWU, ListElement.
            
            options = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of MRIComparisonWU.
            %
            % See also MRIComparisonWU, ListElement.
            
            defaults = [MRIMeasureWU.getDefaults() ...
                MRIComparisonWU.GROUP2_DEFAULT ...
                MRIComparisonWU.VALUES2_DEFAULT ...
                MRIComparisonWU.PVALUE1_DEFAULT ...
                MRIComparisonWU.PVALUE2_DEFAULT ...
                MRIComparisonWU.PERCENTILES_DEFAULT];
        end
    end
end