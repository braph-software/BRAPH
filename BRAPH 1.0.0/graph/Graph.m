classdef Graph < handle & matlab.mixin.Copyable
    % Graph < handle & matlab.mixin.Copyable (Abstract) : Creates and implements graph
    %   Graph represents graph and a set of measures that can be calculated
    %   on an instance of a graph.
    %   Instances of this class cannot be created. Use one of the subclasses
    %   (e.g., GraphBD, GraphBU, GraphWD, GraphWU).
    %
    % Graph properties (Constant):
    %   A measure denoted by MEAS can have 4 properties. The properties
    %   addmissible to any measure are defined as follows:
    %   MEAS        -   order number for the measure
    %   MEAS_NAME   -   name of the measure
    %   MEAS_NODAL  -   logical expression of nodality of the measure
    %   MEAS_TXT    -   description of the measure
    %
    %   Example: The measure DEGREE is a nodal measure of the number of connections
    %   of each node in a graph. It has the following properties:
    %       DEGREE = 1;
    %       DEGREE_NAME = 'degree';
    %       DEGREE_NODAL = true;
    %       DEGREE_TXT = 'The degree of a node is the number of edges connected to the node.
    %                      Connection weights are ignored in calculations.'
    %
    % The measures that can be calculated are the following:
    %   DEGREE              -   degree of a node
    %   DEGREEAV            -   average degree of a graph
    %   IN_DEGREE           -   in-degree of a node
    %   IN_DEGREEAV         -   average in-degree of a graph
    %   OUT_DEGREE          -   out-degree of a node
    %   OUT_DEGREEAV        -   average out-degree of a graph
    %   STRENGTH            -   strength of a node
    %   STRENGTHAV          -   average strength of a graph
    %   IN_STRENGTH         -   in-strength of a node
    %   IN_STRENGTHAV       -   average in-strength of a graph
    %   OUT_STRENGTH        -   out-strength of a node
    %   OUT_STRENGTHAV      -   average out-strength of a graph
    %   TRIANGLES           -   number of triangles around a node
    %   CPL                 -   characteristic path length of a graph
    %   PL                  -   path length of a node
    %   IN_CPL              -   characteristic in-path length of a graph
    %   IN_PL               -   in-path length of a node
    %   OUT_CPL             -   characteristic out-path length of a graph
    %   OUT_PL              -   out-path length of a node
    %   GEFF                -   global efficiency of a graph
    %   GEFFNODE            -   global efficiency of a node
    %   IN_GEFF             -   in-global efficiency of a graph
    %   IN_GEFFNODE         -   in-global efficiency of a node
    %   OUT_GEFF            -   out-global efficiency of a graph
    %   OUT_GEFFNODE        -   out-global efficiency of a node
    %   LEFF                -   local efficiency of a graph
    %   LEFFNODE            -   local efficiency of a node
    %   IN_LEFF             -   in-local efficiency of a graph
    %   IN_LEFFNODE         -   in-local efficiency of a node
    %   OUT_LEFF            -   out-local efficiency of a graph
    %   OUT_LEFFNODE        -   out-local efficiency of a node
    %   CLUSTER             -   clustering coefficient of a graph
    %   CLUSTERNODE         -   clustering coefficient around a node
    %   MODULARITY          -   modularity
    %   BETWEENNESS         -   betweenness centrality of a node
    %   CLOSENESS           -   closeness centrality of a node
    %   IN_CLOSENESS        -   in-closeness centrality of a node
    %   OUT_CLOSENESS       -   out-closeness centrality of a node
    %   ZSCORE              -   within module degree z-score of a node
    %   IN_ZSCORE           -   within module degree in-z-score of a node
    %   OUT_ZSCORE          -   within module degree out-z-score of a node
    %   PARTICIPATION       -   participation
    %   TRANSITIVITY        -   transitivity of a graph
    %   ECCENTRICITY        -   eccentricity of a node
    %   ECCENTRICITYAV      -   average eccentricity of a graph
    %   IN_ECCENTRICITY     -   in-eccentricity of a node
    %   IN_ECCENTRICITYAV   -   average in-eccentricity of a graph
    %   OUT_ECCENTRICITY    -   out-eccentricity of a node
    %   OUT_ECCENTRICITYAV  -   average out-eccentricity of a graph
    %   RADIUS              -   minimum eccentricity of a graph
    %   DIAMETER            -   maximum eccentricity of a graph
    %   CPL_WSG             -   characteristic path length of a graph (within connected subgraphs)
    %   ASSORTATIVITY       -   assortativity
    %   SW                  -   small worldness
    %   SW_WSG              -   small worldness (within connected subgraphs)
    %
    %   NAME     -   array of names of the measures
    %   NODAL    -   array of logical expressions of nodality of the measures
    %   TXT      -   array of descriptions of the measure
    %
    % Graph properties (GetAccess = public, SetAccess = protected):
    %   A        -   connection matrix
    %   P        -   coefficient p-values
    %   S        -   default community structure
    %
    % Graph properties (Access = protected):
    %   N        -   number of nodes
    %   D        -   matrix of the shortest path lengths
    %   deg      -   degree
    %   indeg    -   in-degree
    %   outdeg   -   out-degree
    %   str      -   strength
    %   instr    -   in-strength
    %   outstr   -   out-strength
    %   ecc      -   eccentricity
    %   eccin    -   in-eccentricity
    %   eccout   -   out-eccentricity
    %   t        -   triangles
    %   c        -   path length
    %   cin      -   in-path length
    %   cout     -   out-path length
    %   ge       -   global efficiency
    %   gein     -   in-global efficiency
    %   geout    -   out-global efficiency
    %   le       -   local efficiency
    %   lenode   -   local efficiency of a node
    %   cl       -   clustering coefficient
    %   clnode   -   clustering coefficient of a node
    %   b        -   betweenness (non-normalized)
    %   tr       -   transitivity
    %   clo      -   closeness
    %   cloin    -   in-closeness
    %   cloout   -   out-closeness
    %   Ci       -   structure    
    %   m        -   modularity
    %   z        -   z-score
    %   zin      -   in-z-score
    %   zout     -   out-z-score
    %   p        -   participation
    %   a        -   assortativity
    %   sw       -   small-worldness
    %   sw_wsg   -   small-worldness
    %
    % Graph methods (Access = protected):
    %   Graph                               -   constructor
    %   reset_structure_related_measures    -   resets z-score and participation
    %   copyElement                         -   copy community structure
    %
    % Graph methods (Abstract):
    %   weighted     -   weighted graph
    %   binary       -   binary graph
    %   directed	 -   direced graph
    %   undirected   -   undirected graph
    %   distance     -   distance between nodes (shortest path length)
    %   measure      -   calculates given measure
    %   randomize    -   randomize graph while preserving degree distribution
    %
    % Graph methods :
    %   subgraph            -   creates subgraph from given nodes
    %   nodeattack          -   removes given nodes from a graph
    %   edgeattack          -   removes given edges from a graph
    %   nodenumber          -   number of nodes in a graph
    %   radius              -   radius of a graph
    %   diameter            -   diameter of a graph
    %   eccentricity        -   eccentricity of nodes
    %   pl                  -   path length of nodes
    %   closeness           -   closeness centrality of nodes
    %   structure           -   community structures of a graph
    %   modularity          -   modularty of a graph
    %   zscore              -   within module degree z-score
    %   participation       -   participation coefficient of nodes
    %   smallworldness       -   small-wordness of the graph
    %
    % Graph methods (Static):
    %   removediagonal      -   replaces matrix diagonal with given value
    %   symmetrize          -   symmetrizes a matrix
    %   histogram           -   histogram of a matrix
    %   binarize            -   binarizes a matrix
    %   plotw               -   plots a weighted matrix
    %   plotb               -   plots a binary matrix
    %   hist                -   plots the histogram and density of a matrix
    %   isnodal             -   checks if measure is nodal
    %   isglobal            -   checks if measure is global
    %
    % Graph methods (Static, Abstract):
    %   measurelist         -   list of measures valid for a graph
    %   measurenumber       -   number of measures valid for a graph
    %
    % See also GraphBD, GraphBU, GraphWD, GraphWU, Structure, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        % measures
        DEGREE = 1;
        DEGREE_NAME = 'degree';
        DEGREE_NODAL = true;
        DEGREE_TXT = 'The degree of a node is the number of edges connected to the node. Connection weights are ignored in calculations.';
        
        DEGREEAV = 2;
        DEGREEAV_NAME = 'av. degree';
        DEGREEAV_NODAL = false;
        DEGREEAV_TXT = 'The average degree of a graph is the average node degree. The node degree is the number of edges connected to the node. Connection weights are ignored in calculations.';
        
        IN_DEGREE = 3;
        IN_DEGREE_NAME = 'in-degree';
        IN_DEGREE_NODAL = true;
        IN_DEGREE_TXT = 'In directed graphs, the in-degree of a node is the number of inward edges. Connection weights are ignored in calculations.';
        
        IN_DEGREEAV = 4;
        IN_DEGREEAV_NAME = 'av. in-degree';
        IN_DEGREEAV_NODAL = true;
        IN_DEGREEAV_TXT = 'In directed graphs, the average in-degree is the average node in-degree. The node in-degree of a node is the number of inward edges. Connection weights are ignored in calculations.';
        
        OUT_DEGREE = 5;
        OUT_DEGREE_NAME = 'out-degree';
        OUT_DEGREE_NODAL = true;
        OUT_DEGREE_TXT = 'In directed graphs, the out-degree of a node is the number of outward edges. Connection weights are ignored in calculations.';
        
        OUT_DEGREEAV = 6;
        OUT_DEGREEAV_NAME = 'av. out-degree';
        OUT_DEGREEAV_NODAL = true;
        OUT_DEGREEAV_TXT = 'In directed graphs, the average out-degree is the average node out-degree. The node out-degree of a node is the number of outward edges. Connection weights are ignored in calculations.';
        
        STRENGTH = 7;
        STRENGTH_NAME = 'strength';
        STRENGTH_NODAL = true;
        STRENGTH_TXT = 'The strength of a node is the sum of the weights of the edges connected to the node.';
        
        STRENGTHAV = 8;
        STRENGTHAV_NAME = 'av. strength';
        STRENGTHAV_NODAL = false;
        STRENGTHAV_TXT = 'The average strength of a graph is the average node strength. The node strength is the sum of the weights of the edges connected to the node.';
        
        IN_STRENGTH = 9;
        IN_STRENGTH_NAME = 'in-strength';
        IN_STRENGTH_NODAL = true;
        IN_STRENGTH_TXT = 'In directed graphs, the in-strength of a node is the sum of inward edge weights. Connection weights are ignored in calculations.';
        
        IN_STRENGTHAV = 10;
        IN_STRENGTHAV_NAME = 'av. in-strength';
        IN_STRENGTHAV_NODAL = true;
        IN_STRENGTHAV_TXT = 'In directed graphs, the average in-strength is the average node in-strength. The node in-strength of a node is the sum of inward edge weights.';
        
        OUT_STRENGTH = 11;
        OUT_STRENGTH_NAME = 'out-strength';
        OUT_STRENGTH_NODAL = true;
        OUT_STRENGTH_TXT = 'In directed graphs, the out-strength of a node is the sum of outward edge weights.';
        
        OUT_STRENGTHAV = 12;
        OUT_STRENGTHAV_NAME = 'av. out-strength';
        OUT_STRENGTHAV_NODAL = true;
        OUT_STRENGTHAV_TXT = 'In directed graphs, the average out-strength is the average node out-strength. The node out-strength of a node is the sum of outward edge weights.';
        
        TRIANGLES = 13;
        TRIANGLES_NAME = 'triangles';
        TRIANGLES_NODAL = true;
        TRIANGLES_TXT = 'The number of triangles around a node is the numbers of couples of node neighbors that are connected.';
        
        CPL = 14;
        CPL_NAME = 'char. path length';
        CPL_NODAL = false;
        CPL_TXT = 'The characteristic path length of a graph is the average shortest path length in the graph. It is the average of the path length of all nodes in the graph.';
        
        PL = 15;
        PL_NAME = 'path length';
        PL_NODAL = true;
        PL_TXT = 'For undirected graphs, the path length of a node is the average path length from the note to all other nodes. For directed graphs, it is the sum of the in-path length and of the out-path length.';
        
        IN_CPL = 16;
        IN_CPL_NAME = 'char. path length (in)';
        IN_CPL_NODAL = false;
        IN_CPL_TXT = 'The characteristic in-path length of a graph is the average of the in-path length of all nodes in the graph.';
        
        IN_PL = 17;
        IN_PL_NAME = 'path length (in)';
        IN_PL_NODAL = true;
        IN_PL_TXT = 'The in-path length of a node is the average path length from the node itself to all other nodes.';
        
        OUT_CPL = 18;
        OUT_CPL_NAME = 'char. path length (out)';
        OUT_CPL_NODAL = false;
        OUT_CPL_TXT = 'The characteristic out-path length of a graph is the average of the out-path length of all nodes in the graph.';
        
        OUT_PL = 19;
        OUT_PL_NAME = 'path length (out)';
        OUT_PL_NODAL = true;
        OUT_PL_TXT = 'The out-path length of a node is the average path length from all other nodes to the node itself.';
        
        GEFF = 20;
        GEFF_NAME = 'global efficiency';
        GEFF_NODAL = false;
        GEFF_TXT = 'The global efficiency is the average inverse shortest path length in the graph. It is inversely related to the characteristic path length.';
        
        GEFFNODE = 21;
        GEFFNODE_NAME = 'global efficiency nodes';
        GEFFNODE_NODAL = true;
        GEFFNODE_TXT = 'The global efficiency of a node is the average inverse shortest path length of the node. It is inversely related to the path length of the node.';
        
        IN_GEFF = 22;
        IN_GEFF_NAME = 'global efficiency (in)';
        IN_GEFF_NODAL = false;
        IN_GEFF_TXT = 'The characteristic in-global efficiency of a graph is the average of the in-global efficiency of all nodes in the graph.';
        
        IN_GEFFNODE = 23;
        IN_GEFFNODE_NAME = 'global efficiency nodes (in)';
        IN_GEFFNODE_NODAL = true;
        IN_GEFFNODE_TXT = 'The in-global efficiency of a node is the average inverse path length from the node itself to all other nodes.';
        
        OUT_GEFF = 24;
        OUT_GEFF_NAME = 'global efficiency (out)';
        OUT_GEFF_NODAL = false;
        OUT_GEFF_TXT = 'The characteristic out-global efficiency of a graph is the average of the out-global efficiency of all nodes in the graph.';
        
        OUT_GEFFNODE = 25;
        OUT_GEFFNODE_NAME = 'global efficiency nodes (out)';
        OUT_GEFFNODE_NODAL = true;
        OUT_GEFFNODE_TXT = 'The out-global efficiency of a node is the average inverse path length from all other nodes to the node itself.';
        
        LEFF = 26;
        LEFF_NAME = 'local efficiency';
        LEFF_NODAL = false;
        LEFF_TXT = 'The local efficiency of a graph is the average of the local efficiencies of its nodes. It is related to clustering coefficient.';
        
        LEFFNODE = 27;
        LEFFNODE_NAME = 'local efficiency nodes';
        LEFFNODE_NODAL = true;
        LEFFNODE_TXT = 'The local efficiency of a node is the global efficiency of the node computed on the node''s neighborhood';
        
        IN_LEFF = 28;
        IN_LEFF_NAME = 'local efficiency (in)';
        IN_LEFF_NODAL = false;
        IN_LEFF_TXT = 'The in-local efficiency of a graph is the average of the in-local efficiencies of its nodes.';
        
        IN_LEFFNODE = 29;
        IN_LEFFNODE_NAME = 'local efficiency nodes (in)';
        IN_LEFFNODE_NODAL = true;
        IN_LEFFNODE_TXT = 'The in-local efficiency of a node is the in-global efficiency of the node computed on the node''s neighborhood';
        
        OUT_LEFF = 30;
        OUT_LEFF_NAME = 'local efficiency (out)';
        OUT_LEFF_NODAL = false;
        OUT_LEFF_TXT = 'The out-local efficiency of a graph is the average of the out-local efficiencies of its nodes.';
        
        OUT_LEFFNODE = 31;
        OUT_LEFFNODE_NAME = 'local efficiency nodes (out)';
        OUT_LEFFNODE_NODAL = true;
        OUT_LEFFNODE_TXT = 'The out-local efficiency of a node is the out-global efficiency of the node computed on the node''s neighborhood';
        
        CLUSTER = 32;
        CLUSTER_NAME = 'clustering';
        CLUSTER_NODAL = false;
        CLUSTER_TXT = 'The clustering coefficient of a graph is the average of the clustering coefficients of its nodes.';
        
        CLUSTERNODE = 33;
        CLUSTERNODE_NAME = 'clustering nodes';
        CLUSTERNODE_NODAL = true;
        CLUSTERNODE_TXT = 'The clustering coefficient is the fraction of triangles around a node. It is equivalent to the fraction of a node''s neighbors that are neighbors of each other.';
        
        MODULARITY = 34;
        MODULARITY_NAME = 'modularity';
        MODULARITY_NODAL = false;
        MODULARITY_TXT = 'The modularity is a statistic that quantifies the degree to which the graph may be subdivided into such clearly delineated groups.';
        
        BETWEENNESS = 35;
        BETWEENNESS_NAME = 'betweenness centrality';
        BETWEENNESS_NODAL = true;
        BETWEENNESS_TXT = 'Node betweenness centrality of a node is the fraction of all shortest paths in the graph that contain a given node. Nodes with high values of betweenness centrality participate in a large number of shortest paths.';
        
        CLOSENESS = 36;
        CLOSENESS_NAME = 'closeness centrality';
        CLOSENESS_NODAL = true;
        CLOSENESS_TXT = 'The closeness centrality of a node is the inverse of the average shortest path length from the node to all other nodes in the graph.';
        
        IN_CLOSENESS = 37;
        IN_CLOSENESS_NAME = 'in-closeness centrality';
        IN_CLOSENESS_NODAL = true;
        IN_CLOSENESS_TXT = 'The in-closeness centrality of a node is the inverse of the average shortest path length from the node to all other nodes in the graph.';
        
        OUT_CLOSENESS = 38;
        OUT_CLOSENESS_NAME = 'in-closeness centrality';
        OUT_CLOSENESS_NODAL = true;
        OUT_CLOSENESS_TXT = 'The in-closeness centrality of a node is the inverse of the average shortest path length from all other nodes in the graph to the node.';
        
        ZSCORE = 39;
        ZSCORE_NAME = 'within module degree z-score';
        ZSCORE_NODAL = true;
        ZSCORE_TXT = 'The within-module degree z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        
        IN_ZSCORE = 40;
        IN_ZSCORE_NAME = 'within module degree in-z-score';
        IN_ZSCORE_NODAL = true;
        IN_ZSCORE_TXT = 'The within-module degree in-z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        
        OUT_ZSCORE = 41;
        OUT_ZSCORE_NAME = 'within module degree out-z-score';
        OUT_ZSCORE_NODAL = true;
        OUT_ZSCORE_TXT = 'The within-module degree out-z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        
        PARTICIPATION = 42;
        PARTICIPATION_NAME = 'participation';
        PARTICIPATION_NODAL = true;
        PARTICIPATION_TXT = 'The complementary participation coefficient assesses the diversity of intermodular interconnections of individual nodes. Nodes with a high within-module degree but with a low participation coefficient (known as provincial hubs) are hence likely to play an important part in the facilitation of modular segregation. On the other hand, nodes with a high participation coefficient (known as connector hubs) are likely to facilitate global intermodular integration.';
        
        TRANSITIVITY = 43;
        TRANSITIVITY_NAME = 'transitivity';
        TRANSITIVITY_NODAL = false;
        TRANSITIVITY_TXT = 'The transitivity is the ratio of triangles to triplets in the graph. It is an alternative to the graph clustering coefficient.';
        
        ECCENTRICITY = 44;
        ECCENTRICITY_NAME = 'eccentricity';
        ECCENTRICITY_NODAL = true;
        ECCENTRICITY_TXT = 'The node eccentricity is the maximal shortest path length between a node and any other node.';
        
        ECCENTRICITYAV = 45;
        ECCENTRICITYAV_NAME = 'eccentricity';
        ECCENTRICITYAV_NODAL = false;
        ECCENTRICITYAV_TXT = 'The average eccentricity is the average node eccentricy.';
        
        IN_ECCENTRICITY = 46;
        IN_ECCENTRICITY_NAME = 'in-eccentricity';
        IN_ECCENTRICITY_NODAL = true;
        IN_ECCENTRICITY_TXT = 'In directed graphs, the node in-eccentricity is the maximal shortest path length from any nodes in the netwrok and a node.';
        
        IN_ECCENTRICITYAV = 47;
        IN_ECCENTRICITYAV_NAME = 'av. in-eccentricity';
        IN_ECCENTRICITYAV_NODAL = false;
        IN_ECCENTRICITYAV_TXT = 'In directed graphs, the average in-eccentricity is the average node in-eccentricy.';
        
        OUT_ECCENTRICITY = 48;
        OUT_ECCENTRICITY_NAME = 'out-eccentricity';
        OUT_ECCENTRICITY_NODAL = true;
        OUT_ECCENTRICITY_TXT = 'In directed graphs, the node out-eccentricity is the maximal shortest path length from a node to all other nodes in the netwrok.';
        
        OUT_ECCENTRICITYAV = 49;
        OUT_ECCENTRICITYAV_NAME = 'av. out-eccentricity';
        OUT_ECCENTRICITYAV_NODAL = false;
        OUT_ECCENTRICITYAV_TXT = 'In directed graphs, the average out-eccentricity is the average node out-eccentricy.';
        
        RADIUS = 50;
        RADIUS_NAME = 'radius';
        RADIUS_NODAL = false;
        RADIUS_TXT = 'The radius is the minimum eccentricity.';
        
        DIAMETER = 51;
        DIAMETER_NAME = 'diameter';
        DIAMETER_NODAL = false;
        DIAMETER_TXT = 'The diameter is the maximum eccentricity.'
        
        CPL_WSG = 52;
        CPL_WSG_NAME = 'char. path length (within subgraphs)';
        CPL_WSG_NODAL = false;
        CPL_WSG_TXT = 'The characteristic path length of a graph is the average shortest path length in the graph. It is the average of the path length of all nodes in the graph. This measure is calculated within subgraphs.';

        ASSORTATIVITY = 53;
        ASSORTATIVITY_NAME = 'assortativity';
        ASSORTATIVITY_NODAL = false;
        ASSORTATIVITY_TXT = 'The assortativity coefficient is a correlation coefficient between the degrees/strengths of all nodes on two opposite ends of a link. A positive assortativity coefficient indicates that nodes tend to link to other nodes with the same or similar degree/strength.'

        SW = 54;
        SW_NAME = 'small-worldness';
        SW_NODAL = false;
        SW_TXT = 'Network small-worldness.'

        SW_WSG = 55;
        SW_WSG_NAME = 'small-worldness (within subgraphs)';
        SW_WSG_NODAL = false;
        SW_WSG_TXT = 'Network small-worldness. This measure is calculated within subgraphs.'

        NAME = { ...
            Graph.DEGREE_NAME ...
            Graph.DEGREEAV_NAME ...
            Graph.IN_DEGREE_NAME ...
            Graph.IN_DEGREEAV_NAME ...
            Graph.OUT_DEGREE_NAME ...
            Graph.OUT_DEGREEAV_NAME ...
            Graph.STRENGTH_NAME ...
            Graph.STRENGTHAV_NAME ...
            Graph.IN_STRENGTH_NAME ...
            Graph.IN_STRENGTHAV_NAME ...
            Graph.OUT_STRENGTH_NAME ...
            Graph.OUT_STRENGTHAV_NAME ...
            Graph.TRIANGLES_NAME ...
            Graph.CPL_NAME ...
            Graph.PL_NAME ...
            Graph.IN_CPL_NAME ...
            Graph.IN_PL_NAME ...
            Graph.OUT_CPL_NAME ...
            Graph.OUT_PL_NAME ...
            Graph.GEFF_NAME ...
            Graph.GEFFNODE_NAME ...
            Graph.IN_GEFF_NAME ...
            Graph.IN_GEFFNODE_NAME ...
            Graph.OUT_GEFF_NAME ...
            Graph.OUT_GEFFNODE_NAME ...
            Graph.LEFF_NAME ...
            Graph.LEFFNODE_NAME ...
            Graph.IN_LEFF_NAME ...
            Graph.IN_LEFFNODE_NAME ...
            Graph.OUT_LEFF_NAME ...
            Graph.OUT_LEFFNODE_NAME ...
            Graph.CLUSTER_NAME ...
            Graph.CLUSTERNODE_NAME ...
            Graph.MODULARITY_NAME ...
            Graph.BETWEENNESS_NAME ...
            Graph.CLOSENESS_NAME ...
            Graph.IN_CLOSENESS_NAME ...
            Graph.OUT_CLOSENESS_NAME ...
            Graph.ZSCORE_NAME ...
            Graph.IN_ZSCORE_NAME ...
            Graph.OUT_ZSCORE_NAME ...
            Graph.PARTICIPATION_NAME ...
            Graph.TRANSITIVITY_NAME ...
            Graph.ECCENTRICITY_NAME ...
            Graph.ECCENTRICITYAV_NAME ...
            Graph.IN_ECCENTRICITY_NAME ...
            Graph.IN_ECCENTRICITYAV_NAME ...
            Graph.OUT_ECCENTRICITY_NAME ...
            Graph.OUT_ECCENTRICITYAV_NAME ...
            Graph.RADIUS_NAME ...
            Graph.DIAMETER_NAME ...
            Graph.CPL_WSG_NAME ...
            Graph.ASSORTATIVITY_NAME ...
            Graph.SW_NAME ...
            Graph.SW_WSG_NAME ...
            };
        
        NODAL = [ ...
            Graph.DEGREE_NODAL ...
            Graph.DEGREEAV_NODAL ...
            Graph.IN_DEGREE_NODAL ...
            Graph.IN_DEGREEAV_NODAL ...
            Graph.OUT_DEGREE_NODAL ...
            Graph.OUT_DEGREEAV_NODAL ...
            Graph.STRENGTH_NODAL ...
            Graph.STRENGTHAV_NODAL ...
            Graph.IN_STRENGTH_NODAL ...
            Graph.IN_STRENGTHAV_NODAL ...
            Graph.OUT_STRENGTH_NODAL ...
            Graph.OUT_STRENGTHAV_NODAL ...
            Graph.TRIANGLES_NODAL ...
            Graph.CPL_NODAL ...
            Graph.PL_NODAL ...
            Graph.IN_CPL_NODAL ...
            Graph.IN_PL_NODAL ...
            Graph.OUT_CPL_NODAL ...
            Graph.OUT_PL_NODAL ...
            Graph.GEFF_NODAL ...
            Graph.GEFFNODE_NODAL ...
            Graph.IN_GEFF_NODAL ...
            Graph.IN_GEFFNODE_NODAL ...
            Graph.OUT_GEFF_NODAL ...
            Graph.OUT_GEFFNODE_NODAL ...
            Graph.LEFF_NODAL ...
            Graph.LEFFNODE_NODAL ...
            Graph.IN_LEFF_NODAL ...
            Graph.IN_LEFFNODE_NODAL ...
            Graph.OUT_LEFF_NODAL ...
            Graph.OUT_LEFFNODE_NODAL ...
            Graph.CLUSTER_NODAL ...
            Graph.CLUSTERNODE_NODAL ...
            Graph.MODULARITY_NODAL ...
            Graph.BETWEENNESS_NODAL ...
            Graph.CLOSENESS_NODAL ...
            Graph.IN_CLOSENESS_NODAL ...
            Graph.OUT_CLOSENESS_NODAL ...
            Graph.ZSCORE_NODAL ...
            Graph.IN_ZSCORE_NODAL ...
            Graph.OUT_ZSCORE_NODAL ...
            Graph.PARTICIPATION_NODAL ...
            Graph.TRANSITIVITY_NODAL ...
            Graph.ECCENTRICITY_NODAL ...
            Graph.ECCENTRICITYAV_NODAL ...
            Graph.IN_ECCENTRICITY_NODAL ...
            Graph.IN_ECCENTRICITYAV_NODAL ...
            Graph.OUT_ECCENTRICITY_NODAL ...
            Graph.OUT_ECCENTRICITYAV_NODAL ...
            Graph.RADIUS_NODAL ...
            Graph.DIAMETER_NODAL ...
            Graph.CPL_WSG_NODAL ...
            Graph.ASSORTATIVITY_NODAL ...
            Graph.SW_NODAL ...
            Graph.SW_WSG_NODAL ...
            ];
        
        TXT = { ...
            Graph.DEGREE_TXT ...
            Graph.DEGREEAV_TXT ...
            Graph.IN_DEGREE_TXT ...
            Graph.IN_DEGREEAV_TXT ...
            Graph.OUT_DEGREE_TXT ...
            Graph.OUT_DEGREEAV_TXT ...
            Graph.STRENGTH_TXT ...
            Graph.STRENGTHAV_TXT ...
            Graph.IN_STRENGTH_TXT ...
            Graph.IN_STRENGTHAV_TXT ...
            Graph.OUT_STRENGTH_TXT ...
            Graph.OUT_STRENGTHAV_TXT ...
            Graph.TRIANGLES_TXT ...
            Graph.CPL_TXT ...
            Graph.PL_TXT ...
            Graph.IN_CPL_TXT ...
            Graph.IN_PL_TXT ...
            Graph.OUT_CPL_TXT ...
            Graph.OUT_PL_TXT ...
            Graph.GEFF_TXT ...
            Graph.GEFFNODE_TXT ...
            Graph.IN_GEFF_TXT ...
            Graph.IN_GEFFNODE_TXT ...
            Graph.OUT_GEFF_TXT ...
            Graph.OUT_GEFFNODE_TXT ...
            Graph.LEFF_TXT ...
            Graph.LEFFNODE_TXT ...
            Graph.IN_LEFF_TXT ...
            Graph.IN_LEFFNODE_TXT ...
            Graph.OUT_LEFF_TXT ...
            Graph.OUT_LEFFNODE_TXT ...
            Graph.CLUSTER_TXT ...
            Graph.CLUSTERNODE_TXT ...
            Graph.MODULARITY_TXT ...
            Graph.BETWEENNESS_TXT ...
            Graph.CLOSENESS_TXT ...
            Graph.IN_CLOSENESS_TXT ...
            Graph.OUT_CLOSENESS_TXT ...
            Graph.ZSCORE_TXT ...
            Graph.IN_ZSCORE_TXT ...
            Graph.OUT_ZSCORE_TXT ...
            Graph.PARTICIPATION_TXT ...
            Graph.TRANSITIVITY_TXT ...
            Graph.ECCENTRICITY_TXT ...
            Graph.ECCENTRICITYAV_TXT ...
            Graph.IN_ECCENTRICITY_TXT ...
            Graph.IN_ECCENTRICITYAV_TXT ...
            Graph.OUT_ECCENTRICITY_TXT ...
            Graph.OUT_ECCENTRICITYAV_TXT ...
            Graph.RADIUS_TXT ...
            Graph.DIAMETER_TXT ...
            Graph.CPL_WSG_TXT ...
            Graph.ASSORTATIVITY_TXT ...
            Graph.SW_TXT ...
            Graph.SW_WSG_TXT ...
            };
    end
    properties (GetAccess = public, SetAccess = protected)
        A  % connection matrix
        P  % coefficient p-values
        S  % community structure
    end
    properties (Access = protected)
        % N = nodenumber(g)
        N
        
        % D = distance(g)
        D  % matrix
        
        % measures
        
        % [deg,indeg,outdeg] = degree(g)
        deg
        indeg
        outdeg
        
        % [str,instr,outstr] = strength(g)
        str
        instr
        outstr
        
        % [ecc,eccin,eccout] = eccentricity(g)
        ecc
        eccin
        eccout
        
        % t = triangles(g)
        t
        
        % [c,cin,cout] = pl(g)
        c
        cin
        cout
        
        % [ge,gein,geout] = geff(g)
        ge
        gein
        geout
        
        % [le,lenode] = leff(g)
        le
        lenode
        
        % [cl,clnode] = cluster(g)
        cl
        clnode
        
        % b = betweenness(g)  % non-normalized
        b
        
        % tr = transitivity(g)
        tr
        
        % [clo,cloin,cloout] = closeness(g)
        clo
        cloin
        cloout
        
        % Ci = structure(g)
        Ci
        
        % m = modularity(g)
        m
        
        % [z,zin,zout] = zscore(g)
        z
        zin
        zout
        
        % p = participation(g)
        p
        
        % a = assortativity(g)
        a
        
        % sw = smallwordness(g)
        sw
    end
    methods (Access = protected)
        function g = Graph(A,varargin)
            % GRAPH(A) creates a graph with default properties.
            %   A is a generic connection (square, real-valued) matrix.
            %   This method is only accessible by the subclasses of Graph.
            %
            % GRAPH(A,Property1,Value1,Property2,Value2,...) initializes property
            %   Property1 to Value1, Property2 to Value2, ... .
            %   Admissible properties are:
            %       P           -   coefficient p-values
            %       structure   -   community structure object
            %   If a community structure object is not provided, one is initialized 
            %   with parameters: algorithm - 'Louvain' and gamma - 1. 
            %
            % See also Graph, GraphBD, GraphBU, GraphWD, GraphWU.
            
            P = zeros(size(A));  % p-values
            S = Structure('algorithm',Structure.ALGORITHM_LOUVAIN,'gamma',1);  % community structure            
            for n = 1:1:length(varargin)-1
                switch varargin{n}
                    case 'p'
                        P = varargin{n+1};
                    case 'structure'
                        S = varargin{n+1};                        
                end
            end
            
            g.A = A;
            g.P = P;
            g.S = S;
            g.N = length(g.A);
        end
        function reset_structure_related_measures(g)
            % RESET_STRUCTURE_RELATED_MEASURES resets z-score and participation
            %
            % RESET_STRUCTURE_RELATED_MEASURES(G) resets all measures (z-score and
            %   participation) related to the community structure of the graph G.
            %
            % See also Graph.
            
            % [z,zin,zout] = zscore(g)
            z = [];
            zin = [];
            zout = [];
            
            % p = participation(g)
            p = [];
        end
        function cp = copyElement(g)
            % COPYELEMENT copies elements of graph
            %
            % CP = COPYELEMENT(G) copies elements of the graph G.
            %   Makes a deep copy also of the structure of the graph.
            %
            % See also Graph, handle, matlab.mixin.Copyable.
            
            % Make a shallow copy
            cp = copyElement@matlab.mixin.Copyable(g);
            % Make a deep copy
            cp.S = copy(g.S);
        end        
    end
    methods (Abstract)
        weighted(g)  % weighted graph
        binary(g)  % binary graph
        directed(g)  % direced graph
        undirected(g)  % undirected graph
        distance(g)  % distance between nodes (shortest path length)
        measure(g,mi)  % calculates given measure
        randomize(g)  % randomize graph while preserving degree distribution
    end
    methods
        function sg = subgraph(g,nodes)
            % SUBGRAPH creates subgraph from given nodes
            %
            % SG = SUBGRAPH(G,NODES) creates the graph SG as a subgraph of G
            %   containing only the nodes specified by NODES.
            %
            % See also Graph, eval.
            
            eval(['sg = ' class(g) '(g.A(nodes,nodes));'])
        end
        function ga = nodeattack(g,nodes)
            % NODEATTACK removes given nodes from a graph
            %
            % GA = NODEATTACK(G,NODES) creates the graph GA resulting by removing
            %   the nodes specified by NODES from G.
            %
            % NODES are removed by setting all the connections from and to
            %   the nodes in the connection matrix to 0.
            %
            % See also Graph, edgeattack, eval.
            
            A = g.A;
            for i = 1:1:numel(nodes)
                A(nodes(i),:) = 0;
                A(:,nodes(i)) = 0;
            end
            P = g.P;
            
            eval(['ga = ' class(g) '(A,''P'',P);'])
        end
        function ga = edgeattack(g,nodes1,nodes2)
            % EDGEATTACK removes given edges from a graph
            %
            % GA = EDGEATTACK(G,NODES1,NODES2) creates the graph GA resulting
            %   by removing the edges going from NODES1 to NODES2 from G.
            %
            % EDGES are removed by setting all the connections from NODES1 to
            %   NODES2 in the connection matrix to 0.
            %
            % NODES1 and NODES2 must have the same dimensions.
            %
            % See also Graph, nodeattack, eval.
            
            Check.samesize('The number of originating nodes is not equal to the ending nodes of an edge'...
                ,nodes1,nodes2);
            
            A = g.A;
            for i = 1:1:numel(nodes1)
                A(nodes1(i),nodes2(i)) = 0;
            end
            P = g.P;
            
            eval(['ga = ' class(g) '(A,''P'',P);'])
        end
        function N = nodenumber(g)
            % NODENUMBER number of nodes in a graph
            %
            % N = NODENUMBER(G) gets the total number of nodes of graph G.
            %
            % See also Graph.
            
            N = g.N;
        end
        function r = radius(g)
            % RADIUS radius of a graph
            %
            % R = RADIUS(G) calculates the radius R of the graph G.
            %
            % Radius is calculated as the minimum eccentricity.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, diameter, eccentricity.
            
            r = min(g.eccentricity());
        end
        function r = diameter(g)
            % DIAMETER diameter of a graph
            %
            % R = DIAMETER(G) calculates the diameter R of the graph G.
            %
            % Diameter is calculated as the maximum eccentricity.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, radius, eccentricity.
            
            r = max(g.eccentricity());
        end
        function [ecc,eccin,eccout] = eccentricity(g)
            % ECCENTRICITY eccentricity of nodes
            %
            % [ECC,ECCIN,ECCOUT] = ECCENTRICITY(G) calculates the eccentricity ECC,
            %   in-eccentricity ECCIN and out-eccentricity ECCOUT of all nodes in
            %   the graph G.
            %
            % The node eccentricity is the maximal shortest path length between a
            %   node and any other node. The eccentricity of a node is the maximum
            %   of the in and out-eccentricity of that node.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, distance, pl.
            
            if isempty(g.ecc) || isempty(g.eccin) || isempty(g.eccout)
                D = g.distance();
                D = Graph.removediagonal(D,Inf);
                
                g.eccin = max(D.*(D~=Inf),[],1);  % in-eccentricy = max of distance along column
                g.eccout = max(D.*(D~=Inf),[],2)';  % out-eccentricy = max of distance along column
                g.ecc = max(g.eccin,g.eccout);
            end
            
            ecc = g.ecc;
            eccin = g.eccin;
            eccout = g.eccout;
        end
        function [c,cin,cout] = pl(g)
            % PL path length of nodes
            %
            % [C,CIN,COUT] = PL(G) calculates the path length C, in-path length CIN
            %   and out-path length COUT of all nodes in the graph G.
            %
            % The path length is the average shortest path lengths of one node to all
            %   other nodes. The path length of a node is the average of the in-path
            %   and out-path length of that node.
            %
            % Reference: "Complex network measures of brain connectivity: Uses and
            %            iterpretations", M. Rubinov, O. Sporns
            %
            % See also Graph, distance.
            
            if isempty(g.c) || isempty(g.cin) || isempty(g.cout)
                D = g.distance();
                D = Graph.removediagonal(D,Inf);
                
                N = g.nodenumber();
                
                g.cin = zeros(1,N);
                for u = 1:1:N
                    Du = D(:,u);
                    g.cin(u) = sum(Du(Du~=Inf))/length(nonzeros(Du~=Inf));
                end
                
                g.cout = zeros(1,N);
                for u = 1:1:N
                    Du = D(u,:);
                    g.cout(u) = sum(Du(Du~=Inf))/length(nonzeros(Du~=Inf));
                end
                
                g.c = mean([g.cin; g.cout],1);
            end
            
            c = g.c;
            cin = g.cin;
            cout = g.cout;
        end
        function [clo,cloin,cloout] = closeness(g)
            % CLOSENESS closeness centrality of nodes
            %
            % [CLO,CLOIN,CLOOUT] = CLOSENESS(G) calculates the closeness centrality CLO,
            %   in-closeness centrality CLOIN and out-closeness centrality CLOOUT of all
            %   nodes in the graph G.
            %
            % The closeness centrality is the inverse of the average shortest path lengths
            %   of one node to all other nodes.
            %
            % See also Graph, pl.
            
            if isempty(g.clo)
                c = g.pl();
                g.clo = c.^-1;
            end
            
            if isempty(g.cloin)
                [~,cin] = g.pl();
                g.cloin = cin.^-1;
            end
            
            if isempty(g.cloout)
                [~,~,cout] = g.pl();
                g.cloout = cout.^-1;
            end
            
            clo = g.clo;
            cloin = g.cloin;
            cloout = g.cloout;
        end
        function [Ci m] = structure(g)
            % STRUCTURE community structures of a graph
            %
            % [CI M] = STRUCTURE(G) calculate the optimal community structure CI in
            %   the graph G also returning the maximized modularity M.
            %   It reads the properties of the community structure provided as an
            %   input to the graph to calculate the optimized community structure.
            %
            %   The optimal community structure is a structure with maximum number of
            %   edges connecting nodes within communities compared to the edges
            %   connecting nodes between communities.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            %
            % See also Graph, modularity.
            
            if g.S.isFixed()
                
                if isempty(g.S.getCi())
                    g.S.setCi(1,ones(length(g.A)))
                end
                
                Ci = g.S.getCi();
                
                A = Graph.removediagonal(g.A,0);
                Q = 0;
                
                if g.undirected()
                    
                    L = sum(sum(A(:)))/2; % sum of link weights (divide by 2 for undirected)
                    degree = g.degree();
                    for i = 1:1:length(A)
                        indices = find(Ci == Ci(i));
                        indices = indices(indices~=i);
                        for j = 1:1:length(indices)
                            Q = Q + A(i,j) - degree(i)*degree(indices(j))./L;
                        end
                    end
                    
                    
                elseif g.directed()
                    
                    L = sum(sum(A(:))); % sum of link weights
                    [~,ind,outd] = g.degree();
                    for i = 1:1:length(A)
                        indices = find(Ci == Ci(i));
                        indices = indices(indices~=i);
                        for j = 1:1:length(indices)
                            Q = Q + A(i,j) - outd(i)*ind(indices(j))./L;
                        end
                    end
                end
                
                
                g.m = Q/L;
                m = g.m;
                
            else
                algorithm = g.S.getAlgorithm();  % algorithm from defined structure
                gamma = g.S.getGamma();  % gamma from defined structure
            
                switch algorithm
                    
                    case Structure.ALGORITHM_LOUVAIN
                        
                        A = Graph.removediagonal(g.A,0);
                        W = double(A);  % convert from logical
                        n = length(W);
                        s = sum(W(:));  % sum of edges (each undirected edge is counted twice)
                        
                        if min(W(:)) < -1e-10
                            error('W must not contain negative weights.')
                        end
                        
                        if ~exist('B','var') || isempty(B)
                            B = 'modularity';
                        end
                        if ( ~exist('gamma','var') || isempty(gamma)) && ischar(B)
                            gamma = 1;
                        end
                        if ~exist('M0','var') || isempty(M0)
                            M0 = 1:n;
                        elseif numel(M0) ~= n
                            error('M0 must contain n elements.')
                        end
                        
                        [~,~,Mb] = unique(M0);
                        M = Mb;
                        
                        if ischar(B)
                            switch B
                                case 'modularity';
                                    B = W-gamma*(sum(W,2)*sum(W,1))/s;
                                case 'potts';
                                    B = W-gamma*(~W);
                                otherwise;
                                    error('Unknown objective function.');
                            end
                        else
                            B = double(B);
                            if ~isequal(size(W),size(B))
                                error('W and B must have the same size.')
                            end
                            if max(max(abs(B-B.'))) > 1e-10
                                warning('B is not symmetric, enforcing symmetry.')
                            end
                            if exist('gamma','var')
                                warning('Value of gamma is ignored in generalized mode.')
                            end
                        end
                        
                        B = (B+B.')/2;  % symmetrize modularity matrix
                        Hnm = zeros(n,n);  % node-to-module degree
                        for m = 1:max(Mb)  % loop over modules
                            Hnm(:,m) = sum(B(:,Mb==m),2);
                        end
                        H = sum(Hnm,2);  % node degree
                        Hm = sum(Hnm,1);  % module degree
                        
                        Q0 = -inf;
                        Q = sum(B(bsxfun(@eq,M0,M0.')))/s;  % compute modularity
                        first_iteration = true;
                        while Q-Q0 > 1e-10
                            flag = true;  % flag for within-hierarchy search
                            while flag;
                                flag = false;
                                for u=randperm(n)  % loop over all nodes in random order
                                    ma = Mb(u);  % current module of u
                                    dQ = Hnm(u,:)-Hnm(u,ma)+B(u,u);
                                    dQ(ma) = 0;  % (line above) algorithm condition
                                    
                                    [max_dQ mb] = max(dQ);  % maximal increase in modularity and corresponding module
                                    if max_dQ > 1e-10;  % if maximal increase is positive
                                        flag = true;
                                        Mb(u) = mb;  % reassign module
                                        
                                        Hnm(:,mb) = Hnm(:,mb)+B(:,u);  % change node-to-module strengths
                                        Hnm(:,ma) = Hnm(:,ma)-B(:,u);
                                        Hm(mb) = Hm(mb)+H(u);  % change module strengths
                                        Hm(ma) = Hm(ma)-H(u);
                                    end
                                end
                            end
                            [~,~,Mb] = unique(Mb);  % new module assignments
                            
                            M0 = M;
                            if first_iteration
                                M = Mb;
                                first_iteration = false;
                            else
                                for u=1:n  % loop through initial module assignments
                                    M(M0==u) = Mb(u);  % assign new modules
                                end
                            end
                            
                            n = max(Mb);  % new number of modules
                            B1 = zeros(n);  % new weighted matrix
                            for u = 1:n
                                for v = u:n
                                    bm = sum(sum(B(Mb==u,Mb==v)));  % pool weights of nodes in same module
                                    B1(u,v) = bm;
                                    B1(v,u) = bm;
                                end
                            end
                            B = B1;
                            
                            Mb = 1:n;  % initial module assignments
                            Hnm = B;  % node-to-module strength
                            H = sum(B);  % node strength
                            Hm = H;  % module strength
                            
                            Q0 = Q;
                            Q = trace(B)/s;  % compute modularity
                        end
                        
                        g.Ci = M';
                        g.m = Q;
                        
                    case Structure.ALGORITHM_NEWMAN
                        
                        if g.directed()
                            A = Graph.removediagonal(g.A,0);
                            N = length(A);  % number of vertices
                            n_perm = randperm(N);  % randomly permute order of nodes
                            A = A(n_perm,n_perm);  % DB: use permuted matrix for subsequent analysis
                            Ki = sum(A,1);  % in-degree
                            Ko = sum(A,2);  % out-degree
                            m = sum(Ki);  % number of edges
                            b = A-gamma*(Ko*Ki).'/m;
                            B = b+b.';  % directed modularity matrix
                            Ci = ones(N,1);  % community indices
                            cn = 1;  % number of communities
                            U = [1 0];  % array of unexamined communites
                            
                            ind = 1:N;
                            Bg = B;
                            Ng = N;
                            
                            while U(1)  % examine community U(1)
                                [V D] = eig(Bg);
                                [d1 i1] = max(real(diag(D)));  % most positive eigenvalue of Bg
                                v1 = V(:,i1);  % corresponding eigenvector
                                
                                S = ones(Ng,1);
                                S(v1<0) = -1;
                                q = S.'*Bg*S;  % contribution to modularity
                                
                                if q > 1e-10  % contribution positive: U(1) is divisible
                                    qmax = q;  % maximal contribution to modularity
                                    Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                                    indg = ones(Ng,1);  % array of unmoved indices
                                    Sit = S;
                                    while any(indg);  % iterative fine-tuning
                                        Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                                        qmax = max(Qit.*indg);  % for i=1:Ng
                                        imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                                        Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                                        indg(imax) = nan;  % Sit(i)=-Sit(i);
                                        if qmax > q;  % end
                                            q = qmax;
                                            S = Sit;
                                        end
                                    end
                                    
                                    if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                                        U(1) = [];
                                    else
                                        cn = cn+1;
                                        Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                                        Ci(ind(S==-1)) = cn;
                                        U = [cn U];
                                    end
                                else  % contribution nonpositive: U(1) is indivisible
                                    U(1) = [];
                                end
                                
                                ind = find(Ci==U(1));  % indices of unexamined community U(1)
                                bg = B(ind,ind);
                                Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                                Ng = length(ind);  % number of vertices in U(1)
                            end
                            
                            s = Ci(:,ones(1,N));  % compute modularity
                            Q =~ (s-s.').*B/(2*m);
                            Q = sum(Q(:));
                            Ci_corrected = zeros(N,1);  % initialize Ci_corrected
                            Ci_corrected(n_perm) = Ci;  % return order of nodes to the order used at the input stage.
                            Ci = Ci_corrected;  % output corrected community assignments
                            
                            g.Ci = Ci';
                            g.m = Q;
                            
                        elseif g.undirected()
                            A = Graph.removediagonal(g.A,0);
                            N = length(A);  % number of vertices
                            n_perm = randperm(N);  % randomly permute order of nodes
                            A = A(n_perm,n_perm);  % DB: use permuted matrix for subsequent analysis
                            K = sum(A);  % degree
                            m = sum(K);  % number of edges (each undirected edge is counted twice)
                            B = A-gamma*(K.'*K)/m;  % modularity matrix
                            Ci = ones(N,1);  % community indices
                            cn = 1;  % number of communities
                            U = [1 0];  % array of unexamined communites
                            
                            ind = 1:N;
                            Bg = B;
                            Ng = N;
                            
                            while U(1)  % examine community U(1)
                                [V D] = eig(Bg);
                                [d1 i1] = max(real(diag(D)));  % maximal positive (real part of) eigenvalue of Bg
                                v1 = V(:,i1);  % corresponding eigenvector
                                
                                S = ones(Ng,1);
                                S(v1<0) = -1;
                                q = S.'*Bg*S;  % contribution to modularity
                                
                                if q > 1e-10  % contribution positive: U(1) is divisible
                                    qmax = q;  % maximal contribution to modularity
                                    Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                                    indg = ones(Ng,1);  % array of unmoved indices
                                    Sit = S;
                                    while any(indg);  % iterative fine-tuning
                                        Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                                        qmax = max(Qit.*indg);  % for i=1:Ng
                                        imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                                        Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                                        indg(imax) = nan;  % Sit(i)=-Sit(i);
                                        if qmax > q;  % end
                                            q = qmax;
                                            S = Sit;
                                        end
                                    end
                                    
                                    if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                                        U(1) = [];
                                    else
                                        cn = cn+1;
                                        Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                                        Ci(ind(S==-1)) = cn;
                                        U = [cn U];
                                    end
                                else  % contribution nonpositive: U(1) is indivisible
                                    U(1) = [];
                                end
                                
                                ind = find(Ci==U(1));  % indices of unexamined community U(1)
                                bg = B(ind,ind);
                                Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                                Ng = length(ind);  % number of vertices in U(1)
                            end
                            
                            s = Ci(:,ones(1,N));  % compute modularity
                            Q =~ (s-s.').*B/m;
                            Q = sum(Q(:));
                            Ci_corrected = zeros(N,1);  % initialize Ci_corrected
                            Ci_corrected(n_perm) = Ci;  % return order of nodes to the order used at the input stage.
                            Ci = Ci_corrected;  % output corrected community assignments
                            
                            g.Ci = Ci';
                            g.m = Q;
                        end       
                end
                
                Ci = g.Ci;
                m = g.m;
            end
            
            reset_structure_related_measures(g)
        end
        function m = modularity(g)
            % MODULARITY modularity of a graph
            %
            % M = MODULARITY(G) returns the maximized modularity M of the graph G.
            %   Before the modularity can be calculated, a custom structure should be
            %   provided as input to the graph, or alternatively the function
            %   G.structure() should be called to calculate the optimized community structure.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            %
            % See also Graph, Structure.

            if isempty(g.m)
                g.structure();
            end
            
            m = g.m;
        end
        function [z,zin,zout] = zscore(g)
            % ZSCORE within module degree z-score
            %
            % [Z, ZIN, ZOUT] = ZSCORE(G) calculates the within-module degree z-score Z,
            %   in-z-score ZIN and out-z-score ZOUT of nodes included in graph G.
            %   Before the z-score can be calculated, a custom structure should be provided 
            %   as input to the graph, or alternatively the function G.structure() should be 
            %   called to calculate the optimized community structure.
            %   
            % The within-module degree z-score is a within-module version of degree
            %   centrality. It measures how well a node is connected to the other
            %   nodes in the same community.
            %
            % See also Graph, Structure.
            
            if isempty(g.z)
                W = g.A+g.A.';
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.z = Z;
            end
            
            if nargout>1 && isempty(g.zin)
                W = g.A;
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.zin = Z;
            end
            
            if nargout>2 && isempty(g.zout)
                W = g.A.';
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.zout = Z;
            end
            
            z = g.z;
            zin = g.zin;
            zout = g.zout;
        end
        function p = participation(g)
            % PARTICIPATION participation coefficient of nodes
            %
            % P = PARTICIPATION(G) calculates the participation coefficient of
            %   a node from the graph G in a given community.
            %   Before the participation coefficient can be calculated, a custom structure 
            %   should be provided as input to the graph, or alternatively the function 
            %   g.structure() should be called to calculate the optimized community structure. 
            %    
            % The participation coefficient shows the node connectivity through the
            %   availible communities. It is expressed by the ratio of the edges that
            %   a node forms within a community to the total number of edges the node
            %   forms whithin the whole graph.
            %
            % See also Graph, Structure.
            
            if isempty(g.p)
                W = g.A;
                Ci = g.structure();
                
                n = length(W);  % number of vertices
                Ko = sum(W,2);  % (out)degree
                Gc = (W~=0)*diag(Ci);  % neighbor community affiliation
                Kc2 = zeros(n,1);  % community-specific neighbors
                
                for i = 1:1:max(Ci)
                    Kc2 = Kc2+(sum(W.*(Gc==i),2).^2);
                end
                
                P = ones(n,1)-Kc2./(Ko.^2);
                P(~Ko) = 0;  % P=0 if for nodes with no (out)neighbors
                
                g.p = P';
            end
            
            p = g.p;
        end
        function sw = smallworldness(g,wsg)
            % SMALLWORLDNESS small-worldness of the graph
            %
            % SW = SMALLWORLDNESS(G,WGS) calculated the small-worldness of the graph.
            %   WGS = true means that it is calcualted using 
            %   the characteristic path length within connected subgraphs.
            %
            % SW = SMALLWORLDNESS(G) is equivalent to SW = SMALLWORLDNESS(G,false)
            %
            % See also Graph.            
            
            if nargin<2
                wsg = false;
            end
            
            M = 100;  % number of random graphs
            
            if isempty(g.sw)
                C = g.measure(Graph.CLUSTER);
                if g.directed() || ~wsg
                    L = g.measure(Graph.CPL);
                else
                    L = g.measure(Graph.CPL_WSG);
                end
                
                Cr = zeros(1,M);
                Lr = zeros(1,M);
                for m = 1:1:M
                    gr = g.randomize();
                    Cr(m) = gr.measure(Graph.CLUSTER);
                    if g.directed()
                        Lr(m) = gr.measure(Graph.CPL);
                    else
                        Lr(m) = gr.measure(Graph.CPL_WSG);
                    end
                end
                Cr = mean(Cr);
                Lr = mean(Lr);
                
                g.sw = (C/Cr)/(L/Lr);
            end
            
            sw = g.sw;
        end
    end
    methods (Static)
        function B = removediagonal(A,value)
            % REMOVEDIAGONAL replaces matrix diagonal with given value
            %
            % B = REMOVEDIAGONAL(A,VALUE) sets the values in the diagonal of any
            %   matrix A to VALUE and returns the resulting matrix B.
            %   If VALUE is not inputted, the default is 0.
            %
            % See also Graph.
            
            if nargin < 2
                value = 0;
            end
            
            B = A;
            B(1:length(A)+1:numel(A)) = value;
        end
        function B = symmetrize(A,varargin)
            % SYMMETRIZE symmetrizes a matrix
            %
            % B = SYMMETRIZE(A) symmetrizes any matrix A and returns the resulting
            %   symmetric matrix B.
            %
            % B = SYMMETRIZE(A,'PropertyName',PropertyValue) symmetrizes the matrix
            %   A by the property PropertyName specified by the PropertyValue.
            %   Admissible properties are:
            %       rule    -   'max' (default) | 'min' | 'av' | 'sum'
            %                   'max' - maximum between inconnection and outconnection (default)
            %                   'min' - minimum between inconnection and outconnection
            %                   'av'  - average of inconnection and outconnection
            %                   'sum' - sum of inconnection and outconnection
            %
            % See also Graph.
            
            % Rule
            rule = 'max';
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'rule')
                    rule = varargin{n+1};
                end
            end
            
            switch lower(rule)
                case {'sum','add'}  % sum rule
                    B = A+transpose(A);
                case {'av','average'}  % average rule
                    B = (A+transpose(A))/2;
                case {'min','minimum','or','weak'}  % minimum rule
                    B = min(A,transpose(A));
                otherwise  % {'max','maximum','and','strong'} % maximum rule
                    B = max(A,transpose(A));
            end
        end
        function [count,bins,density] = histogram(A,varargin)
            % HISTOGRAM histogram of a matrix
            %
            % [COUNT,BINS,DENSITY] = HISTOGRAM(A) calculates the histogram of matrix A
            %   and finds the frequency of data COUNT in the intervals BINS at which histogram
            %   is plotted, and associated DENSITY.
            %
            % [COUNT,BINS,DENSITY] = HISTOGRAM(A,'PropertyName',PropertyValue) calculates
            %   the histogram of A by using the property PropertyName specified by the
            %   PropertyValue.
            %   Admissible properties are:
            %       bins       -   -1:.001:1 (default)
            %       diagonal   -   'exclude' (default) | 'include'
            %
            % See also Graph, hist.
            
            % Bins
            bins = -1:.001:1;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'bins')
                    bins = varargin{n+1};
                end
            end
            
            % Diagonal
            diagonal = 'exclude';
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'diagonal')
                    diagonal = varargin{n+1};
                end
            end
            
            % Analysis
            if strcmp(diagonal,'include')
                count = hist(reshape(A,1,numel(A)),bins);
                density = 1-cumsum(count)/numel(A);
            else
                B = A(~eye(size(A)));
                count = hist(B,bins);
                density = 1-cumsum(count)/numel(B);
            end
            
            density = density*100;
        end
        function [B,threshold] = binarize(A,varargin)
            % BINARIZE binarizes a matrix
            %
            % [B,THRESHOLD] = BINARIZE(A) binarizes the matrix A by fixing either the
            %   threshold (default, threshold=0) or the density (percent of connections).
            %   It returns the binarized matrix B and the threshold THRESHOLD.
            %
            % [B,THRESHOLD] = BINARIZE(A,'PropertyName',PropertyValue) binarizes the
            %   matrix A by using the property PropertyName specified by the PropertyValue.
            %   Admissible properties are:
            %       threshold   -   0 (default)
            %       bins        -   -1:.001:1 (default)
            %       density     -   percentage of connections
            %       diagonal    -   'exclude' (default) | 'include'
            %
            % See also Graph, histogram.
            
            % Threshold and density
            threshold = 0;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'threshold')
                    threshold = varargin{n+1};
                end
            end
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'density')
                    [~,bins,density] = Graph.histogram(A,varargin{:});
                    threshold = bins(density<varargin{n+1});
                    if isempty(threshold)
                        threshold = 1;
                    else
                        threshold = threshold(1);
                    end
                end
            end
            
            % Calculates binary graph
            B = zeros(size(A));
            B(A>threshold) = 1;
        end
        function h = plotw(A,varargin)
            % PLOTW plots a weighted matrix
            %
            % H = PLOTW(A) plots the weighted matrix A and returns the handle to
            %   the plot H.
            %
            % H = PLOTW(A,'PropertyName',PropertyValue) sets the property of the
            %   matrix plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       xlabels   -   1:1:number of matrix elements (default)
            %       ylabels   -   1:1:number of matrix elements (default)
            %
            % See also Graph, plotb, surf.
            
            N = length(A);
            
            % x labels
            xlabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'xlabels')
                    xlabels = varargin{n+1};
                end
            end
            if ~iscell(xlabels)
                xlabels = {xlabels};
            end
            
            % y labels
            ylabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'ylabels')
                    ylabels = varargin{n+1};
                end
            end
            if ~iscell(ylabels)
                ylabels = {ylabels};
            end
            
            ht = surf((0:1:N), ...
                (0:1:N), ...
                [A, zeros(size(A,1),1); zeros(1,size(A,1)+1)]);
            view(2)
            shading flat
            axis equal square tight
            grid off
            box on
            set(gca, ...
                'XAxisLocation','top', ...
                'XTick',(1:1:N)-.5, ...
                'XTickLabel',{}, ...
                'YAxisLocation','left', ...
                'YDir','Reverse', ...
                'YTick',(1:1:N)-.5, ...
                'YTickLabel',ylabels)
            
            if ~verLessThan('matlab', '8.4.0')
                set(gca, ...
                    'XTickLabelRotation',90, ...
                    'XTickLabel',xlabels)
            else
                t = text((1:1:N)-.5,zeros(1,N),xlabels);
                set(t, ...
                    'HorizontalAlignment','left', ...
                    'VerticalAlignment','middle', ...
                    'Rotation',90);
            end
            
            colormap jet
            
            % output if needed
            if nargout>0
                h = ht;
            end
        end
        function h = plotb(A,varargin)
            % PLOTB plots a binary matrix
            %
            % H = PLOTB(A) plots the binarized version of weighted matrix A and
            %   returns the handle to the plot H.
            %   The matrix A can be binarized by fixing the threshold
            %   (default, threshold=0.5).
            %
            % H = PLOTB(A,'PropertyName',PropertyValue) sets the property of the
            %   matrix plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       threshold   -   0.5 (default)
            %       xlabels     -   1:1:number of matrix elements (default)
            %       ylabels     -   1:1:number of matrix elements (default)
            %
            % See also Graph, binarize, plotw, surf.
            
            N = length(A);
            
            % threshold
            threshold = .5;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'threshold')
                    threshold = varargin{n+1};
                end
            end
            
            % x labels
            xlabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'xlabels')
                    xlabels = varargin{n+1};
                end
            end
            if ~iscell(xlabels)
                xlabels = {xlabels};
            end
            
            % y labels
            ylabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'ylabels')
                    ylabels = varargin{n+1};
                end
            end
            if ~iscell(ylabels)
                ylabels = {ylabels};
            end
            
            B = Graph.binarize(A,'threshold',threshold);
            
            ht = surf((0:1:N), ...
                (0:1:N), ...
                [B, zeros(size(B,1),1); zeros(1,size(B,1)+1)]);
            view(2)
            shading flat
            axis equal square tight
            grid off
            box on
            set(gca, ...
                'XAxisLocation','top', ...
                'XTick',(1:1:N)-.5, ...
                'XTickLabel',{}, ...
                'YAxisLocation','left', ...
                'YDir','Reverse', ...
                'YTick',(1:1:N)-.5, ...
                'YTickLabel',ylabels)
            
            if ~verLessThan('matlab', '8.4.0')
                set(gca, ...
                    'XTickLabelRotation',90, ...
                    'XTickLabel',xlabels)
            else
                t = text((1:1:N)-.5,zeros(1,N),xlabels);
                set(t, ...
                    'HorizontalAlignment','left', ...
                    'VerticalAlignment','middle', ...
                    'Rotation',90);
            end
            
            colormap bone
            
            % output if needed
            if nargout>0
                h = ht;
            end
        end
        function h = hist(A,varargin)
            % HIST plots the histogram and density of a matrix
            %
            % H = HIST(A) plots the histogram of a matrix A and the associated density and
            %   returns the handle to the plot H.
            %
            % H = HIST(A,'PropertyName',PropertyValue) sets the property of the histogram
            %   plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       bins       -   -1:.001:1 (default)
            %       diagonal   -   'exclude' (default) | 'include'
            %
            % See also Graph, histogram.
            
            [count,bins,density] = Graph.histogram(A,varargin{:});
            
            bins = [bins(1) bins bins(end)];
            count = [0 count 0];
            density = [100 density 0];
            
            hold on
            ht1 = fill(bins,count,'k');
            ht2 = plot(bins,density,'b','linewidth',2);
            hold off
            xlabel('coefficient values / threshold')
            ylabel('coefficient counts / density')
            
            grid off
            box on
            axis square tight
            set(gca, ...
                'XAxisLocation','bottom', ...
                'XTickLabelMode','auto', ...
                'XTickMode','auto', ...
                'YTickLabelMode','auto', ...
                'YAxisLocation','left', ...
                'YDir','Normal', ...
                'YTickMode','auto', ...
                'YTickLabelMode','auto')
            
            % output if needed
            if nargout>0
                h = [ht1 ht2];
            end
        end
        function bool = isnodal(mi)
            % ISNODAL checks if measure is nodal
            %
            % BOOL = ISNODAL(MI) returns true if measure MI is nodal and false otherwise.
            %
            % See also Graph, isglobal.
            
            bool = Graph.NODAL(mi);
        end
        function bool = isglobal(mi)
            % ISGLOBAL checks if measure is global
            %
            % BOOL = ISGLOBAL(MI) returns true if measure MI is global and false otherwise.
            %
            % See also Graph, isnodal.
            
            bool = ~Graph.isnodal(mi);
        end
    end
    methods (Static,Abstract)
        measurelist(nodal)  % list of measures valid for a graph (no argin = all; true = only nodal; false = only non-nodal)
        measurenumber(nodal)  % number of measures valid for a graph (no argin = all; true = only nodal; false = only non-nodal)
    end
end