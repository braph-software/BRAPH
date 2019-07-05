classdef GraphBD < Graph
    % GraphBD < Graph : Binary directed graph
    %   GraphBD represents a binary directed graph and set of respective measures
    %   that can be calculated on the graph.
    %
    % GraphBD properties (Constant):
    %   MEASURES_BD     -   array of measures defined for binary directed graph
    %
    % GraphBD properties (GetAccess = public, SetAccess = protected):
    %   A               -   connection matrix < Graph
    %   P               -   coefficient p-values < Graph
    %   S               -   community structure < Graph    
    %   C               -   weighted connection matrix
    %   threshold       -   threshold to be applied for binarization
    %
    % GraphBD properties (Access = protected):
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
    %
    % GraphBD methods (Access = protected):
    %   reset_structure_related_measures  -     resets z-score and participation < Graph
    %   copyElement         -   copy community structure < Graph
    %
    % GraphBD methods :
    %   GraphBD             -   constructor
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
    %   density             -   density of a graph
    %   weighted            -   checks if graph is weighted
    %   binary              -   checks if graph is binary
    %   directed            -   checks if graph is directed
    %   undirected          -   checks if graph is undirected
    %   distance            -   shortest path length of nodes from each other
    %   degree              -   degree of a node
    %   triangles           -   number of triangles around a node
    %   geff                -   global efficiency
    %   leff                -   local efficiency
    %   cluster             -   clustering coefficient
    %   betweenness         -   betweenness centrality of a node
    %   transitivity        -   transitivity of a graph
    %   measure             -   calculates given measure
    %   randomize           -   randomizes the graph
    %
    % GraphBD methods (Static):
    %   measurelist         -   list of measures valid for a binary directed graph
    %   measurenumber       -   number of measures valid for a binary directed graph
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
    % See also Graph, GraphBU, Structure.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        MEASURES_BD = [ ...
            Graph.DEGREE ...
            Graph.DEGREEAV ...
            Graph.IN_DEGREE ...
            Graph.IN_DEGREEAV ...
            Graph.OUT_DEGREE ...
            Graph.OUT_DEGREEAV ...
            Graph.RADIUS ...
            Graph.DIAMETER ...
            Graph.ECCENTRICITY ...
            Graph.ECCENTRICITYAV ...
            Graph.IN_ECCENTRICITY ...
            Graph.IN_ECCENTRICITYAV ...
            Graph.OUT_ECCENTRICITY ...
            Graph.OUT_ECCENTRICITYAV ...
            Graph.TRIANGLES ...
            Graph.CPL ...
            Graph.PL ...
            Graph.IN_CPL ...
            Graph.IN_PL ...
            Graph.OUT_CPL ...
            Graph.OUT_PL ...
            Graph.GEFF ...
            Graph.GEFFNODE ...
            Graph.IN_GEFF ...
            Graph.IN_GEFFNODE ...
            Graph.OUT_GEFF ...
            Graph.OUT_GEFFNODE ...
            Graph.LEFF ...
            Graph.LEFFNODE ...
            Graph.IN_LEFF ...
            Graph.IN_LEFFNODE ...
            Graph.OUT_LEFF ...
            Graph.OUT_LEFFNODE ...
            Graph.CLUSTER ...
            Graph.CLUSTERNODE ...
            Graph.BETWEENNESS ...
            Graph.CLOSENESS ...
            Graph.IN_CLOSENESS ...
            Graph.OUT_CLOSENESS ...
            Graph.TRANSITIVITY ...
            Graph.MODULARITY ...
            Graph.ZSCORE ...
            Graph.IN_ZSCORE ...
            Graph.OUT_ZSCORE ...
            Graph.PARTICIPATION ...
            ]
    end
    properties (GetAccess = public, SetAccess = protected)
        C  % weighted correlation matrix
        threshold
    end
    properties (Access = protected)
    end
    methods
        function g = GraphBD(A,varargin)
            % GRAPHBD(A) creates a binary directed graph with default properties
            %
            % GRAPHBD(A,Property1,Value1,Property2,Value2,...) creates a graph from
            %   any connection matrix A and initializes property Property1 to
            %   Value1, Property2 to Value2, ... .
            %   Admissible properties are:
            %     threshold    -   thereshold = 0 (default)
            %     density      -   percent of connections
            %     bins         -   -1:.001:1 (default)
            %     diagonal     -   'exclude' (default) | 'include'
            %     P            -   coefficient p-values
            %     structure    -   community structure object
            %
            % See also Graph, GraphBU.
            
            C = A;
            
            [A,threshold] = Graph.binarize(A,varargin{:});  % binarized connection matrix
            
            g = g@Graph(A,varargin{:});
            g.C = C;
            g.threshold = threshold;
        end
        function d = density(g,varargin)
            % DENSITY density of a graph
            %
            % D = DENSITY(G) calculates the density D of the graph G.
            %
            % D = DENSITY(G,'PropertyName',PropertyValue) calculates the density
            %   of G by using the property PropertyName specified by the PropertyValue.
            %   Admissible properties are:
            %       diagonal   -   'exclude' (default) | 'include'
            %
            % See also GraphBD.
            
            % Diagonal
            diagonal = 'exclude';
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'diagonal')
                    diagonal = varargin{n+1};
                end
            end
            
            A = g.A;
            
            % Analysis
            if strcmp(diagonal,'include')
                d = sum(sum(A))/numel(A)*100;
            else
                B = A(~eye(size(A)));
                d = sum(B)/numel(B)*100;
            end
        end
        function bool = weighted(g)
            % WEIGHTED checks if graph is weighted
            %
            % BOOL = WEIGHTED(G) returns false for binary graphs.
            %
            % See also GraphBD, binary.
            
            bool = false;
        end
        function bool = binary(g)
            % BINARY checks if graph is binary
            %
            % BOOL = BINARY(G) returns true for binary graphs.
            %
            % See also GraphBD, weighted.
            
            bool = true;
        end
        function bool = directed(g)
            % DIRECTED checks if graph is directed
            %
            % BOOL = DIRECTED(G) returns true for directed graphs.
            %
            % See also GraphBD, undirected.
            
            bool = true;
        end
        function bool = undirected(g)
            % UNDIRECTED checks if graph is undirected
            %
            % BOOL = UNDIRECTED(G) returns false for directed graphs.
            %
            % See also GraphBD, directed.
            
            bool = false;
        end
        function D = distance(g)
            % DISTANCE shortest path length of nodes from each other
            %
            % D = DISTANCE(G) returns the distance matrix D which contains lengths
            %   of shortest paths between all pairs of nodes in the graph G. An
            %   entry (u,v) represents the length of shortest path from node u to
            %   node v.
            %
            % Lengths between disconnected nodes are set to Inf. Distances on the main
            %   diagonal are set to 0.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %            "Complex network measures of brain connectivity: Uses and
            %            interpretations", M.Rubinov and O.Sporns
            %
            % See also GraphBD, pl.
            
            if isempty(g.c)
                calc_D()
            end
            D = g.D;
            
            function calc_D()
                l = 1;  % path length
                g.D = g.A;  % distance matrix
                
                Lpath = g.A;
                Idx = true;
                while any(Idx(:))
                    l = l+1;
                    Lpath = Lpath*g.A;
                    Idx = (Lpath~=0)&(g.D==0);
                    g.D(Idx) = l;
                end
                
                g.D(~g.D) = inf;  % assign inf to disconnected nodes
                g.D = Graph.removediagonal(g.D);  % assign 0 to the diagonal
            end
        end
        function [deg,indeg,outdeg] = degree(g)
            % DEGREE degree of a node
            %
            % [DEG,INDEG,OUTDEG] = DEGREE(G) calculates the degree DEG, in-degree
            %   INDEG and out-degree OUTDEG of all nodes in the graph G.
            %
            % The node degree is the number of edges connected to a node. The
            %   in-degree and out-degree is the number of inward and outward edges
            %   respectively. For directed graphs, the degree is the sum of the
            %   inward and outward degrees.
            %
            % In these calculations, the diagonal of connection matrix is removed i.e.
            %   self-connections are not considered.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %            "Complex network measures of brain connectivity: Uses and
            %            interpretations", M.Rubinov and O.Sporns
            %
            % See also GraphBD.
            
            if isempty(g.deg) || isempty(g.indeg) || isempty(g.outdeg)
                A = double(g.A~=0);  % binarizes connection matrix
                A = Graph.removediagonal(A);  % remove diagonal
                
                g.indeg = sum(A,1);  % indegree = column sum of A
                g.outdeg = sum(A,2)';  % outdegree = row sum of A
                g.deg = g.indeg + g.outdeg;  % degree = indegree + outdegree
            end
            
            deg = g.deg;
            indeg = g.indeg;
            outdeg = g.outdeg;
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
            % In directed graphs, a triangle is considered only if the directions
            %   between the three nodes (vertices of the triangle) are arranged as
            %   a cycle i.e. each one of the nodes has one incoming and one outgoing
            %   edge. Thus, each set of 3 nodes contributes to 2 triangles: clockwise
            %   and couterclockwise.
            %
            % Reference: "Clustering in complex directed networks", G.Fagiolo
            %
            % See also GraphBD.
            
            if isempty(g.t)
                A = Graph.removediagonal(g.A);
                N = g.nodenumber();
                g.t = zeros(1,N);
                for u = 1:1:N
                    nodesout = find(A(u,:)~=0);
                    nodesin = find(A(:,u)~=0)';
                    if ~isempty(nodesout) && ~isempty(nodesin)
                        g.t(u) = sum(sum(A(nodesout,nodesin)));
                    end
                end
            end
            
            t = g.t;
        end
        function [ge,gein,geout] = geff(g)
            % GEFF global efficiency
            %
            % [GE,GEIN,GEOUT] = GEFF(G) calculates the global efficiency GE, in-global
            %   GEIN and out-global efficiency GEOUT for all nodes in the graph G.
            %
            % The global efficiency of a node is the average of inverse shortest path length,
            %   and is inversely related to the path length of the node. For directed graphs,
            %   the global efficiency of the node is the average of the inward and outward
            %   global efficiencies.
            %
            % In these calculations, the diagonal of connection matrix is removed i.e.
            %   self-connections are not considered.
            %
            % Reference: "Efficient Behavior of Small-World Networks", V.Latora and M. Marchiori
            %
            % See also GraphBD, distance, pl.
            
            if isempty(g.ge) || isempty(g.gein) || isempty(g.geout)
                D = g.distance();
                N = g.nodenumber();
                Di = Graph.removediagonal(D.^-1);  % removes infinite values on diagonal
                
                g.gein = sum(Di,1)/(N-1);
                g.geout = sum(Di,2)'/(N-1);
                g.ge = mean([g.gein; g.geout],1);
            end
            
            ge = g.ge;
            gein = g.gein;
            geout = g.geout;
        end
        function [le,lenode] = leff(g)
            % LEFF local efficiency
            %
            % [LE,LENODE] = LEFF(G) calculates the local efficiency of each node
            %   LENODE and mean local efficiency LE of the graph G.
            %
            % The local efficiency of a node is the global efficiency calculated
            %   on the subgraph created by the neighbours of the node and is related
            %   to the clustering coefficient.
            %
            % In these calculations, the diagonal of connection matrix is removed i.e.
            %   self-connections are not considered.
            %
            % Reference: "Efficient Behavior of Small-World Networks", V.Latora and M. Marchiori
            %
            % See also GraphBD, geff.
            
            if isempty(g.le) || isempty(g.lenode)
                N = g.nodenumber();
                A = Graph.removediagonal(g.A);
                
                g.lenode = zeros(1,N);
                for u = 1:1:N
                    nodes = find(A(u,:) | A(:,u).');  % neighbours of u
                    if length(nodes)>1
                        sg = g.subgraph(nodes);  % subgraph of the neighbours
                        g.lenode(u) = mean(sg.geff());
                    end
                end
                
                g.lenode = g.lenode;
                g.le = mean(g.lenode);
            end
            
            le = g.le;
            lenode = g.lenode;
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
            % In directed graphs, a triangle is considered only if the directions
            %   between the three nodes (vertices of the triangle) are arranged as
            %   a cycle. For this configuration, number of all neighbouring pairs
            %   is given by din*dout-dii where din and dout are the in and out-degree
            %   of the node and dii are the 'false pairs' (i<->j) which do not form triangles.
            %
            % Reference: "Clustering in complex directed networks", G.Fagiolo
            %
            % See also GraphBD, triangles.
            
            if isempty(g.cl) || isempty(g.clnode)
                A = Graph.removediagonal(g.A);
                N = g.nodenumber();
                
                [~,indeg,outdeg] = g.degree();
                t = g.triangles();
                
                indeg(t==0) = inf;  % if no 3-cycles exist, make C = 0 (via indeg = inf)
                outdeg(t==0) = inf;
                false_connections = diag(A^2);
                CYC3 = indeg.*outdeg-false_connections';
                
                g.clnode = t./CYC3;
                g.cl = mean(g.clnode);
            end
            
            cl = g.cl;
            clnode = g.clnode;
        end
        function b = betweenness(g,normalized)
            % BETWEENNESS betweenness centrality of a node
            %
            % B = BETWEENNESS(G) calculates the betweenness centrality B of all
            %   nodes of the graph G.
            %
            % B = BETWEENNESS(G,NORMALIZED) calculates the betweenness centrality
            %   B and normalizes it to the range [0,1] if NORMALIZED is equal to true (default).
            %   If NORMALIZED is equal to false, the betweenness is not normalized.
            %
            % Betweenness centrality of a node is defined as the fraction of
            %   all shortest paths in a graph G that contain that node. Nodes
            %   that have high value of betweenness centrality participate in
            %   a large number of shortest paths.
            %
            % Betweenness centrality B may be normalised to the range [0,1] as
            %   B/[(N-1)(N-2)], where N is the number of nodes in the graph.
            %
            %   Reference: "Betweenness centrality: Algorithms and Lower Bounds", S.Kintali
            %              (generalization to directed and disconnected graphs)
            %              "Complex network measures of brain connectivity: Uses and
            %              interpretations", M.Rubinov and O.Sporns
            %
            % See also GraphBD.
            
            if isempty(g.b)
                A = g.A;
                N = g.nodenumber();  % number of nodes
                I = eye(N)~=0;  % logical identity matrix
                d = 1;  % path length
                NPd = A;  % number of paths of length |d|
                NSPd = NPd;  % number of shortest paths of length |d|
                NSP = NSPd; NSP(I) = 1;  % number of shortest paths of any length
                L = NSPd; L(I) = 1;  % length of shortest paths
                
                % calculate NSP and L
                while find(NSPd,1);
                    d = d+1;
                    NPd = NPd*A;
                    NSPd = NPd.*(L==0);
                    NSP = NSP+NSPd;
                    L = L+d.*(NSPd~=0);
                end
                L(~L) = inf; L(I) = 0;  % L for disconnected vertices is inf
                NSP(~NSP) = 1;  % NSP for disconnected vertices is 1
                
                At = A.';
                DP = zeros(N);  % vertex on vertex dependency
                diam = d-1;  % graph diameter
                % calculate DP
                for d = diam:-1:2
                    DPd1 = (((L==d).*(1+DP)./NSP)*At).*((L==(d-1)).*NSP);
                    DP = DP + DPd1;  % DPd1: dependencies on vertices |d-1| from source
                end
                
                g.b = sum(DP,1);  % compute betweenness
                
            end
            b = g.b;
            
            if exist('normalized') && normalized
                N = g.nodenumber();
                b = b/((N-1)*(N-2));
            end
        end
        function tr = transitivity(g)
            % TRANSITIVITY transitivity of a graph
            %
            % TR = TRANSITIVITY(G) calculates the transitivity of the graph G.
            %
            % Transitivity of a graph is defined as the fraction of triangles to
            %   triplets in a graph. In directed graphs, a triangle is considered
            %   only if the directions between the three nodes (vertices of the
            %   triangle) are arranged as a cycle. A triple is defined as a node
            %   which is connected to an unordered pair of other nodes.
            %
            % The number of all (in or out) neighbour pairs is K(K-1)/2. Each
            %   neighbour pair may generate two triangles. "False pairs" are i<->j
            %   edge pairs (these do not generate triangles). The number of false
            %   pairs is the main diagonal of A^2. Thus the maximum possible number
            %   of triangles = (2 edges)*([ALL PAIRS] - [FALSE PAIRS])
            %                     = 2 * (K(K-1)/2 - diag(A^2))
            %                     = K(K-1) - 2(diag(A^2))
            %
            %   Reference: "Ego-centered networks and the ripple effect", M.E.J. Newman
            %
            % See also GraphBD, triangles, cluster.
            
            if isempty(g.tr)
                A = Graph.removediagonal(g.A);
                N = g.nodenumber();
                
                [K,~,~] = g.degree();
                t = g.triangles();  % number of 3-cycles (directed triangles)
                false_connections = 2*diag(A^2);
                CYC3 = K'.*(K'-1)-false_connections;  % number of all possible triplets
                
                if any(CYC3)
                    g.tr = 3*sum(t)./sum(CYC3);  % transitivity
                else % if no 3-cycles exist
                    g.tr = 0;
                end
            end
            
            tr = g.tr;
        end
        function res = measure(g,mi)
            % MEASURE calculates given measure
            %
            % RES = MEASURE(G,MI) calculates the measure of the graph G specified
            %   by MI and returns the result RES.
            %   Admissible measures for binary directed graphs are:
            %     Graph.DEGREE
            %     Graph.DEGREEAV
            %     Graph.IN_DEGREE
            %     Graph.IN_DEGREEAV
            %     Graph.OUT_DEGREE
            %     Graph.OUT_DEGREEAV
            %     Graph.RADIUS
            %     Graph.DIAMETER
            %     Graph.ECCENTRICITY
            %     Graph.ECCENTRICITYAV
            %     Graph.IN_ECCENTRICITY
            %     Graph.IN_ECCENTRICITYAV
            %     Graph.OUT_ECCENTRICITY
            %     Graph.OUT_ECCENTRICITYAV
            %     Graph.TRIANGLES
            %     Graph.CPL
            %     Graph.PL
            %     Graph.IN_CPL
            %     Graph.IN_PL
            %     Graph.OUT_CPL
            %     Graph.OUT_PL
            %     Graph.GEFF
            %     Graph.GEFFNODE
            %     Graph.IN_GEFF
            %     Graph.IN_GEFFNODE
            %     Graph.OUT_GEFF
            %     Graph.OUT_GEFFNODE
            %     Graph.LEFF
            %     Graph.LEFFNODE
            %     Graph.CLUSTER
            %     Graph.CLUSTERNODE
            %     Graph.BETWEENNESS
            %     Graph.CLOSENESS
            %     Graph.IN_CLOSENESS
            %     Graph.OUT_CLOSENESS
            %     Graph.TRANSITIVITY
            %     Graph.MODULARITY
            %     Graph.ZSCORE
            %     Graph.IN_ZSCORE
            %     Graph.OUT_ZSCORE
            %     Graph.PARTICIPATION
            %     Graph.SW
            %
            % See also GraphBD.
            
            if ~any(GraphBD.measurelist()==mi)
                g.ERR_MEASURE_NOT_DEFINED(mi)
            end
            
            switch mi
                case Graph.DEGREE
                    res = g.degree();
                case Graph.DEGREEAV
                    res = mean(g.degree());
                case Graph.IN_DEGREE
                    [~,res] = g.degree();
                case Graph.IN_DEGREEAV
                    [~,res] = g.degree();
                    res = mean(res);
                case Graph.OUT_DEGREE
                    [~,~,res] = g.degree();
                case Graph.OUT_DEGREEAV
                    [~,~,res] = g.degree();
                    res = mean(res);
                case Graph.RADIUS
                    res = g.radius();
                case Graph.DIAMETER
                    res = g.diameter();
                case Graph.ECCENTRICITY
                    res = g.eccentricity();
                case Graph.ECCENTRICITYAV
                    res = mean(g.eccentricity());
                case Graph.IN_ECCENTRICITY
                    [~,res] = g.eccentricity();
                case Graph.IN_ECCENTRICITYAV
                    [~,res] = g.eccentricity();
                    res = mean(res);
                case Graph.OUT_ECCENTRICITY
                    [~,~,res] = g.eccentricity();
                case Graph.OUT_ECCENTRICITYAV
                    [~,~,res] = g.eccentricity();
                    res = mean(res);
                case Graph.TRIANGLES
                    res = g.triangles();
                case Graph.CPL
                    res = mean(g.pl());
                case Graph.PL
                    res = g.pl();
                case Graph.IN_CPL
                    [~,res] = g.pl();
                    res = mean(res);
                case Graph.IN_PL
                    [~,res] = g.pl();
                case Graph.OUT_CPL
                    [~,~,res] = g.pl();
                    res = mean(res);
                case Graph.OUT_PL
                    [~,~,res] = g.pl();
                case Graph.GEFF
                    res = mean(g.geff());
                case Graph.GEFFNODE
                    res = g.geff();
                case Graph.IN_GEFF
                    [~,res] = g.geff();
                    res = mean(res);
                case Graph.IN_GEFFNODE
                    [~,res] = g.geff();
                case Graph.OUT_GEFF
                    [~,~,res] = g.geff();
                    res = mean(res);
                case Graph.OUT_GEFFNODE
                    [~,~,res] = g.geff();
                case Graph.LEFF
                    res = mean(g.leff());
                case Graph.LEFFNODE
                    [~,res] = g.leff();
                % case Graph.IN_LEFF
                % case Graph.IN_LEFFNODE
                % case Graph.OUT_LEFF
                % case Graph.OUT_LEFFNODE
                case Graph.CLUSTER
                    res = g.cluster();
                case Graph.CLUSTERNODE
                    [~,res] = g.cluster();
                case Graph.BETWEENNESS
                    res = g.betweenness(true);
                case Graph.CLOSENESS
                    res = g.closeness();
                case Graph.IN_CLOSENESS
                    [~,res] = g.closeness();
                case Graph.OUT_CLOSENESS
                    [~,~,res] = g.closeness();
                case Graph.TRANSITIVITY
                    res = g.transitivity();
                case Graph.MODULARITY
                    res = g.modularity();
                case Graph.ZSCORE
                    res = g.zscore();
                case Graph.IN_ZSCORE
                    [~,res] = g.zscore();
                case Graph.OUT_ZSCORE
                    [~,~,res] = g.zscore();
                case Graph.PARTICIPATION
                    res = g.participation();
                case Graph.SW
                    res = g.smallworldness();
                case Graph.SW_WSG
                    res = g.smallworldness(true);
            end
        end
        function [gr,R] = randomize(g,bin_swaps,wei_freq)
            % RANDOMIZE randomizes the graph
            %
            % [GR,R] = RANDOMIZE(G) randomizes the graph G and returns the new binary directed
            %   graph GR and the correlation coefficients R, between strength sequences
            %   of input and output connection matrices.
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
            %   higher values of bin_swaps and wei_freq. Higher values of bin_swaps may
            %   enable a more random binary organization, and higher values of wei_freq
            %   may enable a more accurate conservation of strength sequences.
            %
            % Reference: "Weight-conserving characterization of complex functional brain
            %             networks", M.Rubinov and O.Sporns
            %             "Specificity and Stability in Topology of Protein Networks", S.Maslov
            %             and K.Sneppen
            %
            % See also GraphBD.
            
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
                wei_freq=1;
            end
            
            n = size(W,1);  % number of nodes
            W(1:n+1:end) = 0;  % clear diagonal
            
            Ap = W>0;  % positive adjacency matrix
            if nnz(Ap) < (n*(n-1))  % if Ap not fully connected
                n2 = size(Ap,1);
                [i2 j2] = find(Ap);
                K2 = length(i2);
                bin_swaps = K2*bin_swaps;
                
                % maximal number of rewiring attempts per 'bin_swaps'
                maxAttempts = round(n2*K2/(n2*(n2-1)));
                % actual number of successful rewirings
                eff = 0;
                
                for bin_swaps=1:bin_swaps
                    att = 0;
                    while (att<=maxAttempts)  % while not rewired
                        while 1
                            e1 = ceil(K2*rand);
                            e2 = ceil(K2*rand);
                            while (e2 == e1),
                                e2 = ceil(K2*rand);
                            end
                            a = i2(e1); b = j2(e1);
                            c = i2(e2); d = j2(e2);
                            
                            if all(a ~= [c d]) && all(b ~= [c d]);
                                break  % all four vertices must be different
                            end
                        end
                        
                        % rewiring condition
                        if ~(Ap(a,d) || Ap(c,b))
                            Ap(a,d) = Ap(a,b); Ap(a,b) = 0;
                            Ap(c,b) = Ap(c,d); Ap(c,d) = 0;
                            
                            j2(e1) = d;  % reassign edge indices
                            j2(e2) = b;
                            eff = eff+1;
                            break;
                        end  % rewiring condition
                        att = att+1;
                    end  % while not rewired
                end  % bin_swapsations
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
                        Si = sum(W.*Ap,1).';  % positive in-strength
                        So = sum(W.*Ap,2);  % positive out-strength
                        Wv = sort(W(Ap));  % sorted weights vector
                        [I, J] = find(Ap_r);  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                    case -1
                        Si = sum(-W.*An,1).';  % negative in-strength
                        So = sum(-W.*An,2);  % negative out-strength
                        Wv = sort(-W(An));  % sorted weights vector
                        [I, J] = find(An_r);  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                end
                
                P = (So*Si.');  % expected weights matrix
                
                if wei_freq==1
                    for m = numel(Wv):-1:1  % iteratively explore all weights
                        [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        r = ceil(rand*m);
                        o = Oind(r);  % choose random index of sorted expected weight
                        W0(Lij(o)) = s*Wv(r);  % assign corresponding sorted weight at this index
                        
                        f = 1 - Wv(r)/So(I(o));  % readjust expected weight probabilities for node I(o)
                        P(I(o),:) = P(I(o),:)*f;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        f = 1 - Wv(r)/Si(J(o));  % readjust expected weight probabilities for node J(o)
                        P(:,J(o)) = P(:,J(o))*f;  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
                        
                        So(I(o)) = So(I(o)) - Wv(r);  % readjust in-strength of node I(o)
                        Si(J(o)) = Si(J(o)) - Wv(r);  % readjust out-strength of node J(o)
                        Lij(o) = [];  % remove current index from further consideration
                        I(o) = [];
                        J(o) = [];
                        Wv(r) = [];  % remove current weight from further consideration
                    end
                else
                    wei_period = round(1/wei_freq);  % convert frequency to period
                    for m = numel(Wv):-wei_period:1  % iteratively explore at the given period
                        [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        R = randperm(m,min(m,wei_period)).';
                        
                        O = Oind(R);  % choose random index of sorted expected weight
                        W0(Lij(O)) = s*Wv(R);  % assign corresponding sorted weight at this index
                        
                        WAi = accumarray(I(O),Wv(R),[n,1]);
                        Iu = any(WAi,2);
                        F = 1 - WAi(Iu)./So(Iu);  % readjust expected weight probabilities for node I(o)
                        P(Iu,:) = P(Iu,:).*F(:,ones(1,n));  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        So(Iu) = So(Iu) - WAi(Iu);  % readjust in-strength of node I(o)
                        
                        WAj = accumarray(J(O),Wv(R),[n,1]);
                        Ju = any(WAj,2);
                        F = 1 - WAj(Ju)./Si(Ju);  % readjust expected weight probabilities for node J(o)
                        P(:,Ju) = P(:,Ju).*F(:,ones(1,n)).';  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
                        Si(Ju) = Si(Ju) - WAj(Ju);  % readjust out-strength of node J(o)
                        
                        O = Oind(R);
                        Lij(O) = [];  % remove current index from further consideration
                        I(O) = [];
                        J(O) = [];
                        Wv(R) = [];  % remove current weight from further consideration
                    end
                end
            end
            
            rpos_in = corrcoef(sum( W.*(W>0),1), sum( W0.*(W0>0),1) );
            rpos_ou = corrcoef(sum( W.*(W>0),2), sum( W0.*(W0>0),2) );
            rneg_in = corrcoef(sum(-W.*(W<0),1), sum(-W0.*(W0<0),1) );
            rneg_ou = corrcoef(sum(-W.*(W<0),2), sum(-W0.*(W0<0),2) );
            R = [rpos_in(2) rpos_ou(2) rneg_in(2) rneg_ou(2)];
            
            % Create the new BD graph
            gr = GraphBD(W0);
        end
    end
    methods (Static)
        function mlist = measurelist(nodal)
            % MEASURELIST list of measures valid for a binary directed graph
            %
            % MLIST = MEASURELIST(G) returns the list of measures MLIST valid
            %   for a bindary directed graph G.
            %
            % MLIST = MEASURELIST(G,NODAL) returns the list of nodal measures MLIST
            %   valid for a bindary directed graph G if NODAL is a bolean true and
            %   the list of global measures if NODAL is a boolean false.
            %
            % See also GraphBD.
            
            mlist = GraphBD.MEASURES_BD;
            if exist('nodal','var')
                if nodal
                    mlist = mlist(Graph.NODAL(mlist));
                else
                    mlist = mlist(~Graph.NODAL(mlist));
                end
            end
        end
        function n = measurenumber(varargin)
            % MEASURENUMBER number of measures valid for a binary directed graph
            %
            % N = MEASURENUMBER(G) returns the number of measures N valid for a
            %   bindary directed graph G.
            %
            % N = MEASURELIST(G,NODAL) returns the number of nodal measures N
            %   valid for a bindary directed graph G if NODAL is a bolean true and
            %   the number of global measures if NODAL is a boolean false.
            %
            % See also GraphBD, measurelist.
            
            mlist = GraphBD.measurelist(varargin{:});
            n = numel(mlist);
        end
    end
end