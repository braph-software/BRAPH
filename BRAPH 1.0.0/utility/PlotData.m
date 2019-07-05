classdef PlotData < List
    % PlotData < List : Plot of a data of elements in a list
    %   PlotData manages and plots the data of elements in a list.
    %   Each element data can be plotted by using symbols and lines.
    %
    % PlotData properties (Constants):
    %   NAME                  -   name numeric code
    %   NAME_TAG              -   name tag
    %   NAME_FORMAT           -   name format
    %   NAME_DEFAULT          -   name default value
    %
    %   XLABEL                -   xlabel numeric code
    %   XLABEL_TAG            -   xlabel tag
    %   XLABEL_FORMAT         -   xlabel format
    %   XLABEL_DEFAULT        -   xlabel default value
    %
    %   YLABEL                -   ylabel numeric code
    %   YLABEL_TAG            -   ylabel tag
    %   YLABEL_FORMAT         -   ylabel format
    %   YLABEL_DEFAULT        -   ylabel default value
    %
    % PlotData properties (Access = protected):
    %   props                 -   cell array of object properties < ListElement
    %   elements              -   cell array of list elements < List
    %   path                  -   XML file path < List
    %   file                  -   XML file name < List
    %   h_axes                -   handle for the axes
    %   f_settings            -   settings figure handle
    %
    % PlotData methods (Access = protected):
    %   PlotData              -   constructor
    %   setProp               -   sets property value < ListElement
    %   getProp               -   gets property value, format and tag < ListElement
    %   getPropValue          -   string of property value < ListElement
    %   getPropFormat         -   string of property format < ListElement
    %   getPropTag            -   string of property tag < ListElement
    %   fullfile              -   builds XML file name < List
    %   length                -   list length < List
    %   get                   -   gets element < List
    %   getProps              -   get a property from all elements of the list < List
    %   add                   -   adds element < List
    %   remove                -   removes element < List
    %   replace               -   replaces element < List
    %   invert                -   inverts two elements < List
    %   moveto                -   moves element < List
    %   removeall             -   removes selected elements < List
    %   addabove              -   adds empty elements above selected ones < List
    %   addbelow              -   adds empty elements below selected ones < List
    %   moveup                -   moves up selected elements < List
    %   movedown              -   moves down selected elements < List
    %   move2top              -   moves selected elements to top < List
    %   move2bottom           -   moves selected elements to bottom < List
    %   toXML                 -   creates XML Node from List < List
    %   fromXML               -   loads List from XML Node < List
    %   load                  -   load < List
    %   loadfromfile          -   loads List from XML file < List
    %   save                  -   save < List
    %   savetofile            -   saves a list to XML file < List
    %   clear                 -   clears list < List
    %   disp                  -   displays plot data list
    %   plot_single_data      -   plots the data of a single element
    %   data_on               -   shows the data plot of single element
    %   data_off              -   hides the data plot of single element
    %   plot                  -   plots the data of multiple elements
    %   plot_on               -   shows the data plot of multiple elements
    %   plot_off              -   hides the data plot of multiple elements
    %   set_axes              -   sets current axes
    %   get_axes              -   gets current axes
    %   hold_on               -   hold on
    %   hold_off              -   hold off
    %   grid_on               -   grid on
    %   grid_off              -   grid off
    %   axis_on               -   axis on
    %   axis_off              -   axis off
    %   axis_equal            -   axis equal
    %   axis_tight            -   axis tight
    %   set_legend            -   sets plot legend
    %   set_labels            -   sets plot labels
    %   set_title             -   sets plot title
    %   get_pde_i             -   order number of list element corresponding to a plot
    %   get_pde               -   properties of list element corresponding to a plot
    %   plot_settings         -   sets plot's properties
    %
    % PlotData methods (Static):
    %   cleanXML              -   removes whitespace nodes from xmlread < ListElement
    %   propnumber            -   number of properties
    %   getTags               -   cell array of strings with the tags of the properties
    %   getFormats            -   cell array with the formats of the properties
    %   getDefaults           -   cell array with the defaults of the properties
    %   getOptions            -   MRICohortcell array with options (only for properties with options format)ys multiple brain regions as spheres
    %   elementClass          -   element class name
    %   element               -   creates new empty element
    %
    % See also List, ListElement, PlotDataElement.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % cohort name
        NAME = 1
        NAME_TAG = 'name'
        NAME_FORMAT = BNC.CHAR
        NAME_DEFAULT = 'plot data object'
        
        % x label
        XLABEL = 2
        XLABEL_TAG = 'xlabel'
        XLABEL_FORMAT = BNC.CHAR
        XLABEL_DEFAULT = 'X Label [a.u.]'
        
        % y label
        YLABEL = 3
        YLABEL_TAG = 'ylabel'
        YLABEL_FORMAT = BNC.CHAR
        YLABEL_DEFAULT = 'Y Label [a.u.]'
        
        % font size
        FONT_SIZE = 4
        FONT_SIZE_TAG = 'fontsize'
        FONT_SIZE_FORMAT = BNC.NUMERIC
        FONT_SIZE_DEFAULT = 12
        
        % font type
        FONT_TYPE = 5
        FONT_TYPE_TAG = 'fonttype'
        FONT_TYPE_FORMAT = BNC.OPTIONS
        FONT_TYPE_OPTIONS = GUI.FONT_TYPE_TAG
        FONT_TYPE_DEFAULT = GUI.FONT_TYPE_TAG{1}
        
        % font weight
        FONT_WEIGHT = 6
        FONT_WEIGHT_TAG = 'fontweight'
        FONT_WEIGHT_FORMAT = BNC.OPTIONS
        FONT_WEIGHT_OPTIONS = GUI.FONT_WEIGHT_TAG
        FONT_WEIGHT_DEFAULT = GUI.FONT_WEIGHT_TAG{1}
        
        % font interpreter
        FONT_INTERPRETER = 7
        FONT_INTERPRETER_TAG = 'interpreter'
        FONT_INTERPRETER_FORMAT = BNC.OPTIONS
        FONT_INTERPRETER_OPTIONS = GUI.FONT_INTERPRETER_TAG
        FONT_INTERPRETER_DEFAULT = GUI.FONT_INTERPRETER_TAG{1}
        
        % font color
        FONT_COLOR = 8
        FONT_COLOR_TAG = 'fontcolor'
        FONT_COLOR_FORMAT = BNC.NUMERIC
        FONT_COLOR_DEFAULT = [0 0 0]
        
    end
    properties (Access = protected)
        h_axes  % handle for the axes
        f_settings  % settings figure handle
        f_high_settings  % settings high value plot
        f_low_settings  % settings low value plot
        f_mid_settings  % settings mid valueplot
        f_area_settings  % settings area plot
    end
    methods (Access = protected)
        function cp = copyElement(pd)
            % COPYELEMENT makes a deep copy of the list.
            %
            % CP = COPYELEMENT(List) makes a deep copy of the list.
            %
            % See also List, matlab.mixin.Copyable, copy, handle.
            
            % Make a deep copy
            cp = copyElement@List(pd);
            % resets the graphic handles
            cp.h_axes = NaN;
            cp.f_settings = NaN;
            cp.f_high_settings = NaN;
            cp.f_low_settings = NaN;
            cp.f_mid_settings = NaN;
            cp.f_area_settings = NaN;
        end
    end
    methods
        function pd = PlotData(plot_elements,varargin)
            % PlotData() plots and manages the data of a list of elements.
            %   The data can be plotted by using symbols and lines and their
            %   various properties can be set.
            %
            % See also PlotData.
            
            if nargin==0 || isempty(plot_elements)
                plot_elements = {};
            end
            
            pd = pd@List(plot_elements,varargin{:});
        end
        function disp(pd)
            % DISP displays plot data list
            %
            % DISP(PD) displays the plot data list PD and the properties of its
            %   elements on the command line.
            %
            % See also PlotData, List.
            
            pd.disp@List()
            disp(' >> PLOT ELEMENTS << ')
            for i = 1:1:pd.length()
                pe = pd.get(i);
                if isa(pe,'PlotDataArea')
                    disp([pe.getPropValue(PlotDataArea.CODE) ...
                        ' X=[' num2str(size(pe.getPropValue(PlotDataArea.X),1)) 'x' num2str(size(pe.getPropValue(PlotDataArea.X),2)) ']' ...
                        ' Y_HIGH=[' num2str(size(pe.getProp(PlotDataArea.Y_HIGH),1)) 'x' num2str(size(pe.getProp(PlotDataArea.Y_HIGH),2)) ']' ...
                        ' Y_LOW=[' num2str(size(pe.getProp(PlotDataArea.Y_LOW),1)) 'x' num2str(size(pe.getProp(PlotDataArea.Y_LOW),2)) ']' ...
                        ' Y_MID=[' num2str(size(pe.getProp(PlotDataArea.Y_MID),1)) 'x' num2str(size(pe.getProp(PlotDataArea.Y_MID),2)) ']' ...
                        ' ' pe.getPropValue(PlotDataArea.NOTES) ...
                        ])
                elseif isa(pe,'PlotDataElement')
                    disp([pe.getPropValue(PlotDataElement.CODE) ...
                        ' X=[' num2str(size(pe.getProp(PlotDataElement.X),1)) 'x' num2str(size(pe.getProp(PlotDataElement.X),2)) ']' ...
                        ' Y=[' num2str(size(pe.getProp(PlotDataElement.Y),1)) 'x' num2str(size(pe.getProp(PlotDataElement.Y),2)) ']' ...
                        ' ' pe.getPropValue(PlotDataElement.NOTES) ...
                        ])                    
                end
            end
        end
        
        function h_data = plot_single_data(pd,i,varargin)
            % PLOT_SINGLE_DATA plots the data of a single element
            %
            % PLOT_SINGLE_DATA(PD,I) plots the data of the element I as a symbol, if not plotted.
            %
            % H_PL = PLOT_SINGLE_DATA(PD,I) returns the handle to the symbol denoting the element I.
            %
            % PLOT_SINGLE_DATA(PD,I,'PropertyName',PropertyValue) sets the property
            %   of the symbol's PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            pd.set_axes()
            pd.hold_on()

            pde = pd.get(i);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'x'
                        pde.setProp(PlotDataArea.X,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'y'
                        pde.setProp(PlotDataArea.Y,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'marker'
                        pde.setProp(PlotDataArea.SYM_MARKER,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markersize'
                        pde.setProp(PlotDataArea.SYM_SIZE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markercolor'
                        pde.setProp(PlotDataArea.SYM_FACE_COLOR,varargin{n+1})
                        pde.setProp(PlotDataArea.SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markerfacecolor'
                        pde.setProp(PlotDataArea.SYM_FACE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markeredgecolor'
                        pde.setProp(PlotDataArea.SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linestyle'
                        pde.setProp(PlotDataArea.LIN_STYLE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linewidth'
                        pde.setProp(PlotDataArea.LIN_WIDTH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linecolor'
                        pde.setProp(PlotDataArea.LIN_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                end
            end
                        
            % gets properties
            h_data = pde.getDataHandle();
            X = pde.getProp(PlotDataElement.X);
            Y = pde.getProp(PlotDataElement.Y);
            SYM_MARKER = pde.getProp(PlotDataElement.SYM_MARKER);
            SYM_SIZE = pde.getProp(PlotDataElement.SYM_SIZE);
            SYM_EDGE_COLOR = pde.getProp(PlotDataElement.SYM_EDGE_COLOR);
            SYM_FACE_COLOR = pde.getProp(PlotDataElement.SYM_FACE_COLOR);
            LIN_STYLE = pde.getProp(PlotDataElement.LIN_STYLE);
            LIN_WIDTH = pde.getProp(PlotDataElement.LIN_WIDTH);
            LIN_COLOR = pde.getProp(PlotDataElement.LIN_COLOR);
            
            % plots
            if ~ishandle(h_data)
                h_data = plot( ...
                    pd.get_axes(), ...
                    X, ...
                    Y, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
                pde.setDataHandle(h_data)
            else
                set(h_data, ...
                    'XData',X, ...
                	'YData',Y, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
            end
            
            varargin = varargin(~cellfun(@isempty, varargin));
            for n = 1:2:length(varargin)
                set(h_data,varargin{n},varargin{n+1})
            end
            
            % output if needed
            if nargout>0
                h_data = pde.getDataHandle();
            end
        end
        function plot_single_data_on(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_data = pde.getDataHandle();
            if  ishandle(h_data)
                set(h_data,'Visible','on')
            end
            pde.setDataHandle(h_data)
        end
        function plot_single_data_off(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_data = pde.getDataHandle();
            if  ishandle(h_data)
                set(h_data,'Visible','off')
            end
            pde.setDataHandle(h_data)
        end
        function plot_data(pd,i_vec,varargin)
            % PLOT plots the data of multiple elements
            %
            % PLOT(PD,I_VEC) plots the data of the elements specified in
            %   I_VEC as symbols, if not plotted.
            %
            % PLOT(PD,[]) plots the data plot of all elements contained in the
            %   list PD.
            %
            % PLOT(PD,I_VEC,'PropertyName',PropertyValue) sets the property
            %   of multiple symbols' PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'marker'
                        Marker = varargin{n+1};
                        nmarker = n+1;
                    case 'markersize'
                        Size = varargin{n+1};
                        nsize = n+1;
                    case 'markercolor'
                        MarkerColor = varargin{n+1};
                        nmarkercolor = n+1;
                    case 'markerfacecolor'
                        MarkerFaceColor = varargin{n+1};
                        nmarkerfacecolor = n+1;
                    case 'markeredgecolor'
                        MarkerEdgeColor = varargin{n+1};
                        nmarkeredgecolor = n+1;
                    case 'slinetyle'
                        Style = varargin{n+1};
                        nstyle = n+1;
                    case 'linewidth'
                        Width = varargin{n+1};
                        nwidth = n+1;
                    case 'linecolor'
                        Color = varargin{n+1};
                        ncolor = n+1;
                end
            end
            
            for m = 1:1:length(i_vec)
                if exist('Marker','var') && numel(Marker)==length(i_vec)
                    varargin{nmarker} = Marker(m);
                end
                if exist('Style','var') && numel(Style)==length(i_vec)
                    varargin{nstyle} = Style(m);
                end
                if exist('MarkerEdgeColor','var') && size(MarkerEdgeColor,1)==length(i_vec) && size(MarkerEdgeColor,2)==3
                    varargin{nmarkeredgecolor} = MarkerEdgeColor(m,:);
                end
                if exist('MarkerFaceColor','var') && size(MarkerFaceColor,1)==length(i_vec) && size(MarkerFaceColor,2)==3
                    varargin{nmarkerfacecolor} = MarkerFaceColor(m,:);
                end
                if exist('Color','var') && size(Color,1)==length(i_vec) && size(Color,2)==3
                    varargin{ncolor} = Color(m,:);
                end
                if exist('MarkerColor','var') && size(MarkerColor,1)==length(i_vec) && size(MarkerColor,2)==3
                    varargin{nmarkercolor} = MarkerColor(m,:);
                end
                if exist('Size','var') && numel(Size)==length(i_vec)
                    varargin{nsize} = Size(m);
                end
                if exist('Width','var') && numel(Width)==length(i_vec)
                    varargin{nwidth} = Width(m);
                end
                
                pd.plot_single_data(i_vec(m),varargin{:});
            end
        end
        function plot_data_on(pd,i_vec)
            % PLOT_DATA_ON shows the data plot of multiple elements
            %
            % PLOT_DATA_ON(PD,I_VEC) shows the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_ON(PD,[]) shows the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_data_on(i_vec(m))
            end
        end
        function plot_data_off(pd,i_vec)
            % PLOT_DATA_OFF hides the data plot of multiple elements
            %
            % PLOT_DATA_OFF(PD,I_VEC) hides the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_OFF(PD,[]) hides the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_data_off(i_vec(m))
            end
        end
        
        function h_high = plot_single_high(pd,i,varargin)
            % PLOT_SINGLE_DATA plots the data of a single element
            %
            % PLOT_SINGLE_DATA(PD,I) plots the data of the element I as a symbol, if not plotted.
            %
            % H_PL = PLOT_SINGLE_DATA(PD,I) returns the handle to the symbol denoting the element I.
            %
            % PLOT_SINGLE_DATA(PD,I,'PropertyName',PropertyValue) sets the property
            %   of the symbol's PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            pd.set_axes()
            pd.hold_on()
            
            pde = pd.get(i);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'x'
                        pde.setProp(PlotDataArea.X,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'y_high'
                        pde.setProp(PlotDataArea.Y_HIGH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'marker'
                        pde.setProp(PlotDataArea.HIGH_SYM_MARKER,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markersize'
                        pde.setProp(PlotDataArea.HIGH_SYM_SIZE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markercolor'
                        pde.setProp(PlotDataArea.HIGH_SYM_FACE_COLOR,varargin{n+1})
                        pde.setProp(PlotDataArea.HIGH_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markerfacecolor'
                        pde.setProp(PlotDataArea.HIGH_SYM_FACE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markeredgecolor'
                        pde.setProp(PlotDataArea.HIGH_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linestyle'
                        pde.setProp(PlotDataArea.HIGH_LIN_STYLE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linewidth'
                        pde.setProp(PlotDataArea.HIGH_LIN_WIDTH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linecolor'
                        pde.setProp(PlotDataArea.HIGH_LIN_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                end
            end
                        
            % gets properties
            h_high = pde.getYHighHandle();
            X = pde.getProp(PlotDataArea.X);
            Y_HIGH = pde.getProp(PlotDataArea.Y_HIGH);
            SYM_MARKER = pde.getProp(PlotDataArea.HIGH_SYM_MARKER);
            SYM_SIZE = pde.getProp(PlotDataArea.HIGH_SYM_SIZE);
            SYM_EDGE_COLOR = pde.getProp(PlotDataArea.HIGH_SYM_EDGE_COLOR);
            SYM_FACE_COLOR = pde.getProp(PlotDataArea.HIGH_SYM_FACE_COLOR);
            LIN_STYLE = pde.getProp(PlotDataArea.HIGH_LIN_STYLE);
            LIN_WIDTH = pde.getProp(PlotDataArea.HIGH_LIN_WIDTH);
            LIN_COLOR = pde.getProp(PlotDataArea.HIGH_LIN_COLOR);
            
            % plots
            if ~ishandle(h_high)
                h_high = plot( ...
                    pd.get_axes(), ...
                    X, ...
                    Y_HIGH, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
                pde.setYHighHandle(h_high)
            else
                set(h_high, ...
                    'XData',X, ...
                	'YData',Y_HIGH, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
            end
            
            varargin = varargin(~cellfun(@isempty, varargin));
            for n = 1:2:length(varargin)
                set(h_high,varargin{n},varargin{n+1})
            end
            
            % output if needed
            if nargout>0
                h_high = pde.getYHighHandle();
            end
        end
        function plot_single_high_on(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_high = pde.getYHighHandle();
            if  ishandle(h_high)
                set(h_high,'Visible','on')
            end
            pde.setYHighHandle(h_high)
        end
        function plot_single_high_off(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_up = pde.getYHighHandle();
            if  ishandle(h_up)
                set(h_up,'Visible','off')
            end
            pde.setYHighHandle(h_up)
        end
        function plot_high(pd,i_vec,varargin)
            % PLOT plots the data of multiple elements
            %
            % PLOT(PD,I_VEC) plots the data of the elements specified in
            %   I_VEC as symbols, if not plotted.
            %
            % PLOT(PD,[]) plots the data plot of all elements contained in the
            %   list PD.
            %
            % PLOT(PD,I_VEC,'PropertyName',PropertyValue) sets the property
            %   of multiple symbols' PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'marker'
                        Marker = varargin{n+1};
                        nmarker = n+1;
                    case 'markersize'
                        Size = varargin{n+1};
                        nsize = n+1;
                    case 'markercolor'
                        MarkerColor = varargin{n+1};
                        nmarkercolor = n+1;
                    case 'markerfacecolor'
                        MarkerFaceColor = varargin{n+1};
                        nmarkerfacecolor = n+1;
                    case 'markeredgecolor'
                        MarkerEdgeColor = varargin{n+1};
                        nmarkeredgecolor = n+1;
                    case 'slinetyle'
                        Style = varargin{n+1};
                        nstyle = n+1;
                    case 'linewidth'
                        Width = varargin{n+1};
                        nwidth = n+1;
                    case 'linecolor'
                        Color = varargin{n+1};
                        ncolor = n+1;
                end
            end
            
            for m = 1:1:length(i_vec)
                if exist('Marker','var') && numel(Marker)==length(i_vec)
                    varargin{nmarker} = Marker(m);
                end
                if exist('Style','var') && numel(Style)==length(i_vec)
                    varargin{nstyle} = Style(m);
                end
                if exist('MarkerEdgeColor','var') && size(MarkerEdgeColor,1)==length(i_vec) && size(MarkerEdgeColor,2)==3
                    varargin{nmarkeredgecolor} = MarkerEdgeColor(m,:);
                end
                if exist('MarkerFaceColor','var') && size(MarkerFaceColor,1)==length(i_vec) && size(MarkerFaceColor,2)==3
                    varargin{nmarkerfacecolor} = MarkerFaceColor(m,:);
                end
                if exist('Color','var') && size(Color,1)==length(i_vec) && size(Color,2)==3
                    varargin{ncolor} = Color(m,:);
                end
                if exist('MarkerColor','var') && size(MarkerColor,1)==length(i_vec) && size(MarkerColor,2)==3
                    varargin{nmarkercolor} = MarkerColor(m,:);
                end
                if exist('Size','var') && numel(Size)==length(i_vec)
                    varargin{nsize} = Size(m);
                end
                if exist('Width','var') && numel(Width)==length(i_vec)
                    varargin{nwidth} = Width(m);
                end
                
                pd.plot_single_high(i_vec(m),varargin{:});
            end
        end
        function plot_high_on(pd,i_vec)
            % PLOT_DATA_ON shows the data plot of multiple elements
            %
            % PLOT_DATA_ON(PD,I_VEC) shows the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_ON(PD,[]) shows the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_high_on(i_vec(m))
            end
        end
        function plot_high_off(pd,i_vec)
            % PLOT_DATA_OFF hides the data plot of multiple elements
            %
            % PLOT_DATA_OFF(PD,I_VEC) hides the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_OFF(PD,[]) hides the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_high_off(i_vec(m))
            end
        end
        
        function h_low = plot_single_low(pd,i,varargin)
            % PLOT_SINGLE_DATA plots the data of a single element
            %
            % PLOT_SINGLE_DATA(PD,I) plots the data of the element I as a symbol, if not plotted.
            %
            % H_PL = PLOT_SINGLE_DATA(PD,I) returns the handle to the symbol denoting the element I.
            %
            % PLOT_SINGLE_DATA(PD,I,'PropertyName',PropertyValue) sets the property
            %   of the symbol's PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            pd.set_axes()
            pd.hold_on()
            
            pde = pd.get(i);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'x'
                        pde.setProp(PlotDataArea.X,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'y_low'
                        pde.setProp(PlotDataArea.Y_LOW,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'marker'
                        pde.setProp(PlotDataArea.LOW_SYM_MARKER,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markersize'
                        pde.setProp(PlotDataArea.LOW_SYM_SIZE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markercolor'
                        pde.setProp(PlotDataArea.LOW_SYM_FACE_COLOR,varargin{n+1})
                        pde.setProp(PlotDataArea.LOW_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markerfacecolor'
                        pde.setProp(PlotDataArea.LOW_SYM_FACE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markeredgecolor'
                        pde.setProp(PlotDataArea.LOW_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linestyle'
                        pde.setProp(PlotDataArea.LOW_LIN_STYLE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linewidth'
                        pde.setProp(PlotDataArea.LOW_LIN_WIDTH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linecolor'
                        pde.setProp(PlotDataArea.LOW_LIN_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                end
            end
            
            % gets properties
            h_low = pde.getYLowHandle();
            X = pde.getProp(PlotDataArea.X);
            Y_LOW = pde.getProp(PlotDataArea.Y_LOW);
            SYM_MARKER = pde.getProp(PlotDataArea.LOW_SYM_MARKER);
            SYM_SIZE = pde.getProp(PlotDataArea.LOW_SYM_SIZE);
            SYM_EDGE_COLOR = pde.getProp(PlotDataArea.LOW_SYM_EDGE_COLOR);
            SYM_FACE_COLOR = pde.getProp(PlotDataArea.LOW_SYM_FACE_COLOR);
            LIN_STYLE = pde.getProp(PlotDataArea.LOW_LIN_STYLE);
            LIN_WIDTH = pde.getProp(PlotDataArea.LOW_LIN_WIDTH);
            LIN_COLOR = pde.getProp(PlotDataArea.LOW_LIN_COLOR);
            
            % plots
            if ~ishandle(h_low)
                h_low = plot( ...
                    pd.get_axes(), ...
                    X, ...
                    Y_LOW, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
                pde.setYLowHandle(h_low)
            else
                set(h_low, ...
                    'XData',X, ...
                    'YData',Y_LOW, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
            end
            
            varargin = varargin(~cellfun(@isempty, varargin));
            for n = 1:2:length(varargin)
                set(h_low,varargin{n},varargin{n+1})
            end
            
            % output if needed
            if nargout>0
                h_low = pde.getYLowHandle();
            end
        end
        function plot_single_low_on(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_low = pde.getYLowHandle();
            if  ishandle(h_low)
                set(h_low,'Visible','on')
            end
            pde.setYLowHandle(h_low)
        end
        function plot_single_low_off(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_low = pde.getYLowHandle();
            if  ishandle(h_low)
                set(h_low,'Visible','off')
            end
            pde.setYLowHandle(h_low)
        end
        function plot_low(pd,i_vec,varargin)
            % PLOT plots the data of multiple elements
            %
            % PLOT(PD,I_VEC) plots the data of the elements specified in
            %   I_VEC as symbols, if not plotted.
            %
            % PLOT(PD,[]) plots the data plot of all elements contained in the
            %   list PD.
            %
            % PLOT(PD,I_VEC,'PropertyName',PropertyValue) sets the property
            %   of multiple symbols' PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'marker'
                        Marker = varargin{n+1};
                        nmarker = n+1;
                    case 'markersize'
                        Size = varargin{n+1};
                        nsize = n+1;
                    case 'markercolor'
                        MarkerColor = varargin{n+1};
                        nmarkercolor = n+1;
                    case 'markerfacecolor'
                        MarkerFaceColor = varargin{n+1};
                        nmarkerfacecolor = n+1;
                    case 'markeredgecolor'
                        MarkerEdgeColor = varargin{n+1};
                        nmarkeredgecolor = n+1;
                    case 'slinetyle'
                        Style = varargin{n+1};
                        nstyle = n+1;
                    case 'linewidth'
                        Width = varargin{n+1};
                        nwidth = n+1;
                    case 'linecolor'
                        Color = varargin{n+1};
                        ncolor = n+1;
                end
            end
            
            for m = 1:1:length(i_vec)
                if exist('Marker','var') && numel(Marker)==length(i_vec)
                    varargin{nmarker} = Marker(m);
                end
                if exist('Style','var') && numel(Style)==length(i_vec)
                    varargin{nstyle} = Style(m);
                end
                if exist('MarkerEdgeColor','var') && size(MarkerEdgeColor,1)==length(i_vec) && size(MarkerEdgeColor,2)==3
                    varargin{nmarkeredgecolor} = MarkerEdgeColor(m,:);
                end
                if exist('MarkerFaceColor','var') && size(MarkerFaceColor,1)==length(i_vec) && size(MarkerFaceColor,2)==3
                    varargin{nmarkerfacecolor} = MarkerFaceColor(m,:);
                end
                if exist('Color','var') && size(Color,1)==length(i_vec) && size(Color,2)==3
                    varargin{ncolor} = Color(m,:);
                end
                if exist('MarkerColor','var') && size(MarkerColor,1)==length(i_vec) && size(MarkerColor,2)==3
                    varargin{nmarkercolor} = MarkerColor(m,:);
                end
                if exist('Size','var') && numel(Size)==length(i_vec)
                    varargin{nsize} = Size(m);
                end
                if exist('Width','var') && numel(Width)==length(i_vec)
                    varargin{nwidth} = Width(m);
                end
                
                pd.plot_single_low(i_vec(m),varargin{:});
            end
        end
        function plot_low_on(pd,i_vec)
            % PLOT_DATA_ON shows the data plot of multiple elements
            %
            % PLOT_DATA_ON(PD,I_VEC) shows the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_ON(PD,[]) shows the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_low_on(i_vec(m))
            end
        end
        function plot_low_off(pd,i_vec)
            % PLOT_DATA_OFF hides the data plot of multiple elements
            %
            % PLOT_DATA_OFF(PD,I_VEC) hides the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_OFF(PD,[]) hides the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_low_off(i_vec(m))
            end
        end
        
        function h_mid = plot_single_mid(pd,i,varargin)
            % PLOT_SINGLE_DATA plots the data of a single element
            %
            % PLOT_SINGLE_DATA(PD,I) plots the data of the element I as a symbol, if not plotted.
            %
            % H_PL = PLOT_SINGLE_DATA(PD,I) returns the handle to the symbol denoting the element I.
            %
            % PLOT_SINGLE_DATA(PD,I,'PropertyName',PropertyValue) sets the property
            %   of the symbol's PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            pd.set_axes()
            pd.hold_on()
            
            pde = pd.get(i);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'x'
                        pde.setProp(PlotDataArea.X,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'y_mid'
                        pde.setProp(PlotDataArea.Y_MID,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'marker'
                        pde.setProp(PlotDataArea.MID_SYM_MARKER,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markersize'
                        pde.setProp(PlotDataArea.MID_SYM_SIZE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markercolor'
                        pde.setProp(PlotDataArea.MID_SYM_FACE_COLOR,varargin{n+1})
                        pde.setProp(PlotDataArea.MID_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markerfacecolor'
                        pde.setProp(PlotDataArea.MID_SYM_FACE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'markeredgecolor'
                        pde.setProp(PlotDataArea.MID_SYM_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linestyle'
                        pde.setProp(PlotDataArea.MID_LIN_STYLE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linewidth'
                        pde.setProp(PlotDataArea.MID_LIN_WIDTH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'linecolor'
                        pde.setProp(PlotDataArea.MID_LIN_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                end
            end
            
            % gets properties
            h_mid = pde.getYMidHandle();
            X = pde.getProp(PlotDataArea.X);
            Y_MID = pde.getProp(PlotDataArea.Y_MID);
            SYM_MARKER = pde.getProp(PlotDataArea.MID_SYM_MARKER);
            SYM_SIZE = pde.getProp(PlotDataArea.MID_SYM_SIZE);
            SYM_EDGE_COLOR = pde.getProp(PlotDataArea.MID_SYM_EDGE_COLOR);
            SYM_FACE_COLOR = pde.getProp(PlotDataArea.MID_SYM_FACE_COLOR);
            LIN_STYLE = pde.getProp(PlotDataArea.MID_LIN_STYLE);
            LIN_WIDTH = pde.getProp(PlotDataArea.MID_LIN_WIDTH);
            LIN_COLOR = pde.getProp(PlotDataArea.MID_LIN_COLOR);

            % plots
            if ~ishandle(h_mid)
                h_mid = plot( ...
                    pd.get_axes(), ...
                    X, ...
                    Y_MID, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);
                pde.setYMidHandle(h_mid)
            else
                set(h_mid, ...
                    'XData',X, ...
                    'YData',Y_MID, ...
                    'Marker',SYM_MARKER, ...
                    'MarkerSize',SYM_SIZE, ...
                    'MarkerEdgeColor',SYM_EDGE_COLOR, ...
                    'MarkerFaceColor',SYM_FACE_COLOR, ...
                    'LineStyle',LIN_STYLE, ...
                    'LineWidth',LIN_WIDTH, ...
                    'Color',LIN_COLOR);                    
            end
            
            varargin = varargin(~cellfun(@isempty, varargin));
            for n = 1:2:length(varargin)
                set(h_mid,varargin{n},varargin{n+1})
            end
            
            % output if needed
            if nargout>0
                h_mid = pde.getYMidHandle();
            end
        end
        function plot_single_mid_on(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_mid = pde.getYMidHandle();
            if  ishandle(h_mid)
                set(h_mid,'Visible','on')
            end
            pde.setYMidHandle(h_mid)
        end
        function plot_single_mid_off(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_mid = pde.getYMidHandle();
            if  ishandle(h_mid)
                set(h_mid,'Visible','off')
            end
            pde.setYMidHandle(h_mid)
        end
        function plot_mid(pd,i_vec,varargin)
            % PLOT plots the data of multiple elements
            %
            % PLOT(PD,I_VEC) plots the data of the elements specified in
            %   I_VEC as symbols, if not plotted.
            %
            % PLOT(PD,[]) plots the data plot of all elements contained in the
            %   list PD.
            %
            % PLOT(PD,I_VEC,'PropertyName',PropertyValue) sets the property
            %   of multiple symbols' PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'marker'
                        Marker = varargin{n+1};
                        nmarker = n+1;
                    case 'markersize'
                        Size = varargin{n+1};
                        nsize = n+1;
                    case 'markercolor'
                        MarkerColor = varargin{n+1};
                        nmarkercolor = n+1;
                    case 'markerfacecolor'
                        MarkerFaceColor = varargin{n+1};
                        nmarkerfacecolor = n+1;
                    case 'markeredgecolor'
                        MarkerEdgeColor = varargin{n+1};
                        nmarkeredgecolor = n+1;
                    case 'slinetyle'
                        Style = varargin{n+1};
                        nstyle = n+1;
                    case 'linewidth'
                        Width = varargin{n+1};
                        nwidth = n+1;
                    case 'linecolor'
                        Color = varargin{n+1};
                        ncolor = n+1;
                end
            end
            
            for m = 1:1:length(i_vec)
                if exist('Marker','var') && numel(Marker)==length(i_vec)
                    varargin{nmarker} = Marker(m);
                end
                if exist('Style','var') && numel(Style)==length(i_vec)
                    varargin{nstyle} = Style(m);
                end
                if exist('MarkerEdgeColor','var') && size(MarkerEdgeColor,1)==length(i_vec) && size(MarkerEdgeColor,2)==3
                    varargin{nmarkeredgecolor} = MarkerEdgeColor(m,:);
                end
                if exist('MarkerFaceColor','var') && size(MarkerFaceColor,1)==length(i_vec) && size(MarkerFaceColor,2)==3
                    varargin{nmarkerfacecolor} = MarkerFaceColor(m,:);
                end
                if exist('Color','var') && size(Color,1)==length(i_vec) && size(Color,2)==3
                    varargin{ncolor} = Color(m,:);
                end
                if exist('MarkerColor','var') && size(MarkerColor,1)==length(i_vec) && size(MarkerColor,2)==3
                    varargin{nmarkercolor} = MarkerColor(m,:);
                end
                if exist('Size','var') && numel(Size)==length(i_vec)
                    varargin{nsize} = Size(m);
                end
                if exist('Width','var') && numel(Width)==length(i_vec)
                    varargin{nwidth} = Width(m);
                end
                
                pd.plot_single_mid(i_vec(m),varargin{:});
            end
        end
        function plot_mid_on(pd,i_vec)
            % PLOT_DATA_ON shows the data plot of multiple elements
            %
            % PLOT_DATA_ON(PD,I_VEC) shows the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_ON(PD,[]) shows the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_mid_on(i_vec(m))
            end
        end
        function plot_mid_off(pd,i_vec)
            % PLOT_DATA_OFF hides the data plot of multiple elements
            %
            % PLOT_DATA_OFF(PD,I_VEC) hides the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_OFF(PD,[]) hides the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_mid_off(i_vec(m))
            end
        end
        
        function h_area = plot_single_area(pd,i,varargin)
            
            pd.set_axes()
            pd.hold_on()
            
            pde = pd.get(i);
            
            % sets properties
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'areacolor'
                        pde.setProp(PlotDataArea.AREA_FACE_COLOR,varargin{n+1})
                        pde.setProp(PlotDataArea.AREA_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'facecolor'
                        pde.setProp(PlotDataArea.AREA_FACE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'edgecolor'
                        pde.setProp(PlotDataArea.AREA_EDGE_COLOR,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'alpha'
                        pde.setProp(PlotDataArea.AREA_FACE_ALPHA,varargin{n+1})
                        pde.setProp(PlotDataArea.AREA_EDGE_ALPHA,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'facealpha'
                        pde.setProp(PlotDataArea.AREA_FACE_ALPHA,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'edgealpha'
                        pde.setProp(PlotDataArea.AREA_EDGE_ALPHA,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'edgewidth'
                        pde.setProp(PlotDataArea.AREA_EDGE_WIDTH,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                    case 'edgestyle'
                        pde.setProp(PlotDataArea.AREA_EDGE_STYLE,varargin{n+1})
                        varargin{n} = {};
                        varargin{n+1} = {};
                end
            end
            
            % gets properties
            h_area = pde.getAreaHandle();
            X = pde.getProp(PlotDataArea.X);
            Yl = pde.getProp(PlotDataArea.Y_LOW);
            Yh = pde.getProp(PlotDataArea.Y_HIGH);
            X_patch = [X fliplr(X)];
            Y_patch = [Yl fliplr(Yh)];
            
            FACE_COLOR = pde.getProp(PlotDataArea.AREA_FACE_COLOR);
            FACE_ALPHA = pde.getProp(PlotDataArea.AREA_FACE_ALPHA);
            EDGE_COLOR = pde.getProp(PlotDataArea.AREA_EDGE_COLOR);
            EDGE_ALPHA = pde.getProp(PlotDataArea.AREA_EDGE_ALPHA);
            EDGE_STYLE = pde.getProp(PlotDataArea.AREA_EDGE_STYLE);
            EDGE_WIDTH = pde.getProp(PlotDataArea.AREA_EDGE_WIDTH);
            
            % plots
            if ~ishandle(h_area)
                h_area = fill( ...
                    X_patch, ...
                    Y_patch, ...
                    [1 0 0], ...
                    'FaceColor',FACE_COLOR, ...
                    'FaceAlpha',FACE_ALPHA, ...
                    'EdgeColor',EDGE_COLOR, ...
                    'EdgeAlpha',EDGE_ALPHA, ...
                    'LineStyle',EDGE_STYLE, ...
                    'LineWidth',EDGE_WIDTH, ...
                    'Parent',pd.get_axes());
                pde.setAreaHandle(h_area)
            else
                set(h_area, ...
                    'XData',X_patch, ...
                    'YData',Y_patch, ...
                    'FaceColor',FACE_COLOR, ...
                    'FaceAlpha',FACE_ALPHA, ...
                    'EdgeColor',EDGE_COLOR, ...
                    'EdgeAlpha',EDGE_ALPHA, ...
                    'LineStyle',EDGE_STYLE, ...
                    'LineWidth',EDGE_WIDTH);
            end
            
            varargin = varargin(~cellfun(@isempty, varargin));
            for n = 1:2:length(varargin)
                set(h_area,varargin{n},varargin{n+1})
            end
            
            % output if needed
            if nargout>0
                h_area = pde.getAreaHandle();
            end
            
        end
        function plot_single_area_on(pd,i)
            % DATA_ON shows the data plot of single element
            %
            % DATA_ON(PD,I) shows the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_area = pde.getAreaHandle();
            if  ishandle(h_area)
                set(h_area,'Visible','on')
            end
            pde.setAreaHandle(h_area)
        end
        function plot_single_area_off(pd,i)
            % DATA_OFF hides the data plot of single element
            %
            % DATA_OFF(PD,I) hides the data plot of the element I.
            %
            % See also PlotData.
            
            pde = pd.get(i);
            h_areas = pde.getAreaHandle();
            if  ishandle(h_areas)
                set(h_areas,'Visible','off')
            end
            pde.setAreaHandle(h_areas)
        end
        function plot_area(pd,i_vec,varargin)
            % PLOT plots the data of multiple elements
            %
            % PLOT(PD,I_VEC) plots the data of the elements specified in
            %   I_VEC as symbols, if not plotted.
            %
            % PLOT(PD,[]) plots the data plot of all elements contained in the
            %   list PD.
            %
            % PLOT(PD,I_VEC,'PropertyName',PropertyValue) sets the property
            %   of multiple symbols' PropertyName to PropertyValue.
            %   All standard plot properties of plot can be used.
            %   The symbol properties can also be changed when hidden.
            %
            % See also PlotData, plot.
            
            % Marker - Style - MarkerEdgeColor - MarkerFaceColor - Color
            % MarkerColor - Size - Width
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'areacolor'
                        Areacolor = varargin{n+1};
                        nareacolor = n+1;
                    case 'facecolor'
                        Facecolor = varargin{n+1};
                        nfacecolor = n+1;
                    case 'edgecolor'
                        Edgecolor = varargin{n+1};
                        nedgecolor = n+1;
                    case 'alpha'
                        Alpha = varargin{n+1};
                        nalpha = n+1;
                    case 'facealpha'
                        Facealpha = varargin{n+1};
                        nfacealpha = n+1;
                    case 'edgealpha'
                        Edgealpha = varargin{n+1};
                        nedgealpha = n+1;
                    case 'edgewidth'
                        Edgewidth = varargin{n+1};
                        nedgewidth = n+1;
                    case 'edgestyle'
                        Edgestyle = varargin{n+1};
                        nedgestyle = n+1;
                end
            end
            
            for m = 1:1:length(i_vec)
                if exist('Areacolor','var') && size(Areacolor,1)==length(i_vec) && size(Areacolor,2)==3
                    varargin{nareacolor} = Areacolor(m,:);
                end
                if exist('Facecolor','var') && size(Facecolor,1)==length(i_vec) && size(Facecolor,2)==3
                    varargin{nfacecolor} = Facecolor(m,:);
                end
                if exist('Edgecolor','var') && size(Edgecolor,1)==length(i_vec) && size(Edgecolor,2)==3
                    varargin{nedgecolor} = Edgecolor(m,:);
                end
                if exist('Alpha','var') && numel(Alpha)==length(i_vec)
                    varargin{nalpha} = Alpha(m);
                end
                if exist('Facealpha','var') && numel(Facealpha)==length(i_vec)
                    varargin{nfacealpha} = Facealpha(m);
                end
                if exist('Edgealpha','var') && numel(Edgealpha)==length(i_vec)
                    varargin{nedgealpha} = Edgealpha(m);
                end
                if exist('Edgewidth','var') && numel(Edgewidth)==length(i_vec)
                    varargin{nedgewidth} = Edgewidth(m);
                end
                if exist('Edgestyle','var') && numel(Edgestyle)==length(i_vec)
                    varargin{nedgestyle} = Edgestyle(m);
                end
                
                pd.plot_single_area(i_vec(m),varargin{:});
            end
        end
        function plot_area_on(pd,i_vec)
            % PLOT_DATA_ON shows the data plot of multiple elements
            %
            % PLOT_DATA_ON(PD,I_VEC) shows the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_ON(PD,[]) shows the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            
            for m = 1:1:length(i_vec)
                pd.plot_single_area_on(i_vec(m))
            end
        end
        function plot_area_off(pd,i_vec)
            % PLOT_DATA_OFF hides the data plot of multiple elements
            %
            % PLOT_DATA_OFF(PD,I_VEC) hides the data plot of the elements
            %   specified in I_VEC.
            %
            % PLOT_DATA_OFF(PD,[]) hides the data plot of all elements
            %   contained in the list PD.
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1:1:pd.length();
            end
            for m = 1:1:length(i_vec)
                pd.plot_single_area_off(i_vec(m))
            end
        end
        
        function h = set_axes(pd,ht)
            % SET_AXES sets current axes
            %
            % SET_AXES(PD,HT) set the axes to plot the data of list of
            %   elements PD.
            %   If an axes is not entered as an input argument HT, the
            %   current axes is used for plotting.
            %
            % H = SET_AXES(PD) returns a handle to the axes used to plot
            %   the data of list of elements PD.
            %
            % See also PlotData, gca.
            
            if isempty(pd.h_axes) || ~ishandle(pd.h_axes)
                
                if nargin<2
                    ht = gca;
                end
                
                pd.h_axes = ht;
            end
            
            if nargout>0
                h = ht;
            end
        end
        function h = get_axes(pd)
            % GET_AXES gets current axes
            %
            % H = GET_AXES(PD) returns a handle to the axes used to plot
            %   the data of list of elements PD.
            %
            % See also PlotData, axes.
            
            h = pd.h_axes;
        end
        function hold_on(pd)
            % HOLD_ON hold on
            %
            % HOLD_ON(PD) retains the plot if another graph is also plotted
            %   in the current axes.
            %
            % See also PlotData, hold.
            
            pd.set_axes()
            
            hold(pd.h_axes,'on')
        end
        function hold_off(pd)
            % HOLD_OFF hold off
            %
            % HOLD_OFF(PD) clears the current plot if another graph is also
            %   plotted in the current axes.
            %
            % See also PlotData, hold.
            
            pd.set_axes()
            
            hold(pd.h_axes,'off')
        end
        function grid_on(pd)
            % GRID_ON grid on
            %
            % GRID_ON(PD) adds major grid lines to the current axes.
            %
            % See also PlotData, grid.
            
            pd.set_axes()
            
            grid(pd.h_axes,'on')
        end
        function grid_off(pd)
            % GRID_OFF grid off
            %
            % GRID_OFF(PD) removes grid lines from the current axes.
            %
            % See also PlotData, grid.
            
            pd.set_axes()
            
            grid(pd.h_axes,'off')
        end
        function axis_on(pd)
            % AXIS_ON axis on
            %
            % AXIS_ON(PD) turns on all axis lines, tick marks, and labels.
            %
            % See also PlotData, axis.
            
            pd.set_axes()
            
            axis(pd.h_axes,'on')
        end
        function axis_off(pd)
            % AXIS_OFF axis off
            %
            % AXIS_OFF(PD) turns off all axis lines, tick marks, and labels.
            %
            % See also PlotData, axis.
            
            pd.set_axes()
            
            axis(pd.h_axes,'off')
        end
        function axis_equal(pd)
            % AXIS_EQUAL axis equal
            %
            % AXIS_EQUAL(PD) sets the aspect ratio so that the data units
            %   are the same in every direction.
            %
            % See also PlotData, axis.
            
            pd.set_axes()
            
            daspect(pd.h_axes,[1 1 1])
        end
        function axis_tight(pd)
            % AXIS_TIGHT axis tight
            %
            % AXIS_TIGHT(PD) sets the axis limits to the range of the data.
            %
            % See also PlotData, axis.
            
            pd.set_axes()
            
            axis(pd.h_axes,'tight')
        end
        function set_labels(pd,varargin)
            % SET_LABELS sets plot labels
            %
            % SET_LABELS(PD) display the x and y labels specified as the
            %   properties of the list of elements PD.
            %
            % SET_LABELS(PD,'PropertyName',PropertyValue) sets the property
            %   of the label's PropertyName to PropertyValue.
            %   All standard plot properties of xlabel and ylabel can be used.
            %   Additional properties:
            %       xlabel  -   x label of the plot
            %       ylabel  -   y label of the plot
            %
            % See also PlotData, xlabel, ylabel.
            
            pd.set_axes()
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'xlabel'
                        pd.setProp(PlotData.XLABEL,varargin{n+1})
                    case 'ylabel'
                        pd.setProp(PlotData.YLABEL,varargin{n+1})
                    case 'interpreter'
                        pd.setProp(PlotData.FONT_INTERPRETER,varargin{n+1})
                    case 'textcolor'
                        pd.setProp(PlotData.FONT_COLOR,varargin{n+1})
                    case 'fontsize'
                        pd.setProp(PlotData.FONT_SIZE,varargin{n+1})
                    case 'fontweight'
                        pd.setProp(PlotData.FONT_WEIGHT,varargin{n+1})
                    case 'fontname'
                        pd.setProp(PlotData.FONT_TYPE,varargin{n+1})
                end
            end
            
            LABEL_SIZE = pd.getProp(PlotData.FONT_SIZE);
            LABEL_TYPE = pd.getProp(PlotData.FONT_TYPE);
            LABEL_WEIGHT = pd.getProp(PlotData.FONT_WEIGHT);
            LABEL_INTERPRETER = pd.getProp(PlotData.FONT_INTERPRETER);
            LABEL_COLOR = pd.getProp(PlotData.FONT_COLOR);
            
            set(gca,'FontSize',0.75*LABEL_SIZE)
            
            xlabel(pd.getProp(PlotData.XLABEL), ...
                'FontSize',LABEL_SIZE, ...
                'FontName',LABEL_TYPE, ...
                'FontWeight',LABEL_WEIGHT, ...
                'Interpreter',LABEL_INTERPRETER, ...
                'Color',LABEL_COLOR);
            
            ylabel(pd.getProp(PlotData.YLABEL), ...
                'FontSize',LABEL_SIZE, ...
                'FontName',LABEL_TYPE, ...
                'FontWeight',LABEL_WEIGHT, ...
                'Interpreter',LABEL_INTERPRETER, ...
                'Color',LABEL_COLOR);
        end
        function set_title(pd,varargin)
            % SET_TITLE sets plot title
            %
            % SET_TITLE(PD) display the title of the plot of the list of elements PD.
            %
            % SET_TITLE(PD,'PropertyName',PropertyValue) sets the property
            %   of the title's PropertyName to PropertyValue.
            %   All standard plot properties of title can be used.
            %   Additional properties:
            %       title  -   title of the plot
            %
            % See also PlotData, title.
            
            pd.set_axes()
            
            for n = 1:2:length(varargin)
                switch lower(varargin{n})
                    case 'title'
                        pd.setProp(PlotData.NAME,varargin{n+1})
                    case 'interpreter'
                        pd.setProp(PlotData.FONT_INTERPRETER,varargin{n+1})
                    case 'textcolor'
                        pd.setProp(PlotData.FONT_COLOR,varargin{n+1})
                    case 'fontsize'
                        pd.setProp(PlotData.FONT_SIZE,varargin{n+1})
                    case 'fontweight'
                        pd.setProp(PlotData.FONT_WEIGHT,varargin{n+1})
                    case 'fontname'
                        pd.setProp(PlotData.FONT_TYPE,varargin{n+1})
                end
            end
            
            TITLE_SIZE = pd.getProp(PlotData.FONT_SIZE);
            TITLE_TYPE = pd.getProp(PlotData.FONT_TYPE);
            TITLE_WEIGHT = pd.getProp(PlotData.FONT_WEIGHT);
            TITLE_INTERPRETER = pd.getProp(PlotData.FONT_INTERPRETER);
            TITLE_COLOR = pd.getProp(PlotData.FONT_COLOR);
            
            title(pd.getProp(PlotData.NAME), ...
                'FontSize',TITLE_SIZE, ...
                'FontName',TITLE_TYPE, ...
                'FontWeight',TITLE_WEIGHT, ...
                'Interpreter',TITLE_INTERPRETER, ...
                'Color',TITLE_COLOR);
        end
        function i = get_pde_i(pd,h)
            % GET_PDE_I order number of list element corresponding to a plot
            %
            % I = GET_PDE_I(PD,H) returns the order number of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:pd.length()
                    if h==pd.get(j).getDataHandle()
                        i = j;
                    end
                end
            end
        end
        function pde = get_pde(pd,h)
            % GET_PDE properties of list element corresponding to a plot
            %
            % PDE = GET_PDE(PD,H) returns the properties of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = pd.get_pde_i(h);
            pde = pd.get(i);
        end
        function i = get_pde_high_i(pd,h)
            % GET_PDE_I order number of list element corresponding to a plot
            %
            % I = GET_PDE_I(PD,H) returns the order number of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:pd.length()
                    if h==pd.get(j).getYHighHandle()
                        i = j;
                    end
                end
            end
        end
        function pde = get_pde_high(pd,h)
            % GET_PDE properties of list element corresponding to a plot
            %
            % PDE = GET_PDE(PD,H) returns the properties of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = pd.get_pde_high_i(h);
            pde = pd.get(i);
        end
        function i = get_pde_low_i(pd,h)
            % GET_PDE_I order number of list element corresponding to a plot
            %
            % I = GET_PDE_I(PD,H) returns the order number of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:pd.length()
                    if h==pd.get(j).getYLowHandle()
                        i = j;
                    end
                end
            end
        end
        function pde = get_pde_low(pd,h)
            % GET_PDE properties of list element corresponding to a plot
            %
            % PDE = GET_PDE(PD,H) returns the properties of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = pd.get_pde_low_i(h);
            pde = pd.get(i);
        end
        function i = get_pde_mid_i(pd,h)
            % GET_PDE_I order number of list element corresponding to a plot
            %
            % I = GET_PDE_I(PD,H) returns the order number of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:pd.length()
                    if h==pd.get(j).getYMidHandle()
                        i = j;
                    end
                end
            end
        end
        function pde = get_pde_mid(pd,h)
            % GET_PDE properties of list element corresponding to a plot
            %
            % PDE = GET_PDE(PD,H) returns the properties of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = pd.get_pde_mid_i(h);
            pde = pd.get(i);
        end
        function i = get_pde_area_i(pd,h)
            % GET_PDE_I order number of list element corresponding to a plot
            %
            % I = GET_PDE_I(PD,H) returns the order number of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = NaN;
            if ~isempty(h)
                for j = 1:1:pd.length()
                    if h==pd.get(j).getAreaHandle()
                        i = j;
                    end
                end
            end
        end
        function pde = get_pde_area(pd,h)
            % GET_PDE properties of list element corresponding to a plot
            %
            % PDE = GET_PDE(PD,H) returns the properties of the list element
            %   in the list PD corresponding to the plot with handle H.
            %
            % See also PlotData.
            
            i = pd.get_pde_area_i(h);
            pde = pd.get(i);
        end

        function plot_data_settings(pd,i_vec,varargin)
            % PLOT_SETTINGS sets plot's properties
            %
            % PLOT_SETTINGS(PD) allows the user to interractively
            %   change the plots' settings via a graphical user interface.
            %
            % PLOT_SETTINGS(PD,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1;
            end
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Plot Settings - Data';
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
            if isempty(pd.f_settings) || ~ishandle(pd.f_settings)
                pd.f_settings = figure('Visible','off');
            end
            f = pd.f_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            % Initialization
            ui_list = uicontrol(f,'Style', 'listbox');
            GUI.setUnits(ui_list)
            GUI.setBackgroundColor(ui_list)
            if ~isempty(i_vec)
                set(ui_list,'Value',i_vec)
            else
                set(ui_list,'Value',1)
            end
            set(ui_list,'Max',2,'Min',0)
            set(ui_list,'BackgroundColor',[1 1 1])
            set(ui_list,'Position',[.10 .05 .40 .90])
            set(ui_list,'TooltipString','Select brain regions');
            set(ui_list,'Callback',{@cb_list});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.55 .87 .15 .08])
            set(ui_button_show,'String','Show data plot')
            set(ui_button_show,'TooltipString','Show selected brain regions')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.75 .87 .15 .08])
            set(ui_button_hide,'String','Hide data plot')
            set(ui_button_hide,'TooltipString','Hide selected brain regions')
            set(ui_button_hide,'Callback',{@cb_hide})
            
            ui_popup_marker = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_marker)
            GUI.setBackgroundColor(ui_popup_marker)
            set(ui_popup_marker,'Position',[.55 .73 .35 .08])
            set(ui_popup_marker,'String',GUI.PLOT_SYMBOL_NAME)
            set(ui_popup_marker,'Value',2)
            set(ui_popup_marker,'TooltipString','Select symbol');
            set(ui_popup_marker,'Callback',{@cb_marker})
            
            ui_text_size = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_size)
            GUI.setBackgroundColor(ui_text_size)
            set(ui_text_size,'Position',[.55 .585 .10 .08])
            set(ui_text_size,'String','size ')
            set(ui_text_size,'HorizontalAlignment','left')
            set(ui_text_size,'FontWeight','bold')
            
            ui_edit_size = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_size)
            GUI.setBackgroundColor(ui_edit_size)
            set(ui_edit_size,'Position',[.65 .60 .25 .08])
            set(ui_edit_size,'HorizontalAlignment','center')
            set(ui_edit_size,'FontWeight','bold')
            set(ui_edit_size,'String','10')
            set(ui_edit_size,'Callback',{@cb_markersize})
            
            ui_button_facecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_facecolor)
            GUI.setBackgroundColor(ui_button_facecolor)
            set(ui_button_facecolor,'Position',[.55 .46 .15 .08])
            set(ui_button_facecolor,'String','Symbol Color')
            set(ui_button_facecolor,'TooltipString','Select symbol color')
            set(ui_button_facecolor,'Callback',{@cb_markerfacecolor})
            
            ui_button_edgecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_edgecolor)
            GUI.setBackgroundColor(ui_button_edgecolor)
            set(ui_button_edgecolor,'Position',[.75 .46 .15 .08])
            set(ui_button_edgecolor,'String','Edge Color')
            set(ui_button_edgecolor,'TooltipString','Select symbol edge color')
            set(ui_button_edgecolor,'Callback',{@cb_markeredgecolor})
            
            ui_popup_line = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_line)
            GUI.setBackgroundColor(ui_popup_line)
            set(ui_popup_line,'Position',[.55 .32 .35 .08])
            set(ui_popup_line,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_line,'Value',1)
            set(ui_popup_line,'TooltipString','Select line style');
            set(ui_popup_line,'Callback',{@cb_linestyle})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.55 .175 .10 .08])
            set(ui_text_width,'String','width ')
            set(ui_text_width,'HorizontalAlignment','left')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.65 .19 .25 .08])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_linewidth})
            
            ui_button_linecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_linecolor)
            GUI.setBackgroundColor(ui_button_linecolor)
            set(ui_button_linecolor,'Position',[.55 .05 .35 .08])
            set(ui_button_linecolor,'String','Line Color')
            set(ui_button_linecolor,'TooltipString','Select symbol color')
            set(ui_button_linecolor,'Callback',{@cb_linecolor})
            
            update_list()
            set(f,'Visible','on')
            
            function update_list()
                codes = {};
                for i = 1:1:pd.length()
                    %if ~isa(pd.get(i),'PlotDataArea')
                        codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                    %end
                end
                codes = codes(~cellfun(@isempty, codes));
                % Set list names
                set(ui_list,'String',codes)
            end
            function cb_list(~,~)  % (src,event)
            end
            function cb_show(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_data(get_list_data())
                pd.plot_data_on(get_list_data())
                pd.set_axes()
            end
            function cb_hide(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_data_off(get_list_data())
                pd.set_axes()
            end
            function cb_marker(~,~)  % (src,event)
                symbol = GUI.PLOT_SYMBOL_TAG{get(ui_popup_marker,'Value')};
                pd.plot_data(get_list_data(),'Marker',symbol)
            end
            function cb_markersize(~,~)  % (src,event)
                size = real(str2num(get(ui_edit_size,'String')));
                
                if isempty(size) || size<=0
                    set(ui_edit_size,'String','5')
                    size = 5;
                end
                pd.plot_data(get_list_data(),'MarkerSize',size)    
            end
            function cb_markerfacecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_data(get_list_data(),'MarkerFaceColor',color)
                end
            end
            function cb_markeredgecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_data(get_list_data(),'MarkerEdgeColor',color)
                end
            end
            function cb_linestyle(~,~)  % (src,event)
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_line,'Value')};
                pd.plot_data(get_list_data(),'LineStyle',style)
            end
            function cb_linewidth(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<=0
                    set(ui_edit_width,'String','1')
                    width = 1;
                end
                pd.plot_data(get_list_data(),'LineWidth',width)
            end
            function cb_linecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_data(get_list_data(),'linecolor',color)
                end
            end
            function data = get_list_data()
                if pd.length>0
                    data = get(ui_list,'Value');
                else
                    data = [];
                end
            end
        end
        function plot_high_settings(pd,i_vec,varargin)
            % PLOT_SETTINGS sets plot's properties
            %
            % PLOT_SETTINGS(PD) allows the user to interractively
            %   change the plots' settings via a graphical user interface.
            %
            % PLOT_SETTINGS(PD,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1;
            end
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Plot Settings - Upper Bound';
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
            if isempty(pd.f_high_settings) || ~ishandle(pd.f_high_settings)
                pd.f_high_settings = figure('Visible','off');
            end
            f = pd.f_high_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            % Initialization
            ui_list = uicontrol(f,'Style', 'listbox');
            GUI.setUnits(ui_list)
            GUI.setBackgroundColor(ui_list)
            if ~isempty(i_vec)
                set(ui_list,'Value',i_vec)
            else
                set(ui_list,'Value',1)
            end
            set(ui_list,'Max',2,'Min',0)
            set(ui_list,'BackgroundColor',[1 1 1])
            set(ui_list,'Position',[.10 .05 .40 .90])
            set(ui_list,'TooltipString','Select brain regions');
            set(ui_list,'Callback',{@cb_list});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.55 .87 .15 .08])
            set(ui_button_show,'String','Show data plot')
            set(ui_button_show,'TooltipString','Show selected brain regions')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.75 .87 .15 .08])
            set(ui_button_hide,'String','Hide data plot')
            set(ui_button_hide,'TooltipString','Hide selected brain regions')
            set(ui_button_hide,'Callback',{@cb_hide})
            
            ui_popup_marker = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_marker)
            GUI.setBackgroundColor(ui_popup_marker)
            set(ui_popup_marker,'Position',[.55 .73 .35 .08])
            set(ui_popup_marker,'String',GUI.PLOT_SYMBOL_NAME)
            set(ui_popup_marker,'Value',2)
            set(ui_popup_marker,'TooltipString','Select symbol');
            set(ui_popup_marker,'Callback',{@cb_marker})
            
            ui_text_size = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_size)
            GUI.setBackgroundColor(ui_text_size)
            set(ui_text_size,'Position',[.55 .585 .10 .08])
            set(ui_text_size,'String','size ')
            set(ui_text_size,'HorizontalAlignment','left')
            set(ui_text_size,'FontWeight','bold')
            
            ui_edit_size = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_size)
            GUI.setBackgroundColor(ui_edit_size)
            set(ui_edit_size,'Position',[.65 .60 .25 .08])
            set(ui_edit_size,'HorizontalAlignment','center')
            set(ui_edit_size,'FontWeight','bold')
            set(ui_edit_size,'String','10')
            set(ui_edit_size,'Callback',{@cb_markersize})
            
            ui_button_facecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_facecolor)
            GUI.setBackgroundColor(ui_button_facecolor)
            set(ui_button_facecolor,'Position',[.55 .46 .15 .08])
            set(ui_button_facecolor,'String','Symbol Color')
            set(ui_button_facecolor,'TooltipString','Select symbol color')
            set(ui_button_facecolor,'Callback',{@cb_markerfacecolor})
            
            ui_button_edgecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_edgecolor)
            GUI.setBackgroundColor(ui_button_edgecolor)
            set(ui_button_edgecolor,'Position',[.75 .46 .15 .08])
            set(ui_button_edgecolor,'String','Edge Color')
            set(ui_button_edgecolor,'TooltipString','Select symbol edge color')
            set(ui_button_edgecolor,'Callback',{@cb_markeredgecolor})
            
            ui_popup_line = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_line)
            GUI.setBackgroundColor(ui_popup_line)
            set(ui_popup_line,'Position',[.55 .32 .35 .08])
            set(ui_popup_line,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_line,'Value',1)
            set(ui_popup_line,'TooltipString','Select line style');
            set(ui_popup_line,'Callback',{@cb_linestyle})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.55 .175 .10 .08])
            set(ui_text_width,'String','width ')
            set(ui_text_width,'HorizontalAlignment','left')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.65 .19 .25 .08])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_linewidth})
            
            ui_button_linecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_linecolor)
            GUI.setBackgroundColor(ui_button_linecolor)
            set(ui_button_linecolor,'Position',[.55 .05 .35 .08])
            set(ui_button_linecolor,'String','Line Color')
            set(ui_button_linecolor,'TooltipString','Select symbol color')
            set(ui_button_linecolor,'Callback',{@cb_linecolor})
            
            update_list()
            set(f,'Visible','on')
            
            function update_list()
                codes = {};
                for i = 1:1:pd.length()
                    if isa(pd.get(i),'PlotDataArea')
                        codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                    end
                end
                codes = codes(~cellfun(@isempty, codes));
                % Set list names
                set(ui_list,'String',codes)
            end
            function cb_list(~,~)  % (src,event)
            end
            function cb_show(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_high(get_list_high())
                pd.plot_high_on(get_list_high())
                pd.set_axes();
            end
            function cb_hide(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_high_off(get_list_high())
                pd.set_axes();
            end
            function cb_marker(~,~)  % (src,event)
                symbol = GUI.PLOT_SYMBOL_TAG{get(ui_popup_marker,'Value')};
                pd.plot_high(get_list_high(),'marker',symbol)
            end
            function cb_markersize(~,~)  % (src,event)
                size = real(str2num(get(ui_edit_size,'String')));
                
                if isempty(size) || size<=0
                    set(ui_edit_size,'String','5')
                    size = 5;
                end
                pd.plot_high(get_list_high(),'MarkerSize',size)    
            end
            function cb_markerfacecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_high(get_list_high(),'MarkerFaceColor',color)
                end
            end
            function cb_markeredgecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_high(get_list_high(),'MarkerEdgeColor',color)
                end
            end
            function cb_linestyle(~,~)  % (src,event)
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_line,'Value')};
                pd.plot_high(get_list_high(),'LineStyle',style)
            end
            function cb_linewidth(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<=0
                    set(ui_edit_width,'String','1')
                    width = 1;
                end
                pd.plot_high(get_list_high(),'LineWidth',width)
            end
            function cb_linecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_high(get_list_high(),'linecolor',color)
                end
            end
            function data = get_list_high()
                if pd.length>0
                    codes = {};
                    for i = 1:1:pd.length()
                        if isa(pd.get(i),'PlotDataArea')
                            codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                        end
                    end
                    indices = find(~cellfun(@isempty,codes));
                    value = get(ui_list,'Value');
                    
                    data = indices(value);
                else
                    data = [];
                end
            end
        end
        function plot_low_settings(pd,i_vec,varargin)
            % PLOT_SETTINGS sets plot's properties
            %
            % PLOT_SETTINGS(PD) allows the user to interractively
            %   change the plots' settings via a graphical user interface.
            %
            % PLOT_SETTINGS(PD,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1;
            end
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Plot Settings - Lower Bound';
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
            if isempty(pd.f_low_settings) || ~ishandle(pd.f_low_settings)
                pd.f_low_settings = figure('Visible','off');
            end
            f = pd.f_low_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            % Initialization
            ui_list = uicontrol(f,'Style', 'listbox');
            GUI.setUnits(ui_list)
            GUI.setBackgroundColor(ui_list)
            if ~isempty(i_vec)
                set(ui_list,'Value',i_vec)
            else
                set(ui_list,'Value',1)
            end
            set(ui_list,'Max',2,'Min',0)
            set(ui_list,'BackgroundColor',[1 1 1])
            set(ui_list,'Position',[.10 .05 .40 .90])
            set(ui_list,'TooltipString','Select brain regions');
            set(ui_list,'Callback',{@cb_list});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.55 .87 .15 .08])
            set(ui_button_show,'String','Show data plot')
            set(ui_button_show,'TooltipString','Show selected brain regions')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.75 .87 .15 .08])
            set(ui_button_hide,'String','Hide data plot')
            set(ui_button_hide,'TooltipString','Hide selected brain regions')
            set(ui_button_hide,'Callback',{@cb_hide})
            
            ui_popup_marker = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_marker)
            GUI.setBackgroundColor(ui_popup_marker)
            set(ui_popup_marker,'Position',[.55 .73 .35 .08])
            set(ui_popup_marker,'String',GUI.PLOT_SYMBOL_NAME)
            set(ui_popup_marker,'Value',2)
            set(ui_popup_marker,'TooltipString','Select symbol');
            set(ui_popup_marker,'Callback',{@cb_marker})
            
            ui_text_size = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_size)
            GUI.setBackgroundColor(ui_text_size)
            set(ui_text_size,'Position',[.55 .585 .10 .08])
            set(ui_text_size,'String','size ')
            set(ui_text_size,'HorizontalAlignment','left')
            set(ui_text_size,'FontWeight','bold')
            
            ui_edit_size = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_size)
            GUI.setBackgroundColor(ui_edit_size)
            set(ui_edit_size,'Position',[.65 .60 .25 .08])
            set(ui_edit_size,'HorizontalAlignment','center')
            set(ui_edit_size,'FontWeight','bold')
            set(ui_edit_size,'String','10')
            set(ui_edit_size,'Callback',{@cb_markersize})
            
            ui_button_facecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_facecolor)
            GUI.setBackgroundColor(ui_button_facecolor)
            set(ui_button_facecolor,'Position',[.55 .46 .15 .08])
            set(ui_button_facecolor,'String','Symbol Color')
            set(ui_button_facecolor,'TooltipString','Select symbol color')
            set(ui_button_facecolor,'Callback',{@cb_markerfacecolor})
            
            ui_button_edgecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_edgecolor)
            GUI.setBackgroundColor(ui_button_edgecolor)
            set(ui_button_edgecolor,'Position',[.75 .46 .15 .08])
            set(ui_button_edgecolor,'String','Edge Color')
            set(ui_button_edgecolor,'TooltipString','Select symbol edge color')
            set(ui_button_edgecolor,'Callback',{@cb_markeredgecolor})
            
            ui_popup_line = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_line)
            GUI.setBackgroundColor(ui_popup_line)
            set(ui_popup_line,'Position',[.55 .32 .35 .08])
            set(ui_popup_line,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_line,'Value',1)
            set(ui_popup_line,'TooltipString','Select line style');
            set(ui_popup_line,'Callback',{@cb_linestyle})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.55 .175 .10 .08])
            set(ui_text_width,'String','width ')
            set(ui_text_width,'HorizontalAlignment','left')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.65 .19 .25 .08])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_linewidth})
            
            ui_button_linecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_linecolor)
            GUI.setBackgroundColor(ui_button_linecolor)
            set(ui_button_linecolor,'Position',[.55 .05 .35 .08])
            set(ui_button_linecolor,'String','Line Color')
            set(ui_button_linecolor,'TooltipString','Select symbol color')
            set(ui_button_linecolor,'Callback',{@cb_linecolor})
            
            update_list()
            set(f,'Visible','on')
            
            function update_list()
                codes = {};
                for i = 1:1:pd.length()
                    if isa(pd.get(i),'PlotDataArea')
                        codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                    end
                end
                codes = codes(~cellfun(@isempty, codes));
                % Set list names
                set(ui_list,'String',codes)
            end
            function cb_list(~,~)  % (src,event)
            end
            function cb_show(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_low(get_list_data())
                pd.plot_low_on(get_list_data())
                pd.set_axes()
            end
            function cb_hide(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_low_off(get_list_data())
                pd.set_axes()
            end
            function cb_marker(~,~)  % (src,event)
                symbol = GUI.PLOT_SYMBOL_TAG{get(ui_popup_marker,'Value')};
                pd.plot_low(get_list_data(),'Marker',symbol)
            end
            function cb_markersize(~,~)  % (src,event)
                size = real(str2num(get(ui_edit_size,'String')));
                
                if isempty(size) || size<=0
                    set(ui_edit_size,'String','5')
                    size = 5;
                end
                pd.plot_low(get_list_data(),'MarkerSize',size)    
            end
            function cb_markerfacecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_low(get_list_data(),'MarkerFaceColor',color)
                end
            end
            function cb_markeredgecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_low(get_list_data(),'MarkerEdgeColor',color)
                end
            end
            function cb_linestyle(~,~)  % (src,event)
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_line,'Value')};
                pd.plot_low(get_list_data(),'LineStyle',style)
            end
            function cb_linewidth(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<=0
                    set(ui_edit_width,'String','1')
                    width = 1;
                end
                pd.plot_low(get_list_data(),'LineWidth',width)
            end
            function cb_linecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_low(get_list_data(),'linecolor',color)
                end
            end
            function data = get_list_data()
                if pd.length>0
                    codes = {};
                    for i = 1:1:pd.length()
                        if isa(pd.get(i),'PlotDataArea')
                            codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                        end
                    end
                    indices = find(~cellfun(@isempty,codes));
                    value = get(ui_list,'Value');
                    
                    data = indices(value);
                else
                    data = [];
                end
            end
        end
        function plot_mid_settings(pd,i_vec,varargin)
            % PLOT_SETTINGS sets plot's properties
            %
            % PLOT_SETTINGS(PD) allows the user to interractively
            %   change the plots' settings via a graphical user interface.
            %
            % PLOT_SETTINGS(PD,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1;
            end
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Plot Settings - Average';
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
            if isempty(pd.f_mid_settings) || ~ishandle(pd.f_mid_settings)
                pd.f_mid_settings = figure('Visible','off');
            end
            f = pd.f_mid_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            % Initialization
            ui_list = uicontrol(f,'Style', 'listbox');
            GUI.setUnits(ui_list)
            GUI.setBackgroundColor(ui_list)
            if ~isempty(i_vec)
                set(ui_list,'Value',i_vec)
            else
                set(ui_list,'Value',1)
            end
            set(ui_list,'Max',2,'Min',0)
            set(ui_list,'BackgroundColor',[1 1 1])
            set(ui_list,'Position',[.10 .05 .40 .90])
            set(ui_list,'TooltipString','Select brain regions');
            set(ui_list,'Callback',{@cb_list});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.55 .87 .15 .08])
            set(ui_button_show,'String','Show data plot')
            set(ui_button_show,'TooltipString','Show selected brain regions')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.75 .87 .15 .08])
            set(ui_button_hide,'String','Hide data plot')
            set(ui_button_hide,'TooltipString','Hide selected brain regions')
            set(ui_button_hide,'Callback',{@cb_hide})
            
            ui_popup_marker = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_marker)
            GUI.setBackgroundColor(ui_popup_marker)
            set(ui_popup_marker,'Position',[.55 .73 .35 .08])
            set(ui_popup_marker,'String',GUI.PLOT_SYMBOL_NAME)
            set(ui_popup_marker,'Value',2)
            set(ui_popup_marker,'TooltipString','Select symbol');
            set(ui_popup_marker,'Callback',{@cb_marker})
            
            ui_text_size = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_size)
            GUI.setBackgroundColor(ui_text_size)
            set(ui_text_size,'Position',[.55 .585 .10 .08])
            set(ui_text_size,'String','size ')
            set(ui_text_size,'HorizontalAlignment','left')
            set(ui_text_size,'FontWeight','bold')
            
            ui_edit_size = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_size)
            GUI.setBackgroundColor(ui_edit_size)
            set(ui_edit_size,'Position',[.65 .60 .25 .08])
            set(ui_edit_size,'HorizontalAlignment','center')
            set(ui_edit_size,'FontWeight','bold')
            set(ui_edit_size,'String','10')
            set(ui_edit_size,'Callback',{@cb_markersize})
            
            ui_button_facecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_facecolor)
            GUI.setBackgroundColor(ui_button_facecolor)
            set(ui_button_facecolor,'Position',[.55 .46 .15 .08])
            set(ui_button_facecolor,'String','Symbol Color')
            set(ui_button_facecolor,'TooltipString','Select symbol color')
            set(ui_button_facecolor,'Callback',{@cb_markerfacecolor})
            
            ui_button_edgecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_edgecolor)
            GUI.setBackgroundColor(ui_button_edgecolor)
            set(ui_button_edgecolor,'Position',[.75 .46 .15 .08])
            set(ui_button_edgecolor,'String','Edge Color')
            set(ui_button_edgecolor,'TooltipString','Select symbol edge color')
            set(ui_button_edgecolor,'Callback',{@cb_markeredgecolor})
            
            ui_popup_line = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_line)
            GUI.setBackgroundColor(ui_popup_line)
            set(ui_popup_line,'Position',[.55 .32 .35 .08])
            set(ui_popup_line,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_line,'Value',1)
            set(ui_popup_line,'TooltipString','Select line style');
            set(ui_popup_line,'Callback',{@cb_linestyle})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.55 .175 .10 .08])
            set(ui_text_width,'String','width ')
            set(ui_text_width,'HorizontalAlignment','left')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.65 .19 .25 .08])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_linewidth})
            
            ui_button_linecolor = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_linecolor)
            GUI.setBackgroundColor(ui_button_linecolor)
            set(ui_button_linecolor,'Position',[.55 .05 .35 .08])
            set(ui_button_linecolor,'String','Line Color')
            set(ui_button_linecolor,'TooltipString','Select symbol color')
            set(ui_button_linecolor,'Callback',{@cb_linecolor})
            
            update_list()
            set(f,'Visible','on')
            
            function update_list()
                codes = {};
                for i = 1:1:pd.length()
                    if isa(pd.get(i),'PlotDataArea')
                        codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                    end
                end
                codes = codes(~cellfun(@isempty, codes));
                % Set list names
                set(ui_list,'String',codes)
            end
            function cb_list(~,~)  % (src,event)
            end
            function cb_show(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_mid(get_list_data())
                pd.plot_mid_on(get_list_data())
                pd.set_axes()
            end
            function cb_hide(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_mid_off(get_list_data())
                pd.set_axes()
            end
            function cb_marker(~,~)  % (src,event)
                symbol = GUI.PLOT_SYMBOL_TAG{get(ui_popup_marker,'Value')};
                pd.plot_mid(get_list_data(),'Marker',symbol)
            end
            function cb_markersize(~,~)  % (src,event)
                size = real(str2num(get(ui_edit_size,'String')));
                
                if isempty(size) || size<=0
                    set(ui_edit_size,'String','5')
                    size = 5;
                end
                pd.plot_mid(get_list_data(),'MarkerSize',size)    
            end
            function cb_markerfacecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_mid(get_list_data(),'MarkerFaceColor',color)
                end
            end
            function cb_markeredgecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_mid(get_list_data(),'MarkerEdgeColor',color)
                end
            end
            function cb_linestyle(~,~)  % (src,event)
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_line,'Value')};
                pd.plot_mid(get_list_data(),'LineStyle',style)
            end
            function cb_linewidth(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<=0
                    set(ui_edit_width,'String','1')
                    width = 1;
                end
                pd.plot_mid(get_list_data(),'LineWidth',width)
            end
            function cb_linecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_mid(get_list_data(),'linecolor',color)
                end
            end
            function data = get_list_data()
                if pd.length>0
                    codes = {};
                    for i = 1:1:pd.length()
                        if isa(pd.get(i),'PlotDataArea')
                            codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                        end
                    end
                    indices = find(~cellfun(@isempty,codes));
                    value = get(ui_list,'Value');
                    
                    data = indices(value);
                else
                    data = [];
                end
            end
        end
        function plot_area_settings(pd,i_vec,varargin)
            % PLOT_SETTINGS sets plot's properties
            %
            % PLOT_SETTINGS(PD) allows the user to interractively
            %   change the plots' settings via a graphical user interface.
            %
            % PLOT_SETTINGS(PD,'PropertyName',PropertyValue) sets the property
            %   of the GUI's PropertyName to PropertyValue.
            %   Admissible properties are:
            %       FigPosition  -   position of the GUI on the screen
            %       FigColor     -   background color of the GUI
            %       FigName      -   name of the GUI
            %
            % See also PlotData.
            
            if nargin<2 || isempty(i_vec)
                i_vec = 1;
            end
            
            % sets position of figure
            FigPosition = [.50 .30 .30 .30];
            FigColor = GUI.BKGCOLOR;
            FigName = 'Plot Settings - Area';
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
            if isempty(pd.f_area_settings) || ~ishandle(pd.f_area_settings)
                pd.f_area_settings = figure('Visible','off');
            end
            f = pd.f_area_settings;
            set(f,'units','normalized')
            set(f,'Position',FigPosition)
            set(f,'Color',FigColor)
            set(f,'Name',FigName)
            set(f,'MenuBar','none')
            set(f,'Toolbar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            
            % Initialization
            ui_list = uicontrol(f,'Style', 'listbox');
            GUI.setUnits(ui_list)
            GUI.setBackgroundColor(ui_list)
            set(ui_list,'Max',2,'Min',0)
            set(ui_list,'BackgroundColor',[1 1 1])
            set(ui_list,'Position',[.05 .05 .40 .90])
            set(ui_list,'Value',i_vec)
            set(ui_list,'TooltipString','Select brain regions');
            set(ui_list,'Callback',{@cb_list});
            
            ui_button_show = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_show)
            GUI.setBackgroundColor(ui_button_show)
            set(ui_button_show,'Position',[.50 .85 .18 .10])
            set(ui_button_show,'String','Show data plot')
            set(ui_button_show,'TooltipString','Show selected brain regions')
            set(ui_button_show,'Callback',{@cb_show})
            
            ui_button_hide = uicontrol(f,'Style', 'pushbutton');
            GUI.setUnits(ui_button_hide)
            GUI.setBackgroundColor(ui_button_hide)
            set(ui_button_hide,'Position',[.765 .85 .18 .10])
            set(ui_button_hide,'String','Hide data plot')
            set(ui_button_hide,'TooltipString','Hide selected brain regions')
            set(ui_button_hide,'Callback',{@cb_hide})

            ui_text = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text)
            GUI.setBackgroundColor(ui_text)
            set(ui_text,'String','transparency')
            set(ui_text,'Position',[.73 .68 .25 .10])
            set(ui_text,'HorizontalAlignment','center')
            set(ui_text,'FontWeight','bold')
            
            ui_button_facecolor = uicontrol(f,'Style','pushbutton');
            GUI.setUnits(ui_button_facecolor)
            GUI.setBackgroundColor(ui_button_facecolor)
            set(ui_button_facecolor,'Position',[.50 .575 .15 .10])
            set(ui_button_facecolor,'String','face color')
            set(ui_button_facecolor,'HorizontalAlignment','center')
            set(ui_button_facecolor,'TooltipString','Brain region face color')
            set(ui_button_facecolor,'Callback',{@cb_facecolor})
            
            ui_slider_facealpha = uicontrol(f,'Style','slider');
            GUI.setUnits(ui_slider_facealpha)
            GUI.setBackgroundColor(ui_slider_facealpha)
            set(ui_slider_facealpha,'Position',[.73 .600 .25 .05])
            set(ui_slider_facealpha,'String','Brain region transparency')
            set(ui_slider_facealpha,'Min',0,'Max',1,'Value',.5)
            set(ui_slider_facealpha,'TooltipString','Brain region face transparency')
            set(ui_slider_facealpha,'Callback',{@cb_facealpha})
            
            ui_button_edgecolor = uicontrol(f,'Style','pushbutton');
            GUI.setUnits(ui_button_edgecolor)
            GUI.setBackgroundColor(ui_button_edgecolor)
            set(ui_button_edgecolor,'Position',[.50 .405 .15 .10])
            set(ui_button_edgecolor,'String','edge color')
            set(ui_button_edgecolor,'HorizontalAlignment','center')
            set(ui_button_edgecolor,'TooltipString','Brain region edge color')
            set(ui_button_edgecolor,'Callback',{@cb_edgecolor})
            
            ui_slider_edgealpha = uicontrol(f,'Style','slider');
            GUI.setUnits(ui_slider_edgealpha)
            GUI.setBackgroundColor(ui_slider_edgealpha)
            set(ui_slider_edgealpha,'Position',[.73 .430 .25 .05])
            set(ui_slider_edgealpha,'String','Brain transparency')
            set(ui_slider_edgealpha,'Min',0,'Max',1,'Value',.5)
            set(ui_slider_edgealpha,'TooltipString','Brain region edge transparency')
            set(ui_slider_edgealpha,'Callback',{@cb_edgealpha})
            
            ui_popup_line = uicontrol(f,'Style','popup','String',{''});
            GUI.setUnits(ui_popup_line)
            GUI.setBackgroundColor(ui_popup_line)
            set(ui_popup_line,'Position',[.50 .235 .48 .08])
            set(ui_popup_line,'String',GUI.PLOT_LINESTYLE_NAME)
            set(ui_popup_line,'Value',1)
            set(ui_popup_line,'TooltipString','Select line style');
            set(ui_popup_line,'Callback',{@cb_linestyle})
            
            ui_text_width = uicontrol(f,'Style','text');
            GUI.setUnits(ui_text_width)
            GUI.setBackgroundColor(ui_text_width)
            set(ui_text_width,'Position',[.50 .05 .15 .10])
            set(ui_text_width,'String','width')
            set(ui_text_width,'HorizontalAlignment','right')
            set(ui_text_width,'FontWeight','bold')
            
            ui_edit_width = uicontrol(f,'Style','edit');
            GUI.setUnits(ui_edit_width)
            GUI.setBackgroundColor(ui_edit_width)
            set(ui_edit_width,'Position',[.73 .065 .25 .10])
            set(ui_edit_width,'HorizontalAlignment','center')
            set(ui_edit_width,'FontWeight','bold')
            set(ui_edit_width,'String','1')
            set(ui_edit_width,'Callback',{@cb_linewidth})
            
            update_list()
            set(f,'Visible','on')
            
            function update_list()
                codes = {};
                for i = 1:1:pd.length()
                    if isa(pd.get(i),'PlotDataArea')
                        codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                    end
                end
                codes = codes(~cellfun(@isempty, codes));
                % Set list names
                set(ui_list,'String',codes)
            end
            function cb_list(~,~)  % (src,event)
            end
            function cb_show(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_area_on(get_list_data())
                pd.set_axes()
            end
            function cb_hide(~,~)  % (src,event)
                pd.get_axes();
                pd.plot_area_off(get_list_data())
                pd.set_axes()
            end
            function cb_facecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_area(get_list_data(),'FaceColor',color);
                end
            end
            function cb_facealpha(~,~)  % (src,event)
                pd.plot_area(get_list_data(),'FaceAlpha',get(ui_slider_facealpha,'Value'))
            end
            function cb_edgecolor(~,~)  % (src,event)
                color = uisetcolor();
                
                if length(color)==3
                    pd.plot_area(get_list_data(),'EdgeColor',color);
                end
            end
            function cb_edgealpha(~,~)  % (src,event)
                pd.plot_area(get_list_data(),'EdgeAlpha',get(ui_slider_edgealpha,'Value'))
            end
            function cb_linestyle(~,~)  % (src,event)
                style = GUI.PLOT_LINESTYLE_TAG{get(ui_popup_line,'Value')};
                pd.plot_area(get_list_data(),'EdgeStyle',style)
            end
            function cb_linewidth(~,~)  % (src,event)
                width = real(str2num(get(ui_edit_width,'String')));
                
                if isempty(width) || width<=0
                    set(ui_edit_width,'String','1')
                    width = 1;
                end
                pd.plot_area(get_list_data(),'EdgeWidth',width)
            end
            function data = get_list_data()
                if pd.length>0
                    codes = {};
                    for i = 1:1:pd.length()
                        if isa(pd.get(i),'PlotDataArea')
                            codes{1,i} = pd.get(i).getProp(PlotDataArea.CODE);
                        end
                    end
                    indices = find(~cellfun(@isempty,codes));
                    value = get(ui_list,'Value');
                    
                    data = indices(value);
                else
                    data = [];
                end
            end
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PlotData.
            %
            % See also PlotData, List.
            
            N = 8;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags
            %   of all properties of PlotData.
            %
            % See also PlotData, List.
            
            tags = {PlotData.NAME_TAG ...
                PlotData.XLABEL_TAG ...
                PlotData.YLABEL_TAG ...
                PlotData.FONT_SIZE_TAG ...
                PlotData.FONT_TYPE_TAG ...
                PlotData.FONT_WEIGHT_TAG ...
                PlotData.FONT_INTERPRETER_TAG ...
                PlotData.FONT_COLOR_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PlotData.
            %
            % See also PlotData, List.
            
            formats = {PlotData.NAME_FORMAT ...
                PlotData.XLABEL_FORMAT ...
                PlotData.YLABEL_FORMAT ...
                PlotData.FONT_SIZE_FORMAT ...
                PlotData.FONT_TYPE_FORMAT ...
                PlotData.FONT_WEIGHT_FORMAT ...
                PlotData.FONT_INTERPRETER_FORMAT ...
                PlotData.FONT_COLOR_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PlotData.
            %
            % See also PlotData, List.
            
            defaults = {PlotData.NAME_DEFAULT ...
                PlotData.XLABEL_DEFAULT ...
                PlotData.YLABEL_DEFAULT ...
                PlotData.FONT_SIZE_DEFAULT ...
                PlotData.FONT_TYPE_DEFAULT ...
                PlotData.FONT_WEIGHT_DEFAULT ...
                PlotData.FONT_INTERPRETER_DEFAULT ...
                PlotData.FONT_COLOR_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS() returns a cell array containing the options
            %   of the properties of PlotData.
            %   If there is not "options", it returns an empty cell array.
            %
            % See also PlotData, List.
                        
            switch prop
                case PlotData.FONT_TYPE
                    options = PlotData.FONT_TYPE_OPTIONS;
                case PlotData.FONT_WEIGHT
                    options = PlotData.FONT_WEIGHT_OPTIONS;
                case PlotData.FONT_INTERPRETER
                    options = PlotData.FONT_INTERPRETER_OPTIONS;
                otherwise
                    options = {};
            end
        end
        function class = elementClass()
            % ELEMENTCLASS element class
            %
            % CLASS = ELEMENTCLASS() returns the name of the element class,
            %   i.e., the string 'PlotDataElement'.
            %
            % See also PlotData, PlotDataElement.
            
            class = 'PlotDataElement';
        end
        function pde = element()
            % ELEMENT returns empty PlotDataElement
            %
            % PDE = ELEMENT() returns an empty PlotDataElement.
            %
            % See also PlotData, PlotDataElement.
            
            pde = PlotDataElement();
        end
    end
end