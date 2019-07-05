classdef List < ListElement
    % List < ListElement (Abstract) : List
    %   List represents a list of indexed elements.
    %   Instances of this class cannot be created. Use one of the subclasses 
    %   (e.g., BrainAtlas).
    %
    % List properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements
    %   path            -   XML file path
    %   file            -   XML file name
    %
    % List methods (Access = protected):
    %   List            -   constructor
    %   copyElement     -   deep copy
    %
    % List methods:
    %   disp            -   displays list 
    %   setProp         -   sets property value < ListElement
    %   getProp         -   gets property value, format and tag < ListElement
    %   getPropValue    -   string of property value < ListElement
    %   getPropFormat	-   string of property format < ListElement
    %   getPropTag      -   string of property tag < ListElement
    %   fullfile        -   builds XML file name 
    %   length          -   list length
    %   get             -   gets element
    %   getProps        -   get a property from all elements of the list 
    %   add             -   adds element
    %   remove          -   removes element 
    %   replace         -   replaces element 
    %   invert          -   inverts two elements
    %   moveto          -   moves element
    %   removeall       -   removes selected elements 
    %   addabove        -   adds empty elements above selected ones
    %   addbelow        -   adds empty elements below selected ones
    %   moveup          -   moves up selected elements 
    %   movedown        -   moves down selected elements
    %   move2top        -   moves selected elements to top
    %   move2bottom     -   moves selected elements to bottom 
    %   toXML           -   creates XML Node from List
    %   fromXML         -   loads List from XML Node
    %   load            -   load
    %   loadfromfile    -   loads List from XML file
    %   save            -   save
    %   savetofile      -   saves a list to XML file  
    %   clear           -   clears list
    %   copy            -   deep copy < matlab.mixin.Copyable
    %   extract         -   extracts a sublist
    %
    % List methods (Abstract, Static):
    %   propnumber      -   number of properties < ListElement
    %   getTags         -   cell array of strings with the tags of the properties < ListElement
    %   getFormats      -   cell array with the formats of the properties < ListElement
    %   getDefaults     -   cell array with the defaults of the properties < ListElement
    %   getOptions      -   cell array with options (only for properties with options format) < ListElement
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % List methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %
    % See also BrainAtlas, ListElement, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Access = protected)
        path  % XML file path
        file  % XML file name
        elements  % cell array of elements
    end
    methods (Access = protected)
        function list = List(elements,varargin)
            % LIST(ELEMENTS) creates a List with default properties.
            %   ELEMENTS is a cell array of elements or an empty cell array.
            %   This method is only accessible by the subclasses of List.
            %
            % LIST(ELEMENTS,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1, Tag2 to Value2, ... .
            %
            % See also List, ListElement.
            
            list = list@ListElement(varargin{:});
            
            for i = 1:1:length(elements)
                Check.isa(['All elements should be of class ' list.elementClass() '.'],elements{i},list.elementClass())
            end
            list.elements = elements;
        end
        function cp = copyElement(list)
            % COPYELEMENT makes a deep copy of the list.
            %
            % CP = COPYELEMENT(List) makes a deep copy of the list.
            %   The path and file are set to '' in the copy.
            %
            % See also List, matlab.mixin.Copyable, copy, handle.
            
            % Make a shallow copy
            cp = copyElement@matlab.mixin.Copyable(list);
            % Make a deep copy
            for i = 1:1:list.length()
                cp.elements{i} = copy(list.elements{i});
            end
            % Clear path and file
            list.path = '';
            list.file = '';            
        end
    end
    methods
        function disp(list)
            % DISP displays list
            %
            % DISP(LIST) displays the list LIST and the properties of its
            %   elements on the command line.
            %
            % See also List.

            list.disp@ListElement();
            disp(list.fullfile());
            disp([int2str(list.length()) ' ' list.elementClass() '''s'])
        end
        function file = fullfile(list)
            % FULLFILE builds XML file name
            %
            % FILE = FULLFILE(LIST) builds a full file name for the
            %   specified list LIST by using its path and file properties.
            %
            % See also List.

            file = BNC.fullfile(list.path,list.file);
        end
        function l = length(list)
            % LENGTH list length
            %
            % L = LENGTH(LIST) gets the number of elements in LIST.
            %
            % See also List.

            l = length(list.elements);
        end
        function el = get(list,i)
            % GET gets an element of the list
            %
            % EL = GET(LIST,I) gets the I-th element of LIST.
            %
            % See also List, ListElement.

            el = list.elements{i};
        end
        function props = getProps(list,prop)
            % GETPROPS gets a property from all elements of the list
            %
            % PROPS = GETPROPS(LIST,PROP) gets the property specified by PROP
            %   from all elements in LIST.
            %   If the property is numeric or logical, it returns a matrix,
            %   otherwise it returns a cell array.
            %
            % See also List, ListElement.

            props = cell(1,list.length());
            for i = 1:1:list.length()
                props{i} = list.get(i).getProp(prop);
            end
            if ~isempty(props)
                if BNC.isNumericFormat(list.get(i).getPropFormat(prop)) || BNC.isLogicalFormat(list.get(i).getPropFormat(prop))
                    props = cell2mat(props);
                end
            end
        end
        function add(list,el,i)
            % ADD adds element
            %
            % ADD(LIST,EL,I) adds an element EL at the I-th position in LIST.
            %   If i<1 or i>LIST.length, it adds the element at the end of LIST.
            %   If EL is empty, it adds a new element initialized to its default value.
            %
            % ADD(LIST,EL) adds EL at the end of LIST.
            %
            % ADD(LIST) adds empty element at the end of LIST.
            %
            % See also List, ListElement.
            
            if nargin<3 || i<=0
                i = list.length()+1;
            end
            
            if nargin<2 || isempty(el)
                el = list.element();
            end
            
            Check.isa(['Element el must be a ' list.elementClass()],el,list.elementClass())
            
            if i<=list.length()
                list.elements(i+1:list.length()+1) = list.elements(i:list.length());
                list.elements{i} = el;
            else
                list.elements{list.length()+1} = el;
            end
        end
        function remove(list,i)
            % REMOVE removes element 
            %
            % REMOVE(LIST,I) removes the element at the I-th position from LIST.
            %
            % See also List, ListElement.

            indices = 1:1:list.length();
            list.elements = list.elements(indices~=i);
        end
        function replace(list,i,el)
            % REPLACE replaces element 
            %
            % REPLACE(LIST,I,EL) replaces the element at the I-th position
            %   in LIST with the element EL.
            %
            % See also List, ListElement.
            
            Check.isa(['Element el must be a ' list.elementClass()],el,list.elementClass())
            
            if i>0 && i<=list.length()
                list.elements{i} = el;
            end
        end
        function invert(list,i,j)
            % INVERT inverts two elements 
            %
            % INVERT(LIST,I,J) inverts the positions of the elements at 
            %   I-th and and J-th position in LIST.
            %
            % See also List, ListElement.

            if i>0 && i<=list.length() && j>0 && j<=list.length && i~=j
                eli = list.get(i);
                elj = list.get(j);
                list.replace(i,elj);
                list.replace(j,eli);
            end
        end
        function moveto(list,i,j)
            % MOVETO moves element
            %
            % MOVETO(LIST,I,J) moves the element at the I-th position to
            % the J-th position in LIST.
            %
            % See also List, ListElement.
            
            if i>0 && i<=list.length() && j>0 && j<=list.length && i~=j
                el = list.get(i);
                if i>j
                    list.remove(i);
                    list.add(el,j);
                else % i<j
                    list.add(el,j+1);
                    list.remove(i);
                end
            end
        end
        function selected = removeall(list,selected)
            % REMOVEALL removes selected elements
            %
            % SELECTED = REMOVEALL(LIST,SELECTED) removes all elements whose 
            %   positions in LIST are included in the array SELECTED. 
            %   It returns an empty array.
            %
            % See also List, ListElement.

            for i = numel(selected):-1:1
                list.remove(selected(i));
            end
            selected = [];
        end
        function [selected,added] = addabove(list,selected)
            % ADDABOVE adds empty elements above selected ones
            %
            % [SELECTED,ADDED] = ADDABOVE(LIST,SELECTED) adds empty 
            %   elements above the elements whose positions in the list 
            %   LIST are included in SELECTED. 
            %   It returns the final positions of the SELECTED elements 
            %   and the positions ADDED of the empty elements added.
            %
            % See also List, ListElement.

            for i = numel(selected):-1:1
                list.add({},selected(i));
            end
            selected = selected+reshape(1:1:numel(selected),size(selected));
            added = selected-1;
        end
        function [selected,added] = addbelow(list,selected)
            % ADDBELOW adds empty elements below selected ones
            %
            % [SELECTED,ADDED] = ADDBELOW(LIST,SELECTED) adds empty 
            %   elements below the elements whose positions in the list 
            %   LIST are included in SELECTED. 
            %   It returns the final positions of the SELECTED elements 
            %   and also the positions ADDED of the empty elements added.
            %
            % See also List, ListElement.

            for i = numel(selected):-1:1
                list.add({},selected(i)+1);
            end
            selected = selected+reshape(0:1:numel(selected)-1,size(selected));
            added = selected+1;
        end
        function selected = moveup(list,selected)
            % MOVEUP moves up selected elements
            %
            % SELECTED = MOVEUP(LIST,SELECTED) moves up by one position
            %   all elements whose positions in LIST are included
            %   in the SELECTED array and returns their final positions.
            %
            % See also List, ListElement.

            if ~isempty(selected)

                firstindex2process = 1;
                unprocessablelength = 1;
                while firstindex2process<=list.length() && firstindex2process<=numel(selected) && selected(firstindex2process)==unprocessablelength
                    firstindex2process = firstindex2process+1;
                    unprocessablelength = unprocessablelength+1;
                end

                for i = firstindex2process:1:numel(selected)
                    list.invert(selected(i),selected(i)-1);
                    selected(i) = selected(i)-1;
                end
            end
        end
        function selected = movedown(list,selected)
            % MOVEDOWN moves down selected elements
            %
            % SELECTED = MOVEDOWN(LIST,SELECTED) moves down by one position
            %   all elements whose positions in LIST are included
            %   in the SELECTED array and returns their final positions.
            %
            % See also List, ListElement.

            if ~isempty(selected)

                lastindex2process = numel(selected);
                unprocessablelength = list.length();
                while lastindex2process>0 && selected(lastindex2process)==unprocessablelength
                    lastindex2process = lastindex2process-1;
                    unprocessablelength = unprocessablelength-1;
                end

                for i = lastindex2process:-1:1
                    list.invert(selected(i),selected(i)+1);
                    selected(i) = selected(i)+1;
                end
            end
        end
        function selected = move2top(list,selected)
            % MOVE2TOP moves selected elements to top
            %
            % SELECTED = MOVE2TOP(LIST,SELECTED) moves to top all elements 
            %   whose positions in the list LIST are included in the  
            %   SELECTED array and returns their final positions.
            %
            % See also List, ListElement.

            if ~isempty(selected)
                for i = 1:1:numel(selected)
                    list.moveto(selected(i),i);
                end
                selected = reshape(1:1:numel(selected),size(selected));
            end
        end
        function selected = move2bottom(list,selected)
            % MOVE2BOTTOM moves selected elements to bottom
            %
            % SELECTED = MOVE2BOTTOM(LIST,SELECTED) moves to bottm all  
            %   elements whose positions in the list LIST are included   
            %   in the SELECTED array and returns their final positions.
            %
            % See also List, ListElement.

            if ~isempty(selected)
                for i = numel(selected):-1:1
                    list.moveto(selected(i),list.length()-(numel(selected)-i));
                end
                selected = reshape(list.length()-numel(selected)+1:1:list.length(),size(selected));
            end
        end
        function [ListNode,Document,RootNode] = toXML(list,Document,RootNode)
            % toXML creates XML Node from List
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(LIST,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the list.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also List, ListElement, xmlwrite.
            
            if nargin<2
                Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            end

            if nargin<3
                RootNode = Document.getDocumentElement;
            end

            ListNode = list.toXML@ListElement(Document,RootNode);
            
            for i = 1:1:list.length()
                list.elements{i}.toXML(Document,ListNode);
            end
            
        end
        function fromXML(list,ListNode)
            % fromXML loads List from XML Node
            %
            % FROMXML(LIST,LISTNODE) loads the properties of list LIST,
            %   from the attributes of LISTNODE 
            %   attributes.
            %
            % See also List, ListElement, xmlread.
            
            list.fromXML@ListElement(ListNode);
            
            ElementsNodes = ListNode.getChildNodes;
            ElementsNodes = List.cleanXML(ElementsNodes);
            for i = 0:1:ElementsNodes.getLength-1
                ElementNode = ElementsNodes.item(i);
                el = list.element();
                if strcmp(ElementNode.getNodeName,class(el))
                    el.fromXML(ElementNode)
                    list.add(el)
                end
            end
            
        end
        function success = load(list,varargin)
            % LOAD load
            %
            % success = LOAD(LIST,VARARGIN) returns true if a list is 
            %   created and initialized from a XML node. 
            %
            % LOAD(LIST,'PropertyName',PropertyValue) sets the list 
            %   property PropertyName to PropertyValue.
            %   Admissible properties are:
            %       path    -   XML file path
            %       file    -   XML file name
            %
            % See also List, xmlread.
            
            success = false;
            
            % identify file
            pathtmp = list.path;
            filetmp = list.file;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'path')
                    pathtmp = varargin{n+1};
                end
                if strcmpi(varargin{n},'file')
                    filetmp = varargin{n+1};
                end
            end
            
            if BNC.fileExists(BNC.fullfile(pathtmp,filetmp))
                
                % clear list
                list.clear()
                
                % load file
                Document = xmlread(BNC.fullfile(pathtmp,filetmp));
                RootNode = Document.getDocumentElement;
                RootNode = List.cleanXML(RootNode);

                % parsing BrainAtlas node
                for i = 0:1:RootNode.getChildNodes.getLength-1
                    tmpNode = RootNode.getChildNodes.item(i);
                    if strcmpi(tmpNode.getNodeName,class(list))
                        ListNode = tmpNode;
                    end
                end
                
                list.fromXML(ListNode);
                list.path = pathtmp;
                list.file = filetmp;
                
                success = true;
            end
        end
        function success = loadfromfile(list,msg)
            % LOADFROMFILE loads List from XML file
            %
            % success = LOADFROMFILE(LIST,MSG) creates and initializes a list
            %   LIST by loading a XML file.
            %   It returns true if a list is successfully created.
            %
            % See also List, xmlread.
            
            if nargin<2
                msg = BNC.XML_MSG_GETFILE;
            end
            
            % select file
            [filetmp,pathtmp,filterindex] = uigetfile(BNC.XML_EXTENSION,msg);

            % load file
            success = false;
            if filterindex
                success = list.load('path',pathtmp,'file',filetmp);
            end
        end
        function save(list,varargin)
            % SAVE save
            %
            % SAVE(LIST,VARARGIN) saves a list to a XML specified by a 
            %   path and file name.
            %
            % SAVE(LIST,'PropertyName',PropertyValue) sets the list 
            %   property PropertyName to PropertyValue.
            %   Admissible properties are:
            %       path    -   XML file path
            %       file    -   XML file name
            %
            % See also List, xmlwrite.
            
            % generate XML
            [~,Document] = list.toXML();
            
            % identify file
            pathtmp = list.path;
            filetmp = list.file;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'path')
                    pathtmp = varargin{n+1};
                end
                if strcmpi(varargin{n},'file')
                    filetmp = varargin{n+1};
                end
            end
            
            if BNC.dirExists(pathtmp)
                % save file
                xmlwrite(BNC.fullfile(pathtmp,filetmp),Document);
                list.path = pathtmp;
                list.file = filetmp;
            end
        end
        function savetofile(list,msg)
            % SAVETOFILE saves a list to XML file 
            %
            % SAVETOFILE(LIST,MSG) saves a list LIST to XML file.
            %
            % See also List, xmlwrite.
            
            if nargin<2
                msg = BNC.XML_MSG_PUTFILE;
            end
            
            % select file
            [filetmp,pathtmp,filterindex] = uiputfile(BNC.XML_EXTENSION,msg);

            % save file
            if filterindex
                list.save('path',pathtmp,'file',filetmp);
            end
        end
        function clear(list)
            % CLEAR clears list
            %
            % CLEAR(LIST) sets the values of all properties of the list LIST
            %   to their default values and eliminates all list elements.
            %
            % See also List, ListElement.

            list.clear@ListElement()
            list.path = '';
            list.file = '';
            list.elements = {};
        end
        function slist = extract(list,i_vec)
            % EXTRACT extracts sublist
            %
            % SLIST = EXTRACT(LIST,I) extracts the sublist containign onli
            %   elements I. I can be a vector.
            %
            % See also List, ListElement.
            
            slist = list.copy();
            slist.removeall(setdiff(1:1:list.length(),i_vec));
        end
    end
    methods (Abstract, Static)
        class = elementClass()  % element class name
        le = element()  % get new empty element
    end
end