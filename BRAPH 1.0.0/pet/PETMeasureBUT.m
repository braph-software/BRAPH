classdef PETMeasureBUT < PETMeasure
    % PETMeasureBUT < PETMeasure : Fixed threshold binary undirected PET measure 
    %   PETMeasureBUT represents PET measure of binary undirected graph with fixed threshold.
    %
    % PETMeasureBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETMeasureBUT properties (Constants):
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
    %   GROUP1              -   group numeric code < PETMeasure
    %   GROUP1_TAG          -   group tag < PETMeasure
    %   GROUP1_FORMAT       -   group format < PETMeasure
    %   GROUP1_DEFAULT      -   group default < PETMeasure
    %
    %   VALUES1             -   values numeric code < PETMeasure
    %   VALUES1_TAG         -   values tag < PETMeasure
    %   VALUES1_FORMAT      -   values format < PETMeasure
    %   VALUES1_DEFAULT     -   values default < PETMeasure
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
    % PETMeasureBUT methods:
    %   PETMeasureBUT   -   constructor
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %   hash            -   hash value of the hash list element   
    %   isMeasure       -   return true if measure
    %   isComparison    -   return true if comparison
    %   isRandom        -   return true if comparison with random graphs
    %
    % PETMeasureBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also PETMeasure, PETMeasureBUD, PETMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % threshold
        THRESHOLD = PETMeasure.propnumber() + 1
        THRESHOLD_TAG = 'threshold'
        THRESHOLD_FORMAT = BNC.NUMERIC
        THRESHOLD_DEFAULT = 0.5
        
        % density 1
        DENSITY1 = PETMeasure.propnumber() + 2
        DENSITY1_TAG = 'density1'
        DENSITY1_FORMAT = BNC.NUMERIC
        DENSITY1_DEFAULT = NaN
        
        dTHRESHOLD = 1e-4
        THRESHOLD_LEVELS = 2/PETMeasureBUT.dTHRESHOLD + 1
    end
    methods
        function m = PETMeasureBUT(varargin)
            % PETMEASUREBUT() creates binary undirected PET measures with fixed threshold.
            %
            % PETMEASUREBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETMeasureBUT.CODE         -   numeric
            %     PETMeasureBUT.PARAM        -   numeric
            %     PETMeasureBUT.NOTES        -   char
            %     PETMeasureBUT.GROUP1       -   numeric
            %     PETMeasureBUT.VALUES1      -   numeric
            %     PETMeasureBUT.THRESHOLD    -   numeric
            %     PETMeasureBUT.DENSITY1     -   numeric
            %
            % See also PETMeasureBUT.
            
            m = m@PETMeasure(varargin{:});
        end
        function [code,g,t] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,T] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   T of the measure given by M.
            %   T is calculated as a function of the threshold to threshold
            %   levels ratio.
            %
            % See also PETMeasureBUT. 
            
            code = m.getProp(PETMeasureBUT.CODE);
            g = m.getProp(PETMeasureBUT.GROUP1);
            t = round((m.getProp(PETMeasureBUT.THRESHOLD)+1)/PETMeasureBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also PETMeasureBUT, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also PETMeasureBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also PETMeasureBUT, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETMeasureBUT.
            %
            % See also PETMeasureBUT.

            N = PETMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETMeasureBUT.
            %
            % See also PETMeasureBUT, ListElement.
            
            tags = [ PETMeasure.getTags() ...
                PETMeasureBUT.THRESHOLD_TAG ...
                PETMeasureBUT.DENSITY1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETMeasureBUT.
            %
            % See also PETMeasureBUT, ListElement.
            
            formats = [PETMeasure.getFormats() ...
                PETMeasureBUT.THRESHOLD_FORMAT ...
                PETMeasureBUT.DENSITY1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETMeasureBUT.
            %
            % See also PETMeasureBUT, ListElement.
            
            defaults = [ PETMeasure.getDefaults() ...
                PETMeasureBUT.THRESHOLD_DEFAULT ...
                PETMeasureBUT.DENSITY1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETMeasureBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETMeasureBUT, ListElement.
            
            options = {};
        end 
    end
end