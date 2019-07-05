classdef PETMeasureBUD < PETMeasure
    % PETMeasureBUD < PETMeasure : Fixed density binary undirected PET measure 
    %   PETMeasureBUD represents PET measure of binary undirected graph with fixed density.
    %
    % PETMeasureBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETMeasureBUD properties (Constants):
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
    % PETMeasureBUD methods:
    %   PETMeasureBUD   -   constructor
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
    % PETMeasureBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also PETMeasure, PETMeasureBUT, PETMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % density
        DENSITY = PETMeasure.propnumber() + 1
        DENSITY_TAG = 'density'
        DENSITY_FORMAT = BNC.NUMERIC
        DENSITY_DEFAULT = 50
        
        % threshold 1
        THRESHOLD1 = PETMeasure.propnumber() + 2
        THRESHOLD1_TAG = 'threshold1'
        THRESHOLD1_FORMAT = BNC.NUMERIC
        THRESHOLD1_DEFAULT = NaN
        
        dDENSITY = 1e-2
        DENSITY_LEVELS = 100/PETMeasureBUD.dDENSITY + 1
    end
    methods
        function m = PETMeasureBUD(varargin)
            % PETMEASUREBUD() creates binary undirected PET measures with fixed density.
            %
            % PETMEASUREBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETMeasureBUD.CODE         -   numeric
            %     PETMeasureBUD.PARAM        -   numeric
            %     PETMeasureBUD.NOTES        -   char
            %     PETMeasureBUD.GROUP1       -   numeric
            %     PETMeasureBUD.VALUES1      -   numeric
            %     PETMeasureBUD.DENSITY      -   numeric
            %     PETMeasureBUD.THRESHOLD1   -   numeric
            %
            % See also PETMeasureBUD.
            
            m = m@PETMeasure(varargin{:});
        end
        function [code,g,d] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,D] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   D of the measure given by M.
            %   D is calculated as a function of the density to density
            %   levels ratio.
            %
            % See also PETMeasureBUD. 
            
            code = m.getProp(PETMeasureBUD.CODE);
            g = m.getProp(PETMeasureBUD.GROUP1);
            d = round(m.getProp(PETMeasureBUD.DENSITY)/PETMeasureBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also PETMeasureBUD, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also PETMeasureBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also PETMeasureBUD, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PETMeasureBUD.
            %
            % See also PETMeasureBUD.

            N = PETMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETMeasureBUD.
            %
            % See also PETMeasureBUD, ListElement.
            
            tags = [ PETMeasure.getTags() ...
                PETMeasureBUD.DENSITY_TAG ...
                PETMeasureBUD.THRESHOLD1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PETMeasureBUD.
            %
            % See also PETMeasureBUD, ListElement.
            
            formats = [PETMeasure.getFormats() ...
                PETMeasureBUD.DENSITY_FORMAT ...
                PETMeasureBUD.THRESHOLD1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of PETMeasureBUD.
            %
            % See also PETMeasureBUD, ListElement.
            
            defaults = [ PETMeasure.getDefaults() ...
                PETMeasureBUD.DENSITY_DEFAULT ...
                PETMeasureBUD.THRESHOLD1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of PETMeasureBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also PETMeasureBUD, ListElement.
            
            options = {};
        end
        
    end
end