classdef MRIGraphAnalysisWU < MRIGraphAnalysis
    % MRIGraphAnalysisWU < MRIGraphAnalysis : Graph analysis of weighted undirected MRI
    %   MRIGraphAnalysisWU represents a list of measures used for graph analysis of MRI data based 
    %   on weighted undirected graphs.
    %
    % MRIGraphAnalysisWU properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   cohort          -   cohort (MRICohort) < MRIGraphAnalysis
    %   data            -   subject data (cell array; matrix; one per group) < MRIGraphAnalysis
    %   A               -   adjaciency matrix (cell array; matrix; one per group) < MRIGraphAnalysis
    %   P               -   correlation p-value matrix (cell array; matrix; one per group) < MRIGraphAnalysis      
    %   structure       -   community structure < MRIGraphAnalysis
    %   ht_measure      -   hashtable for measure (cell array; sparse vectors; one per measure) < MRIGraphAnalysis
    %   ht_comparison   -   hashtable for comparison (cell array; sparse matrices; one per measure) < MRIGraphAnalysis
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure)
    %
    % MRIGraphAnalysisWU properties (Constant):
    %   NAME            -   name numeric code < MRIGraphAnalysis
    %   NAME_TAG        -   name tag < MRIGraphAnalysis
    %   NAME_FORMAT     -   name format < MRIGraphAnalysis
    %   NAME_DEFAULT    -   name default < MRIGraphAnalysis
    %
    %   GRAPH           -   graph numeric code < MRIGraphAnalysis
    %   GRAPH_TAG       -   graph tag < MRIGraphAnalysis
    %   GRAPH_FORMAT    -   graph format < MRIGraphAnalysis
    %   GRAPH_WU        -   graph 'wu' option < MRIGraphAnalysis
    %   GRAPH_BUT       -   graph 'but' option < MRIGraphAnalysis
    %   GRAPH_BUD       -   graph 'bud' option < MRIGraphAnalysis
    %   GRAPH_OPTIONS   -   array of graph options < MRIGraphAnalysis
    %   GRAPH_DEFAULT   -   graph default < MRIGraphAnalysis
    %
    %   CORR                    -   correlation numeric code < MRIGraphAnalysis
    %   CORR_TAG                -   correlation tag < MRIGraphAnalysis
    %   CORR_FORMAT             -   correlation format < MRIGraphAnalysis
    %   CORR_PEARSON            -   correlation 'pearson' option < MRIGraphAnalysis
    %   CORR_SPEARMAN           -   correlation 'spearman' option < MRIGraphAnalysis
    %   CORR_KENDALL            -   correlation 'kendall' option < MRIGraphAnalysis
    %   CORR_PARTIALPEARSON     -   correlation 'partial pearson' option < MRIGraphAnalysis
    %   CORR_PARTIALSPEARMAN    -   correlation 'partial spearman' option < MRIGraphAnalysis
    %   CORR_OPTIONS            -   array of correlation options < MRIGraphAnalysis
    %   CORR_DEFAULT            -   correlation default < MRIGraphAnalysis
    %
    %   NEG             -   negative correlations numeric code < MRIGraphAnalysis
    %   NEG_TAG         -   negative correlations tag < MRIGraphAnalysis
    %   NEG_FORMAT      -   negative correlations format < MRIGraphAnalysis
    %   NEG_ZERO        -   negative correlations 'zero' option < MRIGraphAnalysis
    %   NEG_NONE        -   negative correlations 'none' option < MRIGraphAnalysis
    %   NEG_ABS         -   negative correlations 'abs' option < MRIGraphAnalysis
    %   NEG_OPTIONS     -   array of negative correlations options < MRIGraphAnalysis
    %   NEG_DEFAULT     -   negative correlations default < MRIGraphAnalysis
    %
    % MRIGraphAnalysisWU methods (Access = protected):
    %   initialize             -   initializes graph analysis < MRIGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %   copyElement             -   deep copy < MRIGraphAnalysis
    %
    % MRIGraphAnalysisWU methods:
    %   MRIGraphAnalysisWU     -   constructor
    %   setProp                 -   sets property value < ListElement
    %   getProp                 -   gets property value, format and tag < ListElement
    %   getPropValue            -   string of property value < ListElement
    %   getPropFormat           -   string of property format < ListElement
    %   getPropTag              -   string of property tag < ListElement
    %   fullfile                -   builds XML file name < List
    %   length                  -   list length < List
    %   get                     -   gets element < List
    %   getProps                -   get a property from all elements of the list < List 
    %   invert                  -   inverts two elements < List
    %   moveto                  -   moves element < List
    %   removeall               -   removes selected elements < List 
    %   addabove                -   adds empty elements above selected ones < List
    %   addbelow                -   adds empty elements below selected ones < List
    %   moveup                  -   moves up selected elements < List 
    %   movedown                -   moves down selected elements < List
    %   move2top                -   moves selected elements to top < List
    %   move2bottom             -   moves selected elements to bottom < List 
    %   load                    -   load < List
    %   loadfromfile            -   loads List from XML file < List
    %   save                    -   save < List
    %   savetofile              -   saves a list to XML file < List
    %   clear                   -   clears list < List
    %   adjmatrix               -   calculates the adjaciency matrix < MRIGraphAnalysis
    %   getCohort               -   returns cohort of a graph analysis < MRIGraphAnalysis
    %   getStructure            -   returns community structure of graph analysis
    %   getBrainAtlas           -   returns atlas of graph analysis < MRIGraphAnalysis
    %   getPlotBrainSurf        -   generates new PlotBrainSurf < MRIGraphAnalysis
    %   getPlotBrainAtlas       -   generates new PlotBrainAtlas < MRIGraphAnalysis
    %   getPlotBrainGraph       -   generates new PlotBrainGraph < MRIGraphAnalysis
    %   getSubjectData          -   returns data of subjects < MRIGraphAnalysis
    %   getA                    -   returns adjaciency matrix < MRIGraphAnalysis
    %   getP                    -   returns correlations p-value matrix < MRIGraphAnalysis
    %   exist                   -   tests whether a given measure/comparison exists < MRIGraphAnalysis
    %   existMeasure            -   tests whether a given measure exists < MRIGraphAnalysis
    %   existComparison         -   tests whether a given comparison exists < MRIGraphAnalysis
    %   existRandom             -   tests whether a given comparison with random graphs exists
    %   add                     -   adds measure < MRIGraphAnalysis
    %   remove                  -   removes measure < MRIGraphAnalysis
    %   replace                 -   replaces measure < MRIGraphAnalysis
    %   toXML                   -   creates XML Node from graph analysis < MRIGraphAnalysis
    %   fromXML                 -   loads graph analysis from XML Node < MRIGraphAnalysis
    %   disp                    -   displays graph analysis
	%   getMeasures             -   gets available measures
    %   getMeasure              -   gets measure from a given group
    %   getComparisons          -   gets available comparisons
	%   getComparison           -   gets comparison from given groups
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets comparison with random graphs from given group at specified density
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare           -   calculates random comparison
    %
    % MRIGraphAnalysisWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < MRIGraphAnalysis
    %   getTags         -   cell array of strings with the tags of the properties < MRIGraphAnalysis
    %   getFormats      -   cell array with the formats of the properties < MRIGraphAnalysis
    %   getDefaults     -   cell array with the defaults of the properties < MRIGraphAnalysis
    %   getOptions      -   cell array with options (only for properties with options format) < MRIGraphAnalysis
    %   getIndex        -   get index used in calculation of hash values
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % See also MRIGraphAnalysisBUT, MRIGraphAnalysis ,MRIGraphAnalysisBUD, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = MRIGraphAnalysisWU(cohort,str,varargin)
            % MRIGRAPHANALYSISWU(COHORT,STRUCTURE) creates a MRI graph analysis using
            %   the cohort COHORT and community structure STRUCTURE. This analysis has
            %   default properties and uses a weighted undirected graph.
            %
            % MRIGRAPHANALYSISWU(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes
            %   property Tag1 to Value1, Tag2 to Value2, ... .
            %   Admissible properties are:
            %       MRIGraphAnalysis.NAME       -   char
            %       MRIGraphAnalysis.CORR       -   options:
            %                                       MRIGraphAnalysis.CORR_PEARSON
            %                                       MRIGraphAnalysis.CORR_SPEARMAN
            %                                       MRIGraphAnalysis.CORR_KENDALL
            %                                       MRIGraphAnalysis.CORR_PARTIALPEARSON
            %                                       MRIGraphAnalysis.CORR_PARTIALSPEARMAN
            %       MRIGraphAnalysis.NEG        -   options:
            %                                       MRIGraphAnalysis.NEG_ZERO
            %                                       MRIGraphAnalysis.NEG_NONE
            %                                       MRIGraphAnalysis.NEG_ABS
            %
            % See also MRIGraphAnalysisWU, MRIGraphAnalysis, List.
            
            ga = ga@MRIGraphAnalysis(cohort,str, ...
                MRIGraphAnalysis.GRAPH, MRIGraphAnalysis.GRAPH_WU, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also MRIGraphAnalysisWU.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'MRIComparisonWU')
                    disp([Graph.NAME{m.getProp(MRIComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(MRIComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(MRIComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(MRIComparisonWU.GROUP1) ...
                        ' g2=' m.getPropValue(MRIComparisonWU.GROUP2) ...
                        ' v1=' m.getPropValue(MRIComparisonWU.VALUES1) ...
                        ' v2=' m.getPropValue(MRIComparisonWU.VALUES2) ...
                        ' p=' m.getPropValue(MRIComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(MRIComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(MRIComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'MRIRandomComparisonWU')
                    disp([Graph.NAME{m.getProp(MRIRandomComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(MRIRandomComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(MRIRandomComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(MRIRandomComparisonWU.GROUP1)...
                        ' v=' m.getPropValue(MRIRandomComparisonWU.VALUES1) ...
                        ' rand=' m.getPropValue(MRIRandomComparisonWU.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(MRIRandomComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(MRIRandomComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(MRIRandomComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'MRIMeasureWU')
                    disp([Graph.NAME{m.getProp(MRIMeasureWU.CODE)} ...
                        ' param=' m.getPropValue(MRIMeasureWU.PARAM) ...
                        ' notes=' m.getPropValue(MRIMeasureWU.NOTES) ...
                        ' g=' m.getPropValue(MRIMeasureWU.GROUP1) ...
                        ' v=' m.getPropValue(MRIMeasureWU.VALUES1) ...
                        ])
                end
            end
        end
        function [ms,mi] = getMeasures(ga,measurecode,g)
            % GETMEASURES gets available measures
            %
            % [MS,MI] = GETMEASURES(GA,MEASURECODE,G) returns the measure MS and hash table position
            %   MI of the measure specified by MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also MRIGraphAnalysisWU.
            
            mi = ga.ht_measure{measurecode}(g);
            ms = {};
            
            if mi>0
                ms{1} = ga.get(mi);
            end
        end
        function [m,mi] = getMeasure(ga,measurecode,g)
            % GETMEASURE gets measure from a given group
            %
            % [M,MI] = GETMEASURE(GA,MEASURECODE,G) returns the properties of the measure M and hash table
            %   position MI of the measure specified by MEASURECODE calculated for a group G in graph 
            %   analysis GA.
            %
            % See also MRIGraphAnalysisWU.
            
            [~,mi] = ga.getMeasures(measurecode,g);
            if mi>0
                m = ga.get(mi);
            else
                m = [];
            end
        end
        function [cs,ci] = getComparisons(ga,measurecode,g1,g2)
            % GETCOMPARISONS gets available comparisons
            %
            % [CS,CI] = GETCOMPARISONS(GA,MEASURECODE,G1,G2) returns the comparison CS and hash table position
            %   CI of the comparison specified by MEASURECODE calculated for the groups G1 and G2 in graph 
            %   analysis GA.
            %
            % See also MRIGraphAnalysisWU.
            
            ci = ga.ht_comparison{measurecode}(g1,g2);
            cs = {};
            if ci>0
                cs{1} = ga.get(ci);
            end
        end
        function [c,ci] = getComparison(ga,measurecode,g1,g2)
            % GETCOMPARSION gets comparison from given groups
            %
            % [C,CI] = GETCOMPARSION(GA,MEASURECODE,G1,G2) returns the properties of the comparison C and 
            %   hash table position CI of the comparison specified by MEASURECODE calculated for the groups 
            %   G1 and G2 in graph analysis GA.
            %
            % See also MRIGraphAnalysisWU.
            
            [~,ci] = ga.getComparisons(measurecode,g1,g2);
            if ci>0
                c = ga.get(ci);
            else
                c = [];
            end
        end
        function [ns,ni] = getRandomComparisons(ga,measurecode,g)
            % GETRANDOMCOMPARISONS gets available comparisons with random graphs
            %
            % [NS,NI] = GETRANDOMCOMPARISONS(GA,MEASURECODE,G) returns the comparisons with
            %   random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also MRIGraphAnalysisWU.

            ni = ga.ht_random_comparison{measurecode}(g);
            ns = {};
            if ni>0
                ns{1} = ga.get(ni);
            end
        end
        function [n,ni] = getRandomComparison(ga,measurecode,g)
            % GETRANDOMCOMPARISON gets comparison with random graphs from given group at specified density
            %
            % [N,NI] = GETRANDOMCOMPARISON(GA,MEASURECODE,G,DENSITY) returns the comparisons
            %   with random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G at specified density DENSITY in graph analysis GA.
            %
            % See also MRIGraphAnalysisWU.
            
            [~,ni] = ga.getRandomComparisons(measurecode,g);
            if ni>0
                n = ga.get(ni);
            else
                n = [];
            end
        end
        function m = calculate(ga,measurecode,g,varargin)
            % CALCULATE calculates measure
            %
            % M = CALCULATE(GA,MEASURECODE,G) returns the properties of the measure M after 
            %   calculating the measure specified by MEASURECODE for the group G in graph analysis GA.
            %
            % M = CALCULATE(GA,MEASURECODE,G,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphWU can be used.
            %
            % See also MRIGraphAnalysisWU, GraphWU.
            
            [m,mi] = ga.getMeasure(measurecode,g);
            
            if ~mi
                graph = GraphWU(ga.A{g},'Structure',ga.structure,varargin{:});
                res = graph.measure(measurecode);
                m = MRIMeasureWU( ...
                    MRIMeasureWU.CODE,measurecode, ...
                    MRIMeasureWU.GROUP1,g, ...
                    MRIMeasureWU.VALUES1,res);
                ga.add(m)
            end
        end
        function c = compare(ga,measurecode,g1,g2,varargin)
            % COMPARE calculates comparison
            %
            % C = COMPARE(GA,MEASURECODE,G1,G2) returns the properties of the comparison C after 
            %   calculating the measure specified by MEASURECODE for the groups G1 and G2 in graph 
            %   analysis GA.
            %
            % C = COMPARE(GA,MEASURECODE,G,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %   Additional admissible properties are:
            %       verbose          -   print the progress of the permutation test on the command line
            %                            true (default) | false
            %       interruptible    -   time for parallel execution of other codes 
            %                            [default = 0]
            %       m                -   number of permutations
            %                            [default = 1e+1]
            %       longitudinal     -   whether to make a longitudinal comparison
            %                            [default = false]
            %
            % See also MRIGraphAnalysisWU, GraphBU.
            
            % Whether to print progress messages to the command window [default = true]
            verbose = true;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'verbose')
                    verbose = varargin{n+1};
                end
            end
            
            % Whether the code should leave some time for parallel execution of other codes [default = 0]
            interruptible = 0;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'interruptible')
                    interruptible = varargin{n+1};
                end
            end
            
            % Number of permutations
            M = 1e+3;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'m')
                    M = varargin{n+1};
                end
            end
            
            % Whether to make a longitudinal comparison [default = false]
            longitudinal = false;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'longitudinal')
                    longitudinal = varargin{n+1};
                end
            end
            
            [c,ci] = ga.getComparison(measurecode,g1,g2);
            
            if ~ci

                m1 = ga.calculate(measurecode,g1,varargin{:});
                res1 = m1.getProp(MRIMeasure.VALUES1);
                
                m2 = ga.calculate(measurecode,g2,varargin{:});
                res2 = m2.getProp(MRIMeasure.VALUES1);
                
                data1 = ga.data{g1};
                data2 = ga.data{g2};
                data = [data1; data2];
                
                all1 = zeros(M,numel(res1));
                all2 = zeros(M,numel(res2));
                
                subs1 = find(ga.cohort.getGroup(g1).getProp(Group.DATA)==true);
                subs2 = find(ga.cohort.getGroup(g2).getProp(Group.DATA)==true);
                subs1 = [1:1:numel(subs1)];
                subs2 = numel(subs1)+[1:1:numel(subs2)];
                substmp = [subs1 subs2];
                
                start = tic;
                for i = 1:1:M
                    if verbose
                        disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                    end
                    
                    if longitudinal
                        max = min(numel(subs1),numel(subs2));
                        perm = sign(randn(1,max));
                        perm1 = subs1;
                        perm2 = subs2;
                        perm1(perm==1) = subs2(perm==1);
                        perm2(perm==1) = subs1(perm==1);
                    else
                        perm1 = sort( randperm(numel(substmp),numel(subs1)) );
                        perm2 = [1:1:numel(substmp)];
                        perm2(perm1) = 0;
                        perm2 = perm2(perm2>0);
                    end
                    
                    dataperm1 = data(perm1,:);
                    A1 = ga.adjmatrix(dataperm1);
                    graphperm1 = GraphWU(A1,'Structure',ga.structure,varargin{:});
                    mperm1 = graphperm1.measure(measurecode);
                    
                    dataperm2 = data(perm2,:);
                    A2 = ga.adjmatrix(dataperm2);
                    graphperm2 = GraphWU(A2,'Structure',ga.structure,varargin{:});
                    mperm2 = graphperm2.measure(measurecode);
                    
                    all1(i,:) = reshape(mperm1,1,numel(mperm1));
                    all2(i,:) = reshape(mperm2,1,numel(mperm2));
                    
                    if interruptible
                        pause(interruptible)
                    end
                end
                
                dm = res2 - res1;
                dall = all2 - all1;
                
                p_single = pvalue1(dm,dall);
                p_double = pvalue2(dm,dall);
                percentiles = quantiles(dall,100);

                c = MRIComparisonWU( ...
                    MRIComparisonWU.CODE,measurecode, ...
                    MRIComparisonWU.GROUP1,g1, ...
                    MRIComparisonWU.VALUES1,res1, ...
                    MRIComparisonWU.GROUP2,g2, ...
                    MRIComparisonWU.VALUES2,res2, ...
                    MRIComparisonWU.PVALUE1,p_single, ...
                    MRIComparisonWU.PVALUE2,p_double, ...
                    MRIComparisonWU.PERCENTILES,percentiles, ...
                    MRIComparisonWU.PARAM,M);

                ga.add(c)
            end
        end
        function n = randomcompare(ga,measurecode,g,varargin)
            % RANDOMCOMPARE calculates comparison
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY) returns the properties of the comparison
            %   with random graphs N after calculating the measure specified by MEASURECODE for the group G
            %   at specified density DENSITY in graph analysis GA.
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %   Additional admissible properties are:
            %       verbose         -   print the progress of the permutation test on the command line true 
            %                           (default) | false
            %       interruptible   -   time for parallel execution of other codes
            %                           [default = 0]
            %       m               -   number of permutations
            %                           [default = 1e+1]
            %       swaps           -   number of swaps to create random matrix
            %                           [default = 5]
            %
            % See also MRIGraphAnalysisWU, GraphBU.
            
            % Whether to print progress messages to the command window [default = true]
            verbose = true;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'verbose')
                    verbose = varargin{n+1};
                end
            end
            
            % Whether the code should leave some time for parallel
            % execution of other codes [default = 0]
            interruptible = 0;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'interruptible')
                    interruptible = varargin{n+1};
                end
            end
            
            % Number of random matrixes to be compared with
            M = 1e+1;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'m')
                    M = varargin{n+1};
                end
            end
            
            % how much swaps to create random matrix
            bin_swaps = 5;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'swaps')
                    bin_swaps = varargin{n+1};
                end
            end
            
            [n,ni] = ga.getRandomComparison(measurecode,g);
            
            if ~ni
                
                m = ga.calculate(measurecode,g,varargin{:});
                res = m.getProp(MRIMeasureWU.VALUES1);
                
                graph = GraphWU(ga.A{g},'Structure',ga.structure,varargin{:});
                results = cell(1,M);
                start = tic;
                
                for c = 1:1:M
                    if verbose
                        disp(['** RANDOM GRAPH - sampling #' int2str(c) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                    end
                    
                    [random_gr,~] = graph.randomize(bin_swaps);
                    temp_res = random_gr.measure(measurecode);
                    results{1,c} = temp_res;
                    
                    if interruptible
                        pause(interruptible)
                    end
                    
                end
                
                resall = zeros(M,length(results{1,1}));
                for i = 1:1:M
                    resall(i,:) = results{1,i};
                end
                
                p_single = pvalue1(res,resall);
                p_double = pvalue2(res,resall);
                percentiles = quantiles(resall,100);
                rand_res = mean(resall);
                
                n = MRIRandomComparisonWU( ...
                    MRIRandomComparisonWU.CODE,measurecode, ...
                    MRIRandomComparisonWU.GROUP1,g, ...
                    MRIRandomComparisonWU.VALUES1,res, ...
                    MRIRandomComparisonWU.RANDOM_COMP_VALUES,rand_res, ...
                    MRIRandomComparisonWU.PVALUE1,p_single, ...
                    MRIRandomComparisonWU.PVALUE2,p_double, ...
                    MRIRandomComparisonWU.PERCENTILES,percentiles, ...
                    MRIRandomComparisonWU.PARAM,M);
                
                ga.add(n)
            end
            
        end
    end
    methods (Access = protected)
        function initialize_hashtables(ga)
            % INITIALIZE_HASTABLES intializes hashtables
            %
            % INITIALIZE_HASTABLES(GA) initalizes the sparse matrices to be
            %   used as hashtables. 
            %
            % See also MRIGraphAnalysisWU.
            
            ga.ht_measure = {};
            ga.ht_comparison = {};
            ga.ht_random_comparison = {};
            
            for m = 1:1:GraphWU.measurenumber()
                D = ga.cohort.groupnumber();
                ga.ht_measure{GraphWU.MEASURES_WU(m)} = sparse(1,D);
                ga.ht_comparison{GraphWU.MEASURES_WU(m)} = sparse(D,D);
                ga.ht_random_comparison{GraphWU.MEASURES_WU(m)} = sparse(1,D);
            end
        end
    end
    methods (Static)
        function index = getIndex(m)
            % GETINDEX calculates measure index
            %
            % GETINDEX(M) calculates the index of the measure M. 
            %
            % See also MRIGraphAnalysisWU.
            
            Check.isa('Error: The measure m must be a MRIMeasureWU',m,'MRIMeasureWU')
            
            if m.isMeasure()
                [~,g] = m.hash();
                index = g;
            elseif m.isComparison()
                [~,g1,g2] = m.hash();
                index = [g1 g2];
            else % m.isRandom()
                [~,g] = m.hash();
                index = g;
            end
        end
        function class = elementClass()
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'MRIMeasureWU'.
            %
            % See also MRIGraphAnalysisWU, MRIMeasureWU.
            
            class = 'MRIMeasureWU';
        end
        function m = element()
            % ELEMENT creates new MRI measure of a weighted undirected graph
            %
            % M = ELEMENT() returns a MRI measure M of a weighted undirected graph.
            %
            % See also MRIGraphAnalysisWU, MRIMeasureWU.
            
            m = MRIMeasureWU();
        end
    end
end