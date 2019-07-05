classdef PlotBrainGraph < PlotBrainAtlas
    % PlotBrainGraph < PlotBrainAtlas : Plot of a brain graph
    %   PlotBrainGraph plots and manages the links between brain regions.
    %   The links can be plotted by using lines, arrows or cylinders.
    %
    % PlotBrainGraph properties (Constants):
    %
    %   INIT_LIN_COLOR     -   line color
    %                          (default = [0 0 0])
    %
    %   INIT_ARR_COLOR     -   arrow color (edges and faces)
    %                          (default = [0 0 0])
    %   INIT_ARR_SWIDTH    -   arrow stem width
    %                          (default = 0.1)
    %   INIT_ARR_HLENGTH   -   arrow head length
    %                          (default = 1)
    %   INIT_ARR_HWIDTH    -   arrow head width
    %                          (default = 1)
    %   INIT_ARR_HNODE     -   head intersection with the arrow stem
    %                          (default = 0.5)
    %   INIT_ARR_N         -   number of radial sections
    %                          (default = 32)
    %
    %   INIT_CYL_COLOR     -   cylinder color (edges and faces)
    %                          (default = [0 0 0])
    %   INIT_CYL_R         -   cylinder radius
    %                          (default = 0.1)
    %   INIT_CYL_N         -   number of radial sections
    %                          (default = 32)
    %
    % PlotBrainGraph properties (protected):
    %   atlas             -   brain atlas < PlotBrainAtlas
    %   syms              -   cell array containing the symbols' properties < PlotBrainAtlas
    %   f_syms_settings   -   symbols settings figure handle < PlotBrainAtlas
    %   sphs              -   cell array containing the spheres' propertie < PlotBrainAtlas
    %   f_sphs_settings   -   spheres settings figure handle < PlotBrainAtlas
    %   labs              -   cell array containing the labels' properties < PlotBrainAtlas
    %   f_labs_settings   -   labels settings figure handle < PlotBrainAtlas
    %
    %   lins                  -   cell array containing the lines' properties
    %                              lins{n}.h     -   graphic handle
    %                              lins{n}.X1    -   initial x-coordinate
    %                              lins{n}.Y1    -   initial y-coordinate
    %                              lins{n}.Z1    -   initial z-coordinate
    %                              lins{n}.X2    -   final x-coordinate
    %                              lins{n}.Y2    -   final y-coordinate
    %                              lins{n}.Z2    -   final z-coordinate
    %   f_lins_settings       -   lines settings figure handle
    %
    %   arrs                  -   cell array containing the arrows' properties
    %                              arrs{n}.h         -   graphic handle
    %                              arrs{n}.X1        -   initial x-coordinate
    %                              arrs{n}.Y1        -   initial y-coordinate
    %                              arrs{n}.Z1        -   initial z-coordinate
    %                              arrs{n}.X2        -   final x-coordinate
    %                              arrs{n}.Y2        -   final y-coordinate
    %                              arrs{n}.Z2        -   final z-coordinate
    %                              arrs{n}.SWIDTH    -   arrow stem width
    %                              arrs{n}.HLENGTH   -   arrow head length
    %                              arrs{n}.HWIDTH    -   arrow head width
    %                              arrs{n}.HNODE     -   arrow head intersection with the arrow stem
    %                              arrs{n}.N         -   number of equally spaced points around the arrow
    %   f_arrs_settings       -   arrs settings figure handle
    %
    %   cyls                  -   cell array containing the cylinders' properties
    %                              cyls{n}.h     -   graphic handle
    %                              cyls{n}.X1    -   initial x-coordinate
    %                              cyls{n}.Y1    -   initial y-coordinate
    %                              cyls{n}.Z1    -   initial z-coordinate
    %                              cyls{n}.X2    -   final x-coordinate
    %                              cyls{n}.Y2    -   final y-coordinate
    %                              cyls{n}.Z2    -   final z-coordinate
    %                              cyls{n}.R     -   cylinder radius
    %                              cyls{n}.N     -   number of equally spaced points around the cylinder
    %   f_cyls_settings       -   cylinders settings figure handle
    %
    % PlotBrainGraph methods:
    %   PlotBrainGraph    -   constructor
    %   disp              -   displays brain surface < PlotBrainSurf
    %   name              -   brain surface name < PlotBrainSurf
    %   set_axes          -   sets current axes < PlotBrainSurf
    %   get_axes          -   gets current axes < PlotBrainSurf
    %
    %   brain             -   plots brain surface < PlotBrainSurf
    %   brain_on          -   shows brain surface < PlotBrainSurf
    %   brain_off         -   hides brain surface < PlotBrainSurf
    %   brain_settings    -   sets brain surface's properties < PlotBrainSurf
    %
    %   hold_on           -   hold on < PlotBrainSurf
    %   hold_off          -   hold off < PlotBrainSurf
    %   grid_on           -   grid on < PlotBrainSurf
    %   grid_off          -   grid off < PlotBrainSurf
    %   axis_on           -   axis on < PlotBrainSurf
    %   axis_off          -   axis off < PlotBrainSurf
    %   axis_equal        -   axis equal < PlotBrainSurf
    %   axis_tight        -   axis tight < PlotBrainSurf
    %   view              -   sets desired view < PlotBrainSurf
    %   update_light      -   sets lighting properties < PlotBrainSurf
    %   rotate            -   rotates viewpoint < PlotBrainSurf
    %
    %   br_sym            -   displays brain region as symbol < PlotBrainAtlas
    %   br_sym_on         -   shows a symbol < PlotBrainAtlas
    %   br_sym_off        -   hides a symbol < PlotBrainAtlas
    %   br_sym_is_on      -   checks if symbol is visible < PlotBrainAtlas
    %   br_syms           -   displays multiple brain regions as symbols < PlotBrainAtlas
    %   br_syms_on        -   shows multiple symbols < PlotBrainAtlas
    %   br_syms_off       -   hides multiple symbols < PlotBrainAtlas
    %   get_sym_i         -   order number of brain region corresponding to a symbol < PlotBrainAtlas
    %   get_sym_br        -   properties of brain region corresponding to a symbol < PlotBrainAtlas
    %   br_syms_settings  -   sets symbols' properties < PlotBrainAtlas
    %
    %   br_sph            -   displays brain region as sphere < PlotBrainAtlas
    %   br_sph_on         -   shows a sphere < PlotBrainAtlas
    %   br_sph_off        -   hides a sphere < PlotBrainAtlas
    %   br_sph_is_on      -   checks if sphere is visible < PlotBrainAtlas
    %   br_sphs           -   displays multiple brain regions as spheres < PlotBrainAtlas
    %   br_sphs_on        -   shows multiple spheres < PlotBrainAtlas
    %   br_sphs_off       -   hides multiple spheres < PlotBrainAtlas
    %   get_sph_i         -   order number of brain region corresponding to a sphere < PlotBrainAtlas
    %   get_sph_br        -   properties of brain region corresponding to a sphere < PlotBrainAtlas
    %   br_sphs_settings  -   sets spheres' properties < PlotBrainAtlas
    %
    %   br_lab            -   displays brain region as label < PlotBrainAtlas
    %   br_lab_on         -   shows a label < PlotBrainAtlas
    %   br_lab_off        -   hides a label < PlotBrainAtlas
    %   br_lab_is_on      -   checks if label is visible < PlotBrainAtlas
    %   br_labs           -   displays multiple brain regions as label < PlotBrainAtlas
    %   br_labs_on        -   shows multiple labels < PlotBrainAtlas
    %   br_labs_off       -   hides multiple labels < PlotBrainAtlas
    %   get_lab_i         -   order number of brain region corresponding to a label < PlotBrainAtlas
    %   get_lab_br        -   properties of brain region corresponding to a label < PlotBrainAtlas
    %   br_labs_settings  -   sets labels' properties < PlotBrainAtlas
    %
    %   link_lin            -   plots link as line
    %   link_lin_on         -   shows a line link
    %   link_lin_off        -   hides a line link
    %   link_lin_is_on      -   checks if line link is visible
    %   link_lins           -   plots multiple links as lines
    %   link_lins_on        -   shows multiple link lines
    %   link_lins_off       -   hides multiple link lines
    %   get_lin_ij          -   order number of brain regions linked via corresponding line
    %   get_lin_br          -   properties of brain regions linked via corresponding line
    %   link_lins_settings  -   sets lines' properties
    %
    %   link_arr            -   plots link as arrow
    %   link_arr_on         -   shows a arrow link
    %   link_arr_off        -   hides a arrow link
    %   link_arr_is_on      -   checks if arrow link is visible
    %   link_arrs           -   plots multiple links as arrows
    %   link_arrs_on        -   shows multiple link arrows
    %   link_arrs_off       -   hides multiple link arrows
    %   get_arr_ij          -   order number of brain regions linked via corresponding arrow
    %   get_arr_br          -   properties of brain regions linked via corresponding arrow
    %   link_arrs_settings  -   sets arrows' properties
    %
    %   link_cyl            -   plots link as cylinder
    %   link_cyl_on         -   shows a cylinder link
    %   link_cyl_off        -   hides a cylinder link
    %   link_cyl_is_on      -   checks if cylinder link is visible
    %   link_cyls           -   plots multiple links as cylinders
    %   link_cyls_on        -   shows multiple link cylinders
    %   link_cyls_off       -   hides multiple link cylinders
    %   get_cyl_ij          -   order number of brain regions linked via corresponding cylinder
    %   get_cyl_br          -   properties of brain regions linked via corresponding cylinder
    %   link_cyls_settings  -   sets cylinders' properties
    %
    % See also PlotBrainSurf, PlotBrainAtlas.
    
    % Author: Mite Mijalkov & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        % Lines
        INIT_LIN_COLOR = [0 0 0];
        
        % Arrows
        INIT_ARR_COLOR = [0 0 0];
        INIT_ARR_SWIDTH = .1;
        INIT_ARR_HLENGTH = 1;
        INIT_ARR_HWIDTH = 1;
        INIT_ARR_HNODE = .5;
        INIT_ARR_N = 32;
        
        % Cylinders
        INIT_CYL_COLOR = [0 0 0];
        INIT_CYL_R = .1;
        INIT_CYL_N = 32;
    end
    properties (Access = protected)
        % lins is a 2D cell array containing the lines' properties
        % lins{n}.h     -   graphic handle
        % lins{n}.X1    -   initial x-coordinate
        % lins{n}.Y1    -   initial y-coordinate
        % lins{n}.Z1    -   initial z-coordinate
        % lins{n}.X2    -   final x-coordinate
        % lins{n}.Y2    -   final y-coordinate
        % lins{n}.Z2    -   final z-coordinate
        lins
        f_lins_settings  % lines setting figure handle
        
        % arrs is a 2D cell array containing the arrs' properties
        % arrs{n}.h         -   graphic handle
        % arrs{n}.X1        -   initial x-coordinate
        % arrs{n}.Y1        -   initial y-coordinate
        % arrs{n}.Z1        -   initial z-coordinate
        % arrs{n}.X2        -   final x-coordinate
        % arrs{n}.Y2        -   final y-coordinate
        % arrs{n}.Z2        -   final z-coordinate
        % arrs{n}.SWIDTH    -   arrow stem width
        % arrs{n}.HLENGTH   -   arrow head length
        % arrs{n}.HWIDTH    -   arrow head width
        % arrs{n}.HNODE     -   arrow head intersection with the arrow stem
        % arrs{n}.N         -   number of equally spaced points around the arrow
        arrs
        f_arrs_settings  % arrows setting figure handle
        
        % cyls is a 2D cell array containing the cylinders' properties
        % cyls{n}.h     -   graphic handle
        % cyls{n}.X1    -   initial x-coordinate
        % cyls{n}.Y1    -   initial y-coordinate
        % cyls{n}.Z1    -   initial z-coordinate
        % cyls{n}.X2    -   final x-coordinate
        % cyls{n}.Y2    -   final y-coordinate
        % cyls{n}.Z2    -   final z-coordinate
        % cyls{n}.R     -   cylinder radius
        % cyls{n}.N     -   number of equally spaced points around the cylinder
        cyls
        f_cyls_settings  % cylinders setting figure handle
    end
    methods
        function bg = PlotBrainGraph(atlas)
            % PLOTBRAINGRAPH() plots and manages the links between brain regions
            %   The links can be plotted by using lines, arrows or
            %   cylinders and their various properties can be set.
            %
            % See also PlotBrainGraph.
            
            bg = bg@PlotBrainAtlas(atlas);
            
            bg.lins.h = NaN(atlas.length(),atlas.length());
            bg.lins.X1 = repmat(atlas.getProps(BrainRegion.X),atlas.length(),1);
            bg.lins.Y1 = repmat(atlas.getProps(BrainRegion.Y),atlas.length(),1);
            bg.lins.Z1 = repmat(atlas.getProps(BrainRegion.Z),atlas.length(),1);
            bg.lins.X2 = repmat(atlas.getProps(BrainRegion.X)',1,atlas.length());
            bg.lins.Y2 = repmat(atlas.getProps(BrainRegion.Y)',1,atlas.length());
            bg.lins.Z2 = repmat(atlas.getProps(BrainRegion.Z)',1,atlas.length());
            
            bg.arrs.h = NaN(atlas.length(),atlas.length());
            bg.arrs.X1 = repmat(atlas.getProps(BrainRegion.X),atlas.length(),1);
            bg.arrs.Y1 = repmat(atlas.getProps(BrainRegion.Y),atlas.length(),1);
            bg.arrs.Z1 = repmat(atlas.getProps(BrainRegion.Z),atlas.length(),1);
            bg.arrs.X2 = repmat(atlas.getProps(BrainRegion.X)',1,atlas.length());
            bg.arrs.Y2 = repmat(atlas.getProps(BrainRegion.Y)',1,atlas.length());
            bg.arrs.Z2 = repmat(atlas.getProps(BrainRegion.Z)',1,atlas.length());
            bg.arrs.SWIDTH = PlotBrainGraph.INIT_ARR_SWIDTH * ones(atlas.length());
            bg.arrs.HLENGTH = PlotBrainGraph.INIT_ARR_HLENGTH * ones(atlas.length());
            bg.arrs.HWIDTH = PlotBrainGraph.INIT_ARR_HWIDTH * ones(atlas.length());
            bg.arrs.HNODE = PlotBrainGraph.INIT_ARR_HNODE * ones(atlas.length());
            bg.arrs.N = PlotBrainGraph.INIT_ARR_N * ones(atlas.length());
            
            bg.cyls.h = NaN(atlas.length(),atlas.length());
            bg.cyls.X1 = repmat(atlas.getProps(BrainRegion.X),atlas.length(),1);
            bg.cyls.Y1 = repmat(atlas.getProps(BrainRegion.Y),atlas.length(),1);
            bg.cyls.Z1 = repmat(atlas.getProps(BrainRegion.Z),atlas.length(),1);
            bg.cyls.X2 = repmat(atlas.getProps(BrainRegion.X)',1,atlas.length());
            bg.cyls.Y2 = repmat(atlas.getProps(BrainRegion.Y)',1,atlas.length());
            bg.cyls.Z2 = repmat(atlas.getProps(BrainRegion.Z)',1,atlas.length());
            bg.cyls.R = PlotBrainGraph.INIT_CYL_R * ones(atlas.length());
            bg.cyls.N = PlotBrainGraph.INIT_CYL_N * ones(atlas.length());
            
        end
        
        function h = link_lin(bg,i,j,varargin)
            % LINK_LIN plots link as line
            %
            % LINK_LIN(BG,I,J) plots the link from the brain regions I to
            %   J as a line, if not plotted.
            %
            % H = LINK_LIN(BG,I,J) returns the handle to the link line
            %   from the brain region I to J.
            %
            % LINK_LIN(BG,I,J,'PropertyName',PropertyValue) sets the property
            %   of the line link PropertyName to PropertyValue.
            %   All standard plot properties of plot3 can be used.
            %   The line properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, plot3.
            
            bg.set_axes();
            
            % get coordinates of the both regions center coordinates and label
            X1 = bg.atlas.get(i).getProp(BrainRegion.X);
            Y1 = bg.atlas.get(i).getProp(BrainRegion.Y);
            Z1 = bg.atlas.get(i).getProp(BrainRegion.Z);
            
            X2 = bg.atlas.get(j).getProp(BrainRegion.X);
            Y2 = bg.atlas.get(j).getProp(BrainRegion.Y);
            Z2 = bg.atlas.get(j).getProp(BrainRegion.Z);
            
            if ~ishandle(bg.lins.h(j,i))
                
                if ~ishandle(bg.lins.h(i,j))
                    
                    bg.lins.h(i,j) = plot3( ...
                        bg.get_axes(), ...
                        [X1 X2], ...
                        [Y1 Y2], ...
                        [Z1 Z2], ...
                        'Color',PlotBrainGraph.INIT_LIN_COLOR);
                else
                    
                    x1 = bg.lins.X1(i,j);
                    y1 = bg.lins.Y1(i,j);
                    z1 = bg.lins.Z1(i,j);
                    
                    x2 = bg.lins.X2(i,j);
                    y2 = bg.lins.Y2(i,j);
                    z2 = bg.lins.Z2(i,j);
                    
                    if x1~=X1 || y1~=Y1 || z1~=Z1 || x2~=X2 || y2~=Y2 || z2~=Z2
                        
                        set(bg.lins.h(i,j),'XData',[X1 X2]);
                        set(bg.lins.h(i,j),'YData',[Y1 Y2]);
                        set(bg.lins.h(i,j),'ZData',[Z1 Z2]);
                    end
                end
            else
                bg.lins.h(i,j) = bg.lins.h(j,i);
            end
            
            % saves new data
            bg.lins.X1(i,j) = X1;
            bg.lins.Y1(i,j) = Y1;
            bg.lins.Z1(i,j) = Z1;
            
            bg.lins.X2(i,j) = X2;
            bg.lins.Y2(i,j) = Y2;
            bg.lins.Z2(i,j) = Z2;
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'linestyle'
                        set(bg.lins.h(i,j),'LineStyle',varargin{n+1});
                    case 'linewidth'
                        set(bg.lins.h(i,j),'LineWidth',varargin{n+1});
                    case 'color'
                        set(bg.lins.h(i,j),'Color',varargin{n+1});
                    otherwise
                        set(bg.lins.h(i,j),varargin{n},varargin{n+1});
                end
            end
            
            % output if needed
            if nargout>0
                h = bg.lins.h(i,j);
            end
        end
        function link_lin_on(bg,i,j)
            % LINK_LIN_ON shows a line link
            %
            % LINK_LIN_ON(BG,I,J) shows the line link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.lins.h(i,j))
                set(bg.lins.h(i,j),'Visible','on')
            end
        end
        function link_lin_off(bg,i,j)
            % LINK_LIN_OFF hides a line link
            %
            % LINK_LIN_OFF(BG,I,J) hides the line link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.lins.h(i,j))
                set(bg.lins.h(i,j),'Visible','off')
            end
        end
        function bool = link_lin_is_on(bg,i,j)
            % LINK_LIN_IS_ON checks if line link is visible
            %
            % BOOL = LINK_LIN_IS_ON(BG,I,J) returns true if the line link
            %   from the brain regions I to J is visible and false otherwise.
            %
            % See also PlotBrainGraph.
            
            bool = ishandle(bg.lins.h(i,j)) && strcmpi(get(bg.lins.h(i,j),'Visible'),'on');
        end
        function link_lins(bg,i_vec,j_vec,varargin)
            % LINK_LINS plots multiple links as lines
            %
            % LINK_LINS(BG,I_VEC,J_VEC) plots the line links from the
            %   brain regions specified in I_VEC to the ones specified in
            %   J_VEC, if not plotted. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_LINS(BG,[],[]) plots the line links between all
            %   possible brain region combinations.
            %
            % LINK_LINS(BG,I_VEC,J_VEC,'PropertyName',PropertyValue) sets the property
            %   of the multiple line links' PropertyName to PropertyValue.
            %   All standard plot properties of plot3 can be used.
            %   The line properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, plot3.
            
            % Color - LineStyle - LineWidth
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'color'
                        Color = varargin{n+1};
                        ncolor = n+1;
                    case 'linestyle'
                        LineStyle = varargin{n+1};
                        nlinestyle = n+1;
                    case 'linewidth'
                        LineWidth = varargin{n+1};
                        nlinewidth = n+1;
                end
            end
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        if exist('Color','var') && size(Color,1)==bg.atlas.length() && size(Color,2)==bg.atlas.length() && size(Color,3)==3
                            varargin{ncolor} = squeeze(Color(i,j,:));
                        end
                        if exist('LineStyle','var') && size(LineStyle,1)==bg.atlas.length() && size(LineStyle,2)==bg.atlas.length()
                            varargin{nlinestyle} = LineStyle(i,j);
                        end
                        if exist('LineWidth','var') && size(LineWidth,1)==bg.atlas.length() && size(LineWidth,2)==bg.atlas.length()
                            varargin{nlinewidth} = LineWidth(i,j);
                        end
                        
                        bg.link_lin(i,j,varargin{:})
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    if exist('Color','var') && size(Color,1)==length(i_vec) && size(Color,2)==3
                        varargin{ncolor} = squeeze(Color(m,:));
                    end
                    if exist('LineStyle','var') && size(LineStyle,1)==length(i_vec)
                        varargin{nlinestyle} = LineStyle(m);
                    end
                    if exist('LineWidth','var') && size(LineWidth,1)==length(i_vec)
                        varargin{nlinewidth} = LineWidth(m);
                    end
                    
                    bg.link_lin(i_vec(m),j_vec(m),varargin{:})
                end
            end
        end
        function link_lins_on(bg,i_vec,j_vec)
            % LINK_LINS_ON shows multiple link lines
            %
            % LINK_LINS_ON(BG,I_VEC,J_VEC) shows multiple link lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_LINS_ON(BG,[],[]) shows the line links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_lin_on(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_lin_on(i_vec(m),j_vec(m))
                end
            end
        end
        function link_lins_off(bg,i_vec,j_vec)
            % LINK_LINS_OFF hides multiple link lines
            %
            % LINK_LINS_OFF(BG,I_VEC,J_VEC) hides multiple link lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_LINS_OFF(BG,[],[]) hides the line links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_lin_off(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_lin_off(i_vec(m),j_vec(m))
                end
            end
        end
        function [i,j] = get_lin_ij(bg,h)
            % GET_LIN_IJ order number of brain regions linked via corresponding line
            %
            % [I,J] = GET_LIN_IJ(BG,H) returns the order number of the brain regions
            %   connected via the line with handle H.
            %
            % See also PlotBrainGraph.
            
            i = NaN;
            j = NaN;
            if ~isempty(h)
                for m = 1:1:bg.atlas.length()
                    for n = 1:1:bg.atlas.length()
                        if h==bg.lins.h(m,n)
                            i = m;
                            j = n;
                        end
                    end
                end
            end
        end
        function [br_i, br_j] = get_lin_br(bg,h)
            % GET_LIN_BR properties of brain regions linked via corresponding line
            %
            % [BR_I,BR_J] = GET_LIN_BR(BG,H) returns the properties of the brain regions
            %   BR_I and BR_J connected via the line with handle H.
            %
            % See also PlotBrainGraph.
            
            [i,j] = bg.get_lin_ij(h);
            br_i = bg.atlas.get(i);
            br_j = bg.atlas.get(j);
        end
        function link_lins_settings(bg,m_vec,k_vec,varargin)
            % LINK_LINS_SETTINGS sets lines' properties
            %
            % LINK_LINS_SETTINGS(BG) allows the user to interractively
            %   change the lines settings via a graphical user interface.
            %
            % LINK_LINS_SETTINGS(BG,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotBrainGraph.
            
            data = cell(bg.atlas.length(),bg.atlas.length());
            
            if nargin<2 || isempty(m_vec) || isempty(k_vec)
                m_vec = 1:1:bg.atlas.length();
                k_vec = 1:1:bg.atlas.length();
            end
            if length(m_vec)==1
                m_vec = m_vec*ones(size(k_vec));
            end
            if length(k_vec)==1
                k_vec = k_vec*ones(size(m_vec));
            end
            for p = 1:1:length(m_vec)
                    if m_vec(p) ~= k_vec(p)
                        data{m_vec(p),k_vec(p)} = true;
                    else
                        data{m_vec(p),k_vec(p)} = false;
                    end
            end
            
            set_color = bg.INIT_LIN_COLOR;
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Brain Graph Lines Settings';
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'figposition'
                        FigPosition = varargin{n+1};
                    case 'figcolor'
                        FigColor = varargin{n+1};
                    case 'figname'
                        FigName = varargin{n+1};
                end
            end
            
            % create a figure
            if isempty(bg.f_lins_settings) || ~ishandle(bg.f_lins_settings)
                bg.f_lins_settings = figure('Visible','off');
            end
            f = bg.f_lins_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            ui_table = uitable(f);
            GUI.setUnits(ui_table)
            set(ui_table,'BackgroundColor',GUI.TABBKGCOLOR)
            set(ui_table,'Position',[.03 .215 .54 .71])
            set(ui_table,'ColumnName',bg.atlas.getProps(BrainRegion.LABEL))
            set(ui_table,'ColumnWidth',{40})
            set(ui_table,'RowName',bg.atlas.getProps(BrainRegion.LABEL))
            [string{1:bg.atlas.length()}] = deal('logical');
            set(ui_table,'ColumnFormat',string)
            set(ui_table,'ColumnEditable',true)
            set(ui_table,'Data',data)
            set(ui_table,'CellEditCallback',{@cb_table_edit});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.60 .825 .18 .10])
            set(ui_button_show,'String','Show lines')
            set(ui_button_show,'TooltipString','Show selected lines')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.80 .825 .18 .10])
            set(ui_button_hide,'String','Hide lines')
            set(ui_button_hide,'TooltipString','Hide selected lines')
            set(ui_button_hide,'Callback',{@cb_hide})
            
            ui_popup_style = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_style)
            GUI.setBackgroundColor(ui_popup_style)
            set(ui_popup_style,'Position',[.62 .575 .35 .10])
            set(ui_popup_style,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_style,'Value',1)
            set(ui_popup_style,'TooltipString','Select line style');
            set(ui_popup_style,'Callback',{@cb_style})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.62 .330 .10 .10])
            set(ui_text_width,'String','Link width ')
            set(ui_text_width,'HorizontalAlignment','left')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.72 .325 .25 .10])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_width})
            
            ui_button_linecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_linecolor)
            GUI.setBackgroundColor(ui_button_linecolor)
            set(ui_button_linecolor,'ForegroundColor',set_color)
            set(ui_button_linecolor,'Position',[.62 .075 .35 .10])
            set(ui_button_linecolor,'String','Link Color')
            set(ui_button_linecolor,'TooltipString','Select line color')
            set(ui_button_linecolor,'Callback',{@cb_linecolor})
            
            ui_button_clearselection = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_clearselection)
            GUI.setBackgroundColor(ui_button_clearselection)
            set(ui_button_clearselection,'Position',[.03 .075 .54 .10])
            set(ui_button_clearselection,'String','Clear Selection')
            set(ui_button_clearselection,'TooltipString','Clear selected links')
            set(ui_button_clearselection,'Callback',{@cb_clearselection})
            
            function cb_table_edit(~,event)  % (src,event)
                i = event.Indices(1);
                j = event.Indices(2);
                
                if i~=j
                    if data{i,j} == true
                        data{i,j} = false;
                    else
                        data{i,j} = true;
                    end
                    set(ui_table,'Data',data)
                end
            end
            function update_link_lins()
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_style,'Value')};
                width = real(str2num(get(ui_edit_width,'String')));
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_lins(i,j,'LineStyle',style,'LineWidth',width,...
                            'Color',set_color);
                    end
                end
            end
            function cb_show(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        update_link_lins()
                        bg.link_lins_on(i,j)
                    end
                end
            end
            function cb_hide(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_lins_off(i,j)
                    end
                end
            end
            function cb_style(~,~)  % (src,event)
                update_link_lins()
            end
            function cb_width(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<1
                    set(ui_edit_width,'String','1')
                    width = 3;
                end
                update_link_lins()
            end
            function cb_linecolor(~,~)  % (src,event)
                set_color_prev = get(ui_button_linecolor,'ForegroundColor');
                set_color = uisetcolor();               
                if length(set_color)==3
                    set(ui_button_linecolor,'ForegroundColor',set_color)
                    update_link_lins()
                else 
                    set_color = set_color_prev;
                end
            end
            function cb_clearselection(~,~)  % (src,event)
                [data{:}] = deal(zeros(1));
                set(ui_table,'Data',data)
            end
            set(f,'Visible','on')
        end
        
        function h = link_arr(bg,i,j,varargin)
            % LINK_ARR plots link as arrow
            %
            % LINK_ARR(BG,I,J) plots the link from the brain regions I to
            %   J as an arrow, if not plotted.
            %
            % H = LINK_ARR(BG,I,J) returns the handle to the link arrow
            %   from the brain region I to J.
            %
            % LINK_ARR(BG,I,J,'PropertyName',PropertyValue) sets the property
            %   of the arrow link PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used and also
            %   the ARROW3D properties listed below.
            % ARROW3D properties:
            %   Color       -   Arrow color both edges and faces [default = 'k']
            %   StemWidth   -   Arrow stem width [default = .1]
            %   HeadLength  -   Arrow head length [default = 1]
            %   HeadWidth   -   Arrow head width [default = 1]
            %   HeadNode    -   Arrow head intersection with the arrow stem [default = .5]
            %   N           -   Number of radial sections [default = 32]
            %   The arrow properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, arrow3d, surf.
            
            bg.set_axes();
            
            % arrow properties
            color = PlotBrainGraph.INIT_ARR_COLOR;
            SWIDTH = bg.arrs.SWIDTH(i,j);
            HLENGTH = bg.arrs.HLENGTH(i,j);
            HWIDTH = bg.arrs.HWIDTH(i,j);
            HNODE = bg.arrs.HNODE(i,j);
            N = bg.arrs.N(i,j);
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'stemwidth'
                        SWIDTH = varargin{n+1};
                    case 'headlength'
                        HLENGTH = varargin{n+1};
                    case 'headwidth'
                        HWIDTH = varargin{n+1};
                    case 'headnode'
                        HNODE = varargin{n+1};
                    case 'n'
                        N = varargin{n+1};
                    case 'color'
                        color = varargin{n+1};
                end
            end
            
            % get coordinates of the both regions
            X1 = bg.atlas.get(i).getProp(BrainRegion.X);
            Y1 = bg.atlas.get(i).getProp(BrainRegion.Y);
            Z1 = bg.atlas.get(i).getProp(BrainRegion.Z);
            
            X2 = bg.atlas.get(j).getProp(BrainRegion.X);
            Y2 = bg.atlas.get(j).getProp(BrainRegion.Y);
            Z2 = bg.atlas.get(j).getProp(BrainRegion.Z);
            
            if ~ishandle(bg.arrs.h(i,j))
                
                [X,Y,Z] = arrow3d(X1, Y1, Z1, X2, Y2, Z2,...
                    'StemWidth',SWIDTH,...
                    'HeadLength',HLENGTH,...
                    'HeadWidth',HWIDTH,...
                    'HeadNode',HNODE,...
                    'N',N);
                
                bg.arrs.h(i,j) = surf(X,Y,Z,...
                    'EdgeColor',color,...
                    'FaceColor',color,...
                    'Parent',bg.get_axes());
            else
                
                x1 = bg.arrs.X1(i,j);
                y1 = bg.arrs.Y1(i,j);
                z1 = bg.arrs.Z1(i,j);
                
                x2 = bg.arrs.X2(i,j);
                y2 = bg.arrs.Y2(i,j);
                z2 = bg.arrs.Z2(i,j);
                
                swidth = bg.arrs.SWIDTH(i,j);
                hlength = bg.arrs.HLENGTH(i,j);
                hwidth = bg.arrs.HWIDTH(i,j);
                hnode = bg.arrs.HNODE(i,j);
                num = bg.arrs.N(i,j);
                
                if x1~=X1 || y1~=Y1 || z1~=Z1 || x2~=X2 || y2~=Y2 || z2~=Z2 ...
                        || swidth~=SWIDTH || hlength~=HLENGTH || hwidth~=HWIDTH || hnode~=HNODE || num~=N
                    
                    [X,Y,Z] = arrow3d(X1, Y1, Z1, X2, Y2, Z2,...
                        'StemWidth',SWIDTH,...
                        'HeadLength',HLENGTH,...
                        'HeadWidth',HWIDTH,...
                        'HeadNode',HNODE,...
                        'N',N);
                    
                    set(bg.arrs.h(i,j),'XData',X);
                    set(bg.arrs.h(i,j),'YData',Y);
                    set(bg.arrs.h(i,j),'ZData',Z);
                end
            end
            
            % saves new data
            bg.arrs.X1(i,j) = X1;
            bg.arrs.Y1(i,j) = Y1;
            bg.arrs.Z1(i,j) = Z1;
            
            bg.arrs.X2(i,j) = X2;
            bg.arrs.Y2(i,j) = Y2;
            bg.arrs.Z2(i,j) = Z2;
            
            bg.arrs.SWIDTH(i,j) = SWIDTH;
            bg.arrs.HLENGTH(i,j) = HLENGTH;
            bg.arrs.HWIDTH(i,j) = HWIDTH;
            bg.arrs.HNODE(i,j) = HNODE;
            bg.arrs.N(i,j) = N;
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'stemwidth'
                        % do nothing
                    case 'headlength'
                        % do nothing
                    case 'headwidth'
                        % do nothing
                    case 'headnode'
                        % do nothing
                    case 'n'
                        % do nothing
                    case 'color'
                        color = varargin{n+1};
                        set(bg.arrs.h(i,j),'FaceColor',color)
                        set(bg.arrs.h(i,j),'EdgeColor',color)
                    otherwise
                        bg.arrs.h(i,j) = arrow3d(X1, Y1, Z1, X2, Y2, Z2,varargin{n},varargin{n+1});
                end
            end
            
            % output if needed
            if nargout>0
                h = bg.arrs.h(i,j);
            end
        end
        function link_arr_on(bg,i,j)
            % LINK_ARR_ON shows an arrow link
            %
            % LINK_ARR_ON(BG,I,J) shows the arrow link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.arrs.h(i,j))
                set(bg.arrs.h(i,j),'Visible','on')
            end
        end
        function link_arr_off(bg,i,j)
            % LINK_ARR_OFF hides an arrow link
            %
            % LINK_ARR_OFF(BG,I,J) hides the arrow link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.arrs.h(i,j))
                set(bg.arrs.h(i,j),'Visible','off')
            end
        end
        function bool = link_arr_is_on(bg,i,j)
            % LINK_ARR_IS_ON checks if arrow link is visible
            %
            % BOOL = LINK_ARR_IS_ON(BG,I,J) returns true if the arrow link
            %   from the brain regions I to J is visible and false otherwise.
            %
            % See also PlotBrainGraph.
            
            bool = ishandle(bg.arrs.h(i,j)) && strcmpi(get(bg.arrs.h(i,j),'Visible'),'on');
        end
        function link_arrs(bg,i_vec,j_vec,varargin)
            % LINK_ARRS plots multiple links as arrs
            %
            % LINK_ARRS(BG,I_VEC,J_VEC) plots the arrow links from the
            %   brain regions specified in I_VEC to the ones specified in
            %   J_VEC, if not plotted. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_ARRS(BG,[],[]) plots the arrow links between all
            %   possible brain region combinations.
            %
            % LINK_ARRS(BG,I_VEC,J_VEC,'PropertyName',PropertyValue) sets the property
            %   of the multiple arrow links' PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used and also
            %   the ARROW3D properties listed below.
            % ARROW3D properties:
            %   Color       -   Arrow color both edges and faces [default = 'k']
            %   StemWidth   -   Arrow stem width [default = .1]
            %   HeadLength  -   Arrow head length [default = 1]
            %   HeadWidth   -   Arrow head width [default = 1]
            %   HeadNode    -   Arrow head intersection with the arrow stem [default = .5]
            %   N           -   Number of radial sections [default = 32]
            %   The arrow properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, arrow3d, plot3.
            
            % StemWidth - HeadLength - HeadWidth - HeadNode - Color - N
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'stemwidth'
                        StemWidth = varargin{n+1};
                        nstemwidth = n+1;
                    case 'headlength'
                        HeadLength = varargin{n+1};
                        nheadlength = n+1;
                    case 'headwidth'
                        HeadWidth = varargin{n+1};
                        nheadwidth = n+1;
                    case 'headnode'
                        HeadNode = varargin{n+1};
                        nheadnode = n+1;
                    case 'color'
                        Color = varargin{n+1};
                        ncolor = n+1;
                    case 'n'
                        Number = varargin{n+1};
                        nnumber = n+1;
                end
            end
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        if exist('Color','var') && size(Color,1)==bg.atlas.length() && size(Color,2)==bg.atlas.length() && size(Color,3)==3
                            varargin{ncolor} = squeeze(Color(i,j,:));
                        end
                        if exist('StemWidth','var') && size(StemWidth,1)==bg.atlas.length() && size(StemWidth,2)==bg.atlas.length()
                            varargin{nstemwidth} = StemWidth(i,j);
                        end
                        if exist('HeadLength','var') && size(HeadLength,1)==bg.atlas.length() && size(HeadLength,2)==bg.atlas.length()
                            varargin{nheadlength} = HeadLength(i,j);
                        end
                        if exist('HeadWidth','var') && size(HeadWidth,1)==bg.atlas.length() && size(HeadWidth,2)==bg.atlas.length()
                            varargin{nheadwidth} = HeadWidth(i,j);
                        end
                        if exist('HeadNode','var') && size(HeadNode,1)==bg.atlas.length() && size(HeadNode,2)==bg.atlas.length()
                            varargin{nheadnode} = HeadNode(i,j);
                        end
                        if exist('Number','var') && size(Number,1)==bg.atlas.length() && size(Number,2)==bg.atlas.length()
                            varargin{nnumber} = Number(i,j);
                        end
                        
                        bg.link_arr(i,j,varargin{:})
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    if exist('Color','var') && size(Color,1)==bg.atlas.length() && size(Color,2)==bg.atlas.length() && size(Color,3)==3
                        varargin{ncolor} = squeeze(Color(m,:));
                    end
                    if exist('StemWidth','var') && size(StemWidth,1)==bg.atlas.length() && size(StemWidth,2)==bg.atlas.length()
                        varargin{nstemwidth} = StemWidth(m);
                    end
                    if exist('HeadLength','var') && size(HeadLength,1)==bg.atlas.length() && size(HeadLength,2)==bg.atlas.length()
                        varargin{nheadlength} = HeadLength(m);
                    end
                    if exist('HeadWidth','var') && size(HeadWidth,1)==bg.atlas.length() && size(HeadWidth,2)==bg.atlas.length()
                        varargin{nheadwidth} = HeadWidth(m);
                    end
                    if exist('HeadNode','var') && size(HeadNode,1)==bg.atlas.length() && size(HeadNode,2)==bg.atlas.length()
                        varargin{nheadnode} = HeadNode(m);
                    end
                    if exist('Number','var') && size(Number,1)==bg.atlas.length() && size(Number,2)==bg.atlas.length()
                        varargin{nnumber} = Number(m);
                    end
                    
                    bg.link_arr(i_vec(m),j_vec(m),varargin{:})
                end
            end
        end
        function link_arrs_on(bg,i_vec,j_vec)
            % LINK_ARRS_ON shows multiple arrow lines
            %
            % LINK_ARRS_ON(BG,I_VEC,J_VEC) shows multiple arrow lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_ARRS_ON(BG,[],[]) shows the arrow links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_arr_on(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_arr_on(i_vec(m),j_vec(m))
                end
            end
        end
        function link_arrs_off(bg,i_vec,j_vec)
            % LINK_ARRS_OFF hides multiple arrow lines
            %
            % LINK_ARRS_OFF(BG,I_VEC,J_VEC) hides multiple arrow lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_ARRS_OFF(BG,[],[]) hides the arrow links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_arr_off(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_arr_off(i_vec(m),j_vec(m))
                end
            end
        end
        function [i,j] = get_arr_ij(bg,h)
            % GET_ARR_IJ order number of brain regions linked via corresponding arrow
            %
            % [I,J] = GET_ARR_IJ(BG,H) returns the order number of the brain regions
            %   connected via the arrow with handle H.
            %
            % See also PlotBrainGraph.
            
            i = NaN;
            j = NaN;
            if ~isempty(h)
                for m = 1:1:bg.atlas.length()
                    for n = 1:1:bg.atlas.length()
                        if h==bg.arrs.h(m,n)
                            i = m;
                            j = n;
                        end
                    end
                end
            end
        end
        function [br_i, br_j] = get_arr_br(bg,h)
            % GET_ARR_BR properties of brain regions linked via corresponding arrow
            %
            % [BR_I,BR_J] = GET_ARR_BR(BG,H) returns the properties of the brain regions
            %   BR_I and BR_J connected via the arrow with handle H.
            %
            % See also PlotBrainGraph.
            
            [i,j] = bg.get_arr_ij(h);
            br_i = bg.atlas.get(i);
            br_j = bg.atlas.get(j);
        end
        function link_arrs_settings(bg,m_vec,k_vec,varargin)
            % LINK_ARRS_SETTINGS sets arrows' properties
            %
            % LINK_ARRS_SETTINGS(BG) allows the user to interractively
            %   change the arrows settings via a graphical user interface.
            %
            % LINK_ARRS_SETTINGS(BG,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotBrainGraph.
            
            data = cell(bg.atlas.length(),bg.atlas.length()); 
            
            if nargin<2 || isempty(m_vec) || isempty(k_vec)
                m_vec = 1:1:bg.atlas.length();
                k_vec = 1:1:bg.atlas.length();
            end
            if length(m_vec)==1
                m_vec = m_vec*ones(size(k_vec));
            end
            if length(k_vec)==1
                k_vec = k_vec*ones(size(m_vec));
            end
            for p = 1:1:length(m_vec)
                    if m_vec(p) ~= k_vec(p)
                        data{m_vec(p),k_vec(p)} = true;
                    else
                        data{m_vec(p),k_vec(p)} = false;
                    end
            end
            
            set_color = bg.INIT_ARR_COLOR;
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Brain Graph Arrows Settings';
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'figposition'
                        FigPosition = varargin{n+1};
                    case 'figcolor'
                        FigColor = varargin{n+1};
                    case 'figname'
                        FigName = varargin{n+1};
                end
            end
            
            % create a figure
            if isempty(bg.f_arrs_settings) || ~ishandle(bg.f_arrs_settings)
                bg.f_arrs_settings = figure('Visible','off');
            end
            f = bg.f_arrs_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            ui_table = uitable(f);
            GUI.setUnits(ui_table)
            set(ui_table,'BackgroundColor',GUI.TABBKGCOLOR)
            set(ui_table,'Position',[.03 .215 .54 .71])
            set(ui_table,'ColumnName',bg.atlas.getProps(BrainRegion.LABEL))
            set(ui_table,'ColumnWidth',{40})
            set(ui_table,'RowName',bg.atlas.getProps(BrainRegion.LABEL))
            [string{1:bg.atlas.length()}] = deal('logical');
            set(ui_table,'ColumnFormat',string)
            set(ui_table,'ColumnEditable',true)
            set(ui_table,'Data',data)
            set(ui_table,'CellEditCallback',{@cb_table_edit});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.60 .825 .18 .10])
            set(ui_button_show,'String','Show arrows')
            set(ui_button_show,'TooltipString','Show selected arrows')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.80 .825 .18 .10])
            set(ui_button_hide,'String','Hide arrows')
            set(ui_button_hide,'TooltipString','Hide selected arrows')
            set(ui_button_hide,'Callback',{@cb_hide})
                       
            ui_text_stemwidth = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_stemwidth)
            GUI.setBackgroundColor(ui_text_stemwidth)
            set(ui_text_stemwidth,'Position',[.60 .520 .10 .10])
            set(ui_text_stemwidth,'String','Stem width ')
            set(ui_text_stemwidth,'HorizontalAlignment','left')
            set(ui_text_stemwidth,'FontWeight','bold')
            
            ui_edit_stemwidth = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_stemwidth)
            GUI.setBackgroundColor(ui_edit_stemwidth)
            set(ui_edit_stemwidth,'Position',[.68 .515 .10 .10])
            set(ui_edit_stemwidth,'HorizontalAlignment','center')
            set(ui_edit_stemwidth,'FontWeight','bold')
            set(ui_edit_stemwidth,'String','0.1')
            set(ui_edit_stemwidth,'Callback',{@cb_stemwidth})
            
            ui_text_headwidth = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_headwidth)
            GUI.setBackgroundColor(ui_text_headwidth)
            set(ui_text_headwidth,'Position',[.80 .520 .10 .10])
            set(ui_text_headwidth,'String','Head width ')
            set(ui_text_headwidth,'HorizontalAlignment','left')
            set(ui_text_headwidth,'FontWeight','bold')
            
            ui_edit_headwidth = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_headwidth)
            GUI.setBackgroundColor(ui_edit_headwidth)
            set(ui_edit_headwidth,'Position',[.88 .515 .10 .10])
            set(ui_edit_headwidth,'HorizontalAlignment','center')
            set(ui_edit_headwidth,'FontWeight','bold')
            set(ui_edit_headwidth,'String','1')
            set(ui_edit_headwidth,'Callback',{@cb_headwidth})
            
            ui_text_headlength = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_headlength)
            GUI.setBackgroundColor(ui_text_headlength)
            set(ui_text_headlength,'Position',[.60 .115 .10 .20])
            set(ui_text_headlength,'String','Head length ')
            set(ui_text_headlength,'HorizontalAlignment','left')
            set(ui_text_headlength,'FontWeight','bold')
            
            ui_edit_headlength = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_headlength)
            GUI.setBackgroundColor(ui_edit_headlength)
            set(ui_edit_headlength,'Position',[.68 .210 .10 .10])
            set(ui_edit_headlength,'HorizontalAlignment','center')
            set(ui_edit_headlength,'FontWeight','bold')
            set(ui_edit_headlength,'String','1')
            set(ui_edit_headlength,'Callback',{@cb_headlength})
            
            ui_text_headnode = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_headnode)
            GUI.setBackgroundColor(ui_text_headnode)
            set(ui_text_headnode,'Position',[.80 .215 .10 .10])
            set(ui_text_headnode,'String','Head node ')
            set(ui_text_headnode,'HorizontalAlignment','left')
            set(ui_text_headnode,'FontWeight','bold')
            
            ui_edit_headnode = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_headnode)
            GUI.setBackgroundColor(ui_edit_headnode)
            set(ui_edit_headnode,'Position',[.88 .210 .10 .10])
            set(ui_edit_headnode,'HorizontalAlignment','center')
            set(ui_edit_headnode,'FontWeight','bold')
            set(ui_edit_headnode,'String','0.5')
            set(ui_edit_headnode,'Callback',{@cb_headnode})
            
            ui_button_arrowcolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_arrowcolor)
            GUI.setBackgroundColor(ui_button_arrowcolor)
            set(ui_button_arrowcolor,'ForegroundColor',set_color)
            set(ui_button_arrowcolor,'Position',[.62 .075 .35 .10])
            set(ui_button_arrowcolor,'String','Link Color')
            set(ui_button_arrowcolor,'TooltipString','Select line color')
            set(ui_button_arrowcolor,'Callback',{@cb_arrowcolor})
            
            ui_button_clearselection = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_clearselection)
            GUI.setBackgroundColor(ui_button_clearselection)
            set(ui_button_clearselection,'Position',[.03 .075 .54 .10])
            set(ui_button_clearselection,'String','Clear Selection')
            set(ui_button_clearselection,'TooltipString','Clear selected links')
            set(ui_button_clearselection,'Callback',{@cb_clearselection})
            
            function cb_table_edit(~,event)  % (src,event)
                i = event.Indices(1);
                j = event.Indices(2);
                
                if i~=j
                    if data{i,j} == true
                        data{i,j} = false;
                    else
                        data{i,j} = true;
                    end
                    set(ui_table,'Data',data)
                end
            end
            function update_link_arrs()
                stemwidth = real(str2num(get(ui_edit_stemwidth,'String')));
                headwidth = real(str2num(get(ui_edit_headwidth,'String')));
                headlength = real(str2num(get(ui_edit_headlength,'String')));
                headnode = real(str2num(get(ui_edit_headnode,'String')));
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_arrs(i,j,'StemWidth',stemwidth,...
                            'HeadWidth',headwidth,...
                            'HeadLength',headlength,...
                            'HeadNode',headnode,...
                            'Color',set_color);
                    end
                end
            end
            function cb_arrowcolor(~,~)  % (src,event)
                set_color_prev = get(ui_button_arrowcolor,'ForegroundColor');
                set_color = uisetcolor();               
                if length(set_color)==3
                    set(ui_button_arrowcolor,'ForegroundColor',set_color)
                    update_link_arrs()
                else 
                    set_color = set_color_prev;
                end
            end
            function cb_show(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        update_link_arrs()
                        bg.link_arrs_on(i,j)
                    end
                end
            end
            function cb_hide(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_arrs_off(i,j)
                    end
                end
            end
            function cb_stemwidth(~,~)  % (src,event)
                stemwidth = real(str2num(get(ui_edit_stemwidth,'String')));
                
                if isempty(stemwidth) || stemwidth<=0
                    set(ui_edit_stemwidth,'String','0.1')
                    stemwidth = 3;
                end
                update_link_arrs()
            end
            function cb_headwidth(~,~)  % (src,event)
                headwidth = real(str2num(get(ui_edit_headwidth,'String')));
                
                if isempty(headwidth) || headwidth<=0
                    set(ui_edit_headwidth,'String','1')
                    headwidth = 3;
                end
                update_link_arrs()
            end
            function cb_headlength(~,~)  % (src,event)
                headlength = real(str2num(get(ui_edit_headlength,'String')));
                
                if isempty(headlength) || headlength<=0
                    set(ui_edit_headlength,'String','1')
                    headlength = 3;
                end
                update_link_arrs()
            end
            function cb_headnode(~,~)  % (src,event)
                headnode = real(str2num(get(ui_edit_headnode,'String')));
                
                if isempty(headnode) || headnode<=0
                    set(ui_edit_headnode,'String','0.5')
                    headnode = 3;
                end
                update_link_arrs()
            end
            function cb_clearselection(~,~)  % (src,event)
                [data{:}] = deal(zeros(1));
                set(ui_table,'Data',data)
            end
            set(f,'Visible','on')
        end
        
        function h = link_cyl(bg,i,j,varargin)
            % LINK_CYL plots link as cylinder
            %
            % LINK_CYL(BG,I,J) plots the link from the brain regions I to
            %   J as a cylinder, if not plotted.
            %
            % H = LINK_CYL(BG,I,J) returns the handle to the link cylinder
            %   from the brain region I to J.
            %
            % LINK_CYL(BG,I,J,'PropertyName',PropertyValue) sets the property
            %   of the cylinder link PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used and also the
            %   CYLINDER3D properties listed below.
            % Additional CYLINDER3D properties:
            %   Color   -   Cylinder color both edges and faces [default = 'k']
            %   R       -   Cylinder radius [default = .1]
            %   N       -   Number of radial sections [default = 32]
            %   The cylinder properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, cylinder3d, plot3.
            
            bg.set_axes();
            
            % cylinder properties
            color = PlotBrainGraph.INIT_CYL_COLOR;
            R = bg.cyls.R(i,j);
            N = bg.cyls.N(i,j);
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'r'
                        R = varargin{n+1};
                    case 'n'
                        N = varargin{n+1};
                end
            end
            
            
            % get coordinates of the both regions
            X1 = bg.atlas.get(i).getProp(BrainRegion.X);
            Y1 = bg.atlas.get(i).getProp(BrainRegion.Y);
            Z1 = bg.atlas.get(i).getProp(BrainRegion.Z);
            
            X2 = bg.atlas.get(j).getProp(BrainRegion.X);
            Y2 = bg.atlas.get(j).getProp(BrainRegion.Y);
            Z2 = bg.atlas.get(j).getProp(BrainRegion.Z);
            
            if ~ishandle(bg.cyls.h(i,j))
                
                [X,Y,Z] = cylinder3d(X1, Y1, Z1, X2, Y2, Z2,...
                    'R',R,...
                    'N',N);
                
                bg.cyls.h(i,j) = surf(X,Y,Z,...
                    'EdgeColor',color,...
                    'FaceColor',color,...
                    'Parent',bg.get_axes());
                
            else
                
                x1 = bg.cyls.X1(i,j);
                y1 = bg.cyls.Y1(i,j);
                z1 = bg.cyls.Z1(i,j);
                
                x2 = bg.cyls.X2(i,j);
                y2 = bg.cyls.Y2(i,j);
                z2 = bg.cyls.Z2(i,j);
                
                r = bg.cyls.R(i,j);
                num = bg.cyls.N(i,j);
                
                if x1~=X1 || y1~=Y1 || z1~=Z1 || x2~=X2 || y2~=Y2 || z2~=Z2 || r~=R || num~=N
                    
                    [X,Y,Z] = cylinder3d(X1, Y1, Z1, X2, Y2, Z2,...
                        'R',R,...
                        'N',N);
                    
                    set(bg.cyls.h(i,j),'XData',X);
                    set(bg.cyls.h(i,j),'YData',Y);
                    set(bg.cyls.h(i,j),'ZData',Z);
                end
            end
            
            % saves new data
            bg.cyls.X1(i,j) = X1;
            bg.cyls.Y1(i,j) = Y1;
            bg.cyls.Z1(i,j) = Z1;
            
            bg.cyls.X2(i,j) = X2;
            bg.cyls.Y2(i,j) = Y2;
            bg.cyls.Z2(i,j) = Z2;
            
            bg.cyls.R(i,j) = R;
            bg.cyls.N(i,j) = N;
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'r'
                        % do nothing
                    case 'n'
                        % do nothing
                    case 'color'
                        color = varargin{n+1};
                        set(bg.cyls.h(i,j),'FaceColor',color);
                        set(bg.cyls.h(i,j),'EdgeColor',color);
                    case 'alpha'
                        % do nothing
                    otherwise
                        bg.cyls.h(i,j) = cylinder3d(X1, Y1, Z1, X2, Y2, Z2,varargin{n},varargin{n+1});
                end
            end
            
            % output if needed
            if nargout>0
                h = bg.cyls.h(i,j);
            end
        end
        function link_cyl_on(bg,i,j)
            % LINK_CYL_ON shows a cylinder link
            %
            % LINK_CYL_ON(BG,I,J) shows the cylinder link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.cyls.h(i,j))
                set(bg.cyls.h(i,j),'Visible','on')
            end
        end
        function link_cyl_off(bg,i,j)
            % LINK_CYL_OFF hides a cylinder link
            %
            % LINK_CYL_OFF(BG,I,J) hides the cylinder link from the brain
            %   region I to J.
            %
            % See also PlotBrainGraph.
            
            if ishandle(bg.cyls.h(i,j))
                set(bg.cyls.h(i,j),'Visible','off')
            end
        end
        function bool = link_cyl_is_on(bg,i,j)
            % LINK_CYL_IS_ON checks if cylinder link is visible
            %
            % BOOL = LINK_CYL_IS_ON(BG,I,J) returns true if the cylinder link
            %   from the brain regions I to J is visible and false otherwise.
            %
            % See also PlotBrainGraph.
            
            bool = ishandle(bg.cyls.h(i,j)) && strcmpi(get(bg.cyls.h(i,j),'Visible'),'on');
        end
        function link_cyls(bg,i_vec,j_vec,varargin)
            % LINK_CYLS plots multiple links as cylinders
            %
            % LINK_CYLS(BG,I_VEC,J_VEC) plots the cylinder links from the
            %   brain regions specified in I_VEC to the ones specified in
            %   J_VEC, if not plotted. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_CYLS(BG,[],[]) plots the cylinder links between all
            %   possible brain region combinations.
            %
            % LINK_CYLS(BG,I_VEC,J_VEC,'PropertyName',PropertyValue) sets the property
            %   of the multiple cylinder links' PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used and also
            %   the CYLINDER3D properties listed below.
            % Additional CYLINDER3D properties:
            %   Color   -   Cylinder color both edges and faces [default = 'k']
            %   R       -   Cylinder radius [default = .1]
            %   N       -   Number of radial sections [default = 32]
            %   The cylinder properties can also be changed when hidden.
            %
            % See also PlotBrainGraph, arrow3d, plot3.
            
            % Color - R - N
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'color'
                        Color = varargin{n+1};
                        ncolor = n+1;
                    case 'r'
                        Radius = varargin{n+1};
                        nradius = n+1;
                    case 'n'
                        Number = varargin{n+1};
                        nnumber = n+1;
                end
            end
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        if exist('Color','var') && size(Color,1)==bg.atlas.length() && size(Color,2)==bg.atlas.length() && size(Color,3)==3
                            varargin{ncolor} = squeeze(Color(i,j,:));
                        end
                        if exist('Radius','var') && size(Radius,1)==bg.atlas.length() && size(Radius,2)==bg.atlas.length()
                            varargin{nradius} = Radius(i,j);
                        end
                        if exist('Number','var') && size(Number,1)==bg.atlas.length() && size(Number,2)==bg.atlas.length()
                            varargin{nnumber} = Number(i,j);
                        end
                        
                        bg.link_cyl(i,j,varargin{:})
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    if exist('Color','var') && size(Color,1)==bg.atlas.length() && size(Color,2)==bg.atlas.length() && size(Color,3)==3
                        varargin{ncolor} = squeeze(Color(m,:));
                    end
                    if exist('Radius','var') && size(Radius,1)==bg.atlas.length() && size(Radius,2)==bg.atlas.length()
                        varargin{nradius} = Radius(m);
                    end
                    if exist('Number','var') && size(Number,1)==bg.atlas.length() && size(Number,2)==bg.atlas.length()
                        varargin{nnumber} = Number(m);
                    end
                    
                    bg.link_cyl(i_vec(m),j_vec(m),varargin{:})
                end
            end
        end
        function link_cyls_on(bg,i_vec,j_vec)
            % LINK_CYLS_ON shows multiple cylinder lines
            %
            % LINK_CYLS_ON(BG,I_VEC,J_VEC) shows multiple cylinder lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_CYLS_ON(BG,[],[]) shows the cylinder links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_cyl_on(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_cyl_on(i_vec(m),j_vec(m))
                end
            end
        end
        function link_cyls_off(bg,i_vec,j_vec)
            % LINK_CYLS_OFF hides multiple cylinder lines
            %
            % LINK_CYLS_OFF(BG,I_VEC,J_VEC) hides multiple cylinder lines
            %   from the brain regions specified in I_VEC to the ones
            %   specified in J_VEC. I_VEC and J_VEC need not be the same
            %   size.
            %
            % LINK_CYLS_OFF(BG,[],[]) shows the cylinder links between all
            %   possible brain region combinations.
            %
            % See also PlotBrainGraph.
            
            if nargin<2 || isempty(i_vec) || isempty(j_vec)
                for i = 1:1:bg.atlas.length()
                    for j = 1:1:bg.atlas.length()
                        bg.link_cyl_off(i,j)
                    end
                end
            else
                if length(i_vec)==1
                    i_vec = i_vec*ones(size(j_vec));
                end
                if length(j_vec)==1
                    j_vec = j_vec*ones(size(i_vec));
                end
                
                for m = 1:1:length(i_vec)
                    bg.link_cyl_off(i_vec(m),j_vec(m))
                end
            end
        end
        function [i,j] = get_cyl_ij(bg,h)
            % GET_CYL_IJ order number of brain regions linked via corresponding cylinder
            %
            % [I,J] = GET_CYL_IJ(BG,H) returns the order number of the brain regions
            %   connected via the cylinder with handle H.
            %
            % See also PlotBrainGraph.
            
            i = NaN;
            j = NaN;
            if ~isempty(h)
                for m = 1:1:bg.atlas.length()
                    for n = 1:1:bg.atlas.length()
                        if h==bg.cyls.h(m,n)
                            i = m;
                            j = n;
                        end
                    end
                end
            end
        end
        function [br_i, br_j] = get_cyl_br(bg,h)
            % GET_CYL_BR properties of brain regions linked via corresponding cylinder
            %
            % [BR_I,BR_J] = GET_CYL_BR(BG,H) returns the properties of the brain regions
            %   BR_I and BR_J connected via the cylinder with handle H.
            %
            % See also PlotBrainGraph.
            
            [i,j] = bg.get_cyl_ij(h);
            br_i = bg.atlas.get(i);
            br_j = bg.atlas.get(j);
        end
        function link_cyls_settings(bg,m_vec,k_vec,varargin)
            % LINK_CYLS_SETTINGS sets cylinders' properties
            %
            % LINK_CYLS_SETTINGS(BG) allows the user to interractively
            %   change the cylinders settings via a graphical user interface.
            %
            % LINK_CYLS_SETTINGS(BG,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotBrainGraph.
            
            data = cell(bg.atlas.length(),bg.atlas.length());
            
            if nargin<2 || isempty(m_vec) || isempty(k_vec)
                m_vec = 1:1:bg.atlas.length();
                k_vec = 1:1:bg.atlas.length();
            end
            if length(m_vec)==1
                m_vec = m_vec*ones(size(k_vec));
            end
            if length(k_vec)==1
                k_vec = k_vec*ones(size(m_vec));
            end
            for p = 1:1:length(m_vec)
                    if m_vec(p) ~= k_vec(p)
                        data{m_vec(p),k_vec(p)} = true;
                    else
                        data{m_vec(p),k_vec(p)} = false;
                    end
            end
            
            set_color = bg.INIT_CYL_COLOR;
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Brain Graph Cylinders Settings';
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'figposition'
                        FigPosition = varargin{n+1};
                    case 'figcolor'
                        FigColor = varargin{n+1};
                    case 'figname'
                        FigName = varargin{n+1};
                end
            end
            
            % create a figure
            if isempty(bg.f_cyls_settings) || ~ishandle(bg.f_cyls_settings)
                bg.f_cyls_settings = figure('Visible','off');
            end
            f = bg.f_cyls_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            ui_table = uitable(f);
            GUI.setUnits(ui_table)
            set(ui_table,'BackgroundColor',GUI.TABBKGCOLOR)
            set(ui_table,'Position',[.03 .215 .54 .71])
            set(ui_table,'ColumnName',bg.atlas.getProps(BrainRegion.LABEL))
            set(ui_table,'ColumnWidth',{40})
            set(ui_table,'RowName',bg.atlas.getProps(BrainRegion.LABEL))
            [string{1:bg.atlas.length()}] = deal('logical');
            set(ui_table,'ColumnFormat',string)
            set(ui_table,'ColumnEditable',true)
            set(ui_table,'Data',data)
            set(ui_table,'CellEditCallback',{@cb_table_edit});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.60 .825 .18 .10])
            set(ui_button_show,'String','Show cyls')
            set(ui_button_show,'TooltipString','Show selected arrows')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.80 .825 .18 .10])
            set(ui_button_hide,'String','Hide cyls')
            set(ui_button_hide,'TooltipString','Hide selected arrows')
            set(ui_button_hide,'Callback',{@cb_hide})
                       
            ui_text_cylradius = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_cylradius)
            GUI.setBackgroundColor(ui_text_cylradius)
            set(ui_text_cylradius,'Position',[.60 .520 .18 .10])
            set(ui_text_cylradius,'String','Cylinder radius ')
            set(ui_text_cylradius,'HorizontalAlignment','left')
            set(ui_text_cylradius,'FontWeight','bold')
            
            ui_edit_cylradius = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_cylradius)
            GUI.setBackgroundColor(ui_edit_cylradius)
            set(ui_edit_cylradius,'Position',[.80 .515 .18 .10])
            set(ui_edit_cylradius,'HorizontalAlignment','center')
            set(ui_edit_cylradius,'FontWeight','bold')
            set(ui_edit_cylradius,'String','0.1')
            set(ui_edit_cylradius,'Callback',{@cb_cylradius})
            
            ui_button_cylcolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_cylcolor)
            GUI.setBackgroundColor(ui_button_cylcolor)
            set(ui_button_cylcolor,'ForegroundColor',set_color)
            set(ui_button_cylcolor,'Position',[.62 .075 .35 .10])
            set(ui_button_cylcolor,'String','Link Color')
            set(ui_button_cylcolor,'TooltipString','Select line color')
            set(ui_button_cylcolor,'Callback',{@cb_cylcolor})
            
            ui_button_clearselection = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_clearselection)
            GUI.setBackgroundColor(ui_button_clearselection)
            set(ui_button_clearselection,'Position',[.03 .075 .54 .10])
            set(ui_button_clearselection,'String','Clear Selection')
            set(ui_button_clearselection,'TooltipString','Clear selected links')
            set(ui_button_clearselection,'Callback',{@cb_clearselection})
            
            function cb_table_edit(~,event)  % (src,event)
                i = event.Indices(1);
                j = event.Indices(2);
                
                if i~=j
                    if data{i,j} == true
                        data{i,j} = false;
                    else
                        data{i,j} = true;
                    end
                    set(ui_table,'Data',data)
                end
            end
            function update_link_cyls()
                radius = real(str2num(get(ui_edit_cylradius,'String')));
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_cyls(i,j,'R',radius,...
                            'Color',set_color);
                    end
                end
            end
            function cb_show(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        update_link_cyls()
                        bg.link_cyls_on(i,j)
                    end
                end
            end
            function cb_hide(~,~)  % (src,event)
                indices = find(~cellfun(@isempty,data));
                
                for m = 1:1:length(indices)
                    if data{indices(m)}==1
                        [i,j] = ind2sub(size(data),indices(m));
                        bg.link_cyls_off(i,j)
                    end
                end
            end
            function cb_cylradius(~,~)  % (src,event)
                radius = real(str2num(get(ui_edit_cylradius,'String')));
                
                if isempty(radius) || radius<=0
                    set(ui_edit_cylradius,'String','0.1')
                    radius = 3;
                end
                update_link_cyls()
            end
            function cb_cylcolor(~,~)  % (src,event)
                set_color_prev = get(ui_button_cylcolor,'ForegroundColor');
                set_color = uisetcolor();               
                if length(set_color)==3
                    set(ui_button_cylcolor,'ForegroundColor',set_color)
                    update_link_cyls()
                else 
                    set_color = set_color_prev;
                end
            end
            function cb_clearselection(~,~)  % (src,event)
                [data{:}] = deal(zeros(1));
                set(ui_table,'Data',data)
            end
            set(f,'Visible','on')
        end
    end
end