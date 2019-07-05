classdef PETMeasureWU < PETMeasure
    % PETMeasureWU < PETMeasure : Weighted undirected PET measures 
    %   PETMeasureBUT represents PET measures of weighted undirected graph.
    %
    % PETMeasureWU properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % PETMeasureWU properties (Constant):
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
    % PETMeasureWU methods (Access = protected):
    %   PETMeasureWU        -   constructor
    %
    % PETMeasureWU methods:
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
    % PETMeasureWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < PETMeasure
    %   getTags         -   cell array of strings with the tags of the properties < PETMeasure
    %   getFormats      -   cell array with the formats of the properties < PETMeasure
    %   getDefaults     -   cell array with the defaults of the properties < PETMeasure
    %   getOptions      -   cell array with options (only for properties with options format) < PETMeasure    
    %
    % See also PETMeasure, PETMeasureBUD, PETMeasureBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function m = PETMeasureWU(varargin)
            % PETMEASUREWU() creates weighted undirected PET measures with default properties.
            %
            % PETMEASUREWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     PETMeasureWU.CODE         -   numeric
            %     PETMeasureWU.PARAM        -   numeric
            %     PETMeasureWU.NOTES        -   char
            %     PETMeasureWU.GROUP1       -   numeric
            %     PETMeasureWU.VALUES1      -   numeric
            %
            % See also PETMeasureWU.
            
            m = m@PETMeasure(varargin{:});
        end
        function [code,g] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G] = HASH(M) returns the code CODE and the group G of the measure given by M.
            %
            % See also PETMeasureWU. 
            
            code = m.getProp(PETMeasureWU.CODE);
            g = m.getProp(PETMeasureWU.GROUP1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also PETMeasureWU, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also PETMeasureWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also PETMeasureWU, isMeasure, isComparison.
            
            bool = false;
        end
    end
end