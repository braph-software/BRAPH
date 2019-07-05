classdef fMRIGraphAnalysisBUD < fMRIGraphAnalysis
    % fMRIGraphAnalysisBUD < fMRIGraphAnalysis : Graph analysis of fixed density binary undirected fMRI
    %   fMRIGraphAnalysisBUD represents a list of measures used for graph analysis of fMRI data based 
    %   on binary undirected graphs with fixed density.
    %
    % fMRIGraphAnalysisBUD properties (Access = protected):
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
    % fMRIGraphAnalysisBUD properties (Constant):
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
    % fMRIGraphAnalysisBUD methods (Access = protected):
    %   copyElement            -   copies elements of graph analysis < fMRIGraphAnalysis
    %   initialize             -   initializes graph analysis < fMRIGraphAnalysis
    %   initialize_hashtables  -   initialize hash tables
    %
    % fMRIGraphAnalysisBUD methods:
    %   fMRIGraphAnalysisBUD    -   constructor
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
    % fMRIGraphAnalysisBUD methods (Static):
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
    % See also fMRIGraphAnalysisBUT, fMRIGraphAnalysis ,fMRIGraphAnalysisWU, List.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    methods
        function ga = fMRIGraphAnalysisBUD(cohort,structure,varargin)
            % FMRIGRAPHANALYSISBUD(COHORT,STRUCTURE) creates a fMRI graph analysis using the cohort COHORT 
            %   and community structure STRUCTURE. This analysis has default properties and uses a  
            %   binary undirected graph with fixed density.
            %   
            % FMRIGRAPHANALYSISBUD(COHORT,STRUCTURE,Tag1,Value1,Tag2,Value2,...) initializes property Tag1 to Value1, 
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
            % See also fMRIGraphAnalysisBUD, fMRIGraphAnalysis, List.
            
            ga = ga@fMRIGraphAnalysis(cohort,structure, ...
                fMRIGraphAnalysis.GRAPH, fMRIGraphAnalysis.GRAPH_BUD, ...
                varargin{:});
        end
        function disp(ga)
            % DISP displays graph analysis
            %
            % DISP(GA) displays the graph analysis GA and the properties of its measures 
            %   and comparisons on the command line.
            %
            % See also fMRIGraphAnalysisBUD.
            
            ga.disp@List()
            ga.cohort.disp@List()
            disp(' >> MEASURES and COMPARISONS << ')
            for i = 1:1:ga.length()
                m = ga.get(i);
                if isa(m,'fMRIComparisonBUD')
                    disp([Graph.NAME{m.getProp(fMRIComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(fMRIComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(fMRIComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(fMRIComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(fMRIComparisonBUD.THRESHOLD1) ...
                        ' t2=' m.getPropValue(fMRIComparisonBUD.THRESHOLD2) ...
                        ' g1=' m.getPropValue(fMRIComparisonBUD.GROUP1)...
                        ' g2=' m.getPropValue(fMRIComparisonBUD.GROUP2) ...
                        ' v1= matrix ' int2str(size(m.getProp(fMRIComparisonBUD.VALUES1),1)) ' x ' int2str(size(m.getProp(fMRIComparisonBUD.VALUES1),2)) ...
                        ' v2= matrix ' int2str(size(m.getProp(fMRIComparisonBUD.VALUES2),1)) ' x ' int2str(size(m.getProp(fMRIComparisonBUD.VALUES2),2)) ...
                        ' p=' m.getPropValue(fMRIComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(fMRIComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(fMRIComparisonBUD.PERCENTILES) ...
                        ])
                    elseif isa(m,'fMRIRandomComparisonBUD')
                    disp([Graph.NAME{m.getProp(fMRIRandomComparisonBUD.CODE)} ...
                        ' param=' m.getPropValue(fMRIRandomComparisonBUD.PARAM) ...
                        ' notes=' m.getPropValue(fMRIRandomComparisonBUD.NOTES) ...
                        ' d=' m.getPropValue(fMRIRandomComparisonBUD.DENSITY) ...
                        ' t1=' m.getPropValue(fMRIRandomComparisonBUD.THRESHOLD1) ...
                        ' g1=' m.getPropValue(fMRIRandomComparisonBUD.GROUP1)...
                        ' v=' m.getPropValue(fMRIRandomComparisonBUD.VALUES1) ...
                        ' rand=' m.getPropValue(fMRIRandomComparisonBUD.RANDOM_COMP_VALUES) ...
                        ' p=' m.getPropValue(fMRIRandomComparisonBUD.PVALUE1) ...
                        ' p=' m.getPropValue(fMRIRandomComparisonBUD.PVALUE2) ...
                        ' per=' m.getPropValue(fMRIRandomComparisonBUD.PERCENTILES) ...
                        ])
                elseif isa(m,'fMRIMeasureBUD')
                    disp([Graph.NAME{m.getProp(fMRIMeasureBUD.CODE)} ...
                        ' param=' m.getPropValue(fMRIMeasureBUD.PARAM) ...
                        ' notes=' m.getPropValue(fMRIMeasureBUD.NOTES) ...
                        ' d=' m.getPropValue(fMRIMeasureBUD.DENSITY) ...
                        ' t=' m.getPropValue(fMRIMeasureBUD.THRESHOLD1) ...
                        ' g=' m.getPropValue(fMRIMeasureBUD.GROUP1) ...
                        ' v= matrix ' int2str(size(m.getProp(fMRIMeasureBUD.VALUES1),1)) ' x ' int2str(size(m.getProp(fMRIMeasureBUD.VALUES1),2)) ...
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
            % See also fMRIGraphAnalysisBUD.
            
            indices = find(ga.ht_measure{measurecode}~=0);
            indices = indices(reg2int(indices,fMRIMeasureBUD.DENSITY_LEVELS)==g);
            
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
            % See also fMRIGraphAnalysisBUD.
            
            mt = fMRIMeasureBUD( ...
                fMRIMeasureBUD.CODE,measurecode, ...
                fMRIMeasureBUD.GROUP1,g, ...
                fMRIMeasureBUD.DENSITY,density ...                
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
            % See also fMRIGraphAnalysisBUD.
            
            [indices1t,indices2t] = find(ga.ht_comparison{measurecode}~=0);
            indices1 = indices1t(reg2int(indices1t,fMRIMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,fMRIMeasureBUD.DENSITY_LEVELS)==g2);
            indices2 = indices2t(reg2int(indices1t,fMRIMeasureBUD.DENSITY_LEVELS)==g1 & reg2int(indices2t,fMRIMeasureBUD.DENSITY_LEVELS)==g2);
            
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
            % See also fMRIGraphAnalysisBUD.
            
            ct = fMRIComparisonBUD( ...
                fMRIComparisonBUD.CODE,measurecode, ...
                fMRIComparisonBUD.GROUP1,g1, ...
                fMRIComparisonBUD.GROUP2,g2, ...
                fMRIComparisonBUD.DENSITY,density ...
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
            % See also fMRIGraphAnalysisBUD.

            indices = find(ga.ht_random_comparison{measurecode}~=0);
            indices = indices(reg2int(indices,fMRIMeasureBUD.DENSITY_LEVELS)==g);
            
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
            % See also fMRIGraphAnalysisBUD.
            
            nt = fMRIRandomComparisonBUD( ...
                fMRIRandomComparisonBUD.CODE,measurecode, ...
                fMRIRandomComparisonBUD.GROUP1,g, ...
                fMRIRandomComparisonBUD.DENSITY,density ...                
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
            % See also fMRIGraphAnalysisBUD, GraphBU.
            
            [m,mi] = ga.getMeasure(measurecode,g,density);

            if ~mi
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                res = [];
                threshold = [];
                for i = indices
                    graph = GraphBU(ga.A{i},'structure',ga.structure,'Density',density,varargin{:});
                    res = [res; graph.measure(measurecode)];
                    threshold = [threshold graph.threshold()];
                end            

                m = fMRIMeasureBUD( ...
                    fMRIMeasureBUD.CODE,measurecode, ...
                    fMRIMeasureBUD.DENSITY,density, ...
                    fMRIMeasureBUD.THRESHOLD1,threshold, ...
                    fMRIMeasureBUD.GROUP1,g, ...
                    fMRIMeasureBUD.VALUES1,res);
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
            % See also fMRIGraphAnalysisBUD, GraphBU.
            
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
                values1 = m1.getProp(fMRIMeasure.VALUES1);
                res1 = m1.mean();
                
                m2 = ga.calculate(measurecode,g2,density,varargin{:});
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
                                
                c = fMRIComparisonBUD( ...
                    fMRIComparisonBUD.CODE,measurecode, ...
                    fMRIComparisonBUD.DENSITY,(m1.getProp(fMRIMeasureBUD.DENSITY) + m2.getProp(fMRIMeasureBUD.DENSITY))/2, ...
                    fMRIComparisonBUD.THRESHOLD1,m1.getProp(fMRIMeasureBUD.THRESHOLD1), ...
                    fMRIComparisonBUD.THRESHOLD2,m2.getProp(fMRIMeasureBUD.THRESHOLD1), ...
                    fMRIComparisonBUD.GROUP1,g1, ...
                    fMRIComparisonBUD.VALUES1,res1, ...
                    fMRIComparisonBUD.GROUP2,g2, ...
                    fMRIComparisonBUD.VALUES2,res2, ...
                    fMRIComparisonBUD.PVALUE1,p_single, ...
                    fMRIComparisonBUD.PVALUE2,p_double, ...
                    fMRIComparisonBUD.PERCENTILES,percentiles, ...
                    fMRIComparisonBUD.PARAM,M);
                
                ga.add(c)
            end
        end
        function n = randomcompare(ga,measurecode,g,density,varargin)
            % RANDOMCOMPARE calculates comparison with random graphs
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY) returns the properties of the comparison
            %   with random graphs N after calculating the measure specified by MEASURECODE for the group G
            %   at specified density DENSITY in graph analysis GA.
            %
            % N = RANDOMCOMPARE(GA,MEASURECODE,G,DENSITY,Tag1,Value1,Tag2,Value2,...) initializes property
            %   Tag1 to Value1,Tag2 to Value2, ... .
            %   All properties of GraphBU can be used.
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
            % See also fMRIGraphAnalysisBUD, GraphBU.

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
            
            [n,ni] = ga.getRandomComparison(measurecode,g,density);
            
            if ~ni
                m = ga.calculate(measurecode,g,density,varargin{:});
                res = m.mean();                    
                
                indices = find(ga.cohort.getGroup(g).getProp(Group.DATA)==true);
                start = tic;
                results = cell(length(indices),M);
                for i = 1:1:length(indices)
                    graph = GraphBU(ga.A{indices(i)},'structure',ga.structure,'Density',density,varargin{:});
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
                    
                    n = fMRIRandomComparisonBUD( ...
                        fMRIRandomComparisonBUD.CODE,measurecode, ...
                        fMRIRandomComparisonBUD.DENSITY,m.getProp(fMRIMeasureBUD.DENSITY), ...
                        fMRIRandomComparisonBUD.THRESHOLD1,m.getProp(fMRIMeasureBUD.THRESHOLD1), ...
                        fMRIRandomComparisonBUD.GROUP1,g, ...
                        fMRIRandomComparisonBUD.VALUES1,res, ...
                        fMRIRandomComparisonBUD.RANDOM_COMP_VALUES,rand_res, ...
                        fMRIRandomComparisonBUD.PVALUE1,p_single, ...
                        fMRIRandomComparisonBUD.PVALUE2,p_double, ...
                        fMRIRandomComparisonBUD.PERCENTILES,percentiles, ...
                        fMRIRandomComparisonBUD.PARAM,M);
                    
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
            % See also fMRIGraphAnalysisBUD.
            
            ga.ht_measure = {};
            ga.ht_comparison = {};
            ga.ht_random_comparison = {};
            
            for m = 1:1:GraphBU.measurenumber()
                D = ga.cohort.groupnumber() * fMRIMeasureBUD.DENSITY_LEVELS;
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
            % See also fMRIGraphAnalysisBUD.
            
            Check.isa('Error: The measure m must be a fMRIMeasureBUD',m,'fMRIMeasureBUD')
            
            if m.isMeasure()
                [~,g,d] = m.hash();
                index = int2reg(g,d,fMRIMeasureBUD.DENSITY_LEVELS);
            elseif m.isComparison()
                [~,g1,g2,d] = m.hash();
                index = [int2reg(g1,d,fMRIMeasureBUD.DENSITY_LEVELS) int2reg(g2,d,fMRIMeasureBUD.DENSITY_LEVELS)];
            else % m.isRandom()
                [~,g,d] = m.hash();
                index = int2reg(g,d,fMRIMeasureBUD.DENSITY_LEVELS);
            end
            
        end
        function class = elementClass()
            % ELEMENTCLASS element class name
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'fMRIMeasureBUD'.
            %
            % See also fMRIGraphAnalysisBUD, fMRIMeasureBUD.
            
            class = 'fMRIMeasureBUD';
        end
        function m = element()
            % ELEMENT creates new fMRI measure of a binary undirected graph
            %
            % M = ELEMENT() returns a fMRI measure M of a binary undirected graph with fixed density.
            %
            % See also fMRIGraphAnalysisBUD, fMRIMeasureBUD.
            
            m = fMRIMeasureBUD();
        end
    end
end