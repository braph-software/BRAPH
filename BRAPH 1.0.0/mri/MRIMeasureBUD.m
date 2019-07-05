classdef MRIMeasureBUD < MRIMeasure
    % MRIMeasureBUD < MRIMeasure : Fixed density binary undirected MRI measure 
    %   MRIMeasureBUD represents MRI measure of binary undirected graph with fixed density.
    %
    % MRIMeasureBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % MRIMeasureBUD properties (Constants):
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
    %   GROUP1              -   group numeric code < MRIMeasure
    %   GROUP1_TAG          -   group tag < MRIMeasure
    %   GROUP1_FORMAT       -   group format < MRIMeasure
    %   GROUP1_DEFAULT      -   group default < MRIMeasure
    %
    %   VALUES1             -   values numeric code < MRIMeasure
    %   VALUES1_TAG         -   values tag < MRIMeasure
    %   VALUES1_FORMAT      -   values format < MRIMeasure
    %   VALUES1_DEFAULT     -   values default < MRIMeasure
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
    % MRIMeasureBUD methods:
    %   MRIMeasureBUD   -   constructor
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
    % MRIMeasureBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIMeasure, MRIMeasureBUT, MRIMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % density
        DENSITY = MRIMeasure.propnumber() + 1
        DENSITY_TAG = 'density'
        DENSITY_FORMAT = BNC.NUMERIC
        DENSITY_DEFAULT = 50
        
        % threshold 1
        THRESHOLD1 = MRIMeasure.propnumber() + 2
        THRESHOLD1_TAG = 'threshold1'
        THRESHOLD1_FORMAT = BNC.NUMERIC
        THRESHOLD1_DEFAULT = NaN
        
        dDENSITY = 1e-2
        DENSITY_LEVELS = 100/MRIMeasureBUD.dDENSITY + 1
    end
    methods
        function m = MRIMeasureBUD(varargin)
            % MRIMEASUREBUD() creates binary undirected MRI measures with fixed density.
            %
            % MRIMEASUREBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIMeasureBUD.CODE         -   numeric
            %     MRIMeasureBUD.PARAM        -   numeric
            %     MRIMeasureBUD.NOTES        -   char
            %     MRIMeasureBUD.GROUP1       -   numeric
            %     MRIMeasureBUD.VALUES1      -   numeric
            %     MRIMeasureBUD.DENSITY      -   numeric
            %     MRIMeasureBUD.THRESHOLD1   -   numeric
            %
            % See also MRIMeasureBUD.
            
            m = m@MRIMeasure(varargin{:});
        end
        function [code,g,d] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,D] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   D of the measure given by M.
            %   D is calculated as a function of the density to density
            %   levels ratio.
            %
            % See also MRIMeasureBUD. 
            
            code = m.getProp(MRIMeasureBUD.CODE);
            g = m.getProp(MRIMeasureBUD.GROUP1);
            d = round(m.getProp(MRIMeasureBUD.DENSITY)/MRIMeasureBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also MRIMeasureBUD, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also MRIMeasureBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIMeasureBUD, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIMeasureBUD.
            %
            % See also MRIMeasureBUD.

            N = MRIMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIMeasureBUD.
            %
            % See also MRIMeasureBUD, ListElement.
            
            tags = [ MRIMeasure.getTags() ...
                MRIMeasureBUD.DENSITY_TAG ...
                MRIMeasureBUD.THRESHOLD1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIMeasureBUD.
            %
            % See also MRIMeasureBUD, ListElement.
            
            formats = [MRIMeasure.getFormats() ...
                MRIMeasureBUD.DENSITY_FORMAT ...
                MRIMeasureBUD.THRESHOLD1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIMeasureBUD.
            %
            % See also MRIMeasureBUD, ListElement.
            
            defaults = [ MRIMeasure.getDefaults() ...
                MRIMeasureBUD.DENSITY_DEFAULT ...
                MRIMeasureBUD.THRESHOLD1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIMeasureBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIMeasureBUD, ListElement.
            
            options = {};
        end
        
    end
end