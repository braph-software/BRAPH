classdef fMRIComparisonWU < fMRIMeasureWU
    % fMRIComparisonWU < fMRIMeasureWU : Weighted undirected fMRI comparison 
    %   fMRIComparisonWU represents fMRI comparison of weighted undirected graph.
    %
    % fMRIComparisonWU properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % fMRIComparisonBUT properties (Constants):
    %   CODE                -   code numeric code < fMRIMeasure 
    %   CODE_TAG            -   code tag < fMRIMeasure 
    %   CODE_FORMAT         -   code format < fMRIMeasure
    %   CODE_DEFAULT        -   code default < fMRIMeasure
    %
    %   PARAM               -   parameters numeric code < fMRIMeasure
    %   PARAM_TAG           -   parameters tag < fMRIMeasure
    %   PARAM_FORMAT        -   parameters format < fMRIMeasure
    %   PARAM_DEFAULT       -   parameters default < fMRIMeasure
    %
    %   NOTES               -   notes numeric code < fMRIMeasure
    %   NOTES_TAG           -   notes tag < fMRIMeasure
    %   NOTES_FORMAT        -   notes format < fMRIMeasure
    %   NOTES_DEFAULT       -   notes default < fMRIMeasure
    %
    %   GROUP1              -   group1 numeric code < fMRIMeasure
    %   GROUP1_TAG          -   group1 tag < fMRIMeasure
    %   GROUP1_FORMAT       -   group1 format < fMRIMeasure
    %   GROUP1_DEFAULT      -   group1 default < fMRIMeasure
    %
    %   VALUES1             -   values1 numeric code < fMRIMeasure
    %   VALUES1_TAG         -   values1 tag < fMRIMeasure
    %   VALUES1_FORMAT      -   values1 format < fMRIMeasure
    %   VALUES1_DEFAULT     -   values1 default < fMRIMeasure
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
    % fMRIComparisonWU methods:
    %   fMRIComparisonWU    -   constructor
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   mean                -   mean of measure < fMRIMeasure
    %   std                 -   standard deviation of measure < fMRIMeasure 
    %   var                 -   variance of measure < fMRIMeasure
    %   diff                -   difference between two measures   
    %   CI                  -   confidence interval calculated for a comparison
    %   hash                -   hash values of the hash list element   
    %   isMeasure           -   return true if measure
    %   isComparison        -   return true if comparison 
    %   isRandom            -   return true if comparison with random graphs
    %
    % fMRIComparisonWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasureWU, fMRIComparisonBUD, fMRIComparisonBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % group 2
        GROUP2 = fMRIMeasureWU.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        % global measures: column vector [subjects x 1]
        % nodal measures: matrix [subjects x regions]
        VALUES2 = fMRIMeasureWU.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % one-tailed p-value
        PVALUE1 = fMRIMeasureWU.propnumber() + 3
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = fMRIMeasureWU.propnumber() + 4
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = fMRIMeasureWU.propnumber() + 5
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN

    end
    methods
        function c = fMRIComparisonWU(varargin)
            % FMRICOMPARISONWU() creates weighted undirected fMRI comparisons.
            %
            % FMRICOMPARISONWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIComparisonWU.CODE         -   numeric
            %     fMRIComparisonWU.PARAM        -   numeric
            %     fMRIComparisonWU.NOTES        -   char
            %     fMRIComparisonWU.GROUP1       -   numeric
            %     fMRIComparisonWU.VALUES1      -   numeric
            %     fMRIComparisonWU.GROUP2       -   numeric
            %     fMRIComparisonWU.VALUES2      -   numeric
            %     fMRIComparisonWU.PVALUE1      -   numeric
            %     fMRIComparisonWU.PVALUE2      -   numeric
            %     fMRIComparisonWU.PERCENTILES  -   numeric
            %
            % See also fMRIComparisonWU.
            
            c = c@fMRIMeasureWU(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also fMRIComparisonWU. 
            
            d = mean(c.getProp(fMRIComparisonWU.VALUES2),1)-mean(c.getProp(fMRIComparisonWU.VALUES1),1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also fMRIComparisonWU. 
            
            p = round(p);
            percentiles = c.getProp(fMRIComparisonWU.PERCENTILES);
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
            % See also fMRIComparisonWU. 
            
            code = c.getProp(fMRIComparisonWU.CODE);
            g1 = c.getProp(fMRIComparisonWU.GROUP1);
            g2 = c.getProp(fMRIComparisonWU.GROUP2);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also fMRIComparisonWU, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also fMRIComparisonWU, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also fMRIComparisonWU, isMeasure, isComparison.            
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU.

            N = fMRIMeasureWU.propnumber() + 5;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU, ListElement.
            
            tags = [fMRIMeasureWU.getTags() ...
                fMRIComparisonWU.GROUP2_TAG ...
                fMRIComparisonWU.VALUES2_TAG ...
                fMRIComparisonWU.PVALUE1_TAG ...
                fMRIComparisonWU.PVALUE2_TAG ...
                fMRIComparisonWU.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU, ListElement.
            
            formats = [fMRIMeasureWU.getFormats() ...
                fMRIComparisonWU.GROUP2_FORMAT ...
                fMRIComparisonWU.VALUES2_FORMAT ...
                fMRIComparisonWU.PVALUE1_FORMAT ...
                fMRIComparisonWU.PVALUE2_FORMAT ...
                fMRIComparisonWU.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRIComparisonWU.
            %
            % See also fMRIComparisonWU, ListElement.
            
            defaults = [fMRIMeasureWU.getDefaults() ...
                fMRIComparisonWU.GROUP2_DEFAULT ...
                fMRIComparisonWU.VALUES2_DEFAULT ...
                fMRIComparisonWU.PVALUE1_DEFAULT ...
                fMRIComparisonWU.PVALUE2_DEFAULT ...
                fMRIComparisonWU.PERCENTILES_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIComparisonWU.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIComparisonWU, ListElement.
            
            options = {};
        end
    end
end