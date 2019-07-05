classdef EEGCohort < ListWithGroups
    % EEGCohort < ListWithGroups : cohort of EEG
    %   EEGCohort represents a cohort of subjects with EEG data.
    %
    % EEGCohort properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   atlas           -   brain atlas
    %
    % EEGCohort properties:
    %   grs             -   group list < ListWithGroups
    %
    % EEGCohort properties (Constants):
    %   NAME                -   name numeric code
    %   NAME_TAG            -   name tag
    %   NAME_FORMAT         -   name format
    %   NAME_DEFAULT        -   name default value
    %
    %   T                   -   time numeric code
    %   T_TAG               -   time tag
    %   T_FORMAT            -   time format
    %   T_DEFAULT           -   time default value
    %
    % EEGCohort methods:
    %   EEGCohort           -   constructor
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
    %   get                 -   gets element < ListWithGroups
    %   groupnumber         -   returns number of groups < ListWithGroups
    %   checkgroup          -   checks size of group member data < ListWithGroups
    %   getGroup            -   returns group tags, values and formats < ListWithGroups 
    %   getGroupData        -   returns group data < ListWithGroups
    %   add                 -   adds element < ListWithGroups
    %   remove              -   removes element < ListWithGroups
    %   replace             -   replaces element < ListWithGroups
    %   invert              -   inverts two elements < ListWithGroups
    %   moveto              -   moves element < ListWithGroups
    %   addgroup            -   adds group < ListWithGroups
    %   addgroupsabove      -   adds empty group above selected ones < ListWithGroups
    %   addgroupsbelow      -   adds empty group below selected ones < ListWithGroups
    %   removegroup         -   removes group < ListWithGroups
    %   removeallgroups     -   removes selected group < ListWithGroups
    %   movegroupsup        -   moves up selected group < ListWithGroups
    %   movegroupsdown      -   moves down selected group < ListWithGroups
    %   movegroups2top      -   moves selected groups to top < ListWithGroups
    %   movegroups2bottom   -   moves selected groups to bottom < ListWithGroups
    %   replacegroup        -   replaces groups < ListWithGroups
    %   invertgroups        -   inverts two groups < ListWithGroups
    %   movetogroup         -   moves group < ListWithGroups
    %   addtogroup          -   adds selected subjects to selected group < ListWithGroups
    %   removefromgroup     -   removes selected subjects from selected group < ListWithGroups
    %   notgroup            -   complementary group < ListWithGroups
    %   andgroup            -   intersection (AND) of two groups < ListWithGroups
    %   orgroup             -   union (OR) of two groups < ListWithGroups
    %   nandgroup           -   intersection (NAND) of two groups < ListWithGroups
    %   xorgroup            -   intersection (XOR) of two groups < ListWithGroups
    %   disp                -   displays cohort
    %   elementClass        -   element class name
    %   element             -   creates new EEG subject
    %   getBrainAtlas       -   returns atlas of cohort
    %   getPlotBrainSurf    -   generates PlotBrainSurf
    %   getPlotBrainAtlas   -   generates PlotBrainAtlas
    %   getPlotBrainGraph   -   generates PlotBrainGraph
    %   getSubjectData      -   returns data of subjects
    %   loadfromxls         -   loads EEG cohort from XLS file
    %   loadfrommat         -   loads EEG cohort from MAT file
    %   toXML               -   creates XML Node from EEGCohort
    %   fromXML             -   loads EEGCohort from XML Node
    %   clear               -   clears EEGCohort
    %   extract             -   extracts subcommunity cohort of certain subjects
    %
    % EEGCohort methods (Access = protected):
    %   copyElement         -   copy cohort and its elements
    %
    % EEGCohort methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   EEGCohort cell array with options (only for properties with options format)  
    %
    % See also ListWithGroups, BrainAtlas.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % cohort name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'EEG Cohort'
        
        % repetition time
        T = 2
        T_TAG = 'repetition_time'
        T_FORMAT = BNC.NUMERIC
        T_DEFAULT = 1
        
    end
    properties (Access = protected)
        atlas  % brain atlas (BrainAtlas)
    end
    methods
        function cohort = EEGCohort(atlas,subjects,varargin)
            % EEGCOHORT(ATLAS,SUBJECTS) creates a EEG cohort with default
            %   properties using the atlas ATLAS and subjects SUBJECTS.
            %
            % EEGCOHORT(ATLAS,SUBJECTS,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     EEGCohort.NAME      -   char
            %     EEGCohort.T         -   numeric
            %
            % See also EEGCohort,  ListWithGroups, BrainAtlas.
            
            Check.isa('The variable atlas must be a BrainAtlas',atlas,'BrainAtlas')
            
            if nargin==1 || isempty(subjects)
                subjects = {};
            end
            
            cohort = cohort@ListWithGroups(subjects,varargin{:});
            
            cohort.atlas = atlas;
        end
        function disp(cohort)
            % DISP displays cohort
            %
            % DISP(COHORT) displays cohort COHORT and the properties of its subjects 
            %   and groups on the command line.
            %
            % See also EEGCohort, EEGSubject.
            
            cohort.disp@ListWithGroups()
            cohort.atlas.disp@ListElement()
            disp(' >> SUBJECTS << ')
            for i = 1:1:cohort.length()
                sub = cohort.get(i);
                disp([sub.getPropValue(EEGSubject.CODE) ...
                    ' ' sub.getPropValue(EEGSubject.AGE) ...
                    ' ' sub.getPropValue(EEGSubject.GENDER) ...
                    ' ' int2str(size(sub.getProp(EEGSubject.DATA),1)) ' x ' int2str(size(sub.getProp(EEGSubject.DATA),2)) ...
                    ' ' sub.getPropValue(EEGSubject.NOTES) ...
                    ])
            end
            disp(' >> GROUPS << ')
            for i = 1:1:cohort.groupnumber()
                gr = cohort.grs.get(i);
                disp([gr.getPropValue(Group.NAME) ...
                    ' ' gr.getPropValue(Group.DATA) ...
                    ' ' gr.getPropValue(Group.NOTES) ...
                    ])
            end
        end        
        function class = elementClass(~)  % (cohort)
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'EEGSubject'.
            %
            % See also EEGCohort, EEGSubject.
            
            class = 'EEGSubject';
        end
        function sub = element(cohort)
            % ELEMENT creates new empty EEG subject
            %
            % SUB = ELEMENT(COHORT) returns an empty EEG subject SUB of cohort COHORT.
            %
            % See also EEGCohort, EEGSubject, BrainAtlas.
            
            sub = EEGSubject();
        end
        function atlas = getBrainAtlas(cohort)
            % GETBRAINATLAS returns atlas of cohort
            %
            % ATLAS = GETBRAINATLAS(COHORT) returns the atlas used for initializing 
            %   the EEG cohort.
            %
            % See also EEGCohort, BrainAtlas.
            
            atlas = cohort.atlas;
        end
        function bs = getPlotBrainSurf(cohort)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(COHORT) generates a new PlotBrainSurf.
            %
            % See also EEGCohort, PlotBrainSurf.
            
            bs = cohort.getBrainAtlas().getPlotBrainSurf();
        end
        function ba = getPlotBrainAtlas(cohort)
            % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(COHORT) generates a new PlotBrainAtlas.
            %
            % See also EEGCohort, PlotBrainAtlas.
            
            ba = cohort.getBrainAtlas().getPlotBrainAtlas();
        end
        function bg = getPlotBrainGraph(cohort)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(GA) generates a new PlotBrainSurf.
            %
            % See also EEGCohort, PlotBrainSurf.
            
            bg = cohort.getBrainAtlas().getPlotBrainGraph();
        end
        function data = getSubjectData(cohort,g)
            % GETSUBJECTDATA returns data of subjects
            %
            % DATA = GETSUBJECTDATA(COHORT,G) returns the data of the subjects
            %   belonging to a group G of cohort COHORT as DATA.
            %
            % See also EEGCohort.
            
            indices = find(cohort.getGroup(g).getProp(Group.DATA)==true);
            for j = 1:1:length(indices)
                data{1,j} = cohort.get(indices(j)).getProp(EEGSubject.DATA);
            end
        end
        function success = loadfromxls(cohort,msg) 
            % LOADFROMXLS loads EEG cohort from XLS file
            %
            % SUCCESS = LOADFROMXLS(COHORT,MSG) creates and initializes a
            %   EEG cohort by loading XLS files ('*.xlsx' or '*.xls') of a folder.
            %   It returns true if the EEG cohort is successfully created.
            %
            % See also EEGCohort, uigetfile, fopen.
            
            success = false;
            
            if nargin<2
                msg = BNC.MSG_GETDIR;
            end
            
            % select directory
            directory = uigetdir(cd,msg);
            
             % select xls or xlsx files
            files = dir(fullfile(directory,'*.xlsx'));
            files2 = dir(fullfile(directory,'*.xls'));
            len = length(files);
            for i =1:1:length(files2)
                files(len+i,1) = files2(i,1);
            end
            
            % load subjects
             cohort.clear();
            for i = 1:1:length(files)
                [~,~,raw] = xlsread(fullfile(directory,files(i).name));
                %sdata{i} = raw;
                sub = EEGSubject( ...
                    EEGSubject.CODE,files(i).name, ...
                    EEGSubject.DATA,cell2mat(raw));
                cohort.add(sub)
            end
            
            if i==length(files)
                [~,groupname] = fileparts(directory);                
                cohort.addgroup( ...
                    Group(Group.NAME,groupname, ...
                    Group.DATA,true(1,cohort.length())) ...
                    )

                success = true;
            end
        end
        function success = loadfrommat(cohort,msg)
            % LOADFROMMAT loads EEG cohort from MAT file
            %
            % SUCCESS = LOADFROMMAT(COHORT,MSG) creates and initializes a
            %   EEG cohort by loading MAT files ('*.mat)' of a folder.
            %   It returns true if the EEG cohort is successfully created.
            %
            % See also EEGCohort, uigetfile, fopen.
            
            success = false;
            
            if nargin<2
                msg = BNC.MSG_GETDIR;
            end
            
            % select directory
            directory = uigetdir(cd,msg);
                        
            % select mat files
            files = dir(fullfile(directory,'*.mat'));
            % load subjects
            cohort.clear();
            for i = 1:1:length(files)
                varnames = whos('-file',fullfile(directory,files(i).name));
                varvalues = load(fullfile(directory,files(i).name));
                
                if length(varnames)==1  
                    % New data format
                    % One matrix 
                    
                    eval(['data = varvalues.' varnames(1).name ';'])
                    
                elseif length(varnames)==cohort.getBrainAtlas().length()
                    % Old data format
                    % One variable (column vector) per region

                    eval(['tmp = varvalues.' varnames(1).name ';'])
                    
                    data = zeros(length(tmp),cohort.getBrainAtlas().length());
                    for j = 1:1:length(varnames)
                        eval(['data(:,j) = varvalues.' varnames(j).name ';'])
                    end
                    
                end

                sub = EEGSubject( ...
                    EEGSubject.CODE,files(i).name, ...
                    EEGSubject.DATA,data);
                cohort.add(sub)
            end
            if i==length(files)
                [~,groupname] = fileparts(directory);
                cohort.addgroup( ...
                    Group(Group.NAME,groupname, ...
                    Group.DATA,true(1,cohort.length())) ...
                    )

                success = true;
            end
            
        end
        function savetotxt(cohort,msg)  %% TBI
        end            
        function success = loadfromtxt(cohort,msg)  %% TBI
        end
        function [ListNode,Document,RootNode] = toXML(cohort,Document,RootNode)
            % TOXML creates XML Node from MRICohort
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(COHORT,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the EEGCohort.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also EEGCohort, ListWithGroups, List, xmlwrite.
            
            if nargin<3
                [ListNode,Document,RootNode] = cohort.toXML@ListWithGroups();
            elseif nargin<2
                [ListNode,Document,RootNode] = cohort.toXML@ListWithGroups(Document);
            else
                [ListNode,Document,RootNode] = cohort.toXML@ListWithGroups(Document,RootNode);
            end

            cohort.atlas.toXML(Document,ListNode);
            
        end
        function fromXML(cohort,ListNode)
            % FROMXML loads MRICohort from XML Node
            %
            % FROMXML(COHORT,LISTNODE) loads the properties of EEGCohort COHORT,
            %   from the attributes of LISTNODE.
            %   
            % See also EEGCohort, ListWithGroups, List, xmlread.
            
            cohort.fromXML@ListWithGroups(ListNode)
            
            ChildrenNodes = ListNode.getChildNodes;
            ChildrenNodes = cohort.cleanXML(ChildrenNodes);
            for i = 0:1:ChildrenNodes.getLength-1
                ChildNode = ChildrenNodes.item(i);
                if strcmp(ChildNode.getNodeName,class(cohort.atlas))
                    cohort.atlas.fromXML(ChildNode);
                end
            end
            
        end
        function clear(cohort)  % cohort.atlas.clear();  % atlas not cleared
            % CLEAR clears MRICohort
            %
            % CLEAR(COHORT) sets the values of all properties of the 
            %   EEGCohort COHORT to their default values and eliminates 
            %   all list elements.
            %
            % See also EEGCohort, ListWithGroups, List.
            
            cohort.clear@ListWithGroups()
        end        
        function scohort = extract(cohort,brs,subs)
            % EXTRACT extracts subcommunity cohort of certain subjects
            %
            % SCOHORT = EXTRACT(COHORT,BRS,SUBS) makes a copy SCOHORT of cohort COHORT
            %   that include all elements BRS of the subjects SUBS.
            %
            % See also EEGCohort.

            if nargin<3
                subs = [1:1:cohort.length()];
            end
            
            % extracts subjects
            scohort = cohort.extract@ListWithGroups(subs);
            
            % extracts brain regions
            scohort.atlas = scohort.getBrainAtlas().extract(brs);
            for j = 1:1:scohort.length()
                data = scohort.get(j).getProp(EEGSubject.DATA);
                scohort.get(j).setProp(EEGSubject.DATA,data(:,brs));
            end
        end
    end
    methods (Access = protected)
        % COPYELEMENT copies elements of cohort
        %
        % CP = COPYELEMENT(COHORT) copies elements of the cohort COHORT.
        %   Makes a deep copy also of the atlas of the cohort.
        %
        % See also EEGCohort, handle, matlab.mixin.Copyable.

        function cp = copyElement(cohort)
            
            % Make a shallow copy
            cp = copyElement@ListWithGroups(cohort);
            % Make a deep copy
            cp.atlas = copy(cohort.atlas);
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of EEGCohort.
            %
            % See also EEGCohort.

            N = 2;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of EEGCohort.
            %
            % See also EEGCohort, ListElement.
            
            tags = {EEGCohort.NAME_TAG ...
                EEGCohort.T_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of EEGCohort.
            %
            % See also EEGCohort, ListElement.

            formats = {EEGCohort.NAME_FORMAT ...
                EEGCohort.T_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of EEGCohort.
            %
            % See also EEGCohort, ListElement.

            defaults = {EEGCohort.NAME_DEFAULT ...
                EEGCohort.T_DEFAULT};
        end
        function options = getOptions(~)  % (prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of EEGCohort.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also EEGCohort, ListElement.
            
            options = {};
        end
    end
end