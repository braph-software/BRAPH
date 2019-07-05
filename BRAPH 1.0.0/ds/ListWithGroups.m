classdef ListWithGroups < List
    % ListWithGroups < List (Abstract) : List of elements within groups
    %   ListWithGroups represents a list of elements and list of groups to which they belong.
    %   Instances of this class cannot be created. Use one of the subclasses 
    %   (e.g., MRICohort).
    %
    % ListWithGroups properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %
    % ListWithGroups properties:
    %   grs             -   group list
    %
    % ListWithGroups methods (Access = protected):
    %   ListWithGroups      -   constructor
    %   copyElement         -   copy ListWithGroups and its elements
    %
    % ListWithGroups methods:
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   fullfile            -   builds XML file name < List  
    %   length              -   list length < List
    %   getProps            -   get a property from all elements of the list < List
    %   removeall           -   removes selected elements < List
    %   addabove            -   adds empty elements above selected ones < List
    %   addbelow        	-   adds empty elements below selected ones < List
    %   moveup              -   moves up selected elements < List 
    %   movedown            -   moves down selected elements < List
    %   move2top            -   moves selected elements to top < List
    %   move2bottom         -   moves selected elements to bottom < List 
    %   load                -   load < List
    %   loadfromfile        -   loads List from XML file < List
    %   save                -   save < List
    %   savetofile          -   saves a list to XML file < List
    %   disp                -   displays list with groups
    %   get                 -   gets element of the list and groups to which it belongs
    %   groupnumber         -   returns number of groups
    %   checkgroup          -   checks size of group member data
    %   getGroup            -   returns group tags, values and formats 
    %   getGroupData        -   returns group data
    %   add                 -   adds list element
    %   remove              -   removes list element 
    %   replace             -   replaces list element 
    %   invert              -   inverts two list elements
    %   moveto              -   moves list element
    %   addgroup            -   adds group
    %   addgroupsabove      -   adds empty group above selected ones
    %   addgroupsbelow      -   adds empty group below selected ones
    %   removegroup         -   removes group
    %   removeallgroups     -   removes selected groups
    %   movegroupsup        -   moves up selected groups
    %   movegroupsdown      -   moves down selected groups
    %   movegroups2top      -   moves selected groups to top
    %   movegroups2bottom   -   moves selected groups to bottom
    %   replacegroup        -   replaces group
    %   invertgroups        -   inverts two groups
    %   movetogroup         -   moves group
    %   addtogroup          -   adds selected list elements to selected group
    %   removefromgroup     -   removes selected list elements from selected group
    %   notgroup            -   complementary group
    %   andgroup            -   intersection (AND) of two groups
    %   orgroup             -   union (OR) of two groups
    %   nandgroup           -   intersection (NAND) of two groups
    %   xorgroup            -   intersection (XOR) of two groups
    %   toXML               -   creates XML Node from ListWithGroups
    %   fromXML             -   loads ListWithGroups from XML Node
    %   clear               -   clears ListWithGroups
    %
    % ListWithGroups methods (Abstract, Static):
    %   propnumber      -   number of properties < ListElement
    %   getTags         -   cell array of strings with the tags of the properties < ListElement
    %   getFormats      -   cell array with the formats of the properties < ListElement
    %   getDefaults     -   cell array with the defaults of the properties < ListElement
    %   getOptions      -   MRICohortcell array with options (only for properties with options format) < ListElement
    %   elementClass    -   element class name < List
    %   element         -   creates new empty element < List
    %
    % ListWithGroups methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %
    % See also ListWithGroups, List, GroupList.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Access = protected)
        grs  % group list (GroupList)
    end
    methods (Access = protected)
        function lg = ListWithGroups(elements,varargin)
            % LISTWITHGROUPS(ELEMENTS) creates a List with default properties.
            %   ELEMENTS is a cell array of elements or an empty cell array.
            %   This method is only accessible by the subclasses of ListWithGroups.
            %
            % LISTWITHGROUPS(ELEMENTS,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1, Tag2 to Value2, ... .
            %
            % See also ListWithGroups, List, ListElement.
            
            lg = lg@List(elements,varargin{:});
            
            lg.grs = GroupList();
        end
        function cp = copyElement(lg)
            % COPYELEMENT copy List of Groups and its elements
            %
            % COPYELEMENT(LG) copies the list with groups LG and its elements.
            %
            % See also ListWithGroups.

            % Make a shallow copy
            cp = copyElement@List(lg);
            % Make a deep copy
            cp.grs = copy(lg.grs);
        end
    end
    methods
        function disp(lg)
            % DISP displays list with groups
            %
            % DISP(LG) displays the list with groups LG and the properties 
            %   of its elements and groups on the command line.
            %
            % See also ListWithGroups.
            
            lg.disp@List();
            lg.grs.disp();
        end
        function [el,groups] = get(lg,i) 
            % GET gets element of the list and groups to which it belongs 
            %
            % [EL,GROUPS] = DISP(LG,I) returns EL, an element at position I in
            %    the list with groups LG and groups to which it belongs,
            %    GROUPS.
            %
            % See also ListWithGroups.
            
            el = lg.get@List(i);
            
            groups = [];
            for g = 1:1:lg.groupnumber()
                gr = lg.grs.get(g);
                groupdata = gr.getProp(Group.DATA);
                if groupdata(i)
                    groups = [groups g];
                end
            end
        end
        function n = groupnumber(lg)
            % GROUPNUMBER returns number of groups
            %
            % N = GROUPNUMBER(LG) returns number of groups N, in list with groups LG.
            % 
            % See also ListWithGroups.
            
            n = lg.grs.length();
        end
        function checkgroup(lg,gr)  
            % CHECKGROUP checks size of group member data
            %
            % CHECKGROUP(LG,GR) checks size of the member data of group GR in 
            %   list with groups LG. It gives error if the size is not equal to the number
            %   of list elements.
            %
            % See also ListWithGroups.
            
            if length(gr.getProp(Group.DATA))~=lg.length()
                error('The size of the group member data (%i) should be the same as the number of list elements (%i).',length(gr.getProp(Group.DATA)),lg.length())
            end
        end
        function gr = getGroup(lg,g)
            % GETGROUP returns group tags, values and formats 
            %
            % GR = GETGROUP(LG,G) returns GR, the group at position G in list
            %   with groups LG.
            %
            % See also ListWithGroups.
            
            gr = lg.grs.get(g);
        end
        function groupdata = getGroupData(lg,g)
            % GETGROUPDATA returns group data
            %
            % GETGROUPDATA(LG,G) returns data of group G in list with groups LG.
            % 
            % See also ListWithGroups.
            
            groupdata = lg.getGroup(g).getProp(Group.DATA);
        end
        function add(lg,le,i,groups)
            % ADD adds list element
            %
            % ADD(LG,LE,I,GROUPS) adds list element LE to position I and groups GROUPS
            %   in list with groups LG.
            % 
            % See also ListWithGroups.
            
            if nargin<4
                groups = [];
            end
            
            if nargin<3 || isempty(i) || i<0
                i = lg.length()+1;
            end
            
            if nargin<2
                le = [];
            end
            
            lg.add@List(le,i)
            l = lg.length();
            
            for g = 1:1:lg.groupnumber()
                gr = lg.grs.get(g);
                groupdata = gr.getProp(Group.DATA);
                if i<l
                    groupdata(i+1:l) = groupdata(i:l-1);
                end
                if any(groups==g)
                    groupdata(i) = true;
                else
                    groupdata(i) = false;
                end
                gr.setProp(Group.DATA,groupdata)
            end
            
        end
        function remove(lg,i)
            % REMOVE removes list element
            %
            % REMOVE(LG,I) removes list element in position I in list with groups LG.   
            % 
            % See also ListWithGroups.
            
            lg.remove@List(i)
            
            indices = 1:1:lg.length()+1;
            for g = 1:1:lg.groupnumber()
                gr = lg.grs.get(g);
                groupdata = gr.getProp(Group.DATA);
                groupdata = groupdata(indices~=i);
                gr.setProp(Group.DATA,groupdata)
            end
        end
        function replace(lg,i,el,groups)
            % REPLACE replaces list element
            %
            % REPLACE(LG,I,EL,GROUPS) replaces list element in position I with EL and
            %   assigns it to groups GROUPS in list with groups LG.
            % 
            % See also ListWithGroups.
            
             if nargin<4
                groups = [];
             end
             
             lg.replace@List(i,el)
             
             if i>0 && i<=lg.length()
                 for g = 1:1:lg.groupnumber()
                     gr = lg.grs.get(g);
                     groupdata = gr.getProp(Group.DATA);
                     if any(groups==g)
                         groupdata(i) = true;
                     else
                         groupdata(i) = false;
                     end
                     gr.setProp(Group.DATA,groupdata)
                 end
             end
        end
        function invert(lg,i,j)
            % INVERT inverts two list elements
            %
            % INVERT(LG,I,J) inverts list elements in positions I and J in list with groups LG. 
            %
            % See also ListWithGroups.
            
            if i>0 && i<=lg.length() && j>0 && j<=lg.length && i~=j
                [eli,groupsi] = lg.get(i);
                [elj,groupsj] = lg.get(j);
                lg.replace(i,elj,groupsj);
                lg.replace(j,eli,groupsi);
            end
        end
        function moveto(lg,i,j)
            % MOVETO moves list element
            %
            % MOVETO(LG,I,J) moves list element I to position J in list with groups LG.
            %
            % See also ListWithGroups.
            
            if i>0 && i<=lg.length() && j>0 && j<=lg.length && i~=j
                [el,groups] = lg.get(i);
                if i>j
                    lg.remove(i);
                    lg.add(el,j,groups);
                else % i<j
                    lg.add(el,j+1,groups);
                    lg.remove(i);
                end
            end
        end
        function addgroup(lg,gr,i)
            % ADDGROUP adds group
            %
            % ADDGROUP(LG,GR,I) adds group GR to position I in list with groups LG. 
            %
            % See also ListWithGroups.
                        
            if nargin<3
                i = lg.groupnumber()+1;
            end
            
            if nargin<2
                gr = Group(Group.DATA,zeros(1,lg.length()));
            end
            
            lg.checkgroup(gr)
            lg.grs.add(gr,i)
        end
        function [selected,added] = addgroupsabove(lg,selected)
            % ADDGROUPSABOVE adds empty group above selected ones
            %
            % SELECTED = ADDGROUPSABOVE(LG,SELECTED) adds empty group above 
            %   SELECTED positions in list with groups LG. 
            %
            % See also ListWithGroups.
            
            [selected,added] = lg.grs.addabove(selected);
            for i = added
                lg.grs.replace(i,Group(Group.DATA,zeros(1,lg.length())))
            end
        end
        function [selected,added] = addgroupsbelow(lg,selected)
            % ADDGROUPSBELOW adds empty group below selected ones
            %
            % SELECTED = ADDGROUPSBELOW(LG,SELECTED) adds empty group below 
            %   SELECTED positions in list with groups LG. 
            %
            % See also ListWithGroups.
            
            [selected,added] = lg.grs.addbelow(selected);
            for i = added
                lg.grs.replace(i,Group(Group.DATA,zeros(1,lg.length())))
            end
        end
        function removegroup(lg,i)
            % REMOVEGROUP removes group
            %
            % REMOVEGROUP(LG,I) removes group in position I in list with groups LG. 
            %
            % See also ListWithGroups.
            
            lg.grs.remove(i)
        end
        function selected = removeallgroups(lg,selected)
            % REMOVEALLGROUPS removes selected groups
            %
            % SELECTED = REMOVEALLGROUPS(LG,SELECTED) removes selected groups
            %   SELECTED in list with groups LG.
            %   It returns an empty array.
            %
            % See also ListWithGroups.
            
            selected = lg.grs.removeall(selected);
        end
        function selected = movegroupsup(lg,selected)
            % MOVEGROUPSUP moves up selected groups
            %
            % SELECTED = MOVEGROUPSUP(LG,SELECTED) moves one position up the selected groups
            %   SELECTED in list with groups LG and returns their final positions in 
            %   the array SELECTED. 
            %
            % See also ListWithGroups.
            
            selected = lg.grs.moveup(selected);            
        end
        function selected = movegroupsdown(lg,selected)
            % MOVESGROUPSDOWN moves up selected groups
            %
            % SELECTED = MOVESGROUPSDOWN(LG,SELECTED) moves one position down the selected groups
            %   SELECTED in list with groups LG and returns their final positions in 
            %   the array SELECTED. 
            %
            % See also ListWithGroups.
            
            selected = lg.grs.movedown(selected);
        end
        function selected = movegroups2top(lg,selected)
            % MOVEGROUP2TOP moves selected groups to top
            %
            % SELECTED = MOVEGROUP2TOP(LG,SELECTED) moves the selected groups SELECTED
            %   in list with groups LG to top and returns their final positions in 
            %   the array SELECTED.
            %
            % See also ListWithGroups.
            
            selected = lg.grs.move2top(selected);
        end
        function selected = movegroups2bottom(lg,selected)
            % MOVEGROUPS2BOTTOM moves selected groups to bottom
            %
            % SELECTED = MOVEGROUPS2BOTTOM(LG,SELECTED) moves the selected groups SELECTED
            %   in list with groups LG to bottom and returns their final positions in 
            %   the array SELECTED.
            %
            % See also ListWithGroups.
            
            selected = lg.grs.move2bottom(selected);
        end
        function replacegroup(lg,i,gr)
            % REPLACEGROUP replaces group
            %
            % REPLACEGROUP(LG,I,GR) replaces group in position I in list with groups LG 
            %   with group GR. 
            % 
            % See also ListWithGroups.
            
            lg.checkgroup(gr)
            lg.grs.replace(i,gr)            
        end
        function invertgroups(lg,i,j)
            % INVERT inverts two groups
            %
            % INVERT(LG,I,J) inverts two groups at positions I and J in list with groups LG. 
            %
            % See also ListWithGroups.
            
            lg.grs.invert(i,j)            
        end
        function movetogroup(lg,i,j)
            % MOVETOGROUP moves group
            %
            % MOVETOGROUP(LG,I,J) moves group at position I to position J in list with groups LG.
            %
            % See also ListWithGroups, List.
            
            lg.grs.moveto(i,j)            
        end
        function addtogroup(lg,g,indices) 
            % ADDTOGROUP adds selected list elements to selected group
            %
            % ADDTOGROUP(LG,G,INDICES) adds list elements INDICES to group at position G of
            %   list with groups LG.
            %
            % See also ListWithGroups, List.
            
            if g>0 && g<=lg.groupnumber()
                indices = indices(indices>0 & indices<=lg.length());
                gr = lg.grs.get(g);
                groupdata = gr.getProp(Group.DATA);
                groupdata(indices) = true;
                gr.setProp(Group.DATA,groupdata)
            end
        end
        function removefromgroup(lg,g,indices)
            % REMOVEFROMGROUP removes selected list elements from selected group
            %
            % REMOVEFROMGROUP(LG,G,INDICES) removes list elements INDICES from 
            %   group at position G in list with groups LG.
            %
            % See also ListWithGroups, List.
            
            if g>0 && g<=lg.groupnumber()
                indices = indices(indices>0 & indices<=lg.length());
                gr = lg.grs.get(g);
                groupdata = gr.getProp(Group.DATA);
                groupdata(indices) = false;
                gr.setProp(Group.DATA,groupdata)
            end
        end
        function notgroup(lg,g,gname,gnotes)
            % NOTGROUP complementary group
            %
            % NOTGROUP(LG,G) returns complementary (NOT) of group G in list with groups LG
            %   with default name and note.
            %
            % NOTGROUP(LG,G,GNAME,GNOTES) returns complementary (NOT) of group G of 
            %   list with groups LG with GNAME and GNOTES assigned as its
            %   name and note respectively.
            %
            % See also ListWithGroups, andgroup, orgroup, nandgroup, xorgroup.
            
            if g>0 && g<=lg.groupnumber()
                
                gr = lg.grs.get(g);
                
                if nargin<4
                    gnotes = ['Complementary of ' gr.getProp(Group.NOTES)];
                end
                
                if nargin<3
                    gname = ['Complementary of ' gr.getProp(Group.NAME)];
                end
                
                grnot = Group(Group.NAME,gname, ...
                    Group.DATA,not(gr.getProp(Group.DATA)), ...
                    Group.NOTES,gnotes);
                lg.addgroup(grnot,g+1)
            end
        end
        function andgroup(lg,g1,g2,gname,gnotes)
            % ANDGROUP intersection (AND) of two groups
            %
            % ANDGROUP(LG,G1,G2) returns intersection (AND) of groups G1 and G2 
            %   in list with groups LG with default name and note.
            %
            % ANDGROUP(LG,G1,G2,GNAME,GNOTES) returns intersection (AND) of 
            %   groups G1 and G2 in list with groups LG with GNAME and GNOTES 
            %   assigned as its name and note respectively.
            %
            % See also ListWithGroups, notgroup, orgroup, nandgroup, xorgroup.
            
            if g1>0 && g1<=lg.groupnumber() && g2>0 && g2<=lg.groupnumber()
                
                gr1 = lg.grs.get(g1);
                gr2 = lg.grs.get(g2);
                
                if nargin<5
                    gnotes = ['Intersection (AND) of ' gr1.getProp(Group.NOTES) ' & ' gr2.getProp(Group.NOTES)];
                end
                
                if nargin<4
                    gname = ['Intersection (AND) of ' gr1.getProp(Group.NAME) ' & ' gr2.getProp(Group.NAME)];
                end
                
                grand = Group(Group.NAME,gname, ...
                    Group.DATA,and(gr1.getProp(Group.DATA),gr2.getProp(Group.DATA)), ...
                    Group.NOTES,gnotes);
                lg.addgroup(grand)
            end
        end
        function orgroup(lg,g1,g2,gname,gnotes)
            % ORGROUP union (OR) of two groups
            %
            % ORGROUP(LG,G1,G2) returns  union (OR) of of groups G1 and G2 
            %   in list with groups LG with default name and note.
            %
            % ORGROUP(LG,G1,G2,GNAME,GNOTES) returns  union (OR) of groups
            %   G1 and G2 in list with groups LG with GNAME and GNOTES 
            %   assigned as its name and note respectively.
            %
            % See also ListWithGroups, notgroup, andgroup, nandgroup, xorgroup.
            
            if g1>0 && g1<=lg.groupnumber() && g2>0 && g2<=lg.groupnumber()
                
                gr1 = lg.grs.get(g1);
                gr2 = lg.grs.get(g2);
                
                if nargin<5
                    gnotes = ['Union (OR) of ' gr1.getProp(Group.NOTES) ' & ' gr2.getProp(Group.NOTES)];
                end
                
                if nargin<4
                    gname = ['Union (OR) of ' gr1.getProp(Group.NAME) ' & ' gr2.getProp(Group.NAME)];
                end
                
                gror = Group(Group.NAME,gname, ...
                    Group.DATA,or(gr1.getProp(Group.DATA),gr2.getProp(Group.DATA)), ...
                    Group.NOTES,gnotes);
                lg.addgroup(gror)
            end
        end
        function nandgroup(lg,g1,g2,gname,gnotes)
            % NANDGROUP intersection (NAND) of two groups
            %
            % NANDGROUP(LG,G1,G2) returns  intersection (NAND) of of groups G1 and G2 
            %   in list with groups LG with default name and note.
            %
            % NANDGROUP(LG,G1,G2,GNAME,GNOTES) returns  intersection (NAND) of groups
            %   G1 and G2 in list with groups LG with GNAME and GNOTES 
            %   assigned as its name and note respectively.
            %
            % See also ListWithGroups, notgroup, andgroup, orgroup, xorgroup.
            
            if g1>0 && g1<=lg.groupnumber() && g2>0 && g2<=lg.groupnumber()
                
                gr1 = lg.grs.get(g1);
                gr2 = lg.grs.get(g2);
                
                if nargin<5
                    gnotes = ['Intersection (NAND) of ' gr1.getProp(Group.NOTES) ' & ' gr2.getProp(Group.NOTES)];
                end
                
                if nargin<4
                    gname = ['Intersection (NAND) of ' gr1.getProp(Group.NAME) ' & ' gr2.getProp(Group.NAME)];
                end
                
                grnand = Group(Group.NAME,gname, ...
                    Group.DATA,~and(gr1.getProp(Group.DATA),gr2.getProp(Group.DATA)), ...
                    Group.NOTES,gnotes);
                lg.addgroup(grnand)
            end
        end
        function xorgroup(lg,g1,g2,gname,gnotes)
            % XORGROUP intersection (XOR) of two groups
            %
            % XORGROUP(LG,G1,G2) returns  intersection (XOR) of of groups G1 and G2 
            %   in list with groups LG with default name and note.
            %
            % XORGROUP(LG,G1,G2,GNAME,GNOTES) returns  intersection (XOR) of groups
            %   G1 and G2 in list with groups LG with GNAME and GNOTES 
            %   assigned as its name and note respectively.
            %
            % See also ListWithGroups, notgroup, andgroup, orgroup, nandgroup.
            
            if g1>0 && g1<=lg.groupnumber() && g2>0 && g2<=lg.groupnumber()
                
                gr1 = lg.grs.get(g1);
                gr2 = lg.grs.get(g2);
                
                if nargin<5
                    gnotes = ['Intersection (XOR) of ' gr1.getProp(Group.NOTES) ' & ' gr2.getProp(Group.NOTES)];
                end
                
                if nargin<4
                    gname = ['Intersection (XOR) of ' gr1.getProp(Group.NAME) ' & ' gr2.getProp(Group.NAME)];
                end
                
                grxor = Group(Group.NAME,gname, ...
                    Group.DATA,xor(gr1.getProp(Group.DATA),gr2.getProp(Group.DATA)), ...
                    Group.NOTES,gnotes);
                lg.addgroup(grxor)
            end
        end
        function [ListNode,Document,RootNode] = toXML(lg,Document,RootNode)
            % TOXML creates XML Node from ListWithGroups
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(LG,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the ListWithGroups.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also ListWithGroups, List, xmlwrite.
            
            if nargin<3
                [ListNode,Document,RootNode] = lg.toXML@List();
            elseif nargin<2
                [ListNode,Document,RootNode] = lg.toXML@List(Document);
            else
                [ListNode,Document,RootNode] = lg.toXML@List(Document,RootNode);
            end

            lg.grs.toXML(Document,ListNode);
            
        end
        function fromXML(lg,ListNode)
            % FROMXML loads ListWithGroups from XML Node
            %
            % FROMXML(LG,LISTNODE) loads the properties of ListWithGroups LG,
            %   from the attributes of LISTNODE.
            %   
            % See also ListWithGroups, List, xmlread.
            
            lg.fromXML@List(ListNode)
            
            ChildrenNodes = ListNode.getChildNodes;
            ChildrenNodes = lg.cleanXML(ChildrenNodes);
            for i = 0:1:ChildrenNodes.getLength-1
                ChildNode = ChildrenNodes.item(i);
                if strcmp(ChildNode.getNodeName,class(lg.grs))
                    lg.grs.fromXML(ChildNode);
                end
            end
            
        end
        function clear(lg)
            % CLEAR clears ListWithGroups
            %
            % CLEAR(LG) sets the values of all properties of the 
            %   ListWithGroups LG to their default values and eliminates 
            %   all list elements.
            %
            % See also ListWithGroups, List.
            
            lg.grs.clear();
            lg.clear@List()
        end        
    end
end