classdef EEGMeasureBUT < EEGMeasure
    % EEGMeasureBUT < EEGMeasure : Fixed threshold binary undirected EEG measure 
    %   EEGMeasureBUT represents EEG measure of binary undirected graph with fixed threshold.
    %
    % EEGMeasureBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGMeasureBUT properties (Constants):
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
    %   GROUP1              -   group numeric code < EEGMeasure
    %   GROUP1_TAG          -   group tag < EEGMeasure
    %   GROUP1_FORMAT       -   group format < EEGMeasure
    %   GROUP1_DEFAULT      -   group default < EEGMeasure
    %
    %   VALUES1             -   values numeric code < EEGMeasure
    %   VALUES1_TAG         -   values tag < EEGMeasure
    %   VALUES1_FORMAT      -   values format < EEGMeasure
    %   VALUES1_DEFAULT     -   values default < EEGMeasure
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
    % EEGMeasureBUT methods:
    %   EEGMeasureBUT  -   constructor
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %   mean            -   mean of measure < EEGMeasure
    %   std             -   standard deviation of measure < EEGMeasure 
    %   var             -   variance of measure < EEGMeasure
    %   hash            -   hash value of the hash list element   
    %   isMeasure       -   return true if measure
    %   isComparison    -   return true if comparison
    %   isRandom        -   return true if comparison with random graphs
    %
    % EEGMeasureBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasure, EEGMeasureBUD, EEGMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % threshold
        THRESHOLD = EEGMeasure.propnumber() + 1
        THRESHOLD_TAG = 'threshold'
        THRESHOLD_FORMAT = BNC.NUMERIC
        THRESHOLD_DEFAULT = 0.5

        % density 1
        DENSITY1 = EEGMeasure.propnumber() + 2
        DENSITY1_TAG = 'density1'
        DENSITY1_FORMAT = BNC.NUMERIC
        DENSITY1_DEFAULT = NaN

        dTHRESHOLD = 1e-4
        THRESHOLD_LEVELS = 2/EEGMeasureBUT.dTHRESHOLD + 1
    end
    methods
        function m = EEGMeasureBUT(varargin)
            % EEGMEASUREBUT() creates binary undirected EEG measures with fixed threshold.
            %
            % EEGMEASUREBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGMeasureBUT.CODE         -   numeric
            %     EEGMeasureBUT.PARAM        -   numeric
            %     EEGMeasureBUT.NOTES        -   char
            %     EEGMeasureBUT.GROUP1       -   numeric
            %     EEGMeasureBUT.VALUES1      -   numeric
            %     EEGMeasureBUT.THRESHOLD    -   numeric
            %     EEGMeasureBUT.DENSITY1     -   numeric
            %
            % See also EEGMeasureBUT.
            
            m = m@EEGMeasure(varargin{:});
        end
        function [code,g,t] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,T] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   T of the measure given by M.
            %   T is calculated as a function of the threshold to threshold
            %   levels ratio.
            %
            % See also EEGMeasureBUT. 
            
            code = m.getProp(EEGMeasureBUT.CODE);
            g = m.getProp(EEGMeasureBUT.GROUP1);
            t = round((m.getProp(EEGMeasureBUT.THRESHOLD)+1)/EEGMeasureBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also EEGMeasureBUT, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also EEGMeasureBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also EEGMeasureBUT, isMeasure, isComparison.            
            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGMeasureBUT.
            %
            % See also EEGMeasureBUT.

            N = EEGMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGMeasureBUT.
            %
            % See also EEGMeasureBUT, ListElement.
            
            tags = [ EEGMeasure.getTags() ...
                EEGMeasureBUT.THRESHOLD_TAG ...
                EEGMeasureBUT.DENSITY1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGMeasureBUT.
            %
            % See also EEGMeasureBUT, ListElement.
            
            formats = [EEGMeasure.getFormats() ...
                EEGMeasureBUT.THRESHOLD_FORMAT ...
                EEGMeasureBUT.DENSITY1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGMeasureBUT.
            %
            % See also EEGMeasureBUT, ListElement.
            
            defaults = [ EEGMeasure.getDefaults() ...
                EEGMeasureBUT.THRESHOLD_DEFAULT ...
                EEGMeasureBUT.DENSITY1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGMeasureBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGMeasureBUT, ListElement.
            
            options = {};
        end 
    end
end