classdef fMRIGraphAnalysis < List
    % fMRIGraphAnalysis < List (Abstract): Graph analysis of fMRI data
    %   fMRIGraphAnalysis represents a list of measures used for graph analysis of fMRI data.
    %   Instances of this class cannot be created. Use one of the subclasses
    %   (e.g., fMRIGraphAnalysisBUD).
    %
    % fMRIGraphAnalysis properties (Access = protected):
    %   props                   -   cell array of object properties < ListElement
    %   elements                -   cell array of list elements < List
    %   path                    -   XML file path < List
    %   file                    -   XML file name < List
    %   cohort                  -   cohort (fMRICohort)
    %   data                    -   subject data (cell array; matrix; one per subject)
    %   A                       -   adjaciency matrix (cell array; matrix; one per subject)
    %   P                       -   correlation p-value matrix (cell array; matrix; one per subject)
    %   structure               -   community structure
    %   ht_measure              -   hashtable for measure (cell array; sparse vectors; one per measure)
    %   ht_comparison           -   hashtable for comparison (cell array; sparse matrices; one per measure)
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure)
    %
    % fMRIGraphAnalysis properties (Constant):
    %   NAME                    -   name numeric code
    %   NAME_TAG                -   name tag
    %   NAME_FORMAT             -   name format
    %   NAME_DEFAULT            -   name default
    %
    %   GRAPH                   -   graph numeric code
    %   GRAPH_TAG               -   graph tag
    %   GRAPH_FORMAT            -   graph format
    %   GRAPH_WU                -   graph 'wu' option
    %   GRAPH_BUT               -   graph 'but' option
    %   GRAPH_BUD               -   graph 'bud' option
    %   GRAPH_OPTIONS           -   array of graph options
    %   GRAPH_DEFAULT           -   graph default
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
    %   NEG                     -   negative correlations numeric code
    %   NEG_TAG                 -   negative correlations tag
    %   NEG_FORMAT              -   negative correlations format
    %   NEG_ZERO                -   negative correlations 'zero' option
    %   NEG_NONE                -   negative correlations 'none' option
    %   NEG_ABS                 -   negative correlations 'abs' option
    %   NEG_OPTIONS             -   array of negative correlations options
    %   NEG_DEFAULT             -   negative correlations default
    %
    %   FMIN                    -   lower frequency cutoff numeric code
    %   FMIN_TAG                -   lower frequency cutoff tag
    %   FMIN_FORMAT             -   lower frequency cutoff format
    %   FMIN_DEFAULT            -   lower frequency cutoff default
    %
    %   FMAX                    -   higher frequency cutoff numeric code
    %   FMAX_TAG                -   higher frequency cutoff tag
    %   FMAX_FORMAT             -   higher frequency cutoff format
    %   FMAX_DEFAULT            -   higher frequency cutoff default
    %
    % fMRIGraphAnalysis methods (Access = protected):
    %   fMRIGraphAnalysis       -   constructor
    %   initialize              -   initializes graph analysis
    %   copyElement             -   copies elements of graph analysis
    %
    % fMRIGraphAnalysis methods (Abstract,Access = protected):
    %   initialize_hashtables   -   initialize hash tables
    %
    % fMRIGraphAnalysis methods (Abstract):
    %   getMeasures             -   gets available measures
    %   getComparisons          -   gets available comparisons
    %   getRandomComparisons    -   gets available random comparisons
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare           -   calculates random comparison
    %
    % fMRIGraphAnalysis methods:
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
    %   getBrainAtlas       -   returns atlas of graph analysis
    %   getPlotBrainSurf    -   generates new PlotBrainSurf
    %   getPlotBrainAtlas   -   generates new PlotBrainAtlas
    %   getPlotBrainGraph   -   generates new PlotBrainGraph
    %   getSubjectData      -   returns data of subjects
    %   getA                -   returns adjaciency matrix
    %   getP                -   returns correlations p-value matrix
    %   getStructure        -   returns community structure
    %   exist               -   tests whether a given measure,comparison or random comparison exists
    %   existMeasure        -   tests whether a given measure exists
    %   existComparison     -   tests whether a given comparison exists
    %   existRandom         -   tests whether a given random comparison exists
    %   add                 -   adds measure
    %   remove              -   removes measure
    %   replace             -   replaces measure
    %   toXML               -   creates XML Node from graph analysis
    %   fromXML             -   loads graph analysis from XML Node
    %
    % fMRIGraphAnalysis methods (Abstract, Static):
    %   elementClass    -   element class name < List
    %   element         -   creates new empty element < List
    %   getIndex        -   get index used in calculation of hash values
    %
    % fMRIGraphAnalysis methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties
    %   getTags         -   cell array of strings with the tags of the properties
    %   getFormats      -   cell array with the formats of the properties
    %   getDefaults     -   cell array with the defaults of the properties
    %   getOptions      -   cell array with options (only for properties with options format)
    %
    % See also fMRIGraphAnalysisBUT, fMRIGraphAnalysisBUD, fMRIGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)

        % analysis name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'fMRI Graph Analysis'
        
        % graph type
        GRAPH = 2
        GRAPH_TAG = 'graph'
        GRAPH_FORMAT = BNC.OPTIONS
        GRAPH_WU = 'wu'
        GRAPH_BUT = 'but'
        GRAPH_BUD = 'bud'
        GRAPH_OPTIONS = {fMRIGraphAnalysis.GRAPH_WU ...
            fMRIGraphAnalysis.GRAPH_BUT ...
            fMRIGraphAnalysis.GRAPH_BUD}
        GRAPH_DEFAULT = fMRIGraphAnalysis.GRAPH_BUD

        % Correlation types
        CORR = 3
        CORR_TAG = 'correlation'
        CORR_FORMAT = BNC.OPTIONS
        CORR_PEARSON = 'pearson'
        CORR_SPEARMAN = 'spearman'
        CORR_KENDALL = 'kendall'
        CORR_PARTIALPEARSON = 'partial pearson'
        CORR_PARTIALSPEARMAN = 'partial spearman'
        CORR_OPTIONS = {fMRIGraphAnalysis.CORR_PEARSON ...
            fMRIGraphAnalysis.CORR_SPEARMAN ...
            fMRIGraphAnalysis.CORR_KENDALL ...
            fMRIGraphAnalysis.CORR_PARTIALPEARSON ...
            fMRIGraphAnalysis.CORR_PARTIALSPEARMAN}
        CORR_DEFAULT = fMRIGraphAnalysis.CORR_PEARSON
        
        % How to deal with negative correlations
        NEG = 4
        NEG_TAG = 'negative'
        NEG_FORMAT = BNC.OPTIONS
        NEG_ZERO = 'zero'
        NEG_NONE = 'none'
        NEG_ABS = 'abs'
        NEG_OPTIONS = {fMRIGraphAnalysis.NEG_ZERO ...
            fMRIGraphAnalysis.NEG_NONE ....
            fMRIGraphAnalysis.NEG_ABS}
        NEG_DEFAULT = fMRIGraphAnalysis.NEG_NONE
        
        % Lower frequency cutoff
        FMIN = 5
        FMIN_TAG = 'min_frequency'
        FMIN_FORMAT = BNC.NUMERIC
        FMIN_DEFAULT = 0
        
        % Higher frequency cutoff
        FMAX = 6
        FMAX_TAG = 'max_frequency'
        FMAX_FORMAT = BNC.NUMERIC
        FMAX_DEFAULT = inf

    end
    properties % (Access = protected)
        cohort  % cohort (fMRICohort)
        data  % subject data (cell array; matrix; one per subject)
        A  % adjaciency matrix (cell array; matrix; one per subject)
        P  % correlation p-value matrix (cell array; matrix; one per subject)
        structure  % community structure
        
        ht_measure  % hashtable for measure (cell array; sparse vectors; one per measure)
        ht_comparison  % hashtable for comparison (cell array; sparse matrices; one per measure)
        ht_random_comparison  % hashtable for random comparison (cell array; sparse vectors; one per measure)
    end
    methods (Access = protected)
        function ga = fMRIGraphAnalysis(cohort,structure,varargin)
            % FMRIGRAPHANALYSIS(COHORT,STRUCTURE) creates a fMRI graph analysis with default
            %   properties using the cohort COHORT and community structure STRUCTURE.
            %   This method is only accessible by the subclasses of fMRIGraphAnalysis.
            %
            % FMRIGRAPHANALYSIS(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIGraphAnalysis.NAME      -   char
            %     fMRIGraphAnalysis.GRAPH     -   options (fMRIGraphAnalysis.GRAPH_WU,
            %                                     fMRIGraphAnalysis.GRAPH_BUT,fMRIGraphAnalysis.GRAPH_BUD)
            %     fMRIGraphAnalysis.CORR      -   options (fMRIGraphAnalysis.CORR_PEARSON,fMRIGraphAnalysis.CORR_SPEARMAN,
            %                                     fMRIGraphAnalysis.CORR_KENDALL,fMRIGraphAnalysis.CORR_PARTIALPEARSON,
            %                                     fMRIGraphAnalysis.CORR_PARTIALSPEARMAN)
            %     fMRIGraphAnalysis.NEG       -   options (fMRIGraphAnalysis.NEG_ZERO,
            %                                     fMRIGraphAnalysis.NEG_NONE,fMRIGraphAnalysis.NEG_ABS)
            %     fMRIGraphAnalysis.FMIN      -   numeric
            %     fMRIGraphAnalysis.FMAX      -   numeric
            %
            % See also fMRIGraphAnalysis,  List.

            Check.isa('The variable cohort must be a fMRICohort',cohort,'fMRICohort')
            
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
            %     data                  -   subject data
            %     A                     -   adjaciency matrix
            %     P                     -   correlation p-value matrix 
            %     ht_measure            -   hashtable for measure 
            %     ht_comparison         -   hashtable for comparison
            %     ht_random_comparison  -   hashtable for random comparison
            %
            % See also fMRIGraphAnalysis.
            
            % load subject data and creates weighted adjacency matrices
            ga.data = cell(1,ga.cohort.length());
            ga.A = cell(1,ga.cohort.length());
            ga.P = cell(1,ga.cohort.length());
            for subi = 1:1:ga.cohort.length()
                if subi>length(ga.data) || isempty(ga.data{subi})
                    
                    % load timeseries
                    ga.data{subi} = ga.cohort.get(subi).getProp(fMRISubject.DATA);
                    
                    % band pass
                    data = ga.data{subi};
                    fmin = ga.getProp(fMRIGraphAnalysis.FMIN);
                    fmax = ga.getProp(fMRIGraphAnalysis.FMAX);
                    T = ga.getCohort().getProp(fMRICohort.T);
                    fs = 1/T;
                    if fmax>fmin && T>0
                        
                        NFFT = 2*ceil(size(data,1)/2);
                        ft = fft(data,NFFT);  % Fourier transform
                        f = fftshift( fs*abs(-NFFT/2:NFFT/2-1)/NFFT ); % absolute frequency
                        
                        ft(f<fmin|f>fmax,:) = 0;
                        
                        data = ifft(ft,NFFT);
                        
                        % ft = fft(data);  % Fourier transform
                        % 
                        % ft_tmp = 0*ft;
                        % ind = [floor(fs/fmax):1:ceil(fs/fmin)];
                        % for i = ind
                        %     if i == 1
                        %         ft_tmp(1,:) = ft(1,:);
                        %     else
                        %         ft_tmp(i,:) = ft(i,:);
                        %         ft_tmp(end+2-i,:) = ft(end+2-i,:);
                        %     end
                        % end
                        % data = ifft(ft_tmp);
        
                        ga.data{subi} = data;
                    end
                    
                    % calculate correlation matrix
                    [A,P] = ga.adjmatrix(ga.data{subi});
                    ga.A{subi} = A;
                    ga.P{subi} = P;
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
            % See also fMRIGraphAnalysis, handle, matlab.mixin.Copyable.

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
        [ns,ni] = getRandomComparisons(ga,measurecode,g)  % gets available random comparisons
        [cs,ci] = getComparisons(ga,measurecode,g1,g2)  % gets available comparisons
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
            % See also fMRIGraphAnalysis, corr, partialcorr, corrcoef.
            
            switch ga.getProp(fMRIGraphAnalysis.CORR)
                case fMRIGraphAnalysis.CORR_SPEARMAN
                    [A,P] = corr(data,'Type','Spearman');
                case fMRIGraphAnalysis.CORR_KENDALL
                    [A,P] = corr(data,'Type','Kendall');
                case fMRIGraphAnalysis.CORR_PARTIALPEARSON
                    [A,P] = partialcorr(data,'Type','Pearson');
                case fMRIGraphAnalysis.CORR_PARTIALSPEARMAN
                    [A,P] = partialcorr(data,'Type','Spearman');
                otherwise  % fMRIGraphAnalysis.PEARSON
                    [A,P] = corrcoef(data);                
            end
            
            switch ga.getProp(fMRIGraphAnalysis.NEG)
                case fMRIGraphAnalysis.NEG_ZERO
                    A(A<0) = 0;
                case fMRIGraphAnalysis.NEG_ABS
                    A = abs(A);
                otherwise  % fMRIGraphAnalysis.NEG_NONE
            end
        end        
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays graph analysis GA and its cohort on the command line.
            %
            % See also fMRIGraphAnalysis.
            
            ga.disp@List()
            ga.cohort.disp@List()
        end
        function cohort = getCohort(ga)
            % GETCOHORT returns cohort of a graph analysis
            %
            % COHORT = GETCOHORT(GA) returns the cohort used for initializing 
            %   the graph analysis GA.
            %
            % See also fMRIGraphAnalysis, fMRICohort.
            
            cohort = ga.cohort;
        end
        function atlas = getBrainAtlas(ga)
            % GETBRAINATLAS returns atlas of graph analysis
            %
            % ATLAS = GETBRAINATLAS(GA) returns the atlas used for initializing 
            %   the cohort used for graph analysis GA.
            %
            % See also fMRIGraphAnalysis, fMRICohort, BrainAtlas.
            
            atlas = ga.getCohort().getBrainAtlas();
        end
        function bs = getPlotBrainSurf(ga)
            % GETPLOTBRAINSURF generates new PlotBrainSurf
            %
            % BS = GETPLOTBRAINSURF(GA) generates a new PlotBrainSurf.
            %
            % See also fMRIGraphAnalysis, fMRICohort, PlotBrainSurf.
            
            bs = ga.getBrainAtlas().getPlotBrainSurf();
        end
        function ba = getPlotBrainAtlas(ga)
             % GETPLOTBRAINATLAS generates new PlotBrainAtlas
            %
            % BA = GETPLOTBRAINATLAS(GA) generates a new PlotBrainAtlas.
            %
            % See also fMRIGraphAnalysis, fMRICohort, PlotBrainAtlas.
            
            ba = ga.getBrainAtlas().getPlotBrainAtlas();
        end
        function bg = getPlotBrainGraph(ga)
            % GETPLOTBRAINGRAPH generates new PlotBrainGraph
            %
            % BG = GETPLOTBRAINGRAPH(GA) generates a new PlotBrainGraph.
            %
            % See also fMRIGraphAnalysis, PlotBrainGraph.
            
            bg = ga.getBrainAtlas().getPlotBrainGraph();
        end
        function data = getSubjectData(ga,subi)          
            % GETSUBJECTDATA returns data of subjects
            %
            % DATA = GETSUBJECTDATA(GA,SUBI) returns the data of the subject
            %  SUBI of the cohort used in graph analysis GA.
            %
            % See also fMRIGraphAnalysis.
            
            data = ga.data{subi};
        end
        function A = getA(ga,subi)
            % GETA returns adjaciency matrix
            %
            % A = GETA(GA,SUBI) returns the adjaciency matrix A of the subject SUBI
            %   in graph analysis GA.
            %
            % See also fMRIGraphAnalysis.
            
            A = ga.A{subi};
        end
        function P = getP(ga,subi)
            % GETP returns correlations p-value matrix
            %
            % P = GETP(GA,SUBI) returns the matrix of p-values for correlations P of the 
            %   subject SUBI in graph analysis GA.
            %
            % See also fMRIGraphAnalysis.
            
            P = ga.P{subi};
        end
        function structure = getStructure(ga)
            % GETSTRUCTURE returns community structure of graph analysis
            %
            % STR = GETSTRUCTURE(GA) returns community structure of graph analysis GA.
            %
            % See also fMRIGraphAnalysis.

            structure = ga.structure;
        end
        function [bool,i] = exist(ga,m)
            % EXIST tests whether a given measure,comparison or random comparison exists
            %
            % [BOOL,I] = EXIST(GA,M) returns BOOL as true if the measure,comparison or
            %   random comparison M exists for the graph analysis GA and false otherwise. 
            %   It also returns the value corresponding to the measure,comparison or random comparison
            %   in the hash table as I.
            %
            % See also fMRIGraphAnalysis.
            
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
            % See also fMRIGraphAnalysis.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],m,ga.elementClass())

            index = ga.getIndex(m);
            i = ga.ht_measure{m.getProp(fMRIMeasure.CODE)}(index);
            bool = i>0;
        end
        function [bool,i] = existComparison(ga,c)
            % EXISTCOMPARISON tests whether a given comparison exists
            %
            % [BOOL,I] = EXISTCOMPARISON(GA,C) returns BOOL as true if the comparison C exists for the 
            %   graph analysis GA and false otherwise.
            %   It also returns the value corresponding to the comparison in the hash table as I.
            %
            % See also fMRIGraphAnalysis.
            
            Check.isa(['Error: The measure c must be a ' ga.elementClass()],c,ga.elementClass())

            index = ga.getIndex(c);
            i = ga.ht_comparison{c.getProp(fMRIMeasure.CODE)}(index(1),index(2));
            bool = i>0;
        end
        function [bool,i] = existRandom(ga,n)
            % EXISTRANDOM tests whether a given random comparison exists
            %
            % [BOOL,I] = EXISTRANDOM(GA,N) returns BOOL as true if the random comparison N 
            %   exists for the graph analysis GA and false otherwise.
            %   It also returns the value corresponding to the comparison in the hash table as I.
            %
            % See also fMRIGraphAnalysis.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],n,ga.elementClass())
            
            index = ga.getIndex(n);
            i = ga.ht_random_comparison{n.getProp(fMRIMeasure.CODE)}(index);
            bool = i>0;
        end
        function add(ga,m,i)
            % ADD adds measure,comparison or random comparison
            %
            % ADD(GA,M,I) adds a  measure,comparison or random comparison M at the I-th position
            %   in graph analysis GA. If i<1 or i>GA.length, it adds the measure,comparison 
            %   or random comparison at the end of GA. If M is empty, it adds a new empty
            %   measure,comparison or random comparison.
            %
            % ADD(GA,M) adds M at the end of GA.
            %
            % ADD(GA) adds empty  measure,comparison or random comparison at the end of GA.
            %
            % See also fMRIGraphAnalysis, List.
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
                ga.ht_measure{m.getProp(fMRIMeasure.CODE)}(index) = i;
            elseif m.isComparison()
                index = ga.getIndex(m);
                ga.ht_comparison{m.getProp(fMRIMeasure.CODE)}(index(1),index(2)) = i;
            else % m.isRandom()
                index = ga.getIndex(m);
                ga.ht_random_comparison{m.getProp(fMRIMeasure.CODE)}(index) = i;
            end
        end
        function remove(ga,i)
            % REMOVE removes measure,comparison or random comparison
            %
            % REMOVE(GA,I) removes the measure,comparison or random comparison at 
            %   the I-th position from GA.
            %
            % See also fMRIGraphAnalysis, List.
            
            if i>0 && i<=ga.length()
                m = ga.get(i);
                ga.remove@List(i)
            
                if m.isMeasure()
                    index = ga.getIndex(m);
                    ga.ht_measure{m.getProp(fMRIMeasure.CODE)}(index) = 0;
                elseif m.isComparison()
                    index = ga.getIndex(m);
                    ga.ht_comparison{m.getProp(fMRIMeasure.CODE)}(index(1),index(2)) = 0;
                else % m.isRandom()
                    index = ga.getIndex(m);
                    ga.ht_random_comparison{m.getProp(fMRIMeasure.CODE)}(index) = 0;
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
            % REPLACE replaces measure,comparison or random comparison
            %
            % REPLACE(GA,I,M) replaces the measure,comparison or random comparison
            %    at the I-th position in GA with the element M.
            %
            % See also fMRIGraphAnalysis, List.
            
            Check.isa(['Error: The measure m must be a ' ga.elementClass()],m,ga.elementClass())

            if i>0 && i<=ga.length()
                ga.remove(i)
                ga.add(m,i)
            end
            
        end
        function [ListNode,Document,RootNode] = toXML(ga,Document,RootNode)
            % TOXML creates XML Node from fMRIGraphAnalysis
            %
            % [LISTNODE, DOCUMENT, ROOTNODE] = TOXML(GA,DOCUMENT,ROOTNODE)  
            %   appends to ROOTNODE of DOCUMENT a new node (LISTNODE) 
            %   representing the fMRIGraphAnalysis.
            %   It returns the DOCUMENT, its ROOTNODE and the LISTNODE.
            % 
            % The default XML Document is created with:
            %   Document = com.mathworks.xml.XMLUtils.createDocument('xml');
            %
            % See also fMRIGraphAnalysis, fMRICohort, List, xmlwrite.
            
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
            % FROMXML loads fMRIGraphAnalysis from XML Node
            %
            % FROMXML(GA,LISTNODE) loads the properties of fMRIGraphAnalysis GA,
            %   from the attributes of LISTNODE.
            %   
            % See also fMRIGraphAnalysis, fMRICohort, List, xmlread.
            
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
            % N = PROPNUMBER() gets the total number of properties of fMRIGraphAnalysis.
            %
            % See also fMRIGraphAnalysis.

            N = 6;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the tags of the properties
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags 
            %   of all properties of fMRIGraphAnalysis.
            %
            % See also fMRIGraphAnalysis.
            
            tags = {fMRIGraphAnalysis.NAME_TAG ...
                fMRIGraphAnalysis.GRAPH_TAG ...
                fMRIGraphAnalysis.CORR_TAG ...
                fMRIGraphAnalysis.NEG_TAG ...
                fMRIGraphAnalysis.FMIN_TAG ...
                fMRIGraphAnalysis.FMAX_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of fMRIGraphAnalysis.
            %
            % See also fMRIGraphAnalysis.
            
            formats = {fMRIGraphAnalysis.NAME_FORMAT ...
                fMRIGraphAnalysis.GRAPH_FORMAT ...
                fMRIGraphAnalysis.CORR_FORMAT ...
                fMRIGraphAnalysis.NEG_FORMAT ...
                fMRIGraphAnalysis.FMIN_FORMAT ...
                fMRIGraphAnalysis.FMAX_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of fMRIGraphAnalysis.
            %
            % See also fMRIGraphAnalysis.

            defaults = {fMRIGraphAnalysis.NAME_DEFAULT ...
                fMRIGraphAnalysis.GRAPH_DEFAULT ...
                fMRIGraphAnalysis.CORR_DEFAULT ...
                fMRIGraphAnalysis.NEG_DEFAULT ...
                fMRIGraphAnalysis.FMIN_DEFAULT ...
                fMRIGraphAnalysis.FMAX_DEFAULT};
        end
        function options = getOptions(prop)  % (prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties specified by PROP of fMRIGraphAnalysis.
            %   If the PROP is not "options", it returns an empty cell array. 
            %
            % See also fMRIGraphAnalysis.
            
            switch prop
                case fMRIGraphAnalysis.GRAPH
                    options = fMRIGraphAnalysis.GRAPH_OPTIONS;
                case fMRIGraphAnalysis.CORR
                    options = fMRIGraphAnalysis.CORR_OPTIONS;
                case fMRIGraphAnalysis.NEG
                    options = fMRIGraphAnalysis.NEG_OPTIONS;
                otherwise
                    options = {};
            end
        end        
    end
end
