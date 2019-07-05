classdef EEGMeasureBUD < EEGMeasure
    % EEGMeasureBUD < EEGMeasure : Fixed density binary undirected EEG measure 
    %   EEGMeasureBUD represents EEG measure of binary undirected graph with fixed density.
    %
    % EEGMeasureBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGMeasureBUD properties (Constants):
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
    %   DENSITY             -   density numeric code
    %   DENSITY_TAG         -   density tag
    %   DENSITY_FORMAT      -   density format
    %   DENSITY_DEFAULT     -   density default
    %
    %   THRESHOLD1          -   threshold numeric code
    %   THRESHOLD1_TAG      -   threshold tag
    %   THRESHOLD1_FORMAT   -   threshold format
    %   THRESHOLD1_DEFAULT  -   threshold default
    %
    %   dDENSITY            -   d density value
    %   DENSITY_LEVELS      -   density intervals
    %
    % EEGMeasureBUD methods:
    %   EEGMeasureBUD  -   constructor
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
    % EEGMeasureBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also EEGMeasure, EEGMeasureBUT, EEGMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % density
        DENSITY = EEGMeasure.propnumber() + 1
        DENSITY_TAG = 'density'
        DENSITY_FORMAT = BNC.NUMERIC
        DENSITY_DEFAULT = 50

        % threshold 1
        THRESHOLD1 = EEGMeasure.propnumber() + 2
        THRESHOLD1_TAG = 'threshold1'
        THRESHOLD1_FORMAT = BNC.NUMERIC
        THRESHOLD1_DEFAULT = NaN

        dDENSITY = 1e-2
        DENSITY_LEVELS = 100/EEGMeasureBUD.dDENSITY + 1
    end
    methods
        function m = EEGMeasureBUD(varargin)
            % EEGMEASUREBUD() creates binary undirected EEG measures with fixed density.
            %
            % EEGMEASUREBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGMeasureBUD.CODE         -   numeric
            %     EEGMeasureBUD.PARAM        -   numeric
            %     EEGMeasureBUD.NOTES        -   char
            %     EEGMeasureBUD.GROUP1       -   numeric
            %     EEGMeasureBUD.VALUES1      -   numeric
            %     EEGMeasureBUD.DENSITY      -   numeric
            %     EEGMeasureBUD.THRESHOLD1   -   numeric
            %
            % See also EEGMeasureBUD.
            
            m = m@EEGMeasure(varargin{:});
        end
        function [code,g,d] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,D] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   D of the measure given by M.
            %   D is calculated as a function of the density to density
            %   levels ratio.
            %
            % See also EEGMeasureBUD.
            
            code = m.getProp(EEGMeasureBUD.CODE);
            g = m.getProp(EEGMeasureBUD.GROUP1);
            d = round(m.getProp(EEGMeasureBUD.DENSITY)/EEGMeasureBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also EEGMeasureBUD, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also EEGMeasureBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also EEGMeasureBUD, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGMeasureBUD.
            %
            % See also EEGMeasureBUD.

            N = EEGMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGMeasureBUD.
            %
            % See also EEGMeasureBUD, ListElement.
            
            tags = [ EEGMeasure.getTags() ...
                EEGMeasureBUD.DENSITY_TAG ...
                EEGMeasureBUD.THRESHOLD1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGMeasureBUD.
            %
            % See also EEGMeasureBUD, ListElement.
            
            formats = [EEGMeasure.getFormats() ...
                EEGMeasureBUD.DENSITY_FORMAT ...
                EEGMeasureBUD.THRESHOLD1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGMeasureBUD.
            %
            % See also EEGMeasureBUD, ListElement.
            
            defaults = [ EEGMeasure.getDefaults() ...
                EEGMeasureBUD.DENSITY_DEFAULT ...
                EEGMeasureBUD.THRESHOLD1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGMeasureBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGMeasureBUD, ListElement.
            
            options = {};
        end
    end
end