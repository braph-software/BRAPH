classdef PETGraphAnalysisWU < PETGraphAnalysis
    % PETGraphAnalysisWU < PETGraphAnalysis : Graph analysis of weighted undirected PET
    %   PETGraphAnalysisWU represents a list of measures used for graph analysis of PET data based 
    %   on weighted undirected graphs.
    %
    % PETGraphAnalysisWU properties (Access = protected):
    %   props           -   cell array of object properties < ListElement
    %   elements        -   cell array of list elements < List
    %   path            -   XML file path < List
    %   file            -   XML file name < List
    %   cohort          -   cohort (PETCohort) < PETGraphAnalysis
    %   data            -   subject data (cell array; matrix; one per group) < PETGraphAnalysis
    %   A               -   adjaciency matrix (cell array; matrix; one per group) < PETGraphAnalysis
    %   P               -   correlation p-value matrix (cell array; matrix; one per group) < PETGraphAnalysis      
    %   structure       -   community structure < PETGraphAnalysis
    %   ht_measure      -   hashtable for measure (cell array; sparse vectors; one per measure) < PETGraphAnalysis
    %   ht_comparison   -   hashtable for comparison (cell array; sparse matrices; one per measure) < PETGraphAnalysis
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure)
    %
    % PETGraphAnalysisWU properties (Constant):
    %   NAME            -   name numeric code < PETGraphAnalysis
    %   NAME_TAG        -   name tag < PETGraphAnalysis
    %   NAME_FORMAT     -   name format < PETGraphAnalysis
    %   NAME_DEFAULT    -   name default < PETGraphAnalysis
    %
    %   GRAPH           -   graph numeric code < PETGraphAnalysis
    %   GRAPH_TAG       -   graph tag < PETGraphAnalysis
    %   GRAPH_FORMAT    -   graph format < PETGraphAnalysis
    %   GRAPH_WU        -   graph 'wu' option < PETGraphAnalysis
    %   GRAPH_BUT       -   graph 'but' option < PETGraphAnalysis
    %   GRAPH_BUD       -   graph 'bud' option < PETGraphAnalysis
    %   GRAPH_OPTIONS   -   array of graph options < PETGraphAnalysis
    %   GRAPH_DEFAULT   -   graph default < PETGraphAnalysis
    %
    %   CORR                    -   correlation numeric code < PETGraphAnalysis
    %   CORR_TAG                -   correlation tag < PETGraphAnalysis
    %   CORR_FORMAT             -   correlation format < PETGraphAnalysis
    %   CORR_PEARSON            -   correlation 'pearson' option < PETGraphAnalysis
    %   CORR_SPEARMAN           -   correlation 'spearman' option < PETGraphAnalysis
    %   CORR_KENDALL            -   correlation 'kendall' option < PETGraphAnalysis
    %   CORR_PARTIALPEARSON     -   correlation 'partial pearson' option < PETGraphAnalysis
    %   CORR_PARTIALSPEARMAN    -   correlation 'partial spearman' option < PETGraphAnalysis
    %   CORR_OPTIONS            -   array of correlation options < PETGraphAnalysis
    %   CORR_DEFAULT            -   correlation default < PETGraphAnalysis
    %
    %   NEG             -   negative correlations numeric code < PETGraphAnalysis
    %   NEG_TAG         -   negative correlations tag < PETGraphAnalysis
    %   NEG_FORMAT      -   negative correlations format < PETGraphAnalysis
    %   NEG_ZERO        -   negative correlations 'zero' option < PETGraphAnalysis
    %   NEG_NONE        -   negative correlations 'none' option < PETGraphAnalysis
    %   NEG_ABS         -   negative correlations 'abs' option < PETGraphAnalysis
    %   NEG_OPTIONS     -   array of negative correlations options < PETGraphAnalysis
    %   NEG_DEFAULT     -   negative correlations default < PETGraphAnalysis
    %
    % PETGraphAnalysisWU methods (Access = protected):
    %   initialize             -   initializes graph analysis < PETGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %   copyElement             -   deep copy < PETGraphAnalysis
    %
    % PETGraphAnalysisWU methods:
    %   PETGraphAnalysisWU     -   constructor
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
    %   adjmatrix               -   calculates the adjaciency matrix < PETGraphAnalysis
    %   getCohort               -   returns cohort of a graph analysis < PETGraphAnalysis
    %   getStructure            -   returns community structure of graph analysis
    %   getBrainAtlas           -   returns atlas of graph analysis < PETGraphAnalysis
    %   getPlotBrainSurf        -   generates new PlotBrainSurf < PETGraphAnalysis
    %   getPlotBrainAtlas       -   generates new PlotBrainAtlas < PETGraphAnalysis
    %   getPlotBrainGraph       -   generates new PlotBrainGraph < PETGraphAnalysis
    %   getSubjectData          -   returns data of subjects < PETGraphAnalysis
    %   getA                    -   returns adjaciency matrix < PETGraphAnalysis
    %   getP                    -   returns correlations p-value matrix < PETGraphAnalysis
    %   exist                   -   tests whether a given measure/comparison exists < PETGraphAnalysis
    %   existMeasure            -   tests whether a given measure exists < PETGraphAnalysis
    %   existComparison         -   tests whether a given comparison exists < PETGraphAnalysis
    %   existRandom             -   tests whether a given comparison with random graphs exists
    %   add                     -   adds measure < PETGraphAnalysis
    %   remove                  -   removes measure < PETGraphAnalysis
    %   replace                 -   replaces measure < PETGraphAnalysis
    %   toXML                   -   creates XML Node from graph analysis < PETGraphAnalysis
    %   fromXML                 -   loads graph analysis from XML Node < PETGraphAnalysis
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
    % PETGraphAnalysisWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < PETGraphAnalysis
    %   getTags         -   cell array of strings with the tags of the properties < PETGraphAnalysis
    %   getFormats      -   cell array with the formats of the properties < PETGraphAnalysis
    %   getDefaults     -   cell array with the defaults of the properties < PETGraphAnalysis
    %   getOptions      -   cell array with options (only for properties with options format) < PETGraphAnalysis
    %   getIndex        -   get index used in calculation of hash values
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % See also PETGraphAnalysisBUT, PETGraphAnalysis ,PETGraphAnalysisBUD, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = PETGraphAnalysisWU(cohort,str,varargin)
            % PETGRAPHANALYSISWU(COHORT,STRUCTURE) creates a PET graph analysis using
            %   the cohort COHORT and community structure STRUCTURE. This analysis has
            %   default properties and uses a weighted undirected graph.
            %
            % PETGRAPHANALYSISWU(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes
            %   property Tag1 to Value1, Tag2 to Value2, ... .
            %   Admissible properties are:
            %       PETGraphAnalysis.NAME       -   char
            %       PETGraphAnalysis.CORR       -   options:
            %                                       PETGraphAnalysis.CORR_PEARSON
            %                                       PETGraphAnalysis.CORR_SPEARMAN
            %                                       PETGraphAnalysis.CORR_KENDALL
            %                                       PETGraphAnalysis.CORR_PARTIALPEARSON
            %                                       PETGraphAnalysis.CORR_PARTIALSPEARMAN
            %       PETGraphAnalysis.NEG        -   options:
            %                                       PETGraphAnalysis.NEG_ZERO
            %                                       PETGraphAnalysis.NEG_NONE
            %                                       PETGraphAnalysis.NEG_ABS
            %
            % See also PETGraphAnalysisWU, PETGraphAnalysis, List.
            
            ga = ga@PETGraphAnalysis(cohort,str, ...
                PETGraphAnalysis.GRAPH, PETGraphAnalysis.GRAPH_WU, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also PETGraphAnalysisWU.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'PETComparisonWU')
                    disp([Graph.NAME{m.getProp(PETComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(PETComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(PETComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(PETComparisonWU.GROUP1) ...
                        ' g2=' m.getPropValue(PETComparisonWU.GROUP2) ...
                        ' v1=' m.getPropValue(PETComparisonWU.VALUES1) ...
                        ' v2=' m.getPropValue(PETComparisonWU.VALUES2) ...
                        ' p=' m.getPropValue(PETComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(PETComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(PETComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'PETRandomComparisonWU')
                    disp([Graph.NAME{m.getProp(PETRandomComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(PETRandomComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(PETRandomComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(PETRandomComparisonWU.GROUP1)...
                        ' v=' m.getPropValue(PETRandomComparisonWU.VALUES1) ...
                        ' rand=' m.getPropValue(PETRandomComparisonWU.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(PETRandomComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(PETRandomComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(PETRandomComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'PETMeasureWU')
                    disp([Graph.NAME{m.getProp(PETMeasureWU.CODE)} ...
                        ' param=' m.getPropValue(PETMeasureWU.PARAM) ...
                        ' notes=' m.getPropValue(PETMeasureWU.NOTES) ...
                        ' g=' m.getPropValue(PETMeasureWU.GROUP1) ...
                        ' v=' m.getPropValue(PETMeasureWU.VALUES1) ...
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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU.

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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU, GraphWU.
            
            [m,mi] = ga.getMeasure(measurecode,g);
            
            if ~mi
                graph = GraphWU(ga.A{g},'Structure',ga.structure,varargin{:});
                res = graph.measure(measurecode);
                m = PETMeasureWU( ...
                    PETMeasureWU.CODE,measurecode, ...
                    PETMeasureWU.GROUP1,g, ...
                    PETMeasureWU.VALUES1,res);
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
            % See also PETGraphAnalysisWU, GraphBU.
            
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
                res1 = m1.getProp(PETMeasure.VALUES1);
                
                m2 = ga.calculate(measurecode,g2,varargin{:});
                res2 = m2.getProp(PETMeasure.VALUES1);
                
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

                c = PETComparisonWU( ...
                    PETComparisonWU.CODE,measurecode, ...
                    PETComparisonWU.GROUP1,g1, ...
                    PETComparisonWU.VALUES1,res1, ...
                    PETComparisonWU.GROUP2,g2, ...
                    PETComparisonWU.VALUES2,res2, ...
                    PETComparisonWU.PVALUE1,p_single, ...
                    PETComparisonWU.PVALUE2,p_double, ...
                    PETComparisonWU.PERCENTILES,percentiles, ...
                    PETComparisonWU.PARAM,M);

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
            % See also PETGraphAnalysisWU, GraphBU.
            
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
                res = m.getProp(PETMeasureWU.VALUES1);
                
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
                
                n = PETRandomComparisonWU( ...
                    PETRandomComparisonWU.CODE,measurecode, ...
                    PETRandomComparisonWU.GROUP1,g, ...
                    PETRandomComparisonWU.VALUES1,res, ...
                    PETRandomComparisonWU.RANDOM_COMP_VALUES,rand_res, ...
                    PETRandomComparisonWU.PVALUE1,p_single, ...
                    PETRandomComparisonWU.PVALUE2,p_double, ...
                    PETRandomComparisonWU.PERCENTILES,percentiles, ...
                    PETRandomComparisonWU.PARAM,M);
                
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
            % See also PETGraphAnalysisWU.
            
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
            % See also PETGraphAnalysisWU.
            
            Check.isa('Error: The measure m must be a PETMeasureWU',m,'PETMeasureWU')
            
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
            %   i.e., the string 'PETMeasureWU'.
            %
            % See also PETGraphAnalysisWU, PETMeasureWU.
            
            class = 'PETMeasureWU';
        end
        function m = element()
            % ELEMENT creates new PET measure of a weighted undirected graph
            %
            % M = ELEMENT() returns a PET measure M of a weighted undirected graph.
            %
            % See also PETGraphAnalysisWU, PETMeasureWU.
            
            m = PETMeasureWU();
        end
    end
end