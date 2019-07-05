classdef EEGMeasureWU < EEGMeasure
    % EEGMeasureWU < EEGMeasure : Weighted undirected EEG measures 
    %   EEGMeasureBUT represents EEG measures of weighted undirected graph.
    %
    % EEGMeasureWU properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % EEGMeasureWU properties (Constant):
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
    % EEGMeasureWU methods (Access = protected):
    %   EEGMeasureWU        -   constructor
    %
    % EEGMeasureWU methods:
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
    % EEGMeasureWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < EEGMeasure
    %   getTags         -   cell array of strings with the tags of the properties < EEGMeasure
    %   getFormats      -   cell array with the formats of the properties < EEGMeasure
    %   getDefaults     -   cell array with the defaults of the properties < EEGMeasure
    %   getOptions      -   cell array with options (only for properties with options format) < EEGMeasure    
    %
    % See also EEGMeasure, EEGMeasureBUD, EEGMeasureBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function m = EEGMeasureWU(varargin)
            % EEGMEASUREWU() creates weighted undirected EEG measures with default properties.
            %
            % EEGMEASUREWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGMeasureWU.CODE         -   numeric
            %     EEGMeasureWU.PARAM        -   numeric
            %     EEGMeasureWU.NOTES        -   char
            %     EEGMeasureWU.GROUP1       -   numeric
            %     EEGMeasureWU.VALUES1      -   numeric
            %
            % See also EEGMeasureWU.
            
            m = m@EEGMeasure(varargin{:});
        end
        function [code,g] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G] = HASH(M) returns the code CODE and the group G of the measure given by M.
            %
            % See also EEGMeasureWU. 
            
            code = m.getProp(EEGMeasureWU.CODE);
            g = m.getProp(EEGMeasureWU.GROUP1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also EEGMeasureWU, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also EEGMeasureWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also EEGMeasureWU, isMeasure, isComparison.            
            
            bool = false;
        end
    end
end