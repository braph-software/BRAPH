classdef PETGraphAnalysisBUD < PETGraphAnalysis
    % PETGraphAnalysisBUD < PETGraphAnalysis : Graph analysis of fixed density binary undirected PET
    %   PETGraphAnalysisBUD represents a list of measures used for graph analysis of PET data based 
    %   on binary undirected graphs with fixed density.
    %
    % PETGraphAnalysisBUD properties (Access = protected):
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
    % PETGraphAnalysisBUD properties (Constant):
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
    % PETGraphAnalysisBUD methods (Access = protected):
    %   initialize             -   initializes graph analysis < PETGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %   copyElement             -   deep copy < PETGraphAnalysis
    %
    % PETGraphAnalysisBUD methods:
    %   PETGraphAnalysisBUD     -   constructor
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
    %   getMeasure              -   gets measure from a given group at specified density
    %   getComparisons          -   gets available comparisons
	%   getComparison           -   gets comparison from given groups at specified density
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets comparison with random graphs from given group at specified density
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare           -   calculates random comparison
    %
    % PETGraphAnalysisBUD methods (Static):
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
    % See also PETGraphAnalysisBUT, PETGraphAnalysis ,PETGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = PETGraphAnalysisBUD(cohort,structure,varargin)
            % PETGRAPHANALYSISBUD(COHORT,STRUCTURE) creates a PET graph analysis using
            %   the cohort COHORT and community structure STRUCTURE. This analysis has
            %   default properties and uses a binary undirected graph with fixed density.
            %
            % PETGRAPHANALYSISBUD(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes
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
            % See also PETGraphAnalysisBUD, PETGraphAnalysis, List.

            ga = ga@PETGraphAnalysis(cohort,structure, ...
                PETGraphAnalysis.GRAPH, PETGraphAnalysis.GRAPH_BUD, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also PETGraphAnalysisBUD.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'PETComparisonBUD')
                    disp([Graph.NAME{m.getProp(PETComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(PETComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(PETComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(PETComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(PETComparisonBUD.THRESHOLD1) ...
                        ' t2=' m.getPropValue(PETComparisonBUD.THRESHOLD2) ...
                        ' g1=' m.getPropValue(PETComparisonBUD.GROUP1)...
                        ' g2=' m.getPropValue(PETComparisonBUD.GROUP2) ...
                        ' v1=' m.getPropValue(PETComparisonBUD.VALUES1) ...
                        ' v2=' m.getPropValue(PETComparisonBUD.VALUES2) ...
                        ' p=' m.getPropValue(PETComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(PETComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(PETComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'PETRandomComparisonBUD')
                    disp([Graph.NAME{m.getProp(PETRandomComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(PETRandomComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(PETRandomComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(PETRandomComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(PETRandomComparisonBUD.THRESHOLD1) ...
                        ' g1=' m.getPropValue(PETRandomComparisonBUD.GROUP1)...
                        ' v=' m.getPropValue(PETRandomComparisonBUD.VALUES1) ...
                        ' rand=' m.getPropValue(PETRandomComparisonBUD.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(PETRandomComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(PETRandomComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(PETRandomComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'PETMeasureBUD')
                    disp([Graph.NAME{m.getProp(PETMeasureBUD.CODE)} ...
                        ' param=' m.getPropValue(PETMeasureBUD.PARAM) ...
                        ' notes=' m.getPropValue(PETMeasureBUD.NOTES) ...
                        ' d=' m.getPropValue(PETMeasureBUD.DENSITY) ...
                        ' t=' m.getPropValue(PETMeasureBUD.THRESHOLD1) ...
                        ' g=' m.getPropValue(PETMeasureBUD.GROUP1) ...
                        ' v=' m.getPropValue(PETMeasureBUD.VALUES1) ...
                        ])
                end
            end
        end
        function [ms,mi] = getMeasures(ga,measurecode,g)
            % GETMEASURES gets available measures
            %
            % [MS,MI] = GETMEASURES(GA,MEASURECODE,G) returns the measures MS and hash table position
            %   MI of the measure specified by MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also PETGraphAnalysisBUD.
            
            indices = find(ga.ht_measure{measurecode}~=0);
            indices = indices(reg2int(indices,PETMeasureBUD.DENSITY_LEVELS)==g);
            
            mi = zeros(1,length(indices));
            ms = cell(1,length(indices));
            for i = 1:1:length(indices)
                mi(i) = ga.ht_measure{measurecode}(indices(i));
                ms{i} = ga.get(mi(i));
            end
        end
        function [m,mi] = getMeasure(ga,measurecode,g,density)
            % GETMEASURE gets measure from a given group at specified density
            %
            % [M,MI] = GETMEASURE(GA,MEASURECODE,G,DENSITY) returns the measure M and hash table position
            %   MI of the measure specified by MEASURECODE calculated for a group G at specified density
            %   DENSITY in graph analysis GA.
            %
            % See also PETGraphAnalysisBUD.
            
            graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure);
            mt = PETMeasureBUD( ...
                PETMeasureBUD.CODE,measurecode, ...
                PETMeasureBUD.GROUP1,g, ...
                PETMeasureBUD.DENSITY,graph.density ...                
                );
            
            [~,mi] = ga.existMeasure(mt);
            if mi>0
                m = ga.get(mi);
            else
                m = [];
            end
        end
        function [cs,ci] = getComparisons(ga,measurecode,g1,g2)
            % GETCOMPARISONS gets available comparisons
            %
            % [CS,CI] = GETCOMPARISONS(GA,MEASURECODE,G1,G2) returns the comparisons CS and hash table position
            %   CI of the comparison specified by MEASURECODE calculated for the groups G1 and G2 in graph 
            %   analysis GA.
            %
            % See also PETGraphAnalysisBUD.
            
            [indices1t,indices2t] = find(ga.ht_comparison{measurecode}~=0);
            indices1 = indices1t(reg2int(indices1t,PETMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,PETMeasureBUD.DENSITY_LEVELS)==g2);
            indices2 = indices2t(reg2int(indices1t,PETMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,PETMeasureBUD.DENSITY_LEVELS)==g2);
            
            ci = zeros(1,length(indices1));
            cs = cell(1,length(indices1));
            for i = 1:1:length(indices1)
                ci(i) = ga.ht_comparison{measurecode}(indices1(i),indices2(i));                
                cs{i} = ga.get(ga.ht_comparison{measurecode}(indices1(i),indices2(i)));
            end
        end
        function [c,ci] = getComparison(ga,measurecode,g1,g2,density)
            % GETCOMPARISON gets comparison from given groups at specified density
            %
            % [C,CI] = GETCOMPARISON(GA,MEASURECODE,G1,G2,DENSITY) returns the comparison C and hash table 
            %   position CI of the comparison specified by MEASURECODE calculated for the groups G1 and G2
            %   at specified density DENSITY in graph analysis GA.
            %
            % See also PETGraphAnalysisBUD.
            
            graph1 = GraphBU(ga.A{g1},'Density',density,'Structure',ga.structure);
            graph2 = GraphBU(ga.A{g2},'Density',density,'Structure',ga.structure);
            ct = PETComparisonBUD( ...
                PETComparisonBUD.CODE,measurecode, ...
                PETComparisonBUD.GROUP1,g1, ...
                PETComparisonBUD.GROUP2,g2, ...
                PETComparisonBUD.DENSITY,(graph1.density + graph2.density)/2 ...
                );
            
            [~,ci] = ga.existComparison(ct);
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
            % See also PETGraphAnalysisBUD.

            indices = find(ga.ht_random_comparison{measurecode}~=0);
            indices = indices(reg2int(indices,PETMeasureBUD.DENSITY_LEVELS)==g);
            
            ni = zeros(1,length(indices));
            ns = cell(1,length(indices));
            for i = 1:1:length(indices)
                ni(i) = ga.ht_random_comparison{measurecode}(indices(i));
                ns{i} = ga.get(ni(i));
            end
        end
        function [n,ni] = getRandomComparison(ga,measurecode,g,density)
            % GETRANDOMCOMPARISON gets comparison with random graphs from given group at specified density
            %
            % [N,NI] = GETRANDOMCOMPARISON(GA,MEASURECODE,G,DENSITY) returns the comparisons
            %   with random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G at specified density DENSITY in graph analysis GA.
            %
            % See also PETGraphAnalysisBUD.

            graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure);
            nt = PETRandomComparisonBUD( ...
                PETRandomComparisonBUD.CODE,measurecode, ...
                PETRandomComparisonBUD.GROUP1,g, ...
                PETRandomComparisonBUD.DENSITY,graph.density ...
                );
            
            [~,ni] = ga.existRandom(nt);
            if ni>0
                n = ga.get(ni);
            else
                n = [];
            end
        end
        function m = calculate(ga,measurecode,g,density,varargin)
            % CALCULATE calculates measure
            %
            % M = CALCULATE(GA,MEASURECODE,G,DENSITY) returns the properties of the measure M after 
            %   calculating the measure specified by MEASURECODE for the group G at specified density 
            %   DENSITY in graph analysis GA.
            %
            % M = CALCULATE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property 
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
            %
            % See also PETGraphAnalysisBUD, GraphBU.
            
            [m,mi] = ga.getMeasure(measurecode,g,density);

            if ~mi
                graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure,varargin{:});
                res = graph.measure(measurecode);
                m = PETMeasureBUD( ...
                    PETMeasureBUD.CODE,measurecode, ...
                    PETMeasureBUD.DENSITY,graph.density(), ...
                    PETMeasureBUD.THRESHOLD1,graph.threshold(), ...
                    PETMeasureBUD.GROUP1,g, ...
                    PETMeasureBUD.VALUES1,res);
                ga.add(m)                
            end
        end
        function c = compare(ga,measurecode,g1,g2,density,varargin)
            % COMPARE calculates comparison
            %
            % C = COMPARE(GA,MEASURECODE,G1,G2,DENSITY) returns the properties of the comparison C after 
            %   calculating the measure specified by MEASURECODE for the groups G1 and G2 at specified density 
            %   DENSITY in graph analysis GA.
            %
            % C = COMPARE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property 
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
            % See also PETGraphAnalysisBUD, GraphBU.
            
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
            
            % Number of permutations
            M = 1e+1;
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
            
            [c,ci] = ga.getComparison(measurecode,g1,g2,density);
            
            if ~ci
                
                m1 = ga.calculate(measurecode,g1,density,varargin{:});
                res1 = m1.getProp(PETMeasureBUD.VALUES1);
                
                m2 = ga.calculate(measurecode,g2,density,varargin{:});
                res2 = m2.getProp(PETMeasureBUD.VALUES1);
                
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
                for c = 1:1:M
                    if verbose
                        disp(['** PERMUTATION TEST - sampling #' int2str(c) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
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
                    graphperm1 = GraphBU(A1,'Density',density,'Structure',ga.structure,varargin{:});
                    mperm1 = graphperm1.measure(measurecode);
                    
                    dataperm2 = data(perm2,:);
                    A2 = ga.adjmatrix(dataperm2);
                    graphperm2 = GraphBU(A2,'Density',density,'Structure',ga.structure,varargin{:});
                    mperm2 = graphperm2.measure(measurecode);
                    
                    all1(c,:) = reshape(mperm1,1,numel(mperm1));
                    all2(c,:) = reshape(mperm2,1,numel(mperm2));
                    
                    if interruptible
                        pause(interruptible)
                    end
                end
                
                dm = res2 - res1;
                dall = all2 - all1;
            
                p_single = pvalue1(dm,dall);
                p_double = pvalue2(dm,dall);
                percentiles = quantiles(dall,100);
                
                c = PETComparisonBUD( ...
                    PETComparisonBUD.CODE,measurecode, ...
                    PETComparisonBUD.DENSITY,(m1.getProp(PETMeasureBUD.DENSITY) + m2.getProp(PETMeasureBUD.DENSITY))/2, ...
                    PETComparisonBUD.THRESHOLD1,m1.getProp(PETMeasureBUD.THRESHOLD1), ...
                    PETComparisonBUD.THRESHOLD2,m2.getProp(PETMeasureBUD.THRESHOLD1), ...
                    PETComparisonBUD.GROUP1,g1, ...
                    PETComparisonBUD.VALUES1,res1, ...
                    PETComparisonBUD.GROUP2,g2, ...
                    PETComparisonBUD.VALUES2,res2, ...
                    PETComparisonBUD.PVALUE1,p_single, ...
                    PETComparisonBUD.PVALUE2,p_double, ...
                    PETComparisonBUD.PERCENTILES,percentiles, ...
                    PETComparisonBUD.PARAM,M);
                
                ga.add(c)
            end
        end
        function n = randomcompare(ga,measurecode,g,density,varargin)
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
            % See also PETGraphAnalysisBUD, GraphBU.

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
            
            % How many swaps to create random matrix
            bin_swaps = 5;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'swaps')
                    bin_swaps = varargin{n+1};
                end
            end
            
            [n,ni] = ga.getRandomComparison(measurecode,g,density);
            
            if ~ni
                
                m = ga.calculate(measurecode,g,density,varargin{:});
                res = m.getProp(PETMeasureBUD.VALUES1);
                
                graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure,varargin{:});
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
                if M == 1
                    rand_res = resall;
                else
                    rand_res = mean(resall);
                end
                
                n = PETRandomComparisonBUD( ...
                    PETRandomComparisonBUD.CODE,measurecode, ...
                    PETRandomComparisonBUD.DENSITY,m.getProp(PETMeasureBUD.DENSITY), ...
                    PETRandomComparisonBUD.THRESHOLD1,m.getProp(PETMeasureBUD.THRESHOLD1), ...
                    PETRandomComparisonBUD.GROUP1,g, ...
                    PETRandomComparisonBUD.VALUES1,res, ...
                    PETRandomComparisonBUD.RANDOM_COMP_VALUES,rand_res, ...
                    PETRandomComparisonBUD.PVALUE1,p_single, ...
                    PETRandomComparisonBUD.PVALUE2,p_double, ...
                    PETRandomComparisonBUD.PERCENTILES,percentiles, ...
                    PETRandomComparisonBUD.PARAM,M);
                
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
            % See also PETGraphAnalysisBUD.
            
            ga.ht_measure = {};
            ga.ht_comparison = {};
            ga.ht_random_comparison = {};
            
            for m = 1:1:GraphBU.measurenumber()
                D = ga.cohort.groupnumber() * PETMeasureBUD.DENSITY_LEVELS;
                ga.ht_measure{GraphBU.MEASURES_BU(m)} = sparse(1,D);
                ga.ht_comparison{GraphBU.MEASURES_BU(m)} = sparse(D,D);
                ga.ht_random_comparison{GraphBU.MEASURES_BU(m)} = sparse(1,D);
            end
        end
    end
    methods (Static)
        function index = getIndex(m)
            % GETINDEX calculates measure index
            %
            % GETINDEX(M) calculates the index of the measure M.
            %
            % See also PETGraphAnalysisBUD.
            
            Check.isa('Error: The measure m must be a PETMeasureBUD',m,'PETMeasureBUD')
            
            if m.isMeasure()
                [~,g,d] = m.hash();
                index = int2reg(g,d,PETMeasureBUD.DENSITY_LEVELS);
            elseif m.isComparison()
                [~,g1,g2,d] = m.hash();
                index = [int2reg(g1,d,PETMeasureBUD.DENSITY_LEVELS) int2reg(g2,d,PETMeasureBUD.DENSITY_LEVELS)];
            else % m.isRandom()
                [~,g,d] = m.hash();
                index = int2reg(g,d,PETMeasureBUD.DENSITY_LEVELS);
            end
        end
        function class = elementClass()
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'PETMeasureBUD'.
            %
            % See also PETGraphAnalysisBUD, PETMeasureBUD.
            
            class = 'PETMeasureBUD';
        end
        function m = element()
            % ELEMENT creates new PET measure of a binary undirected graph
            %
            % M = ELEMENT() returns a PET measure M of a binary undirected graph with fixed density.
            %
            % See also PETGraphAnalysisBUD, PETMeasureBUD.
            
            m = PETMeasureBUD();
        end
    end
end