classdef MRIGraphAnalysis < List
    % MRIGraphAnalysis < List (Abstract) : Graph analysis of MRI data
    %   MRIGraphAnalysis represents a list of measures used for graph analysis of MRI data.
    %   Instances of this class cannot be created. Use one of the subclasses 
    %   (e.g., MRIGraphAnalysisBUD).
    %
    % MRIGraphAnalysis properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   cohort          -   cohort (MRICohort)
    %   data            -   subject data (cell array; matrix; one per group)
    %   A               -   adjaciency matrix (cell array; matrix; one per group)
    %   P               -   correlation p-value matrix (cell array; matrix; one per group)      
    %   structure       -   community structure
    %   ht_measure      -   hashtable for measure (cell array; sparse vectors; one per measure)
    %   ht_comparison   -   hashtable for comparison (cell array; sparse matrices; one per measure)
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure)
    %
    % MRIGraphAnalysis properties (Constant):
    %   NAME            -   name numeric code
    %   NAME_TAG        -   name tag
    %   NAME_FORMAT     -   name format
    %   NAME_DEFAULT    -   name default
    %
    %   GRAPH           -   graph numeric code
    %   GRAPH_TAG       -   graph tag
    %   GRAPH_FORMAT    -   graph format
    %   GRAPH_WU        -   graph 'wu' option
    %   GRAPH_BUT       -   graph 'but' option
    %   GRAPH_BUD       -   graph 'bud' option
    %   GRAPH_OPTIONS   -   array of graph options
    %   GRAPH_DEFAULT   -   graph default 
    %
    %   CORR                    -   correlation numeric code
    %   CORR_TAG                -   correlation tag
    %   CORR_FORMAT             -   correlation format
    %   CORR_PEARSON            -   correlation 'pearson' option
    %   CORR_SPEARMAN           -   correlation 'spearman' option
    %   CORR_KENDALL            -   correlation 'kendall' option
    %   CORR_PARTIALPEARSON     -   correlation 'partial pearson' option
    %   CORR_PARTIALSPEARMAN    -   correlation 'partial spearman' option
    %   CORR_OPTIONS            -   array of correlation options
    %   CORR_DEFAULT            -   correlation default
    %
    %   NEG             -   negative correlations numeric code
    %   NEG_TAG         -   negative correlations tag
    %   NEG_FORMAT      -   negative correlations format
    %   NEG_ZERO        -   negative correlations 'zero' option
    %   NEG_NONE        -   negative correlations 'none' option
    %   NEG_ABS         -   negative correlations 'abs' option
    %   NEG_OPTIONS     -   array of negative correlations options
    %   NEG_DEFAULT     -   negative correlations default
    %
    % MRIGraphAnalysis methods (Access = protected):
    %   MRIGraphAnalysis        -   constructor
    %   initialize              -   initializes graph analysis
    %   copyElement             -   deep copy
    %
    % MRIGraphAnalysis methods (Abstract,Access = protected):
    %   initialize_hashtables   -   initialize hash tables
    % 
    % MRIGraphAnalysis methods (Abstract):
    %   getMeasures             -   gets available measures
    %   getMeasure              -   gets measure from a given group
    %   getComparisons          -   gets available comparisons
	%   getComparison           -   gets comparison from a given group
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets comparison with random graphs from a given group
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare           -   calculates random comparison
    %
    % MRIGraphAnalysis methods:
    %   setProp             -   sets property value < ListElement
    %   getProp             -   gets property value, format and tag < ListElement
    %   getPropValue        -   string of property value < ListElement
    %   getPropFormat       -   string of property format < ListElement
    %   getPropTag          -   string of property tag < ListElement
    %   fullfile            -   builds XML file name < List
    %   length              -   list length < List
    %   get                 -   gets element < List
    %   getProps            -   get a property from all elements of the list < List 
    %   invert              -   inverts two elements < List
    %   moveto              -   moves element < List
    %   removeall           -   removes selected elements < List 
    %   addabove            -   adds empty elements above selected ones < List
    %   addbelow            -   adds empty elements below selected ones < List
    %   moveup              -   moves up selected elements < List 
    %   movedown            -   moves down selected elements < List
    %   move2top            -   moves selected elements to top < List
    %   move2bottom         -   moves selected elements to bottom < List 
    %   load                -   load < List
    %   loadfromfile        -   loads List from XML file < List
    %   save                -   save < List
    %   savetofile          -   saves a list to XML file < List
    %   clear               -   clears list < List
    %   adjmatrix           -   calculates the adjaciency matrix
    %   disp                -   displays graph analysis
    %   getCohort           -   returns cohort of a graph analysis
    %   getStructure        -   returns community structure of graph analysis
    %   getBrainAtlas       -   returns atlas of graph analysis
    %   getPlotBrainSurf    -   generates new PlotBrainSurf
    %   getPlotBrainAtlas   -   generates new PlotBrainAtlas
    %   getPlotBrainGraph   -   generates new PlotBrainGraph
    %   getSubjectData      -   returns data of subjects
    %   getA                -   returns adjaciency matrix
    %   getP                -   returns correlations p-value matrix
    %   exist               -   tests whether a given measure/comparison exists
    %   existMeasure        -   tests whether a given measure exists
    %   existComparison     -   tests whether a given comparison exists
    %   existRandom         -   tests whether a given comparison with random graphs exists
    %   add                 -   adds measure
    %   remove              -   removes measure
    %   replace             -   replaces measure
    %   toXML               -   creates XML Node from graph analysis
    %   fromXML             -   loads graph analysis from XML Node
    %
    % MRIGraphAnalysis methods (Abstract, Static):
    %   elementClass    -   element class name < List
    %   element         -   creates new empty element < List
    %   getIndex        -   get index used in calculation of hash values
    %
    % MRIGraphAnalysis methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also MRIGraphAnalysisBUT, MRIGraphAnalysisBUD ,MRIGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov , Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)

        % analysis name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'MRI Graph Analysis'
        
        % graph type
        GRAPH = 2
        GRAPH_TAG = 'graph'
        GRAPH_FORMAT = BNC.OPTIONS
        GRAPH_WU = 'wu'
        GRAPH_BUT = 'but'
        GRAPH_BUD = 'bud'
        GRAPH_OPTIONS = {MRIGraphAnalysis.GRAPH_WU ...
            MRIGraphAnalysis.GRAPH_BUT ...
            MRIGraphAnalysis.GRAPH_BUD}
        GRAPH_DEFAULT = MRIGraphAnalysis.GRAPH_BUD

        % Correlation types
        CORR = 3
        CORR_TAG = 'correlation'
        CORR_FORMAT = BNC.OPTIONS
        CORR_PEARSON = 'pearson'
        CORR_SPEARMAN = 'spearman'
        CORR_KENDALL = 'kendall'
        CORR_PARTIALPEARSON = 'partial pearson'
        CORR_PARTIALSPEARMAN = 'partial spearman'
        CORR_OPTIONS = {MRIGraphAnalysis.CORR_PEARSON ...
            MRIGraphAnalysis.CORR_SPEARMAN ...
            MRIGraphAnalysis.CORR_KENDALL ...
            MRIGraphAnalysis.CORR_PARTIALPEARSON ...
            MRIGraphAnalysis.CORR_PARTIALSPEARMAN}
        CORR_DEFAULT = MRIGraphAnalysis.CORR_PEARSON
        
        % How to deal with negative correlations
        NEG = 4
        NEG_TAG = 'negative'
        NEG_FORMAT = BNC.OPTIONS
        NEG_ZERO = 'zero'
        NEG_NONE = 'none'
        NEG_ABS = 'abs'
        NEG_OPTIONS = {MRIGraphAnalysis.NEG_ZERO ...
            MRIGraphAnalysis.NEG_NONE ....
            MRIGraphAnalysis.NEG_ABS}
        NEG_DEFAULT = MRIGraphAnalysis.NEG_NONE

    end
    properties (Access = protected)
        cohort  % cohort (MRICohort)
        data  % subject data (cell array; matrix; one per group)
        A  % adjaciency matrix (cell array; matrix; one per group)
        P  % correlation p-value matrix (cell array; matrix; one per group)
        structure  % community structure
        
        ht_measure  % hashtable for measure (cell array; sparse vectors; one per measure)
        ht_comparison  % hashtable for comparison (cell array; sparse matrices; one per measure)
        ht_random_comparison  % hashtable for random comparison (cell array; sparse vectors; one per measure)
    end
    methods (Access = protected)
        function ga = MRIGraphAnalysis(cohort,structure,varargin)
            % MRIGRAPHANALYSIS(COHORT,STRUCTURE) creates a MRI graph analysis with default
            %   properties using the cohort COHORT and community structure STRUCTURE.
            %   This method is only accessible by the subclasses of MRIGraphAnalysis.
            %
            % MRIGRAPHANALYSIS(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     MRIGraphAnalysis.NAME      -   char
            %     MRIGraphAnalysis.GRAPH     -   options (MRIGraphAnalysis.GRAPH_WU,
            %                                    MRIGraphAnalysis.GRAPH_BUT,MRIGraphAnalysis.GRAPH_BUD)
            %     MRIGraphAnalysis.CORR      -   options (MRIGraphAnalysis.CORR_PEARSON,MRIGraphAnalysis.CORR_SPEARMAN,
            %                                    MRIGraphAnalysis.CORR_KENDALL,MRIGraphAnalysis.CORR_PARTIALPEARSON,
            %                                    MRIGraphAnalysis.CORR_PARTIALSPEARMAN)
            %     MRIGraphAnalysis.NEG       -   options (MRIGraphAnalysis.NEG_ZERO,
            %                                    MRIGraphAnalysis.NEG_NONE,MRIGraphAnalysis.NEG_ABS)
            %
            % See also MRIGraphAnalysis,  List.
            
            Check.isa('The variable cohort must be a MRICohort',cohort,'MRICohort')
            
            ga = ga@List({},varargin{:});
            
            ga.cohort = cohort;
            ga.structure = structure;
            
            ga.initialize();
        end
        function initialize(ga)
            % INITIALIZE initializes graph analysis
            %
            % INITIALIZE(GA) initalizes all properties of the graph analysis GA.
            %   The properties to be initialized are:
            %     data           -   subject data
            %     A              -   adjaciency matrix
            %     P              -   correlation p-value matrix 
            %     ht_measure     -   hashtable for measure 
            %     ht_comparison  -   hashtable for comparison
            %     ht_random_comparison  -   hashtable for random comparison
            %
            % See also MRIGraphAnalysis.
            
            % load subject data and creates weighted adjacency matrices
            ga.data = cell(1,ga.cohort.groupnumber());
            ga.A = cell(1,ga.cohort.groupnumber());
            ga.P = cell(1,ga.cohort.groupnumber());
            for g = 1:1:ga.cohort.groupnumber()
                if g>length(ga.data) || isempty(ga.data{g})
                    ga.data{g} = ga.cohort.getSubjectData(g);
                    [A,P] = ga.adjmatrix(ga.data{g});
                    ga.A{g} = A;
                    ga.P{g} = P;
                end
            end
            
            % create hash tables
            ga.initialize_hashtables();
        end
        function cp = copyElement(ga)
            % COPYELEMENT copies elements of graph analysis
            %
            % CP = COPYELEMENT(GA) copies elements of the graph analysis GA.
            %   Makes a deep copy also of the structure of the graph analysis.
            %
            % See also MRIGraphAnalysis, handle, matlab.mixin.Copyable.

            % Make a shallow copy
            cp = copyElement@List(ga);
            % Make a deep copy
            cp.cohort = copy(ga.cohort);
            cp.structure = copy(ga.structure);
        end        
    end
    methods (Abstract,Access = protected)
        initialize_hashtables(ga)  % initialize hash tables
    end
    methods (Abstract)
        [ms,mi] = getMeasures(ga,measurecode,g)  % gets available measures
        [cs,ci] = getComparisons(ga,measurecode,g1,g2)  % gets available comparisons
        [ns,ni] = getRandomComparisons(ga,measurecode,g)  % gets available random comparisons
        m = calculate(ga,measurecode,g,varargin)  % calculates measure
        c = compare(ga,measurecode,g1,g2,varargin)  % calculates comparison
        n = randomcompare(ga,measurecode,g,varargin)  % calculates random comparison
    end
    methods
        function [A,P] = adjmatrix(ga,data)
            % ADJMATRIX calculates the adjaciency matrix
            %
            % [A,P] = ADJMATRIX(GA,DATA) calculates the adjaciency matrix A and the 
            %   matrix of p-values for correlations P, given the graph analysis GA
            %   and its subject data DATA.
            %
            % See also MRIGraphAnalysis, corr, partialcorr, corrcoef.
            
            switch ga.getProp(MRIGraphAnalysis.CORR)
                case MRIGraphAnalysis.CORR_SPEARMAN
                    [A,P] = corr(data,'Type','Spearman');
                case MRIGraphAnalysis.CORR_KENDALL
                    [A,P] = corr(data,'Type','Kendall');
                case MRIGraphAnalysis.CORR_PARTIALPEARSON
                    [A,P] = partialcorr(data,'Type','Pearson');
                case MRIGraphAnalysis.CORR_PARTIALSPEARMAN
                    [A,P] = partialcorr(data,'Type','Spearman');
                otherwise  % MRIGraphAnalysis.PEARSON
                    [A,P] = corrcoef(data);                
            end
            
            switch ga.getProp(MRIGraphAnalysis.NEG)
                case MRIGraphAnalysis.NEG_ZERO
                    A(A<0) = 0;
                case MRIGraphAnalysis.NEG_ABS
                    A = abs(A);
                otherwise  % MRIGraphAnalysis.NEG_NONE
            end
        end        
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays graph analysis GA and its cohort on the command line.
            %
            % See also MRIGraphAnalysis.
            
            ga.disp@List()
            ga.cohort.disp@List()
        end
        function cohort = getCohort(ga)
            % GETCOHORT returns cohort of a graph analysis
            %
            % COHORT = GETCOHORT(GA) returns the cohort used for initializing 
            %   the graph analysis GA.
            %
            % See also MRIGraphAnalysis, MRICohort.
            
            cohort = ga.cohort;
        end
        function str = getStructure(ga)
            % GETSTRUCTURE returns community structure of graph analysis
            %
            % STR = GETSTRUCTURE(GA) returns community structure of graph analysis GA.
            %
            % See also MRIGraphAnalysis.

            str = ga.structure;
        end
        function atlas = getBrainAtlas(ga)
            % GETBRAINATLAS returns atlas of graph analysis
            %
            % ATLAS = GETBRAINATLAS(GA) returns the atlas used for initializing 
            %   the cohort used for graph analysis GA.
            %
            % See also MRIGraphAnalysis, MRICohort, BrainAtlas.
            
            atlas = ga.getCohort().getBrainAtlas();
        end
        function bs = getPlotBrainSurf(ga)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(GA) generates a new PlotBrainSurf.
            %
            % See also MRIGraphAnalysis, MRICohort, PlotBrainSurf.
            
            bs = ga.getBrainAtlas().getPlotBrainSurf();
        end
        function ba = getPlotBrainAtlas(ga)
            % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(GA) generates a new PlotBrainAtlas.
            %
            % See also MRIGraphAnalysis, MRICohort, PlotBrainAtlas.
            
            ba = ga.getBrainAtlas().getPlotBrainAtlas();
        end
        function bg = getPlotBrainGraph(ga)
            % GETPLOTBRAINGRAPH generates new PlotBrainGraph
            %
            % BG = GETPLOTBRAINGRAPH(GA) generates a new PlotBrainGraph.
            %
            % See also MRIGraphAnalysis, PlotBrainGraph.
            
            bg = ga.getBrainAtlas().getPlotBrainGraph();
        end
        function data = getSubjectData(ga,g)
            % GETSUBJECTDATA returns data of subjects
            %
            % DATA = GETSUBJECTDATA(GA,G) returns the data of the subjects
            %   belonging to a group G of the cohort used in graph analysis GA.
            %
            % See also MRIGraphAnalysis.
            
            data = ga.data{g};
        end
        function A = getA(ga,g)
            % GETA returns adjaciency matrix
            %
            % A = GETA(GA,G) returns the adjaciency matrix A of the group G in graph analysis GA.
            %
            % See also MRIGraphAnalysis.
            
            A = ga.A{g};
        end
        function P = getP(ga,g)
            % GETP returns correlations p-value matrix
            %
            % P = GETP(GA,G) returns the matrix of p-values for correlations P of the 
            %   group G in graph analysis GA.
            %
            % See also MRIGraphAnalysis.
            
            P = ga.P{g};
        end
        function [bool,i] = exist(ga,m)
            % EXIST tests whether a given measure/comparison exists
            %
            % [BOOL,I] = EXIST(GA,M) returns BOOL as true if the measure/comparison M exists 
            %   for the graph analysis GA and false otherwise. 
            %   It also returns the value corresponding to the measure/comparison in the hash 
            %   table as I.
            %
            % See also MRIGraphAnalysis.
            
            if m.isMeasure()
                [bool,i] = ga.existMeasure(m);
            elseif m.isComparison()
                [bool,i] = ga.existComparison(m);
            else % m.isRandom()
                [bool,i] = ga.existRandom(m);
            end
        end
        function [bool,i] = existMeasure(ga,m)
            % EXISTMEASURE tests whether a given measure exists
            %
            % [BOOL,I] = EXISTMEASURE(GA,M) returns BOOL as true if the measure M exists for the 
            %   graph analysis GA and false otherwise.
            %   It also returns the value corresponding to the measure in the hash table as I.
            %
            % See also MRIGraphAnalysis.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],m,ga.elementClass())

            index = ga.getIndex(m);
            i = ga.ht_measure{m.getProp(MRIMeasure.CODE)}(index);
            bool = i>0;
        end
        function [bool,i] = existComparison(ga,c)
            % EXISTCOMPARISON tests whether a given comparison exists
            %
            % [BOOL,I] = EXISTCOMPARISON(GA,C) returns BOOL as true if the comparison C exists for the 
            %   graph analysis GA and false otherwise.
            %   It also returns the value corresponding to the comparison in the hash table as I.
            %
            % See also MRIGraphAnalysis.
            
            Check.isa(['Error: The measure c must be a ' ga.elementClass()],c,ga.elementClass())

            index = ga.getIndex(c);
            i = ga.ht_comparison{c.getProp(MRIMeasure.CODE)}(index(1),index(2));
            bool = i>0;
        end
        function [bool,i] = existRandom(ga,n)
            % EXISTRANDOM tests whether a given comparison with random graphs exists
            %
            % [BOOL,I] = EXISTRANDOM(GA,N) returns BOOL as true if the comparison
            %   with random graphs N exists for the graph analysis GA and false otherwise.
            %   It also returns the value corresponding to the comparison with random graphs
            %   in the hash table as I.
            %
            % See also MRIGraphAnalysis.

            Check.isa(['Error: The measure m must be a ' ga.elementClass()],n,ga.elementClass())
            
            index = ga.getIndex(n);
            i = ga.ht_random_comparison{n.getProp(MRIMeasure.CODE)}(index);
            bool = i>0;
        end
        function add(ga,m,i)
            % ADD adds measure/comparison/random comparison
            %
            % ADD(GA,M,I) adds a measure/comparison/random comparison M at the I-th position in graph analysis GA.
            %   If i<1 or i>GA.length, it adds the measure/comparison/random comparison at the end of GA.
            %   If M is empty, it adds a new empty measure/comparison/random comparison.
            %
            % ADD(GA,M) adds M at the end of GA.
            %
            % ADD(GA) adds empty measure/comparison/random comparison at the end of GA.
            %
            % See also MRIGraphAnalysis, List.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],m,ga.elementClass())
            
            if nargin<3 || i<=0 || i>ga.length()
                i = ga.length()+1;
            end
            
            if nargin<2 || isempty(m)
                m = [];
            end
            
            for l = 1:1:length(ga.ht_measure)
                indices = ga.ht_measure{l}>=i;
                ga.ht_measure{l}(indices) = ga.ht_measure{l}(indices)+1;
            end
            for l = 1:1:length(ga.ht_comparison)
                indices = ga.ht_comparison{l}>=i;
                ga.ht_comparison{l}(indices) = ga.ht_comparison{l}(indices)+1;
            end
            for l = 1:1:length(ga.ht_random_comparison)
                indices = ga.ht_random_comparison{l}>=i;
                ga.ht_random_comparison{l}(indices) = ga.ht_random_comparison{l}(indices)+1;
            end
                
            ga.add@List(m,i)

            if m.isMeasure()
                index = ga.getIndex(m);
                ga.ht_measure{m.getProp(MRIMeasure.CODE)}(index) = i;
            elseif m.isComparison()
                index = ga.getIndex(m);
                ga.ht_comparison{m.getProp(MRIMeasure.CODE)}(index(1),index(2)) = i;
            else % m.isRandom()
                index = ga.getIndex(m);
                ga.ht_random_comparison{m.getProp(MRIMeasure.CODE)}(index) = i;
            end
        end
        function remove(ga,i)
            % REMOVE removes measure/comparison/random comparison 
            %
            % REMOVE(GA,I) removes the measure/comparison/random comparison at the I-th position from GA.
            %
            % See also MRIGraphAnalysis, List.
            
            if i>0 && i<=ga.length()
                m = ga.get(i);
                ga.remove@List(i)
            
                if m.isMeasure()
                    index = ga.getIndex(m);
                    ga.ht_measure{m.getProp(MRIMeasure.CODE)}(index) = 0;
                elseif m.isComparison()
                    index = ga.getIndex(m);
                    ga.ht_comparison{m.getProp(MRIMeasure.CODE)}(index(1),index(2)) = 0;
                else % m.isRandom()
                    index = ga.getIndex(m);
                    ga.ht_random_comparison{m.getProp(MRIMeasure.CODE)}(index) = 0;
                end
                
                for l = 1:1:length(ga.ht_measure)
                    indices = ga.ht_measure{l}>i;
                    ga.ht_measure{l}(indices) = ga.ht_measure{l}(indices)-1;
                end
                for l = 1:1:length(ga.ht_comparison)
                    indices = ga.ht_comparison{l}>i;
                    ga.ht_comparison{l}(indices) = ga.ht_comparison{l}(indices)-1;
                end
                for l = 1:1:length(ga.ht_random_comparison)
                    indices = ga.ht_random_comparison{l}>i;
                    ga.ht_random_comparison{l}(indices) = ga.ht_random_comparison{l}(indices)-1;
                end
            end
        end
        function replace(ga,i,m)
            % REPLACE replaces measure/comparison/random comparison 
            %
            % REPLACE(GA,I,M) replaces the measure/comparison/random comparison at the I-th position
            %   in GA with the element M.
            %
            % See also MRIGraphAnalysis, List.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],m,ga.elementClass())

            if i>0 && i<=ga.length()
                ga.remove(i)
                ga.add(m,i)
            end
            
        end
        function [ListNode,Document,RootNode] = toXML(ga,Document,RootNode)
            % TOXML creates XML Node from MRIGraphAnalysis
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(GA,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the MRIGraphAnalysis.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also MRIGraphAnalysis, MRICohort, List, xmlwrite.
            
            if nargin<3
                [ListNode,Document,RootNode] = ga.toXML@List();
            elseif nargin<2
                [ListNode,Document,RootNode] = ga.toXML@List(Document);
            else
                [ListNode,Document,RootNode] = ga.toXML@List(Document,RootNode);
            end

            ga.cohort.toXML(Document,ListNode);
            
        end
        function fromXML(ga,ListNode)
            % FROMXML loads MRIGraphAnalysis from XML Node
            %
            % FROMXML(GA,LISTNODE) loads the properties of MRIGraphAnalysis GA,
            %   from the attributes of LISTNODE.
            %   
            % See also MRIGraphAnalysis, MRICohort, List, xmlread.
            
            ga.fromXML@List(ListNode)
            
            ChildrenNodes = ListNode.getChildNodes;
            ChildrenNodes = ga.cleanXML(ChildrenNodes);
            for i = 0:1:ChildrenNodes.getLength-1
                ChildNode = ChildrenNodes.item(i);
                if strcmp(ChildNode.getNodeName,class(ga.cohort))
                    ga.cohort.fromXML(ChildNode);
                end
            end

            ga.initialize()
        end
    end
    methods (Abstract,Static)
        i = getIndex(m)  % get index used in calculation of hash values
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of MRIGraphAnalysis.
            %
            % See also MRIGraphAnalysis.

            N = 4;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of MRIGraphAnalysis.
            %
            % See also MRIGraphAnalysis.
            
            tags = {MRIGraphAnalysis.NAME_TAG ...
                MRIGraphAnalysis.GRAPH_TAG ...
                MRIGraphAnalysis.CORR_TAG ...
                MRIGraphAnalysis.NEG_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of MRIGraphAnalysis.
            %
            % See also MRIGraphAnalysis.
            
            formats = {MRIGraphAnalysis.NAME_FORMAT ...
                MRIGraphAnalysis.GRAPH_FORMAT ...
                MRIGraphAnalysis.CORR_FORMAT ...
                MRIGraphAnalysis.NEG_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of MRIGraphAnalysis.
            %
            % See also MRIGraphAnalysis.

            defaults = {MRIGraphAnalysis.NAME_DEFAULT ...
                MRIGraphAnalysis.GRAPH_DEFAULT ...
                MRIGraphAnalysis.CORR_DEFAULT ...
                MRIGraphAnalysis.NEG_DEFAULT};
        end
        function options = getOptions(prop)  % (prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of MRIGraphAnalysis.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also MRIGraphAnalysis.
            
            switch prop
                case MRIGraphAnalysis.GRAPH
                    options = MRIGraphAnalysis.GRAPH_OPTIONS;
                case MRIGraphAnalysis.CORR
                    options = MRIGraphAnalysis.CORR_OPTIONS;
                case MRIGraphAnalysis.NEG
                    options = MRIGraphAnalysis.NEG_OPTIONS;
                otherwise
                    options = {};
            end
        end        
    end
end