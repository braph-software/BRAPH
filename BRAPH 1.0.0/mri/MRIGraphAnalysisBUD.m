classdef MRIGraphAnalysisBUD < MRIGraphAnalysis
    % MRIGraphAnalysisBUD < MRIGraphAnalysis : Graph analysis of fixed density binary undirected MRI
    %   MRIGraphAnalysisBUD represents a list of measures used for graph analysis of MRI data based 
    %   on binary undirected graphs with fixed density.
    %
    % MRIGraphAnalysisBUD properties (Access = protected):
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
    % MRIGraphAnalysisBUD properties (Constant):
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
    % MRIGraphAnalysisBUD methods (Access = protected):
    %   initialize             -   initializes graph analysis < MRIGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %   copyElement             -   deep copy < MRIGraphAnalysis
    %
    % MRIGraphAnalysisBUD methods:
    %   MRIGraphAnalysisBUD     -   constructor
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
    %   getMeasure              -   gets measure from a given group at specified density
    %   getComparisons          -   gets available comparisons
	%   getComparison           -   gets comparison from given groups at specified density
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets comparison with random graphs from given group at specified density
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare           -   calculates random comparison
    %
    % MRIGraphAnalysisBUD methods (Static):
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
    % See also MRIGraphAnalysisBUT, MRIGraphAnalysis ,MRIGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = MRIGraphAnalysisBUD(cohort,structure,varargin)
            % MRIGRAPHANALYSISBUD(COHORT,STRUCTURE) creates a MRI graph analysis using
            %   the cohort COHORT and community structure STRUCTURE. This analysis has
            %   default properties and uses a binary undirected graph with fixed density.
            %
            % MRIGRAPHANALYSISBUD(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes
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
            % See also MRIGraphAnalysisBUD, MRIGraphAnalysis, List.

            ga = ga@MRIGraphAnalysis(cohort,structure, ...
                MRIGraphAnalysis.GRAPH, MRIGraphAnalysis.GRAPH_BUD, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also MRIGraphAnalysisBUD.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'MRIComparisonBUD')
                    disp([Graph.NAME{m.getProp(MRIComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(MRIComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(MRIComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(MRIComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(MRIComparisonBUD.THRESHOLD1) ...
                        ' t2=' m.getPropValue(MRIComparisonBUD.THRESHOLD2) ...
                        ' g1=' m.getPropValue(MRIComparisonBUD.GROUP1)...
                        ' g2=' m.getPropValue(MRIComparisonBUD.GROUP2) ...
                        ' v1=' m.getPropValue(MRIComparisonBUD.VALUES1) ...
                        ' v2=' m.getPropValue(MRIComparisonBUD.VALUES2) ...
                        ' p=' m.getPropValue(MRIComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(MRIComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(MRIComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'MRIRandomComparisonBUD')
                    disp([Graph.NAME{m.getProp(MRIRandomComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(MRIRandomComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(MRIRandomComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(MRIRandomComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(MRIRandomComparisonBUD.THRESHOLD1) ...
                        ' g1=' m.getPropValue(MRIRandomComparisonBUD.GROUP1)...
                        ' v=' m.getPropValue(MRIRandomComparisonBUD.VALUES1) ...
                        ' rand=' m.getPropValue(MRIRandomComparisonBUD.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(MRIRandomComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(MRIRandomComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(MRIRandomComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'MRIMeasureBUD')
                    disp([Graph.NAME{m.getProp(MRIMeasureBUD.CODE)} ...
                        ' param=' m.getPropValue(MRIMeasureBUD.PARAM) ...
                        ' notes=' m.getPropValue(MRIMeasureBUD.NOTES) ...
                        ' d=' m.getPropValue(MRIMeasureBUD.DENSITY) ...
                        ' t=' m.getPropValue(MRIMeasureBUD.THRESHOLD1) ...
                        ' g=' m.getPropValue(MRIMeasureBUD.GROUP1) ...
                        ' v=' m.getPropValue(MRIMeasureBUD.VALUES1) ...
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
            % See also MRIGraphAnalysisBUD.
            
            indices = find(ga.ht_measure{measurecode}~=0);
            indices = indices(reg2int(indices,MRIMeasureBUD.DENSITY_LEVELS)==g);
            
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
            % See also MRIGraphAnalysisBUD.
            
            graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure);
            mt = MRIMeasureBUD( ...
                MRIMeasureBUD.CODE,measurecode, ...
                MRIMeasureBUD.GROUP1,g, ...
                MRIMeasureBUD.DENSITY,graph.density ...                
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
            % See also MRIGraphAnalysisBUD.
            
            [indices1t,indices2t] = find(ga.ht_comparison{measurecode}~=0);
            indices1 = indices1t(reg2int(indices1t,MRIMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,MRIMeasureBUD.DENSITY_LEVELS)==g2);
            indices2 = indices2t(reg2int(indices1t,MRIMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,MRIMeasureBUD.DENSITY_LEVELS)==g2);
            
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
            % See also MRIGraphAnalysisBUD.
            
            graph1 = GraphBU(ga.A{g1},'Density',density,'Structure',ga.structure);
            graph2 = GraphBU(ga.A{g2},'Density',density,'Structure',ga.structure);
            ct = MRIComparisonBUD( ...
                MRIComparisonBUD.CODE,measurecode, ...
                MRIComparisonBUD.GROUP1,g1, ...
                MRIComparisonBUD.GROUP2,g2, ...
                MRIComparisonBUD.DENSITY,(graph1.density + graph2.density)/2 ...
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
            % See also MRIGraphAnalysisBUD.

            indices = find(ga.ht_random_comparison{measurecode}~=0);
            indices = indices(reg2int(indices,MRIMeasureBUD.DENSITY_LEVELS)==g);
            
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
            % See also MRIGraphAnalysisBUD.

            graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure);
            nt = MRIRandomComparisonBUD( ...
                MRIRandomComparisonBUD.CODE,measurecode, ...
                MRIRandomComparisonBUD.GROUP1,g, ...
                MRIRandomComparisonBUD.DENSITY,graph.density ...
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
            % See also MRIGraphAnalysisBUD, GraphBU.
            
            [m,mi] = ga.getMeasure(measurecode,g,density);

            if ~mi
                graph = GraphBU(ga.A{g},'Density',density,'Structure',ga.structure,varargin{:});
                res = graph.measure(measurecode);
                m = MRIMeasureBUD( ...
                    MRIMeasureBUD.CODE,measurecode, ...
                    MRIMeasureBUD.DENSITY,graph.density(), ...
                    MRIMeasureBUD.THRESHOLD1,graph.threshold(), ...
                    MRIMeasureBUD.GROUP1,g, ...
                    MRIMeasureBUD.VALUES1,res);
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
            % See also MRIGraphAnalysisBUD, GraphBU.
            
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
                res1 = m1.getProp(MRIMeasureBUD.VALUES1);
                
                m2 = ga.calculate(measurecode,g2,density,varargin{:});
                res2 = m2.getProp(MRIMeasureBUD.VALUES1);
                
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
                
                c = MRIComparisonBUD( ...
                    MRIComparisonBUD.CODE,measurecode, ...
                    MRIComparisonBUD.DENSITY,(m1.getProp(MRIMeasureBUD.DENSITY) + m2.getProp(MRIMeasureBUD.DENSITY))/2, ...
                    MRIComparisonBUD.THRESHOLD1,m1.getProp(MRIMeasureBUD.THRESHOLD1), ...
                    MRIComparisonBUD.THRESHOLD2,m2.getProp(MRIMeasureBUD.THRESHOLD1), ...
                    MRIComparisonBUD.GROUP1,g1, ...
                    MRIComparisonBUD.VALUES1,res1, ...
                    MRIComparisonBUD.GROUP2,g2, ...
                    MRIComparisonBUD.VALUES2,res2, ...
                    MRIComparisonBUD.PVALUE1,p_single, ...
                    MRIComparisonBUD.PVALUE2,p_double, ...
                    MRIComparisonBUD.PERCENTILES,percentiles, ...
                    MRIComparisonBUD.PARAM,M);
                
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
            % See also MRIGraphAnalysisBUD, GraphBU.

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
                res = m.getProp(MRIMeasureBUD.VALUES1);
                
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
                
                n = MRIRandomComparisonBUD( ...
                    MRIRandomComparisonBUD.CODE,measurecode, ...
                    MRIRandomComparisonBUD.DENSITY,m.getProp(MRIMeasureBUD.DENSITY), ...
                    MRIRandomComparisonBUD.THRESHOLD1,m.getProp(MRIMeasureBUD.THRESHOLD1), ...
                    MRIRandomComparisonBUD.GROUP1,g, ...
                    MRIRandomComparisonBUD.VALUES1,res, ...
                    MRIRandomComparisonBUD.RANDOM_COMP_VALUES,rand_res, ...
                    MRIRandomComparisonBUD.PVALUE1,p_single, ...
                    MRIRandomComparisonBUD.PVALUE2,p_double, ...
                    MRIRandomComparisonBUD.PERCENTILES,percentiles, ...
                    MRIRandomComparisonBUD.PARAM,M);
                
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
            % See also MRIGraphAnalysisBUD.
            
            ga.ht_measure = {};
            ga.ht_comparison = {};
            ga.ht_random_comparison = {};
            
            for m = 1:1:GraphBU.measurenumber()
                D = ga.cohort.groupnumber() * MRIMeasureBUD.DENSITY_LEVELS;
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
            % See also MRIGraphAnalysisBUD.
            
            Check.isa('Error: The measure m must be a MRIMeasureBUD',m,'MRIMeasureBUD')
            
            if m.isMeasure()
                [~,g,d] = m.hash();
                index = int2reg(g,d,MRIMeasureBUD.DENSITY_LEVELS);
            elseif m.isComparison()
                [~,g1,g2,d] = m.hash();
                index = [int2reg(g1,d,MRIMeasureBUD.DENSITY_LEVELS) int2reg(g2,d,MRIMeasureBUD.DENSITY_LEVELS)];
            else % m.isRandom()
                [~,g,d] = m.hash();
                index = int2reg(g,d,MRIMeasureBUD.DENSITY_LEVELS);
            end
        end
        function class = elementClass()
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'MRIMeasureBUD'.
            %
            % See also MRIGraphAnalysisBUD, MRIMeasureBUD.
            
            class = 'MRIMeasureBUD';
        end
        function m = element()
            % ELEMENT creates new MRI measure of a binary undirected graph
            %
            % M = ELEMENT() returns a MRI measure M of a binary undirected graph with fixed density.
            %
            % See also MRIGraphAnalysisBUD, MRIMeasureBUD.
            
            m = MRIMeasureBUD();
        end
    end
end