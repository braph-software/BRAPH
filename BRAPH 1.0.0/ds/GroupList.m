classdef GroupList < List
    % GroupList < List (Abstract) : Group List
    %   GroupList represents a list of groups.
    %   Instances of this class cannot be created.
    %
    % GroupList properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %
    % GroupList methods:
    %   GroupList           -   constructor
    %   disp                -   displays group list
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   fullfile            -   builds XML file name < List
    %   length              -   list length < List
    %   get                 -   gets element < List
    %   getProps            -   get a property from all elements of the list < List
    %   add                 -   adds element < List
    %   remove              -   removes element < List
    %   replace             -   replaces element < List 
    %   invert              -   inverts two elements < List
    %   moveto              -   moves element < List
    %   removeall           -   removes selected elements < List
    %   addabove            -   adds empty elements above selected ones < List
    %   addbelow            -   adds empty elements below selected ones < List
    %   moveup              -   moves up selected elements < List
    %   movedown            -   moves down selected elements < List
    %   move2top            -   moves selected elements to top < List
    %   move2bottom         -   moves selected elements to bottom < List 
    %   toXML               -   creates XML Node from List < List
    %   fromXML             -   loads List from XML Node < List
    %   load                -   load < List
    %   loadfromfile        -   loads List from XML file < List
    %   save                -   save < List
    %   savetofile          -   saves a list to XML file < List
    %   clear               -   clears list < List
    %   extract             -   extracts sublist
    %
    % GroupList methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %   elementClass    -   element class name
    %   element         -   creates new empty group
    %
    % See also Group, List, ListElement.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function grs = GroupList(groups,varargin)
            % GroupList(GROUPS) creates a group list with default
            % properties and groups GROUPS
            %
            % GRS =  GroupList(GROUPS,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %
            % See also GroupList, List, Group.
            
            if nargin==0 || isempty(groups)
                groups = {};
            end
            
            grs = grs@List(groups,varargin{:});
        end
        function disp(grs)
            % DISP displays group list
            %
            % DISP(GRS) displays the group list GRS and the properties of its
            %   group's on the command line.
            %
            % See also GroupList, Group.
            
            grs.disp@List()
        end
        function sgrs = extract(grs,i_vec,j_vec)
            % EXTRACT extracts sublist
            %
            % SLIST = EXTRACT(LIST,I) extracts the sublist containign onli
            %   elements I. I can be a vector.
            %
            % See also List, ListElement.
            
            sgrs = grs.extract@List(i_vec);
            for g = 1:1:sgrs.length()
                data = sgrs.get(g).getProp(Group.DATA);
                sgrs.get(g).setProp(Group.DATA,data(j_vec));
            end
        end
    end
	methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of GroupList.
            %
            % See also GroupList.
            
            N = 0;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of GroupList.
            %
            % See also GroupList, Group.
            
            tags = {};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of GroupList.
            %
            % See also GroupList, Group.
            
            formats = {};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of GroupList.
            %
            % See also GroupList, Group.
            
            defaults = {};
        end
        function options = getOptions(~)  % (i)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of GroupList.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also GroupList, Group.
            
            options = {};
        end
        function class = elementClass()
            % ELEMENTCLASS element class
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'Group'.
            %
            % See also GroupList, Group.
            
            class = 'Group';
        end
        function gr = element()
            % ELEMENT creates new empty group
            %
            % GR = ELEMENT() returns an empty group GR.
            %
            % See also GroupList, Group.
            
            gr = Group();
        end
    end
end