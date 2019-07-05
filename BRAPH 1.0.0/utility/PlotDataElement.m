classdef PlotDataElement < ListElement
    % PlotDataElement < ListElement : Element of a list to be plotted
    %   PlotDataElement creates and manages an element which data is to be plotted.
    %
    % PlotDataElement properties (Constants):
    %   CODE                    -   element code numeric code
    %   CODE_TAG                -   element code tag
    %   CODE_FORMAT             -   element code format
    %   CODE_DEFAULT            -   element code default value
    %
    %   X                       -   x data numeric code
    %   X_TAG                   -   x data tag
    %   X_FORMAT                -   x data format
    %   X_DEFAULT               -   x data default value
    %
    %   Y                       -   y data numeric code
    %   Y_TAG                   -   y data tag
    %   Y_FORMAT                -   y data format
    %   Y_DEFAULT               -   y data default value
    %
    %   NOTES                   -   name numeric code
    %   NOTES_TAG               -   name tag
    %   NOTES_FORMAT            -   name format
    %   NOTES_DEFAULT           -   name default value
    %
    %   SYM_MARKER              -   symbol type
    %                               (default = 'o')
    %   SYM_MARKER_TAG          -   symbol type tag
    %   SYM_MARKER_FORMAT       -   symbol type format
    %   SYM_MARKER_DEFAULT      -   symbol type default
    %    
    %   SYM_SIZE                -   symbol size
    %                               (default = 10)
    %   SYM_SIZE_TAG            -   symbol size tag    
    %   SYM_SIZE_FORMAT         -   symbol size format
    %   SYM_SIZE_DEFAULT        -   symbol size default
    %
    %   SYM_EDGE_COLOR          -   symbol edge color
    %                               (default = [0 0 1])
    %   SYM_EDGE_COLOR_TAG      -   symbol edge color tag
    %   SYM_EDGE_COLOR_FORMAT   -   symbol edge color format
    %   SYM_EDGE_COLOR_DEFAULT  -   symbol edge color default
    %
    %   SYM_FACE_COLOR          -   symbol face color
    %                               (default = [0 0 1])
    %   SYM_FACE_COLOR_TAG      -   symbol face color tag
    %   SYM_FACE_COLOR_FORMAT   -   symbol face color format
    %   SYM_FACE_COLOR_DEFAULT  -   symbol face color default
    %
    %   LIN_STYLE               -   line style
    %                               (default = '-')
    %   LIN_STYLE_TAG           -   line style tag
    %   LIN_STYLE_FORMAT        -   line style format
    %   LIN_STYLE_DEFAULT       -   line style default
    %
    %   LIN_WIDTH               -   line width
    %                               (default = 1)
    %   LIN_WIDTH_TAG           -   line width tag
    %   LIN_WIDTH_FORMAT        -   line width format
    %   LIN_WIDTH_DEFAULT       -   line width default
    %    
    %   LIN_COLOR               -   line color
    %                               (default = [0 0 1])
    %   LIN_COLOR_TAG           -   line color tag
    %   LIN_COLOR_FORMAT        -   line color format
    %   LIN_COLOR_DEFAULT       -   line color default
    %
    % PlotData properties (Access = protected):
    %   props                 -   cell array of object properties < ListElement
    %   h_plot                -   handle for the plot
    %
    % PlotData methods ():
    %   PlotDataElement       -   constructor
    %   setProp               -   sets property value < ListElement
    %   getProp               -   gets property value, format and tag < ListElement
    %   getPropValue          -   string of property value < ListElement
    %   getPropFormat         -   string of property format < ListElement
    %   getPropTag            -   string of property tag < ListElement
    %   disp                  -   displays element of a plot data list
    %   getDataLength         -   gets length of the data
    %   getPlotHandle         -   gets handle of the plot
    %   setPlotHandle         -   sets handle of the plot
    %
    % PlotData methods (Static):
    %   cleanXML              -   removes whitespace nodes from xmlread < ListElement
    %   propnumber            -   number of properties
    %   getTags               -   cell array of strings with the tags of the properties
    %   getFormats            -   cell array with the formats of the properties
    %   getDefaults           -   cell array with the defaults of the properties
    %   getOptions            -   cell array with options (only for properties with options format)
    %
    % See also List, ListElement, PlotData.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        
        % few-letter code (unique for each subject)
        CODE = 1
        CODE_TAG = 'code'
        CODE_FORMAT = BNC.CHAR
        CODE_DEFAULT = 'plot element code'
        
        % X data values
        X = 2
        X_TAG = 'xvalues'
        X_FORMAT = BNC.NUMERIC
        X_DEFAULT = []
        
        % Y data values
        Y = 3
        Y_TAG = 'yvalues'
        Y_FORMAT = BNC.NUMERIC
        Y_DEFAULT = []
        
        % notes
        NOTES = 4
        NOTES_TAG = 'notes'
        NOTES_FORMAT = BNC.CHAR
        NOTES_DEFAULT = '---'
        
        % Symbols
        SYM_MARKER = 5
        SYM_MARKER_TAG = 'symbol_type'
        SYM_MARKER_FORMAT = BNC.OPTIONS
        SYM_MARKER_OPTIONS = GUI.PLOT_SYMBOL_TAG
        SYM_MARKER_DEFAULT = GUI.PLOT_SYMBOL_TAG{2}
        
        SYM_SIZE = 6
        SYM_SIZE_TAG = 'marker_size'
        SYM_SIZE_FORMAT = BNC.NUMERIC
        SYM_SIZE_DEFAULT = 10
        
        SYM_EDGE_COLOR = 7
        SYM_EDGE_COLOR_TAG = 'marker_edge_color'
        SYM_EDGE_COLOR_FORMAT = BNC.NUMERIC
        SYM_EDGE_COLOR_DEFAULT = [0 0 1]
        
        SYM_FACE_COLOR = 8
        SYM_FACE_COLOR_TAG = 'marker_face_color'
        SYM_FACE_COLOR_FORMAT = BNC.NUMERIC
        SYM_FACE_COLOR_DEFAULT = BNC.COLOR
        
        % Line
        LIN_STYLE = 9
        LIN_STYLE_TAG = 'line_style'
        LIN_STYLE_FORMAT = BNC.OPTIONS
        LIN_STYLE_OPTIONS = GUI.PLOT_LINESTYLE_TAG
        LIN_STYLE_DEFAULT = GUI.PLOT_LINESTYLE_TAG{1}
        
        LIN_WIDTH = 10
        LIN_WIDTH_TAG = 'line_width'
        LIN_WIDTH_FORMAT = BNC.NUMERIC
        LIN_WIDTH_DEFAULT = 1
        
        LIN_COLOR = 11
        LIN_COLOR_TAG = 'line_color'
        LIN_COLOR_FORMAT = BNC.NUMERIC
        LIN_COLOR_DEFAULT = [0 0 1]
    end
    properties (Access = protected)
        h  % handle for the data plot
    end
    methods (Access = protected)
        function cp = copyElement(pde)
            % COPYELEMENT makes a deep copy of the list.
            %
            % CP = COPYELEMENT(List) makes a deep copy of the list.
            %
            % See also List, matlab.mixin.Copyable, copy, handle.
            
            % Make a shallow copy
            cp = copyElement@ListElement(pde);
            % resets the graphic handles
            cp.h = NaN;
        end
    end    
    methods
        function pde = PlotDataElement(varargin)
            % PlotDataElement() creates and manages an element which data
            %   is to be plotted.
            %   The data of the element can be plotted after adding the element
            %   to a list by using symbols and lines.
            %
            % See also PlotDataElement.
            
            pde = pde@ListElement(varargin{:});
            
            pde.h = NaN;
        end
        function l = getDataLength(pde)
            % GETDATALENGTH gets length of the data
            %
            % [Xl,Yl] = GETDATALENGTH(PDE) returns the length of the x - values data of the
            %   list element PDE as XL and the length of the y - values data as YL.
            %
            % See also PlotDataElement, length.
            
            l = length(getProp(pde.X));
        end
        function h = getDataHandle(pde)
            % GETPLOTHANDLE gets handle of the plot
            %
            % H = GETPLOTHANDLE(PDE) returns the handle of the plot containing
            %   the list element PDE.
            %
            % See also PlotDataElement.
            
            h = pde.h;
        end
        function setDataHandle(pde,h)
            % SETPLOTHANDLE sets handle of the plot
            %
            % SETPLOTHANDLE(PDE,H) sets the handle of the plot containing
            %   the list element PDE to H.
            %
            % See also PlotDataElement.
            
            pde.h = h;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PlotDataElement.
            %
            % See also PlotDataElement.
            
            N = 11;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags
            %   of all properties of PlotDataElement.
            %
            % See also PlotDataElement, ListElement.
            
            tags = {PlotDataElement.CODE_TAG ...
                PlotDataElement.X_TAG ...
                PlotDataElement.Y_TAG ...
                PlotDataElement.NOTES_TAG ...
                PlotDataElement.SYM_MARKER_TAG ...
                PlotDataElement.SYM_SIZE_TAG ...
                PlotDataElement.SYM_EDGE_COLOR_TAG ...
                PlotDataElement.SYM_FACE_COLOR_TAG ...
                PlotDataElement.LIN_STYLE_TAG ...
                PlotDataElement.LIN_WIDTH_TAG ...
                PlotDataElement.LIN_COLOR_TAG};
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PlotDataElement.
            %
            % See also PlotDataElement, ListElement.
            
            formats = {PlotDataElement.CODE_FORMAT ...
                PlotDataElement.X_FORMAT ...
                PlotDataElement.Y_FORMAT ...
                PlotDataElement.NOTES_FORMAT ...
                PlotDataElement.SYM_MARKER_FORMAT ...
                PlotDataElement.SYM_SIZE_FORMAT ...
                PlotDataElement.SYM_EDGE_COLOR_FORMAT ...
                PlotDataElement.SYM_FACE_COLOR_FORMAT ...
                PlotDataElement.LIN_STYLE_FORMAT ...
                PlotDataElement.LIN_WIDTH_FORMAT ...
                PlotDataElement.LIN_COLOR_FORMAT};
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PlotDataElement.
            %
            % See also PlotDataElement, ListElement.
            
            defaults = {PlotDataElement.CODE_DEFAULT ...
                PlotDataElement.X_DEFAULT ...
                PlotDataElement.Y_DEFAULT ...
                PlotDataElement.NOTES_DEFAULT ...
                PlotDataElement.SYM_MARKER_DEFAULT ...
                PlotDataElement.SYM_SIZE_DEFAULT ...
                PlotDataElement.SYM_EDGE_COLOR_DEFAULT ...
                PlotDataElement.SYM_FACE_COLOR_DEFAULT ...
                PlotDataElement.LIN_STYLE_DEFAULT ...
                PlotDataElement.LIN_WIDTH_DEFAULT ...
                PlotDataElement.LIN_COLOR_DEFAULT};
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties of PlotDataElement.
            %   If the PROP is not "options", it returns an empty cell array.
            %
            % See also PlotDataElement, ListElement.
            
            switch prop
                case PlotDataElement.SYM_MARKER
                    options = PlotDataElement.SYM_MARKER_OPTIONS;
                case PlotDataElement.LIN_STYLE
                    options = PlotDataElement.LIN_STYLE_OPTIONS;
                otherwise
                    options = {};
            end
        end
    end
end