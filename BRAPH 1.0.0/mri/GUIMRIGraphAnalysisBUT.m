function GUIMRIGraphAnalysisBUT(ga)
%% MRI Graph Analysis
% GUIMRIGraphAnalysis(ga,true) opens analysis with only reading and basic writing permissions
% GUIMRIGraphAnalysis(ga) opens cohort - equivalent to GUIMRIGraphAnalysis(ga,false)
% GUIMRIGraphAnalysis(cohort) opens empty analysis (the MRICohort is set to cohort)
% GUIMRIGraphAnalysis() opens empty analysis with empty cohort

%% General Constants
APPNAME = [GUI.MGA_NAME ' BUT'];  % application name
BUILT = BNC.BUILT;
BRAINVIEW_BUTTON_GRAPH  = ' View Graph Links ';
BRAINVIEW_BUTTON_VIEWMEAS = ' View Group Measures ';
BRAINVIEW_BUTTON_VIEWCOMP = ' View Group Comparison ';
BRAINVIEW_BUTTON_VIEWRAND = ' View Group Random Comparison ';
BRAINVIEW_BUTTON_STATE = ' View Brain ';

% Dimensions
MARGIN_X = .01;
MARGIN_Y = .01;
LEFTCOLUMN_WIDTH = .19;
HEADING_HEIGHT = .12;
FILENAME_HEIGHT = .02;

MAINPANEL_X0 = LEFTCOLUMN_WIDTH+2*MARGIN_X;
MAINPANEL_Y0 = FILENAME_HEIGHT+2*MARGIN_Y;
MAINPANEL_WIDTH = 1-LEFTCOLUMN_WIDTH-3*MARGIN_X;
MAINPANEL_HEIGHT = 1-HEADING_HEIGHT-FILENAME_HEIGHT-4*MARGIN_Y;
MAINPANEL_POSITION = [MAINPANEL_X0 MAINPANEL_Y0 MAINPANEL_WIDTH MAINPANEL_HEIGHT];

% Commands
OPEN_CMD = GUI.OPEN_CMD;
OPEN_SC = GUI.OPEN_SC;
OPEN_TP = ['Open MRI graph analysis. Shortcut: ' GUI.ACCELERATOR '+' OPEN_SC];

SAVE_CMD = GUI.SAVE_CMD;
SAVE_SC = GUI.SAVE_SC;
SAVE_TP = ['Save current MRI graph analysis. Shortcut: ' GUI.ACCELERATOR '+' SAVE_SC];

SAVEAS_CMD = GUI.SAVEAS_CMD;
SAVEAS_TP = 'Open dialog box to save current MRI graph analysis';

IMPORT_XML_CMD = GUI.IMPORT_XML_CMD;
IMPORT_XML_TP = 'Import MRI graph analysis from an xml file (*.xml)';

EXPORT_XML_CMD = GUI.EXPORT_XML_CMD;
EXPORT_XML_TP = 'Export MRI graph analysis as an xml file (*.xml)';

CLOSE_CMD = GUI.CLOSE_CMD;
CLOSE_SC = GUI.CLOSE_SC;
CLOSE_TP = ['Close ' APPNAME '. Shortcut: ' GUI.ACCELERATOR '+' CLOSE_SC];

SELECTALL_CALC_CMD = GUI.SELECTALL_CMD;
SELECTALL_CALC_TP = 'Select all measures';

CLEARSELECTION_CALC_CMD = GUI.CLEARSELECTION_CMD;
CLEARSELECTION_CALC_TP = 'Clear measure selection';

SELECTGLOBAL_CALC_CMD = 'Select Global';
SELECTGLOBAL_CALC_TP = 'Select all global measures';

SELECTNODAL_CALC_CMD = 'Select Nodal';
SELECTNODAL_CALC_TP = 'Select all nodal measures';

CALCULATE_CALC_CMD = 'Calculate Group Measures';
CALCULATE_CALC_TP = 'Calculates selected measures for a group';

COMPARE_CALC_CMD = 'Compare Group Measures';
COMPARE_CALC_TP = 'Compares selected measures for two group';

RANDOM_CALC_CMD = 'Compare With Random Graph';
RANDOM_CALC_TP = 'Compares selected measures with a random graph';

SELECTALL_MEAS_CMD = GUI.SELECTALL_CMD;
SELECTALL_MEAS_TP = 'Select all measures';

CLEARSELECTION_MEAS_CMD = GUI.CLEARSELECTION_CMD;
CLEARSELECTION_MEAS_TP = 'Clear measure selection';

REMOVE_MEAS_CMD = GUI.REMOVE_CMD;
REMOVE_MEAS_TP = 'Remove selected measures';

FIGURE_CMD = GUI.FIGURE_CMD;
FIGURE_SC = GUI.FIGURE_SC;
FIGURE_TP = ['Generate figure. Shortcut: ' GUI.ACCELERATOR '+' FIGURE_SC];

%% Application data
Check.isa('Error: The MRI graph analysis ga must be a MRIGraphAnalysisBUT',ga,'MRIGraphAnalysisBUT')
selected_calc = [];
selected_brainmeasures = [];
selected_regionmeasures = [];

bg = [];

ui_popups_grouplists = [];
plot_data_global = PlotData();  % plot data for the global measures
plot_data_nodal = PlotData();  % plot data for the nodal measures

% Callbacks to manage application data
    function cb_open(~,~)  % (src,event)
        % select file
        [file,path,filterindex] = uigetfile(GUI.MGA_EXTENSION,GUI.MGA_MSG_GETFILE);
        % load file
        if filterindex
            filename = fullfile(path,file);
            ga = load(filename,'-mat','ga','selected_calc','selected_brainmeasures','selected_regionmeasures','BUILT');
            if isa(ga.ga,'MRIGraphAnalysis')
                selected_calc = ga.selected_calc;
                selected_brainmeasures = ga.selected_brainmeasures;
                selected_regionmeasures = ga.selected_regionmeasures;
                ga = ga.ga;
                setup()
                setup_calc_corr()
                update_filename(filename)
            end
        end
    end
    function cb_save(~,~)  % (src,event)
        filename = get(ui_text_filename,'String');
        if length(filename)>0
            save(filename,'ga','selected_calc','selected_brainmeasures','selected_regionmeasures','BUILT');
        else
            cb_saveas();
        end
    end
    function cb_saveas(~,~)  % (src,event)
        % select file
        [file,path,filterindex] = uiputfile(GUI.MGA_EXTENSION,GUI.MGA_MSG_PUTFILE);
        % save file
        if filterindex
            filename = fullfile(path,file);
            save(filename,'ga','selected_calc','selected_brainmeasures','selected_regionmeasures','BUILT');
            update_filename(filename)
        end
    end
    function cb_import_xml(~,~)  % (scr,event)
        gatmp = MRIGraphAnalysisBUT(MRICohort(BrainAtlas()),Structure());
        success = gatmp.loadfromfile(BNC.XML_MSG_GETFILE);
        if success
            ga = gatmp;
            selected_calc = [];
            setup()
            setup_calc_corr()
            update_filename('')
        end
    end
    function cb_export_xml(~,~)  % (scr,event)
        ga.savetofile(BNC.XML_MSG_PUTFILE);
    end
    function update_popups_grouplists()
        if ga.getCohort().groupnumber()>0
            % updates group lists of popups
            GroupList = {};
            for g = 1:1:ga.getCohort().groupnumber()
                GroupList{g} = ga.getCohort().getGroup(g).getProp(Group.NAME);
            end
        else
            GroupList = {''};
        end
        set(ui_popups_grouplists,'String',GroupList)
    end

%% GUI inizialization
fig_structure = [];
fig_group = [];
f = GUI.init_figure(APPNAME,.9,.9,'center');

%% Text File Name
FILENAME_WIDTH = 1-2*MARGIN_X;
FILENAME_POSITION = [MARGIN_X MARGIN_Y FILENAME_WIDTH FILENAME_HEIGHT];

ui_text_filename = uicontrol('Style','text');
init_filename()
    function init_filename()
        GUI.setUnits(ui_text_filename)
        GUI.setBackgroundColor(ui_text_filename)
        
        set(ui_text_filename,'Position',FILENAME_POSITION)
        set(ui_text_filename,'HorizontalAlignment','left')
    end
    function update_filename(filename)
        set(ui_text_filename,'String',filename)
    end

%% Panel Cohort
COHORT_NAME = 'Cohort';
COHORT_WIDTH = LEFTCOLUMN_WIDTH;
COHORT_HEIGHT = HEADING_HEIGHT;
COHORT_X0 = MARGIN_X;
COHORT_Y0 = 1-MARGIN_Y-COHORT_HEIGHT;
COHORT_POSITION = [COHORT_X0 COHORT_Y0 COHORT_WIDTH COHORT_HEIGHT];

COHORT_BUTTON_VIEW_CMD = 'View Cohort';
COHORT_BUTTON_VIEW_TP = ['Open MRI cohort with ' GUI.MCE_NAME '.'];

ui_panel_cohort = uipanel();
ui_text_cohort_name = uicontrol(ui_panel_cohort,'Style','text');
ui_text_cohort_subjectnumber = uicontrol(ui_panel_cohort,'Style','text');
ui_text_cohort_groupnumber = uicontrol(ui_panel_cohort,'Style','text');
ui_button_cohort = uicontrol(ui_panel_cohort,'Style','pushbutton');
init_cohort()
    function init_cohort()
        GUI.setUnits(ui_panel_cohort)
        GUI.setBackgroundColor(ui_panel_cohort)
        
        set(ui_panel_cohort,'Position',COHORT_POSITION)
        set(ui_panel_cohort,'Title',COHORT_NAME)
        
        set(ui_text_cohort_name,'Position',[.05 .60 .50 .20])
        set(ui_text_cohort_name,'HorizontalAlignment','left')
        set(ui_text_cohort_name,'FontWeight','bold')
        
        set(ui_text_cohort_subjectnumber,'Position',[.05 .40 .50 .20])
        set(ui_text_cohort_subjectnumber,'HorizontalAlignment','left')
        
        set(ui_text_cohort_groupnumber,'Position',[.05 .20 .50 .20])
        set(ui_text_cohort_groupnumber,'HorizontalAlignment','left')
        
        set(ui_button_cohort,'Position',[.55 .30 .40 .40])
        set(ui_button_cohort,'Callback',{@cb_cohort})
    end
    function update_cohort()
        update_popups_grouplists()
        
        set(ui_text_cohort_name,'String',ga.getCohort().getProp(MRICohort.NAME))
        set(ui_text_cohort_subjectnumber,'String',['subject number = ' int2str(ga.getCohort().length())])
        set(ui_text_cohort_groupnumber,'String',['group number = ' int2str(ga.getCohort().groupnumber())])
        set(ui_button_cohort,'String',COHORT_BUTTON_VIEW_CMD)
        set(ui_button_cohort,'TooltipString',COHORT_BUTTON_VIEW_TP);
    end
    function cb_cohort(~,~)  % (src,event)
        GUIMRICohort(ga.getCohort(),true)  % open atlas with restricted permissions
    end

%% Panel Calc
CALC_SELECTED_COL = 1;
CALC_NAME_COL = 2;
CALC_NODAL_COL = 3;
CALC_NODAL_NO = 'Global';
CALC_NODAL_YES = 'Nodal';
CALC_TXT_COL = 4;

CALC_WIDTH = LEFTCOLUMN_WIDTH;
CALC_HEIGHT = MAINPANEL_HEIGHT;
CALC_X0 = MARGIN_X;
CALC_Y0 = FILENAME_HEIGHT+2*MARGIN_Y;
CALC_POSITION = [CALC_X0 CALC_Y0 CALC_WIDTH CALC_HEIGHT];

NEW_BUTTON_CMD = 'New analysis';
NEW_BUTTON_TP = 'Opens a new window to define new correlation matrix';

VIEW_BUTTON_CMD = 'View community';
VIEW_BUTTON_TP = 'View the community structure defined for a graph';

ui_panel_calc = uipanel();
ui_edit_calc_ganame = uicontrol(ui_panel_calc,'Style','edit');

ui_popup_calc_graph = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_graph = uicontrol(ui_panel_calc,'Style','text');
ui_popup_calc_corr = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_corr = uicontrol(ui_panel_calc,'Style','text');
ui_popup_calc_neg = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_neg = uicontrol(ui_panel_calc,'Style','text');
ui_button_comm_view = uicontrol(ui_panel_calc,'Style','pushbutton');
ui_button_calc_new = uicontrol(ui_panel_calc,'Style','pushbutton');

ui_table_calc = uitable(ui_panel_calc);
ui_button_calc_selectall = uicontrol(ui_panel_calc,'Style', 'pushbutton');
ui_button_calc_clearselection = uicontrol(ui_panel_calc,'Style', 'pushbutton');
ui_button_calc_global = uicontrol(ui_panel_calc,'Style', 'pushbutton');
ui_button_calc_nodal = uicontrol(ui_panel_calc,'Style', 'pushbutton');

ui_button_calc_calculate = uicontrol(ui_panel_calc,'Style','pushbutton');
ui_button_calc_compare = uicontrol(ui_panel_calc,'Style','pushbutton');
ui_button_calc_random = uicontrol(ui_panel_calc,'Style','pushbutton');
init_calc()
setup_calc_corr()
    function init_calc()
        GUI.setUnits(ui_panel_calc)
        GUI.setBackgroundColor(ui_panel_calc)
        
        set(ui_panel_calc,'Position',CALC_POSITION)
        set(ui_panel_calc,'BorderType','none')
        
        set(ui_edit_calc_ganame,'Position',[.02 .96 .96 .03])
        set(ui_edit_calc_ganame,'HorizontalAlignment','left')
        set(ui_edit_calc_ganame,'FontWeight','bold')
        set(ui_edit_calc_ganame,'Callback',{@cb_calc_ganame})
                
        set(ui_text_calc_graph,'Position',[.07 .875 .30 .045])
        set(ui_text_calc_graph,'String','Graph')
        set(ui_text_calc_graph,'Enable','off')
        set(ui_text_calc_graph,'HorizontalAlignment','left')
        set(ui_text_calc_graph,'FontWeight','bold')
        
        set(ui_popup_calc_graph,'String',MRIGraphAnalysis.GRAPH_OPTIONS)
        set(ui_popup_calc_graph,'Position',[.45 .875 .45 .05])
        set(ui_popup_calc_graph,'Enable','off')
        set(ui_popup_calc_graph,'TooltipString','Select a graph type');
        set(ui_popup_calc_graph,'Callback',{@cb_calc_graph});
        
        set(ui_text_calc_corr,'Position',[.07 .835 .30 .045])
        set(ui_text_calc_corr,'String','Correlation')
        set(ui_text_calc_corr,'HorizontalAlignment','left')
        set(ui_text_calc_corr,'Enable','off')
        set(ui_text_calc_corr,'FontWeight','bold')
        
        set(ui_popup_calc_corr,'String',MRIGraphAnalysis.CORR_OPTIONS)
        set(ui_popup_calc_corr,'Position',[.45 .835 .45 .05])
        set(ui_popup_calc_corr,'Enable','off')
        set(ui_popup_calc_corr,'TooltipString','Select a matrix correlation');
        set(ui_popup_calc_corr,'Callback',{@cb_calc_corr});

        set(ui_text_calc_neg,'Position',[.07 .795 .30 .05])
        set(ui_text_calc_neg,'String','Negative corrs.')
        set(ui_text_calc_neg,'Enable','off')
        set(ui_text_calc_neg,'HorizontalAlignment','left')
        set(ui_text_calc_neg,'FontWeight','bold')
        
        set(ui_popup_calc_neg,'String',MRIGraphAnalysis.NEG_OPTIONS)
        set(ui_popup_calc_neg,'Position',[.45 .795 .45 .05])
        set(ui_popup_calc_neg,'Enable','off')
        set(ui_popup_calc_neg,'TooltipString','Select a negative correlations handling');
        set(ui_popup_calc_neg,'Callback',{@cb_calc_neg});
        
        set(ui_button_comm_view,'Position',[.02 .750 .96 .045])
        set(ui_button_comm_view,'String',VIEW_BUTTON_CMD)
        set(ui_button_comm_view,'TooltipString',VIEW_BUTTON_TP)
        set(ui_button_comm_view,'Callback',{@cb_comm_view})
        
        set(ui_button_calc_new,'Position',[.02 .675 .96 .045])
        set(ui_button_calc_new,'String',NEW_BUTTON_CMD)
        set(ui_button_calc_new,'TooltipString',NEW_BUTTON_TP)
        set(ui_button_calc_new,'Callback',{@cb_calc_new})
        
        set(ui_table_calc,'BackgroundColor',GUI.TABBKGCOLOR)
        set(ui_table_calc,'Position',[.02 .27 .96 .37])
        set(ui_table_calc,'ColumnName',{'','   Brain Measure   ',' global/nodal ','   notes   '})
        set(ui_table_calc,'ColumnFormat',{'logical','char',{CALC_NODAL_NO CALC_NODAL_YES},'char'})
        set(ui_table_calc,'ColumnEditable',[true false false true])
        set(ui_table_calc,'CellEditCallback',{@cb_calc_edit});
        
        set(ui_button_calc_selectall,'Position',[.02 .23 .47 .03])
        set(ui_button_calc_selectall,'String',SELECTALL_CALC_CMD)
        set(ui_button_calc_selectall,'TooltipString',SELECTALL_CALC_TP)
        set(ui_button_calc_selectall,'Callback',{@cb_calc_selectall})
        
        set(ui_button_calc_clearselection,'Position',[.51 .23 .47 .03])
        set(ui_button_calc_clearselection,'String',CLEARSELECTION_CALC_CMD)
        set(ui_button_calc_clearselection,'TooltipString',CLEARSELECTION_CALC_TP)
        set(ui_button_calc_clearselection,'Callback',{@cb_calc_clearselection})
        
        set(ui_button_calc_global,'Position',[.02 .20 .47 .03])
        set(ui_button_calc_global,'String',SELECTGLOBAL_CALC_CMD)
        set(ui_button_calc_global,'TooltipString',SELECTGLOBAL_CALC_TP)
        set(ui_button_calc_global,'Callback',{@cb_calc_global})
        
        set(ui_button_calc_nodal,'Position',[.51 .20 .47 .03])
        set(ui_button_calc_nodal,'String',SELECTNODAL_CALC_CMD)
        set(ui_button_calc_nodal,'TooltipString',SELECTNODAL_CALC_TP)
        set(ui_button_calc_nodal,'Callback',{@cb_calc_nodal})
        
        set(ui_button_calc_calculate,'Position',[.02 .12 .96 .045])
        set(ui_button_calc_calculate,'String',CALCULATE_CALC_CMD)
        set(ui_button_calc_calculate,'TooltipString',CALCULATE_CALC_TP)
        set(ui_button_calc_calculate,'Callback',{@cb_calc_calculate})
        
        set(ui_button_calc_compare,'Position',[.02 .065 .96 .045])
        set(ui_button_calc_compare,'String',COMPARE_CALC_CMD)
        set(ui_button_calc_compare,'TooltipString',COMPARE_CALC_TP)
        set(ui_button_calc_compare,'Callback',{@cb_calc_compare})
        
        set(ui_button_calc_random,'Position',[.02 .01 .96 .045])
        set(ui_button_calc_random,'String',RANDOM_CALC_CMD)
        set(ui_button_calc_random,'TooltipString',RANDOM_CALC_TP)
        set(ui_button_calc_random,'Callback',{@cb_calc_random})
    end
    function update_calc_ganame()
        ganame = ga.getProp(MRICohort.NAME);
        if isempty(ganame)
            set(f,'Name',[APPNAME ' - ' BNC.VERSION])
        else
            set(f,'Name',[APPNAME ' - ' BNC.VERSION ' - ' ganame])
        end
        set(ui_edit_calc_ganame,'String',ganame)
    end
    function cb_calc_ganame(~,~)  % (src,event)
        ga.setProp(MRIGraphAnalysis.NAME,get(ui_edit_calc_ganame,'String'));
        update_calc_ganame()
    end
    function cb_calc_new(~,~)  %  (src,event)
        GUIMRIGraphAnalysis(copy(ga.getCohort()))
    end
    function cb_comm_view(~,~)  % (src,event)
        GUIMRIGraphAnalysisStructure(fig_structure,ga,true);
    end
    function update_calc_table()
        
        update_popups_grouplists()
        
        mlist = measurelist();
        
        data = cell(length(mlist),4);
        for mi = 1:1:length(mlist)
            if any(selected_calc==mi)
                data{mi,CALC_SELECTED_COL} = true;
            else
                data{mi,CALC_SELECTED_COL} = false;
            end
            data{mi,CALC_NAME_COL} = Graph.NAME{mlist(mi)};
            if Graph.isnodal(mlist(mi))
                data{mi,CALC_NODAL_COL} = CALC_NODAL_YES;
            else
                data{mi,CALC_NODAL_COL} = CALC_NODAL_NO;
            end
            data{mi,CALC_TXT_COL} = Graph.TXT{mlist(mi)};
        end
        set(ui_table_calc,'Data',data)
    end
    function cb_calc_edit(~,event)  % (src,event)
        mi = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case CALC_SELECTED_COL
                if newdata==1
                    selected_calc = sort(unique([selected_calc(:); mi]));
                else
                    selected_calc = selected_calc(selected_calc~=mi);
                end
        end
    end
    function cb_calc_selectall(~,~)  % (src,event)
        mlist = GraphBU.measurelist();
        
        selected_calc = (1:1:length(mlist))';
        update_calc_table()
    end
    function cb_calc_clearselection(~,~)  % (src,event)
        selected_calc = [];
        update_calc_table()
    end
    function cb_calc_global(~,~)  % (src,event)
        selected_calc = [];
        mlist = measurelist();
        for mi = 1:1:length(mlist)
            if Graph.isglobal(mlist(mi))
                selected_calc = [selected_calc; mi];
            end
        end
        update_calc_table()
    end
    function cb_calc_nodal(~,~)  % (src,event)
        selected_calc = [];
        mlist = measurelist();
        for mi = 1:1:length(mlist)
            if Graph.isnodal(mlist(mi))
                selected_calc = [selected_calc; mi];
            end
        end
        update_calc_table()
    end
    function cb_calc_calculate(~,~)  %  (src,event)
        mlist = measurelist();
        GUIMRIGraphAnalysisBUTCalcMeas(ga,mlist,selected_calc)
    end
    function cb_calc_compare(~,~)  %  (src,event)
        mlist = measurelist();
        GUIMRIGraphAnalysisBUTCalcComp(ga,mlist,selected_calc)
    end
    function cb_calc_random(~,~)  %  (src,event)
        mlist = measurelist();
        GUIMRIGraphAnalysisBUTCalcRand(ga,mlist,selected_calc)
    end
    function setup_calc_corr()
        set(ui_popup_calc_corr,'Value',find(strcmp(MRIGraphAnalysis.CORR_OPTIONS,ga.getProp(MRIGraphAnalysis.CORR))))
        set(ui_popup_calc_graph,'Value',find(strcmp(MRIGraphAnalysis.GRAPH_OPTIONS,ga.getProp(MRIGraphAnalysis.GRAPH))))
        set(ui_popup_calc_neg,'Value',find(strcmp(MRIGraphAnalysis.NEG_OPTIONS,ga.getProp(MRIGraphAnalysis.NEG))))
        
        set(ui_popup_calc_corr,'Enable','off')
        set(ui_popup_calc_graph,'Enable','off')
        set(ui_popup_calc_neg,'Enable','off')
        
        set(ui_button_calc_new,'String',NEW_BUTTON_CMD)
        set(ui_button_calc_new,'TooltipString',NEW_BUTTON_TP)
    end
    function mlist = measurelist()
        mlist = GraphBU.measurelist();
    end

%% Panel Console
CONSOLE_WIDTH = 1-LEFTCOLUMN_WIDTH-3*MARGIN_X;
CONSOLE_HEIGHT = HEADING_HEIGHT;
CONSOLE_X0 = LEFTCOLUMN_WIDTH+2*MARGIN_X;
CONSOLE_Y0 = 1-MARGIN_Y-CONSOLE_HEIGHT;
CONSOLE_POSITION = [CONSOLE_X0 CONSOLE_Y0 CONSOLE_WIDTH CONSOLE_HEIGHT];

CONSOLE_MATRIX_CMD = 'Correlation Matrix';
CONSOLE_MATRIX_SC = '1';
CONSOLE_MATRIX_TP = ['Visualizes correlation matrix. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_MATRIX_SC];

CONSOLE_BRAINMEASURES_CMD = 'Global Measures';
CONSOLE_BRAINMEASURES_SC = '2';
CONSOLE_BRAINMEASURES_TP = ['Manages the brain measures. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_BRAINMEASURES_SC];

CONSOLE_REGIONMEASURES_CMD = 'Nodal Measures';
CONSOLE_REGIONMEASURES_SC = '3';
CONSOLE_REGIONMEASURES_TP = ['Manages the regional measures. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_REGIONMEASURES_SC];

CONSOLE_BRAINVIEW_CMD = 'Brain View';
CONSOLE_BRAINVIEW_SC = '4';
CONSOLE_BRAINVIEW_TP = ['Visualizes the nodal measures on the brain. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_BRAINVIEW_SC];

ui_panel_console = uipanel();
ui_button_console_matrix = uicontrol(ui_panel_console,'Style', 'pushbutton');
ui_button_console_brainmeasures = uicontrol(ui_panel_console,'Style', 'pushbutton');
ui_button_console_regionmeasures = uicontrol(ui_panel_console,'Style', 'pushbutton');
ui_button_console_brainview = uicontrol(ui_panel_console,'Style', 'pushbutton');
init_console()
    function init_console()
        GUI.setUnits(ui_panel_console)
        GUI.setBackgroundColor(ui_panel_console)
        
        set(ui_panel_console,'Position',CONSOLE_POSITION)
        set(ui_panel_console,'BorderType','none')
        
        set(ui_button_console_matrix,'Position',[.05 .30 .15 .40])
        set(ui_button_console_matrix,'String',CONSOLE_MATRIX_CMD)
        set(ui_button_console_matrix,'TooltipString',CONSOLE_MATRIX_TP)
        set(ui_button_console_matrix,'Callback',{@cb_console_matrix})
        
        set(ui_button_console_brainmeasures,'Position',[.30 .30 .15 .40])
        set(ui_button_console_brainmeasures,'String',CONSOLE_BRAINMEASURES_CMD)
        set(ui_button_console_brainmeasures,'TooltipString',CONSOLE_BRAINMEASURES_TP)
        set(ui_button_console_brainmeasures,'Callback',{@cb_console_brainmeasures})
        
        set(ui_button_console_regionmeasures,'Position',[.55 .30 .15 .40])
        set(ui_button_console_regionmeasures,'String',CONSOLE_REGIONMEASURES_CMD)
        set(ui_button_console_regionmeasures,'TooltipString',CONSOLE_REGIONMEASURES_TP)
        set(ui_button_console_regionmeasures,'Callback',{@cb_console_regionmeasures})
        
        set(ui_button_console_brainview,'Position',[.80 .30 .15 .40])
        set(ui_button_console_brainview,'String',CONSOLE_BRAINVIEW_CMD)
        set(ui_button_console_brainview,'TooltipString',CONSOLE_BRAINVIEW_TP)
        set(ui_button_console_brainview,'Callback',{@cb_console_brainview})
    end
    function update_console_panel_visibility(console_panel_cmd)
        switch console_panel_cmd
            case CONSOLE_BRAINMEASURES_CMD
                set(ui_panel_matrix,'Visible','off')
                set(ui_panel_brainmeasures,'Visible','on')
                set(ui_panel_regionmeasures,'Visible','off')
                set(ui_panel_brainview,'Visible','off')
                
                set(ui_button_console_matrix,'FontWeight','normal')
                set(ui_button_console_brainmeasures,'FontWeight','bold')
                set(ui_button_console_regionmeasures,'FontWeight','normal')
                set(ui_button_console_brainview,'FontWeight','normal')
                
                set([ui_toolbar_zoomin ...
                    ui_toolbar_zoomout ...
                    ui_toolbar_pan ...
                    ui_toolbar_datacursor ...
                    ui_toolbar_insertcolorbar], ...
                    'Visible','on')
                set([ui_toolbar_rotate ...
                    ui_toolbar_3D ...
                    ui_toolbar_SL ...
                    ui_toolbar_SR ...
                    ui_toolbar_AD ...
                    ui_toolbar_AV ...
                    ui_toolbar_CP ...
                    ui_toolbar_CA ...
                    ui_toolbar_brain ...
                    ui_toolbar_br ...
                    ui_toolbar_axis ...
                    ui_toolbar_grid ...
                    ui_toolbar_label ...
                    ui_toolbar_sym], ...
                    'Visible','off')
                set(ui_toolbar_brain,'Separator','off');
                set(ui_toolbar_3D,'Separator','off');
                
            case CONSOLE_REGIONMEASURES_CMD
                set(ui_panel_matrix,'Visible','off')
                set(ui_panel_brainmeasures,'Visible','off')
                set(ui_panel_regionmeasures,'Visible','on')
                set(ui_panel_brainview,'Visible','off')
                
                set(ui_button_console_matrix,'FontWeight','normal')
                set(ui_button_console_brainmeasures,'FontWeight','normal')
                set(ui_button_console_regionmeasures,'FontWeight','bold')
                set(ui_button_console_brainview,'FontWeight','normal')
                
                set([ui_toolbar_zoomin ...
                    ui_toolbar_zoomout ...
                    ui_toolbar_pan ...
                    ui_toolbar_datacursor ...
                    ui_toolbar_insertcolorbar], ...
                    'Visible','on')
                set([ui_toolbar_rotate ...
                    ui_toolbar_3D ...
                    ui_toolbar_SL ...
                    ui_toolbar_SR ...
                    ui_toolbar_AD ...
                    ui_toolbar_AV ...
                    ui_toolbar_CP ...
                    ui_toolbar_CA ...
                    ui_toolbar_brain ...
                    ui_toolbar_br ...
                    ui_toolbar_axis ...
                    ui_toolbar_grid ...
                    ui_toolbar_label ...
                    ui_toolbar_sym], ...
                    'Visible','off')
                set(ui_toolbar_brain,'Separator','off');
                set(ui_toolbar_3D,'Separator','off');
                
            case CONSOLE_BRAINVIEW_CMD
                set(ui_panel_matrix,'Visible','off')
                set(ui_panel_brainmeasures,'Visible','off')
                set(ui_panel_regionmeasures,'Visible','off')
                set(ui_panel_brainview,'Visible','on')
                
                set(ui_button_console_matrix,'FontWeight','normal')
                set(ui_button_console_brainmeasures,'FontWeight','normal')
                set(ui_button_console_regionmeasures,'FontWeight','normal')
                set(ui_button_console_brainview,'FontWeight','bold')
                
                set([ui_toolbar_zoomin ...
                    ui_toolbar_zoomout ...
                    ui_toolbar_pan ...
                    ui_toolbar_datacursor ...
                    ui_toolbar_insertcolorbar ...
                    ui_toolbar_rotate ...
                    ui_toolbar_3D ...
                    ui_toolbar_SL ...
                    ui_toolbar_SR ...
                    ui_toolbar_AD ...
                    ui_toolbar_AV ...
                    ui_toolbar_CP ...
                    ui_toolbar_CA ...
                    ui_toolbar_brain ...
                    ui_toolbar_br ...
                    ui_toolbar_axis ...
                    ui_toolbar_grid ...
                    ui_toolbar_label ...
                    ui_toolbar_sym], ...
                    'Visible','on')
                set(ui_toolbar_brain,'Separator','on');
                set(ui_toolbar_3D,'Separator','on');
                
            otherwise % CONSOLE_MATRIX_CMD
                set(ui_panel_matrix,'Visible','on')
                set(ui_panel_brainmeasures,'Visible','off')
                set(ui_panel_regionmeasures,'Visible','off')
                set(ui_panel_brainview,'Visible','off')
                
                set(ui_button_console_matrix,'FontWeight','bold')
                set(ui_button_console_brainmeasures,'FontWeight','normal')
                set(ui_button_console_regionmeasures,'FontWeight','normal')
                set(ui_button_console_brainview,'FontWeight','normal')
                
                set([ui_toolbar_zoomin ...
                    ui_toolbar_zoomout ...
                    ui_toolbar_pan ...
                    ui_toolbar_datacursor ...
                    ui_toolbar_insertcolorbar], ...
                    'Visible','on')
                set([ui_toolbar_rotate ...
                    ui_toolbar_3D ...
                    ui_toolbar_SL ...
                    ui_toolbar_SR ...
                    ui_toolbar_AD ...
                    ui_toolbar_AV ...
                    ui_toolbar_CP ...
                    ui_toolbar_CA ...
                    ui_toolbar_brain ...
                    ui_toolbar_br ...
                    ui_toolbar_axis ...
                    ui_toolbar_grid ...
                    ui_toolbar_label ...
                    ui_toolbar_sym], ...
                    'Visible','off')
                set(ui_toolbar_brain,'Separator','off');
                set(ui_toolbar_3D,'Separator','off');
        end
    end
    function update_console_panel()
        update_popups_grouplists()
        
        if strcmpi(get(ui_panel_matrix,'Visible'),'on')
            update_matrix()
        elseif strcmpi(get(ui_panel_brainmeasures,'Visible'),'on')
            update_brainmeasures()
        elseif strcmpi(get(ui_panel_regionmeasures,'Visible'),'on')
            update_regionmeasures()
        elseif strcmpi(get(ui_panel_brainview,'Visible'),'on')
            update_brainview()
        end
    end
    function cb_console_matrix(~,~)  % (src,event)
        update_matrix()
        update_console_panel_visibility(CONSOLE_MATRIX_CMD)
    end
    function cb_console_brainmeasures(~,~)  % (src,event)
        update_brainmeasures()
        update_console_panel_visibility(CONSOLE_BRAINMEASURES_CMD)
    end
    function cb_console_regionmeasures(~,~)  % (src,event)
        update_regionmeasures()
        update_console_panel_visibility(CONSOLE_REGIONMEASURES_CMD)
    end
    function cb_console_brainview(~,~)  % (src,event)
        update_brainview()
        update_console_panel_visibility(CONSOLE_BRAINVIEW_CMD)
    end

%% Panel 1 - Matrix
ui_panel_matrix = uipanel();
ui_axes_matrix = axes();
ui_text_matrix_group = uicontrol(ui_panel_matrix,'Style','text');
ui_popup_matrix_group = uicontrol(ui_panel_matrix,'Style','popup','String',{''});
ui_checkbox_matrix_w = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_checkbox_matrix_rearrange = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_checkbox_matrix_divide = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_checkbox_matrix_hist = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_checkbox_matrix_bs = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_edit_matrix_bs = uicontrol(ui_panel_matrix,'Style','edit');
ui_slider_matrix_bs = uicontrol(ui_panel_matrix,'Style','slider');
ui_checkbox_matrix_bt = uicontrol(ui_panel_matrix,'Style', 'checkbox');
ui_edit_matrix_bt = uicontrol(ui_panel_matrix,'Style','edit');
ui_slider_matrix_bt = uicontrol(ui_panel_matrix,'Style','slider');
init_matrix()
    function init_matrix()
        GUI.setUnits(ui_panel_matrix)
        GUI.setBackgroundColor(ui_panel_matrix)
        
        set(ui_panel_matrix,'Position',MAINPANEL_POSITION)
        set(ui_panel_matrix,'Title',CONSOLE_MATRIX_CMD)
        
        set(ui_axes_matrix,'Parent',ui_panel_matrix)
        set(ui_axes_matrix,'Position',[.05 .05 .60 .88])
        
        set(ui_text_matrix_group,'Position',[.69 .88 .05 .045])
        set(ui_text_matrix_group,'String','Group  ')
        set(ui_text_matrix_group,'HorizontalAlignment','right')
        set(ui_text_matrix_group,'FontWeight','bold')
        
        ui_popups_grouplists = [ui_popups_grouplists ui_popup_matrix_group];
        set(ui_popup_matrix_group,'Position',[.75 .88 .23 .05])
        set(ui_popup_matrix_group,'TooltipString','Select group');
        set(ui_popup_matrix_group,'Callback',{@cb_matrix});
        
        set(ui_checkbox_matrix_w,'Position',[.70 .82 .28 .05])
        set(ui_checkbox_matrix_w,'String','weighted correlation matrix')
        set(ui_checkbox_matrix_w,'Value',true)
        set(ui_checkbox_matrix_w,'TooltipString','Select weighted matrix')
        set(ui_checkbox_matrix_w,'FontWeight','bold')
        set(ui_checkbox_matrix_w,'Callback',{@cb_matrix_w})
        
        set(ui_checkbox_matrix_hist,'Position',[.70 .76 .28 .05])
        set(ui_checkbox_matrix_hist,'String','histogram')
        set(ui_checkbox_matrix_hist,'Value',false)
        set(ui_checkbox_matrix_hist,'TooltipString','Select histogram of correlation coefficients')
        set(ui_checkbox_matrix_hist,'Callback',{@cb_matrix_hist})
        
        set(ui_checkbox_matrix_bs,'Position',[.70 .70 .28 .05])
        set(ui_checkbox_matrix_bs,'String','binary correlation matrix (set density)')
        set(ui_checkbox_matrix_bs,'Value',false)
        set(ui_checkbox_matrix_bs,'TooltipString','Select binary correlation matrix with a set density')
        set(ui_checkbox_matrix_bs,'Callback',{@cb_matrix_bs})
        
        set(ui_edit_matrix_bs,'Position',[.70 .675 .05 .025])
        set(ui_edit_matrix_bs,'String','50.00');
        set(ui_edit_matrix_bs,'TooltipString','Set density.');
        set(ui_edit_matrix_bs,'FontWeight','bold')
        set(ui_edit_matrix_bs,'Enable','off')
        set(ui_edit_matrix_bs,'Callback',{@cb_matrix_edit_bs});
        
        set(ui_slider_matrix_bs,'Position',[.75 .675 .23 .025])
        set(ui_slider_matrix_bs,'Min',0,'Max',100,'Value',50)
        set(ui_slider_matrix_bs,'TooltipString','Set density.')
        set(ui_slider_matrix_bs,'Enable','off')
        set(ui_slider_matrix_bs,'Callback',{@cb_matrix_slider_bs})
        
        set(ui_checkbox_matrix_bt,'Position',[.70 .60 .28 .05])
        set(ui_checkbox_matrix_bt,'String','binary correlation matrix (set threshold)')
        set(ui_checkbox_matrix_bt,'Value',false)
        set(ui_checkbox_matrix_bt,'TooltipString','Select binary correlation matrix with a set threshold')
        set(ui_checkbox_matrix_bt,'Callback',{@cb_matrix_bt})
        
        set(ui_edit_matrix_bt,'Position',[.70 .575 .05 .025])
        set(ui_edit_matrix_bt,'String','0.50');
        set(ui_edit_matrix_bt,'TooltipString','Set threshold.');
        set(ui_edit_matrix_bt,'FontWeight','bold')
        set(ui_edit_matrix_bt,'Enable','off')
        set(ui_edit_matrix_bt,'Callback',{@cb_matrix_edit_bt});
        
        set(ui_slider_matrix_bt,'Position',[.75 .575 .23 .025])
        set(ui_slider_matrix_bt,'Min',-1,'Max',1,'Value',.50)
        set(ui_slider_matrix_bt,'TooltipString','Set threshold.')
        set(ui_slider_matrix_bt,'Enable','off')
        set(ui_slider_matrix_bt,'Callback',{@cb_matrix_slider_bt})
        
        set(ui_checkbox_matrix_rearrange,'Position',[.70 .50 .28 .05])
        set(ui_checkbox_matrix_rearrange,'String','rearrange to reflect community structure')
        set(ui_checkbox_matrix_rearrange,'Value',false)
        set(ui_checkbox_matrix_rearrange,'TooltipString','Rearrange the matrix to reflect communities')
        set(ui_checkbox_matrix_rearrange,'FontWeight','normal')
        set(ui_checkbox_matrix_rearrange,'Callback',{@cb_matrix_rearrange})
        
        set(ui_checkbox_matrix_divide,'Position',[.70 .455 .28 .05])
        set(ui_checkbox_matrix_divide,'String','divide communities')
        set(ui_checkbox_matrix_divide,'Value',false)
        set(ui_checkbox_matrix_divide,'TooltipString','Draw lines to divide communities')
        set(ui_checkbox_matrix_divide,'FontWeight','normal')
        set(ui_checkbox_matrix_divide,'enable','off')
        set(ui_checkbox_matrix_divide,'Callback',{@cb_matrix_divide})
        
    end
    function S = update_rearrange()
        group = get(ui_popup_matrix_group,'value');
        graph = GraphBU(ga.getA(group),'structure',ga.getStructure(),'threshold',str2num(get(ui_edit_matrix_bt,'String')));
        [S,~] = graph.structure();
    end
    function update_matrix()
        update_popups_grouplists()
        br_regions = ga.getBrainAtlas().getProps(BrainRegion.LABEL);
        
        if ga.getCohort().groupnumber()>0
            g = get(ui_popup_matrix_group,'value');  % selected group
            
            cla(ui_axes_matrix)
            axes(ui_axes_matrix)
            if get(ui_checkbox_matrix_w,'Value')
                
                if get(ui_checkbox_matrix_rearrange,'Value')
                    
                    if isequal(ga.getStructure().getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = ga.getStructure().getCi();
                    end
                    
                    if ~isempty(S)
                        
                        N_comm = numel(unique(S));
                        indices = cell(1,N_comm);
                        for n = 1:1:N_comm
                            indices{1,n} = find(S==n);
                        end
                        A = ga.getA(g);
                        A_all = cat(2,indices{:});
                        B = A(:,A_all);
                        B = B(A_all,:);
                        
                        Graph.plotw(B, ...
                            'xlabels',br_regions(A_all), ...
                            'ylabels',br_regions(A_all))
                        
                        if get(ui_checkbox_matrix_divide,'Value')
                            hold on
                            
                            z = max(max(B));
                            for n = 1:1:numel(indices())
                                pi = find(A_all==indices{1,n}(1))-0.5;
                                pf = find(A_all==indices{1,n}(end))-0.5;
                                
                                plot3([pi pf pf pi pi],[pi pi pf pf pi],[z z z z z],'LineWidth',2,'Color','k')
                            end
                            view(2)
                        end
                        
                    else
                        
                        Graph.plotw(ga.getA(g), ...
                            'xlabels',br_regions, ...
                            'ylabels',br_regions)
                        
                    end
                    
                else
                    
                    Graph.plotw(ga.getA(g), ...
                        'xlabels',br_regions, ...
                        'ylabels',br_regions)
                end
                
            elseif get(ui_checkbox_matrix_hist,'Value')
                
                Graph.hist(ga.getA(g))
            elseif get(ui_checkbox_matrix_bs,'Value')
                
                if get(ui_checkbox_matrix_rearrange,'Value')
                    
                    if isequal(ga.getStructure().getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = ga.getStructure().getCi();
                    end
                    
                    if ~isempty(S)
                        
                        N_comm = numel(unique(S));
                        indices = cell(1,N_comm);
                        for n = 1:1:N_comm
                            indices{1,n} = find(S==n);
                        end
                        
                        A = ga.getA(g);
                        A_all = cat(2,indices{:});
                        B = A(:,A_all);
                        B = B(A_all,:);
                        
                        graph = GraphBU(B,'density',str2num(get(ui_edit_matrix_bs,'String')));
                        
                        Graph.plotb(B, ...
                            'threshold',graph.threshold, ...
                            'xlabels',br_regions(A_all), ...
                            'ylabels',br_regions(A_all))
                        
                        set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                        set(ui_slider_matrix_bs,'Value',graph.density)
                        
                        set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                        set(ui_slider_matrix_bt,'Value',graph.threshold)
                        
                        if get(ui_checkbox_matrix_divide,'Value')
                            hold on
                            
                            z = max(max(B));
                            for n = 1:1:numel(indices())
                                pi = find(A_all==indices{1,n}(1))-0.5;
                                pf = find(A_all==indices{1,n}(end))-0.5;
                                
                                plot3([pi pf pf pi pi],[pi pi pf pf pi],[z z z z z],'LineWidth',2,'Color','r')
                            end
                            view(2)
                        end
                    else
                        
                        graph = GraphBU(ga.getA(g),'density',str2num(get(ui_edit_matrix_bs,'String')));
                        
                        Graph.plotb(ga.getA(g), ...
                            'threshold',graph.threshold, ...
                            'xlabels',br_regions, ...
                            'ylabels',br_regions)
                        
                        set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                        set(ui_slider_matrix_bs,'Value',graph.density)
                        
                        set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                        set(ui_slider_matrix_bt,'Value',graph.threshold)
                        
                    end
                    
                else
                    
                    graph = GraphBU(ga.getA(g),'density',str2num(get(ui_edit_matrix_bs,'String')));
                    
                    Graph.plotb(ga.getA(g), ...
                        'threshold',graph.threshold, ...
                        'xlabels',br_regions, ...
                        'ylabels',br_regions)
                    
                    set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                    set(ui_slider_matrix_bs,'Value',graph.density)
                    
                    set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                    set(ui_slider_matrix_bt,'Value',graph.threshold)
                end
                
            elseif get(ui_checkbox_matrix_bt,'Value')
                
                if get(ui_checkbox_matrix_rearrange,'Value')
                    
                    if isequal(ga.getStructure().getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = ga.getStructure().getCi();
                    end
                    
                    if ~isempty(S)
                        
                        N_comm = numel(unique(S));
                        indices = cell(1,N_comm);
                        for n = 1:1:N_comm
                            indices{1,n} = find(S==n);
                        end
                        
                        A = ga.getA(g);
                        A_all = cat(2,indices{:});
                        B = A(:,A_all);
                        B = B(A_all,:);
                        
                        graph = GraphBU(B,'threshold',str2num(get(ui_edit_matrix_bt,'String')));
                        
                        Graph.plotb(B, ...
                            'threshold',graph.threshold, ...
                            'xlabels',br_regions(A_all), ...
                            'ylabels',br_regions(A_all))
                        
                        set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                        set(ui_slider_matrix_bs,'Value',graph.density)
                        
                        set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                        set(ui_slider_matrix_bt,'Value',graph.threshold)
                        
                        if get(ui_checkbox_matrix_divide,'Value')
                            hold on
                            
                            z = max(max(B));
                            for n = 1:1:numel(indices())
                                pi = find(A_all==indices{1,n}(1))-0.5;
                                pf = find(A_all==indices{1,n}(end))-0.5;
                                
                                plot3([pi pf pf pi pi],[pi pi pf pf pi],[z z z z z],'LineWidth',2,'Color','r')
                            end
                            view(2)
                        end
                    else
                        
                        graph = GraphBU(ga.getA(g),'threshold',str2num(get(ui_edit_matrix_bt,'String')));
                        
                        Graph.plotb(ga.getA(g), ...
                            'threshold',graph.threshold, ...
                            'xlabels',br_regions, ...
                            'ylabels',br_regions)
                        
                        set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                        set(ui_slider_matrix_bs,'Value',graph.density)
                        
                        set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                        set(ui_slider_matrix_bt,'Value',graph.threshold)
                        
                    end
                    
                else
                    
                    graph = GraphBU(ga.getA(g),'threshold',str2num(get(ui_edit_matrix_bt,'String')));
                    
                    Graph.plotb(ga.getA(g), ...
                        'threshold',graph.threshold, ...
                        'xlabels',br_regions, ...
                        'ylabels',br_regions)
                    
                    set(ui_edit_matrix_bs,'String',num2str(graph.density,'%6.2f'))
                    set(ui_slider_matrix_bs,'Value',graph.density)
                    
                    set(ui_edit_matrix_bt,'String',num2str(graph.threshold,'%6.3f'))
                    set(ui_slider_matrix_bt,'Value',graph.threshold)
                end
            end
        end
    end
    function cb_matrix(~,~)  % (src,event)
        update_matrix()
    end
    function cb_matrix_w(~,~)  % (src,event)
        set(ui_checkbox_matrix_w,'Value',true)
        set(ui_checkbox_matrix_w,'FontWeight','bold')
        
        set(ui_checkbox_matrix_hist,'Value',false)
        set(ui_checkbox_matrix_hist,'FontWeight','normal')
        
        set(ui_checkbox_matrix_bs,'Value',false)
        set(ui_checkbox_matrix_bs,'FontWeight','normal')
        set(ui_edit_matrix_bs,'Enable','off')
        set(ui_slider_matrix_bs,'Enable','off')
        
        set(ui_checkbox_matrix_bt,'Value',false)
        set(ui_checkbox_matrix_bt,'FontWeight','normal')
        set(ui_edit_matrix_bt,'Enable','off')
        set(ui_slider_matrix_bt,'Enable','off')
        
        update_matrix()
    end
    function cb_matrix_hist(~,~)  % (src,event)
        set(ui_checkbox_matrix_w,'Value',false)
        set(ui_checkbox_matrix_w,'FontWeight','normal')
        
        set(ui_checkbox_matrix_hist,'Value',true)
        set(ui_checkbox_matrix_hist,'FontWeight','bold')
        
        set(ui_checkbox_matrix_bs,'Value',false)
        set(ui_checkbox_matrix_bs,'FontWeight','normal')
        set(ui_edit_matrix_bs,'Enable','off')
        set(ui_slider_matrix_bs,'Enable','off')
        
        set(ui_checkbox_matrix_bt,'Value',false)
        set(ui_checkbox_matrix_bt,'FontWeight','normal')
        set(ui_edit_matrix_bt,'Enable','off')
        set(ui_slider_matrix_bt,'Enable','off')
        
        update_matrix()
    end
    function cb_matrix_rearrange(src,~)  % (src,event)
        if (get(src,'Value') == get(src,'Max'))
            set(ui_checkbox_matrix_rearrange,'Value',true)
            set(ui_checkbox_matrix_rearrange,'FontWeight','bold')
            set(ui_checkbox_matrix_divide,'Enable','on')
            update_matrix()
        else
            set(ui_checkbox_matrix_rearrange,'Value',false)
            set(ui_checkbox_matrix_rearrange,'FontWeight','normal')
            set(ui_checkbox_matrix_divide,'Enable','off')
            update_matrix()
        end
    end
    function cb_matrix_divide(src,~)  % (src,event)
        if (get(src,'Value') == get(src,'Max'))
            set(ui_checkbox_matrix_divide,'Value',true)
            set(ui_checkbox_matrix_divide,'FontWeight','bold')
            
            update_matrix()
        else
            set(ui_checkbox_matrix_divide,'Value',false)
            set(ui_checkbox_matrix_divide,'FontWeight','normal')
            
            update_matrix()
        end
    end
    function cb_matrix_bs(~,~)  % (src,event)
        set(ui_checkbox_matrix_w,'Value',false)
        set(ui_checkbox_matrix_w,'FontWeight','normal')
        
        set(ui_checkbox_matrix_hist,'Value',false)
        set(ui_checkbox_matrix_hist,'FontWeight','normal')
        
        set(ui_checkbox_matrix_bs,'Value',true)
        set(ui_checkbox_matrix_bs,'FontWeight','bold')
        set(ui_edit_matrix_bs,'Enable','on')
        set(ui_slider_matrix_bs,'Enable','on')
        
        set(ui_checkbox_matrix_bt,'Value',false)
        set(ui_checkbox_matrix_bt,'FontWeight','normal')
        set(ui_edit_matrix_bt,'Enable','off')
        set(ui_slider_matrix_bt,'Enable','off')
        
        update_matrix()
    end
    function cb_matrix_bt(~,~)  % (src,event)
        set(ui_checkbox_matrix_w,'Value',false)
        set(ui_checkbox_matrix_w,'FontWeight','normal')
        
        set(ui_checkbox_matrix_hist,'Value',false)
        set(ui_checkbox_matrix_hist,'FontWeight','normal')
        
        set(ui_checkbox_matrix_bs,'Value',false)
        set(ui_checkbox_matrix_bs,'FontWeight','normal')
        set(ui_edit_matrix_bs,'Enable','off')
        set(ui_slider_matrix_bs,'Enable','off')
        
        set(ui_checkbox_matrix_bt,'Value',true)
        set(ui_checkbox_matrix_bt,'FontWeight','bold')
        set(ui_edit_matrix_bt,'Enable','on')
        set(ui_slider_matrix_bt,'Enable','on')
        
        update_matrix()
    end
    function cb_matrix_edit_bs(src,~)  % (src,event)
        update_matrix();
    end
    function cb_matrix_slider_bs(src,~)  % (src,event)
        set(ui_edit_matrix_bs,'String',get(src,'Value'))
        update_matrix();
    end
    function cb_matrix_edit_bt(src,~)  % (src,event)(src,event)
        update_matrix();
    end
    function cb_matrix_slider_bt(src,~)  % (src,event)
        set(ui_edit_matrix_bt,'String',get(src,'Value'))
        update_matrix();
    end

%% Panel 2 - Brain Measures
BRAINMEASURES_MEAS_SELECTED_COL = 1;
BRAINMEASURES_MEAS_VALUE_COL = 2;
BRAINMEASURES_MEAS_THRESHOLD_COL = 3;
BRAINMEASURES_MEAS_DENSITY_COL = 4;
BRAINMEASURES_MEAS_NOTES_COL = 5;
BRAINMEASURES_MEAS_MEASURE_COL = 6;
BRAINMEASURES_MEAS_PARAM_COL = 7;
BRAINMEASURES_MEAS_GROUP_COL = 8;

BRAINMEASURES_COMP_SELECTED_COL = 1;
BRAINMEASURES_COMP_DIFF_COL = 2;
BRAINMEASURES_COMP_PVALUE1_COL = 3;
BRAINMEASURES_COMP_PVALUE2_COL = 4;
BRAINMEASURES_COMP_VALUE1_COL = 5;
BRAINMEASURES_COMP_VALUE2_COL = 6;
BRAINMEASURES_COMP_CIL_COL = 7;
BRAINMEASURES_COMP_CIU_COL = 8;
BRAINMEASURES_COMP_THRESHOLD_COL = 9;
BRAINMEASURES_COMP_DENSITY1_COL = 10;
BRAINMEASURES_COMP_DENSITY2_COL = 11;
BRAINMEASURES_COMP_NOTES_COL = 12;
BRAINMEASURES_COMP_MEASURE_COL = 13;
BRAINMEASURES_COMP_PARAM_COL = 14;
BRAINMEASURES_COMP_GROUP1_COL = 15;
BRAINMEASURES_COMP_GROUP2_COL = 16;

BRAINMEASURES_RAND_SELECTED_COL = 1;
BRAINMEASURES_RAND_COMPVALUE_COL = 2;
BRAINMEASURES_RAND_PVALUE1_COL = 3;
BRAINMEASURES_RAND_PVALUE2_COL = 4;
BRAINMEASURES_RAND_REALVALUE_COL = 5;
BRAINMEASURES_RAND_CIL_COL = 6;
BRAINMEASURES_RAND_CIU_COL = 7;
BRAINMEASURES_RAND_THRESHOLD_COL = 8;
BRAINMEASURES_RAND_DENSITY_COL = 9;
BRAINMEASURES_RAND_NOTES_COL = 10;
BRAINMEASURES_RAND_MEASURE_COL = 11;
BRAINMEASURES_RAND_PARAM_COL = 12;
BRAINMEASURES_RAND_GROUP_COL = 13;

BRAINMEASURES_LABEL_THRESHOLD = 'threshold [n.u.]';
BRAINMEASURES_LABEL_DENSITY = ' density [n.u.]';
BRAINMEASURES_LABEL_MEASURE = 'measure';
BRAINMEASURES_LABEL_MEASDIFF = 'difference';
BRAINMEASURES_LABEL_RANDOM = 'comp. with random matrix';

ui_panel_brainmeasures = uipanel();

ui_table_brainmeasures = uitable(ui_panel_brainmeasures);
ui_button_brainmeasures_selectall = uicontrol(ui_panel_brainmeasures,'Style', 'pushbutton');
ui_button_brainmeasures_clearselection = uicontrol(ui_panel_brainmeasures,'Style', 'pushbutton');
ui_button_brainmeasures_remove = uicontrol(ui_panel_brainmeasures,'Style', 'pushbutton');
ui_checkbox_brainmeasures_meas = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_checkbox_brainmeasures_comp = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_checkbox_brainmeasures_rand = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_popup_brainmeasures_comp = uicontrol(ui_panel_brainmeasures,'Style','popup','String',{''});
ui_popup_brainmeasures_comp_group1 = uicontrol(ui_panel_brainmeasures,'Style','popup','String',{''});
ui_popup_brainmeasures_comp_group2 = uicontrol(ui_panel_brainmeasures,'Style','popup','String',{''});
init_brainmeasures_table()
    function init_brainmeasures_table()
        GUI.setUnits(ui_panel_brainmeasures)
        GUI.setBackgroundColor(ui_panel_brainmeasures)
        
        set(ui_panel_brainmeasures,'Position',MAINPANEL_POSITION)
        set(ui_panel_brainmeasures,'Title',CONSOLE_BRAINMEASURES_CMD)
        
        set(ui_table_brainmeasures,'BackgroundColor',GUI.TABBKGCOLOR)
        set(ui_table_brainmeasures,'Position',[.02 .19 .32 .79])
        set(ui_table_brainmeasures,'CellEditCallback',{@cb_brainmeasures_table_edit})
        
        set(ui_button_brainmeasures_selectall,'Position',[.02 .14 .10 .03])
        set(ui_button_brainmeasures_selectall,'String',SELECTALL_MEAS_CMD)
        set(ui_button_brainmeasures_selectall,'TooltipString',SELECTALL_MEAS_TP)
        set(ui_button_brainmeasures_selectall,'Callback',{@cb_brainmeasures_selectall})
        
        set(ui_button_brainmeasures_clearselection,'Position',[.13 .14 .10 .03])
        set(ui_button_brainmeasures_clearselection,'String',CLEARSELECTION_MEAS_CMD)
        set(ui_button_brainmeasures_clearselection,'TooltipString',CLEARSELECTION_MEAS_TP)
        set(ui_button_brainmeasures_clearselection,'Callback',{@cb_brainmeasures_clearselection})
        
        set(ui_button_brainmeasures_remove,'Position',[.24 .14 .10 .03])
        set(ui_button_brainmeasures_remove,'String',REMOVE_MEAS_CMD)
        set(ui_button_brainmeasures_remove,'TooltipString',REMOVE_MEAS_TP)
        set(ui_button_brainmeasures_remove,'Callback',{@cb_brainmeasures_remove})
        
        set(ui_checkbox_brainmeasures_meas,'Position',[.02 .09 .10 .03])
        set(ui_checkbox_brainmeasures_meas,'String','measure')
        set(ui_checkbox_brainmeasures_meas,'Value',true)
        set(ui_checkbox_brainmeasures_meas,'TooltipString','Select measure')
        set(ui_checkbox_brainmeasures_meas,'FontWeight','bold')
        set(ui_checkbox_brainmeasures_meas,'Callback',{@cb_brainmeasures_meas})
        
        set(ui_checkbox_brainmeasures_comp,'Position',[.12 .09 .10 .03])
        set(ui_checkbox_brainmeasures_comp,'String','comparison')
        set(ui_checkbox_brainmeasures_comp,'Value',false)
        set(ui_checkbox_brainmeasures_comp,'TooltipString','Select comparison')
        set(ui_checkbox_brainmeasures_comp,'Callback',{@cb_brainmeasures_comp})
        
        set(ui_checkbox_brainmeasures_rand,'Position',[.22 .09 .15 .03])
        set(ui_checkbox_brainmeasures_rand,'String','random comparison')
        set(ui_checkbox_brainmeasures_rand,'Value',false)
        set(ui_checkbox_brainmeasures_rand,'TooltipString','Select random comparison')
        set(ui_checkbox_brainmeasures_rand,'Callback',{@cb_brainmeasures_rand})
        
        set(ui_popup_brainmeasures_comp,'Position',[.02 .04 .10 .03])
        set(ui_popup_brainmeasures_comp,'String',Graph.NAME(GraphBU.measurelist(false)))
        set(ui_popup_brainmeasures_comp,'Enable','on')
        set(ui_popup_brainmeasures_comp,'TooltipString','Select measure');
        set(ui_popup_brainmeasures_comp,'Callback',{@cb_brainmeasures_table})
        
        ui_popups_grouplists = [ui_popups_grouplists ui_popup_brainmeasures_comp_group1];
        set(ui_popup_brainmeasures_comp_group1,'Position',[.13 .04 .10 .03])
        set(ui_popup_brainmeasures_comp_group1,'Enable','on')
        set(ui_popup_brainmeasures_comp_group1,'TooltipString','Select group 1');
        set(ui_popup_brainmeasures_comp_group1,'Callback',{@cb_brainmeasures_table})
        
        ui_popups_grouplists = [ui_popups_grouplists ui_popup_brainmeasures_comp_group2];
        set(ui_popup_brainmeasures_comp_group2,'Position',[.24 .04 .10 .03])
        set(ui_popup_brainmeasures_comp_group2,'Enable','off')
        set(ui_popup_brainmeasures_comp_group2,'TooltipString','Select group 2');
        set(ui_popup_brainmeasures_comp_group2,'Callback',{@cb_brainmeasures_table})
    end
    function update_brainmeasures()
        update_brainmeasures_table()
        update_brainmeasures_axes()
    end
    function update_brainmeasures_table()
      
        mlist = GraphBU.measurelist(false);  % list of non-nodal measures
        
        if get(ui_checkbox_brainmeasures_meas,'Value')
            
            [ms,mi] = ga.getMeasures(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
            
            set(ui_table_brainmeasures,'ColumnName',{'',' value ',' threshold ',' density ',' notes ',' measure ',' param ',' group '})
            set(ui_table_brainmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','char','char','numeric','numeric'})
            set(ui_table_brainmeasures,'ColumnEditable',[true false false false false false false false])
            data = cell(length(ms),8);
            for i = 1:1:length(ms)
                if any(selected_brainmeasures==mi(i))
                    data{i,BRAINMEASURES_MEAS_SELECTED_COL} = true;
                else
                    data{i,BRAINMEASURES_MEAS_SELECTED_COL} = false;
                end
                data{i,BRAINMEASURES_MEAS_VALUE_COL} = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                data{i,BRAINMEASURES_MEAS_THRESHOLD_COL} = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                data{i,BRAINMEASURES_MEAS_DENSITY_COL} = ms{i}.getProp(MRIMeasureBUT.DENSITY1);
                data{i,BRAINMEASURES_MEAS_NOTES_COL} = ms{i}.getProp(MRIMeasureBUT.NOTES);
                data{i,BRAINMEASURES_MEAS_MEASURE_COL} = Graph.NAME{ms{i}.getProp(MRIMeasureBUT.CODE)};
                data{i,BRAINMEASURES_MEAS_PARAM_COL} = ms{i}.getProp(MRIMeasureBUT.PARAM);
                data{i,BRAINMEASURES_MEAS_GROUP_COL} = ms{i}.getProp(MRIMeasureBUT.GROUP1);
            end
            
            set(ui_table_brainmeasures,'Data',data)
            
            set(ui_table_brainmeasures,'RowName',mi)
            
        elseif get(ui_checkbox_brainmeasures_comp,'Value')
            
            [cs,ci] = ga.getComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'),get(ui_popup_brainmeasures_comp_group2,'Value'));
            
            set(ui_table_brainmeasures,'ColumnName',{'',' difference ',' p (1-tailed) ',' p (2-tailed) ',' value 1 ',' value 2 ',' CI lower ',' CI upper ',' threshold ',' density 1 ',' density 2 ',' notes ',' measure ',' param ',' group 1 ',' group 2 '})
            set(ui_table_brainmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','char','numeric','numeric','numeric'})
            set(ui_table_brainmeasures,'ColumnEditable',[true false(1,15)])
            
            data = cell(length(cs),16);
            for i = 1:1:length(cs)
                if any(selected_brainmeasures==ci(i))
                    data{i,BRAINMEASURES_COMP_SELECTED_COL} = true;
                else
                    data{i,BRAINMEASURES_COMP_SELECTED_COL} = false;
                end
                
                data{i,BRAINMEASURES_COMP_DIFF_COL} = cs{i}.diff();
                data{i,BRAINMEASURES_COMP_PVALUE1_COL} = cs{i}.getProp(MRIComparisonBUT.PVALUE1);
                data{i,BRAINMEASURES_COMP_PVALUE2_COL} = cs{i}.getProp(MRIComparisonBUT.PVALUE2);
                data{i,BRAINMEASURES_COMP_VALUE1_COL} = cs{i}.getProp(MRIComparisonBUT.VALUES1);
                data{i,BRAINMEASURES_COMP_VALUE2_COL} = cs{i}.getProp(MRIComparisonBUT.VALUES2);
                
                confint = cs{i}.CI(5);
                data{i,BRAINMEASURES_COMP_CIL_COL} = confint(1);
                data{i,BRAINMEASURES_COMP_CIU_COL} = confint(2);
                
                threshold = cs{i}.getProp(MRIComparisonBUT.THRESHOLD);
                data{i,BRAINMEASURES_COMP_THRESHOLD_COL} = threshold;
                
                density1 = cs{i}.getProp(MRIComparisonBUT.DENSITY1);
                density2 = cs{i}.getProp(MRIComparisonBUT.DENSITY2);
                data{i,BRAINMEASURES_COMP_DENSITY1_COL} = density1;
                data{i,BRAINMEASURES_COMP_DENSITY2_COL} = density2;
                
                data{i,BRAINMEASURES_COMP_NOTES_COL} = cs{i}.getProp(MRIComparisonBUT.NOTES);
                data{i,BRAINMEASURES_COMP_MEASURE_COL} = Graph.NAME{cs{i}.getProp(MRIComparisonBUT.CODE)};
                data{i,BRAINMEASURES_COMP_PARAM_COL} = cs{i}.getProp(MRIComparisonBUT.PARAM);
                data{i,BRAINMEASURES_COMP_GROUP1_COL} = cs{i}.getProp(MRIComparisonBUT.GROUP1);
                data{i,BRAINMEASURES_COMP_GROUP2_COL} = cs{i}.getProp(MRIComparisonBUT.GROUP2);
            end
            set(ui_table_brainmeasures,'Data',data)
            
            set(ui_table_brainmeasures,'RowName',ci)
            
        elseif get(ui_checkbox_brainmeasures_rand,'Value')
            
            [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
            
            set(ui_table_brainmeasures,'ColumnName',{'',' comp value ',' p (1-tailed) ',' p (2-tailed) ',' real value ',' CI lower ',' CI upper ',' threshold ',' density ',' notes ',' measure ',' param ',' group '})
            set(ui_table_brainmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','char','numeric','numeric'})
            set(ui_table_brainmeasures,'ColumnEditable',[true false(1,12)])
            
            data = cell(length(ns),13);
            for i = 1:1:length(ns)
                if any(selected_brainmeasures==ni(i))
                    data{i,BRAINMEASURES_RAND_SELECTED_COL} = true;
                else
                    data{i,BRAINMEASURES_RAND_SELECTED_COL} = false;
                end
                data{i,BRAINMEASURES_RAND_COMPVALUE_COL} = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                data{i,BRAINMEASURES_RAND_PVALUE1_COL} = ns{i}.getProp(MRIRandomComparisonBUT.PVALUE1);
                data{i,BRAINMEASURES_RAND_PVALUE2_COL} = ns{i}.getProp(MRIRandomComparisonBUT.PVALUE2);
                data{i,BRAINMEASURES_RAND_REALVALUE_COL} = ns{i}.getProp(MRIRandomComparisonBUT.VALUES1);
                
                confint = ns{i}.CI(5);
                data{i,BRAINMEASURES_RAND_CIL_COL} = confint(1);
                data{i,BRAINMEASURES_RAND_CIU_COL} = confint(2);
                
                threshold = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                data{i,BRAINMEASURES_RAND_THRESHOLD_COL} = threshold;
                
                density = ns{i}.getProp(MRIRandomComparisonBUT.DENSITY1);
                data{i,BRAINMEASURES_RAND_DENSITY_COL} = density;
                
                data{i,BRAINMEASURES_RAND_NOTES_COL} = ns{i}.getProp(MRIRandomComparisonBUT.NOTES);
                data{i,BRAINMEASURES_RAND_MEASURE_COL} = Graph.NAME{ns{i}.getProp(MRIRandomComparisonBUT.CODE)};
                data{i,BRAINMEASURES_RAND_PARAM_COL} = ns{i}.getProp(MRIRandomComparisonBUT.PARAM);
                data{i,BRAINMEASURES_RAND_GROUP_COL} = ns{i}.getProp(MRIRandomComparisonBUT.GROUP1);
            end
            
            set(ui_table_brainmeasures,'Data',data)
            
            set(ui_table_brainmeasures,'RowName',ni)
        end
    end
    function cb_brainmeasures_table(~,~)  % (src,event)
        update_brainmeasures();
    end
    function cb_brainmeasures_table_edit(~,event)  % (src,event)
        RowNames = get(ui_table_brainmeasures,'RowName');
        
        i = str2num(char(RowNames(event.Indices(1),:)));
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case {BRAINMEASURES_MEAS_SELECTED_COL BRAINMEASURES_COMP_SELECTED_COL BRAINMEASURES_RAND_SELECTED_COL}
                if newdata==1
                    selected_brainmeasures = sort(unique([selected_brainmeasures(:); i]));
                else
                    selected_brainmeasures = selected_brainmeasures(selected_brainmeasures~=i);
                end
        end
        
        update_brainmeasures();
    end
    function cb_brainmeasures_meas(~,~)  % (src,event)
        set(ui_checkbox_brainmeasures_meas,'Value',true)
        set(ui_checkbox_brainmeasures_meas,'FontWeight','bold') 
        set(ui_checkbox_brainmeasures_comp,'Value',false)
        set(ui_checkbox_brainmeasures_comp,'FontWeight','normal')
        set(ui_checkbox_brainmeasures_rand,'Value',false)
        set(ui_checkbox_brainmeasures_rand,'FontWeight','normal')
        set(ui_popup_brainmeasures_comp,'Enable','on')
        set(ui_popup_brainmeasures_comp_group1,'Enable','on')
        set(ui_popup_brainmeasures_comp_group2,'Enable','off')
        
        set(ui_checkbox_brainmeasures_ci,'Value',0)
        set(ui_checkbox_brainmeasures_ci,'Enable','off')
        
        update_brainmeasures()
    end
    function cb_brainmeasures_comp(~,~)  % (src,event)
        set(ui_checkbox_brainmeasures_meas,'Value',false)
        set(ui_checkbox_brainmeasures_meas,'FontWeight','normal')
        set(ui_checkbox_brainmeasures_comp,'Value',true)
        set(ui_checkbox_brainmeasures_comp,'FontWeight','bold')
        set(ui_checkbox_brainmeasures_rand,'Value',false)
        set(ui_checkbox_brainmeasures_rand,'FontWeight','normal')
        set(ui_popup_brainmeasures_comp,'Enable','on')
        set(ui_popup_brainmeasures_comp_group1,'Enable','on')
        set(ui_popup_brainmeasures_comp_group2,'Enable','on')
        
        set(ui_checkbox_brainmeasures_ci,'Value',0)
        set(ui_checkbox_brainmeasures_ci,'Enable','on')
        
        update_brainmeasures()
    end
    function cb_brainmeasures_rand(~,~)  % (src,event)
        set(ui_checkbox_brainmeasures_meas,'Value',false)
        set(ui_checkbox_brainmeasures_meas,'FontWeight','normal')
        set(ui_checkbox_brainmeasures_comp,'Value',false)
        set(ui_checkbox_brainmeasures_comp,'FontWeight','normal')
        set(ui_checkbox_brainmeasures_rand,'Value',true)
        set(ui_checkbox_brainmeasures_rand,'FontWeight','bold')
        set(ui_popup_brainmeasures_comp,'Enable','on')
        set(ui_popup_brainmeasures_comp_group1,'Enable','on')
        set(ui_popup_brainmeasures_comp_group2,'Enable','off')
        
        set(ui_checkbox_brainmeasures_ci,'Value',0)
        set(ui_checkbox_brainmeasures_ci,'Enable','on')
        
        update_brainmeasures()
    end
    function cb_brainmeasures_selectall(~,~)  % (src,event)
        RowNames = get(ui_table_brainmeasures,'RowName');
        
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            selected_brainmeasures = sort(unique([selected_brainmeasures(:); i]));
        end
        
        update_brainmeasures()
    end
    function cb_brainmeasures_clearselection(~,~)  % (src,event)
        RowNames = get(ui_table_brainmeasures,'RowName');
        
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            if any(selected_brainmeasures==i)
                selected_brainmeasures = selected_brainmeasures(selected_brainmeasures~=i);
            end
        end
        
        update_brainmeasures()
    end
    function cb_brainmeasures_remove(~,~)  % (src,event)
        RowNames = get(ui_table_brainmeasures,'RowName');
        
        selected = [];
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            if any(selected_brainmeasures==i)
                selected = [selected; i];
            end
        end
        selected = sort(selected);
        
        for i = length(selected):-1:1
            ga.remove(selected(i))
            selected_brainmeasures = selected_brainmeasures(selected_brainmeasures~=selected(i));
            selected_brainmeasures(selected_brainmeasures>selected(i)) = selected_brainmeasures(selected_brainmeasures>selected(i))-1;
        end
        
        update_brainmeasures()
    end

ui_axes_brainmeasures = axes();
ui_checkbox_brainmeasures_axes = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_checkbox_brainmeasures_holdon = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_checkbox_brainmeasures_cla = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_list_brainmeasures_plotted = uicontrol(ui_panel_brainmeasures,'Style', 'listbox');
ui_checkbox_brainmeasures_xlim = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_edit_brainmeasures_x1 = uicontrol(ui_panel_brainmeasures,'Style','edit');
ui_edit_brainmeasures_x2 = uicontrol(ui_panel_brainmeasures,'Style','edit');
ui_checkbox_brainmeasures_ylim = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
ui_edit_brainmeasures_y1 = uicontrol(ui_panel_brainmeasures,'Style','edit');
ui_edit_brainmeasures_y2 = uicontrol(ui_panel_brainmeasures,'Style','edit');
ui_checkbox_brainmeasures_ci = uicontrol(ui_panel_brainmeasures,'Style', 'checkbox');
init_brainmeasures_axes()
    function init_brainmeasures_axes()
        GUI.setUnits(ui_panel_brainmeasures)
        GUI.setBackgroundColor(ui_panel_brainmeasures)
        
        set(ui_table_brainmeasures,'BackgroundColor',GUI.TABBKGCOLOR)
        
        set(ui_axes_brainmeasures,'Parent',ui_panel_brainmeasures)
        set(ui_axes_brainmeasures,'Position',[.40 .26 .56 .72])
        
        set(ui_checkbox_brainmeasures_axes,'Position',[.65 .14 .10 .03])
        set(ui_checkbox_brainmeasures_axes,'String','hide figure')
        set(ui_checkbox_brainmeasures_axes,'Value',false)
        set(ui_checkbox_brainmeasures_axes,'TooltipString','Hide/show figure')
        set(ui_checkbox_brainmeasures_axes,'Callback',{@cb_brainmeasures_axes})
        
        set(ui_checkbox_brainmeasures_holdon,'Position',[.65 .09 .10 .03])
        set(ui_checkbox_brainmeasures_holdon,'String','hold graph')
        set(ui_checkbox_brainmeasures_holdon,'Value',false)
        set(ui_checkbox_brainmeasures_holdon,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_brainmeasures_holdon,'Callback',{@cb_brainmeasures_axes})
        
        set(ui_checkbox_brainmeasures_cla,'Position',[.65 .04 .10 .03])
        set(ui_checkbox_brainmeasures_cla,'String','clear axes')
        set(ui_checkbox_brainmeasures_cla,'Value',false)
        set(ui_checkbox_brainmeasures_cla,'TooltipString','Clear the axes')
        set(ui_checkbox_brainmeasures_cla,'Callback',{@cb_brainmeasures_cla})
        
        set(ui_list_brainmeasures_plotted,'String','')
        set(ui_list_brainmeasures_plotted,'Value',1)
        set(ui_list_brainmeasures_plotted,'Max',2,'Min',0)
        set(ui_list_brainmeasures_plotted,'Position',[.76 .02 .20 .15])
        set(ui_list_brainmeasures_plotted,'TooltipString','Plotted measures');
        set(ui_list_brainmeasures_plotted,'enable','on')
        set(ui_list_brainmeasures_plotted,'Callback',{@cb_brainmeasures_plotted});
 
        set(ui_checkbox_brainmeasures_xlim,'Position',[.54 .09 .10 .03])
        set(ui_checkbox_brainmeasures_xlim,'String','X Lim')
        set(ui_checkbox_brainmeasures_xlim,'Value',false)
        set(ui_checkbox_brainmeasures_xlim,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_brainmeasures_xlim,'Callback',{@cb_brainmeasures_xlim})
        
        set(ui_edit_brainmeasures_x1,'Position',[.40 .09 .05 .03])
        set(ui_edit_brainmeasures_x1,'String','-1')
        set(ui_edit_brainmeasures_x1,'enable','off')
        set(ui_edit_brainmeasures_x1,'TooltipString','Set X lower limit')
        set(ui_edit_brainmeasures_x1,'Callback',{@cb_brainmeasures_x1})
        
        set(ui_edit_brainmeasures_x2,'Position',[.47 .09 .05 .03])
        set(ui_edit_brainmeasures_x2,'String','1')
        set(ui_edit_brainmeasures_x2,'enable','off')
        set(ui_edit_brainmeasures_x2,'TooltipString','Set X higer limit')
        set(ui_edit_brainmeasures_x2,'Callback',{@cb_brainmeasures_x2})
        
        set(ui_checkbox_brainmeasures_ylim,'Position',[.54 .04 .10 .03])
        set(ui_checkbox_brainmeasures_ylim,'String','Y Lim')
        set(ui_checkbox_brainmeasures_ylim,'Value',false)
        set(ui_checkbox_brainmeasures_ylim,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_brainmeasures_ylim,'Callback',{@cb_brainmeasures_ylim})
        
        set(ui_edit_brainmeasures_y1,'Position',[.40 .04 .05 .03])
        set(ui_edit_brainmeasures_y1,'String','-1')
        set(ui_edit_brainmeasures_y1,'enable','off')
        set(ui_edit_brainmeasures_y1,'TooltipString','Set Y lower limit')
        set(ui_edit_brainmeasures_y1,'Callback',{@cb_brainmeasures_y1})
        
        set(ui_edit_brainmeasures_y2,'Position',[.47 .04 .05 .03])
        set(ui_edit_brainmeasures_y2,'String','1')
        set(ui_edit_brainmeasures_y2,'enable','off')
        set(ui_edit_brainmeasures_y2,'TooltipString','Set Y higer limit')
        set(ui_edit_brainmeasures_y2,'Callback',{@cb_brainmeasures_y2})
        
        set(ui_checkbox_brainmeasures_ci,'Position',[.40 .14 .25 .03])
        set(ui_checkbox_brainmeasures_ci,'String','show confidence intervals')
        set(ui_checkbox_brainmeasures_ci,'Value',false)
        set(ui_checkbox_brainmeasures_ci,'enable','off')
        set(ui_checkbox_brainmeasures_ci,'TooltipString','Show confidence intervals')
        set(ui_checkbox_brainmeasures_ci,'Callback',{@cb_brainmeasures_ci})
    end
    function update_brainmeasures_axes()
        axes(ui_axes_brainmeasures)
        
        if get(ui_checkbox_brainmeasures_axes,'Value')
            
            set(ui_table_brainmeasures,'Position',[.02 .19 .96 .79])
            cla(ui_axes_brainmeasures)
            set(ui_axes_brainmeasures,'Visible','off')
            set(ui_list_brainmeasures_plotted,'String','')
        else
            
            set(ui_checkbox_brainmeasures_axes,'value',false)
            set(ui_table_brainmeasures,'Position',[.02 .19 .32 .79])
            set(ui_axes_brainmeasures,'Visible','on')
            
            mlist = GraphBU.measurelist(false);  % list of non-nodal measures
            
            if get(ui_checkbox_brainmeasures_holdon,'Value')
                
                if get(ui_checkbox_brainmeasures_meas,'Value')
                    
                    [ms,mi] = ga.getMeasures(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
                    
                    if ~isempty(mi)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['measure - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_brainmeasures_plotted,'String',strvcat(str2,['measure - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))]));
                            
                            d = zeros(1,length(ms));
                            meas = zeros(1,length(ms));
                            
                            for i = 1:1:length(ms)
                                meas(i) = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                                d(i) = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                            end
                            
                            pe = PlotDataElement( ...
                                PlotDataElement.CODE,name, ...
                                PlotDataElement.X,d, ...
                                PlotDataElement.Y,meas);
                            
                            plot_data_global.add(pe);
                            plot_data_global.set_axes(ui_axes_brainmeasures);
                            plot_data_global.hold_on()
                            
                            % context menus
                            ui_contextmenu_meas = uicontextmenu();
                            ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_settings,'Label','Data settings')
                            set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                            
                            plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas);
                            xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                            ylabel(BRAINMEASURES_LABEL_MEASURE)
                        end
                    end
                    
                elseif get(ui_checkbox_brainmeasures_comp,'Value')
                    
                    [cs,ci] = ga.getComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'),get(ui_popup_brainmeasures_comp_group2,'Value'));
                    
                    if ~isempty(ci)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['comparison - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'groups = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value')) 'and' int2str(get(ui_popup_brainmeasures_comp_group2,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_brainmeasures_plotted,'String',strvcat(str2,name));
                            
                            d = zeros(1,length(cs));
                            diff = zeros(1,length(cs));
                            m = zeros(1,length(cs));
                            ci5l = zeros(1,length(cs));
                            ci5u = zeros(1,length(cs));
                            
                            for i = 1:1:length(cs)
                                diff(i) = cs{i}.diff();
                                d(i) = cs{i}.getProp(MRIMeasureBUT.THRESHOLD);
                                m(i) = cs{i}.CI(50);
                                ci5 = cs{i}.CI(5);
                                ci5l(i) = ci5(1);
                                ci5u(i) = ci5(2);
                            end
                            pe = PlotDataArea( ...
                                PlotDataArea.CODE,name, ...
                                PlotDataArea.X,d, ...
                                PlotDataArea.Y,diff, ...
                                PlotDataArea.Y_LOW,ci5l, ...
                                PlotDataArea.Y_MID,m, ...
                                PlotDataArea.Y_HIGH,ci5u);
                            
                            plot_data_global.add(pe);
                            plot_data_global.set_axes(ui_axes_brainmeasures);
                            plot_data_global.hold_on()
                            
                            % context menus
                            ui_contextmenu_meas = uicontextmenu();
                            ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_settings,'Label','Data settings')
                            set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                            ui_contextmenu_measure_up = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_up,'Label','Upper confidence border settings')
                            set(ui_contextmenu_measure_up,'Callback',{@cb_up_settings})
                            ui_contextmenu_measure_low = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_low,'Label','Lower confidence border settings')
                            set(ui_contextmenu_measure_low,'Callback',{@cb_low_settings})
                            ui_contextmenu_measure_mid = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_mid,'Label','Middle confidence line settings')
                            set(ui_contextmenu_measure_mid,'Callback',{@cb_mid_settings})
                            ui_contextmenu_measure_area = uimenu(ui_contextmenu_meas);
                            set(ui_contextmenu_measure_area,'Label','Area settings')
                            set(ui_contextmenu_measure_area,'Callback',{@cb_area_settings})
                            
                            plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas)
                            update_ci()
                            xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                            ylabel(BRAINMEASURES_LABEL_MEASDIFF)
                        end
                    end
                    
                elseif get(ui_checkbox_brainmeasures_rand,'Value')
                    
                    [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
            
                    if ~isempty(ni)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['random comp. - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_brainmeasures_plotted,'String',strvcat(str2,['rand comp. - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))]));
                            
                            d = zeros(1,length(ns));
                            meas = zeros(1,length(ns));
                            m = zeros(1,length(ns));
                            ci5l = zeros(1,length(ns));
                            ci5u = zeros(1,length(ns));
                            
                            for i = 1:1:length(ns)
                                meas(i) = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                                d(i) = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                                m(i) = ns{i}.CI(50);
                                ci5 = ns{i}.CI(5);
                                ci5l(i) = ci5(1);
                                ci5u(i) = ci5(2);
                            end
                            
                            pe = PlotDataArea( ...
                                PlotDataArea.CODE,name, ...
                                PlotDataArea.X,d, ...
                                PlotDataArea.Y,meas, ...
                                PlotDataArea.Y_LOW,ci5l, ...
                                PlotDataArea.Y_MID,m, ...
                                PlotDataArea.Y_HIGH,ci5u);
                            
                            plot_data_global.add(pe);
                            plot_data_global.set_axes(ui_axes_brainmeasures);
                            plot_data_global.hold_on()
                            
        
                            % context menus
                        ui_contextmenu_meas = uicontextmenu();
                        ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_settings,'Label','Data settings')
                        set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                        ui_contextmenu_measure_up = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_up,'Label','Upper confidence border settings')
                        set(ui_contextmenu_measure_up,'Callback',{@cb_up_settings})
                        ui_contextmenu_measure_low = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_low,'Label','Lower confidence border settings')
                        set(ui_contextmenu_measure_low,'Callback',{@cb_low_settings})
                        ui_contextmenu_measure_mid = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_mid,'Label','Middle confidence line settings')
                        set(ui_contextmenu_measure_mid,'Callback',{@cb_mid_settings})
                        ui_contextmenu_measure_area = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_area,'Label','Area settings')
                        set(ui_contextmenu_measure_area,'Callback',{@cb_area_settings})
                            
                            plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas);
                            xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                            ylabel(BRAINMEASURES_LABEL_RANDOM)
                            update_ci();
                        end
                    end
                end
                
            else
                cla(ui_axes_brainmeasures)
                set(ui_list_brainmeasures_plotted,'String','')
                for i = plot_data_global.length():-1:1
                    plot_data_global.remove(i);
                end
                
                if get(ui_checkbox_brainmeasures_meas,'Value')
                    
                    [ms,mi] = ga.getMeasures(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
                    
                    if ~isempty(mi)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['measure - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))];
                        set(ui_list_brainmeasures_plotted,'String',strvcat(str2,['measure - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))]));
                        
                        d = zeros(1,length(ms));
                        meas = zeros(1,length(ms));
                        
                        for i = 1:1:length(ms)
                            meas(i) = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                            d(i) = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                        end
                        
                        pe = PlotDataElement( ...
                            PlotDataElement.CODE,name, ...
                            PlotDataElement.X,d, ...
                            PlotDataElement.Y,meas ...
                            );
                        
                        plot_data_global.add(pe);
                        plot_data_global.set_axes(ui_axes_brainmeasures);
                        
                        % context menus
                        ui_contextmenu_meas = uicontextmenu();
                        ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_settings,'Label','Data settings')
                        set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                        
                        plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas);
                        xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                        ylabel(BRAINMEASURES_LABEL_MEASURE)
                    end
                    
                elseif get(ui_checkbox_brainmeasures_comp,'Value')
                    
                    [cs,ci] = ga.getComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'),get(ui_popup_brainmeasures_comp_group2,'Value'));
                    
                    if ~isempty(ci)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['comparison - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'groups = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value')) 'and' int2str(get(ui_popup_brainmeasures_comp_group2,'Value'))];
                        set(ui_list_brainmeasures_plotted,'String',strvcat(str2,name));
                        
                        d = zeros(1,length(cs));
                        diff = zeros(1,length(cs));
                        m = zeros(1,length(cs));
                        ci5l = zeros(1,length(cs));
                        ci5u = zeros(1,length(cs));
                        
                        for i = 1:1:length(cs)
                            diff(i) = cs{i}.diff();
                            d(i) = cs{i}.getProp(MRIMeasureBUT.THRESHOLD);
                            m(i) = cs{i}.CI(50);
                            ci5 = cs{i}.CI(5);
                            ci5l(i) = ci5(1);
                            ci5u(i) = ci5(2);
                        end
                        
                        pe = PlotDataArea( ...
                            PlotDataArea.CODE,name, ...
                            PlotDataArea.X,d, ...
                            PlotDataArea.Y,diff, ...
                            PlotDataArea.Y_LOW,ci5l, ...
                            PlotDataArea.Y_MID,m, ...
                            PlotDataArea.Y_HIGH,ci5u);
                        plot_data_global.add(pe);
                        plot_data_global.set_axes(ui_axes_brainmeasures);
                        plot_data_global.hold_on()
                        
                        % context menus
                        ui_contextmenu_meas = uicontextmenu();
                        ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_settings,'Label','Data settings')
                        set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                        ui_contextmenu_measure_up = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_up,'Label','Upper confidence border settings')
                        set(ui_contextmenu_measure_up,'Callback',{@cb_up_settings})
                        ui_contextmenu_measure_low = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_low,'Label','Lower confidence border settings')
                        set(ui_contextmenu_measure_low,'Callback',{@cb_low_settings})
                        ui_contextmenu_measure_mid = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_mid,'Label','Middle confidence line settings')
                        set(ui_contextmenu_measure_mid,'Callback',{@cb_mid_settings})
                        ui_contextmenu_measure_area = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_area,'Label','Area settings')
                        set(ui_contextmenu_measure_area,'Callback',{@cb_area_settings})
                        
                        plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas)
                        update_ci()
                        xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                        ylabel(BRAINMEASURES_LABEL_MEASDIFF)
                    end
                    
                elseif get(ui_checkbox_brainmeasures_rand,'Value')
                    
                    [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_brainmeasures_comp,'Value')),get(ui_popup_brainmeasures_comp_group1,'Value'));
            
                    if ~isempty(ni)
                        % update list
                        str1 = get(ui_popup_brainmeasures_comp,'String');
                        str2 = get(ui_list_brainmeasures_plotted,'String');
                        name = ['random comp. - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))];
                        set(ui_list_brainmeasures_plotted,'String',strvcat(str2,['random comp. - ' str1{get(ui_popup_brainmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_brainmeasures_comp_group1,'Value'))]));
                        
                        d = zeros(1,length(ns));
                        meas = zeros(1,length(ns));
                        m = zeros(1,length(ns));
                        ci5l = zeros(1,length(ns));
                        ci5u = zeros(1,length(ns));
                        
                        for i = 1:1:length(ns)
                            meas(i) = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                            d(i) = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                            m(i) = ns{i}.CI(50);
                            ci5 = ns{i}.CI(5);
                            ci5l(i) = ci5(1);
                            ci5u(i) = ci5(2);
                        end
                        
                        pe = PlotDataArea( ...
                            PlotDataArea.CODE,name, ...
                            PlotDataArea.X,d, ...
                            PlotDataArea.Y,meas, ...
                            PlotDataArea.Y_LOW,ci5l, ...
                            PlotDataArea.Y_MID,m, ...
                            PlotDataArea.Y_HIGH,ci5u);
                        
                        plot_data_global.add(pe);
                        plot_data_global.set_axes(ui_axes_brainmeasures);
                        
                        % context menus
                        ui_contextmenu_meas = uicontextmenu();
                        ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_settings,'Label','Data settings')
                        set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                        ui_contextmenu_measure_up = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_up,'Label','Upper confidence border settings')
                        set(ui_contextmenu_measure_up,'Callback',{@cb_up_settings})
                        ui_contextmenu_measure_low = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_low,'Label','Lower confidence border settings')
                        set(ui_contextmenu_measure_low,'Callback',{@cb_low_settings})
                        ui_contextmenu_measure_mid = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_mid,'Label','Middle confidence line settings')
                        set(ui_contextmenu_measure_mid,'Callback',{@cb_mid_settings})
                        ui_contextmenu_measure_area = uimenu(ui_contextmenu_meas);
                        set(ui_contextmenu_measure_area,'Label','Area settings')
                        set(ui_contextmenu_measure_area,'Callback',{@cb_area_settings})
                        
                        plot_data_global.plot_data([],'UIContextMenu',ui_contextmenu_meas);
                        xlabel(BRAINMEASURES_LABEL_THRESHOLD)
                        ylabel(BRAINMEASURES_LABEL_RANDOM)
                        update_ci();
                    end
                end
                
            end
        end
    end
    function cb_brainmeasures_axes(~,~)  % (src,event)
        update_brainmeasures()
    end
    function cb_brainmeasures_cla(~,~)  % (src,event)
        cla(ui_axes_brainmeasures)
        set(ui_list_brainmeasures_plotted,'String','')
        
        set(ui_checkbox_brainmeasures_axes,'Value',false)
        set(ui_checkbox_brainmeasures_holdon,'Value',false)
        set(ui_checkbox_brainmeasures_cla,'Value',false)
        
        set(ui_checkbox_brainmeasures_meas,'Value',false)
        set(ui_checkbox_brainmeasures_meas,'FontWeight','normal')
        
        set(ui_checkbox_brainmeasures_comp,'Value',false)
        set(ui_checkbox_brainmeasures_comp,'FontWeight','normal')
        set(ui_popup_brainmeasures_comp,'enable','off')
        set(ui_popup_brainmeasures_comp_group1,'enable','off')
        set(ui_popup_brainmeasures_comp_group2,'enable','off')
        
        set(ui_checkbox_brainmeasures_rand,'Value',false)
        set(ui_checkbox_brainmeasures_rand,'FontWeight','normal')
    end
    function cb_brainmeasures_xlim(~,~)  % (src,event)
        if get(ui_checkbox_brainmeasures_xlim,'Value')
            set(ui_edit_brainmeasures_x1,'enable','on')
            set(ui_edit_brainmeasures_x2,'enable','on')
            x1 = str2num(get(ui_edit_brainmeasures_x1,'String'));
            x2 = str2num(get(ui_edit_brainmeasures_x2,'String'));
            set(ui_axes_brainmeasures,'XLim',[x1 x2])
        else
            set(ui_edit_brainmeasures_x1,'enable','off')
            set(ui_edit_brainmeasures_x2,'enable','off')
            set(ui_axes_brainmeasures,'XLimMode','auto')
        end
    end
    function cb_brainmeasures_x1(~,~)  % (src,event)
        x1 = real(str2num(get(ui_edit_brainmeasures_x1,'String')));
        if isempty(x1) || isnan(x1) || x1>=str2num(get(ui_edit_brainmeasures_x2,'String'))
            x1 = str2num(get(ui_edit_brainmeasures_x2,'String'))-1;
        end
        set(ui_edit_brainmeasures_x1,'String',num2str(x1))
        set(ui_axes_brainmeasures,'XLim',[x1 str2num(get(ui_edit_brainmeasures_x2,'String'))])
    end
    function cb_brainmeasures_x2(~,~)  % (src,event)
        x2 = real(str2num(get(ui_edit_brainmeasures_x2,'String')));
        if isempty(x2) || isnan(x2) || x2<=str2num(get(ui_edit_brainmeasures_x1,'String'))
            x2 = str2num(get(ui_edit_brainmeasures_x1,'String'))+1;
        end
        set(ui_axes_brainmeasures,'XLim',[str2num(get(ui_edit_brainmeasures_x1,'String')) x2])
        set(ui_edit_brainmeasures_x2,'String',num2str(x2))
    end
    function cb_brainmeasures_ylim(~,~)  % (src,event)
        if get(ui_checkbox_brainmeasures_ylim,'Value')
            set(ui_edit_brainmeasures_y1,'enable','on')
            set(ui_edit_brainmeasures_y2,'enable','on')
            y1 = str2num(get(ui_edit_brainmeasures_y1,'String'));
            y2 = str2num(get(ui_edit_brainmeasures_y2,'String'));
            set(ui_axes_brainmeasures,'YLim',[y1 y2])
        else
            set(ui_edit_brainmeasures_y1,'enable','off')
            set(ui_edit_brainmeasures_y2,'enable','off')
            set(ui_axes_brainmeasures,'YLimMode','auto')
        end
    end
    function cb_brainmeasures_y1(~,~)  % (src,event)
        y1 = real(str2num(get(ui_edit_brainmeasures_y1,'String')));
        if isempty(y1) || isnan(y1) || y1>=str2num(get(ui_edit_brainmeasures_y2,'String'))
            y1 = str2num(get(ui_edit_brainmeasures_y2,'String'))-1;
        end
        set(ui_edit_brainmeasures_y1,'String',num2str(y1))
        set(ui_axes_brainmeasures,'YLim',[y1 str2num(get(ui_edit_brainmeasures_y2,'String'))])
    end
    function cb_brainmeasures_y2(~,~)  % (src,event)
        y2 = real(str2num(get(ui_edit_brainmeasures_y2,'String')));
        if isempty(y2) || isnan(y2) || y2<=str2num(get(ui_edit_brainmeasures_y1,'String'))
            y2 = str2num(get(ui_edit_brainmeasures_y1,'String'))+1;
        end
        set(ui_axes_brainmeasures,'YLim',[str2num(get(ui_edit_brainmeasures_y1,'String')) y2])
        set(ui_edit_brainmeasures_y2,'String',num2str(y2))
    end
    function cb_brainmeasures_ci(~,~)  % (src,event)
        update_ci()
    end
    function update_ci()
        for i = 1:1:plot_data_global.length()
            
            if isa(plot_data_global.get(i),'PlotDataArea')
                
                if get(ui_checkbox_brainmeasures_ci,'Value')
                    % context menus
                    ui_contextmenu_meas = uicontextmenu();
                    ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas);
                    set(ui_contextmenu_measure_settings,'Label','Data settings')
                    set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings})
                    ui_contextmenu_measure_up = uimenu(ui_contextmenu_meas);
                    set(ui_contextmenu_measure_up,'Label','Upper confidence border settings')
                    set(ui_contextmenu_measure_up,'Callback',{@cb_up_settings})
                    ui_contextmenu_measure_low = uimenu(ui_contextmenu_meas);
                    set(ui_contextmenu_measure_low,'Label','Lower confidence border settings')
                    set(ui_contextmenu_measure_low,'Callback',{@cb_low_settings})
                    ui_contextmenu_measure_mid = uimenu(ui_contextmenu_meas);
                    set(ui_contextmenu_measure_mid,'Label','Middle confidence line settings')
                    set(ui_contextmenu_measure_mid,'Callback',{@cb_mid_settings})
                    ui_contextmenu_measure_area = uimenu(ui_contextmenu_meas);
                    set(ui_contextmenu_measure_area,'Label','Area settings')
                    set(ui_contextmenu_measure_area,'Callback',{@cb_area_settings})
                    
                    pde_temp = PlotDataArea();
                    plot_data_global.plot_low(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.LOW_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.LOW_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas)
                    plot_data_global.plot_low_on(i);
                    
                    plot_data_global.plot_high(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.HIGH_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.HIGH_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas)
                    plot_data_global.plot_high_on(i);
                    
                    plot_data_global.plot_mid(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.MID_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.MID_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas)
                    plot_data_global.plot_mid_on(i);
                    
                    plot_data_global.plot_area(i,...
                        'areacolor',(pde_temp.getProp(PlotDataArea.AREA_FACE_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas)
                    plot_data_global.plot_area_on(i);
                    
                    pde = plot_data_global.get(i);
                    uistack(pde.getYHighHandle(),'bottom')
                    uistack(pde.getYLowHandle(),'bottom')
                    uistack(pde.getYMidHandle(),'bottom')
                    uistack(pde.getAreaHandle(),'bottom')
                    
                else
                    
                    plot_data_global.plot_data_off(i);
                    
                    plot_data_global.plot_high_off(i);
                    plot_data_global.plot_low_off(i);
                    plot_data_global.plot_mid_off(i);
                    plot_data_global.plot_area_off(i);
                    
                    plot_data_global.plot_data_on(i);
                    
                end
            end
        end
    end
    function cb_brainmeasures_plotted(~,~)  % (src,event)
    end
    function cb_data_settings(~,~)  % (src,event)
        
        i = plot_data_global.get_pde_i(gco);
        
        if isfinite(i)
            plot_data_global.plot_data_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_global.plot_data_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_up_settings(~,~)  % (src,event)
        i = plot_data_global.get_pde_high_i(gco);
        
        if isfinite(i)
            plot_data_global.plot_high_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_global.plot_high_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_low_settings(~,~)  % (src,event)
        i = plot_data_global.get_pde_low_i(gco);
        
        if isfinite(i)
            plot_data_global.plot_low_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_global.plot_low_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_mid_settings(~,~)  % (src,event)
        i = plot_data_global.get_pde_mid_i(gco);
        
        if isfinite(i)
            plot_data_global.plot_mid_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_global.plot_mid_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_area_settings(~,~)  % (src,event)
        i = plot_data_global.get_pde_area_i(gco);
        
        if isfinite(i)
            plot_data_global.plot_area_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_global.plot_area_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end


%% Panel 3 - Region Measures
REGIONMEASURES_MEAS_SELECTED_COL = 1;
REGIONMEASURES_MEAS_VALUE_COL = 2;
REGIONMEASURES_MEAS_THRESHOLD_COL = 3;
REGIONMEASURES_MEAS_DENSITY_COL = 4;
REGIONMEASURES_MEAS_NOTES_COL = 5;
REGIONMEASURES_MEAS_MEASURE_COL = 6;
REGIONMEASURES_MEAS_GROUP_COL = 7;
REGIONMEASURES_MEAS_BR_COL = 8;
REGIONMEASURES_MEAS_PARAM_COL = 9;

REGIONMEASURES_COMP_SELECTED_COL = 1;
REGIONMEASURES_COMP_DIFF_COL = 2;
REGIONMEASURES_COMP_PVALUE1_COL = 3;
REGIONMEASURES_COMP_FDR1_COL = 4;
REGIONMEASURES_COMP_PVALUE2_COL = 5;
REGIONMEASURES_COMP_FDR2_COL = 6;
REGIONMEASURES_COMP_VALUE1_COL = 7;
REGIONMEASURES_COMP_VALUE2_COL = 8;
REGIONMEASURES_COMP_CIL_COL = 9;
REGIONMEASURES_COMP_CIU_COL = 10;
REGIONMEASURES_COMP_THRESHOLD_COL = 11;
REGIONMEASURES_COMP_DENSITY1_COL = 12;
REGIONMEASURES_COMP_DENSITY2_COL = 13;
REGIONMEASURES_COMP_NOTES_COL = 14;
REGIONMEASURES_COMP_MEASURE_COL = 15;
REGIONMEASURES_COMP_PARAM_COL = 16;
REGIONMEASURES_COMP_GROUP1_COL = 17;
REGIONMEASURES_COMP_GROUP2_COL = 18;
REGIONMEASURES_COMP_BR_COL = 19;

REGIONMEASURES_RAND_SELECTED_COL = 1;
REGIONMEASURES_RAND_COMPVALUE_COL = 2;
REGIONMEASURES_RAND_PVALUE1_COL = 3;
REGIONMEASURES_RAND_FDR1_COL = 4;
REGIONMEASURES_RAND_PVALUE2_COL = 5;
REGIONMEASURES_RAND_FDR2_COL = 6;
REGIONMEASURES_RAND_REALVALUE_COL = 7;
REGIONMEASURES_RAND_CIL_COL = 8;
REGIONMEASURES_RAND_CIU_COL = 9;
REGIONMEASURES_RAND_THRESHOLD_COL = 10;
REGIONMEASURES_RAND_DENSITY_COL = 11;
REGIONMEASURES_RAND_NOTES_COL = 12;
REGIONMEASURES_RAND_MEASURE_COL = 13;
REGIONMEASURES_RAND_PARAM_COL = 14;
REGIONMEASURES_RAND_GROUP_COL = 15;
REGIONMEASURES_RAND_BR_COL = 16;

REGIONMEASURES_LABEL_THRESHOLD = 'threshold [%]';
REGIONMEASURES_LABEL_DENSITY = 'density [n.u.]';
REGIONMEASURES_LABEL_MEASURE = 'measure';
REGIONMEASURES_LABEL_MEASDIFF = 'difference';
REGIONMEASURES_LABEL_RANDOM = 'comp. with random matrix';

ui_panel_regionmeasures = uipanel();

ui_table_regionmeasures = uitable(ui_panel_regionmeasures);
ui_button_regionmeasures_selectall = uicontrol(ui_panel_regionmeasures,'Style', 'pushbutton');
ui_button_regionmeasures_clearselection = uicontrol(ui_panel_regionmeasures,'Style', 'pushbutton');
ui_button_regionmeasures_remove = uicontrol(ui_panel_regionmeasures,'Style', 'pushbutton');
ui_checkbox_regionmeasures_meas = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_checkbox_regionmeasures_comp = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_checkbox_regionmeasures_rand = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_popup_regionmeasures_comp = uicontrol(ui_panel_regionmeasures,'Style','popup','String',{''});
ui_popup_regionmeasures_comp_br = uicontrol(ui_panel_regionmeasures,'Style','popup','String',{''});
ui_popup_regionmeasures_comp_group1 = uicontrol(ui_panel_regionmeasures,'Style','popup','String',{''});
ui_popup_regionmeasures_comp_group2 = uicontrol(ui_panel_regionmeasures,'Style','popup','String',{''});
init_regionmeasures()
    function init_regionmeasures()
        GUI.setUnits(ui_panel_regionmeasures)
        GUI.setBackgroundColor(ui_panel_regionmeasures)
        
        set(ui_panel_regionmeasures,'Position',MAINPANEL_POSITION)
        set(ui_panel_regionmeasures,'Title',CONSOLE_REGIONMEASURES_CMD)
        
        set(ui_table_regionmeasures,'BackgroundColor',GUI.TABBKGCOLOR)
        set(ui_table_regionmeasures,'Position',[.02 .19 .32 .79])
        set(ui_table_regionmeasures,'CellEditCallback',{@cb_regionmeasures_table_edit})
        
        set(ui_button_regionmeasures_selectall,'Position',[.02 .14 .10 .03])
        set(ui_button_regionmeasures_selectall,'String',SELECTALL_MEAS_CMD)
        set(ui_button_regionmeasures_selectall,'TooltipString',SELECTALL_MEAS_TP)
        set(ui_button_regionmeasures_selectall,'Callback',{@cb_regionmeasures_selectall})
        
        set(ui_button_regionmeasures_clearselection,'Position',[.13 .14 .10 .03])
        set(ui_button_regionmeasures_clearselection,'String',CLEARSELECTION_MEAS_CMD)
        set(ui_button_regionmeasures_clearselection,'TooltipString',CLEARSELECTION_MEAS_TP)
        set(ui_button_regionmeasures_clearselection,'Callback',{@cb_regionmeasures_clearselection})
        
        set(ui_button_regionmeasures_remove,'Position',[.24 .14 .10 .03])
        set(ui_button_regionmeasures_remove,'String',REMOVE_MEAS_CMD)
        set(ui_button_regionmeasures_remove,'TooltipString',REMOVE_MEAS_TP)
        set(ui_button_regionmeasures_remove,'Callback',{@cb_regionmeasures_remove})
        
        set(ui_checkbox_regionmeasures_meas,'Position',[.02 .09 .10 .03])
        set(ui_checkbox_regionmeasures_meas,'String','measure')
        set(ui_checkbox_regionmeasures_meas,'Value',true)
        set(ui_checkbox_regionmeasures_meas,'TooltipString','Select measure')
        set(ui_checkbox_regionmeasures_meas,'FontWeight','bold')
        set(ui_checkbox_regionmeasures_meas,'Callback',{@cb_regionmeasures_meas})
        
        set(ui_checkbox_regionmeasures_comp,'Position',[.12 .09 .10 .03])
        set(ui_checkbox_regionmeasures_comp,'String','comparison')
        set(ui_checkbox_regionmeasures_comp,'Value',false)
        set(ui_checkbox_regionmeasures_comp,'TooltipString','Select comparison')
        set(ui_checkbox_regionmeasures_comp,'Callback',{@cb_regionmeasures_comp})
        
        set(ui_checkbox_regionmeasures_rand,'Position',[.22 .09 .15 .03])
        set(ui_checkbox_regionmeasures_rand,'String','random comparison')
        set(ui_checkbox_regionmeasures_rand,'Value',false)
        set(ui_checkbox_regionmeasures_rand,'TooltipString','Select random comparison')
        set(ui_checkbox_regionmeasures_rand,'Callback',{@cb_regionmeasures_rand})
        
        set(ui_popup_regionmeasures_comp,'Position',[.02 .04 .08 .03])
        set(ui_popup_regionmeasures_comp,'String',Graph.NAME(GraphBU.measurelist(true)))
        set(ui_popup_regionmeasures_comp,'Enable','on')
        set(ui_popup_regionmeasures_comp,'TooltipString','Select measure');
        set(ui_popup_regionmeasures_comp,'Callback',{@cb_regionmeasures_table})
        
        set(ui_popup_regionmeasures_comp_br,'Position',[.11 .04 .07 .03])
        set(ui_popup_regionmeasures_comp_br,'Enable','on')
        set(ui_popup_regionmeasures_comp_br,'TooltipString','Select measure');
        set(ui_popup_regionmeasures_comp_br,'Callback',{@cb_regionmeasures_table})
        
        ui_popups_grouplists = [ui_popups_grouplists ui_popup_regionmeasures_comp_group1];
        set(ui_popup_regionmeasures_comp_group1,'Position',[.19 .04 .07 .03])
        set(ui_popup_regionmeasures_comp_group1,'Enable','on')
        set(ui_popup_regionmeasures_comp_group1,'TooltipString','Select group 1');
        set(ui_popup_regionmeasures_comp_group1,'Callback',{@cb_regionmeasures_table})
        
        ui_popups_grouplists = [ui_popups_grouplists ui_popup_regionmeasures_comp_group2];
        set(ui_popup_regionmeasures_comp_group2,'Position',[.27 .04 .07 .03])
        set(ui_popup_regionmeasures_comp_group2,'Enable','off')
        set(ui_popup_regionmeasures_comp_group2,'TooltipString','Select group 2');
        set(ui_popup_regionmeasures_comp_group2,'Callback',{@cb_regionmeasures_table})
    end
    function update_regionmeasures()
        update_regionmeasures_table()
        update_regionmeasures_axes()
    end
    function update_regionmeasures_table()
        
        BrainRegions = ga.getBrainAtlas.getProps(BrainRegion.LABEL);
        if ga.getBrainAtlas().length>0
            set(ui_popup_regionmeasures_comp_br,'String',BrainRegions)
        end
        
        mlist = GraphBU.measurelist(true);  % list of nodal measures
        
        if get(ui_checkbox_regionmeasures_meas,'Value')
            
            [ms,mi] = ga.getMeasures(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
            bri = get(ui_popup_regionmeasures_comp_br,'Value');
            
            set(ui_table_regionmeasures,'ColumnName',{'',' value ',' threshold ',' density ',' notes ',' measure ',' group ',' brain region ',' param '})
            set(ui_table_regionmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','char','char','numeric','char','numeric'})
            set(ui_table_regionmeasures,'ColumnEditable',[true false false false false false false false false])
            data = cell(length(ms),9);
            for i = 1:1:length(ms)
                if any(selected_regionmeasures==mi(i))
                    data{i,BRAINMEASURES_MEAS_SELECTED_COL} = true;
                else
                    data{i,BRAINMEASURES_MEAS_SELECTED_COL} = false;
                end
                
                data1 = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                data{i,REGIONMEASURES_MEAS_VALUE_COL} = data1(bri);
                
                data{i,REGIONMEASURES_MEAS_THRESHOLD_COL} = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                data{i,REGIONMEASURES_MEAS_DENSITY_COL} = ms{i}.getProp(MRIMeasureBUT.DENSITY1);
                data{i,REGIONMEASURES_MEAS_NOTES_COL} = ms{i}.getProp(MRIMeasureBUT.NOTES);
                data{i,REGIONMEASURES_MEAS_MEASURE_COL} = Graph.NAME{ms{i}.getProp(MRIMeasureBUT.CODE)};
                data{i,REGIONMEASURES_MEAS_GROUP_COL} = ms{i}.getProp(MRIMeasureBUT.GROUP1);
                data{i,REGIONMEASURES_MEAS_BR_COL} = BrainRegions{bri};
                data{i,REGIONMEASURES_MEAS_PARAM_COL} = ms{i}.getProp(MRIMeasureBUT.PARAM);
            end
            set(ui_table_regionmeasures,'Data',data)
            
            set(ui_table_regionmeasures,'RowName',mi)
            
        elseif get(ui_checkbox_regionmeasures_comp,'Value')
            
            [cs,ci] = ga.getComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'),get(ui_popup_regionmeasures_comp_group2,'Value'));
            bri = get(ui_popup_regionmeasures_comp_br,'Value');
            
            set(ui_table_regionmeasures,'ColumnName',{'',' difference ',' p (1-tailed) ',' fdr (1-tailed) ',' p (2-tailed) ',' fdr (2-tailed) ',' value 1 ',' value 2 ',' CI lower ',' CI upper ',' threshold ',' density 1 ',' density 2 ',' notes ',' measure ',' param ',' group 1 ',' group 2 ',' brainregion '})
            set(ui_table_regionmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','char','numeric','numeric','numeric','char'})
            set(ui_table_regionmeasures,'ColumnEditable',[true false(1,18)])
            
            data = cell(length(cs),19);
            for i = 1:1:length(cs)
                if any(selected_regionmeasures==ci(i))
                    data{i,REGIONMEASURES_COMP_SELECTED_COL} = true;
                else
                    data{i,REGIONMEASURES_COMP_SELECTED_COL} = false;
                end
                
                diff = cs{i}.diff();
                data{i,REGIONMEASURES_COMP_DIFF_COL} = diff(bri);
                
                p1 = cs{i}.getProp(MRIComparisonBUT.PVALUE1);
                data{i,REGIONMEASURES_COMP_PVALUE1_COL} = p1(bri);
                data{i,REGIONMEASURES_COMP_FDR1_COL} = fdr(p1);
                
                p2 = cs{i}.getProp(MRIComparisonBUT.PVALUE2);
                data{i,REGIONMEASURES_COMP_PVALUE2_COL} = p2(bri);
                data{i,REGIONMEASURES_COMP_FDR2_COL} = fdr(p2);
                
                value1 = cs{i}.getProp(MRIComparisonBUT.VALUES1);
                data{i,REGIONMEASURES_COMP_VALUE1_COL} = value1(bri);
                
                value2 = cs{i}.getProp(MRIComparisonBUT.VALUES2);
                data{i,REGIONMEASURES_COMP_VALUE2_COL} = value2(bri);
                
                confint = cs{i}.CI(5);
                data{i,REGIONMEASURES_COMP_CIL_COL} = confint(1,bri);
                data{i,REGIONMEASURES_COMP_CIU_COL} = confint(2,bri);
                
                threshold = cs{i}.getProp(MRIComparisonBUT.THRESHOLD);
                data{i,REGIONMEASURES_COMP_THRESHOLD_COL} = threshold;
                
                density1 = cs{i}.getProp(MRIComparisonBUT.DENSITY1);
                density2 = cs{i}.getProp(MRIComparisonBUT.DENSITY2);
                data{i,REGIONMEASURES_COMP_DENSITY1_COL} = density1;
                data{i,REGIONMEASURES_COMP_DENSITY2_COL} = density2;
                
                data{i,REGIONMEASURES_COMP_NOTES_COL} = cs{i}.getProp(MRIComparisonBUT.NOTES);
                data{i,REGIONMEASURES_COMP_MEASURE_COL} = Graph.NAME{cs{i}.getProp(MRIComparisonBUT.CODE)};
                data{i,REGIONMEASURES_COMP_PARAM_COL} = cs{i}.getProp(MRIComparisonBUT.PARAM);
                data{i,REGIONMEASURES_COMP_GROUP1_COL} = cs{i}.getProp(MRIComparisonBUT.GROUP1);
                data{i,REGIONMEASURES_COMP_GROUP2_COL} = cs{i}.getProp(MRIComparisonBUT.GROUP2);
                data{i,REGIONMEASURES_COMP_BR_COL} = BrainRegions{bri};
            end
            
            set(ui_table_regionmeasures,'Data',data)
            set(ui_table_regionmeasures,'RowName',ci)
            
            elseif get(ui_checkbox_regionmeasures_rand,'Value')
            
            [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
            bri = get(ui_popup_regionmeasures_comp_br,'Value');
            
            set(ui_table_regionmeasures,'ColumnName',{'',' comp value ',' p (1-tailed) ',' fdr (1-tailed) ',' p (2-tailed) ',' fdr (2-tailed) ',' real value ',' CI lower ',' CI upper ',' threshold ',' density ',' notes ',' measure ',' param ',' group ',' brainregion '})
            set(ui_table_regionmeasures,'ColumnFormat',{'logical','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','char','numeric','numeric','char'})
            set(ui_table_regionmeasures,'ColumnEditable',[true false(1,15)])
            
            data = cell(length(ns),16);
            for i = 1:1:length(ns)
                if any(selected_regionmeasures==ni(i))
                    data{i,REGIONMEASURES_RAND_SELECTED_COL} = true;
                else
                    data{i,REGIONMEASURES_RAND_SELECTED_COL} = false;
                end
                
                val = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                data{i,REGIONMEASURES_RAND_COMPVALUE_COL} = val(bri);
                
                p1 = ns{i}.getProp(MRIRandomComparisonBUT.PVALUE1);
                data{i,REGIONMEASURES_RAND_PVALUE1_COL} = p1(bri);
                data{i,REGIONMEASURES_RAND_FDR1_COL} = fdr(p1);
                
                p2 = ns{i}.getProp(MRIRandomComparisonBUT.PVALUE2);
                data{i,REGIONMEASURES_RAND_PVALUE2_COL} = p2(bri);
                data{i,REGIONMEASURES_RAND_FDR2_COL} = fdr(p2);
                
                rval = ns{i}.getProp(MRIRandomComparisonBUT.VALUES1);
                data{i,REGIONMEASURES_RAND_REALVALUE_COL} = rval(bri);
                
                confint = ns{i}.CI(5);
                data{i,REGIONMEASURES_RAND_CIL_COL} = confint(1,bri);
                data{i,REGIONMEASURES_RAND_CIU_COL} = confint(2,bri);
                
                threshold = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                data{i,REGIONMEASURES_RAND_THRESHOLD_COL} = threshold;
                
                density = ns{i}.getProp(MRIRandomComparisonBUT.DENSITY1);
                data{i,REGIONMEASURES_RAND_DENSITY_COL} = density;
                
                data{i,REGIONMEASURES_RAND_NOTES_COL} = ns{i}.getProp(MRIRandomComparisonBUT.NOTES);
                data{i,REGIONMEASURES_RAND_MEASURE_COL} = Graph.NAME{ns{i}.getProp(MRIRandomComparisonBUT.CODE)};
                data{i,REGIONMEASURES_RAND_PARAM_COL} = ns{i}.getProp(MRIRandomComparisonBUT.PARAM);
                data{i,REGIONMEASURES_RAND_GROUP_COL} = ns{i}.getProp(MRIRandomComparisonBUT.GROUP1);
                data{i,REGIONMEASURES_RAND_BR_COL} = BrainRegions{bri};
            end

            set(ui_table_regionmeasures,'Data',data)
            set(ui_table_regionmeasures,'RowName',ni)
        end
    end
    function cb_regionmeasures_table(~,~)  % (src,event)
        update_regionmeasures();
    end
    function cb_regionmeasures_table_edit(~,event)  % (src,event)
        RowNames = get(ui_table_regionmeasures,'RowName');
        
        i = str2num(char(RowNames(event.Indices(1),:)));
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case {REGIONMEASURES_MEAS_SELECTED_COL REGIONMEASURES_COMP_SELECTED_COL REGIONMEASURES_RAND_SELECTED_COL}
                if newdata==1
                    selected_regionmeasures = sort(unique([selected_regionmeasures(:); i]));
                else
                    selected_regionmeasures = selected_regionmeasures(selected_regionmeasures~=i);
                end
        end
        
        update_regionmeasures();
    end
    function cb_regionmeasures_meas(~,~)  % (src,event)
        set(ui_checkbox_regionmeasures_meas,'Value',true)
        set(ui_checkbox_regionmeasures_meas,'FontWeight','bold') 
        set(ui_checkbox_regionmeasures_comp,'Value',false)
        set(ui_checkbox_regionmeasures_comp,'FontWeight','normal')
        set(ui_checkbox_regionmeasures_rand,'Value',false)
        set(ui_checkbox_regionmeasures_rand,'FontWeight','normal')
        set(ui_popup_regionmeasures_comp,'Enable','on')
        set(ui_popup_regionmeasures_comp_group1,'Enable','on')
        set(ui_popup_regionmeasures_comp_group2,'Enable','off')
        
        set(ui_checkbox_regionmeasures_ci,'Value',0)
        set(ui_checkbox_regionmeasures_ci,'Enable','off')
        
        update_regionmeasures()
    end
    function cb_regionmeasures_comp(~,~)  % (src,event)
        set(ui_checkbox_regionmeasures_meas,'Value',false)
        set(ui_checkbox_regionmeasures_meas,'FontWeight','normal')
        set(ui_checkbox_regionmeasures_comp,'Value',true)
        set(ui_checkbox_regionmeasures_comp,'FontWeight','bold')
        set(ui_checkbox_regionmeasures_rand,'Value',false)
        set(ui_checkbox_regionmeasures_rand,'FontWeight','normal')
        set(ui_popup_regionmeasures_comp,'Enable','on')
        set(ui_popup_regionmeasures_comp_group1,'Enable','on')
        set(ui_popup_regionmeasures_comp_group2,'Enable','on')
        
        set(ui_checkbox_regionmeasures_ci,'Value',0)
        set(ui_checkbox_regionmeasures_ci,'Enable','on')
        
        update_regionmeasures()
    end
    function cb_regionmeasures_rand(~,~)  % (src,event)
        set(ui_checkbox_regionmeasures_meas,'Value',false)
        set(ui_checkbox_regionmeasures_meas,'FontWeight','normal')
        set(ui_checkbox_regionmeasures_comp,'Value',false)
        set(ui_checkbox_regionmeasures_comp,'FontWeight','normal')
        set(ui_checkbox_regionmeasures_rand,'Value',true)
        set(ui_checkbox_regionmeasures_rand,'FontWeight','bold')
        set(ui_popup_regionmeasures_comp,'Enable','on')
        set(ui_popup_regionmeasures_comp_group1,'Enable','on')
        set(ui_popup_regionmeasures_comp_group2,'Enable','off')
        
        set(ui_checkbox_regionmeasures_ci,'Value',0)
        set(ui_checkbox_regionmeasures_ci,'Enable','on')
        
        update_regionmeasures()
    end
    function cb_regionmeasures_selectall(~,~)  % (src,event)
        RowNames = get(ui_table_regionmeasures,'RowName');
        
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            selected_regionmeasures = sort(unique([selected_regionmeasures(:); i]));
        end
        
        update_regionmeasures()
    end
    function cb_regionmeasures_clearselection(~,~)  % (src,event)
        RowNames = get(ui_table_regionmeasures,'RowName');
        
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            if any(selected_regionmeasures==i)
                selected_regionmeasures = selected_regionmeasures(selected_regionmeasures~=i);
            end
        end
        
        regionmeasures_table()
    end
    function cb_regionmeasures_remove(~,~)  % (src,event)
        RowNames = get(ui_table_regionmeasures,'RowName');
        
        selected = [];
        for r = 1:1:size(RowNames,1)
            i = str2num(char(RowNames(r,:)));
            if any(selected_regionmeasures==i)
                selected = [selected; i];
            end
        end
        selected = sort(selected);
        
        for i = length(selected):-1:1
            ga.remove(selected(i))
            selected_regionmeasures = selected_regionmeasures(selected_regionmeasures~=selected(i));
            selected_regionmeasures(selected_regionmeasures>selected(i)) = selected_regionmeasures(selected_regionmeasures>selected(i))-1;
        end
        
        update_regionmeasures()
    end

ui_axes_regionmeasures = axes();
ui_checkbox_regionmeasures_axes = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_checkbox_regionmeasures_holdon = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_checkbox_regionmeasures_cla = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_list_regionmeasures_plotted = uicontrol(ui_panel_regionmeasures,'Style', 'listbox');
ui_checkbox_regionmeasures_xlim = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_edit_regionmeasures_x1 = uicontrol(ui_panel_regionmeasures,'Style','edit');
ui_edit_regionmeasures_x2 = uicontrol(ui_panel_regionmeasures,'Style','edit');
ui_checkbox_regionmeasures_ylim = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
ui_edit_regionmeasures_y1 = uicontrol(ui_panel_regionmeasures,'Style','edit');
ui_edit_regionmeasures_y2 = uicontrol(ui_panel_regionmeasures,'Style','edit');
ui_checkbox_regionmeasures_ci = uicontrol(ui_panel_regionmeasures,'Style', 'checkbox');
init_regionmeasures_axes()
    function init_regionmeasures_axes()
        GUI.setUnits(ui_panel_regionmeasures)
        GUI.setBackgroundColor(ui_panel_regionmeasures)
        
        set(ui_table_regionmeasures,'BackgroundColor',GUI.TABBKGCOLOR)
        
        set(ui_axes_regionmeasures,'Parent',ui_panel_regionmeasures)
        set(ui_axes_regionmeasures,'Position',[.40 .26 .56 .72])
        
        set(ui_checkbox_regionmeasures_axes,'Position',[.65 .14 .10 .03])
        set(ui_checkbox_regionmeasures_axes,'String','hide figure')
        set(ui_checkbox_regionmeasures_axes,'Value',false)
        set(ui_checkbox_regionmeasures_axes,'TooltipString','Hide/show figure')
        set(ui_checkbox_regionmeasures_axes,'Callback',{@cb_regionmeasures_axes})
        
        set(ui_checkbox_regionmeasures_holdon,'Position',[.65 .09 .10 .03])
        set(ui_checkbox_regionmeasures_holdon,'String','hold graph')
        set(ui_checkbox_regionmeasures_holdon,'Value',false)
        set(ui_checkbox_regionmeasures_holdon,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_regionmeasures_holdon,'Callback',{@cb_regionmeasures_axes})
        
        set(ui_checkbox_regionmeasures_cla,'Position',[.65 .04 .10 .03])
        set(ui_checkbox_regionmeasures_cla,'String','clear axes')
        set(ui_checkbox_regionmeasures_cla,'Value',false)
        set(ui_checkbox_regionmeasures_cla,'TooltipString','Clear the axes')
        set(ui_checkbox_regionmeasures_cla,'Callback',{@cb_regionmeasures_cla})
        
        set(ui_list_regionmeasures_plotted,'String','')
        set(ui_list_regionmeasures_plotted,'Value',1)
        set(ui_list_regionmeasures_plotted,'Max',2,'Min',0)
        set(ui_list_regionmeasures_plotted,'Position',[.76 .02 .20 .15])
        set(ui_list_regionmeasures_plotted,'TooltipString','Plotted measures');
        set(ui_list_regionmeasures_plotted,'enable','on')
        set(ui_list_regionmeasures_plotted,'Callback',{@cb_regionmeasures_plotted});

        set(ui_checkbox_regionmeasures_xlim,'Position',[.54 .09 .10 .03])
        set(ui_checkbox_regionmeasures_xlim,'String','X Lim')
        set(ui_checkbox_regionmeasures_xlim,'Value',false)
        set(ui_checkbox_regionmeasures_xlim,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_regionmeasures_xlim,'Callback',{@cb_regionmeasures_xlim})
        
        set(ui_edit_regionmeasures_x1,'Position',[.40 .09 .05 .03])
        set(ui_edit_regionmeasures_x1,'String','-1')
        set(ui_edit_regionmeasures_x1,'enable','off')
        set(ui_edit_regionmeasures_x1,'TooltipString','Set X lower limit')
        set(ui_edit_regionmeasures_x1,'Callback',{@cb_regionmeasures_x1})
        
        set(ui_edit_regionmeasures_x2,'Position',[.47 .09 .05 .03])
        set(ui_edit_regionmeasures_x2,'String','1')
        set(ui_edit_regionmeasures_x2,'enable','off')
        set(ui_edit_regionmeasures_x2,'TooltipString','Set X higer limit')
        set(ui_edit_regionmeasures_x2,'Callback',{@cb_regionmeasures_x2})
        
        set(ui_checkbox_regionmeasures_ylim,'Position',[.54 .04 .10 .03])
        set(ui_checkbox_regionmeasures_ylim,'String','Y Lim')
        set(ui_checkbox_regionmeasures_ylim,'Value',false)
        set(ui_checkbox_regionmeasures_ylim,'TooltipString','Plot multiple graphs')
        set(ui_checkbox_regionmeasures_ylim,'Callback',{@cb_regionmeasures_ylim})
        
        set(ui_edit_regionmeasures_y1,'Position',[.40 .04 .05 .03])
        set(ui_edit_regionmeasures_y1,'String','-1')
        set(ui_edit_regionmeasures_y1,'enable','off')
        set(ui_edit_regionmeasures_y1,'TooltipString','Set Y lower limit')
        set(ui_edit_regionmeasures_y1,'Callback',{@cb_regionmeasures_y1})
        
        set(ui_edit_regionmeasures_y2,'Position',[.47 .04 .05 .03])
        set(ui_edit_regionmeasures_y2,'String','1')
        set(ui_edit_regionmeasures_y2,'enable','off')
        set(ui_edit_regionmeasures_y2,'TooltipString','Set Y higer limit')
        set(ui_edit_regionmeasures_y2,'Callback',{@cb_regionmeasures_y2})
        
        set(ui_checkbox_regionmeasures_ci,'Position',[.40 .14 .25 .03])
        set(ui_checkbox_regionmeasures_ci,'String','show confidence intervals')
        set(ui_checkbox_regionmeasures_ci,'enable','off')
        set(ui_checkbox_regionmeasures_ci,'Value',false)
        set(ui_checkbox_regionmeasures_ci,'TooltipString','Show confidence intervals')
        set(ui_checkbox_regionmeasures_ci,'Callback',{@cb_regionmeasures_ci})
    end
    function update_regionmeasures_axes()
        axes(ui_axes_regionmeasures)
        
        if get(ui_checkbox_regionmeasures_axes,'Value')
            
            set(ui_table_regionmeasures,'Position',[.02 .19 .96 .79])
            cla(ui_axes_regionmeasures)
            set(ui_axes_regionmeasures,'Visible','off')
            set(ui_list_regionmeasures_plotted,'String','')
        else
            set(ui_checkbox_regionmeasures_axes,'value',false)
            set(ui_table_regionmeasures,'Position',[.02 .19 .32 .79])
            set(ui_axes_regionmeasures,'Visible','on')
            
            mlist = GraphBU.measurelist(true);  % list of nodal measures
            
            if get(ui_checkbox_regionmeasures_holdon,'Value')
                
                if get(ui_checkbox_regionmeasures_meas,'Value')
                    
                    [ms,mi] = ga.getMeasures(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    if ~isempty(mi)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' measure - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                            
                            d = zeros(1,length(ms));
                            meas = zeros(1,length(ms));
                            
                            for i = 1:1:length(ms)
                                meas1 = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                                meas(i) = meas1(bri);
                                d(i) = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                            end
                            
                            pe = PlotDataElement( ...
                                PlotDataElement.CODE,name, ...
                                PlotDataElement.X,d, ...
                                PlotDataElement.Y,meas);
                            
                            plot_data_nodal.add(pe);
                            plot_data_nodal.set_axes(ui_axes_regionmeasures);
                            plot_data_nodal.hold_on()
                            
                            % context menus
                            ui_contextmenu_meas_nodal = uicontextmenu();
                            ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_settings,'Label','Data settings')
                            set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings_nodal})
                            
                            plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal);
                            xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                            ylabel(REGIONMEASURES_LABEL_MEASURE)
                        end
                    end
                    
                elseif get(ui_checkbox_regionmeasures_comp,'Value')
                    
                    [cs,ci] = ga.getComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'),get(ui_popup_regionmeasures_comp_group2,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    if ~isempty(ci)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' comparison - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'groups = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value')) 'and' int2str(get(ui_popup_regionmeasures_comp_group2,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                            
                            d = zeros(1,length(cs));
                            diff = zeros(1,length(cs));
                            m = zeros(1,length(cs));
                            ci5l = zeros(1,length(cs));
                            ci5u = zeros(1,length(cs));
                            
                            for i = 1:1:length(cs)
                                
                                d(i) = cs{i}.getProp(MRIMeasureBUT.THRESHOLD);
                                
                                temp = cs{i}.diff();
                                diff(i) = temp(bri);
                                
                                temp = cs{i}.CI(50);
                                m(i) = temp(bri);
                                
                                ci5 = cs{i}.CI(5);
                                ci5l(i) = ci5(1,bri);
                                ci5u(i) = ci5(2,bri);
                            end
                            
                            pe = PlotDataArea( ...
                                PlotDataArea.CODE,name, ...
                                PlotDataArea.X,d, ...
                                PlotDataArea.Y,diff, ...
                                PlotDataArea.Y_LOW,ci5l, ...
                                PlotDataArea.Y_MID,m, ...
                                PlotDataArea.Y_HIGH,ci5u);
                            
                            plot_data_nodal.add(pe);
                            plot_data_nodal.set_axes(ui_axes_regionmeasures);
                            plot_data_nodal.hold_on()
                            
                            % context menus
                            ui_contextmenu_meas_nodal = uicontextmenu();
                            ui_contextmenu_measure_settings_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_settings_nodal,'Label','Data settings')
                            set(ui_contextmenu_measure_settings_nodal,'Callback',{@cb_data_settings_nodal})
                            ui_contextmenu_measure_up_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_up_nodal,'Label','Upper confidence border settings')
                            set(ui_contextmenu_measure_up_nodal,'Callback',{@cb_up_settings_nodal})
                            ui_contextmenu_measure_low_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_low_nodal,'Label','Lower confidence border settings')
                            set(ui_contextmenu_measure_low_nodal,'Callback',{@cb_low_settings_nodal})
                            ui_contextmenu_measure_mid_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_mid_nodal,'Label','Middle confidence line settings')
                            set(ui_contextmenu_measure_mid_nodal,'Callback',{@cb_mid_settings_nodal})
                            ui_contextmenu_measure_area_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_area_nodal,'Label','Area settings')
                            set(ui_contextmenu_measure_area_nodal,'Callback',{@cb_area_settings_nodal})
                            
                            plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal)
                            xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                            ylabel(REGIONMEASURES_LABEL_MEASDIFF)
                            update_ci_nodal()
                        end
                    end
                    
                elseif get(ui_checkbox_regionmeasures_rand,'Value')
                    
                    [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    if ~isempty(ni)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' random comp. - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value'))];
                        if isempty(strmatch(name,str2))
                            set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                            
                            d = zeros(1,length(ns));
                            meas = zeros(1,length(ns));
                            m = zeros(1,length(ns));
                            ci5l = zeros(1,length(ns));
                            ci5u = zeros(1,length(ns));
                            
                            for i = 1:1:length(ns)
                                d(i) = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                                
                                temp = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                                meas(i) = temp(bri);
                                
                                temp = ns{i}.CI(50);
                                m(i) = temp(bri);
                                
                                ci5 = ns{i}.CI(5);
                                ci5l(i) = ci5(1,bri);
                                ci5u(i) = ci5(2,bri);
                            end
                            
                            pe = PlotDataArea( ...
                                PlotDataArea.CODE,name, ...
                                PlotDataArea.X,d, ...
                                PlotDataArea.Y,meas, ...
                                PlotDataArea.Y_LOW,ci5l, ...
                                PlotDataArea.Y_MID,m, ...
                                PlotDataArea.Y_HIGH,ci5u);
                            
                            plot_data_nodal.add(pe);
                            plot_data_nodal.set_axes(ui_axes_regionmeasures);
                            plot_data_nodal.hold_on()
                            
                            
                            % context menus
                            ui_contextmenu_meas_nodal = uicontextmenu();
                            ui_contextmenu_measure_settings_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_settings_nodal,'Label','Data settings')
                            set(ui_contextmenu_measure_settings_nodal,'Callback',{@cb_data_settings_nodal})
                            ui_contextmenu_measure_up_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_up_nodal,'Label','Upper confidence border settings')
                            set(ui_contextmenu_measure_up_nodal,'Callback',{@cb_up_settings_nodal})
                            ui_contextmenu_measure_low_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_low_nodal,'Label','Lower confidence border settings')
                            set(ui_contextmenu_measure_low_nodal,'Callback',{@cb_low_settings_nodal})
                            ui_contextmenu_measure_mid_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_mid_nodal,'Label','Middle confidence line settings')
                            set(ui_contextmenu_measure_mid_nodal,'Callback',{@cb_mid_settings_nodal})
                            ui_contextmenu_measure_area_nodal = uimenu(ui_contextmenu_meas_nodal);
                            set(ui_contextmenu_measure_area_nodal,'Label','Area settings')
                            set(ui_contextmenu_measure_area_nodal,'Callback',{@cb_area_settings_nodal})
                            
                            plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal)
                            xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                            ylabel(REGIONMEASURES_LABEL_RANDOM)
                            update_ci_nodal()
                        end
                    end
                end
                
            else
                cla(ui_axes_regionmeasures)
                set(ui_list_regionmeasures_plotted,'String','')
                for i = plot_data_nodal.length():-1:1
                    plot_data_nodal.remove(i);
                end
                
                if get(ui_checkbox_regionmeasures_meas,'Value')
                    
                    [ms,mi] = ga.getMeasures(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    
                    if ~isempty(mi)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' measure - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value'))];
                        set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                        
                        d = zeros(1,length(ms));
                        meas = zeros(1,length(ms));
                        
                        for i = 1:1:length(ms)
                            meas1 = ms{i}.getProp(MRIMeasureBUT.VALUES1);
                            meas(i) = meas1(bri);
                            d(i) = ms{i}.getProp(MRIMeasureBUT.THRESHOLD);
                        end
                        
                        pe = PlotDataElement( ...
                            PlotDataElement.CODE,name, ...
                            PlotDataElement.X,d, ...
                            PlotDataElement.Y,meas);
                        
                        plot_data_nodal.add(pe);
                        plot_data_nodal.set_axes(ui_axes_regionmeasures);
                        
                        % context menus
                        ui_contextmenu_meas_nodal = uicontextmenu();
                        ui_contextmenu_measure_settings = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_settings,'Label','Data settings')
                        set(ui_contextmenu_measure_settings,'Callback',{@cb_data_settings_nodal})
                        
                        plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal);
                        
                        xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                        ylabel(REGIONMEASURES_LABEL_MEASURE)
                    end
                    
                elseif get(ui_checkbox_regionmeasures_comp,'Value')
                    
                    [cs,ci] = ga.getComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'),get(ui_popup_regionmeasures_comp_group2,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    if ~isempty(ci)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' comparison - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'groups = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value')) 'and' int2str(get(ui_popup_regionmeasures_comp_group2,'Value'))];
                        set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                        
                        d = zeros(1,length(cs));
                        diff = zeros(1,length(cs));
                        m = zeros(1,length(cs));
                        ci5l = zeros(1,length(cs));
                        ci5u = zeros(1,length(cs));
                        
                        for i = 1:1:length(cs)
                            
                            d(i) = cs{i}.getProp(MRIMeasureBUT.THRESHOLD);
                            
                            temp = cs{i}.diff();
                            diff(i) = temp(bri);
                            
                            temp = cs{i}.CI(50);
                            m(i) = temp(bri);
                            
                            ci5 = cs{i}.CI(5);
                            ci5l(i) = ci5(1,bri);
                            ci5u(i) = ci5(2,bri);
                        end
                        
                        pe = PlotDataArea( ...
                            PlotDataArea.CODE,name, ...
                            PlotDataArea.X,d, ...
                            PlotDataArea.Y,diff, ...
                            PlotDataArea.Y_LOW,ci5l, ...
                            PlotDataArea.Y_MID,m, ...
                            PlotDataArea.Y_HIGH,ci5u);
                        
                        plot_data_nodal.add(pe);
                        plot_data_nodal.set_axes(ui_axes_regionmeasures);
                        
                        % context menus
                        ui_contextmenu_meas_nodal = uicontextmenu();
                        ui_contextmenu_measure_settings_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_settings_nodal,'Label','Data settings')
                        set(ui_contextmenu_measure_settings_nodal,'Callback',{@cb_data_settings_nodal})
                        ui_contextmenu_measure_up_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_up_nodal,'Label','Upper confidence border settings')
                        set(ui_contextmenu_measure_up_nodal,'Callback',{@cb_up_settings_nodal})
                        ui_contextmenu_measure_low_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_low_nodal,'Label','Lower confidence border settings')
                        set(ui_contextmenu_measure_low_nodal,'Callback',{@cb_low_settings_nodal})
                        ui_contextmenu_measure_mid_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_mid_nodal,'Label','Middle confidence line settings')
                        set(ui_contextmenu_measure_mid_nodal,'Callback',{@cb_mid_settings_nodal})
                        ui_contextmenu_measure_area_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_area_nodal,'Label','Area settings')
                        set(ui_contextmenu_measure_area_nodal,'Callback',{@cb_area_settings_nodal})
                        
                        plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal)
                        xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                        ylabel(REGIONMEASURES_LABEL_MEASDIFF)
                        update_ci_nodal()
                    end
                    
                elseif get(ui_checkbox_regionmeasures_rand,'Value')
                    
                    [ns,ni] = ga.getRandomComparisons(mlist(get(ui_popup_regionmeasures_comp,'Value')),get(ui_popup_regionmeasures_comp_group1,'Value'));
                    bri = get(ui_popup_regionmeasures_comp_br,'Value');
                    br_name = ga.getCohort().getBrainAtlas().get(bri).getProp(BrainRegion.LABEL);
                    
                    if ~isempty(ni)
                        % update list
                        str1 = get(ui_popup_regionmeasures_comp,'String');
                        str2 = get(ui_list_regionmeasures_plotted,'String');
                        name = ['br.region - ' br_name ' random comp. - ' str1{get(ui_popup_regionmeasures_comp,'Value')} ' - ' 'group = ' int2str(get(ui_popup_regionmeasures_comp_group1,'Value'))];
                        set(ui_list_regionmeasures_plotted,'String',strvcat(str2,name));
                        
                        d = zeros(1,length(ns));
                        meas = zeros(1,length(ns));
                        m = zeros(1,length(ns));
                        ci5l = zeros(1,length(ns));
                        ci5u = zeros(1,length(ns));
                        
                        for i = 1:1:length(ns)
                            d(i) = ns{i}.getProp(MRIRandomComparisonBUT.THRESHOLD);
                            
                            temp = ns{i}.getProp(MRIRandomComparisonBUT.RANDOM_COMP_VALUES);
                            meas(i) = temp(bri);
                            
                            temp = ns{i}.CI(50);
                            m(i) = temp(bri);
                            
                            ci5 = ns{i}.CI(5);
                            ci5l(i) = ci5(1,bri);
                            ci5u(i) = ci5(2,bri);
                        end
                        
                        pe = PlotDataArea( ...
                            PlotDataArea.CODE,name, ...
                            PlotDataArea.X,d, ...
                            PlotDataArea.Y,meas, ...
                            PlotDataArea.Y_LOW,ci5l, ...
                            PlotDataArea.Y_MID,m, ...
                            PlotDataArea.Y_HIGH,ci5u);
                        
                        plot_data_nodal.add(pe);
                        plot_data_nodal.set_axes(ui_axes_regionmeasures);
                        
                        % context menus
                        ui_contextmenu_meas_nodal = uicontextmenu();
                        ui_contextmenu_measure_settings_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_settings_nodal,'Label','Data settings')
                        set(ui_contextmenu_measure_settings_nodal,'Callback',{@cb_data_settings_nodal})
                        ui_contextmenu_measure_up_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_up_nodal,'Label','Upper confidence border settings')
                        set(ui_contextmenu_measure_up_nodal,'Callback',{@cb_up_settings_nodal})
                        ui_contextmenu_measure_low_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_low_nodal,'Label','Lower confidence border settings')
                        set(ui_contextmenu_measure_low_nodal,'Callback',{@cb_low_settings_nodal})
                        ui_contextmenu_measure_mid_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_mid_nodal,'Label','Middle confidence line settings')
                        set(ui_contextmenu_measure_mid_nodal,'Callback',{@cb_mid_settings_nodal})
                        ui_contextmenu_measure_area_nodal = uimenu(ui_contextmenu_meas_nodal);
                        set(ui_contextmenu_measure_area_nodal,'Label','Area settings')
                        set(ui_contextmenu_measure_area_nodal,'Callback',{@cb_area_settings_nodal})
                        
                        plot_data_nodal.plot_data([],'UIContextMenu',ui_contextmenu_meas_nodal)
                        xlabel(REGIONMEASURES_LABEL_THRESHOLD)
                        ylabel(REGIONMEASURES_LABEL_RANDOM)
                        update_ci_nodal()
                    end
                end
            end
        end
    end
    function cb_regionmeasures_axes(~,~)  % (src,event)
        update_regionmeasures()
    end
    function cb_regionmeasures_ci(~,~)  % (src,event)
        update_ci_nodal()
    end
    function update_ci_nodal()
        for i = 1:1:plot_data_nodal.length()
            
            if isa(plot_data_nodal.get(i),'PlotDataArea')
                
                if get(ui_checkbox_regionmeasures_ci,'Value')
                    
                    % context menus
                    ui_contextmenu_meas_nodal = uicontextmenu();
                    ui_contextmenu_measure_settings_nodal = uimenu(ui_contextmenu_meas_nodal);
                    set(ui_contextmenu_measure_settings_nodal,'Label','Data settings')
                    set(ui_contextmenu_measure_settings_nodal,'Callback',{@cb_data_settings_nodal})
                    ui_contextmenu_measure_up_nodal = uimenu(ui_contextmenu_meas_nodal);
                    set(ui_contextmenu_measure_up_nodal,'Label','Upper confidence border settings')
                    set(ui_contextmenu_measure_up_nodal,'Callback',{@cb_up_settings_nodal})
                    ui_contextmenu_measure_low_nodal = uimenu(ui_contextmenu_meas_nodal);
                    set(ui_contextmenu_measure_low_nodal,'Label','Lower confidence border settings')
                    set(ui_contextmenu_measure_low_nodal,'Callback',{@cb_low_settings_nodal})
                    ui_contextmenu_measure_mid_nodal = uimenu(ui_contextmenu_meas_nodal);
                    set(ui_contextmenu_measure_mid_nodal,'Label','Middle confidence line settings')
                    set(ui_contextmenu_measure_mid_nodal,'Callback',{@cb_mid_settings_nodal})
                    ui_contextmenu_measure_area_nodal = uimenu(ui_contextmenu_meas_nodal);
                    set(ui_contextmenu_measure_area_nodal,'Label','Area settings')
                    set(ui_contextmenu_measure_area_nodal,'Callback',{@cb_area_settings_nodal})
                    
                    pde_temp = PlotDataArea();
                    
                    plot_data_nodal.plot_low(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.LOW_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.LOW_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas_nodal)
                    plot_data_nodal.plot_low_on(i);
                    
                    plot_data_nodal.plot_high(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.HIGH_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.HIGH_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas_nodal)
                    plot_data_nodal.plot_high_on(i);
                    
                    plot_data_nodal.plot_mid(i,...
                        'markercolor',(pde_temp.getProp(PlotDataArea.MID_SYM_FACE_COLOR)+3)./4,...
                        'color',(pde_temp.getProp(PlotDataArea.MID_LIN_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas_nodal)
                    plot_data_nodal.plot_mid_on(i);
                    
                    plot_data_nodal.plot_area(i,...
                        'areacolor',(pde_temp.getProp(PlotDataArea.AREA_FACE_COLOR)+3)./4,...
                        'UIContextMenu',ui_contextmenu_meas_nodal)
                    plot_data_nodal.plot_area_on(i);
                    
                    pde = plot_data_nodal.get(i);
                    uistack(pde.getYHighHandle(),'bottom')
                    uistack(pde.getYLowHandle(),'bottom')
                    uistack(pde.getYMidHandle(),'bottom')
                    uistack(pde.getAreaHandle(),'bottom')
                    
                else
                    plot_data_nodal.plot_data_off(i);
                    
                    plot_data_nodal.plot_high_off(i);
                    plot_data_nodal.plot_low_off(i);
                    plot_data_nodal.plot_mid_off(i);
                    plot_data_nodal.plot_area_off(i);
                    
                    plot_data_nodal.plot_data_on(i);
                end
            end
        end
    end
    function cb_data_settings_nodal(~,~)  % (src,event)
        
        i = plot_data_nodal.get_pde_i(gco);
        
        if isfinite(i)
            plot_data_nodal.plot_data_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_nodal.plot_data_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_up_settings_nodal(~,~)  % (src,event)
        i = plot_data_nodal.get_pde_high_i(gco);
        
        if isfinite(i)
            plot_data_nodal.plot_high_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_nodal.plot_high_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_low_settings_nodal(~,~)  % (src,event)
        i = plot_data_nodal.get_pde_low_i(gco);
        
        if isfinite(i)
            plot_data_nodal.plot_low_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_nodal.plot_low_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_mid_settings_nodal(~,~)  % (src,event)
        i = plot_data_nodal.get_pde_mid_i(gco);
        
        if isfinite(i)
            plot_data_nodal.plot_mid_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_nodal.plot_mid_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_area_settings_nodal(~,~)  % (src,event)
        i = plot_data_nodal.get_pde_area_i(gco);
        
        if isfinite(i)
            plot_data_nodal.plot_area_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            plot_data_nodal.plot_area_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_regionmeasures_cla(~,~)  % (src,event)
        cla(ui_axes_regionmeasures)
        set(ui_list_regionmeasures_plotted,'String','')
        
        set(ui_checkbox_regionmeasures_axes,'Value',false)
        set(ui_checkbox_regionmeasures_holdon,'Value',false)
        set(ui_checkbox_regionmeasures_cla,'Value',false)
        
        set(ui_checkbox_regionmeasures_meas,'Value',false)
        set(ui_checkbox_regionmeasures_meas,'FontWeight','normal')
        
        set(ui_checkbox_regionmeasures_comp,'Value',false)
        set(ui_checkbox_regionmeasures_comp,'Value',false)
        set(ui_popup_regionmeasures_comp,'FontWeight','normal')
        set(ui_popup_regionmeasures_comp_group1,'enable','off')
        set(ui_popup_regionmeasures_comp_group2,'enable','off')
        
        set(ui_checkbox_regionmeasures_rand,'Value',false)
        set(ui_checkbox_regionmeasures_rand,'FontWeight','normal')
    end
    function cb_regionmeasures_xlim(~,~)  % (src,event)
        if get(ui_checkbox_regionmeasures_xlim,'Value')
            set(ui_edit_regionmeasures_x1,'enable','on')
            set(ui_edit_regionmeasures_x2,'enable','on')
            x1 = str2num(get(ui_edit_regionmeasures_x1,'String'));
            x2 = str2num(get(ui_edit_regionmeasures_x2,'String'));
            set(ui_axes_regionmeasures,'XLim',[x1 x2])
        else
            set(ui_edit_regionmeasures_x1,'enable','off')
            set(ui_edit_regionmeasures_x2,'enable','off')
            set(ui_axes_regionmeasures,'XLimMode','auto')
        end
    end
    function cb_regionmeasures_x1(~,~)  % (src,event)
        x1 = real(str2num(get(ui_edit_regionmeasures_x1,'String')));
        if isempty(x1) || isnan(x1) || x1>=str2num(get(ui_edit_regionmeasures_x2,'String'))
            x1 = str2num(get(ui_edit_regionmeasures_x2,'String'))-1;
        end
        set(ui_edit_regionmeasures_x1,'String',num2str(x1))
        set(ui_axes_regionmeasures,'XLim',[x1 str2num(get(ui_edit_regionmeasures_x2,'String'))])
    end
    function cb_regionmeasures_x2(~,~)  % (src,event)
        x2 = real(str2num(get(ui_edit_regionmeasures_x2,'String')));
        if isempty(x2) || isnan(x2) || x2<=str2num(get(ui_edit_regionmeasures_x1,'String'))
            x2 = str2num(get(ui_edit_regionmeasures_x1,'String'))+1;
        end
        set(ui_axes_regionmeasures,'XLim',[str2num(get(ui_edit_regionmeasures_x1,'String')) x2])
        set(ui_edit_regionmeasures_x2,'String',num2str(x2))
    end
    function cb_regionmeasures_ylim(~,~)  % (src,event)
        if get(ui_checkbox_regionmeasures_ylim,'Value')
            set(ui_edit_regionmeasures_y1,'enable','on')
            set(ui_edit_regionmeasures_y2,'enable','on')
            y1 = str2num(get(ui_edit_regionmeasures_y1,'String'));
            y2 = str2num(get(ui_edit_regionmeasures_y2,'String'));
            set(ui_axes_regionmeasures,'YLim',[y1 y2])
        else
            set(ui_edit_regionmeasures_y1,'enable','off')
            set(ui_edit_regionmeasures_y2,'enable','off')
            set(ui_axes_regionmeasures,'YLimMode','auto')
        end
    end
    function cb_regionmeasures_y1(~,~)  % (src,event)
        y1 = real(str2num(get(ui_edit_regionmeasures_y1,'String')));
        if isempty(y1) || isnan(y1) || y1>=str2num(get(ui_edit_regionmeasures_y2,'String'))
            y1 = str2num(get(ui_edit_regionmeasures_y2,'String'))-1;
        end
        set(ui_edit_regionmeasures_y1,'String',num2str(y1))
        set(ui_axes_regionmeasures,'YLim',[y1 str2num(get(ui_edit_regionmeasures_y2,'String'))])
    end
    function cb_regionmeasures_y2(~,~)  % (src,event)
        y2 = real(str2num(get(ui_edit_regionmeasures_y2,'String')));
        if isempty(y2) || isnan(y2) || y2<=str2num(get(ui_edit_regionmeasures_y1,'String'))
            y2 = str2num(get(ui_edit_regionmeasures_y1,'String'))+1;
        end
        set(ui_axes_regionmeasures,'YLim',[str2num(get(ui_edit_regionmeasures_y1,'String')) y2])
        set(ui_edit_regionmeasures_y2,'String',num2str(y2))
    end


%% Panel 4 - Brain View
BRAINVIEW_GRAPH_CMD = 'View brain graph';
BRAINVIEW_GRAPH_TP = 'View brain graph';
BRAINVIEW_GROUP_CMD = 'View group measures';
BRAINVIEW_GROUP_TP = 'View group measures';
BRAINVIEW_COMPARISON_CMD = 'View comparison';
BRAINVIEW_COMPARISON_TP = 'View comparison';
BRAINVIEW_RAND_CMD = 'View random comparison';
BRAINVIEW_RAND_TP = 'View random comparison';

BRAINVIEW_XLABEL = 'x';
BRAINVIEW_YLABEL = 'y';
BRAINVIEW_ZLABEL = 'z';
BRAINVIEW_UNITS = 'mm';

BRAINVIEW_3D_CMD = PlotBrainSurf.VIEW_3D_CMD;
BRAINVIEW_SR_CMD = PlotBrainSurf.VIEW_SR_CMD;
BRAINVIEW_SL_CMD = PlotBrainSurf.VIEW_SL_CMD;
BRAINVIEW_AD_CMD = PlotBrainSurf.VIEW_AD_CMD;
BRAINVIEW_AV_CMD = PlotBrainSurf.VIEW_AV_CMD;
BRAINVIEW_CA_CMD = PlotBrainSurf.VIEW_CA_CMD;
BRAINVIEW_CP_CMD = PlotBrainSurf.VIEW_CP_CMD;

BRAINVIEW_ZOOMIN_CMD = 'Zoom in';
BRAINVIEW_ZOOMIN_TP = 'Zoom in';

BRAINVIEW_ZOOMOUT_CMD = 'Zoom out';
BRAINVIEW_ZOOMOUT_TP = 'Zoom out';

BRAINVIEW_PAN_CMD = 'Pan';
BRAINVIEW_PAN_TP = 'Pan';

BRAINVIEW_ROTATE3D_CMD = '3D rotation';
BRAINVIEW_ROTATE3D_TP = '3D rotation';

BRAINVIEW_DATACURSOR_CMD = 'Data cursor';
BRAINVIEW_DATACURSOR_TP = 'Data cursor';

BRAINVIEW_DATACURSOR_CMD = 'Data cursor';
BRAINVIEW_DATACURSOR_TP = 'Data cursor';

BRAINVIEW_INSERTCOLORBAR_CMD = 'Data cursor';
BRAINVIEW_INSERTCOLORBAR_TP = 'Data cursor';

BRAINVIEW_BRAIN_CMD = 'Brain';
BRAINVIEW_BRAIN_TP = 'Brain surface on/off';

BRAINVIEW_BRAIN_ALPHA_CMD = 'Brain transparency';
BRAINVIEW_BRAIN_ALPHA_TP = 'Adjust the transparency of the brain surface';

BRAINVIEW_BR_CMD = 'Regions';
BRAINVIEW_BR_TP = 'Brain regions on/off';

BRAINVIEW_BR_ALPHA_CMD = 'Brain region transparency';
BRAINVIEW_BR_ALPHA_TP = 'Adjust the transparency of the brain regions';

BRAINVIEW_AXIS_CMD = 'Show axis';
BRAINVIEW_AXIS_TP = 'Toggle axis on/off';

BRAINVIEW_GRID_CMD = 'Show grid';
BRAINVIEW_GRID_TP = 'Toggle grid on/off';

BRAINVIEW_LABELS_CMD = 'Show labels';
BRAINVIEW_LABELS_TP = 'Toggle labels on/off';

BRAINVIEW_SYMS_CMD = 'Show symbols';
BRAINVIEW_SYMS_TP = 'Toggle symbols on/off';

BRAINVIEW_BRAIN_SETTINGS = 'Brain settings';
BRAINVIEW_BR_SETTINGS = 'Brain region sphere settings';
BRAINVIEW_SYM_SETTINGS = 'Brain region symbols settings';
BRAINVIEW_LAB_SETTINGS = 'Brain region labels settings';
%
ui_panel_brainview = uipanel();
ui_axes_brainview = axes();
ui_button_brainview_group = uicontrol(ui_panel_brainview,'Style', 'pushbutton');
ui_button_brainview_comparison = uicontrol(ui_panel_brainview,'Style', 'pushbutton');
ui_button_brainview_random = uicontrol(ui_panel_brainview,'Style', 'pushbutton');
ui_button_brainview_graph = uicontrol(ui_panel_brainview,'Style', 'pushbutton');
init_brainview()
    function init_brainview()
        GUI.setUnits(ui_panel_brainview)
        GUI.setBackgroundColor(ui_panel_brainview)
        
        set(ui_panel_brainview,'Position',MAINPANEL_POSITION)
        set(ui_panel_brainview,'Title',CONSOLE_BRAINVIEW_CMD)
        
        set(ui_axes_brainview,'Parent',ui_panel_brainview)
        set(ui_axes_brainview,'Position',[.02 .20 .96 .78])
        
        set(ui_button_brainview_graph,'Position',[.08 .05 .15 .05])
        set(ui_button_brainview_graph,'String',BRAINVIEW_GRAPH_CMD)
        set(ui_button_brainview_graph,'TooltipString',BRAINVIEW_GRAPH_TP)
        set(ui_button_brainview_graph,'Callback',{@cb_brainview_graph})
        
        set(ui_button_brainview_group,'Position',[.31 .05 .15 .05])
        set(ui_button_brainview_group,'String',BRAINVIEW_GROUP_CMD)
        set(ui_button_brainview_group,'TooltipString',BRAINVIEW_GROUP_TP)
        set(ui_button_brainview_group,'Callback',{@cb_brainview_viewgroup})
        
        set(ui_button_brainview_comparison,'Position',[.54 .05 .15 .05])
        set(ui_button_brainview_comparison,'String',BRAINVIEW_COMPARISON_CMD)
        set(ui_button_brainview_comparison,'TooltipString',BRAINVIEW_COMPARISON_TP)
        set(ui_button_brainview_comparison,'Callback',{@cb_brainview_viewcomparison})
        
        set(ui_button_brainview_random,'Position',[.77 .05 .15 .05])
        set(ui_button_brainview_random,'String',BRAINVIEW_RAND_CMD)
        set(ui_button_brainview_random,'TooltipString',BRAINVIEW_RAND_TP)
        set(ui_button_brainview_random,'Callback',{@cb_brainview_viewrandom})
    end
    function update_brainview()
        axes(ui_axes_brainview)
        
        % brain
        if strcmpi(get(ui_toolbar_brain,'State'),'on')
            bg.brain_on()
            
            ui_contextmenu_brain = uicontextmenu();
            ui_contextmenu_brain_settings = uimenu(ui_contextmenu_brain);
            set(ui_contextmenu_brain_settings,'Label',BRAINVIEW_BRAIN_SETTINGS)
            set(ui_contextmenu_brain_settings,'Callback',{@cb_brainview_brain_settings})
            ui_contextmenu_sym_settings = uimenu(ui_contextmenu_brain);
            set(ui_contextmenu_sym_settings,'Label',BRAINVIEW_SYM_SETTINGS)
            set(ui_contextmenu_sym_settings,'Callback',{@cb_brainview_sym_settings})
            ui_contextmenu_br_settings = uimenu(ui_contextmenu_brain);
            set(ui_contextmenu_br_settings,'Label',BRAINVIEW_BR_SETTINGS)
            set(ui_contextmenu_br_settings,'Callback',{@cb_brainview_br_settings})
            ui_contextmenu_lab_settings = uimenu(ui_contextmenu_brain);
            set(ui_contextmenu_lab_settings,'Label',BRAINVIEW_LAB_SETTINGS)
            set(ui_contextmenu_lab_settings,'Callback',{@cb_brainview_lab_settings})
            bg.brain('UIContextMenu',ui_contextmenu_brain)
        else
            bg.brain_off()
        end
        
        % brain regions symbols
        if strcmpi(get(ui_toolbar_sym,'State'),'on')
            bg.br_syms_on()
            bg.br_syms()
            
            ui_contextmenu_sym = uicontextmenu();
            ui_contextmenu_brain_settings = uimenu(ui_contextmenu_sym);
            set(ui_contextmenu_brain_settings,'Label',BRAINVIEW_BRAIN_SETTINGS)
            set(ui_contextmenu_brain_settings,'Callback',{@cb_brainview_brain_settings})
            ui_contextmenu_sym_settings = uimenu(ui_contextmenu_sym);
            set(ui_contextmenu_sym_settings,'Label',BRAINVIEW_SYM_SETTINGS)
            set(ui_contextmenu_sym_settings,'Callback',{@cb_brainview_sym_settings})
            ui_contextmenu_br_settings = uimenu(ui_contextmenu_sym);
            set(ui_contextmenu_br_settings,'Label',BRAINVIEW_BR_SETTINGS)
            set(ui_contextmenu_br_settings,'Callback',{@cb_brainview_br_settings})
            ui_contextmenu_lab_settings = uimenu(ui_contextmenu_sym);
            set(ui_contextmenu_lab_settings,'Label',BRAINVIEW_LAB_SETTINGS)
            set(ui_contextmenu_lab_settings,'Callback',{@cb_brainview_lab_settings})
            bg.br_syms([],'UIContextMenu',ui_contextmenu_sym)
        else
            bg.br_syms_off()
        end
        
        % brain regions
        if strcmpi(get(ui_toolbar_br,'State'),'on')
            bg.br_sphs_on()
            
            ui_contextmenu_br = uicontextmenu();
            ui_contextmenu_brain_settings = uimenu(ui_contextmenu_br);
            set(ui_contextmenu_brain_settings,'Label',BRAINVIEW_BRAIN_SETTINGS)
            set(ui_contextmenu_brain_settings,'Callback',{@cb_brainview_brain_settings})
            ui_contextmenu_sym_settings = uimenu(ui_contextmenu_br);
            set(ui_contextmenu_sym_settings,'Label',BRAINVIEW_SYM_SETTINGS)
            set(ui_contextmenu_sym_settings,'Callback',{@cb_brainview_sym_settings})
            ui_contextmenu_br_settings = uimenu(ui_contextmenu_br);
            set(ui_contextmenu_br_settings,'Label',BRAINVIEW_BR_SETTINGS)
            set(ui_contextmenu_br_settings,'Callback',{@cb_brainview_br_settings})
            ui_contextmenu_lab_settings = uimenu(ui_contextmenu_br);
            set(ui_contextmenu_lab_settings,'Label',BRAINVIEW_LAB_SETTINGS)
            set(ui_contextmenu_lab_settings,'Callback',{@cb_brainview_lab_settings})
            bg.br_sphs([],'UIContextMenu',ui_contextmenu_br)
        else
            bg.br_sphs_off()
        end
        
        % brain region labels
        if strcmpi(get(ui_toolbar_label,'State'),'on')
            bg.br_labs_on()
            bg.br_labs()
            
            ui_contextmenu_lab = uicontextmenu();
            ui_contextmenu_brain_settings = uimenu(ui_contextmenu_lab);
            set(ui_contextmenu_brain_settings,'Label',BRAINVIEW_BRAIN_SETTINGS)
            set(ui_contextmenu_brain_settings,'Callback',{@cb_brainview_brain_settings})
            ui_contextmenu_sym_settings = uimenu(ui_contextmenu_lab);
            set(ui_contextmenu_sym_settings,'Label',BRAINVIEW_SYM_SETTINGS)
            set(ui_contextmenu_sym_settings,'Callback',{@cb_brainview_sym_settings})
            ui_contextmenu_br_settings = uimenu(ui_contextmenu_lab);
            set(ui_contextmenu_br_settings,'Label',BRAINVIEW_BR_SETTINGS)
            set(ui_contextmenu_br_settings,'Callback',{@cb_brainview_br_settings})
            ui_contextmenu_lab_settings = uimenu(ui_contextmenu_lab);
            set(ui_contextmenu_lab_settings,'Label',BRAINVIEW_LAB_SETTINGS)
            set(ui_contextmenu_lab_settings,'Callback',{@cb_brainview_lab_settings})
            bg.br_labs([],'UIContextMenu',ui_contextmenu_lab)
        else
            bg.br_labs_off()
        end
        
        % Update light
        bg.update_light()
   
        % axis
        if strcmpi(get(ui_toolbar_axis,'State'),'on')
            bg.axis_on()
        else
            bg.axis_off()
        end
        
        % grid
        if strcmpi(get(ui_toolbar_grid,'State'),'on')
            bg.grid_on()
        else
            bg.grid_off()
        end
    end
    function cb_brainview_brain_settings(~,~)  % (src,event)
        bg.brain_settings('FigName',[APPNAME ' - ' BRAINVIEW_BRAIN_SETTINGS])
    end
    function cb_brainview_sym_settings(~,~)  % (src,event)
        
        i = bg.get_sym_i(gco);
        
        if isfinite(i)
            bg.br_syms_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            bg.br_syms_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_brainview_br_settings(~,~)  % (src,event)
        
        i = bg.get_sph_i(gco);
        
        if isfinite(i)
            bg.br_sphs_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_BR_SETTINGS ' - '])
        else
            bg.br_sphs_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_BR_SETTINGS ' - '])
        end
    end
    function cb_brainview_lab_settings(~,~)  % (src,event)
        
        i = bg.get_lab_i(gco);
        
        if isfinite(i)
            bg.br_labs_settings(i,'FigName',[APPNAME ' - ' BRAINVIEW_LAB_SETTINGS ' - '])
        else
            bg.br_labs_settings([],'FigName',[APPNAME ' - ' BRAINVIEW_LAB_SETTINGS ' - '])
        end
    end
    function cb_brainview_viewgroup(~,~)  % (src,event)
        BRAINVIEW_BUTTON_STATE = BRAINVIEW_BUTTON_VIEWMEAS;
        if ga.getCohort().length()>0
            GUIMRIGraphAnalysisBUTViewMeas(fig_group,ga,bg)
        else
            errordlg('Select a cohort in order to view group measures','Select a cohort','modal');
        end
    end
    function cb_brainview_viewcomparison(~,~)  % (src,event)
        BRAINVIEW_BUTTON_STATE = BRAINVIEW_BUTTON_VIEWCOMP;
        if ga.getCohort().length()>0
            GUIMRIGraphAnalysisBUTViewComp(fig_group,ga,bg)
        else
            errordlg('Select a cohort in order to view group comparisons','Select a cohort','modal');
        end
    end
    function cb_brainview_viewrandom(~,~)  % (src,event)
        BRAINVIEW_BUTTON_STATE = BRAINVIEW_BUTTON_VIEWRAND;
        if ga.getCohort().length()>0
            GUIMRIGraphAnalysisBUTViewRand(fig_group,ga,bg)
        else
            errordlg('Select a cohort in order to view group random comparisons','Select a cohort','modal');
        end
    end
    function cb_brainview_graph(~,~)  % (src,event)
        BRAINVIEW_BUTTON_STATE = BRAINVIEW_BUTTON_GRAPH;
        GUIMRIGraphAnalysisBUTSetGraph(f,ga,bg)
    end

%% Menus
MENU_FILE = GUI.MENU_FILE;
MENU_VIEW = GUI.MENU_VIEW;
MENU_FIGURE = 'Figure';

ui_menu_file = uimenu(f,'Label',MENU_FILE);
ui_menu_file_open = uimenu(ui_menu_file);
ui_menu_file_save = uimenu(ui_menu_file);
ui_menu_file_saveas = uimenu(ui_menu_file);
ui_menu_file_import_xml = uimenu(ui_menu_file);
ui_menu_file_export_xml = uimenu(ui_menu_file);
ui_menu_file_close = uimenu(ui_menu_file);
ui_menu_view = uimenu(f,'Label',MENU_VIEW);
ui_menu_view_matrix = uimenu(ui_menu_view);
ui_menu_view_brainmeasures = uimenu(ui_menu_view);
ui_menu_view_regionmeasures = uimenu(ui_menu_view);
ui_menu_view_brainview = uimenu(ui_menu_view);
ui_menu_figure = uimenu(f,'Label',MENU_FIGURE);
ui_menu_figure_figure = uimenu(ui_menu_figure);
init_menu()
    function init_menu()
        set(ui_menu_file_open,'Label',OPEN_CMD)
        set(ui_menu_file_open,'Accelerator',OPEN_SC)
        set(ui_menu_file_open,'Callback',{@cb_open})
        
        set(ui_menu_file_save,'Separator','on')
        set(ui_menu_file_save,'Label',SAVE_CMD)
        set(ui_menu_file_save,'Accelerator',SAVE_SC)
        set(ui_menu_file_save,'Callback',{@cb_save})
        
        set(ui_menu_file_saveas,'Label',SAVEAS_CMD)
        set(ui_menu_file_saveas,'Callback',{@cb_saveas});
        
        set(ui_menu_file_import_xml,'Separator','on')
        set(ui_menu_file_import_xml,'Label',IMPORT_XML_CMD)
        set(ui_menu_file_import_xml,'Callback',{@cb_import_xml})
        
        set(ui_menu_file_export_xml,'Label',EXPORT_XML_CMD)
        set(ui_menu_file_export_xml,'Callback',{@cb_export_xml})
        
        set(ui_menu_file_close,'Separator','on')
        set(ui_menu_file_close,'Label',CLOSE_CMD)
        set(ui_menu_file_close,'Accelerator',CLOSE_SC);
        set(ui_menu_file_close,'Callback',['GUI.close(''' APPNAME ''',gcf)'])
        
        set(ui_menu_view_matrix,'Label',CONSOLE_MATRIX_CMD)
        set(ui_menu_view_matrix,'Accelerator',CONSOLE_MATRIX_SC)
        set(ui_menu_view_matrix,'Callback',{@cb_console_matrix})
        
        set(ui_menu_view_brainmeasures,'Label',CONSOLE_BRAINMEASURES_CMD)
        set(ui_menu_view_brainmeasures,'Accelerator',CONSOLE_BRAINMEASURES_SC)
        set(ui_menu_view_brainmeasures,'Callback',{@cb_console_brainmeasures})
        
        set(ui_menu_view_regionmeasures,'Label',CONSOLE_REGIONMEASURES_CMD)
        set(ui_menu_view_regionmeasures,'Accelerator',CONSOLE_REGIONMEASURES_SC)
        set(ui_menu_view_regionmeasures,'Callback',{@cb_console_regionmeasures})
        
        set(ui_menu_view_brainview,'Label',CONSOLE_BRAINVIEW_CMD)
        set(ui_menu_view_brainview,'Accelerator',CONSOLE_BRAINVIEW_SC)
        set(ui_menu_view_brainview,'Callback',{@cb_console_brainview})
        
        set(ui_menu_figure_figure,'Label',FIGURE_CMD)
        set(ui_menu_figure_figure,'Accelerator',FIGURE_SC)
        set(ui_menu_figure_figure,'Callback',{@cb_menu_figure})
    end
    function cb_menu_figure(~,~)  % (src,event)
        if strcmpi(get(ui_panel_matrix,'Visible'),'on')
            if get(ui_checkbox_matrix_w,'Value')
                h = figure('Name', ['Correlation matrix - ' ga.getCohort().getGroup(get(ui_popup_matrix_group,'Value')).getProp(Group.NAME)]);
                set(gcf,'color','w')
                copyobj(ui_axes_matrix,h)
                colormap jet
                set(gca,'Units','normalized')
                set(gca,'OuterPosition',[0 0 1 1])
            elseif get(ui_checkbox_matrix_hist,'Value')
                h = figure('Name', ['Histogram - ' ga.getCohort().getGroup(get(ui_popup_matrix_group,'Value')).getProp(Group.NAME)]);
                set(gcf,'color','w')
                copyobj(ui_axes_matrix,h)
                set(gca,'Units','normalized')
                set(gca,'OuterPosition',[0 0 1 1])
            elseif  get(ui_checkbox_matrix_bs,'Value')
                h = figure('Name', ['Binarized correlation matrix - ' ga.getCohort().getGroup(get(ui_popup_matrix_group,'Value')).getProp(Group.NAME) ' - density=' num2str(get(ui_edit_matrix_bs,'String'))]);
                set(gcf,'color','w')
                copyobj(ui_axes_matrix,h)
                colormap bone
                set(gca,'Units','normalized')
                set(gca,'OuterPosition',[0 0 1 1])
            elseif get(ui_checkbox_matrix_bt,'Value')
                h = figure('Name', ['Binarized correlation matrix - ' ga.getCohort().getGroup(get(ui_popup_matrix_group,'Value')).getProp(Group.NAME) ' - threshold=' num2str(get(ui_edit_matrix_bt,'String'))]);
                set(gcf,'color','w')
                copyobj(ui_axes_matrix,h)
                colormap bone
                set(gca,'Units','normalized')
                set(gca,'OuterPosition',[0 0 1 1])
            end
        elseif strcmpi(get(ui_panel_brainmeasures,'Visible'),'on')
            
            mlist = GraphBU.measurelist(false);  % list of non-nodal measures
            
            if get(ui_checkbox_brainmeasures_meas,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_brainmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_brainmeasures_comp_group1,'Value')).getProp(Group.NAME)]);
            elseif get(ui_checkbox_brainmeasures_comp,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_brainmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_brainmeasures_comp_group1,'Value')).getProp(Group.NAME) ' vs. ' ga.getCohort().getGroup(get(ui_popup_brainmeasures_comp_group2,'Value')).getProp(Group.NAME)]);
            elseif get(ui_checkbox_brainmeasures_rand,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_brainmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_brainmeasures_comp_group1,'Value')).getProp(Group.NAME)]);
            end
            set(gcf,'color','w')
            copyobj(ui_axes_brainmeasures,h)
            set(gca,'Units','normalized')
            set(gca,'OuterPosition',[0 0 1 1])
        elseif strcmpi(get(ui_panel_regionmeasures,'Visible'),'on')
            
            mlist = GraphBU.measurelist(true);  % list of nodal measures
            
            if get(ui_checkbox_regionmeasures_meas,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_regionmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_regionmeasures_comp_group1,'Value')).getProp(Group.NAME)]);
            elseif get(ui_checkbox_regionmeasures_comp,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_regionmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_regionmeasures_comp_group1,'Value')).getProp(Group.NAME) ' vs. ' ga.getCohort().getGroup(get(ui_popup_regionmeasures_comp_group2,'Value')).getProp(Group.NAME)]);
            elseif get(ui_checkbox_regionmeasures_rand,'Value')
                h = figure('Name', [Graph.NAME{mlist(get(ui_popup_regionmeasures_comp,'Value'))} ' - ' ga.getCohort().getGroup(get(ui_popup_regionmeasures_comp_group1,'Value')).getProp(Group.NAME)]);
            end
            set(gcf,'color','w')
            copyobj(ui_axes_regionmeasures,h)
            set(gca,'Units','normalized')
            set(gca,'OuterPosition',[0 0 1 1])
        elseif strcmpi(get(ui_panel_brainview,'Visible'),'on')
            
            mlist = GraphBU.measurelist(true);  % list of nodal measures
            
            if strcmp(BRAINVIEW_BUTTON_STATE,BRAINVIEW_BUTTON_GRAPH)
                h = figure('Name', BRAINVIEW_BUTTON_GRAPH);
            elseif strcmp(BRAINVIEW_BUTTON_STATE,BRAINVIEW_BUTTON_VIEWMEAS)
                h = figure('Name', BRAINVIEW_BUTTON_VIEWMEAS);%[BRAINVIEW_BUTTON_VIEWMEAS ' - ' ga.getCohort().getGroup(get(ui_popup_brainview_meas_group,'Value')).getProp(Group.NAME)]);
            elseif strcmp(BRAINVIEW_BUTTON_STATE,BRAINVIEW_BUTTON_VIEWCOMP)
                h = figure('Name', BRAINVIEW_BUTTON_VIEWCOMP);%[BRAINVIEW_BUTTON_VIEWCOMP ' - ' ga.getCohort().getGroup(get(ui_popup_brainview_comp_group1,'Value')).getProp(Group.NAME) ' vs. ' ga.getCohort().getGroup(get(ui_popup_brainview_comp_group2,'Value')).getProp(Group.NAME)]);
            elseif strcmp(BRAINVIEW_BUTTON_STATE,BRAINVIEW_BUTTON_VIEWRAND)
                h = figure('Name', BRAINVIEW_BUTTON_VIEWRAND);%[BRAINVIEW_BUTTON_VIEWRAND ' - ' ga.getCohort().getGroup(get(ui_popup_brainview_comp_group1,'Value')).getProp(Group.NAME)]);
            else
                h = figure('Name', BRAINVIEW_BUTTON_STATE);
            end
            set(gcf,'color','w')
            copyobj(ui_axes_brainview,h)
            set(gca,'Units','normalized')
            set(gca,'OuterPosition',[0 0 1 1])
        end
    end
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,APPNAME);

%% Toolbar
set(f,'Toolbar','figure')
ui_toolbar = findall(f,'Tag','FigureToolBar');
ui_toolbar_open = findall(ui_toolbar,'Tag','Standard.FileOpen');
ui_toolbar_save = findall(ui_toolbar,'Tag','Standard.SaveFigure');
ui_toolbar_zoomin = findall(ui_toolbar,'Tag','Exploration.ZoomIn');
ui_toolbar_zoomout = findall(ui_toolbar,'Tag','Exploration.ZoomOut');
ui_toolbar_pan = findall(ui_toolbar,'Tag','Exploration.Pan');
ui_toolbar_rotate = findall(ui_toolbar,'Tag','Exploration.Rotate');
ui_toolbar_datacursor = findall(ui_toolbar,'Tag','Exploration.DataCursor');
ui_toolbar_insertcolorbar = findall(ui_toolbar,'Tag','Annotation.InsertColorbar');
ui_toolbar_3D = uipushtool(ui_toolbar);
ui_toolbar_SL = uipushtool(ui_toolbar);
ui_toolbar_SR = uipushtool(ui_toolbar);
ui_toolbar_AD = uipushtool(ui_toolbar);
ui_toolbar_AV = uipushtool(ui_toolbar);
ui_toolbar_CA = uipushtool(ui_toolbar);
ui_toolbar_CP = uipushtool(ui_toolbar);
ui_toolbar_brain = uitoggletool(ui_toolbar);
ui_toolbar_axis = uitoggletool(ui_toolbar);
ui_toolbar_grid = uitoggletool(ui_toolbar);
ui_toolbar_sym = uitoggletool(ui_toolbar);
ui_toolbar_br = uitoggletool(ui_toolbar);
ui_toolbar_label = uitoggletool(ui_toolbar);
init_toolbar()
    function init_toolbar()
        % get(findall(ui_toolbar),'Tag')
        delete(findall(ui_toolbar,'Tag','Standard.NewFigure'))
        % delete(findall(ui_toolbar,'Tag','Standard.FileOpen'))
        % delete(findall(ui_toolbar,'Tag','Standard.SaveFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.PrintFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.EditPlot'))
        % delete(findall(ui_toolbar,'Tag','Exploration.ZoomIn'))
        % delete(findall(ui_toolbar,'Tag','Exploration.ZoomOut'))
        % delete(findall(ui_toolbar,'Tag','Exploration.Pan'))
        % delete(findall(ui_toolbar,'Tag','Exploration.Rotate'))
        % delete(findall(ui_toolbar,'Tag','Exploration.DataCursor'))
        delete(findall(ui_toolbar,'Tag','Exploration.Brushing'))
        delete(findall(ui_toolbar,'Tag','DataManager.Linking'))
        % delete(findall(ui_toolbar,'Tag','Annotation.InsertColorbar'))
        delete(findall(ui_toolbar,'Tag','Annotation.InsertLegend'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOff'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOn'))
        
        set(ui_toolbar_open,'TooltipString',OPEN_TP);
        set(ui_toolbar_open,'ClickedCallback',{@cb_open})
        
        set(ui_toolbar_save,'TooltipString',SAVE_TP);
        set(ui_toolbar_save,'ClickedCallback',{@cb_save})
        
        set(ui_toolbar_zoomin,'TooltipString',BRAINVIEW_ZOOMIN_TP);
        
        set(ui_toolbar_zoomout,'TooltipString',BRAINVIEW_ZOOMOUT_TP);
        
        set(ui_toolbar_pan,'TooltipString',BRAINVIEW_PAN_TP);
        
        set(ui_toolbar_rotate,'TooltipString',BRAINVIEW_ROTATE3D_TP);
        
        set(ui_toolbar_datacursor,'TooltipString',BRAINVIEW_DATACURSOR_TP);
        
        set(ui_toolbar_insertcolorbar,'TooltipString',BRAINVIEW_INSERTCOLORBAR_TP);
        
        set(ui_toolbar_3D,'TooltipString',BRAINVIEW_3D_CMD);
        set(ui_toolbar_3D,'CData',imread('icon_view_3d.png'));
        set(ui_toolbar_3D,'Separator','off');
        set(ui_toolbar_3D,'ClickedCallback',{@cb_toolbar_3D})
        function  cb_toolbar_3D(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_3D)
            bg.update_light()
        end
        
        set(ui_toolbar_SL,'TooltipString',BRAINVIEW_SL_CMD);
        set(ui_toolbar_SL,'CData',imread('icon_view_sl.png'));
        set(ui_toolbar_SL,'ClickedCallback',{@cb_toolbar_SL})
        function  cb_toolbar_SL(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_SL)
            bg.update_light()
        end
        
        set(ui_toolbar_SR,'TooltipString',BRAINVIEW_SR_CMD);
        set(ui_toolbar_SR,'CData',imread('icon_view_sr.png'));
        set(ui_toolbar_SR,'ClickedCallback',{@cb_toolbar_SR})
        function  cb_toolbar_SR(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_SR)
            bg.update_light()
        end
        
        set(ui_toolbar_AD,'TooltipString',BRAINVIEW_AD_CMD);
        set(ui_toolbar_AD,'CData',imread('icon_view_ad.png'));
        set(ui_toolbar_AD,'ClickedCallback',{@cb_toolbar_AD})
        function  cb_toolbar_AD(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_AD)
            bg.update_light()
        end
        
        set(ui_toolbar_AV,'TooltipString',BRAINVIEW_AV_CMD);
        set(ui_toolbar_AV,'CData',imread('icon_view_av.png'));
        set(ui_toolbar_AV,'ClickedCallback',{@cb_toolbar_AV})
        function  cb_toolbar_AV(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_AV)
            bg.update_light()
        end
        
        set(ui_toolbar_CA,'TooltipString',BRAINVIEW_CA_CMD);
        set(ui_toolbar_CA,'CData',imread('icon_view_ca.png'));
        set(ui_toolbar_CA,'ClickedCallback',{@cb_toolbar_CA})
        function  cb_toolbar_CA(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_CA)
            bg.update_light()
        end
        
        set(ui_toolbar_CP,'TooltipString',BRAINVIEW_CP_CMD);
        set(ui_toolbar_CP,'CData',imread('icon_view_cp.png'));
        set(ui_toolbar_CP,'ClickedCallback',{@cb_toolbar_CP})
        function  cb_toolbar_CP(~,~)  % (src,event)
            bg.view(PlotBrainSurf.VIEW_CP)
            bg.update_light()
        end
        
        set(ui_toolbar_brain,'TooltipString',BRAINVIEW_BRAIN_CMD);
        set(ui_toolbar_brain,'State','on');
        set(ui_toolbar_brain,'CData',imread('icon_brain.png'));
        set(ui_toolbar_brain,'Separator','off');
        set(ui_toolbar_brain,'OnCallback',{@cb_toolbar_brain})
        set(ui_toolbar_brain,'OffCallback',{@cb_toolbar_brain})
        function cb_toolbar_brain(~,~)  % (src,event)
            update_brainview()
        end
        
        set(ui_toolbar_axis,'TooltipString',BRAINVIEW_AXIS_CMD);
        set(ui_toolbar_axis,'State','on');
        set(ui_toolbar_axis,'CData',imread('icon_axis.png'));
        set(ui_toolbar_axis,'OnCallback',{@cb_toolbar_axis})
        set(ui_toolbar_axis,'OffCallback',{@cb_toolbar_axis})
        function cb_toolbar_axis(~,~)  % (src,event)
            update_brainview()
        end
        
        set(ui_toolbar_grid,'TooltipString',BRAINVIEW_GRID_CMD);
        set(ui_toolbar_grid,'State','on');
        set(ui_toolbar_grid,'CData',imread('icon_grid.png'));
        set(ui_toolbar_grid,'OnCallback',{@cb_toolbar_grid})
        set(ui_toolbar_grid,'OffCallback',{@cb_toolbar_grid})
        function cb_toolbar_grid(~,~)  % (src,event)
            update_brainview()
        end
        
        set(ui_toolbar_sym,'TooltipString',BRAINVIEW_SYMS_CMD);
        set(ui_toolbar_sym,'State','on');
        set(ui_toolbar_sym,'CData',imread('icon_symbol.png'));
        set(ui_toolbar_sym,'OnCallback',{@cb_toolbar_sym})
        set(ui_toolbar_sym,'OffCallback',{@cb_toolbar_sym})
        function cb_toolbar_sym(~,~)  % (src,event)
            update_brainview()
        end
        
        set(ui_toolbar_br,'TooltipString',BRAINVIEW_BR_CMD);
        set(ui_toolbar_br,'State','on');
        set(ui_toolbar_br,'CData',imread('icon_br.png'));
        set(ui_toolbar_br,'OnCallback',{@cb_toolbar_br})
        set(ui_toolbar_br,'OffCallback',{@cb_toolbar_br})
        function cb_toolbar_br(~,~)  % (src,event)
            update_brainview()
        end
        
        set(ui_toolbar_label,'TooltipString',BRAINVIEW_LABELS_CMD);
        set(ui_toolbar_label,'State','off');
        set(ui_toolbar_label,'CData',imread('icon_label.png'));
        set(ui_toolbar_label,'OnCallback',{@cb_toolbar_label})
        set(ui_toolbar_label,'OffCallback',{@cb_toolbar_label})
        function cb_toolbar_label(~,~)  % (src,event)
            update_brainview()
        end
    end

%% Make the GUI visible.
setup()
set(f,'Visible','on');

%% Auxiliary functions

    function setup()
        
        % setup cohort
        update_cohort()
        
        % setup left column
        update_calc_ganame()
        update_calc_table()
        
        % setup main panel
        update_matrix()
        update_console_panel_visibility(CONSOLE_MATRIX_CMD)
        
        % setup brain view
        bg = PlotBrainGraph(ga.getBrainAtlas());
        bg.set_axes(ui_axes_brainview)
        axes(ui_axes_brainview)
        bg.hold_on()
        
        bg.view(PlotBrainSurf.VIEW_3D)
        bg.brain()
        bg.update_light()
        
        bg.br_sphs()
        bg.br_labs()
        bg.axis_equal()
        
        xlabel(ui_axes_brainview,[BRAINVIEW_XLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
        ylabel(ui_axes_brainview,[BRAINVIEW_YLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
        zlabel(ui_axes_brainview,[BRAINVIEW_ZLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
    end

end