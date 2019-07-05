classdef GUI
    % GUI : Set of constants and methods for the GUI of Braph
    %   GUI defines a set of constants and methods of general use in
    %   the graphical user interfaces of Braph.
    %
    % GUI properties (Constants):
    %   BN_NAME             -   Braph name
    %   COLOR               -   Braph color
    %   FONT                -   Braph font
    %
    %   BAE_NAME            -   brain atlas editor name
    %   BAE_EXTENSION       -   brain atlas file extension
    %   BAE_MSG_PUTFILE     -   'save brain atlas' message
    %   BAE_MSG_GETFILE     -   'select brain atlas' message
    %
    %   MCE_NAME            -   MRI Cohort editor's name
    %   MCE_EXTENSION       -   MRI Cohort file extension
    %   MCE_MSG_PUTFILE     -   'save MRI cohort' message
    %   MCE_MSG_GETFILE     -   'select MRI cohort file' message
    % 
    %   MGA_NAME            -   MRI Graph Analysis
    %   MGA_EXTENSION       -   MRI Graph Analysis file extension
    %   MGA_MSG_PUTFILE     -   'save MRI graph analysis' message
    %   MGA_MSG_GETFILE     -   'select MRI graph analysis file' message
    %
    %   fMCE_NAME           -   fMRI Cohort editor's name
    %   fMCE_EXTENSION      -   fMRI Cohort file extension
    %   fMCE_MSG_PUTFILE    -   'save fMRI cohort' message
    %   fMCE_MSG_GETFILE    -   'select fMRI cohort file' message
    %
    %   fMGA_NAME           -   fMRI Graph Analysis
    %   fMGA_EXTENSION      -   fMRI Graph Analysis file extension
    %   fMGA_MSG_PUTFILE    -   'save fMRI graph analysis' message
    %   fMGA_MSG_GETFILE    -   'select fMRI graph analysis file' message
    %
    %   ECE_NAME            -   EEG Cohort editor's name
    %   ECE_EXTENSION       -   EEG Cohort file extension
    %   ECE_MSG_PUTFILE     -   'save EEG cohort' message
    %   ECE_MSG_GETFILE     -   'select EEG cohort file' message
    % 
    %   EGA_NAME            -   EEG Graph Analysis
    %   EGA_EXTENSION       -   EEG Graph Analysis file extension
    %   EGA_MSG_PUTFILE     -   'save EEG graph analysis' message
    %   EGA_MSG_GETFILE     -   'select EEG graph analysis file' message
    %
    %   PCE_NAME            -   PET Cohort editor's name
    %   PCE_EXTENSION       -   PET Cohort file extension
    %   PCE_MSG_PUTFILE     -   'save PET cohort' message
    %   PCE_MSG_GETFILE     -   'select PET cohort file' message
    % 
    %   PGA_NAME            -   PET Graph Analysis
    %   PGA_EXTENSION       -   PET Graph Analysis file extension
    %   PGA_MSG_PUTFILE     -   'save PET graph analysis' message
    %   PGA_MSG_GETFILE     -   'select PET graph analysis file' message
    %
    %   MSG_YES             -   prints 'YES'
    %   MSG_NO              -   prints 'NO'
    %   BRA_UNITS           -   left bracket
    %   KET_UNITS           -   right bracket
    %   BKGCOLOR            -   background color
    %   TABBKGCOLOR         -   background table tab color
    %
    %   PLOT_SYMBOL_TAG         -   cell array of symbols' tags
    %   PLOT_SYMBOL_NAME        -   cell array of strings of symbols' tags
    %   PLOT_LINESTYLE_TAG      -   cell array of line styles' tags
    %   PLOT_LINESTYLE_NAME     -   cell array of strings of line styles' tags
    %   FONT_INTERPRETER_TAG    -   cell array of font interpreters' tags
    %   FONT_INTERPRETER_NAME   -   cell array of strings of font interpreters' tags
    %   FONT_TYPE_TAG           -   cell array of font types' tags
    %   FONT_TYPE_NAME          -   cell array of strings of font types' tags
    %   FONT_WEIGHT_TAG         -   cell array of font weights' tags
    %   FONT_WEIGHT_NAME        -   cell array of strings of font weights' tags    
    %
    %   MENU_FILE           -   string of the name of file menu
    %   MENU_EDIT           -   string of the name of edit menu
    %   MENU_VIEW           -   string of the name of view menu
    %   
    %   OPEN_CMD            -   open command
    %   OPEN_SC             -   open command shortcut
    %   SAVE_CMD            -   save command
    %   SAVE_SC             -   save command shortcut   
    %   SAVEAS_CMD          -   save as command
    %   IMPORT_XML_CMD      -   import XML command
    %   IMPORT_TXT_CMD      -   import TXT command   
    %   IMPORT_XLS_CMD      -   import XLS command
    %   EXPORT_XML_CMD      -   export XML command
    %   EXPORT_TXT_CMD      -   export TXT command
    %   CLOSE_CMD           -   close command
    %   CLOSE_SC            -   close command shortcut   
    %   SELECTALL_CMD       -   select all command
    %   CLEARSELECTION_CMD  -   clear selection command  
    %   ADD_CMD             -   add command
    %   ADD_SC              -   add command shortcut   
    %   ADDABOVE_CMD        -   add above command
    %   ADDBELOW_CMD        -   add below command   
    %   REMOVE_CMD          -   remove command
    %   REMOVE_SC           -   remove command shortcut   
    %   MOVEUP_CMD          -   move up command
    %   MOVEUP_SC           -   move up command shortcut  
    %   MOVEDOWN_CMD        -   move down command
    %   MOVEDOWN_SC         -   move down command shortcut   
    %   MOVE2TOP_CMD        -   move to top command
    %   MOVE2TOP_SC         -   move to top command shortcut   
    %   MOVE2BOTTOM_CMD     -   move to bottom command
    %   MOVE2BOTTOM_SC      -   move to bottom command shortcut   
    %   FIGURE_CMD          -   generate figure command
    %   FIGURE_SC           -   generate figure command shortcut   
    %
    % GUI methods (Static):
    %   ACCELERATOR         -   (Static) defines accelerator
    %   SCREEN_WIDTH        -   (Static) defines screen width   
    %   SCREEN_HEIGHT       -   (Static) defines screen height 
    %   init_figure         -   (Static) creates and intializes GUI figure
    %   close               -   (Static) closes GUI figure   
    %   setMenuAbout        -   (Static) initializes about menu 
    %   about               -   (Static) message in about menu
    %   setUnits            -   (Static) sets GUI figure units  
    %   setBackgroundColor  -   (Static) sets GUI figure background color
    %   disable             -   (Static) disables all children of a specified object
    %   enable              -   (Static) enables all children of a specified object
    %   x                   -   (Static) initial x-position of an element
    %   y                   -   (Static) initial y-position of an element
    %   width               -   (Static) width of an element
    %   height              -   (Static) height of an element
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01

    properties (Constant)
        
        % Braph
        BN_NAME = 'Braph'
        COLOR = [.9 .4 .1]
        FONT = 'Helvetica'

        BAE_NAME = 'Brain Atlas Editor'
        BAE_EXTENSION = '*.atlas'
        BAE_MSG_PUTFILE = 'Save brain atlas'
        BAE_MSG_GETFILE = ['Select brain atlas file (' GUI.BAE_EXTENSION ')']

        MCE_NAME = 'MRI Cohort Editor'
        MCE_EXTENSION = '*.mc'
        MCE_MSG_PUTFILE = 'Save MRI cohort'
        MCE_MSG_GETFILE = ['Select MRI cohort file (' GUI.MCE_EXTENSION ')']

        MGA_NAME = 'MRI Graph Analysis'
        MGA_EXTENSION = '*.mga'
        MGA_MSG_PUTFILE = 'Save MRI graph analysis'
        MGA_MSG_GETFILE = ['Select MRI graph analysis file (' GUI.MGA_EXTENSION ')']

        fMCE_NAME = 'fMRI Cohort Editor'
        fMCE_EXTENSION = '*.fc'
        fMCE_MSG_PUTFILE = 'Save fMRI cohort'
        fMCE_MSG_GETFILE = ['Select fMRI cohort file (' GUI.fMCE_EXTENSION ')']

        fMGA_NAME = 'fMRI Graph Analysis'
        fMGA_EXTENSION = '*.fga'
        fMGA_MSG_PUTFILE = 'Save fMRI graph analysis'
        fMGA_MSG_GETFILE = ['Select fMRI graph analysis file (' GUI.fMGA_EXTENSION ')']

        ECE_NAME = 'EEG Cohort Editor'
        ECE_EXTENSION = '*.ec'
        ECE_MSG_PUTFILE = 'Save EEg cohort'
        ECE_MSG_GETFILE = ['Select EEG cohort file (' GUI.ECE_EXTENSION ')']

        EGA_NAME = 'EEG Graph Analysis'
        EGA_EXTENSION = '*.ega'
        EGA_MSG_PUTFILE = 'Save EEG graph analysis'
        EGA_MSG_GETFILE = ['Select EEG graph analysis file (' GUI.EGA_EXTENSION ')']

        PCE_NAME = 'PET Cohort Editor'
        PCE_EXTENSION = '*.pc'
        PCE_MSG_PUTFILE = 'Save PET cohort'
        PCE_MSG_GETFILE = ['Select PET cohort file (' GUI.PCE_EXTENSION ')']

        PGA_NAME = 'PET Graph Analysis'
        PGA_EXTENSION = '*.pga'
        PGA_MSG_PUTFILE = 'Save PET graph analysis'
        PGA_MSG_GETFILE = ['Select PET graph analysis file (' GUI.PGA_EXTENSION ')']

        % GUI general
        MSG_YES = 'Yes'
        MSG_NO = 'No'
        BRA_UNITS = '['
        KET_UNITS = ']'
        BKGCOLOR = [.95 .95 .95]
        TABBKGCOLOR = [.95 .98 1.00; 1.00 .98 .95]
        
        PLOT_SYMBOL_TAG = { ...
            '.' ...
            'o' ...
            'x' ...
            '+' ...
            '*' ...
            's' ...
            'd' ...
            'v' ...
            '^' ...
            '>' ...
            '<' ...
            'p' ...
            'h' ...
            'none' ...
            }
        
        PLOT_SYMBOL_NAME = { ...
            'point' ...
            'circle' ...
            'x-mark' ...
            'plus' ...
            'star' ...
            'square' ...
            'diamond' ...
            'triangle (down)' ...
            'triangle (up)' ...
            'triangle (left)' ...
            'triangle (right)' ...
            'pentagram' ...
            'hexagram' ...
            'none' ...
            }

        PLOT_LINESTYLE_TAG = { ...
            '-' ...
            ':' ...
            '-.' ...
            '--' ...
            'none' ...
            }

        PLOT_LINESTYLE_NAME = { ...
            'solid' ...
            'dotted' ...
            'dashdot' ...
            'dashed' ...
            'none' ...
            }
    
        FONT_INTERPRETER_TAG = { ...
            'tex' ...
            'latex' ...
            'none' ...
            }
        
        FONT_INTERPRETER_NAME = { ...
            'tex' ...
            'latex' ...
            'none' ...
            }
        
        FONT_TYPE_TAG = { ...
            'Helvetica' ...
            'Calibri' ...
            'Arial' ...
            'Times New Roman' ...
            'Arial Unicode' ...
            'FixedWidth' ...
            }
        
        FONT_TYPE_NAME = { ...
            'Helvetica' ...
            'Calibri' ...
            'Arial' ...
            'Times New Roman' ...
            'Arial Unicode' ...
            'FixedWidth' ...
            }
        
        FONT_WEIGHT_TAG = { ...
            'normal' ...
            'bold' ...
            }
        
        FONT_WEIGHT_NAME = { ...
            'normal' ...
            'bold' ...
            }

        % Menus
        MENU_FILE = 'File'
        MENU_EDIT = 'Edit'
        MENU_VIEW = 'View'

        % Commands
        OPEN_CMD = 'Open ...'; 
        OPEN_SC = 'O';

        SAVE_CMD = 'Save';
        SAVE_SC = 'S';
        
        SAVEAS_CMD = 'Save as ...';

        IMPORT_XML_CMD = 'Import (xml) ...';
        IMPORT_TXT_CMD = 'Import (txt) ...';
        IMPORT_XLS_CMD = 'Import (xls) ...';
        
        EXPORT_XML_CMD = 'Export (xml) ...';
        EXPORT_TXT_CMD = 'Export (txt) ...';

        CLOSE_CMD = 'Close';
        CLOSE_SC = 'C';
        
        SELECTALL_CMD = 'Select all';

        CLEARSELECTION_CMD = 'Clear selection';

        ADD_CMD = 'Add';
        ADD_SC = 'A';

        ADDABOVE_CMD = 'Add above';

        ADDBELOW_CMD = 'Add below';

        REMOVE_CMD = 'Remove';
        REMOVE_SC = 'R';

        MOVEUP_CMD = 'Move up';
        MOVEUP_SC = 'U';

        MOVEDOWN_CMD = 'Move down';
        MOVEDOWN_SC = 'D';

        MOVE2TOP_CMD = 'Move to top';
        MOVE2TOP_SC = 'T';

        MOVE2BOTTOM_CMD = 'Move to bottom';
        MOVE2BOTTOM_SC = 'B';

        FIGURE_CMD = 'Generate figure'; 
        FIGURE_SC = 'F';
    end
    methods (Static)  % constants
        function c = ACCELERATOR()
            % ACCELERATOR defines accelerator
            %
            % C = ACCELERATOR() returns the corresponding accelerator depending 
            %   on whether the version is for Apple Mac OS X or form Win/Unix.
            %
            % See also GUI, ismac.
            
            if ismac  % Mac
                c = 'Cmd';
            else  % Win/Unix
                c = 'Crtl';
            end
        end
        function w = SCREEN_WIDTH()
            % SCREEN_WIDTH defines screen width 
            %
            % W = SCREEN_WIDTH() returns the width of the screen. 
            %
            % See also GUI.
            
            screensize = get(0,'screensize');
            w = screensize(3);
        end
        function h = SCREEN_HEIGHT()
            % SCREEN_HEIGHT defines screen height 
            %
            % W = SCREEN_HEIGHT() returns the height of the screen. 
            %
            % See also GUI.
            
            screensize = get(0,'screensize');
            h = screensize(4);
        end
    end
    methods (Static)  % functions
        function f = init_figure(AppName,width,height,position)
            % INIT_FIGURE creates and intializes GUI figure 
            %
            % F = INIT_FIGURE(APPNAME,WIDTH,HEIGHT,POSITION) creates a GUI figure
            %   F with name APPNAME and initializes the following properties:
            %   WIDTH     -  width of the figure as percentage of the screen width
            %   HEIGHT    -  height of the figure as percentage of the screen height   
            %   POSITION  -  position of the figure on the screen
            %
            % Admissible POSITION initializations are:
            %   north     | south     | east      | west
            %   northeast | northwest | southeast | southwest
            %   center    | onscreen  | [h,v]
            %
            % The figure is initially hidden.
            % 
            % See also GUI, movegui.
            
            f = figure();
            set(f,'Visible','off')
            set(f,'Position',[1 1 GUI.SCREEN_WIDTH*width GUI.SCREEN_HEIGHT*height])
            movegui(f,position)
            set(f,'Color',GUI.BKGCOLOR)
            set(f,'Name',[AppName ' - ' BNC.VERSION])
            set(f,'MenuBar','none')
            set(f,'NumberTitle','off')
            set(f,'DockControls','off')
            set(f,'CloseRequestFcn',['GUI.close(''' AppName ''',gcf)'])
        end
        function close(AppName,f)
            % CLOSE closes GUI figure 
            %
            % CLOSE(APPNAME,F) promts the user to choose whether to close the
            %   GUI figure F with name APPNAME. If the user answers
            %   positively, the GUI figure closes.
            %   F can also be a vector of figures.
            %
            % See also GUI.
            
            selection = questdlg(['Do you want to close ' AppName '?'], ...
                ['Close ' AppName], ...
                GUI.MSG_YES,GUI.MSG_NO,GUI.MSG_YES);
            switch selection
                case GUI.MSG_YES
                    delete(f)
                case GUI.MSG_NO
                    return
            end
        end
        function [ui_menu_about,ui_menu_about_about] = setMenuAbout(f,AppName)
            % SETMENUABOUT initializes about menu 
            %
            % [UI_MENU_ABOUT,UI_MENU_ABOUT_ABOUT] = SETMENUABOUT(APPNAME,F)
            %   adds the menu item UI_MENU_ABOUT and its submenu item
            %   UI_MENU_ABOUT_ABOUT to the figure F.
            %
            % UI_MENU_ABOUT_ABOUT gives general information about the 
            %   brain network toolbox.
            %
            % See also GUI.
            
            ui_menu_about = uimenu(f,'Label','About');
            
            ui_menu_about_about = uimenu(ui_menu_about);
            set(ui_menu_about_about,'Label','About ...')
            set(ui_menu_about_about,'Callback',['GUI.about(''' AppName ''')'])
        end
        function about(AppName)
            % ABOUT message in about menu 
            %
            % ABOUT(APPNAME) specifies the message displayed in the about 
            %   menu in the figure with name APPNAME.
            %
            % See also GUI.
            
            msgbox({'' [AppName ' ' BNC.VERSION] '' BNC.AUTHORS '' BNC.COPYRIGHT ''}, ...
                ['About ' AppName])
        end
        function setUnits(h,alsochildren)
            % SETUNITS sets GUI figure units
            %
            % SETUNITS(H,ALSOCHILDREN) sets the units of the object with 
            %   handle H and all its children to normalized if ALSOCHILDREN 
            %   is true.
            %   If ALSOCHILDREN is false, only the units of the object with 
            %   handle H are set to normalized.
            %
            % See also GUI.
            
            if nargin<2
                alsochildren = true;
            end
            
            set(h,'Units','normalized')
            if alsochildren
                set(allchild(h),'Units','normalized')
            end
        end
        function setBackgroundColor(h,alsochildren)
            % SETBACKGROUNDCOLOR sets GUI figure background color
            %
            % SETBACKGROUNDCOLOR(H,ALSOCHILDREN) sets the background color
            %   of the object with handle H and all its children to the  
            %   brain network color if ALSOCHILDREN is true.
            %
            % If ALSOCHILDREN is false, only the background color of the 
            %   object with handle H are set to normalized.
            %
            % If the child of the object H is a table, the color is
            %   initialized to the background table tab color.
            %
            % If the child of the object H is a push button, the color of
            %   the child remains unaffected.
            %   
            % See also GUI.
            
            if nargin<2
                alsochildren = true;
            end
            
            if isa(h,'matlab.ui.control.Table')
                        set(h,'BackgroundColor',GUI.TABBKGCOLOR)
            elseif isa(h,'matlab.ui.control.UIControl') && strcmpi(get(h,'Style'),'pushbutton')
                % no action
            else
                set(h,'BackgroundColor',GUI.BKGCOLOR)
            end
            
            if alsochildren
                h_vec = allchild(h);
                for i = 1:1:length(h_vec)
                    GUI.setBackgroundColor(h_vec(i),false);
                end
            end
        end
        function disable(h)
            % DISABLE disables all children of a specified object
            %
            % DISABLE(H) disables all children of the object specified by
            % the handle H.
            % The object H must be of the type "uipanel".
            %
            % See also GUI.
            
            all = allchild(h);
            for i = 1:1:length(all)
                ht = all(i);
                if isa(ht,'matlab.ui.control.UIControl')
                    set(ht,'enable','off')
                end
            end
        end
        function enable(h)
            % ENABLE enables all children of a specified object
            %
            % ENABLE(H) enables all children of the object specified by
            % the handle H.
            % The object H must be of the type "uipanel".
            %
            % See also GUI.
  
            all = allchild(h);
            for i = 1:1:length(all)
                ht = all(i);
                if isa(ht,'matlab.ui.control.UIControl')
                    set(ht,'enable','on')
                end
            end
        end        
        function x0 = x(f,r)
            % X initial position
            %
            % X0 = X(F,R) returns the initial position corresponding to
            %   figure F and ratio R.
            %
            % See also GUI.
            
            if nargin<2
                r = 1;
            end
            
            pos = get(f,'Position');
            x0 = r*pos(1);
        end
        function y0 = y(f,r)
            % Y initial position
            %
            % Y0 = Y(F,R) returns the initial position corresponding to
            %   figure F and ratio R.
            %
            % See also GUI.
            
            if nargin<2
                r = 1;
            end
            
            pos = get(f,'Position');
            y0 = r*pos(2);
        end
        function w = width(f,r)
            % WIDTH width
            %
            % W = WIDTH(F,R) returns the width corresponding to figure F and ratio R.
            %
            % See also GUI.
            
            if nargin<2
                r = 1;
            end
            
            pos = get(f,'Position');
            w = r*pos(3);
        end
        function h = height(f,r)
            % HEIGHT height
            %
            % H = HEIGHT(F,R) returns the height corresponding to figure F and ratio R.
            %
            % See also GUI.
            
            if nargin<2
                r = 1;
            end
            
            pos = get(f,'Position');
            h = r*pos(4);
        end
    end
end