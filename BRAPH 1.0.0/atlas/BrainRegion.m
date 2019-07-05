classdef BrainRegion < ListElement
    % BrainRegion < ListElement : Brain region
    %   BrainRegion represents a brain region.
    %
    % BrainRegion properties (Access = protected): 
    %   props           -   cell array of object properties < ListElement
    %
    % BrainRegion properties (Constants):
    %   LABEL           -   label numeric code
    %   LABEL_TAG       -   label tag
    %   LABEL_FORMAT	-   label format
    %   LABEL_DEFAULT   -   label default value ('BR')
    %   
    %   NAME            -   name numeric code
    %   NAME_TAG        -   name tag
    %   NAME_FORMAT     -   name format
    %   NAME_DEFAULT    -   name default value ('br name')
    % 
    %   X               -   x-coordinate numeric code
    %   X_TAG           -   x-coordinate tag
    %   X_FORMAT        -   x-coordinate format
    %   X_DEFAULT       -   x-coordinate default value (0)
    %   
    %   Y               -   y-coordinate numeric code
    %   Y_TAG           -   y-coordinate tag
    %   Y_FORMAT        -   y-coordinate format
    %   Y_DEFAULT       -   y-coordinate default value (0)
    %
    %   Z               -   z-coordinate numeric code
    %   Z_TAG           -   z-coordinate tag
    %   Z_FORMAT        -   z-coordinate format
    %   Z_DEFAULT       -   z-coordinate default value (0)
    %
    %   HS              -   hemisphere numeric code
    %   HS_TAG          -   hemisphere tag
    %   HS_FORMAT       -   hemisphere format
    %   HS_NONE         -   hemisphere "none" option (default)
    %   HS_LEFT         -   hemisphere "left" option
    %   HS_RIGHT        -   hemisphere "right" option
    %   HS_OPTIONS      -   array of hemisphere options
    %   HS_DEFAULT      -   hemisphere default value (BrainRegion.HS_NONE)
    %
    %   NOTES           -   notes numeric code
    %   NOTES_TAG       -   notes tag
    %   NOTES_FORMAT	-   notes format
    %   NOTES_DEFAULT   -   notes default value ('---')
    %
    % BrainRegion methods:
    %   BrainRegion     -   constructor
    %   disp            -   displays list element < ListElement
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %   toXML           -   creates XML Node from ListElement < ListElement
    %   fromXML         -   loads ListElement from XML Node < ListElement
    %   clear           -   clears list element < ListElement
    %   copy            -   deep copy < matlab.mixin.Copyable
    %
    % BrainRegion methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties 
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also ListElement, List, BrainAtlas, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % few-letter code (unique for each brain region)
        LABEL = 1
        LABEL_TAG = 'label'
        LABEL_FORMAT = BNC.CHAR
        LABEL_DEFAULT = 'BR'
        
        % extended name
        NAME = 2
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'br name'
        
        % x-coordinate
        X = 3
        X_TAG = 'x'
        X_FORMAT = BNC.NUMERIC
        X_DEFAULT = 0
        
        % y-coordinate
        Y = 4
        Y_TAG = 'y'
        Y_FORMAT = BNC.NUMERIC
        Y_DEFAULT = 0
        
        % z-coordinate
        Z = 5
        Z_TAG = 'z'
        Z_FORMAT = BNC.NUMERIC
        Z_DEFAULT = 0
        
        % {BrainRegion.HS_NONE BrainRegion.HS_LEFT BrainRegion.HS_RIGHT} hemisphere
        HS = 6
        HS_TAG = 'hemisphere'
        HS_FORMAT = BNC.OPTIONS
        HS_NONE = 'none'        
        HS_LEFT = 'left'
        HS_RIGHT = 'right'
        HS_OPTIONS = {BrainRegion.HS_NONE BrainRegion.HS_LEFT BrainRegion.HS_RIGHT}
        HS_DEFAULT = BrainRegion.HS_NONE
        
        % notes
        NOTES = 7
        NOTES_TAG = 'notes'
        NOTES_FORMAT = BNC.CHAR
        NOTES_DEFAULT = '---'
        
    end
    methods
        function br = BrainRegion(varargin)
            % BRAINREGION() creates a brain region with default properties
            %
            % BRAINREGION(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     BrainRegion.LABEL     -   char
            %     BrainRegion.NAME      -   char
            %     BrainRegion.X         -   numeric
            %     BrainRegion.Y         -   numeric
            %     BrainRegion.Z         -   numeric
            %     BrainRegion.HS        -   options (BrainRegion.HS_NONE BrainRegion.HS_LEFT, BrainRegion.HS_RIGHT)
            %     BrainRegion.NOTES     -   char
            %
            % See also BrainRegion, ListElement.

            br = br@ListElement(varargin{:});
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of BrainRegion.
            %
            % See also BrainRegion, ListElement.

            N = 7;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of BrainRegion.
            %
            % See also BrainRegion, ListElement.

            tags = {BrainRegion.LABEL_TAG ...
                BrainRegion.NAME_TAG ...
                BrainRegion.X_TAG ...
                BrainRegion.Y_TAG ...
                BrainRegion.Z_TAG ...
                BrainRegion.HS_TAG ...
                BrainRegion.NOTES_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of BrainRegion.
            %
            % See also BrainRegion, ListElement.

            formats = {BrainRegion.LABEL_FORMAT ...
                BrainRegion.NAME_FORMAT ...
                BrainRegion.X_FORMAT ...
                BrainRegion.Y_FORMAT ...
                BrainRegion.Z_FORMAT ...
                BrainRegion.HS_FORMAT ...
                BrainRegion.NOTES_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of BrainRegion.
            %
            % See also BrainRegion, ListElement.

            defaults = {BrainRegion.LABEL_DEFAULT ...
                BrainRegion.NAME_DEFAULT ...
                BrainRegion.X_DEFAULT ...
                BrainRegion.Y_DEFAULT ...
                BrainRegion.Z_DEFAULT ...
                BrainRegion.HS_DEFAULT ...
                BrainRegion.NOTES_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of BrainRegion.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also BrainRegion, ListElement.

            switch prop
                case BrainRegion.HS
                    options = BrainRegion.HS_OPTIONS;
                otherwise
                    options = {};
            end
        end
    end    
end