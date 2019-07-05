classdef fMRICohort < ListWithGroups
    % fMRICohort < ListWithGroups : cohort of fMRI
    %   fMRICohort represents a cohort of subjects with fMRI data.
    %
    % fMRICohort properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   atlas           -   brain atlas
    %
    % fMRICohort properties:
    %   grs             -   group list < ListWithGroups
    %
    % fMRICohort properties (Constants):
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
    % fMRICohort methods:
    %   fMRICohort          -   constructor
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
    %   element             -   creates new fMRI subject
    %   getBrainAtlas       -   returns atlas of cohort
    %   getPlotBrainSurf    -   generates PlotBrainSurf
    %   getPlotBrainAtlas   -   generates PlotBrainAtlas
    %   getPlotBrainGraph   -   generates PlotBrainGraph
    %   getSubjectData      -   returns data of subjects
    %   loadfromxls         -   loads fMRI cohort from XLS file
    %   loadfrommat         -   loads fMRI cohort from MAT file
    %   toXML               -   creates XML Node from fMRICohort
    %   fromXML             -   loads fMRICohort from XML Node
    %   clear               -   clears fMRICohort
    %   extract             -   extracts subcommunity cohort of certain subjects
    %
    % fMRICohort methods (Access = protected):
    %   copyElement         -   copy cohort and its elements
    %
    % fMRICohort methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   fMRICohort cell array with options (only for properties with options format)  
    %
    % See also ListWithGroups, BrainAtlas.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % cohort name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'fMRI Cohort'
        
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
        function cohort = fMRICohort(atlas,subjects,varargin)
            % FMRICOHORT(ATLAS,SUBJECTS) creates a fMRI cohort with default
            %   properties using the atlas ATLAS and subjects SUBJECTS.
            %
            % FMRICOHORT(ATLAS,SUBJECTS,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRICohort.NAME      -   char
            %     fMRICohort.T         -   numeric
            %
            % See also fMRICohort,  ListWithGroups, BrainAtlas.
            
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
            % See also fMRICohort, fMRISubject.
            
            cohort.disp@ListWithGroups()
            cohort.atlas.disp@ListElement()
            disp(' >> SUBJECTS << ')
            for i = 1:1:cohort.length()
                sub = cohort.get(i);
                disp([sub.getPropValue(fMRISubject.CODE) ...
                    ' ' sub.getPropValue(fMRISubject.AGE) ...
                    ' ' sub.getPropValue(fMRISubject.GENDER) ...
                    ' ' int2str(size(sub.getProp(fMRISubject.DATA),1)) ' x ' int2str(size(sub.getProp(fMRISubject.DATA),2)) ...
                    ' ' sub.getPropValue(fMRISubject.NOTES) ...
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
            %   i.e., the string 'fMRISubject'.
            %
            % See also fMRICohort, fMRISubject.
            
            class = 'fMRISubject';
        end
        function sub = element(cohort)
            % ELEMENT creates new empty fMRI subject
            %
            % SUB = ELEMENT(COHORT) returns an empty fMRI subject SUB of cohort COHORT.
            %
            % See also fMRICohort, fMRISubject, BrainAtlas.
            
            sub = fMRISubject();
        end
        function atlas = getBrainAtlas(cohort)
            % GETBRAINATLAS returns atlas of cohort
            %
            % ATLAS = GETBRAINATLAS(COHORT) returns the atlas used for initializing 
            %   the fMRI cohort.
            %
            % See also fMRICohort, BrainAtlas.
            
            atlas = cohort.atlas;
        end
        function bs = getPlotBrainSurf(cohort)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(COHORT) generates a new PlotBrainSurf.
            %
            % See also fMRICohort, PlotBrainSurf.
            
            bs = cohort.getBrainAtlas().getPlotBrainSurf();
        end
        function ba = getPlotBrainAtlas(cohort)
            % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(COHORT) generates a new PlotBrainAtlas.
            %
            % See also fMRICohort, PlotBrainAtlas.
            
            ba = cohort.getBrainAtlas().getPlotBrainAtlas();
        end
        function bg = getPlotBrainGraph(cohort)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(GA) generates a new PlotBrainSurf.
            %
            % See also fMRICohort, PlotBrainSurf.
            
            bg = cohort.getBrainAtlas().getPlotBrainGraph();
        end
        function data = getSubjectData(cohort,g)
            % GETSUBJECTDATA returns data of subjects
            %
            % DATA = GETSUBJECTDATA(COHORT,G) returns the data of the subjects
            %   belonging to a group G of cohort COHORT as DATA.
            %
            % See also fMRICohort.
            
            indices = find(cohort.getGroup(g).getProp(Group.DATA)==true);
            for j = 1:1:length(indices)
                data{1,j} = cohort.get(indices(j)).getProp(fMRISubject.DATA);
            end
        end
        function success = loadfromxls(cohort,msg) 
            % LOADFROMXLS loads fMRI cohort from XLS file
            %
            % SUCCESS = LOADFROMXLS(COHORT,MSG) creates and initializes a
            %   fMRI cohort by loading XLS files ('*.xlsx' or '*.xls') of a folder.
            %   It returns true if the fMRI cohort is successfully created.
            %
            % See also fMRICohort, uigetfile, fopen.
            
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
                sub = fMRISubject( ...
                    fMRISubject.CODE,files(i).name, ...
                    fMRISubject.DATA,cell2mat(raw));
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
            % LOADFROMMAT loads fMRI cohort from MAT file
            %
            % SUCCESS = LOADFROMMAT(COHORT,MSG) creates and initializes a
            %   fMRI cohort by loading MAT files ('*.mat)' of a folder.
            %   It returns true if the fMRI cohort is successfully created.
            %
            % See also fMRICohort, uigetfile, fopen.
            
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

                sub = fMRISubject( ...
                    fMRISubject.CODE,files(i).name, ...
                    fMRISubject.DATA,data);
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
            %   representing the fMRICohort.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also fMRICohort, ListWithGroups, List, xmlwrite.
            
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
            % FROMXML(COHORT,LISTNODE) loads the properties of fMRICohort COHORT,
            %   from the attributes of LISTNODE.
            %   
            % See also fMRICohort, ListWithGroups, List, xmlread.
            
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
            %   fMRICohort COHORT to their default values and eliminates 
            %   all list elements.
            %
            % See also fMRICohort, ListWithGroups, List.
            
            cohort.clear@ListWithGroups()
        end        
        function scohort = extract(cohort,brs,subs)
            % EXTRACT extracts subcommunity cohort of certain subjects
            %
            % SCOHORT = EXTRACT(COHORT,BRS,SUBS) makes a copy SCOHORT of cohort COHORT
            %   that include all elements BRS of the subjects SUBS.
            %
            % See also fMRICohort.

            if nargin<3
                subs = [1:1:cohort.length()];
            end
            
            % extracts subjects
            scohort = cohort.extract@ListWithGroups(subs);
            
            % extracts brain regions
            scohort.atlas = scohort.getBrainAtlas().extract(brs);
            for j = 1:1:scohort.length()
                data = scohort.get(j).getProp(fMRISubject.DATA);
                scohort.get(j).setProp(fMRISubject.DATA,data(:,brs));
            end
        end
    end
    methods (Access = protected)
        % COPYELEMENT copies elements of cohort
        %
        % CP = COPYELEMENT(COHORT) copies elements of the cohort COHORT.
        %   Makes a deep copy also of the atlas of the cohort.
        %
        % See also fMRICohort, handle, matlab.mixin.Copyable.

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
            % N = PROPNUMBER() gets the total number of properties of fMRICohort.
            %
            % See also fMRICohort.

            N = 2;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRICohort.
            %
            % See also fMRICohort, ListElement.
            
            tags = {fMRICohort.NAME_TAG ...
                fMRICohort.T_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRICohort.
            %
            % See also fMRICohort, ListElement.

            formats = {fMRICohort.NAME_FORMAT ...
                fMRICohort.T_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRICohort.
            %
            % See also fMRICohort, ListElement.

            defaults = {fMRICohort.NAME_DEFAULT ...
                fMRICohort.T_DEFAULT};
        end
        function options = getOptions(~)  % (prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRICohort.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRICohort, ListElement.
            
            options = {};
        end
    end
end