classdef fMRIComparisonBUT < fMRIMeasureBUT
    % fMRIComparisonBUT < fMRIMeasureBUT : Fixed threshold binary undirected fMRI comparison 
    %   fMRIComparisonBUT represents fMRI comparison of binary undirected graph with fixed threshold.
    %
    % fMRIComparisonBUT properties (Access = protected):
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
    %   THRESHOLD           -   threshold numeric code < fMRIMeasureBUT
    %   THRESHOLD_TAG       -   threshold tag < fMRIMeasureBUT
    %   THRESHOLD_FORMAT    -   threshold format < fMRIMeasureBUT
    %   THRESHOLD_DEFAULT   -   threshold default < fMRIMeasureBUT
    %
    %   DENSITY1            -   density 1 numeric code < fMRIMeasureBUT
    %   DENSITY1_TAG        -   density 1 tag < fMRIMeasureBUT
    %   DENSITY1_FORMAT     -   density 1 format < fMRIMeasureBUT
    %   DENSITY1_DEFAULT    -   density 1 default < fMRIMeasureBUT
    %
    %   dTHRESHOLD          -   d threshold value < fMRIMeasureBUT
    %   THRESHOLD_LEVELS    -   level of threshold < fMRIMeasureBUT
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
    % fMRIComparisonBUT methods:
    %   fMRIComparisonBUT   -   constructor
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
    % fMRIComparisonBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasureBUT, fMRIComparisonBUD, fMRIComparisonWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % group 2
        GROUP2 = fMRIMeasureBUT.propnumber() + 1
        GROUP2_TAG = 'group2'
        GROUP2_FORMAT = BNC.NUMERIC
        GROUP2_DEFAULT = 2

        % measure values group 2
        VALUES2 = fMRIMeasureBUT.propnumber() + 2
        VALUES2_TAG = 'values2'
        VALUES2_FORMAT = BNC.NUMERIC
        VALUES2_DEFAULT = NaN
        
        % density 2
        DENSITY2 = fMRIMeasureBUT.propnumber() + 3
        DENSITY2_TAG = 'density2'
        DENSITY2_FORMAT = BNC.NUMERIC
        DENSITY2_DEFAULT = NaN

        % one-tailed p-value
        PVALUE1 = fMRIMeasureBUT.propnumber() + 4
        PVALUE1_TAG = 'pvalue1'
        PVALUE1_FORMAT = BNC.NUMERIC
        PVALUE1_DEFAULT = NaN

        % two-tailed p-value
        PVALUE2 = fMRIMeasureBUT.propnumber() + 5
        PVALUE2_TAG = 'pvalue2'
        PVALUE2_FORMAT = BNC.NUMERIC
        PVALUE2_DEFAULT = NaN

        % percentiles
        PERCENTILES = fMRIMeasureBUT.propnumber() + 6
        PERCENTILES_TAG = 'percentiles'
        PERCENTILES_FORMAT = BNC.NUMERIC
        PERCENTILES_DEFAULT = NaN
        
    end
    methods
        function c = fMRIComparisonBUT(varargin)
            % FMRICOMPARISONBUT() creates binary undirected fMRI comparisons with fixed threshold.
            %
            % FMRICOMPARISONBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIComparisonBUT.CODE         -   numeric
            %     fMRIComparisonBUT.PARAM        -   numeric
            %     fMRIComparisonBUT.NOTES        -   char
            %     fMRIComparisonBUT.GROUP1       -   numeric
            %     fMRIComparisonBUT.VALUES1      -   numeric
            %     fMRIComparisonBUT.DENSITY1     -   numeric
            %     fMRIComparisonBUT.THRESHOLD    -   numeric
            %     fMRIComparisonBUT.GROUP2       -   numeric
            %     fMRIComparisonBUT.VALUES2      -   numeric
            %     fMRIComparisonBUT.DENSITY2     -   numeric
            %     fMRIComparisonBUT.PVALUE1      -   numeric
            %     fMRIComparisonBUT.PVALUE2      -   numeric
            %     fMRIComparisonBUT.PERCENTILES  -   numeric
            %
            % See also fMRIComparisonBUT.
            
            c = c@fMRIMeasureBUT(varargin{:});
        end
        function d = diff(c)
            % DIFF difference between two measures
            %
            % D = DIFF(C) returns the difference D between the two measures that are constituents 
            %   of the comparison C.  
            %
            % See also fMRIComparisonBUT. 
            
            d = mean(c.getProp(fMRIComparisonBUT.VALUES2),1)-mean(c.getProp(fMRIComparisonBUT.VALUES1),1);
        end
        function ci = CI(c,p)
            % CI confidence interval calculated for a comparison
            %
            % CI = CI(C,P) returns the confidence interval CI of the comparison C given the 
            %   P-quantiles of the percentiles of C.
            %
            % See also fMRIComparisonBUT. 
            
            p = round(p);
            percentiles = c.getProp(fMRIComparisonBUT.PERCENTILES);
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
            % See also fMRIComparisonBUT. 
            
            code = c.getProp(fMRIComparisonBUT.CODE);
            g1 = c.getProp(fMRIComparisonBUT.GROUP1);
            g2 = c.getProp(fMRIComparisonBUT.GROUP2);
            t = round((c.getProp(fMRIComparisonBUT.THRESHOLD)+1)/fMRIComparisonBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns false for comparisons.
            %
            % See also fMRIComparisonBUT, isComparison, isRandom.
            
            bool = false;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns true for comparisons.
            %
            % See also fMRIComparisonBUT, isMeasure, isRandom.
            
            bool = true;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also fMRIComparisonBUT, isMeasure, isComparison.            
            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT.

            N = fMRIMeasureBUT.propnumber() + 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            tags = [ fMRIMeasureBUT.getTags() ...
                fMRIComparisonBUT.GROUP2_TAG ...
                fMRIComparisonBUT.VALUES2_TAG ...
                fMRIComparisonBUT.DENSITY2_TAG ...
                fMRIComparisonBUT.PVALUE1_TAG ...
                fMRIComparisonBUT.PVALUE2_TAG ...
                fMRIComparisonBUT.PERCENTILES_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            formats = [fMRIMeasureBUT.getFormats() ...
                fMRIComparisonBUT.GROUP2_FORMAT ...
                fMRIComparisonBUT.VALUES2_FORMAT ...
                fMRIComparisonBUT.DENSITY2_FORMAT ...
                fMRIComparisonBUT.PVALUE1_FORMAT ...
                fMRIComparisonBUT.PVALUE2_FORMAT ...
                fMRIComparisonBUT.PERCENTILES_FORMAT];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRIComparisonBUT.
            %
            % See also fMRIComparisonBUT, ListElement.
            
            defaults = [fMRIMeasureBUT.getDefaults() ...
                fMRIComparisonBUT.GROUP2_DEFAULT ...
                fMRIComparisonBUT.VALUES2_DEFAULT ...
                fMRIComparisonBUT.DENSITY2_DEFAULT ...
                fMRIComparisonBUT.PVALUE1_DEFAULT ...
                fMRIComparisonBUT.PVALUE2_DEFAULT ...
                fMRIComparisonBUT.PERCENTILES_DEFAULT];
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