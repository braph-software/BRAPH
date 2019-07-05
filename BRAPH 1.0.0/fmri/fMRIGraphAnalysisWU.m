classdef fMRIGraphAnalysisWU < fMRIGraphAnalysis
    % fMRIGraphAnalysisWU < fMRIGraphAnalysis : Graph analysis of weighted undirected fMRI
    %   fMRIGraphAnalysisWU represents a list of measures used for graph analysis of fMRI data based 
    %   on weighted undirected graphs.
    %
    % fMRIGraphAnalysisWU properties (Access = protected):
    %   props                   -   cell array of object properties < ListElement
    %   elements                -   cell array of list elements < List
    %   path                    -   XML file path < List
    %   file                    -   XML file name < List
    %   cohort                  -   cohort (fMRICohort) < fMRIGraphAnalysis
    %   data                    -   subject data (cell array; matrix; one per subject) < fMRIGraphAnalysis
    %   A                       -   adjaciency matrix (cell array; matrix; one per subject) < fMRIGraphAnalysis
    %   P                       -   correlation p-value matrix (cell array; matrix; one per subject) < fMRIGraphAnalysis      
    %   structure               -   community structure < fMRIGraphAnalysis 
    %   ht_measure              -   hashtable for measure (cell array; sparse vectors; one per measure) < fMRIGraphAnalysis
    %   ht_comparison           -   hashtable for comparison (cell array; sparse matrices; one per measure) < fMRIGraphAnalysis
    %   ht_random_comparison    -   hashtable for random comparison (cell array; sparse vectors; one per measure) < fMRIGraphAnalysis
    %
    % fMRIGraphAnalysisWU properties (Constant):
    %   NAME            -   name numeric code < fMRIGraphAnalysis
    %   NAME_TAG        -   name tag < fMRIGraphAnalysis
    %   NAME_FORMAT     -   name format < fMRIGraphAnalysis
    %   NAME_DEFAULT    -   name default < fMRIGraphAnalysis
    %
    %   CORR                    -   correlation numeric code < fMRIGraphAnalysis
    %   CORR_TAG                -   correlation tag < fMRIGraphAnalysis
    %   CORR_FORMAT             -   correlation format < fMRIGraphAnalysis
    %   CORR_PEARSON            -   correlation 'pearson' option < fMRIGraphAnalysis
    %   CORR_SPEARMAN           -   correlation 'spearman' option < fMRIGraphAnalysis
    %   CORR_KENDALL            -   correlation 'kendall' option < fMRIGraphAnalysis
    %   CORR_PARTIALPEARSON     -   correlation 'partial pearson' option < fMRIGraphAnalysis
    %   CORR_PARTIALSPEARMAN    -   correlation 'partial spearman' option < fMRIGraphAnalysis
    %   CORR_OPTIONS            -   array of correlation options < fMRIGraphAnalysis
    %   CORR_DEFAULT            -   correlation default < fMRIGraphAnalysis
    %
    %   NEG             -   negative correlations numeric code < fMRIGraphAnalysis
    %   NEG_TAG         -   negative correlations tag < fMRIGraphAnalysis
    %   NEG_FORMAT      -   negative correlations format < fMRIGraphAnalysis
    %   NEG_ZERO        -   negative correlations 'zero' option < fMRIGraphAnalysis
    %   NEG_NONE        -   negative correlations 'none' option < fMRIGraphAnalysis
    %   NEG_ABS         -   negative correlations 'abs' option < fMRIGraphAnalysis
    %   NEG_OPTIONS     -   array of negative correlations options < fMRIGraphAnalysis
    %   NEG_DEFAULT     -   negative correlations default < fMRIGraphAnalysis
    %
    %   FMIN            -   Lower frequency cutoff numeric code < fMRIGraphAnalysis
    %   FMIN_TAG        -   Lower frequency cutoff tag < fMRIGraphAnalysis
    %   FMIN_FORMAT     -   Lower frequency cutoff format < fMRIGraphAnalysis
    %   FMIN_DEFAULT    -   Lower frequency cutoff default < fMRIGraphAnalysis
    %
    %   FMAX            -   Higher frequency cutoff numeric code < fMRIGraphAnalysis
    %   FMAX_TAG        -   Higher frequency cutoff tag < fMRIGraphAnalysis
    %   FMAX_FORMAT     -   Higher frequency cutoff format < fMRIGraphAnalysis
    %   FMAX_DEFAULT    -   Higher frequency cutoff default < fMRIGraphAnalysis
    %
    % fMRIGraphAnalysisWU methods (Access = protected):
    %   copyElement            -   copies elements of graph analysis < fMRIGraphAnalysis
    %   initialize             -   initializes graph analysis < fMRIGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %
    % fMRIGraphAnalysisWU methods:
    %   fMRIGraphAnalysisWU     -   constructor
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
    %   adjmatrix               -   calculates the adjaciency matrix < fMRIGraphAnalysis
    %   getCohort               -   returns cohort of a graph analysis < fMRIGraphAnalysis
    %   getBrainAtlas           -   returns atlas of graph analysis < fMRIGraphAnalysis
    %   getPlotBrainSurf        -   generates new PlotBrainSurf < fMRIGraphAnalysis
    %   getPlotBrainAtlas       -   generates new PlotBrainAtlas < fMRIGraphAnalysis
    %   getPlotBrainGraph       -   generates new PlotBrainGraph < fMRIGraphAnalysis
    %   getSubjectData          -   returns data of subjects < fMRIGraphAnalysis
    %   getA                    -   returns adjaciency matrix < fMRIGraphAnalysis
    %   getP                    -   returns correlations p-value matrix < fMRIGraphAnalysis
    %   getStructure            -   returns community structure < fMRIGraphAnalysis
    %   exist                   -   tests whether a given measure/comparison exists < fMRIGraphAnalysis
    %   existMeasure            -   tests whether a given measure exists < fMRIGraphAnalysis
    %   existComparison         -   tests whether a given comparison exists < fMRIGraphAnalysis
    %   existRandom             -   tests whether a given random comparison exists < fMRIGraphAnalysis
    %   add                     -   adds measure < fMRIGraphAnalysis
    %   remove                  -   removes measure < fMRIGraphAnalysis
    %   replace                 -   replaces measure < fMRIGraphAnalysis
    %   toXML                   -   creates XML Node from graph analysis < fMRIGraphAnalysis
    %   fromXML                 -   loads graph analysis from XML Node < fMRIGraphAnalysis
    %   disp                    -   displays graph analysis
    %   getMeasures             -   gets available measures
    %   getMeasure              -   gets measure from a given group
    %   getComparisons          -   gets available comparisons
    %   getComparison           -   gets comparison from given groups
    %   getRandomComparisons    -   gets available random comparisons
    %   getRandomComparison     -   gets random comparison from given groups
    %   calculate               -   calculates measure
    %   compare                 -   calculates comparison
    %   randomcompare       -   calculates random comparison
    %
    % fMRIGraphAnalysisWU methods (Static):
    %   cleanXML        -   removes whitespace nodes from xmlread < ListElement
    %   propnumber      -   number of properties < fMRIGraphAnalysis
    %   getTags         -   cell array of strings with the tags of the properties < fMRIGraphAnalysis
    %   getFormats      -   cell array with the formats of the properties < fMRIGraphAnalysis
    %   getDefaults     -   cell array with the defaults of the properties < fMRIGraphAnalysis
    %   getOptions      -   cell array with options (only for properties with options format) < fMRIGraphAnalysis
    %   getIndex        -   get index used in calculation of hash values
    %   elementClass    -   element class name
    %   element         -   creates new empty element
    %
    % See also fMRIGraphAnalysisBUT, fMRIGraphAnalysis ,fMRIGraphAnalysisBUD, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = fMRIGraphAnalysisWU(cohort,structure,varargin)
            % FMRIGRAPHANALYSISWU(COHORT,STRUCTURE) creates a fMRI graph analysis using the cohort COHORT 
            %   and community structure STRUCTURE. This analysis has default properties and uses a  
            %   weighted undirected graph.  
            %   
            % FMRIGRAPHANALYSISWU(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
            %   Tag2 to Value2, ... .
            %   Admissible properties are:
            %     fMRIGraphAnalysis.NAME      -   char
            %     fMRIGraphAnalysis.CORR      -   options (fMRIGraphAnalysis.CORR_PEARSON,fMRIGraphAnalysis.CORR_SPEARMAN,
            %                                    fMRIGraphAnalysis.CORR_KENDALL,fMRIGraphAnalysis.CORR_PARTIALPEARSON,
            %                                    fMRIGraphAnalysis.CORR_PARTIALSPEARMAN)
            %     fMRIGraphAnalysis.NEG       -   options (fMRIGraphAnalysis.NEG_ZERO,
            %                                    fMRIGraphAnalysis.NEG_NONE,fMRIGraphAnalysis.NEG_ABS)
            %     fMRIGraphAnalysis.FMIN      -   numeric
            %     fMRIGraphAnalysis.FMAX      -   numeric
            %
            % See also fMRIGraphAnalysisWU, fMRIGraphAnalysis, List.
            
            ga = ga@fMRIGraphAnalysis(cohort,structure, ...
                fMRIGraphAnalysis.GRAPH, fMRIGraphAnalysis.GRAPH_WU, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also fMRIGraphAnalysisWU.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'fMRIComparisonWU')
                    disp([Graph.NAME{m.getProp(fMRIComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(fMRIComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(fMRIComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(fMRIComparisonWU.GROUP1) ...
                        ' g2=' m.getPropValue(fMRIComparisonWU.GROUP2) ...
                        ' v1= matrix ' int2str(size(m.getProp(fMRIComparisonWU.VALUES1),1)) ' x ' int2str(size(m.getProp(fMRIComparisonWU.VALUES1),2)) ...
                        ' v2= matrix ' int2str(size(m.getProp(fMRIComparisonWU.VALUES2),1)) ' x ' int2str(size(m.getProp(fMRIComparisonWU.VALUES2),2)) ...
                        ' p=' m.getPropValue(fMRIComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(fMRIComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(fMRIComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'fMRIRandomComparisonWU')
                    disp([Graph.NAME{m.getProp(fMRIRandomComparisonWU.CODE)} ...
                        ' param=' m.getPropValue(fMRIRandomComparisonWU.PARAM) ...
                        ' notes=' m.getPropValue(fMRIRandomComparisonWU.NOTES) ...
                        ' g1=' m.getPropValue(fMRIRandomComparisonWU.GROUP1)...
                        ' v=' m.getPropValue(fMRIRandomComparisonWU.VALUES1) ...
                        ' rand=' m.getPropValue(fMRIRandomComparisonWU.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(fMRIRandomComparisonWU.PVALUE1) ...
                        ' p=' m.getPropValue(fMRIRandomComparisonWU.PVALUE2) ...
                        ' per=' m.getPropValue(fMRIRandomComparisonWU.PERCENTILES) ...
                        ])
                elseif isa(m,'fMRIMeasureWU')
                    disp([Graph.NAME{m.getProp(fMRIMeasureWU.CODE)} ...
                        ' param=' m.getPropValue(fMRIMeasureWU.PARAM) ...
                        ' notes=' m.getPropValue(fMRIMeasureWU.NOTES) ...
                        ' g=' m.getPropValue(fMRIMeasureWU.GROUP1) ...
                        ' v= matrix ' int2str(size(m.getProp(fMRIMeasureWU.VALUES1),1)) ' x ' int2str(size(m.getProp(fMRIMeasureWU.VALUES1),2)) ...
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
            % See also fMRIGraphAnalysisWU.
            
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
            % See also fMRIGraphAnalysisWU.
            
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
            % See also fMRIGraphAnalysisWU.
            
            ci = ga.ht_comparison{measurecode}(g1,g2);
            cs = {};
            if ci>0
                cs{1} = ga.get(ci);
            end
        end
        function [c,ci] = getComparison(ga,measurecode,g1,g2)
            % GETCOMPARSION gets comparsion from given groups
            %
            % [C,CI] = GETCOMPARSION(GA,MEASURECODE,G1,G2) returns the properties of the comparsion C and 
            %   hash table position CI of the comparison specified by MEASURECODE calculated for the groups 
            %   G1 and G2 in graph analysis GA.
            %
            % See also fMRIGraphAnalysisWU.
            
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
            % See also fMRIGraphAnalysisWU.
            
            ni = ga.ht_random_comparison{measurecode}(g);
            ns = {};
            if ni>0
                ns{1} = ga.get(ni);
            end
        end
        function [n,ni] = getRandomComparison(ga,measurecode,g)
            % GETRANDOMCOMPARISON gets comparison with random graphs from given group
            %
            % [N,NI] = GETRANDOMCOMPARISON(GA,MEASURECODE,G,THRESHOLD) returns the comparisons
            %   with random graphs NS and hash table position NI of the measure specified by
            %   MEASURECODE calculated for a group G in graph analysis GA.
            %
            % See also fMRIGraphAnalysisWU.
            
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
            % See also fMRIGraphAnalysisWU, GraphWU.
            
            [m,mi] = ga.getMeasure(measurecode,g);
            
            if ~mi
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                res = [];
                for j = 1:1:length(indices)
                    graph = GraphWU(ga.A{indices(j)},'structure',ga.structure,varargin{:});
                    res = [res; graph.measure(measurecode)];
                end            
                
                m = fMRIMeasureWU( ...
                    fMRIMeasureWU.CODE,measurecode, ...
                    fMRIMeasureWU.GROUP1,g, ...
                    fMRIMeasureWU.VALUES1,res);
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
            % See also fMRIGraphAnalysisWU, GraphBU.
            
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
                values1 = m1.getProp(fMRIMeasure.VALUES1);
                res1 = m1.mean();
                
                m2 = ga.calculate(measurecode,g2,varargin{:});
                values2 = m2.getProp(fMRIMeasure.VALUES1);
                res2 = m2.mean();
                
                values = [values1; values2];
                                
                all1 = zeros(M,numel(res1));
                all2 = zeros(M,numel(res2));

                number_sub1 = size(values1,1);
                number_sub2 = size(values2,1);
                number_subtot = number_sub1+number_sub2;
                
                start = tic;
                for i = 1:1:M
                    if verbose
                        disp(['** PERMUTATION TEST - sampling #' int2str(i) '/' int2str(M) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                    end
                    
                    if longitudinal
                        subs1 = [1:1:number_sub1];
                        subs2 = number_sub1 + [1:1:number_sub2];
                        max = min(numel(subs1),numel(subs2));
                        perm = sign(randn(1,max));
                        perm1 = subs1;
                        perm2 = subs2;
                        perm1(perm==1) = subs2(perm==1);
                        perm2(perm==1) = subs1(perm==1);                        
                    else
                        perm1 = sort( randperm(number_subtot,number_sub1) );
                        perm2 = [1:1:number_subtot];
                        perm2(perm1) = 0;
                        perm2 = perm2(perm2>0);
                    end
                    
                    valuesperm1 = values(perm1,:);
                    mperm1 = mean(valuesperm1,1);
                    
                    valuesperm2 = values(perm2,:);
                    mperm2 = mean(valuesperm2,1);

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
                
                c = fMRIComparisonWU( ...
                    fMRIComparisonWU.CODE,measurecode, ...
                    fMRIComparisonWU.GROUP1,g1, ...
                    fMRIComparisonWU.VALUES1,res1, ...
                    fMRIComparisonWU.GROUP2,g2, ...
                    fMRIComparisonWU.VALUES2,res2, ...
                    fMRIComparisonWU.PVALUE1,p_single, ...
                    fMRIComparisonWU.PVALUE2,p_double, ...
                    fMRIComparisonWU.PERCENTILES,percentiles, ...
                    fMRIComparisonWU.PARAM,M);

                ga.add(c)
            end
        end
        function n = randomcompare(ga,measurecode,g,varargin)
            % RANDOMCOMPARE calculates comparison with random graphs
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G) returns the properties of the comparison
            %   with random graphs N after calculating the measure specified by MEASURECODE for the group G
            %   in graph analysis GA.
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,Tag1,Value1,Tag2,Value2,...) initializes property
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphWU can be used.
            %   Additional admissible properties are:
            %       verbose         -   print the progress of the permutation test on the command line
            %                           true (default) | false
            %       interruptible   -   time for parallel execution of other codes
            %                           [default = 0]
            %       m               -   number of permutations
            %                           [default = 1e+1]
            %       swaps           -   number of swaps to create random matrix
            %                           [default = 5]
            %
            % See also fMRIGraphAnalysisWU, GraphWU.
            
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
                res = m.mean();
                
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                results = cell(length(indices),M);
                start = tic;
                for i= 1:1:length(indices)
                    graph = GraphWU(ga.A{indices(i)},'structure',ga.structure,varargin{:});
                    for c = 1:1:M
                        if verbose
                            disp(['** RANDOM GRAPH - sampling #' int2str((i-1)*M+c) '/' int2str(M*length(indices)) ' - ' int2str(toc(start)) '.' int2str(mod(toc(start),1)*10) 's'])
                        end
                        [random_gr,~] = graph.randomize(bin_swaps);
                        temp_res = random_gr.measure(measurecode);
                        results{i,c} = temp_res;
                        
                        if interruptible
                            pause(interruptible)
                        end
                        
                    end
                end
                
                tmp_res = zeros(M,length(results{1,1}));
                resall = zeros(length(indices),length(results{1,1}));
                for c = 1:1:length(indices)
                    for i = 1:1:M
                        tmp_res(i,:) = results{c,i};
                    end
                    resall(c,:) = mean(tmp_res);
                end
                
                p_single = pvalue1(res,resall);
                p_double = pvalue2(res,resall);
                percentiles = quantiles(resall,100);
                rand_res = mean(resall);
                
                n = fMRIRandomComparisonWU( ...
                    fMRIRandomComparisonWU.CODE,measurecode, ...
                    fMRIRandomComparisonWU.GROUP1,g, ...
                    fMRIRandomComparisonWU.VALUES1,res, ...
                    fMRIRandomComparisonWU.RANDOM_COMP_VALUES,rand_res, ...
                    fMRIRandomComparisonWU.PVALUE1,p_single, ...
                    fMRIRandomComparisonWU.PVALUE2,p_double, ...
                    fMRIRandomComparisonWU.PERCENTILES,percentiles, ...
                    fMRIRandomComparisonWU.PARAM,M);
                
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
            % See also fMRIGraphAnalysisWU.
            
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
            % See also fMRIGraphAnalysisWU.
            
            Check.isa('Error: The measure m must be a fMRIMeasureWU',m,'fMRIMeasureWU')
            
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
            %   i.e., the string 'fMRIMeasureWU'.
            %
            % See also fMRIGraphAnalysisWU, fMRIMeasureWU.
            
            class = 'fMRIMeasureWU';
        end
        function m = element()
            % ELEMENT creates new fMRI measure of a weighted undirected graph
            %
            % M = ELEMENT() returns a fMRI measure M of a weighted undirected graph.
            %
            % See also fMRIGraphAnalysisWU, fMRIMeasureWU.
            
            m = fMRIMeasureWU();
        end
    end
end