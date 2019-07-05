function GUIMRIGraphAnalysis(tmp)
%% MRI Graph Analysis
% GUIMRIGraphAnalysis(ga) opens GUIMRIGraphAnalysis (WU, BUT or BUD)
% GUIMRIGraphAnalysis(cohort) opens cohort
% GUIMRIGraphAnalysis() opens empty analysis with empty cohort

%% General Constants
APPNAME = GUI.MGA_NAME;  % application name
BUILT = BNC.BUILT;

% Dimensions
MARGIN_X = .01;
MARGIN_Y = .01;
LEFTCOLUMN_WIDTH = .19;
COHORT_HEIGHT = .12;
TAB_HEIGHT = .20;
FILENAME_HEIGHT = .02;

MAINPANEL_X0 = LEFTCOLUMN_WIDTH+2*MARGIN_X;
MAINPANEL_Y0 = FILENAME_HEIGHT+TAB_HEIGHT+3*MARGIN_Y;
MAINPANEL_WIDTH = 1-LEFTCOLUMN_WIDTH-3*MARGIN_X;
MAINPANEL_HEIGHT = 1-TAB_HEIGHT-FILENAME_HEIGHT-4*MARGIN_Y;
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

FIGURE_CMD = GUI.FIGURE_CMD;
FIGURE_SC = GUI.FIGURE_SC;
FIGURE_TP = ['Generate figure. Shortcut: ' GUI.ACCELERATOR '+' FIGURE_SC];

%% Application data
if exist('tmp','var') && isa(tmp,'MRIGraphAnalysis')
    ga = tmp;
    cohort = ga.getCohort();
    cs = ga.getStructure();
elseif exist('tmp','var') && isa(tmp,'MRICohort')
    cohort = tmp;
    ga = MRIGraphAnalysisWU(cohort,Structure());
    cs = ga.getStructure();
else
    cohort = MRICohort(BrainAtlas());
    ga = MRIGraphAnalysisWU(cohort,Structure());
    cs = ga.getStructure();
end

ui_popups_grouplists = [];

% Callbacks to manage application data
    function cb_open(~,~)  % (src,event)
        % select file
        [file,path,filterindex] = uigetfile(GUI.MGA_EXTENSION,GUI.MGA_MSG_GETFILE);
        % load file
        if filterindex
            filename = fullfile(path,file);
            temp = load(filename,'-mat','ga','BUILT');
            if isa(temp.ga,'MRIGraphAnalysis')
                ga = temp.ga;
                if isa(ga,'MRIGraphAnalysisWU')
                    GUIMRIGraphAnalysisWU(ga)
                elseif isa(ga,'MRIGraphAnalysisBUT')
                    GUIMRIGraphAnalysisBUT(ga)
                elseif isa(ga,'MRIGraphAnalysisBUD')
                    GUIMRIGraphAnalysisBUD(ga)
                else
                    cohort = ga.getCohort();
                    cs = ga.getStructure();
                    setup()
                    update_filename(filename)
                end
            end
        end
    end
    function cb_save(~,~)  % (src,event)
        filename = get(ui_text_filename,'String');
        if length(filename)>0
            save(filename,'ga','BUILT');
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
            save(filename,'ga','BUILT');
            update_filename(filename)
        end
    end
    function cb_import_xml(~,~)  % (scr,event)
        gatmp = update_calc(MRICohort(BrainAtlas()));
        success = gatmp.loadfromfile(BNC.XML_MSG_GETFILE);
        if success
            ga = gatmp;
            cohort = ga.getCohort();
            cs = ga.getStructure();
            setup()
            update_filename('')
        end
    end
    function cb_export_xml(~,~)  % (scr,event)
        ga.savetofile(BNC.XML_MSG_PUTFILE);
    end
    function update_popups_grouplist()
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
f = GUI.init_figure(APPNAME,.9,.9,'center');
    function init_disable()
        GUI.disable(ui_panel_calc)
        GUI.disable(ui_panel_community)
        GUI.disable(ui_panel_matrix)
    end
    function init_enable()
        GUI.enable(ui_panel_calc)
        GUI.enable(ui_panel_community)
        GUI.enable(ui_panel_matrix)
    end

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
COHORT_X0 = MARGIN_X;
COHORT_Y0 = 1-MARGIN_Y-COHORT_HEIGHT;
COHORT_POSITION = [COHORT_X0 COHORT_Y0 COHORT_WIDTH COHORT_HEIGHT];

COHORT_BUTTON_SELECT_CMD = 'Select Cohort';
COHORT_BUTTON_SELECT_TP = 'Select MRI cohort.';
COHORT_BUTTON_SELECT_MSG = 'Select file (*.mc) from where to load brain atlas';

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
        update_popups_grouplist()
        
        if cohort.length>0
            set(ui_text_cohort_name,'String',cohort.getProp(MRICohort.NAME))
            set(ui_text_cohort_subjectnumber,'String',['subject number = ' int2str(cohort.length())])
            set(ui_text_cohort_groupnumber,'String',['group number = ' int2str(cohort.groupnumber())])
            set(ui_button_cohort,'String',COHORT_BUTTON_VIEW_CMD)
            set(ui_button_cohort,'TooltipString',COHORT_BUTTON_VIEW_TP);
            init_enable()
        else
            set(ui_text_cohort_name,'String','- - -')
            set(ui_text_cohort_subjectnumber,'String','subject number = 0')
            set(ui_text_cohort_groupnumber,'String','group number = 0')
            set(ui_button_cohort,'String',COHORT_BUTTON_SELECT_CMD)
            set(ui_button_cohort,'TooltipString',COHORT_BUTTON_SELECT_TP);
            init_disable()
        end
    end
    function cb_cohort(src,~)  % (src,event)
        if strcmp(get(src,'String'),COHORT_BUTTON_VIEW_CMD)
            GUIMRICohort(ga.getCohort(),true)  % open atlas with restricted permissions
        else
            try
                % select file
                [file,path,filterindex] = uigetfile(GUI.MCE_EXTENSION,GUI.MCE_MSG_GETFILE);
                % load file
                if filterindex
                    filename = fullfile(path,file);
                    temp = load(filename,'-mat','cohort');
                    if isa(temp.cohort,'MRICohort')
                        cohort = temp.cohort;
                        ga = MRIGraphAnalysisWU(cohort,Structure());
                        cs = ga.getStructure();
                        setup()
                    end
                end
            catch
                errordlg('The file is not a valid MRI Cohort file. Please load a valid .mc file');
            end
        end
    end

%% Panel - Calc
CALC_WIDTH = LEFTCOLUMN_WIDTH;
CALC_HEIGHT = MAINPANEL_HEIGHT-COHORT_HEIGHT-MARGIN_Y;
CALC_X0 = MARGIN_X;
CALC_Y0 = FILENAME_HEIGHT+TAB_HEIGHT+3*MARGIN_Y;
CALC_POSITION = [CALC_X0 CALC_Y0 CALC_WIDTH CALC_HEIGHT];

CALC_BUTTON_CMD = 'Start analysis';
CALC_BUTTON_TP = 'Sets the correlation matrix and starts an analysis';
SBG_BUTTON_CMD = 'Subgraph analysis';
SBG_BUTTON_TP = 'Creates a subgraph for analysis';

VIEW_COMM_BUTTON_CMD = 'View';
VIEW_COMM_BUTTON_TP = 'View the community structure defined for a graph';
EDIT_COMM_BUTTON_CMD = 'Edit';
EDIT_COMM_BUTTON_TP = 'Edit the community structure defined for a graph';
DEFAULT_COMM_BUTTON_CMD = 'Default';
DEFAULT_COMM_BUTTON_TP = 'Default/Discard community structure defined for a graph';

ui_panel_calc = uipanel();
ui_edit_calc_ganame = uicontrol(ui_panel_calc,'Style','edit');

ui_popup_calc_corr = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_corr = uicontrol(ui_panel_calc,'Style','text');
ui_popup_calc_graph = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_graph = uicontrol(ui_panel_calc,'Style','text');
ui_popup_calc_neg = uicontrol(ui_panel_calc,'Style','popup','String',{''});
ui_text_calc_neg = uicontrol(ui_panel_calc,'Style','text');
ui_button_calc_set = uicontrol(ui_panel_calc,'Style','pushbutton');
ui_button_calc_sub = uicontrol(ui_panel_calc,'Style','pushbutton');

ui_panel_community = uipanel(ui_panel_calc);
ui_text_community_property = uicontrol(ui_panel_community,'Style','text');
ui_text_community_algorithm = uicontrol(ui_panel_community,'Style','text');
ui_text_community_gamma = uicontrol(ui_panel_community,'Style','text');
ui_text_community_number = uicontrol(ui_panel_community,'Style','text');
ui_button_community_edit = uicontrol(ui_panel_community,'Style','pushbutton');
ui_button_community_default = uicontrol(ui_panel_community,'Style','pushbutton');

init_calc()
    function init_calc()
        GUI.setUnits(ui_panel_calc)
        GUI.setBackgroundColor(ui_panel_calc)
        
        set(ui_panel_calc,'Position',CALC_POSITION)
        set(ui_panel_calc,'BorderType','none')
        
        set(ui_edit_calc_ganame,'Position',[.02 .95 .96 .04])
        set(ui_edit_calc_ganame,'HorizontalAlignment','left')
        set(ui_edit_calc_ganame,'FontWeight','bold')
        set(ui_edit_calc_ganame,'Callback',{@cb_calc_ganame})
                
        set(ui_text_calc_graph,'Position',[.02 .850 .30 .04])
        set(ui_text_calc_graph,'String','Graph')
        set(ui_text_calc_graph,'HorizontalAlignment','left')
        set(ui_text_calc_graph,'FontWeight','bold')
        
        set(ui_popup_calc_graph,'String',MRIGraphAnalysis.GRAPH_OPTIONS)
        set(ui_popup_calc_graph,'Position',[.40 .860 .56 .04])
        set(ui_popup_calc_graph,'TooltipString','Select a graph type');
        set(ui_popup_calc_graph,'Callback',{@cb_calc_graph});
        
        set(ui_text_calc_corr,'Position',[.02 .780 .30 .04])
        set(ui_text_calc_corr,'String','Correlation')
        set(ui_text_calc_corr,'HorizontalAlignment','left')
        set(ui_text_calc_corr,'FontWeight','bold')
        
        set(ui_popup_calc_corr,'String',MRIGraphAnalysis.CORR_OPTIONS)
        set(ui_popup_calc_corr,'Position',[.40 .790 .56 .04])
        set(ui_popup_calc_corr,'TooltipString','Select a matrix correlation');
        set(ui_popup_calc_corr,'Callback',{@cb_calc_corr});
        
        set(ui_text_calc_neg,'Position',[.02 .710 .30 .04])
        set(ui_text_calc_neg,'String','Negative corrs.')
        set(ui_text_calc_neg,'HorizontalAlignment','left')
        set(ui_text_calc_neg,'FontWeight','bold')
        
        set(ui_popup_calc_neg,'String',MRIGraphAnalysis.NEG_OPTIONS)
        set(ui_popup_calc_neg,'Position',[.40 .720 .56 .04])
        set(ui_popup_calc_neg,'TooltipString','Select a negative correlations handling');
        set(ui_popup_calc_neg,'Callback',{@cb_calc_neg});
        
        set(ui_button_calc_set,'Position',[.20 .02 .60 .08])
        set(ui_button_calc_set,'String',CALC_BUTTON_CMD)
        set(ui_button_calc_set,'TooltipString',CALC_BUTTON_TP)
        set(ui_button_calc_set,'Callback',{@cb_calc_set})
        
        set(ui_button_calc_sub,'Position',[.20 .12 .60 .08])
        set(ui_button_calc_sub,'String',SBG_BUTTON_CMD)
        set(ui_button_calc_sub,'TooltipString',SBG_BUTTON_TP)
        set(ui_button_calc_sub,'Callback',{@cb_calc_sub})

        set(ui_panel_community,'Position',[.02 .30 0.96 0.30])
        set(ui_panel_community,'Title','Community structure')
        GUI.setUnits(ui_panel_community)
        GUI.setBackgroundColor(ui_panel_community)
        
        set(ui_text_community_property,'Position',[.05 .75 .95 .20])
        set(ui_text_community_property,'HorizontalAlignment','left')
        
        set(ui_text_community_algorithm,'Position',[.05 .65 .60 .10])
        set(ui_text_community_algorithm,'HorizontalAlignment','left')
        
        set(ui_text_community_gamma,'Position',[.05 .5 .60 .10])
        set(ui_text_community_gamma,'HorizontalAlignment','left')
        
        set(ui_text_community_number,'Position',[.05 .35 .60 .10])
        set(ui_text_community_number,'HorizontalAlignment','left')
        
        set(ui_button_community_edit,'Position',[.05 .10 .40 .20])
        set(ui_button_community_edit,'Callback',{@cb_comm_edit})
        set(ui_button_community_edit,'String',EDIT_COMM_BUTTON_CMD)
        set(ui_button_community_edit,'TooltipString',EDIT_COMM_BUTTON_TP)
        
        set(ui_button_community_default,'Position',[.55 .10 .40 .20])
        set(ui_button_community_default,'Callback',{@cb_comm_default})
        set(ui_button_community_default,'String',DEFAULT_COMM_BUTTON_CMD)
        set(ui_button_community_default,'TooltipString',DEFAULT_COMM_BUTTON_TP)
    end
    function update_calc_ganame()
        ganame = ga.getProp(MRICohort.NAME);
        if isempty(ganame)
            set(f,'Name',[GUI.MGA_NAME ' - ' BNC.VERSION])
        else
            set(f,'Name',[GUI.MGA_NAME ' - ' BNC.VERSION ' - ' ganame])
        end
        set(ui_edit_calc_ganame,'String',ganame)
    end
    function update_calc()
        graph = get(ui_popup_calc_graph,'Value');
        corr = get(ui_popup_calc_corr,'Value');
        neg = get(ui_popup_calc_neg,'Value');
        switch graph
            case 1  % weighted undirected
                ga = MRIGraphAnalysisWU(cohort,cs, ...
                    MRIGraphAnalysis.CORR, MRIGraphAnalysis.CORR_OPTIONS{corr}, ...
                    MRIGraphAnalysis.NEG, MRIGraphAnalysis.NEG_OPTIONS{neg} ...
                    );
            case 2  % binary undirected (fix threshold)
                ga = MRIGraphAnalysisBUT(cohort,cs, ...
                    MRIGraphAnalysis.CORR, MRIGraphAnalysis.CORR_OPTIONS{corr}, ...
                    MRIGraphAnalysis.NEG, MRIGraphAnalysis.NEG_OPTIONS{neg} ...
                    );
            otherwise  % binary undirected (fix density)
                ga = MRIGraphAnalysisBUD(cohort,cs, ...
                    MRIGraphAnalysis.CORR, MRIGraphAnalysis.CORR_OPTIONS{corr}, ...
                    MRIGraphAnalysis.NEG, MRIGraphAnalysis.NEG_OPTIONS{neg} ...
                    );
        end
    end
    function cb_calc_ganame(~,~)  % (src,event)
        ga.setProp(MRIGraphAnalysis.NAME,get(ui_edit_calc_ganame,'String'));
        update_calc_ganame()
    end
    function cb_calc_graph(~,~)  %  (src,event)
        update_calc()
        update_tab()
        update_matrix()
    end
    function cb_calc_corr(~,~)  %  (src,event)
        update_calc()
        update_tab()
        update_matrix()
    end
    function cb_calc_neg(~,~)  %  (src,event)
        update_calc()
        update_tab()
        update_matrix()
    end
    function cb_comm_edit(src,~)  % (src,event)
        if ~isempty(cohort.getProps(MRISubject.DATA))

            fig_structure = GUIMRIGraphAnalysisStructure(fig_structure,ga);
            waitfor(fig_structure);

            update_community_info()
        else
            errordlg('Select a non-empty cohort in order to define community structure',...
                'Select a cohort','modal');
        end
    end
    function cb_comm_default(~,~)  % (src,event)

            cs.setCi(ones(1,cohort.getBrainAtlas.length()))
            cs.setAlgorithm(Structure.ALGORITHM_LOUVAIN)
            cs.setGamma(1)
            cs.setNotes('dynamic community structure')
            
            update_community_info()
            update_matrix()
    end
    function cb_calc_set(~,~)  % (src,event)
        if ga.getCohort().groupnumber()>0
            if isa(ga,'MRIGraphAnalysisWU')
                GUIMRIGraphAnalysisWU(copy(ga))
            elseif isa(ga,'MRIGraphAnalysisBUT')
                GUIMRIGraphAnalysisBUT(copy(ga))
            elseif isa(ga,'MRIGraphAnalysisBUD')
                GUIMRIGraphAnalysisBUD(copy(ga))
            end
        end
    end
    function cb_calc_sub(~,~)  % (src,event)
        if ~isempty(cohort.getProps(MRISubject.DATA))

            fig_structure = GUIMRIGraphAnalysisSubgraph(fig_structure,ga);
            waitfor(fig_structure);

        else
            errordlg('Select a non-empty cohort in order to define a subgraph',...
                'Select a cohort','modal');
        end
    end
    function update_community_info()
        set(ui_text_community_property,'String',['structure = ' cs.getNotes()])
        set(ui_text_community_algorithm,'String',['algorithm = ' cs.getAlgorithm()])
        set(ui_text_community_gamma,'String',['gamma = ' num2str(cs.getGamma())])
        set(ui_text_community_number,'String',['community number = ' int2str(numel(unique(cs.getCi)))])
    end

%% Panel - Measure Table
TAB_NAME_COL = 1;
TAB_NODAL_COL = 2;
TAB_NODAL_NO = 'Global';
TAB_NODAL_YES = 'Nodal';
TAB_TXT_COL = 3;

TAB_WIDTH = 1-2*MARGIN_X;
TAB_X0 = MARGIN_X;
TAB_Y0 = 2*MARGIN_Y+FILENAME_HEIGHT;
TAB_POSITION = [TAB_X0 TAB_Y0 TAB_WIDTH TAB_HEIGHT];

ui_table_calc = uitable(f);
set(ui_table_calc,'BackgroundColor',GUI.TABBKGCOLOR)
set(ui_table_calc,'Units','normalized')
set(ui_table_calc,'Position',TAB_POSITION)
set(ui_table_calc,'ColumnName',{'   Brain Measure   ',' global/nodal ','   notes   '})
set(ui_table_calc,'ColumnFormat',{'char',{TAB_NODAL_NO TAB_NODAL_YES},'char'})
set(ui_table_calc,'ColumnEditable',[false false false])
set(ui_table_calc,'ColumnWidth',{GUI.width(f,.15*TAB_WIDTH), GUI.width(f,.15*TAB_WIDTH), GUI.width(f,.70*TAB_WIDTH)})
    function update_tab()
        
        update_popups_grouplist()
        
        mlist = measurelist();
        
        data = cell(length(mlist),3);
        for mi = 1:1:length(mlist)
            data{mi,TAB_NAME_COL} = Graph.NAME{mlist(mi)};
            if Graph.isnodal(mlist(mi))
                data{mi,TAB_NODAL_COL} = TAB_NODAL_YES;
            else
                data{mi,TAB_NODAL_COL} = TAB_NODAL_NO;
            end
            data{mi,TAB_TXT_COL} = Graph.TXT{mlist(mi)};
        end
        set(ui_table_calc,'Data',data)
    end
    function mlist = measurelist()
        switch get(ui_popup_calc_graph,'Value')
            case 1  % weighted undirected
                mlist = GraphWU.measurelist();
            case 2  % binary undirected (fix threshold)
                mlist = GraphBU.measurelist();
            case 3  % binary undirected (fix density)
                mlist = GraphBU.measurelist();
        end
    end

%% Panel - Matrix
CONSOLE_MATRIX_CMD = 'Correlation Matrix';

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
        
        set(ui_checkbox_matrix_rearrange,'Position',[.70 .50 .28 .05])
        set(ui_checkbox_matrix_rearrange,'String','rearrange to reflect community structure')
        set(ui_checkbox_matrix_rearrange,'Value',false)
        set(ui_checkbox_matrix_rearrange,'TooltipString','Rearrange the matrix to reflect communities')
        set(ui_checkbox_matrix_rearrange,'FontWeight','normal')
        set(ui_checkbox_matrix_rearrange,'enable','on')
        set(ui_checkbox_matrix_rearrange,'Callback',{@cb_matrix_rearrange})
        
        set(ui_checkbox_matrix_divide,'Position',[.70 .455 .28 .05])
        set(ui_checkbox_matrix_divide,'String','divide communities')
        set(ui_checkbox_matrix_divide,'Value',false)
        set(ui_checkbox_matrix_divide,'TooltipString','Draw lines to divide communities')
        set(ui_checkbox_matrix_divide,'FontWeight','normal')
        set(ui_checkbox_matrix_divide,'enable','off')
        set(ui_checkbox_matrix_divide,'Callback',{@cb_matrix_divide})
        
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
    end
    function S = update_rearrange()
        group = get(ui_popup_matrix_group,'value');
        
        if isa(ga,'MRIGraphAnalysisWU')
            graph = GraphWU(ga.getA(group),'structure',cs);
        elseif isa(ga,'MRIGraphAnalysisBUT')
            graph = GraphBU(ga.getA(group),'structure',cs,'threshold',str2num(get(ui_edit_matrix_bt,'String')));
        elseif isa(ga,'MRIGraphAnalysisBUD')
            graph = GraphBU(ga.getA(group),'structure',cs,'density',str2num(get(ui_edit_matrix_bs,'String')));
        end
        
        [S,~] = graph.structure();
    end
    function update_matrix()
        update_popups_grouplist()
        br_regions = ga.getBrainAtlas().getProps(BrainRegion.LABEL);
        
        if ga.getCohort().groupnumber()>0
            g = get(ui_popup_matrix_group,'value');  % selected group
            
            cla(ui_axes_matrix)
            axes(ui_axes_matrix)
            if get(ui_checkbox_matrix_w,'Value')
                
                if get(ui_checkbox_matrix_rearrange,'Value')
                    
                    if isequal(cs.getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = cs.getCi();
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
                    
                    if isequal(cs.getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = cs.getCi();
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
                    
                   if isequal(cs.getNotes(),'dynamic community structure')
                        S = update_rearrange();
                    else
                        S = cs.getCi();
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
    function cb_matrix_edit_bs(~,~)  % (src,event)
        update_matrix();
    end
    function cb_matrix_slider_bs(src,~)  % (src,event)
        set(ui_edit_matrix_bs,'String',get(src,'Value'))
        update_matrix();
    end
    function cb_matrix_edit_bt(~,~)  % (src,event)(src,event)
        update_matrix();
    end
    function cb_matrix_slider_bt(src,~)  % (src,event)
        set(ui_edit_matrix_bt,'String',get(src,'Value'))
        update_matrix();
    end

%% Menus
MENU_FILE = GUI.MENU_FILE;
MENU_FIGURE = 'Figure';

ui_menu_file = uimenu(f,'Label',MENU_FILE);
ui_menu_file_open = uimenu(ui_menu_file);
ui_menu_file_save = uimenu(ui_menu_file);
ui_menu_file_saveas = uimenu(ui_menu_file);
ui_menu_file_import_xml = uimenu(ui_menu_file);
ui_menu_file_export_xml = uimenu(ui_menu_file);
ui_menu_file_close = uimenu(ui_menu_file);
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
        end
    end
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,APPNAME);

%% Toolbar
set(f,'Toolbar','figure')
ui_toolbar = findall(f,'Tag','FigureToolBar');
ui_toolbar_open = findall(ui_toolbar,'Tag','Standard.FileOpen');
ui_toolbar_save = findall(ui_toolbar,'Tag','Standard.SaveFigure');
init_toolbar()
    function init_toolbar()
        delete(findall(ui_toolbar,'Tag','Standard.NewFigure'))
        % delete(findall(ui_toolbar,'Tag','Standard.FileOpen'))
        % delete(findall(ui_toolbar,'Tag','Standard.SaveFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.PrintFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.EditPlot'))
        %delete(findall(ui_toolbar,'Tag','Exploration.ZoomIn'))
        %delete(findall(ui_toolbar,'Tag','Exploration.ZoomOut'))
        %delete(findall(ui_toolbar,'Tag','Exploration.Pan'))
        delete(findall(ui_toolbar,'Tag','Exploration.Rotate'))
        %delete(findall(ui_toolbar,'Tag','Exploration.DataCursor'))
        delete(findall(ui_toolbar,'Tag','Exploration.Brushing'))
        delete(findall(ui_toolbar,'Tag','DataManager.Linking'))
        %delete(findall(ui_toolbar,'Tag','Annotation.InsertColorbar'))
        delete(findall(ui_toolbar,'Tag','Annotation.InsertLegend'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOff'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOn'))
        
        set(ui_toolbar_open,'TooltipString',OPEN_TP);
        set(ui_toolbar_open,'ClickedCallback',{@cb_open})
        set(ui_toolbar_save,'TooltipString',SAVE_TP);
        set(ui_toolbar_save,'ClickedCallback',{@cb_save})
    end

%% Make the GUI visible.
setup()
set(f,'Visible','on');

%% Auxiliary functions
    function setup()
        
        % setup cohort
        update_cohort()
        
        % setup community panel
        update_community_info()
        
        % setup graph analysis
        update_calc()
        update_tab()
        update_matrix()
        
        % setup data
        update_calc_ganame()
    end

end