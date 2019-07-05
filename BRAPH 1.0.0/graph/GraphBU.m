classdef GraphBU < GraphBD
    % GraphBU < GraphBD : Binary undirected graph
    %   GraphBU represents a binary undirected graph and set of respective measures
    %   that can be calculated on the graph.
    %
    % GraphBU properties (Constant):
    %   MEASURES_BD     -   array of measures defined for binary directed graph < GraphBD
    %   MEASURES_BU     -   array of measures defined for binary undirected graph
    %
    % GraphBU properties (GetAccess = public, SetAccess = protected):
    %   A               -   connection matrix < Graph
    %   P               -   coefficient p-values < Graph
    %   S               -   community structure < Graph    
    %   C               -   weighted connection matrix < GraphBD
    %   threshold       -   threshold to be applied for binarization < GraphBD
    %
    % GraphBU properties (Access = protected):
    %   N        -   number of nodes < Graph
    %   D        -   matrix of the shortest path lengths < Graph
    %   deg      -   degree < Graph
    %   indeg    -   in-degree < Graph
    %   outdeg   -   out-degree < Graph
    %   str      -   strength < Graph
    %   instr    -   in-strength < Graph
    %   outstr   -   out-strength < Graph
    %   ecc      -   eccentricity < Graph
    %   eccin    -   in-eccentricity < Graph
    %   eccout   -   out-eccentricity < Graph
    %   t        -   triangles < Graph
    %   c        -   path length < Graph
    %   cin      -   in-path length < Graph
    %   cout     -   out-path length < Graph
    %   ge       -   global efficiency < Graph
    %   gein     -   in-global efficiency < Graph
    %   geout    -   out-global efficiency < Graph
    %   le       -   local efficiency < Graph
    %   lenode   -   local efficiency of a node < Graph
    %   cl       -   clustering coefficient < Graph
    %   clnode   -   clustering coefficient of a node < Graph
    %   b        -   betweenness (non-normalized)  < Graph
    %   tr       -   transitivity < Graph
    %   clo      -   closeness < Graph
    %   cloin    -   in-closeness < Graph
    %   cloout   -   out-closeness < Graph
    %   Ci       -   structure < Graph
    %   m        -   modularity < Graph
    %   z        -   z-score < Graph
    %   zin      -   in-z-score < Graph
    %   zout     -   out-z-score < Graph
    %   p        -   participation < Graph
    %   a        -   assortativity < Graph
    %   sw       -   small-worldness < Graph
    %   sw_wsg   -   small-worldness < Graph
    %   B        -   number of edges in shortest weighted path matrix
    %
    % GraphBU methods (Access = protected):
    %   reset_structure_related_measures  -     resets z-score and participation < Graph
    %   copyElement         -   copy community structure < Graph
    %
    % GraphBU methods:
    %   GraphBU             -   constructor
    %   subgraph            -   creates subgraph from given nodes < Graph
    %   nodeattack          -   removes given nodes from a graph < Graph
    %   edgeattack          -   removes given edges from a graph < Graph
    %   nodenumber          -   number of nodes in a graph < Graph
    %   radius              -   radius of a network < Graph
    %   diameter            -   diameter of a network < Graph
    %   eccentricity        -   eccentricity of nodes < Graph
    %   pl                  -   path length of nodes  < Graph
    %   closeness           -   closeness of nodes  < Graph
    %   structure           -   structure measures of a network < Graph
    %   modularity          -   modularty of a network < Graph
    %   zscore              -   z-score of a network < Graph
    %   participation       -   participation of nodes < Graph
    %   smallwordness       -   small-wordness of the graph < Graph
    %   density             -   density of a graph < GraphBD
    %   weighted            -   checks if graph is weighted < GraphBD
    %   binary              -   checks if graph is binary < GraphBD
    %   distance            -   shortest path lenght of nodes from each other < GraphBD
    %   geff                -   global efficiency < GraphBD
    %   leff                -   local efficiency < GraphBD
    %   betweenness         -   betweenness centrality of a node < GraphBD
    %   directed            -   checks if graph is directed
    %   undirected          -   checks if graph is undirected
    %   degree              -   degree of a node
    %   triangles           -   number of triangles around a node
    %   cluster             -   clustering coefficient
    %   transitivity        -   transitivity of graph
    %   assortativity       -   assortativity of graph
    %   measure             -   calculates given measure
    %   randomize           -   randomize graph while preserving degree distribution
    %
    % GraphBU methods (Static):
    %   measurelist         -   list of measures valid for a binary undirected graph
    %   measurenumber       -   number of measures valid for a binary undirected graph
    %   removediagonal      -   replaces matrix diagonal with given value < Graph
    %   symmetrize          -   symmetrizes a matrix < Graph
    %   histogram           -   calculates the histogram of a connection matrix < Graph
    %   binarize            -   binarizes a connection matrix < Graph
    %   plotw               -   plots a weighted matrix < Graph
    %   plotb               -   plots a binary matrix < Graph
    %   hist                -   plots the histogram of a connection matrix < Graph
    %   isnodal             -   checks if measure is nodal < Graph
    %   isglobal            -   checks if measure is global < Graph
    %
    % See also Graph, GraphBD, Structure.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        MEASURES_BU = [ ...
            Graph.DEGREE ...
            Graph.DEGREEAV ...
            Graph.RADIUS ...
            Graph.DIAMETER ...
            Graph.ECCENTRICITY ...
            Graph.ECCENTRICITYAV ...
            Graph.TRIANGLES ...
            Graph.CPL ...
            Graph.CPL_WSG ... 
            Graph.PL ...
            Graph.GEFF ...
            Graph.GEFFNODE ...
            Graph.LEFF ...
            Graph.LEFFNODE ...
            Graph.CLUSTER ...
            Graph.CLUSTERNODE ...
            Graph.BETWEENNESS ...
            Graph.CLOSENESS ...
            Graph.TRANSITIVITY ...
            Graph.MODULARITY ...
            Graph.ZSCORE ...
            Graph.PARTICIPATION ...
            Graph.ASSORTATIVITY ...
            Graph.SW ...
            Graph.SW_WSG ...
            ]
    end
    properties (Access = protected)
        % [D B] = distance(g)
        B  % number of edges in shortest weighted path matrix
    end
    methods
        function g = GraphBU(A,varargin)
            % GRAPHBU(A) creates a binary undirected graph with default properties
            %
            % GRAPHBU(A,Property1,Value1,Property2,Value2,...) creates a graph from
            %   any connection matrix A and initializes property Property1 to Value1,
            %   Property2 to Value2, ... .
            %   Admissible properties are:
            %     threshold -   thereshold = 0 (default)
            %     density   -   percent of connections
            %     bins      -   -1:.001:1 (default)
            %     diagonal  -   'exclude' (default) | 'include'
            %     rule      -   'max' (default) | 'min' | 'av' | 'sum'
            %                   'max' - maximum between inconnection and outconnection (default)
            %                   'min' - minimum between inconnection and outconnection
            %                   'av'  - average of inconnection and outconnection
            %                   'sum' - sum of inconnection and outconnection
            %     P         -   coefficient p-values
            %     structure -   community structure object
            %
            % See also Graph, GraphBD.
            
            C = A;
            A = Graph.symmetrize(A,varargin{:});  % symmetrized connection matrix
            
            g = g@GraphBD(A,varargin{:});
            g.C = C;
        end
        function bool = directed(g)
            % DIRECTED checks if graph is directed
            %
            % BOOL = DIRECTED(G) returns false for undirected graphs.
            %
            % See also GraphBU, undirected.
            
            bool = false;
        end
        function bool = undirected(g)
            % UNDIRECTED checks if graph is undirected
            %
            % BOOL = UNDIRECTED(G) returns true for undirected graphs.
            %
            % See also GraphBU, directed.
            
            bool = true;
        end
        function deg = degree(g)
            % DEGREE degree of a node
            %
            % DEG = DEGREE(G) calculates the degree DEG of all nodes in the graph G.
            %
            % The node degree is the number of edges connected to a node. In these
            %   calculations, the diagonal of connection matrix is removed i.e.
            %   self-connections are not considered.
            %
            % See also GraphBU.
            
            deg = degree@GraphBD(g)/2;
        end
        function t = triangles(g)
            % TRIANGLES number of triangles around a node
            %
            % T = TRIANGLES(G) calculates the number of triangles T around all nodes
            %   in the graph G.
            %
            % Triangles are the number of pairs of neighbours of a node that are
            %   connected with each other.
            %
            % See also GraphBU.
            
            if isempty(g.t)
                A = Graph.removediagonal(g.A);
                A3 = A^3;
                g.t = 0.5*A3([1:g.nodenumber()+1:numel(A3)]);
            end
            
            t = g.t;
        end
        function [cl,clnode] = cluster(g)
            % CLUSTER clustering coefficient
            %
            % [CL,CLNODE] = CLUSTER(G) calculates the clustering coefficient of all
            %   nodes CLNODE and the average clustering coefficient CL of the graph G.
            %
            % Clustering coefficient of a node is defined as the fraction of triangles
            %   around the node (the fraction of node's neighbors that are neighbors of
            %   each other). Clustering coefficient of the graph is defined as the
            %   average of the clustering coefficients of all nodes in the graph.
            %
            %   Reference: "Collective dynamics of small-world networks", D.J. Watts and S.H. Strogatz
            %              (generalization to directed and disconnected graphs)
            %
            % See also GraphBU.
            
            if isempty(g.cl) || isempty(g.clnode)
                deg = g.degree();
                t = g.triangles();
                
                g.clnode = zeros(size(t));
                indices = find(t~=0 & deg>1);
                g.clnode(indices) = 2*t(indices)./(deg(indices).*(deg(indices)-1));
                
                g.cl = mean(g.clnode);
            end
            
            cl = g.cl;
            clnode = g.clnode;
        end
        function tr = transitivity(g)
            % TRANSITIVITY transitivity of a graph
            %
            % TR = TRANSITIVITY(G) calculates the transitivity of the graph G.
            %
            % Transitivity of a graph is defined as the fraction of triangles to
            %   triplets in a graph.
            %
            % Reference: "Ego-centered networks and the ripple effect", M.E.J. Newman
            %
            % See also GraphBU, triangles, cluster.
            
            if isempty(g.tr)
                A = Graph.removediagonal(g.A);
                g.tr = trace(A^3) / (sum(sum(A^2)) - trace(A^2));
            end
            
            tr = g.tr;
        end
        function a = assortativity(g)
            % ASSORTATIVITY Assortativity coefficient
            %
            % A = ASSORTATIVITY(G) calcualtes the assortativity of the graph G.
            %
            % The assortativity coefficient is a correlation coefficient between the
            %   degrees of all nodes on two opposite ends of a link. A positive
            %   assortativity coefficient indicates that nodes tend to link to other
            %   nodes with the same or similar degree.
            %
            % See also GraphBU.
            
            if isempty(g.a)
                g.a = assortativity_bin(Graph.removediagonal(g.A),0);
            end

            a = g.a;

            function r = assortativity_bin(CIJ,flag)
                %   ASSORTATIVITY Assortativity coefficient
                %
                %   r = assortativity(CIJ,flag);
                %
                %   The assortativity coefficient is a correlation coefficient between the
                %   degrees of all nodes on two opposite ends of a link. A positive
                %   assortativity coefficient indicates that nodes tend to link to other
                %   nodes with the same or similar degree.
                %
                %   Inputs:     CIJ,    binary directed/undirected connection matrix
                %               flag,   0, undirected graph: degree/degree correlation
                %                       1, directed graph: out-degree/in-degree correlation
                %                       2, directed graph: in-degree/out-degree correlation
                %                       3, directed graph: out-degree/out-degree correlation
                %                       4, directed graph: in-degree/in-degree correlation
                %
                %   Outputs:    r,      assortativity coefficient
                %
                %   Notes: The function accepts weighted networks, but all connection
                %   weights are ignored. The main diagonal should be empty. For flag 1
                %   the function computes the directed assortativity described in Rubinov
                %   and Sporns (2010) NeuroImage.
                %
                %   Reference:  Newman (2002) Phys Rev Lett 89:208701
                %               Foster et al. (2010) PNAS 107:10815?10820
                %
                %   Olaf Sporns, Indiana University, 2007/2008
                %   Vassilis Tsiaras, University of Crete, 2009
                %   Murray Shanahan, Imperial College London, 2012
                %   Mika Rubinov, University of Cambridge, 2012
                
                if (flag==0)                        % undirected version
                    deg = degrees_und(CIJ);
                    [i,j] = find(triu(CIJ,1)>0);
                    K = length(i);
                    degi = deg(i);
                    degj = deg(j);
                    
                else                                % directed versions
                    [id,od] = degrees_dir(CIJ);
                    [i,j] = find(CIJ>0);
                    K = length(i);
                    
                    switch flag
                        case 1
                            degi = od(i);
                            degj = id(j);
                        case 2
                            degi = id(i);
                            degj = od(j);
                        case 3
                            degi = od(i);
                            degj = od(j);
                        case 4
                            degi = id(i);
                            degj = id(j);
                    end
                end
                
                % compute assortativity
                r = ( sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2 ) / ...
                    ( sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2 );
            end
            function [deg] = degrees_und(CIJ)
                %DEGREES_UND        Degree
                %
                %   deg = degrees_und(CIJ);
                %
                %   Node degree is the number of links connected to the node.
                %
                %   Input:      CIJ,    undirected (binary/weighted) connection matrix
                %
                %   Output:     deg,    node degree
                %
                %   Note: Weight information is discarded.
                %
                %
                %   Olaf Sporns, Indiana University, 2002/2006/2008
                
                
                % ensure CIJ is binary...
                CIJ = double(CIJ~=0);
                
                deg = sum(CIJ);
            end
            function [id,od,deg] = degrees_dir(CIJ)
                %DEGREES_DIR        Indegree and outdegree
                %
                %   [id,od,deg] = degrees_dir(CIJ);
                %
                %   Node degree is the number of links connected to the node. The indegree
                %   is the number of inward links and the outdegree is the number of
                %   outward links.
                %
                %   Input:      CIJ,    directed (binary/weighted) connection matrix
                %
                %   Output:     id,     node indegree
                %               od,     node outdegree
                %               deg,    node degree (indegree + outdegree)
                %
                %   Notes:  Inputs are assumed to be on the columns of the CIJ matrix.
                %           Weight information is discarded.
                %
                %
                %   Olaf Sporns, Indiana University, 2002/2006/2008


                % ensure CIJ is binary...
                CIJ = double(CIJ~=0);

                % compute degrees
                id = sum(CIJ,1);    % indegree = column sum of CIJ
                od = sum(CIJ,2)';   % outdegree = row sum of CIJ
                deg = id+od;        % degree = indegree+outdegree
            end
        end
        function res = measure(g,mi)
            % MEASURE calculates given measure
            %
            % RES = MEASURE(G,MI) calculates the measure of the graph G specified
            %   by MI and returns the result RES.
            %   Admissible measures for binary undirected graphs are:
            %     Graph.DEGREE
            %     Graph.DEGREEAV
            %     Graph.RADIUS
            %     Graph.DIAMETER
            %     Graph.ECCENTRICITY
            %     Graph.ECCENTRICITYAV
            %     Graph.TRIANGLES
            %     Graph.CPL
            %     Graph.CPL_WSG
            %     Graph.PL
            %     Graph.GEFF
            %     Graph.GEFFNODE
            %     Graph.LEFF
            %     Graph.LEFFNODE
            %     Graph.CLUSTER
            %     Graph.CLUSTERNODE
            %     Graph.BETWEENNESS
            %     Graph.CLOSENESS
            %     Graph.TRANSITIVITY
            %     Graph.MODULARITY
            %     Graph.ZSCORE
            %     Graph.PARTICIPATION
            %     Graph.ASSORTATIVITY
            %     Graph.SW
            %
            % See also GraphBU.
            
            if ~any(GraphBU.measurelist()==mi)
                g.ERR_MEASURE_NOT_DEFINED(mi)
            end
            
            switch mi
                case Graph.DEGREE
                    res = g.degree();
                case Graph.DEGREEAV
                    res = mean(g.degree());
                case Graph.RADIUS
                    res = g.radius();
                case Graph.DIAMETER
                    res = g.diameter();
                case Graph.ECCENTRICITY
                    res = g.eccentricity();
                case Graph.ECCENTRICITYAV
                    res = mean(g.eccentricity());
                case Graph.TRIANGLES
                    res = g.triangles();
                case Graph.CPL
                    res = mean(g.pl());
                case Graph.CPL_WSG
                    tmp = g.pl();
                    res = mean(tmp(isfinite(tmp)));
                case Graph.PL
                    res = g.pl();
                case Graph.GEFF
                    res = mean(g.geff());
                case Graph.GEFFNODE
                    res = g.geff();
                case Graph.LEFF
                    res = g.leff();
                case Graph.LEFFNODE
                    [~,res] = g.leff();
                case Graph.CLUSTER
                    res = g.cluster();
                case Graph.CLUSTERNODE
                    [~,res] = g.cluster();
                case Graph.BETWEENNESS
                    res = g.betweenness(true);
                case Graph.CLOSENESS
                    res = g.closeness();
                case Graph.TRANSITIVITY
                    res = g.transitivity();
                case Graph.MODULARITY
                    res = g.modularity();
                case Graph.ZSCORE
                    res = g.zscore();
                case Graph.PARTICIPATION
                    res = g.participation();
                case Graph.ASSORTATIVITY
                    res = g.assortativity();
                case Graph.SW
                    res = g.smallworldness();
                case Graph.SW_WSG
                    res = g.smallworldness(true);
            end
        end
        function [gr,R] = randomize(g,bin_swaps,wei_freq)
            % RANDOMIZE randomizes the graph
            %
            % [GR,R] = RANDOMIZE(G) randomizes the graph G and returns the new binary undirected
            %   graph GR and the correlation coefficients between strength sequences
            %   of input and output connection matrices - R.
            %
            % Optional parameters that can be passed to the function:
            %   BIN_SWAPS -    average number of swaps of each edge in binary randomization
            %                  (default) bin_swap = 5 : each edge is rewired 5 times
            %   WEI_FREQ  -    frequency of weight sorting in weighted randomization, must
            %                  be in the range of: 0 < wei_freq <= 1
            %                  (default) wei_freq = 1 : older [<2011] versions of MATLAB
            %                  (default) wei_freq = .1 : newer versions of MATLAB
            %
            % Randomization may be better (and execution time will be slower) for
            %           %   higher values of bin_swaps and wei_freq. Higher values of bin_swaps may
            %           %   enable a more random binary organization, and higher values of wei_freq
            %           %   may enable a more accurate conservation of strength sequences.
            %
            % Reference: "Weight-conserving characterization of complex functional brain
            %             networks", M.Rubinov and O.Sporns
            %             "Specificity and Stability in Topology of Protein Networks", S.Maslov
            %             and K.Sneppen
            %
            % See also GraphBU.
            
            W = g.A;
            if ~exist('bin_swaps','var')
                bin_swaps = 5;
            end
            if ~exist('wei_freq','var')
                if nargin('randperm')==1
                    wei_freq = 1;
                else
                    wei_freq = 0.1;
                end
            end
            
            if wei_freq<=0 || wei_freq>1
                error('wei_freq must be in the range of: 0 < wei_freq <= 1.')
            end
            if wei_freq && wei_freq<1 && nargin('randperm')==1
                warning('wei_freq may only equal 1 in older (<2011) versions of MATLAB.')
                wei_freq = 1;
            end
            
            n = size(W,1);  % number of nodes
            W(1:n+1:end) = 0;  % clear diagonal
            
            Ap = W>0;  % positive adjacency matrix
            if nnz(Ap)<(n*(n-1))  % if Ap not fully connected
                n2 = size(Ap,1);
                [i2 j2] = find(tril(Ap));
                K2 = length(i2);
                bin_swaps = K2*bin_swaps;
                
                % maximal number of rewiring attempts per 'bin_swaps'
                maxAttempts = round(n2*K2/(n2*(n2-1)));
                % actual number of successful rewirings
                eff = 0;
                
                for iter = 1:bin_swaps
                    att = 0;
                    while (att<=maxAttempts)  % while not rewired
                        while 1
                            e1 = ceil(K2*rand);
                            e2 = ceil(K2*rand);
                            while (e2==e1),
                                e2 = ceil(K2*rand);
                            end
                            a = i2(e1); b = j2(e1);
                            c = i2(e2); d = j2(e2);
                            
                            if all(a~=[c d]) && all(b~=[c d]);
                                break  % all four vertices must be different
                            end
                        end
                        
                        if rand>0.5
                            i2(e2) = d; j2(e2) = c;  % flip edge c-d with 50% probability
                            c = i2(e2); d = j2(e2);  % to explore all potential rewirings
                        end
                        
                        % rewiring condition
                        if ~(Ap(a,d) || Ap(c,b))
                            Ap(a,d) = Ap(a,b); Ap(a,b) = 0;
                            Ap(d,a) = Ap(b,a); Ap(b,a) = 0;
                            Ap(c,b) = Ap(c,d); Ap(c,d) = 0;
                            Ap(b,c) = Ap(d,c); Ap(d,c) = 0;
                            
                            j2(e1) = d;  % reassign edge indices
                            j2(e2) = b;
                            eff = eff+1;
                            break;
                        end  % rewiring condition
                        att = att+1;
                    end  % while not rewired
                end  % iterations
                
                Ap_r = Ap;
            else
                Ap_r = Ap;
            end
            An =~ Ap; An(1:n+1:end) = 0;  % negative adjacency matrix
            An_r =~ Ap_r; An_r(1:n+1:end) = 0;  % randomized negative adjacency
            
            W0 = zeros(n);  % null model network
            for s = [1 -1]
                switch s  % switch sign (positive/negative)
                    case 1
                        S = sum(W.*Ap,2);  % positive strength
                        Wv = sort(W(triu(Ap)));  % sorted weights vector
                        [I,J] = find(triu(Ap_r));  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                    case -1
                        S = sum(-W.*An,2);  % negative strength
                        Wv = sort(-W(triu(An)));  % sorted weights vector
                        [I,J] = find(triu(An_r));  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                end
                
                P = (S*S.');  % expected weights matrix
                
                if wei_freq==1
                    for m = numel(Wv):-1:1  % iteratively explore all weights
                        [dum,Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        r = ceil(rand*m);
                        o = Oind(r);  % choose random index of sorted expected weight
                        W0(Lij(o)) = s*Wv(r);  % assign corresponding sorted weight at this index
                        
                        f = 1 - Wv(r)/S(I(o));  % readjust expected weight probabilities for node I(o)
                        P(I(o),:) = P(I(o),:)*f;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        P(:,I(o)) = P(:,I(o))*f;
                        f = 1 - Wv(r)/S(J(o));  % readjust expected weight probabilities for node J(o)
                        P(J(o),:) = P(J(o),:)*f;  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
                        P(:,J(o)) = P(:,J(o))*f;
                        
                        S([I(o) J(o)]) = S([I(o) J(o)])-Wv(r);  % readjust strengths of nodes I(o) and J(o)
                        Lij(o) = [];  % remove current index from further consideration
                        I(o) = [];
                        J(o) = [];
                        Wv(r) = [];  % remove current weight from further consideration
                    end
                else
                    wei_period = round(1/wei_freq);  % convert frequency to period
                    for m = numel(Wv):-wei_period:1  % iteratively explore at the given period
                        [dum,Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        R = randperm(m,min(m,wei_period)).';
                        O = Oind(R);
                        W0(Lij(O)) = s*Wv(R);  % assign corresponding sorted weight at this index
                        
                        WA = accumarray([I(O);J(O)],Wv([R;R]),[n,1]);  % cumulative weight
                        IJu = any(WA,2);
                        F = 1-WA(IJu)./S(IJu);
                        F = F(:,ones(1,n));  % readjust expected weight probabilities for node I(o)
                        P(IJu,:) = P(IJu,:).*F;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        P(:,IJu) = P(:,IJu).*F.';
                        S(IJu) = S(IJu)-WA(IJu);  % re-adjust strengths of nodes I(o) and J(o)
                        
                        O = Oind(R);
                        Lij(O) = [];  % remove current index from further consideration
                        I(O) = [];
                        J(O) = [];
                        Wv(R) = [];  % remove current weight from further consideration
                    end
                end
            end
            W0 = W0+W0.';
            
            rpos = corrcoef(sum( W.*(W>0)),sum( W0.*(W0>0)));
            rneg = corrcoef(sum(-W.*(W<0)),sum(-W0.*(W0<0)));
            R = [rpos(2) rneg(2)];
            
            % Create the new BU graph
            gr = GraphBU(W0);
        end
    end
    methods (Static)
        function mlist = measurelist(nodal)
            % MEASURELIST list of measures valid for a binary undirected graph
            %
            % MLIST = MEASURELIST(G) returns the list of measures MLIST valid
            %   for a bindary undirected graph G.
            %
            % MLIST = MEASURELIST(G,NODAL) returns the list of nodal measures MLIST
            %   valid for a bindary directed graph G if NODAL is a bolean true and
            %   the list of global measures if NODAL is a boolean false.
            %
            % See also GraphBU.
            
            mlist = GraphBU.MEASURES_BU;
            if exist('nodal','var')
                if nodal
                    mlist = mlist(Graph.NODAL(mlist));
                else
                    mlist = mlist(~Graph.NODAL(mlist));
                end
            end
        end
        function n = measurenumber(varargin)
            % MEASURENUMBER number of measures valid for a binary undirected graph
            %
            % N = MEASURENUMBER(G) returns the number of measures N valid for a
            %   bindary undirected graph G.
            %
            % N = MEASURELIST(G,NODAL) returns the number of nodal measures N
            %   valid for a bindary undirected graph G if NODAL is a bolean true and
            %   the number of global measures if NODAL is a boolean false.
            %
            % See also GraphBD, measurelist.
            
            mlist = GraphBU.measurelist(varargin{:});
            n = numel(mlist);
        end
    end
end