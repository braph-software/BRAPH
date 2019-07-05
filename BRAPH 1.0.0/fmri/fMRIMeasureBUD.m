classdef fMRIMeasureBUD < fMRIMeasure
    % fMRIMeasureBUD < fMRIMeasure : Fixed density binary undirected fMRI measure 
    %   fMRIMeasureBUD represents fMRI measure of binary undirected graph with fixed density.
    %
    % fMRIMeasureBUD properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % fMRIMeasureBUD properties (Constants):
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
    % fMRIMeasureBUD methods:
    %   fMRIMeasureBUD  -   constructor
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
    % fMRIMeasureBUD methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIMeasure, fMRIMeasureBUT, fMRIMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % density
        DENSITY = fMRIMeasure.propnumber() + 1
        DENSITY_TAG = 'density'
        DENSITY_FORMAT = BNC.NUMERIC
        DENSITY_DEFAULT = 50

        % threshold 1
        THRESHOLD1 = fMRIMeasure.propnumber() + 2
        THRESHOLD1_TAG = 'threshold1'
        THRESHOLD1_FORMAT = BNC.NUMERIC
        THRESHOLD1_DEFAULT = NaN

        dDENSITY = 1e-2
        DENSITY_LEVELS = 100/fMRIMeasureBUD.dDENSITY + 1
    end
    methods
        function m = fMRIMeasureBUD(varargin)
            % FMRIMEASUREBUD() creates binary undirected fMRI measures with fixed density.
            %
            % FMRIMEASUREBUD(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIMeasureBUD.CODE         -   numeric
            %     fMRIMeasureBUD.PARAM        -   numeric
            %     fMRIMeasureBUD.NOTES        -   char
            %     fMRIMeasureBUD.GROUP1       -   numeric
            %     fMRIMeasureBUD.VALUES1      -   numeric
            %     fMRIMeasureBUD.DENSITY      -   numeric
            %     fMRIMeasureBUD.THRESHOLD1   -   numeric
            %
            % See also fMRIMeasureBUD.
            
            m = m@fMRIMeasure(varargin{:});
        end
        function [code,g,d] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,D] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   D of the measure given by M.
            %   D is calculated as a function of the density to density
            %   levels ratio.
            %
            % See also fMRIMeasureBUD.
            
            code = m.getProp(fMRIMeasureBUD.CODE);
            g = m.getProp(fMRIMeasureBUD.GROUP1);
            d = round(m.getProp(fMRIMeasureBUD.DENSITY)/fMRIMeasureBUD.dDENSITY + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also fMRIMeasureBUD, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also fMRIMeasureBUD, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also fMRIMeasureBUD, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of fMRIMeasureBUD.
            %
            % See also fMRIMeasureBUD.

            N = fMRIMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIMeasureBUD.
            %
            % See also fMRIMeasureBUD, ListElement.
            
            tags = [ fMRIMeasure.getTags() ...
                fMRIMeasureBUD.DENSITY_TAG ...
                fMRIMeasureBUD.THRESHOLD1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIMeasureBUD.
            %
            % See also fMRIMeasureBUD, ListElement.
            
            formats = [fMRIMeasure.getFormats() ...
                fMRIMeasureBUD.DENSITY_FORMAT ...
                fMRIMeasureBUD.THRESHOLD1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIMeasureBUD.
            %
            % See also fMRIMeasureBUD, ListElement.
            
            defaults = [ fMRIMeasure.getDefaults() ...
                fMRIMeasureBUD.DENSITY_DEFAULT ...
                fMRIMeasureBUD.THRESHOLD1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIMeasureBUD.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIMeasureBUD, ListElement.
            
            options = {};
        end
    end
end