classdef HashListElement < ListElement
    % HashListElement < ListElement (Abstract) : Hash list elements
    %   HashListElement represents an element of a hash list.
    %   Instances of this class cannot be created. Use one of the subclasses 
    %   (e.g., MRIMeasureBD).
    %
    % HashListElement properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %
    % HashListElement methods (Access = protected):
    %   HashListElement -   constructor
    %
    % HashListElement methods:
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %
    % HashListElement methods (Abstract, Static):
    %   propnumber      -   number of properties < ListElement
    %   getTags         -   cell array of strings with the tags of the properties < ListElement
    %   getFormats      -   cell array with the formats of the properties < ListElement
    %   getDefaults     -   cell array with the defaults of the properties < ListElement
    %   getOptions      -   cell array with options (only for properties with options format) < ListElement
    %
    % HashListElement methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %
    % HashListElement methods (Abstract):
    %   hash            -   hash value of the hash list element
    %
    % See also MRIMeasure, ListElement.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods (Access = protected)
        function hle = HashListElement(varargin)
            % HASHLISTELEMENT() creates a hash list element with default properties.
            %   This method is only accessible by the subclasses of HashListElement.
            %
            % HASHLISTELEMENT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %
            % See also HashListElement, ListElement.
            
            hle = hle@ListElement(varargin{:});
        end
    end
    methods (Abstract)
        h = hash(hle)  % hash value of the hash list element
    end
end