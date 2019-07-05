classdef ListElement < handle & matlab.mixin.Copyable
    % ListElement < handle & matlab.mixin.Copyable (Abstract) : Element of a list
    %   ListElement represents an element of a List.
    %   Instances of this class cannot be created. Use one of the subclasses 
    %   (e.g., BrainRegion).
    %
    % ListElement properties (Access = protected): 
    %   props           -   cell array of object properties 
    %
    %   props is a cell array containing the object properties to be
    %   defined in each child class accordign to the format:
    %       props{prop}.tag
    %       props{prop}.format  % { BNC.CHAR BNC.LOGICAL BNC.NUMERIC BNC.OPTIONS }
    %       props{prop}.value
    %       props{prop}.options  % only for options format
    %            
    % ListElement methods (Access = protected):
    %   ListElement     -   constructor
    %
    % ListElement methods:
    %   disp            -   displays list element 
    %   setProp         -   sets property value
    %   getProp         -   gets property value, format and tag
    %   getPropValue    -   string of property value 
    %   getPropFormat	-   string of property format
    %   getPropTag      -   string of property tag 
    %   toXML           -   creates XML Node from ListElement
    %   fromXML         -   loads ListElement from XML Node
    %   clear           -   clears list element
    %   copy            -   deep copy < matlab.mixin.Copyable
    %
    % ListElement methods (Abstract, Static):
    %   propnumber      -   number of properties 
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % ListElement methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread  
    %
    % See also BrainRegion, List, xmlread, xmlwrite, handle, matlab.mixin.Copyable.

    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Access = protected)
        % props is a cell array containing the object properties 
        % props{prop}.tag
        % props{prop}.format  % { BNC.CHAR BNC.LOGICAL BNC.NUMERIC BNC.OPTIONS }
        % props{prop}.value
        % props{prop}.options  % only for options format
        props
    end
    methods (Access = protected)
        function le = ListElement(varargin)
            % LISTELEMENT() creates an element of a list with default properties.
            %   This method is only accessible by the subclasses of ListElement.
            %
            % LISTELEMENT(Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %
            % See also ListElement.
            
            tags = le.getTags();
            formats = le.getFormats();
            defaults = le.getDefaults();
            
            for prop = 1:1:length(tags)
                % tag
                tag = tags{prop};
                le.props{prop}.tag = tag;
            
                % format
                format = formats{prop};
                le.props{prop}.format = format;
                
                % default
                default = defaults{prop};
                
                % value
                switch format
                    case BNC.CHAR
                        le.props{prop}.value = default;
                    case BNC.LOGICAL
                        le.props{prop}.value = default;
                    case BNC.NUMERIC
                        le.props{prop}.value = default;
                    case BNC.OPTIONS
                        options = le.getOptions(prop);
                        le.props{prop}.options = options;
                        le.props{prop}.value = default;
                    otherwise
                        error('Format (%i) not valid.',format)
                end
                for n = 1:2:length(varargin)
                    if varargin{n}==prop
                        le.setProp(prop,varargin{n+1});
                    end
                end
            end
            
        end
    end
    methods
        function disp(le)
            % DISP displays list element
            %
            % DISP(LE) displays the list element LE and its properties
            %   on the command line.
            %
            % See also ListElement.

            disp(['<a href="matlab:help ' class(le) '">' class(le) '</a>']);
            for prop = 1:1:le.propnumber()
                disp([le.getPropTag(prop) ' (' le.getPropFormat(prop) ') = ' le.getPropValue(prop) ])
            end
        end
        function setProp(le,prop,value)
            % SETPROP sets property value
            %
            % SETPROP(LE,PROP,VALUE) sets the value of the property PROP
            %   of the list element LE as VALUE.
            %
            % See also ListElement.

            format = le.getPropFormat(prop);
            
            if BNC.isCharFormat(format)
                le.props{prop}.value = BNC.toCharFormat(value);
            elseif BNC.isLogicalFormat(format)
                le.props{prop}.value = BNC.toLogicalFormat(value);
            elseif BNC.isNumericFormat(format)
                le.props{prop}.value = BNC.toNumericFormat(value);
            elseif BNC.isOptionFormat(format)
                le.props{prop}.value = BNC.toOptionFormat(value,le.props{prop}.options);
            end            
        end
        function [value,format,tag] = getProp(le,prop)
            % GETPROP gets property value, format and tag
            %
            % [VALUE,FORMAT,TAG] = GETPROP(LE,PROP) gets the VALUE, FORMAT
            %   and TAG fields of propery PROP of the list element LE.
            %
            % See also ListElement.

            value = le.props{prop}.value;
            format = le.props{prop}.format;
            tag = le.props{prop}.tag;
        end
        function txt = getPropValue(le,prop)
            % GETPROPVALUE string of property value 
            %
            % TXT = GETPROPVALUE(LE,PROP) gets the string TXT associated to 
            %   the value of propery PROP of the list element LE.
            %
            % See also ListElement.

            value = le.props{prop}.value;
            if isnumeric(value) && size(value,1)>1
                txt = mat2str(le.props{prop}.value);
            else
                txt = num2str(le.props{prop}.value);
            end
        end
        function txt = getPropFormat(le,prop)
            % GETPROPFORMAT string of property format
            %
            % TXT = GETPROPFORMAT(LE,PROP) gets the string TXT associated 
            %   to the propery PROP of the list element LE.
            %
            % See also ListElement.

            txt = le.props{prop}.format;
        end
        function txt = getPropTag(le,prop)
            % GETPROPTAG string of property tag
            %
            % TXT = GETPROPTAG(LE,PROP) gets the string TXT associated
            %   to the propery PROP of the list element LE.
            %
            % See also ListElement.

            txt = le.props{prop}.tag;
        end
        function ElementNode = toXML(le,Document,RootNode)
            % tOXML creates XML Node from ListElement
            %
            % ELEMENTNODE = TOXML(LE,DOCUMENT,ROOTNODE) appends to ROOTNODE
            %   of DOCUMENT a new node (ELEMENTNODE) representing the list element LE.
            % 
            % The XML Document can be created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also ListElement, xmlwrite.
            
            ElementNode = Document.createElement(class(le));
            RootNode.appendChild(ElementNode);

            for prop = 1:1:le.propnumber()
                ElementNode.setAttribute(le.getPropTag(prop),le.getPropValue(prop))
            end

        end
        function fromXML(le,ElementNode)
            % fromXML loads ListElement from XML Node
            %
            % FROMXML(LE,ELEMENTNODE) loads the properties of the list element
            %   LE from the attributes of ELEMENTNODE. 
            %
            % See also ListElement, xmlread.
            
            if ~strcmp(ElementNode.getNodeName,class(le))
                error(['The XML node (' char(ElementNode.getNodeName) ') is not the same as the class of the list element (' class(le) ').'])
            end
            
            attributes = ElementNode.getAttributes;
            for prop = 1:1:le.propnumber()
                for j = 0:1:attributes.getLength-1
                    if strcmp(char(attributes.item(j).getName),le.getPropTag(prop))
                        le.setProp(prop,attributes.item(j).getValue)
                    end
                end
            end
            
        end
        function clear(le)
            % CLEAR clears list element
            %
            % CLEAR(LE) sets the values of all properties of the list element LE 
            %   to their default values.
            %
            % See also ListElement.

            defaults = le.getDefaults();
            
            for prop = 1:1:le.propnumber()
                switch le.getPropFormat(prop)
                    case BNC.CHAR
                        le.setProp(prop,defaults{prop});
                    case BNC.LOGICAL
                        le.setProp(prop,defaults{prop});
                    case BNC.NUMERIC
                        le.setProp(prop,defaults{prop});
                    case BNC.OPTIONS
                        options = le.getOptions(prop);
                        le.setProp(prop,defaults{prop});
                    otherwise
                        error('Format (%i) not valid.',format)
                end
            end
        end
    end
    methods (Abstract, Static)
        N = propnumber()  % number of properties
        tags = getTags()  % cell array of strings with the tags of the properties
        formats = getFormats()  % cell array with the formats of the properties
        defaults = getDefaults()  % cell array with the defaults of the properties
        options = getOptions(prop)  % cell array with options (only for props with options format)
    end    
    methods (Static)
        function Node = cleanXML(Node)
            % CLEANXML removes whitespace nodes from xmlread
            %
            % NODE = CLEANXML(NODE) removes the whitespace-only text nodes from XML document.
            %   It is needed when loading XML nodes with xmlread.
            %
            % See also ListElement, xmlread.
            
            for x = 1:1:Node.getLength
                Child = Node.item(x-1);
                if(isa(Child,'org.apache.xerces.dom.DeferredTextImpl'))
                    Node.removeChild(Child);  % removes element
                    ListElement.cleanXML(Node); % length is no longer valid => recurse
                    break;
                % else  % code to clean all children (slows doen the program a lot)
                %     BNC.cleanXML(Child);
                end
            end
        end
    end
end