classdef MRICohort < ListWithGroups
    % MRICohort < ListWithGroups : cohort of MRI
    %   MRICohort represents a cohort of subjects with MRI data.
    %
    % MRICohort properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   atlas           -   brain atlas
    %
    % MRICohort properties:
    %   grs             -   group list < ListWithGroups
    %
    % MRICohort properties (Constants):
    %   NAME                -   name numeric code
    %   NAME_TAG            -   name tag
    %   NAME_FORMAT         -   name format
    %   NAME_DEFAULT        -   name default value
    %
    % MRICohort methods:
    %   MRICohort           -   constructor
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
    %   element             -   creates new MRI subject
    %   getBrainAtlas       -   returns atlas of cohort
    %   getPlotBrainSurf    -   generates PlotBrainSurf
    %   getPlotBrainAtlas   -   generates PlotBrainAtlas
    %   getSubjectData      -   returns data of subjects
    %   mean                -   mean of data of subjects
    %   std                 -   standard deviation of data of subjects
    %   comparison          -   compares two selected groups
    %   loadfromxls         -   loads MRI cohort from XLS file
    %   savetotxt           -   saves a MRI cohort to TXT file
    %   loadfromtxt         -   loads MRI cohort from TXT file
    %   toXML               -   creates XML Node from MRICohort
    %   fromXML             -   loads MRICohort from XML Node
    %   clear               -   clears MRICohort
    %   copy                -   deep copy < matlab.mixin.Copyable
    %   extract             -   extracts subcommunity cohort of certain subjects
    %
    % MRICohort methods (Access = protected):
    %   copyElement     -   copy cohort and its elements
    %
    % MRICohort methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   MRICohortcell array with options (only for properties with options format)  
    %
    % See also ListWithGroups, BrainAtlas.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % cohort name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'MRI Cohort'
        
    end
    properties (Access = protected)
        atlas  % brain atlas (BrainAtlas)
    end
    methods
        function cohort = MRICohort(atlas,subjects,varargin)
            % MRICOHORT(ATLAS,SUBJECTS) creates a MRI cohort with default
            %   properties using the atlas ATLAS and subjects SUBJECTS.
            %
            % MRICOHORT(ATLAS,SUBJECTS,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRICohort.NAME      -   char
            %
            % See also MRICohort,  ListWithGroups, BrainAtlas.
            
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
            % See also MRICohort, MRISubject.
            
            cohort.disp@ListWithGroups()
            cohort.atlas.disp@ListElement()
            disp(' >> SUBJECTS << ')
            for i = 1:1:cohort.length()
                sub = cohort.get(i);
                disp([sub.getPropValue(MRISubject.CODE) ...
                    ' ' sub.getPropValue(MRISubject.AGE) ...
                    ' ' sub.getPropValue(MRISubject.GENDER) ...
                    ' ' sub.getPropValue(MRISubject.DATA) ...
                    ' ' sub.getPropValue(MRISubject.NOTES) ...
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
            %   i.e., the string 'MRISubject'.
            %
            % See also MRICohort, MRISubject.
            
            class = 'MRISubject';
        end
        function sub = element(cohort)
            % ELEMENT creates new empty MRI subject
            %
            % SUB = ELEMENT(COHORT) returns an empty MRI subject SUB of cohort COHORT.
            %
            % See also MRICohort, MRISubject, BrainAtlas.
            
            sub = MRISubject();
        end
        function atlas = getBrainAtlas(cohort)
            % GETBRAINATLAS returns atlas of cohort
            %
            % ATLAS = GETBRAINATLAS(COHORT) returns the atlas used for initializing 
            %   the MRI cohort.
            %
            % See also MRICohort, BrainAtlas.
            
            atlas = cohort.atlas;
        end
        function bs = getPlotBrainSurf(cohort)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(COHORT) generates a new PlotBrainSurf.
            %
            % See also MRICohort, PlotBrainSurf.
            
            bs = cohort.getBrainAtlas().getPlotBrainSurf();
        end
        function ba = getPlotBrainAtlas(cohort)
            % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(COHORT) generates a new PlotBrainAtlas.
            %
            % See also MRICohort, PlotBrainAtlas.
            
            ba = cohort.getBrainAtlas().getPlotBrainAtlas();
        end
        function data = getSubjectData(cohort,g)
            % GETSUBJECTDATA returns data of subjects
            %
            % DATA = GETSUBJECTDATA(COHORT,G) returns the data of the subjects
            %   belonging to a group G of cohort COHORT as DATA.
            %
            % See also MRICohort.
            
            indices = find(cohort.getGroup(g).getProp(Group.DATA)==true);
            data = zeros(length(indices),cohort.getBrainAtlas().length);
            for j = 1:1:length(indices)
                data(j,:) = cohort.get(indices(j)).getProp(MRISubject.DATA);
            end
        end
        function m = mean(cohort,g)
            % MEAN mean of data of subjects
            %
            % M = MEAN(COHORT,G) returns the mean M of the data of subjects of
            %   group G of cohort COHORT.
            %
            % See also MRICohort.

            m = mean(cohort.getSubjectData(g),1);
        end
        function s = std(cohort,g)
            % STD standard deviation of data of subjects
            %
            % S = STD(COHORT,G) returns the standard deviation S of data of
            %    subjects of group G of cohort COHORT.
            %
            % See also MRICohort.
            
            s = std(cohort.getSubjectData(g),1);
        end
        function [dm,p_single,p_double,m1,m2,s1,s2,all1,all2,dall] = comparison(cohort,g1,g2,M,varargin)
            % COMPARISON compares two selected groups
            %
            % [DM,P_SINGLE,P_DOUBLE,M1,M2,S1,S2,ALL1,ALL2,DALL] = COMPARISON(COHORT,G1,G2,M) compares
            %   the groups G1 and G2 of cohort COHORT by performing the
            %   permutation test with M number of permutations.
            %   The default value for M is 1000 permutations.
            %
            %   The outputs of the function are the following:
            %       DM          -   difference of the sample means of the data of two groups
            %       P_SINGLE    -   one tailed p-value of the difference of the sample means 
            %       P_DOUBLE    -   two tailed p-value of the difference of the sample means
            %       M1          -   sample mean of the data of G1
            %       M2          -   sample mean of the data of G2
            %       S1          -   standard deviation of the data of G1
            %       S2          -   standard deviation of the data of G2
            %       ALL1        -   sample mean of the data of all permutations in G1
            %       ALL2        -   sample mean of the data of all permutations in G2
            %       DALL        -   difference of ALL2 and ALL1
            %
            % [DM,P_SINGLE,P_DOUBLE,M1,M2,S1,S2,ALL1,ALL2,DALL] = COMPARISON(COHORT,G1,G2,Tag1,Value1
            %   ,Tag2,Value2,...) initializes property Tag1 to Value1, Tag2 to Value2, ... .
            %   Admissible properties are:
            %       verbose    -   print the progress of the permutation test on the command line
            %                      'false' (default) | 'true'
            %
            % See also MRICohort, pvalue1, pvalue2.
            
            if nargin<4 || isempty(M)
                M = 1e+3;
            end
            
            Check.isinteger('The number of permutations M must be a positive integer',M,'>',0)
            
            % Verbose
            verbose = false;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'verbose')
                    verbose = varargin{n+1};
                end
            end
            
            data1 = cohort.getSubjectData(g1);
            m1 = cohort.mean(g1);
            s1 = cohort.std(g1);
            
            data2 = cohort.getSubjectData(g2);
            m2 = cohort.mean(g2);
            s2 = cohort.std(g2);
            
            data = [data1; data2];
            
            subs1 = find(cohort.getGroup(g1).getProp(Group.DATA)==true);
            subs2 = find(cohort.getGroup(g2).getProp(Group.DATA)==true);
            substmp = [subs1 subs2];
            
            tic
            
            all1 = zeros(M,length(m1));
            all2 = zeros(M,length(m2));
            for m = 1:1:M
                if verbose
                    disp(['** PERMUTATION TEST - sampling #' int2str(m) '/' int2str(M) ' - ' int2str(toc) '.' int2str(mod(toc,1)*10) 's'])
                end
                        
                perm1 = sort( randperm(numel(substmp),numel(subs1)) );
                perm2 = 1:1:numel(substmp);
                perm2(perm1) = 0; 
                perm2 = perm2(perm2>0);

                all1(m,:) = mean(data(perm1,:),1);
                all2(m,:) = mean(data(perm2,:),1);
            end
            
            dm = m2 - m1;
            dall = all2 - all1;
            
            p_single = pvalue1(dm,dall);
            p_double = pvalue2(dm,dall);
        end
        function success = loadfromxls(cohort,msg)
            % LOADFROMXLS loads MRI cohort from XLS file
            %
            % SUCCESS = LOADFROMXLS(COHORT,MSG) creates and initializes a
            %   MRI cohort by loading an XLS file ('*.xlsx' or '*.xls').
            %   It returns true if the MRI cohort is successfully created.
            %
            % See also MRICohort, uigetfile, fopen.
            
            success = false;
            
            if nargin<2
                msg = BNC.XLS_MSG_GETFILE;
            end
            
            % select file
            [file,path,filterindex] = uigetfile(BNC.XLS_EXTENSION,msg);
            
            % load file
            if filterindex
                
                [~,~,raw] = xlsread(BNC.fullfile(path,file));
                
                cohort.clear();
                
                for i = 2:1:size(raw,1)
                    
                    sub = MRISubject( ...
                        MRISubject.CODE,raw{i,1}, ...
                        MRISubject.DATA,cell2mat(raw(i,2:size(raw,2))));
                    cohort.add(sub)
                end
                
                cohort.addgroup( ...
                    Group(Group.NAME,file, ...
                    Group.DATA,true(1,cohort.length())) ...
                    )
                
                success = true;
            end
        end            
        function savetotxt(cohort,msg)
            % SAVETOTXT saves a MRI cohort to TXT file 
            %
            % SAVETOTXT(COHORT,MSG) saves MRICohort COHORT to a txt file.
            %   Uses a dialog box to select the TXT file ('*.txt').
            %
            % See also MRICohort, uiputfile, fopne, fprintf.
            
            if nargin<2
                msg = BNC.TXT_MSG_PUTFILE;
            end            
            
            % select file
            [file,path,filterindex] = uiputfile(BNC.TXT_EXTENSION,msg);

            % save file
            if filterindex

                fid = fopen(BNC.fullfile(path,file), 'w');
                
                if fid~=-1  % could not open the file
                    
                    % Brain Regions
                    fprintf(fid,'\t');
                    for i = 1:1:cohort.getBrainAtlas().length()-1
                        br = cohort.getBrainAtlas().get(i);
                        fprintf(fid,'%s\t',br.getPropValue(BrainRegion.LABEL));
                    end
                    br = cohort.getBrainAtlas().get(i+1);
                    fprintf(fid,'%s\r',br.getPropValue(BrainRegion.LABEL));
                    
                    % MRISubjects
                    for j = 1:1:cohort.length()
                        sub = cohort.get(j);
                        fprintf(fid,'%s\t',sub.getPropValue(MRISubject.CODE));
                        data = sub.getProp(MRISubject.DATA);
                        for k = 1:1:length(data)-1
                            fprintf(fid,'%f\t',data(k));
                        end
                        fprintf(fid,'%f',data(k+1));
                        if j<cohort.length()
                            fprintf(fid,'\r');
                        end
                    end
                    fclose(fid);
                end
            end
        end            
        function success = loadfromtxt(cohort,msg)
            % LOADFROMTXT loads MRI cohort from TXT file
            %
            % SUCCESS = LOADFROMTXT(COHORT,MSG) creates and initializes a
            %   MRI cohort by loading a TXT file ('*.txt)'.
            %   It returns true if the MRI cohort is successfully created.
            %
            % See also MRICohort, uigetfile, fopen.
            
            success = false;
            
            if nargin<2
                msg = BNC.TXT_MSG_GETFILE;
            end
            
            % select file
            [file,path,filterindex] = uigetfile(BNC.TXT_EXTENSION,msg);
            
            % load file
            if filterindex
                                
                fid = fopen(BNC.fullfile(path,file), 'r');
                
                if fid~=-1  % could not open the file

                    cohort.clear()

                    frewind(fid);
                    txt = fscanf(fid,'%c');
                    txt = strrep(txt,',','.');  % for Excel-genetared files to substitute ',' with '.'
                    indices1 = regexp(txt,'\r');
                    for i = 1:1:length(indices1)
                        
                        if i<length(indices1)
                            txti = txt(indices1(i)+1:1:indices1(i+1));
                        else
                            txti = txt(indices1(i)+1:1:end);
                        end
                        indices2 = regexp(txti,'\t');

                        sub = MRISubject( ...
                            MRISubject.CODE,txti(1:indices2(1)-1), ...
                            MRISubject.DATA,txti(indices2(1):end-1));
                        cohort.add(sub)
                    end
                
                    cohort.addgroup( ...
                        Group(Group.NAME,file, ...
                        Group.DATA,true(1,cohort.length())) ...
                        )
                    
                    success = true;
                end
            end
        end
        function [ListNode,Document,RootNode] = toXML(cohort,Document,RootNode)
            % TOXML creates XML Node from MRICohort
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(COHORT,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the MRICohort.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also MRICohort, ListWithGroups, List, xmlwrite.
            
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
            % FROMXML(COHORT,LISTNODE) loads the properties of MRICohort COHORT,
            %   from the attributes of LISTNODE.
            %   
            % See also MRICohort, ListWithGroups, List, xmlread.
            
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
        function clear(cohort) % cohort.atlas.clear();
            % CLEAR clears MRICohort
            %
            % CLEAR(COHORT) sets the values of all properties of the 
            %   MRICohort COHORT to their default values and eliminates 
            %   all list elements.
            %
            % See also MRICohort, ListWithGroups, List.
            
            cohort.clear@ListWithGroups()
        end        
        function scohort = extract(cohort,brs,subs)
            % EXTRACT extracts subcommunity cohort of certain subjects
            %
            % SCOHORT = EXTRACT(COHORT,BRS,SUBS) makes a copy SCOHORT of cohort COHORT
            %   that include all elements BRS of the subjects SUBS.
            %
            % See also MRICohort.

            if nargin<3
                subs = [1:1:cohort.length()];
            end
            
            % extracts subjects
            scohort = cohort.extract@ListWithGroups(subs);
            
            % extracts brain regions
            scohort.atlas = scohort.getBrainAtlas().extract(brs);
            for j = 1:1:scohort.length()
                data = scohort.get(j).getProp(MRISubject.DATA);
                scohort.get(j).setProp(MRISubject.DATA,data(brs));
            end
        end
    end
    methods (Access = protected)
        function cp = copyElement(cohort)
            % COPYELEMENT copies elements of cohort
            %
            % CP = COPYELEMENT(COHORT) copies elements of the cohort COHORT.
            %   Makes a deep copy also of the atlas of the cohort.
            %
            % See also MRICohort, handle, matlab.mixin.Copyable.

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
            % N = PROPNUMBER() gets the total number of properties of MRICohort.
            %
            % See also MRICohort.

            N = 1;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRICohort.
            %
            % See also MRICohort, ListElement.
            
            tags = {MRICohort.NAME_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRICohort.
            %
            % See also MRICohort, ListElement.

            formats = {MRICohort.NAME_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of MRICohort.
            %
            % See also MRICohort, ListElement.

            defaults = {MRICohort.NAME_DEFAULT};
        end
        function options = getOptions(~)  % (prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRICohort.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRICohort, ListElement.

            options = {};
        end
    end
end
