classdef MRIMeasureWU < MRIMeasure
    % MRIMeasureWU < MRIMeasure : Weighted undirected MRI measures 
    %   MRIMeasureBUT represents MRI measures of weighted undirected graph.
    %
    % MRIMeasureWU properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % MRIMeasureWU properties (Constant):
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
    % MRIMeasureWU methods (Access = protected):
    %   MRIMeasureWU        -   constructor
    %
    % MRIMeasureWU methods:
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
    % MRIMeasureWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < MRIMeasure
    %   getTags         -   cell array of strings with the tags of the properties < MRIMeasure
    %   getFormats      -   cell array with the formats of the properties < MRIMeasure
    %   getDefaults     -   cell array with the defaults of the properties < MRIMeasure
    %   getOptions      -   cell array with options (only for properties with options format) < MRIMeasure    
    %
    % See also MRIMeasure, MRIMeasureBUD, MRIMeasureBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function m = MRIMeasureWU(varargin)
            % MRIMEASUREWU() creates weighted undirected MRI measures with default properties.
            %
            % MRIMEASUREWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIMeasureWU.CODE         -   numeric
            %     MRIMeasureWU.PARAM        -   numeric
            %     MRIMeasureWU.NOTES        -   char
            %     MRIMeasureWU.GROUP1       -   numeric
            %     MRIMeasureWU.VALUES1      -   numeric
            %
            % See also MRIMeasureWU.
            
            m = m@MRIMeasure(varargin{:});
        end
        function [code,g] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G] = HASH(M) returns the code CODE and the group G of the measure given by M.
            %
            % See also MRIMeasureWU. 
            
            code = m.getProp(MRIMeasureWU.CODE);
            g = m.getProp(MRIMeasureWU.GROUP1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also MRIMeasureWU, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also MRIMeasureWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also MRIMeasureWU, isMeasure, isComparison.
            
            bool = false;
        end
    end
end