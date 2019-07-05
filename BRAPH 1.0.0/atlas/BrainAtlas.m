classdef BrainAtlas < List
    % BrainAtlas < List : Brain atlas
    %   BrainAtlas represents a brain atlas. It is a List of BrainRegion's.
    %
    % BrainAtlas properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %
    % BrainAtlas properties (Constants):
    %   NAME                -   name numeric code
    %   NAME_TAG            -   name tag
    %   NAME_FORMAT         -   name format
    %   NAME_DEFAULT        -   name default value
    % 
    %   BRAINSURF           -   brain surface numeric code
    %   BRAINSURF_TAG       -   brain surface  tag
    %   BRAINSURF_FORMAT    -   brain surface  format
    %   BRAINSURF_ICBM152   -   brain surface ICBM152 option
    %                           uses file BrainMesh_ICBM152.nv
    %   BRAINSURF_OPTIONS   -   array of brain surface options
    %   BRAINSURF_DEFAULT   -   brain surface default value
    %
    % BrainAtlas methods:
    %   BrainAtlas          -   constructor
    %   disp                -   displays list 
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   getPlotBrainSurf    -   generates PlotBrainSurf
    %   getPlotBrainAtlas   -   generates PlotBrainAtlas
    %   getPlotBrainGraph   -   generates PlotBrainGraph
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
    %   loadfromxls         -   loads brain atlas from XLS file
    %   savetotxt           -   saves a brain atlas to TXT file
    %   loadfromtxt         -   loads brain atlas from TXT file
    %   clear               -   clears list < List
    %   copy                -   deep copy < matlab.mixin.Copyable
    %   extract             -   extract a sub-BrainAltas < List
    %
    % BrainAtlas methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % See also List, ListElement, BrainRegion, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % brain atlas name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'brain atlas name'
        
        % brain surface
        BRAINSURF = 2
        BRAINSURF_TAG = 'brainsurf'
        BRAINSURF_FORMAT = BNC.OPTIONS
        BRAINSURF_ICBM152 = 'BrainMesh_ICBM152.nv'
        BRAINSURF_OPTIONS = {BrainAtlas.BRAINSURF_ICBM152}
        BRAINSURF_DEFAULT = BrainAtlas.BRAINSURF_ICBM152

    end
    methods
        function atlas = BrainAtlas(regions,varargin)
            % BRAINATLAS(REGIONS) creates a brain atlas with default
            % properties and regions REGIONS
            %
            % BRAINATLAS(REGIONS,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     BrainAtlas.NAME      -   char
            %     BrainAtlas.BRAINSURF -   options (BrainAtlas.BRAINSURF_ICBM152)
            %
            % See also BrainAtlas, List, BrainRegion.
            
            if nargin==0 || isempty(regions)
                regions = {};
            end
            
            atlas = atlas@List(regions,varargin{:});
        end
        function disp(atlas)
            % DISP displays brain atlas
            %
            % DISP(ATLAS) displays the list ATLAS and the properties of its
            %   BrainRegion's on the command line.
            %
            % See also BrainAtlas, BrainRegion.

            atlas.disp@List()
            disp(' >> BRAIN REGIONS << ')
            for i = 1:1:atlas.length()
                br = atlas.get(i);
                disp([br.getPropValue(BrainRegion.LABEL) ...
                    ' ' br.getPropValue(BrainRegion.NAME) ...
                    ' ' br.getPropValue(BrainRegion.X) ...
                    ' ' br.getPropValue(BrainRegion.Y) ...
                    ' ' br.getPropValue(BrainRegion.Z) ...
                    ' ' br.getPropValue(BrainRegion.HS) ...
                    ' ' br.getPropValue(BrainRegion.NOTES) ...
                    ])
            end
        end
        function bs = getPlotBrainSurf(atlas)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(ATLAS) generates a new PlotBrainSurf.
            %
            % See also BrainAtlas, PlotBrainSurf.
            
            switch atlas.getPropValue(BrainAtlas.BRAINSURF)
                otherwise % BRAINSURF_ICBM152
                    bs = PlotBrainSurf();
            end
        end
        function ba = getPlotBrainAtlas(atlas)
            % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(ATLAS) generates a new PlotBrainAtlas.
            %
            % See also BrainAtlas, PlotBrainAtlas.

            switch atlas.getPropValue(BrainAtlas.BRAINSURF)
                otherwise % BRAINSURF_ICBM152
                    ba = PlotBrainAtlas(atlas);
            end
        end
        function bg = getPlotBrainGraph(atlas)
            % GETPLOTBRAINGRAPH generates new PlotBrainGraph
            %
            % BG = GETPLOTBRAINGRAPH(ATLAS) generates a new PlotBrainGraph.
            %
            % See also BrainAtlas, PlotBrainGraph.

            switch atlas.getPropValue(BrainAtlas.BRAINSURF)
                otherwise % BRAINSURF_ICBM152
                    bg = PlotBrainGraph(atlas);
            end
        end
        function success = loadfromxls(atlas,msg)
            % LOADFROMXLS loads brain atlas from XLS file
            %
            % success = LOADFROMXLS(ATLAS,MSG) creates and initializes a
            %   brain atlas by loading an XLS file ('*.xlsx' or '*.xls').
            %   It returns true if the brain atlas is successfully created.
            %
            % See also BrainAtlas, uigetfile, fopen.
            
            success = false;
            
            if nargin<2
                msg = BNC.XLS_MSG_GETFILE;
            end
            
            % select file
            [file,path,filterindex] = uigetfile(BNC.XLS_EXTENSION,msg);
            
            % load file
            if filterindex
                
                [~,~,raw] = xlsread(BNC.fullfile(path,file));
                
                atlas.clear();
                
                atlas.setProp(BrainAtlas.NAME,raw{1,1})
                atlas.setProp(BrainAtlas.BRAINSURF,raw{1,2})
                for i = 2:1:size(raw,1)
                    br = BrainRegion(BrainRegion.LABEL,raw{i,1}, ...
                        BrainRegion.NAME,raw{i,2}, ...
                        BrainRegion.X,raw{i,3}, ...
                        BrainRegion.Y,raw{i,4}, ...
                        BrainRegion.Z,raw{i,5}, ...
                        BrainRegion.HS,raw{i,6}, ...
                        BrainRegion.NOTES,raw{i,7});
                    atlas.add(br)
                end
                
                success = true;
            end
        end
        function savetotxt(atlas,msg)
            % SAVETOTXT saves a brain atlas to TXT file 
            %
            % SAVETOTXT(ATLAS,MSG) saves BrainAtlas ATLAS to a txt file.
            %   Uses a dialog box to select the TXT file ('*.txt').
            %
            % See also BrainAtlas, uiputfile, fopne, fprintf.

            if nargin<2
                msg = BNC.TXT_MSG_PUTFILE;
            end            
            
            % select file
            [file,path,filterindex] = uiputfile(BNC.TXT_EXTENSION,msg);

            % save file
            if filterindex

                fid = fopen(BNC.fullfile(path,file), 'w');
                
                if fid~=-1  % could not open the file
                    fprintf(fid,'%s\t',atlas.getPropValue(BrainAtlas.NAME));
                    fprintf(fid,'%s\r',atlas.getPropValue(BrainAtlas.BRAINSURF));
                    for i = 1:1:atlas.length()
                        br = atlas.get(i);
                        fprintf(fid,'%s\t',br.getPropValue(BrainRegion.LABEL));
                        fprintf(fid,'%s\t',br.getPropValue(BrainRegion.NAME));
                        fprintf(fid,'%s\t',num2str(br.getPropValue(BrainRegion.X)));
                        fprintf(fid,'%s\t',num2str(br.getPropValue(BrainRegion.Y)));
                        fprintf(fid,'%s\t',num2str(br.getPropValue(BrainRegion.Z)));
                        fprintf(fid,'%s\t',br.getPropValue(BrainRegion.HS));
                        fprintf(fid,'%s',br.getPropValue(BrainRegion.NOTES));
                        if i<atlas.length()
                            fprintf(fid,'\r');
                        end
                    end
                    fclose(fid);
                end
            end
        end
        function success = loadfromtxt(atlas,msg)
            % LOADFROMTXT loads brain atlas from TXT file
            %
            % success = LOADFROMTXT(LIST,MSG) creates and initializes a
            %   brain atlas by loading a TXT file ('*.txt)'.
            %   It returns true if the brain atlas is successfully created.
            %
            % See also BrainAtlas, uigetfile, fopen.
            
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

                    atlas.clear()

                    frewind(fid);
                    atlas.setProp(BrainAtlas.NAME,fscanf(fid, '%s\t',1))
                    atlas.setProp(BrainAtlas.BRAINSURF,fscanf(fid, '%s\r',1))
                    
                    frewind(fid);
                    txt = fscanf(fid,'%c');
                    indices1 = regexp(txt,'\r');
                    for i = 1:1:length(indices1)
                        
                        if i<length(indices1)
                            txti = txt(indices1(i)+1:1:indices1(i+1)-1);
                        else
                            txti = txt(indices1(i)+1:1:end);                            
                        end
                        indices2 = regexp(txti,'\t');

                        txti(indices2(2):indices2(5)) = strrep(txti(indices2(2):indices2(5)),',','.');  % for Excel-genetared files to substitute ',' with '.'
                        
                        br = BrainRegion(BrainRegion.LABEL,txti(1:indices2(1)-1), ...
                            BrainRegion.NAME,txti(indices2(1)+1:indices2(2)-1), ...
                            BrainRegion.X,txti(indices2(2)+1:indices2(3)-1), ...
                            BrainRegion.Y,txti(indices2(3)+1:indices2(4)-1), ...
                            BrainRegion.Z,txti(indices2(4)+1:indices2(5)-1), ...
                            BrainRegion.HS,txti(indices2(5)+1:indices2(6)-1), ...
                            BrainRegion.NOTES,txti(indices2(6)+1:end));
                        atlas.add(br)
                    end
                    
                    success = true;
                end
            end
        end        
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of BrainAtlas.
            %
            % See also BrainAtlas.

            N = 2;
        end        
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of BrainAtlas.
            %
            % See also BrainAtlas, ListElement.

            tags = {BrainAtlas.NAME_TAG ...
                BrainAtlas.BRAINSURF_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of BrainAtlas.
            %
            % See also BrainAtlas, ListElement.

            formats = {BrainAtlas.NAME_FORMAT ...
                BrainAtlas.BRAINSURF_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of BrainAtlas.
            %
            % See also BrainAtlas, ListElement.

            defaults = {BrainAtlas.NAME_DEFAULT ...
                BrainAtlas.BRAINSURF_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of BrainAtlas.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also BrainAtlas, ListElement.

            switch prop
                case BrainAtlas.BRAINSURF
                    options = BrainAtlas.BRAINSURF_OPTIONS;
                otherwise
                    options = {};
            end
        end        
        function class = elementClass()
            % ELEMENTCLASS element class
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'BrainRegion'.
            %
            % See also BrainAtlas, BrainRegion.
            
            class = 'BrainRegion';
        end
        function br = element()
            % ELEMENT returns empty BrainRegion
            %
            % BR = ELEMENT() returns an empty BrainRegion.
            %
            % See also BrainAtlas, BrainRegion.
            
            br = BrainRegion();
        end
    end
end