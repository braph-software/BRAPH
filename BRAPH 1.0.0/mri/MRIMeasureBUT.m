classdef MRIMeasureBUT < MRIMeasure
    % MRIMeasureBUT < MRIMeasure : Fixed threshold binary undirected MRI measure 
    %   MRIMeasureBUT represents MRI measure of binary undirected graph with fixed threshold.
    %
    % MRIMeasureBUT properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % MRIMeasureBUT properties (Constants):
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
    % MRIMeasureBUT methods:
    %   MRIMeasureBUT   -   constructor
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
    % MRIMeasureBUT methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIMeasure, MRIMeasureBUD, MRIMeasureWU.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % threshold
        THRESHOLD = MRIMeasure.propnumber() + 1
        THRESHOLD_TAG = 'threshold'
        THRESHOLD_FORMAT = BNC.NUMERIC
        THRESHOLD_DEFAULT = 0.5
        
        % density 1
        DENSITY1 = MRIMeasure.propnumber() + 2
        DENSITY1_TAG = 'density1'
        DENSITY1_FORMAT = BNC.NUMERIC
        DENSITY1_DEFAULT = NaN
        
        dTHRESHOLD = 1e-4
        THRESHOLD_LEVELS = 2/MRIMeasureBUT.dTHRESHOLD + 1
    end
    methods
        function m = MRIMeasureBUT(varargin)
            % MRIMEASUREBUT() creates binary undirected MRI measures with fixed threshold.
            %
            % MRIMEASUREBUT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIMeasureBUT.CODE         -   numeric
            %     MRIMeasureBUT.PARAM        -   numeric
            %     MRIMeasureBUT.NOTES        -   char
            %     MRIMeasureBUT.GROUP1       -   numeric
            %     MRIMeasureBUT.VALUES1      -   numeric
            %     MRIMeasureBUT.THRESHOLD    -   numeric
            %     MRIMeasureBUT.DENSITY1     -   numeric
            %
            % See also MRIMeasureBUT.
            
            m = m@MRIMeasure(varargin{:});
        end
        function [code,g,t] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G,T] = HASH(M) returns the code CODE, the group G and the conversion parameter
            %   T of the measure given by M.
            %   T is calculated as a function of the threshold to threshold
            %   levels ratio.
            %
            % See also MRIMeasureBUT. 
            
            code = m.getProp(MRIMeasureBUT.CODE);
            g = m.getProp(MRIMeasureBUT.GROUP1);
            t = round((m.getProp(MRIMeasureBUT.THRESHOLD)+1)/MRIMeasureBUT.dTHRESHOLD + 1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also MRIMeasureBUT, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also MRIMeasureBUT, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIMeasureBUT, isMeasure, isComparison.

            bool = false;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIMeasureBUT.
            %
            % See also MRIMeasureBUT.

            N = MRIMeasure.propnumber() + 2;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIMeasureBUT.
            %
            % See also MRIMeasureBUT, ListElement.
            
            tags = [ MRIMeasure.getTags() ...
                MRIMeasureBUT.THRESHOLD_TAG ...
                MRIMeasureBUT.DENSITY1_TAG];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIMeasureBUT.
            %
            % See also MRIMeasureBUT, ListElement.
            
            formats = [MRIMeasure.getFormats() ...
                MRIMeasureBUT.THRESHOLD_FORMAT ...
                MRIMeasureBUT.DENSITY1_FORMAT];
        end
        function defaults = getDefaults()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIMeasureBUT.
            %
            % See also MRIMeasureBUT, ListElement.
            
            defaults = [ MRIMeasure.getDefaults() ...
                MRIMeasureBUT.THRESHOLD_DEFAULT ...
                MRIMeasureBUT.DENSITY1_DEFAULT];
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIMeasureBUT.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIMeasureBUT, ListElement.
            
            options = {};
        end 
    end
end