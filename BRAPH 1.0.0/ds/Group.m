classdef Group < ListElement
    % Group < ListElement (Abstract) : Group
    %   Group represents group of list elements.
    %   Instances of this class cannot be created.
    %
    % Group properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %
    % Group properties (Constant):
    %   NAME                -   name numeric code
    %   NAME_TAG            -   name tag
    %   NAME_FORMAT         -   name format
    %   NAME_DEFAULT        -   name default value
    %
    %   DATA                -   data numeric code
    %   DATA_TAG            -   data tag
    %   DATA_FORMAT         -   data format
    %   DATA_DEFAULT        -   data default value
    %
    %   NOTES               -   notes numeric code
    %   NOTES_TAG           -   notes tag
    %   NOTES_FORMAT        -   notes format
    %   NOTES_DEFAULT       -   data default value
    %
    % Group methods:
    %   Group           -   constructor
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %
    % Group methods (Abstract, Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also GroupList, ListElement.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % group name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'Group'
        
        % data
        DATA = 2
        DATA_TAG = 'data'
        DATA_FORMAT = BNC.LOGICAL
        DATA_DEFAULT = []
        
        % notes
        NOTES = 3
        NOTES_TAG = 'notes'
        NOTES_FORMAT = BNC.CHAR
        NOTES_DEFAULT = '---'
        
    end
    methods
        function g = Group(varargin)
            % GROUP creates a group of list elements with default properties.
            %
            % GROUP(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     Group.NAME      -   char
            %     Group.DATA      -   logical
            %     Group.NOTES     -   char
            %
            % See also Group, ListElement.
            
            g = g@ListElement(varargin{:});
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of Group.
            %
            % See also Group.
            
            N = 3;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of Group.
            %
            % See also Group, ListElement.
            
            tags = {Group.NAME_TAG ...
                Group.DATA_TAG ...
                Group.NOTES_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of Group.
            %
            % See also Group, ListElement.
            
            formats = {Group.NAME_FORMAT ...
                Group.DATA_FORMAT ...
                Group.NOTES_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of Group.
            %
            % See also Group, ListElement.
            
            defaults = {Group.NAME_DEFAULT ...
                Group.DATA_DEFAULT ...
                Group.NOTES_DEFAULT};
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of Group.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also Group, ListElement.
            
            options = {};
        end
    end
end