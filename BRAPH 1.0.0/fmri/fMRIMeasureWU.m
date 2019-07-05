classdef fMRIMeasureWU < fMRIMeasure
    % fMRIMeasureWU < fMRIMeasure : Weighted undirected fMRI measures 
    %   fMRIMeasureBUT represents fMRI measures of weighted undirected graph.
    %
    % fMRIMeasureWU properties (Access = protected):
    %   props               -   cell array of object properties < ListElement
    %
    % fMRIMeasureWU properties (Constant):
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
    % fMRIMeasureWU methods (Access = protected):
    %   fMRIMeasureWU        -   constructor
    %
    % fMRIMeasureWU methods:
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
    % fMRIMeasureWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < fMRIMeasure
    %   getTags         -   cell array of strings with the tags of the properties < fMRIMeasure
    %   getFormats      -   cell array with the formats of the properties < fMRIMeasure
    %   getDefaults     -   cell array with the defaults of the properties < fMRIMeasure
    %   getOptions      -   cell array with options (only for properties with options format) < fMRIMeasure    
    %
    % See also fMRIMeasure, fMRIMeasureBUD, fMRIMeasureBUT.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function m = fMRIMeasureWU(varargin)
            % FMRIMEASUREWU() creates weighted undirected fMRI measures with default properties.
            %
            % FMRIMEASUREWU(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIMeasureWU.CODE         -   numeric
            %     fMRIMeasureWU.PARAM        -   numeric
            %     fMRIMeasureWU.NOTES        -   char
            %     fMRIMeasureWU.GROUP1       -   numeric
            %     fMRIMeasureWU.VALUES1      -   numeric
            %
            % See also fMRIMeasureWU.
            
            m = m@fMRIMeasure(varargin{:});
        end
        function [code,g] = hash(m)
            % HASH hash value of the hash list element
            %
            % [CODE,G] = HASH(M) returns the code CODE and the group G of the measure given by M.
            %
            % See also fMRIMeasureWU. 
            
            code = m.getProp(fMRIMeasureWU.CODE);
            g = m.getProp(fMRIMeasureWU.GROUP1);
        end
        function bool = isMeasure(m)
            % ISMEASURE return true if measure
            %
            % BOOL = ISMEASURE(M) returns true for measures.
            %
            % See also fMRIMeasureWU, isComparison, isRandom.
            
            bool = true;
        end
        function bool = isComparison(m)
            % ISCOMPARISON return true if comparison
            %
            % BOOL = ISCOMPARISON(M) returns false for measures.
            %
            % See also fMRIMeasureWU, isMeasure, isRandom.
            
            bool = false;
        end
        function bool = isRandom(m)
            % ISRANDOM return true if comparison with random graphs
            %
            % BOOL = ISRANDOM(M) returns false for measures.
            %
            % See also fMRIMeasureWU, isMeasure, isComparison.            
            
            bool = false;
        end
    end
end