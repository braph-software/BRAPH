classdef fMRIMeasureBUT < fMRIMeasure
    % fMRIMeasureBUT < fMRIMeasure : Fixed threshold binary undirected fMRI measure 
    %   fMRIMeasureBUT represents fMRI measure of binary undirected graph with fixed threshold.
    %
    % fMRIMeasureBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % fMRIMeasureBUT properties (Constants):
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
    %   GROUP1              -   group numeric code < fMRIMeasure
    %   GROUP1_TAG          -   group tag < fMRIMeasure
    %   GROUP1_FORMAT       -   group format < fMRIMeasure
    %   GROUP1_DEFAULT      -   group default < fMRIMeasure
    %
    %   VALUES1             -   values numeric code < fMRIMeasure
    %   VALUES1_TAG         -   values tag < fMRIMeasure
    %   VALUES1_FORMAT      -   values format < fMRIMeasure
    %   VALUES1_DEFAULT     -   values default < fMRIMeasure
    %
    %   THRESHOLD           -   threshold numeric code
    %   THRESHOLD_TAG       -   threshold tag
    %   THRESHOLD_FORMAT    -   threshold format
    %   THRESHOLD_DEFAULT   -   threshold default
    %
    %   DENSITY1            -   density 1 numeric code
    %   DENSITY1_TAG        -   density 1 tag
    %   DENSITY1_FORMAT     -   density 1 format
    %   DENSITY1_DEFAULT    -   density 1 default
    %
    %   dTHRESHOLD          -   d threshold value
    %   THRESHOLD_LEVELS    -   level of threshold
    %
    % fMRIMeasureBUT methods:
    %   fMRIMeasureBUT  -   constructor
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %   mean            -   mean of measure < fMRIMeasure
    %   std             -   standard deviation of measure < fMRIMeasure 
    %   var             -   variance of measure < fMRIMeasure
    %   hash            -   hash value of the hash list element   
    %   isMeasure       -   return true if measure
    %   isComparison    -   return true if comparison
    %   isRandom        -   return true if comparison with random graphs
    %
    % fMRIMeasureBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasure, fMRIMeasureBUD, fMRIMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % threshold
        THRESHOLD = fMRIMeasure.propnumber() + 1
        THRESHOLD_TAG = 'threshold'
        THRESHOLD_FORMAT = BNC.NUMERIC
        THRESHOLD_DEFAULT = 0.5

        % density 1
        DENSITY1 = fMRIMeasure.propnumber() + 2
        DENSITY1_TAG = 'density1'
        DENSITY1_FORMAT = BNC.NUMERIC
        DENSITY1_DEFAULT = NaN

        dTHRESHOLD = 1e-4
        THRESHOLD_LEVELS = 2/fMRIMeasureBUT.dTHRESHOLD + 1
    end
    methods
        function m = fMRIMeasureBUT(varargin)
            % FMRIMEASUREBUT() creates binary undirected fMRI measures with fixed threshold.
            %
            % FMRIMEASUREBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIMeasureBUT.CODE         -   numeric
            %     fMRIMeasureBUT.PARAM        -   numeric
            %     fMRIMeasureBUT.NOTES        -   char
            %     fMRIMeasureBUT.GROUP1       -   numeric
            %     fMRIMeasureBUT.VALUES1      -   numeric
            %     fMRIMeasureBUT.THRESHOLD    -   numeric
            %     fMRIMeasureBUT.DENSITY1     -   numeric
            %
            % See also fMRIMeasureBUT.
            
            m = m@fMRIMeasure(varargin{:});
        end
        function [code,g,t] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,T] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   T of the measure given by M.
            %   T is calculated as a function of the threshold to threshold
            %   levels ratio.
            %
            % See also fMRIMeasureBUT. 
            
            code = m.getProp(fMRIMeasureBUT.CODE);
            g = m.getProp(fMRIMeasureBUT.GROUP1);
            t = round((m.getProp(fMRIMeasureBUT.THRESHOLD)+1)/fMRIMeasureBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also fMRIMeasureBUT, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also fMRIMeasureBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also fMRIMeasureBUT, isMeasure, isComparison.            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIMeasureBUT.
            %
            % See also fMRIMeasureBUT.

            N = fMRIMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIMeasureBUT.
            %
            % See also fMRIMeasureBUT, ListElement.
            
            tags = [ fMRIMeasure.getTags() ...
                fMRIMeasureBUT.THRESHOLD_TAG ...
                fMRIMeasureBUT.DENSITY1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIMeasureBUT.
            %
            % See also fMRIMeasureBUT, ListElement.
            
            formats = [fMRIMeasure.getFormats() ...
                fMRIMeasureBUT.THRESHOLD_FORMAT ...
                fMRIMeasureBUT.DENSITY1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIMeasureBUT.
            %
            % See also fMRIMeasureBUT, ListElement.
            
            defaults = [ fMRIMeasure.getDefaults() ...
                fMRIMeasureBUT.THRESHOLD_DEFAULT ...
                fMRIMeasureBUT.DENSITY1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIMeasureBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIMeasureBUT, ListElement.
            
            options = {};
        end 
    end
end