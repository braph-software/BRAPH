classdef PlotDataArea < PlotDataElement
    % PlotDataArea < PlotDataElement : Area of a list to be plotted
    %   PlotDataArea creates and manages an area element which data is to be plotted.
    %
    % PlotDataArea properties (Constants):
    %   Y_HIGH                      -   high boundary numeric code
    %   Y_HIGH_TAG                  -   high boundary tag
    %   Y_HIGH_FORMAT               -   high boundary format
    %   Y_HIGH_DEFAULT              -   high boundary default value
    %
    %   Y_LOW                       -   low boundary numeric code
    %   Y_LOW_TAG                   -   low boundary tag
    %   Y_LOW_FORMAT                -   low boundary format
    %   Y_LOW_DEFAULT               -   low boundary default value
    %
    %   Y_MID                       -   middle line numeric code
    %   Y_MID_TAG                   -   middle line tag
    %   Y_MID_FORMAT                -   middle line format
    %   Y_MID_DEFAULT               -   middle line default value
    %
    %   AREA_FACE_COLOR             -   area face color
    %                                   (default = [0 0 1])
    %   AREA_FACE_COLOR_TAG         -   area face color tag
    %   AREA_FACE_COLOR_FORMAT      -   area face color format
    %   AREA_FACE_COLOR_DEFAULT     -   area face color default
    %
    %   AREA_FACE_ALPHA             -   area face alpha
    %                                   (default = 1)
    %   AREA_FACE_ALPHA_TAG         -   area face alpha tag
    %   AREA_FACE_ALPHA_FORMAT      -   area face alpha format
    %   AREA_FACE_ALPHA_DEFAULT     -   area face alpha default
    %
    %   AREA_EDGE_COLOR             -   area edge color
    %                                   (default = [0 0 1])
    %   AREA_EDGE_COLOR_TAG         -   area edge color tag
    %   AREA_EDGE_COLOR_FORMAT      -   area edge color format
    %   AREA_EDGE_COLOR_DEFAULT     -   area edge color default
    %
    %   AREA_EDGE_ALPHA             -   area edge alpha
    %                                   (default = 1)
    %   AREA_EDGE_ALPHA_TAG         -   area edge alpha tag
    %   AREA_EDGE_ALPHA_FORMAT      -   area edge alpha format
    %   AREA_EDGE_ALPHA_DEFAULT     -   area edge alpha default
    %
    %   AREA_EDGE_STYLE             -   area edge style
    %                                   (default = '-')
    %   AREA_EDGE_STYLE_TAG         -   area edge tag
    %   AREA_EDGE_STYLE_FORMAT      -   area edge format
    %   AREA_EDGE_STYLE_DEFAULT     -   area edge default
    %
    %   AREA_EDGE_WIDTH             -   area edge width
    %                                   (default = 1)
    %   AREA_EDGE_WIDTH_TAG         -   area edge width tag
    %   AREA_EDGE_WIDTH_FORMAT      -   area edge width format
    %   AREA_EDGE_WIDTH_DEFAULT     -   area edge width default
    %
    %   HIGH_SYM_MARKER             -   high boundary symbol type
    %                                   (default = 'o')
    %   HIGH_SYM_MARKER_TAG         -   high boundary symbol type tag
    %   HIGH_SYM_MARKER_FORMAT      -   high boundary symbol type format
    %   HIGH_SYM_MARKER_DEFAULT     -   high boundary symbol type default
    %
    %   HIGH_SYM_SIZE               -   high boundary symbol size
    %                                   (default = 10)
    %   HIGH_SYM_SIZE_TAG           -   high boundary symbol size tag
    %   HIGH_SYM_SIZE_FORMAT        -   high boundary symbol size format
    %   HIGH_SYM_SIZE_DEFAULT       -   high boundary symbol size default
    %
    %   HIGH_SYM_EDGE_COLOR         -   high boundary symbol edge color
    %                                   (default = [0 0 1])
    %   HIGH_SYM_EDGE_COLOR_TAG     -   high boundary symbol edge color tag
    %   HIGH_SYM_EDGE_COLOR_FORMAT  -   high boundary symbol edge color format
    %   HIGH_SYM_EDGE_COLOR_DEFAULT -   high boundary symbol edge color default
    %
    %   HIGH_SYM_FACE_COLOR         -   high boundary symbol face color
    %                                   (default = [0 0 1])
    %   HIGH_SYM_FACE_COLOR_TAG     -   high boundary symbol face color tag
    %   HIGH_SYM_FACE_COLOR_FORMAT  -   high boundary symbol face color format
    %   HIGH_SYM_FACE_COLOR_DEFAULT -   high boundary symbol face color default
    %
    %   HIGH_LIN_STYLE              -   high boundary line style
    %                                   (default = '-')
    %   HIGH_LIN_STYLE_TAG          -   high boundary line style tag
    %   HIGH_LIN_STYLE_FORMAT       -   high boundary line style format
    %   HIGH_LIN_STYLE_DEFAULT      -   high boundary line style default
    %
    %   HIGH_LIN_WIDTH              -   high boundary line width
    %                                   (default = 1)
    %   HIGH_LIN_WIDTH_TAG          -   high boundary line width tag
    %   HIGH_LIN_WIDTH_FORMAT       -   high boundary line width format
    %   HIGH_LIN_WIDTH_DEFAULT      -   high boundary line width default
    %
    %   HIGH_LIN_COLOR              -   high boundary line color
    %                                   (default = [0 0 1])
    %   HIGH_LIN_COLOR_TAG          -   high boundary line color tag
    %   HIGH_LIN_COLOR_FORMAT       -   high boundary line color format
    %   HIGH_LIN_COLOR_DEFAULT      -   high boundary line color default
    %
    %   LOW_SYM_MARKER             -   low boundary symbol type
    %                                  (default = 'o')
    %   LOW_SYM_MARKER_TAG         -   low boundary symbol type tag
    %   LOW_SYM_MARKER_FORMAT      -   low boundary symbol type format
    %   LOW_SYM_MARKER_DEFAULT     -   low boundary symbol type default
    %
    %   LOW_SYM_SIZE               -   low boundary symbol size
    %                                  (default = 10)
    %   LOW_SYM_SIZE_TAG           -   low boundary symbol size tag
    %   LOW_SYM_SIZE_FORMAT        -   low boundary symbol size format
    %   LOW_SYM_SIZE_DEFAULT       -   low boundary symbol size default
    %
    %   LOW_SYM_EDGE_COLOR         -   low boundary symbol edge color
    %                                  (default = [0 0 1])
    %   LOW_SYM_EDGE_COLOR_TAG     -   low boundary symbol edge color tag
    %   LOW_SYM_EDGE_COLOR_FORMAT  -   low boundary symbol edge color format
    %   LOW_SYM_EDGE_COLOR_DEFAULT -   low boundary symbol edge color default
    %
    %   LOW_SYM_FACE_COLOR         -   low boundary symbol face color
    %                                  (default = [0 0 1])
    %   LOW_SYM_FACE_COLOR_TAG     -   low boundary symbol face color tag
    %   LOW_SYM_FACE_COLOR_FORMAT  -   low boundary symbol face color format
    %   LOW_SYM_FACE_COLOR_DEFAULT -   low boundary symbol face color default
    %
    %   LOW_LIN_STYLE              -   low boundary line style
    %                                  (default = '-')
    %   LOW_LIN_STYLE_TAG          -   low boundary line style tag
    %   LOW_LIN_STYLE_FORMAT       -   low boundary line style format
    %   LOW_LIN_STYLE_DEFAULT      -   low boundary line style default
    %
    %   LOW_LIN_WIDTH              -   low boundary line width
    %                                  (default = 1)
    %   LOW_LIN_WIDTH_TAG          -   low boundary line width tag
    %   LOW_LIN_WIDTH_FORMAT       -   low boundary line width format
    %   LOW_LIN_WIDTH_DEFAULT      -   low boundary line width default
    %
    %   LOW_LIN_COLOR              -   low boundary line color
    %                                  (default = [0 0 1])
    %   LOW_LIN_COLOR_TAG          -   low boundary line color tag
    %   LOW_LIN_COLOR_FORMAT       -   low boundary line color format
    %   LOW_LIN_COLOR_DEFAULT      -   low boundary line color default
    %
    %   MID_SYM_MARKER             -   middle line symbol type
    %                                  (default = 'o')
    %   MID_SYM_MARKER_TAG         -   middle line symbol type tag
    %   MID_SYM_MARKER_FORMAT      -   middle line symbol type format
    %   MID_SYM_MARKER_DEFAULT     -   middle line symbol type default
    %
    %   MID_SYM_SIZE               -   middle line symbol size
    %                                  (default = 10)
    %   MID_SYM_SIZE_TAG           -   middle line symbol size tag
    %   MID_SYM_SIZE_FORMAT        -   middle line symbol size format
    %   MID_SYM_SIZE_DEFAULT       -   middle line symbol size default
    %
    %   MID_SYM_EDGE_COLOR         -   middle line symbol edge color
    %                                  (default = [0 0 1])
    %   MID_SYM_EDGE_COLOR_TAG     -   middle line symbol edge color tag
    %   MID_SYM_EDGE_COLOR_FORMAT  -   middle line symbol edge color format
    %   MID_SYM_EDGE_COLOR_DEFAULT -   middle line symbol edge color default
    %
    %   MID_SYM_FACE_COLOR         -   middle line symbol face color
    %                                  (default = [0 0 1])
    %   MID_SYM_FACE_COLOR_TAG     -   middle line symbol face color tag
    %   MID_SYM_FACE_COLOR_FORMAT  -   middle line symbol face color format
    %   MID_SYM_FACE_COLOR_DEFAULT -   middle line symbol face color default
    %
    %   MID_LIN_STYLE              -   middle line line style
    %                                  (default = '-')
    %   MID_LIN_STYLE_TAG          -   middle line line style tag
    %   MID_LIN_STYLE_FORMAT       -   middle line line style format
    %   MID_LIN_STYLE_DEFAULT      -   middle line line style default
    %
    %   MID_LIN_WIDTH              -   middle line line width
    %                                  (default = 1)
    %   MID_LIN_WIDTH_TAG          -   middle line line width tag
    %   MID_LIN_WIDTH_FORMAT       -   middle line line width format
    %   MID_LIN_WIDTH_DEFAULT      -   middle line line width default
    %
    %   MID_LIN_COLOR              -   middle line line color
    %                                  (default = [0 0 1])
    %   MID_LIN_COLOR_TAG          -   middle line line color tag
    %   MID_LIN_COLOR_FORMAT       -   middle line line color format
    %   MID_LIN_COLOR_DEFAULT      -   middle line line color default
    %
    % PlotDataArea properties (Access = protected):
    %   props                 -   cell array of object properties < ListElement
    %   h_plot                -   handle for the plot < PlotDataElement
    %   h_high                -   handle for high boundary
    %   h_low                 -   handle for low boundary
    %   h_mid                 -   handle for middle line
    %   h_area                -   handle for the area plot
    %
    % PlotDataArea methods (Access = protected):
    %   copyElement           -   makes a deep copy of the list
    %
    % PlotDataArea methods ():
    %   PlotDataArea          -   constructor
    %   setProp               -   sets property value < ListElement
    %   getProp               -   gets property value, format and tag < ListElement
    %   getPropValue          -   string of property value < ListElement
    %   getPropFormat         -   string of property format < ListElement
    %   getPropTag            -   string of property tag < ListElement
    %   disp                  -   displays element of a plot data list < PlotDataElement
    %   getDataLength         -   gets length of the data < PlotDataElement
    %   getPlotHandle         -   gets handle of the plot < PlotDataElement
    %   setPlotHandle         -   sets handle of the plot < PlotDataElement
    %   getYHighHandle        -   gets handle of the high boundary
    %   setYHighHandle        -   sets handle of the high boundary
    %   getYLowHandle         -   gets handle of the low boundary
    %   setYLowHandle         -   sets handle of the low boundary
    %   getYMidHandle         -   gets handle of the middle line
    %   setYMidHandle         -   sets handle of the middle line
    %   getAreaHandle         -   gets handle of the area
    %   setAreaHandle         -   sets handle of the area
    %
    % PlotDataArea methods (Static):
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
        
        % Y high data values
        Y_HIGH = PlotDataElement.propnumber() + 1
        Y_HIGH_TAG = 'y_high_values'
        Y_HIGH_FORMAT = BNC.NUMERIC
        Y_HIGH_DEFAULT = []
        
        % Y low data values
        Y_LOW = PlotDataElement.propnumber() + 2
        Y_LOW_TAG = 'y_low_values'
        Y_LOW_FORMAT = BNC.NUMERIC
        Y_LOW_DEFAULT = []
        
        % Y mid data values
        Y_MID = PlotDataElement.propnumber() + 3
        Y_MID_TAG = 'y_mid_values'
        Y_MID_FORMAT = BNC.NUMERIC
        Y_MID_DEFAULT = []
        
        % Area
        AREA_FACE_COLOR = PlotDataElement.propnumber() + 4
        AREA_FACE_COLOR_TAG = 'face_color'
        AREA_FACE_COLOR_FORMAT = BNC.NUMERIC
        AREA_FACE_COLOR_DEFAULT = [0 0 1]
        
        AREA_FACE_ALPHA = PlotDataElement.propnumber() + 5
        AREA_FACE_ALPHA_TAG = 'face_alpha'
        AREA_FACE_ALPHA_FORMAT = BNC.NUMERIC
        AREA_FACE_ALPHA_DEFAULT = 1
        
        AREA_EDGE_COLOR = PlotDataElement.propnumber() + 6
        AREA_EDGE_COLOR_TAG = 'edge_color'
        AREA_EDGE_COLOR_FORMAT = BNC.NUMERIC
        AREA_EDGE_COLOR_DEFAULT = [0 0 1]
        
        AREA_EDGE_ALPHA = PlotDataElement.propnumber() + 7
        AREA_EDGE_ALPHA_TAG = 'edge_alpha'
        AREA_EDGE_ALPHA_FORMAT = BNC.NUMERIC
        AREA_EDGE_ALPHA_DEFAULT = 1
        
        AREA_EDGE_STYLE = PlotDataElement.propnumber() + 8
        AREA_EDGE_STYLE_TAG = 'edge_style'
        AREA_EDGE_STYLE_FORMAT = BNC.CHAR
        AREA_EDGE_STYLE_OPTIONS = GUI.PLOT_LINESTYLE_TAG
        AREA_EDGE_STYLE_DEFAULT = GUI.PLOT_LINESTYLE_TAG{1}
        
        AREA_EDGE_WIDTH = PlotDataElement.propnumber() + 9
        AREA_EDGE_WIDTH_TAG = 'edge_width'
        AREA_EDGE_WIDTH_FORMAT = BNC.NUMERIC
        AREA_EDGE_WIDTH_DEFAULT = 1
        
        % Symbols
        HIGH_SYM_MARKER = PlotDataElement.propnumber() + 10
        HIGH_SYM_MARKER_TAG = 'symbol_type'
        HIGH_SYM_MARKER_FORMAT = BNC.OPTIONS
        HIGH_SYM_MARKER_OPTIONS = GUI.PLOT_SYMBOL_TAG
        HIGH_SYM_MARKER_DEFAULT = GUI.PLOT_SYMBOL_TAG{2}
        
        HIGH_SYM_SIZE = PlotDataElement.propnumber() + 11
        HIGH_SYM_SIZE_TAG = 'marker_size'
        HIGH_SYM_SIZE_FORMAT = BNC.NUMERIC
        HIGH_SYM_SIZE_DEFAULT = 10
        
        HIGH_SYM_EDGE_COLOR = PlotDataElement.propnumber() + 12
        HIGH_SYM_EDGE_COLOR_TAG = 'marker_edge_color'
        HIGH_SYM_EDGE_COLOR_FORMAT = BNC.NUMERIC
        HIGH_SYM_EDGE_COLOR_DEFAULT = [0 0 1]
        
        HIGH_SYM_FACE_COLOR = PlotDataElement.propnumber() + 13
        HIGH_SYM_FACE_COLOR_TAG = 'marker_face_color'
        HIGH_SYM_FACE_COLOR_FORMAT = BNC.NUMERIC
        HIGH_SYM_FACE_COLOR_DEFAULT = BNC.COLOR
        
        % Line
        HIGH_LIN_STYLE = PlotDataElement.propnumber() + 14
        HIGH_LIN_STYLE_TAG = 'line_style'
        HIGH_LIN_STYLE_FORMAT = BNC.OPTIONS
        HIGH_LIN_STYLE_OPTIONS = GUI.PLOT_LINESTYLE_TAG
        HIGH_LIN_STYLE_DEFAULT = GUI.PLOT_LINESTYLE_TAG{1}
        
        HIGH_LIN_WIDTH = PlotDataElement.propnumber() + 15
        HIGH_LIN_WIDTH_TAG = 'line_width'
        HIGH_LIN_WIDTH_FORMAT = BNC.NUMERIC
        HIGH_LIN_WIDTH_DEFAULT = 1
        
        HIGH_LIN_COLOR = PlotDataElement.propnumber() + 16
        HIGH_LIN_COLOR_TAG = 'line_color'
        HIGH_LIN_COLOR_FORMAT = BNC.NUMERIC
        HIGH_LIN_COLOR_DEFAULT = [0 0 1]
        
        % Symbols
        LOW_SYM_MARKER = PlotDataElement.propnumber() + 17
        LOW_SYM_MARKER_TAG = 'symbol_type'
        LOW_SYM_MARKER_FORMAT = BNC.OPTIONS
        LOW_SYM_MARKER_OPTIONS = GUI.PLOT_SYMBOL_TAG
        LOW_SYM_MARKER_DEFAULT = GUI.PLOT_SYMBOL_TAG{2}
        
        LOW_SYM_SIZE = PlotDataElement.propnumber() + 18
        LOW_SYM_SIZE_TAG = 'marker_size'
        LOW_SYM_SIZE_FORMAT = BNC.NUMERIC
        LOW_SYM_SIZE_DEFAULT = 10
        
        LOW_SYM_EDGE_COLOR = PlotDataElement.propnumber() + 19
        LOW_SYM_EDGE_COLOR_TAG = 'marker_edge_color'
        LOW_SYM_EDGE_COLOR_FORMAT = BNC.NUMERIC
        LOW_SYM_EDGE_COLOR_DEFAULT = [0 0 1]
        
        LOW_SYM_FACE_COLOR = PlotDataElement.propnumber() + 20
        LOW_SYM_FACE_COLOR_TAG = 'marker_face_color'
        LOW_SYM_FACE_COLOR_FORMAT = BNC.NUMERIC
        LOW_SYM_FACE_COLOR_DEFAULT = BNC.COLOR
        
        % Line
        LOW_LIN_STYLE = PlotDataElement.propnumber() + 21
        LOW_LIN_STYLE_TAG = 'line_style'
        LOW_LIN_STYLE_FORMAT = BNC.OPTIONS
        LOW_LIN_STYLE_OPTIONS = GUI.PLOT_LINESTYLE_TAG
        LOW_LIN_STYLE_DEFAULT = GUI.PLOT_LINESTYLE_TAG{1}
        
        LOW_LIN_WIDTH = PlotDataElement.propnumber() + 22
        LOW_LIN_WIDTH_TAG = 'line_width'
        LOW_LIN_WIDTH_FORMAT = BNC.NUMERIC
        LOW_LIN_WIDTH_DEFAULT = 1
        
        LOW_LIN_COLOR = PlotDataElement.propnumber() + 23
        LOW_LIN_COLOR_TAG = 'line_color'
        LOW_LIN_COLOR_FORMAT = BNC.NUMERIC
        LOW_LIN_COLOR_DEFAULT = [0 0 1]
        
        % Symbols
        MID_SYM_MARKER = PlotDataElement.propnumber() + 24
        MID_SYM_MARKER_TAG = 'symbol_type'
        MID_SYM_MARKER_FORMAT = BNC.OPTIONS
        MID_SYM_MARKER_OPTIONS = GUI.PLOT_SYMBOL_TAG
        MID_SYM_MARKER_DEFAULT = GUI.PLOT_SYMBOL_TAG{2}
        
        MID_SYM_SIZE = PlotDataElement.propnumber() + 25
        MID_SYM_SIZE_TAG = 'marker_size'
        MID_SYM_SIZE_FORMAT = BNC.NUMERIC
        MID_SYM_SIZE_DEFAULT = 10
        
        MID_SYM_EDGE_COLOR = PlotDataElement.propnumber() + 26
        MID_SYM_EDGE_COLOR_TAG = 'marker_edge_color'
        MID_SYM_EDGE_COLOR_FORMAT = BNC.NUMERIC
        MID_SYM_EDGE_COLOR_DEFAULT = [0 0 1]
        
        MID_SYM_FACE_COLOR = PlotDataElement.propnumber() + 27
        MID_SYM_FACE_COLOR_TAG = 'marker_face_color'
        MID_SYM_FACE_COLOR_FORMAT = BNC.NUMERIC
        MID_SYM_FACE_COLOR_DEFAULT = BNC.COLOR
        
        % Line
        MID_LIN_STYLE = PlotDataElement.propnumber() + 28
        MID_LIN_STYLE_TAG = 'line_style'
        MID_LIN_STYLE_FORMAT = BNC.OPTIONS
        MID_LIN_STYLE_OPTIONS = GUI.PLOT_LINESTYLE_TAG
        MID_LIN_STYLE_DEFAULT = GUI.PLOT_LINESTYLE_TAG{1}
        
        MID_LIN_WIDTH = PlotDataElement.propnumber() + 29
        MID_LIN_WIDTH_TAG = 'line_width'
        MID_LIN_WIDTH_FORMAT = BNC.NUMERIC
        MID_LIN_WIDTH_DEFAULT = 1
        
        MID_LIN_COLOR = PlotDataElement.propnumber() + 30
        MID_LIN_COLOR_TAG = 'line_color'
        MID_LIN_COLOR_FORMAT = BNC.NUMERIC
        MID_LIN_COLOR_DEFAULT = [0 0 1]
    end
    properties (Access = protected)
        h_high  % handle for high boundary
        h_low  % handle for low boundary
        h_mid  % handle for middle line
        h_area  % handle for the area plot
    end
    methods (Access = protected)
        function cp = copyElement(pda)
            % COPYELEMENT makes a deep copy of the list.
            %
            % CP = COPYELEMENT(List) makes a deep copy of the list.
            %
            % See also List, matlab.mixin.Copyable, copy, handle.
            
            % Make a shallow copy
            cp = copyElement@PlotDataElement(pda);
            % resets the graphic handles
            cp.h_high = NaN;
            cp.h_low = NaN;
            cp.h_mid = NaN;
            cp.h_area = NaN;
        end
    end
    methods
        function pda = PlotDataArea(varargin)
            % PlotDataArea() creates and manages an area element which data
            %   is to be plotted.
            %   The area can be plotted after adding the element
            %   to a list by using symbols and lines.
            %
            % See also PlotDataArea.
            
            pda = pda@PlotDataElement(varargin{:});
            
            pda.h_area = NaN;
            pda.h_high = NaN;
            pda.h_low = NaN;
            pda.h_mid = NaN;
        end
        function h = getYHighHandle(pda)
            % GETYHIGHHANDLE gets handle of the high boundary
            %
            % H = GETYHIGHHANDLE(PDA) returns the handle of the high boundary
            %   of the area element PDA.
            %
            % See also PlotDataArea.
            
            h = pda.h_high;
        end
        function setYHighHandle(pda,h)
            % SETYHIGHHANDLE sets handle of the high boundary
            %
            % SETYHIGHHANDLE(PDA,H) sets the handle of the high boundary
            %   of the area element PDA to H.
            %
            % See also PlotDataArea.
            
            pda.h_high = h;
        end
        function h = getYLowHandle(pda)
            % GETYLOWHANDLE gets handle of the low boundary
            %
            % H = GETYLOWHANDLE(PDA) returns the handle of the low boundary
            %   of the area element PDA.
            %
            % See also PlotDataArea.
            
            h = pda.h_low;
        end
        function setYLowHandle(pda,h)
            % SETYLOWHANDLE sets handle of the low boundary
            %
            % SETYLOWHANDLE(PDA,H) sets the handle of the low boundary
            %   of the area element PDA to H.
            %
            % See also PlotDataArea.
            
            pda.h_low = h;
        end
        function h = getYMidHandle(pda)
            % GETYMIDHANDLE gets handle of the middle line
            %
            % H = GETYMIDHANDLE(PDA) returns the handle of the middle line
            %   of the area element PDA.
            %
            % See also PlotDataArea.
            
            h = pda.h_mid;
        end
        function setYMidHandle(pda,h)
            % SETYMIDHANDLE sets handle of the middle line
            %
            % SETYMIDHANDLE(PDA,H) sets the handle of the middle line
            %   of the area element PDA to H.
            %
            % See also PlotDataArea.
            
            pda.h_mid = h;
        end
        function h = getAreaHandle(pda)
            % GETAREAHANDLE gets handle of the area
            %
            % H = GETAREAHANDLE(PDA) returns the handle of the area
            %   of the area element PDA to H.
            %
            % See also PlotDataArea.
            
            h = pda.h_area;
        end
        function setAreaHandle(pda,h)
            % SETAREAHANDLE sets handle of the area
            %
            % SETAREAHANDLE(PDA,H) sets the handle of the area
            %   of the area element PDA to H.
            %
            % See also PlotDataArea.
            
            pda.h_area = h;
        end
    end
    methods (Static)
        function N = propnumber()
            % PROPNUMBER number of properties
            %
            % N = PROPNUMBER() gets the total number of properties of PlotDataArea.
            %
            % See also PlotDataArea.
            
            N = PlotDataElement.propnumber() + 30;
        end
        function tags = getTags()
            % GETTAGS cell array of strings with the properties' tags
            %
            % TAGS = GETTAGS() returns a cell array of strings with the tags
            %   of all properties of PlotDataArea.
            %
            % See also PlotDataArea, PlotDataElement, ListElement.
            
            tags = [ PlotDataElement.getTags() ...
                { ...
                PlotDataArea.Y_HIGH_TAG ...
                PlotDataArea.Y_LOW_TAG ...
                PlotDataArea.Y_MID_TAG ...
                PlotDataArea.AREA_FACE_COLOR_TAG ...
                PlotDataArea.AREA_FACE_ALPHA_TAG ...
                PlotDataArea.AREA_EDGE_COLOR_TAG ...
                PlotDataArea.AREA_EDGE_ALPHA_TAG ...
                PlotDataArea.AREA_EDGE_STYLE_TAG ...
                PlotDataArea.AREA_EDGE_WIDTH_TAG ...
                PlotDataArea.HIGH_SYM_MARKER_TAG ...
                PlotDataArea.HIGH_SYM_SIZE_TAG ...
                PlotDataArea.HIGH_SYM_EDGE_COLOR_TAG ...
                PlotDataArea.HIGH_SYM_FACE_COLOR_TAG ...
                PlotDataArea.HIGH_LIN_STYLE_TAG ...
                PlotDataArea.HIGH_LIN_WIDTH_TAG ...
                PlotDataArea.HIGH_LIN_COLOR_TAG ...
                PlotDataArea.LOW_SYM_MARKER_TAG ...
                PlotDataArea.LOW_SYM_SIZE_TAG ...
                PlotDataArea.LOW_SYM_EDGE_COLOR_TAG ...
                PlotDataArea.LOW_SYM_FACE_COLOR_TAG ...
                PlotDataArea.LOW_LIN_STYLE_TAG ...
                PlotDataArea.LOW_LIN_WIDTH_TAG ...
                PlotDataArea.LOW_LIN_COLOR_TAG ...
                PlotDataArea.MID_SYM_MARKER_TAG ...
                PlotDataArea.MID_SYM_SIZE_TAG ...
                PlotDataArea.MID_SYM_EDGE_COLOR_TAG ...
                PlotDataArea.MID_SYM_FACE_COLOR_TAG ...
                PlotDataArea.MID_LIN_STYLE_TAG ...
                PlotDataArea.MID_LIN_WIDTH_TAG ...
                PlotDataArea.MID_LIN_COLOR_TAG ...
                } ...
                ];
        end
        function formats = getFormats()
            % GETFORMATS cell array with the formats of the properties
            %
            % FORMATS = GETFORMATS() returns a cell array with the formats
            %   of all properties of PlotDataArea.
            %
            % See also PlotDataArea, PlotDataElement, ListElement.
            
            formats = [ PlotDataElement.getFormats() ...
                { ...
                PlotDataArea.Y_HIGH_FORMAT ...
                PlotDataArea.Y_LOW_FORMAT ...
                PlotDataArea.Y_MID_FORMAT ...
                PlotDataArea.AREA_FACE_COLOR_FORMAT ...
                PlotDataArea.AREA_FACE_ALPHA_FORMAT ...
                PlotDataArea.AREA_EDGE_COLOR_FORMAT ...
                PlotDataArea.AREA_EDGE_ALPHA_FORMAT ...
                PlotDataArea.AREA_EDGE_STYLE_FORMAT ...
                PlotDataArea.AREA_EDGE_WIDTH_FORMAT ...
                PlotDataArea.HIGH_SYM_MARKER_FORMAT ...
                PlotDataArea.HIGH_SYM_SIZE_FORMAT ...
                PlotDataArea.HIGH_SYM_EDGE_COLOR_FORMAT ...
                PlotDataArea.HIGH_SYM_FACE_COLOR_FORMAT ...
                PlotDataArea.HIGH_LIN_STYLE_FORMAT ...
                PlotDataArea.HIGH_LIN_WIDTH_FORMAT ...
                PlotDataArea.HIGH_LIN_COLOR_FORMAT ...
                PlotDataArea.LOW_SYM_MARKER_FORMAT ...
                PlotDataArea.LOW_SYM_SIZE_FORMAT ...
                PlotDataArea.LOW_SYM_EDGE_COLOR_FORMAT ...
                PlotDataArea.LOW_SYM_FACE_COLOR_FORMAT ...
                PlotDataArea.LOW_LIN_STYLE_FORMAT ...
                PlotDataArea.LOW_LIN_WIDTH_FORMAT ...
                PlotDataArea.LOW_LIN_COLOR_FORMAT ...
                PlotDataArea.MID_SYM_MARKER_FORMAT ...
                PlotDataArea.MID_SYM_SIZE_FORMAT ...
                PlotDataArea.MID_SYM_EDGE_COLOR_FORMAT ...
                PlotDataArea.MID_SYM_FACE_COLOR_FORMAT ...
                PlotDataArea.MID_LIN_STYLE_FORMAT ...
                PlotDataArea.MID_LIN_WIDTH_FORMAT ...
                PlotDataArea.MID_LIN_COLOR_FORMAT ...
                } ...
                ];
        end
        function defaults = getDefaults()
            % GETDEFAULTS cell array with the default values of the properties
            %
            % DEFAULTS = GETDEFAULTS() returns a cell array with the default values
            %   of all properties of PlotDataArea.
            %
            % See also PlotDataArea, PlotDataElement, ListElement.
            
            defaults = [ PlotDataElement.getDefaults() ...
                { ...
                PlotDataArea.Y_HIGH_DEFAULT ...
                PlotDataArea.Y_LOW_DEFAULT ...
                PlotDataArea.Y_MID_DEFAULT ...
                PlotDataArea.AREA_FACE_COLOR_DEFAULT ...
                PlotDataArea.AREA_FACE_ALPHA_DEFAULT ...
                PlotDataArea.AREA_EDGE_COLOR_DEFAULT ...
                PlotDataArea.AREA_EDGE_ALPHA_DEFAULT ...
                PlotDataArea.AREA_EDGE_STYLE_DEFAULT ...
                PlotDataArea.AREA_EDGE_WIDTH_DEFAULT ...
                PlotDataArea.HIGH_SYM_MARKER_DEFAULT ...
                PlotDataArea.HIGH_SYM_SIZE_DEFAULT ...
                PlotDataArea.HIGH_SYM_EDGE_COLOR_DEFAULT ...
                PlotDataArea.HIGH_SYM_FACE_COLOR_DEFAULT ...
                PlotDataArea.HIGH_LIN_STYLE_DEFAULT ...
                PlotDataArea.HIGH_LIN_WIDTH_DEFAULT ...
                PlotDataArea.HIGH_LIN_COLOR_DEFAULT ...
                PlotDataArea.LOW_SYM_MARKER_DEFAULT ...
                PlotDataArea.LOW_SYM_SIZE_DEFAULT ...
                PlotDataArea.LOW_SYM_EDGE_COLOR_DEFAULT ...
                PlotDataArea.LOW_SYM_FACE_COLOR_DEFAULT ...
                PlotDataArea.LOW_LIN_STYLE_DEFAULT ...
                PlotDataArea.LOW_LIN_WIDTH_DEFAULT ...
                PlotDataArea.LOW_LIN_COLOR_DEFAULT ...
                PlotDataArea.MID_SYM_MARKER_DEFAULT ...
                PlotDataArea.MID_SYM_SIZE_DEFAULT ...
                PlotDataArea.MID_SYM_EDGE_COLOR_DEFAULT ...
                PlotDataArea.MID_SYM_FACE_COLOR_DEFAULT ...
                PlotDataArea.MID_LIN_STYLE_DEFAULT ...
                PlotDataArea.MID_LIN_WIDTH_DEFAULT ...
                PlotDataArea.MID_LIN_COLOR_DEFAULT ...
                } ...
                ];
        end
        function options = getOptions(prop)
            % GETOPTIONS cell array with options (only for properties with options format)
            %
            % OPTIONS = GETOPTIONS(PROP) returns a cell array containing the options
            %   of the properties of PlotDataArea.
            %   If the PROP is not "options", it returns an empty cell array.
            %
            % See also PlotDataArea, PlotDataElement, ListElement.
            
            options = PlotDataElement.getOptions(prop);
            
            switch prop
                case PlotDataArea.AREA_EDGE_STYLE
                    options = PlotDataArea.AREA_EDGE_STYLE_OPTIONS;
                case PlotDataArea.HIGH_SYM_MARKER
                    options = PlotDataArea.HIGH_SYM_MARKER_OPTIONS;
                case PlotDataArea.HIGH_LIN_STYLE
                    options = PlotDataArea.HIGH_LIN_STYLE_OPTIONS;
                case PlotDataArea.LOW_SYM_MARKER
                    options = PlotDataArea.LOW_SYM_MARKER_OPTIONS;
                case PlotDataArea.LOW_LIN_STYLE
                    options = PlotDataArea.LOW_LIN_STYLE_OPTIONS;
                case PlotDataArea.MID_SYM_MARKER
                    options = PlotDataArea.MID_SYM_MARKER_OPTIONS;
                case PlotDataArea.MID_LIN_STYLE
                    options = PlotDataArea.MID_LIN_STYLE_OPTIONS;
            end
            
        end
    end
end