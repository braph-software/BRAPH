function GUIEEGCohort(tmp,restricted)
%% EEG Cohort Editor
% GUICohort(cohort,true) opens cohort with only reading and basic writing permissions
% GUICohort(cohort) opens cohort - equivalent to GUIBrainAtlas(cohort,false)
% GUICohort(atlas) opens empty cohort (the BrainAtlas is set to atlas)
% GUICohort() opens empty cohort with empty atlas

%% General Constants
APPNAME = GUI.ECE_NAME;  % application name
BUILT = BNC.BUILT;

% Dimensions
MARGIN_X = .01;
MARGIN_Y = .01;
LEFTCOLUMN_WIDTH = .29;
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
OPEN_TP = ['Open EEG cohort. Shortcut: ' GUI.ACCELERATOR '+' OPEN_SC];

SAVE_CMD = GUI.SAVE_CMD;
SAVE_SC = GUI.SAVE_SC;
SAVE_TP = ['Save current EEG cohort. Shortcut: ' GUI.ACCELERATOR '+' SAVE_SC];

SAVEAS_CMD = GUI.SAVEAS_CMD;
SAVEAS_TP = 'Open dialog box to save current EEG cohort';

IMPORT_XML_CMD = GUI.IMPORT_XML_CMD;
IMPORT_XML_TP = 'Import EEG cohort from an xml file (*.xml)';

EXPORT_XML_CMD = GUI.EXPORT_XML_CMD;
EXPORT_XML_TP = 'Export EEG cohort as an xml file (*.xml)';

CLOSE_CMD = GUI.CLOSE_CMD;
CLOSE_SC = GUI.CLOSE_SC;
CLOSE_TP = ['Close ' APPNAME '. Shortcut: ' GUI.ACCELERATOR '+' CLOSE_SC];

ADD_GR_CMD = GUI.ADD_CMD;
ADD_GR_TP = ['Add group at the end of table'];

REMOVE_GR_CMD = GUI.REMOVE_CMD;
REMOVE_GR_TP = ['Remove selected group'];

MOVEUP_GR_CMD = GUI.MOVEUP_CMD;
MOVEUP_GR_TP = ['Move selected group up'];

MOVEDOWN_GR_CMD = GUI.MOVEDOWN_CMD;
MOVEDOWN_GR_TP = ['Move selected group down'];

SELECTALL_SUB_CMD = 'Select all';
SELECTALL_SUB_TP = 'Select all subjects';

CLEARSELECTION_SUB_CMD = 'Clear selection';
CLEARSELECTION_SUB_TP = 'Clear subject selection';

ADD_SUB_CMD = 'Add subject';
ADD_SUBJECTS_TP = 'Add subject at the end of table';

ADDABOVE_SUB_CMD = 'Add above';
ADDABOVE_SUB_TP = 'Add subjects above selected ones';

ADDBELOW_SUB_CMD = 'Add below';
ADDBELOW_SUB_TP = 'Add subjects below selected ones';

REMOVE_SUB_CMD = 'Remove';
REMOVE_SUB_TP = 'Remove selected subjects';

MOVEUP_SUB_CMD = 'Move up';
MOVEUP_SUB_TP = 'Move selected subjects up';

MOVEDOWN_SUB_CMD = 'Move down';
MOVEDOWN_SUB_TP = 'Move selected subjects down';

MOVE2TOP_SUB_CMD = 'Move to top';
MOVE2TOP_SUB_TP = 'Move selected subjects to top of table';

MOVE2BOTTOM_SUB_CMD = 'Move to bottom';
MOVE2BOTTOM_SUB_TP = 'Move selected subjects to bottom of table';

EEGGRAPHANALYSIS_CMD = 'New EEG graph analysis ...';
EEGGRAPHANALYSIS_TP = ['Generate new EEG graph analysis and opens it with ' GUI.EGA_NAME];

%% Application data
if exist('tmp','var') && isa(tmp,'EEGCohort')
    cohort = tmp;
elseif exist('tmp','var') && isa(tmp,'BrainAtlas')
    cohort = EEGCohort(tmp);
else
    cohort = EEGCohort(BrainAtlas());
end
selected_group = [];
selected_subjects = [];

% Callbacks to manage application data
    function cb_open(~,~)  % (src,event)
        % select file
        [file,path,filterindex] = uigetfile(GUI.ECE_EXTENSION,GUI.ECE_MSG_GETFILE);
        % load file
        if filterindex
            filename = fullfile(path,file);
            temp = load(filename,'-mat','cohort','selected_group','selected_subjects','BUILT');
            if isa(temp.cohort,'EEGCohort')
                cohort = temp.cohort;
                selected_group = temp.selected_group;
                selected_subjects = temp.selected_subjects;
                setup()
                update_filename(filename)
                update_group_popups()
            end
        end
    end
    function cb_save(~,~)  % (src,event)
        filename = get(ui_text_filename,'String');
        if isempty(filename)
            cb_saveas();
        else
            save(filename,'cohort','selected_group','selected_subjects','BUILT');
        end
    end
    function cb_saveas(~,~)  % (src,event)
        % select file
        [file,path,filterindex] = uiputfile(GUI.ECE_EXTENSION,GUI.ECE_MSG_PUTFILE);
        % save file
        if filterindex
            filename = fullfile(path,file);
            save(filename,'cohort','selected_group','selected_subjects','BUILT');
            update_filename(filename)
        end
    end
    function cb_import_xml(~,~)  % (scr,event)
        cohorttmp = EEGCohort(BrainAtlas());
        success = cohorttmp.loadfromfile(BNC.XML_MSG_GETFILE);
        if success
            cohort = cohorttmp;
            selected_group = [];
            selected_subjects = [];
            setup()
            update_filename('')
            update_group_popups()
        end
    end
    function cb_export_xml(~,~)  % (scr,event)
        cohort.savetofile(BNC.XML_MSG_PUTFILE);
    end

%% GUI inizialization
f = GUI.init_figure(APPNAME,.8,.9,'southeast');
    function init_disable()
        GUI.disable(ui_panel_grtab)
        GUI.disable(ui_panel_console)
        GUI.disable(ui_panel_groups)
        set(ui_menu_groups,'enable','off')
        set(ui_menu_subjects,'enable','off')
        set(ui_menu_view,'enable','off')
        set(ui_menu_analysis,'enable','off')
    end
    function init_enable()
        GUI.enable(ui_panel_grtab)
        GUI.enable(ui_panel_console)
        GUI.enable(ui_panel_groups)
        set(ui_menu_groups,'enable','on')
        set(ui_menu_subjects,'enable','on')
        set(ui_menu_view,'enable','on')
        set(ui_menu_analysis,'enable','on')
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

%% Panel Atlas
ATLAS_NAME = 'Brain Atlas';
ATLAS_WIDTH = LEFTCOLUMN_WIDTH;
ATLAS_HEIGHT = HEADING_HEIGHT;
ATLAS_X0 = MARGIN_X;
ATLAS_Y0 = 1-MARGIN_Y-ATLAS_HEIGHT;
ATLAS_POSITION = [ATLAS_X0 ATLAS_Y0 ATLAS_WIDTH ATLAS_HEIGHT];

ATLAS_BUTTON_SELECT_CMD = 'Select Atlas';
ATLAS_BUTTON_SELECT_TP = 'Select brain atlas';
ATLAS_BUTTON_SELECT_MSG = 'Select file (*.atlas) from where to load brain atlas.';

ATLAS_BUTTON_VIEW_CMD = 'View Atlas';
ATLAS_BUTTON_VIEW_TP = ['Open brain atlas with ' GUI.BAE_NAME];

ui_panel_atlas = uipanel();
ui_text_atlas_name = uicontrol(ui_panel_atlas,'Style','text');
ui_text_atlas_brnumber = uicontrol(ui_panel_atlas,'Style','text');
ui_button_atlas = uicontrol(ui_panel_atlas,'Style','pushbutton');
init_atlas()
    function init_atlas()
        GUI.setUnits(ui_panel_atlas)
        GUI.setBackgroundColor(ui_panel_atlas)
        
        set(ui_panel_atlas,'Position',ATLAS_POSITION)
        set(ui_panel_atlas,'Title',ATLAS_NAME)
        
        set(ui_text_atlas_name,'Position',[.05 .50 .50 .20])
        set(ui_text_atlas_name,'HorizontalAlignment','left')
        set(ui_text_atlas_name,'FontWeight','bold')
        
        set(ui_text_atlas_brnumber,'Position',[.05 .30 .50 .20])
        set(ui_text_atlas_brnumber,'HorizontalAlignment','left')
        
        set(ui_button_atlas,'Position',[.55 .30 .40 .40])
        set(ui_button_atlas,'Callback',{@cb_atlas})
    end
    function update_atlas()
        if cohort.getBrainAtlas().length>0
            set(ui_text_atlas_name,'String',cohort.getBrainAtlas().getProp(EEGCohort.NAME))
            set(ui_text_atlas_brnumber,'String',['brain region number = ' int2str(cohort.getBrainAtlas().length())])
            set(ui_button_atlas,'String',ATLAS_BUTTON_VIEW_CMD)
            set(ui_button_atlas,'TooltipString',ATLAS_BUTTON_VIEW_TP);
            init_enable()
        else
            set(ui_text_atlas_name,'String','- - -')
            set(ui_text_atlas_brnumber,'String','brain region number = 0')
            set(ui_button_atlas,'String',ATLAS_BUTTON_SELECT_CMD)
            set(ui_button_atlas,'TooltipString',ATLAS_BUTTON_SELECT_TP);
            init_disable()
        end
    end
    function cb_atlas(src,~)  % (src,event)
        if strcmp(get(src,'String'),ATLAS_BUTTON_VIEW_CMD)
            GUIBrainAtlas(cohort.getBrainAtlas(),true)  % open atlas with restricted permissions
        else  % clears also the cohort
            % select file
            [file,path,filterindex] = uigetfile(GUI.BAE_EXTENSION,GUI.BAE_MSG_GETFILE);
            % load file
            if filterindex
                filename = fullfile(path,file);
                temp = load(filename,'-mat','atlas');
                if isa(temp.atlas,'BrainAtlas')
                    atlas = temp.atlas;
                    cohort = EEGCohort(atlas);
                    setup()
                end
            end
        end
    end

%% Panel Group Table
GRTAB_SELECTED_COL = 1;
GRTAB_NAME_COL = 2;
GRTAB_SUBN_COL = 3;
GRTAB_NOTES_COL = 4;

GRTAB_WIDTH = LEFTCOLUMN_WIDTH;
GRTAB_HEIGHT = MAINPANEL_HEIGHT;
GRTAB_X0 = MARGIN_X;
GRTAB_Y0 = FILENAME_HEIGHT+2*MARGIN_Y;
GRTAB_POSITION = [GRTAB_X0 GRTAB_Y0 GRTAB_WIDTH GRTAB_HEIGHT];

GRTAB_RT_CMD = 'Repetition time (s)';
GRTAB_RT_TP = 'Repetition time of EEG in seconds';

GRTAB_LOAD_XLS_CMD = 'Load subject group from xls ...';
GRTAB_LOAD_XLS_TP = 'Load subjects from XLS file. All subjects will be in the same (new) group';

GRTAB_LOAD_MAT_CMD = 'Load subject group from mat ...';
GRTAB_LOAD_MAT_TP = 'Load subjects from MAT file. All subjects will be in the same (new) group';

GRTAB_LOAD_XML_CMD = 'Load subject group from xml ...';
GRTAB_LOAD_XML_TP = 'Load subjects from another EEG cohort XML file. All subjects will be in the same (new) group';

GRTAB_INVERT_CMD = 'Invert';
GRTAB_INVERT_TP = 'Invert group';

GRTAB_MERGE_CMD = 'Merge';
GRTAB_MERGE_TP = 'Merge two groups';

GRTAB_INTERSECT_CMD = 'Intersect';
GRTAB_INTERSECT_TP = 'Intersect two groups';

ui_panel_grtab = uipanel();
ui_edit_grtab_cohortname = uicontrol(ui_panel_grtab,'Style','edit');
ui_edit_repetition_time = uicontrol(ui_panel_grtab,'Style', 'edit');
ui_text_repetition_time = uicontrol(ui_panel_grtab,'Style', 'text');
ui_button_grtab_load_xls = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_button_grtab_load_mat = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_button_grtab_load_xml = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_table_grtab = uitable(ui_panel_grtab);
ui_button_grtab_add_gr = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_button_grtab_remove_gr = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_button_grtab_moveup_gr = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_button_grtab_movedown_gr = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_popup_grtab_invert = uicontrol(ui_panel_grtab,'Style','popup','String',{''});
ui_button_grtab_invert = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_popup_grtab_merge1 = uicontrol(ui_panel_grtab,'Style','popup','String',{''});
ui_popup_grtab_merge2 = uicontrol(ui_panel_grtab,'Style','popup','String',{''});
ui_button_grtab_merge = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
ui_popup_grtab_intersect1 = uicontrol(ui_panel_grtab,'Style','popup','String',{''});
ui_popup_grtab_intersect2 = uicontrol(ui_panel_grtab,'Style','popup','String',{''});
ui_button_grtab_intersect = uicontrol(ui_panel_grtab,'Style', 'pushbutton');
init_grtab()
    function init_grtab()
        GUI.setUnits(ui_panel_grtab)
        GUI.setBackgroundColor(ui_panel_grtab)
        
        set(ui_panel_grtab,'Position',GRTAB_POSITION)
        set(ui_panel_grtab,'BorderType','none')
        
        set(ui_edit_grtab_cohortname,'Position',[.02 .95 .96 .04])
        set(ui_edit_grtab_cohortname,'HorizontalAlignment','left')
        set(ui_edit_grtab_cohortname,'FontWeight','bold')
        set(ui_edit_grtab_cohortname,'Callback',{@cb_grtab_cohortname})
        
        set(ui_text_repetition_time,'Position',[.02 .91 .36 .02])
        set(ui_text_repetition_time,'String',GRTAB_RT_CMD)
        set(ui_text_repetition_time,'FontWeight','bold')
        set(ui_text_repetition_time,'HorizontalAlignment','right')
        set(ui_text_repetition_time,'TooltipString',GRTAB_RT_TP)

        set(ui_edit_repetition_time,'Position',[0.4 0.90 .15 .04])
        set(ui_edit_repetition_time,'String','1')
        set(ui_edit_repetition_time,'TooltipString',GRTAB_RT_TP)
        set(ui_edit_repetition_time,'Callback',{@cb_edit_time})
        
        set(ui_button_grtab_load_xls,'Position',[.02 .85 .96 .035])
        set(ui_button_grtab_load_xls,'String',GRTAB_LOAD_XLS_CMD)
        set(ui_button_grtab_load_xls,'TooltipString',GRTAB_LOAD_XLS_TP)
        set(ui_button_grtab_load_xls,'Callback',{@cb_grtab_load_xls})
        
        set(ui_button_grtab_load_mat,'Position',[.02 .81 0.96 .035])
        set(ui_button_grtab_load_mat,'String',GRTAB_LOAD_MAT_CMD)
        set(ui_button_grtab_load_mat,'TooltipString',GRTAB_LOAD_MAT_TP)
        set(ui_button_grtab_load_mat,'Callback',{@cb_grtab_load_mat})
        
        set(ui_button_grtab_load_xml,'Position',[.02 .77 .96 .035])
        set(ui_button_grtab_load_xml,'String',GRTAB_LOAD_XML_CMD)
        set(ui_button_grtab_load_xml,'TooltipString',GRTAB_LOAD_XML_TP)
        set(ui_button_grtab_load_xml,'Callback',{@cb_grtab_load_xml})
        
        set(ui_table_grtab,'Position',[.02 .21 .96 .55])
        set(ui_table_grtab,'ColumnName',{'',' Group Name ',' Number of Subjects ',' Group Notes '})
        set(ui_table_grtab,'ColumnFormat',{'logical','char','numeric','char'})
        set(ui_table_grtab,'ColumnEditable',[true true false true])
        set(ui_table_grtab,'CellEditCallback',{@cb_grtab_edit_gr});
        
        set(ui_button_grtab_add_gr,'Position',[.02 .16 .21 .03])
        set(ui_button_grtab_add_gr,'String',ADD_GR_CMD)
        set(ui_button_grtab_add_gr,'TooltipString',ADD_GR_TP);
        set(ui_button_grtab_add_gr,'Callback',{@cb_grtab_add_gr})
        
        set(ui_button_grtab_remove_gr,'Position',[.27 .16 .21 .03])
        set(ui_button_grtab_remove_gr,'String',REMOVE_GR_CMD)
        set(ui_button_grtab_remove_gr,'TooltipString',REMOVE_GR_TP);
        set(ui_button_grtab_remove_gr,'Callback',{@cb_grtab_remove_gr})
        
        set(ui_button_grtab_moveup_gr,'Position',[.52 .16 .21 .03])
        set(ui_button_grtab_moveup_gr,'String',MOVEUP_GR_CMD)
        set(ui_button_grtab_moveup_gr,'TooltipString',MOVEUP_GR_TP);
        set(ui_button_grtab_moveup_gr,'Callback',{@cb_grtab_moveup_gr})
        
        set(ui_button_grtab_movedown_gr,'Position',[.77 .16 .21 .03])
        set(ui_button_grtab_movedown_gr,'String',MOVEDOWN_GR_CMD)
        set(ui_button_grtab_movedown_gr,'TooltipString',MOVEDOWN_GR_TP);
        set(ui_button_grtab_movedown_gr,'Callback',{@cb_grtab_movedown_gr})
        
        set(ui_popup_grtab_invert,'Position',[.39 .10 .35 .03])
        set(ui_popup_grtab_invert,'TooltipString','Select group.');
        
        set(ui_button_grtab_invert,'Position',[.77 .10 .21 .03])
        set(ui_button_grtab_invert,'String',GRTAB_INVERT_CMD)
        set(ui_button_grtab_invert,'TooltipString',GRTAB_INVERT_TP)
        set(ui_button_grtab_invert,'Callback',{@cb_grtab_invert})
        
        set(ui_popup_grtab_merge1,'Position',[.02 .06 .35 .03])
        set(ui_popup_grtab_merge1,'TooltipString','Select group.');
        
        set(ui_popup_grtab_merge2,'Position',[.39 .06 .35 .03])
        set(ui_popup_grtab_merge2,'TooltipString','Select group.');
        
        set(ui_button_grtab_merge,'Position',[.77 .06 .21 .03])
        set(ui_button_grtab_merge,'String',GRTAB_MERGE_CMD)
        set(ui_button_grtab_merge,'TooltipString',GRTAB_MERGE_TP)
        set(ui_button_grtab_merge,'Callback',{@cb_grtab_merge})
        
        set(ui_popup_grtab_intersect1,'Position',[.02 .02 .35 .03])
        set(ui_popup_grtab_intersect1,'TooltipString','Select group.');
        
        set(ui_popup_grtab_intersect2,'Position',[.39 .02 .35 .03])
        set(ui_popup_grtab_intersect2,'TooltipString','Select group.');
        
        set(ui_button_grtab_intersect,'Position',[.77 .02 .21 .03])
        set(ui_button_grtab_intersect,'String',GRTAB_INTERSECT_CMD)
        set(ui_button_grtab_intersect,'TooltipString',GRTAB_INTERSECT_TP)
        set(ui_button_grtab_intersect,'Callback',{@cb_grtab_intersect})
    end
    function update_grtab_cohortname()
        cohortname = cohort.getProp(EEGCohort.NAME);
        if isempty(cohortname)
            set(f,'Name',[GUI.ECE_NAME ' - ' BNC.VERSION])
        else
            set(f,'Name',[GUI.ECE_NAME ' - ' BNC.VERSION ' - ' cohortname])
        end
        set(ui_edit_grtab_cohortname,'String',cohortname)
    end
    function update_grtab_table()
        data = cell(cohort.groupnumber(),4);
        for g = 1:1:cohort.groupnumber()
            if any(selected_group==g)
                data{g,GRTAB_SELECTED_COL} = true;
            else
                data{g,GRTAB_SELECTED_COL} = false;
            end
            data{g,GRTAB_NAME_COL} = cohort.getGroup(g).getProp(Group.NAME);
            data{g,GRTAB_SUBN_COL} = length(find(cohort.getGroup(g).getProp(Group.DATA)==true));
            data{g,GRTAB_NOTES_COL} = cohort.getGroup(g).getProp(Group.NOTES);
        end
        set(ui_table_grtab,'Data',data)
    end
    function cb_grtab_cohortname(~,~)  % (src,event)
        cohort.setProp(EEGCohort.NAME,get(ui_edit_grtab_cohortname,'String'));
        update_grtab_cohortname()
    end
    function cb_edit_time(~,~)  % (src,event)
        time = real(str2num(get(ui_edit_repetition_time,'String')));
        if isempty(time) || time<=0
            set(ui_edit_repetition_time,'String','1')
        end
        cohort.setProp(EEGCohort.T,time)
    end
    function cb_grtab_load_xls(~,~)  % (src,event)
        try
            cohorttmp = EEGCohort(cohort.getBrainAtlas());
            if cohorttmp.loadfromxls(BNC.MSG_GETDIR)
                % add subjects
                for i = 1:1:cohorttmp.length()
                    cohort.add(cohorttmp.get(i))
                end
                % add group
                grname = cohorttmp.getGroup(1).getProp(Group.NAME);
                cohort.addgroup()
                gr = cohort.getGroup(cohort.groupnumber());
                gr.setProp(Group.NAME,grname)
                cohort.addtogroup(cohort.groupnumber(),[cohort.length:-1:cohort.length-cohorttmp.length()+1])
                % update
                update_grtab_table()
                update_console_panel_visibility(CONSOLE_SUBJECTS_CMD)
                update_console_panel()
                update_group_popups()
            end
        catch
            errordlg('The file is not a valid EEG Subjects file. Please load a valid Excel file');
        end
    end
    function cb_grtab_load_mat(~,~)  % (src,event)
        try
            cohorttmp = EEGCohort(cohort.getBrainAtlas());
            if cohorttmp.loadfrommat(BNC.MSG_GETDIR)
                % add subjects
                for i = 1:1:cohorttmp.length()
                    cohort.add(cohorttmp.get(i))
                end
                % add group
                grname = cohorttmp.getGroup(1).getProp(Group.NAME);
                cohort.addgroup()
                gr = cohort.getGroup(cohort.groupnumber());
                gr.setProp(Group.NAME,grname)
                cohort.addtogroup(cohort.groupnumber(),[cohort.length:-1:cohort.length-cohorttmp.length()+1])
                % update
                update_grtab_table()
                update_console_panel_visibility(CONSOLE_SUBJECTS_CMD)
                update_console_panel()
                update_group_popups()
            end
        catch
            errordlg('The file is not a valid EEG Subjects file. Please load a valid MAT file');
        end
    end
    function cb_grtab_load_xml(~,~)  % (src,event)
        try
            cohorttmp = EEGCohort(BrainAtlas());
            if cohorttmp.loadfromfile(BNC.XML_MSG_GETFILE)
                % add subjects
                for i = 1:1:cohorttmp.length()
                    cohort.add(cohorttmp.get(i))
                end
                % add group
                grname = cohorttmp.getGroup(1).getProp(Group.NAME);
                cohort.addgroup()
                gr = cohort.getGroup(cohort.groupnumber());
                gr.setProp(Group.NAME,grname)
                cohort.addtogroup(cohort.groupnumber(),[cohort.length:-1:cohort.length-cohorttmp.length()+1])
                % update
                update_grtab_table()
                update_console_panel_visibility(CONSOLE_SUBJECTS_CMD)
                update_console_panel()
                update_group_popups()
            end
        catch
            errordlg('The file is not a valid EEG Subjects file. Please load a valid Xml file');
        end
    end
    function cb_grtab_edit_gr(~,event)  % (src,event)
        g = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case GRTAB_SELECTED_COL
                if newdata==1
                    selected_group = g;
                else
                    selected_group = [];
                end
            case GRTAB_NAME_COL
                cohort.getGroup(g).setProp(Group.NAME,newdata)
            case GRTAB_NOTES_COL
                cohort.getGroup(g).setProp(Group.NOTES,newdata)
        end
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_SUBJECTS_CMD)
        update_console_panel()
        update_group_popups()
    end
    function cb_grtab_add_gr(~,~)  % (src,event)
        cohort.addgroup();
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()        
    end
    function cb_grtab_remove_gr(~,~)  % (src,event)
        selected_group = cohort.removeallgroups(selected_group);
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()   
    end
    function cb_grtab_moveup_gr(~,~)  % (src,event)
        selected_group = cohort.movegroupsup(selected_group);
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()
    end
    function cb_grtab_movedown_gr(~,~)  % (src,event)
        selected_group = cohort.movegroupsdown(selected_group);
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()
    end
    function cb_grtab_invert(~,~)  % (src,event)
        g = get(ui_popup_grtab_invert,'Value');
        cohort.notgroup(g)
        cohort.movegroups2bottom(g+1);
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()
    end
    function cb_grtab_merge(~,~)  % (src,event)
        g1 = get(ui_popup_grtab_merge1,'Value');
        g2 = get(ui_popup_grtab_merge2,'Value');
        cohort.orgroup(g1,g2)
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()
    end
    function cb_grtab_intersect(~,~)  % (src,event)
        g1 = get(ui_popup_grtab_intersect1,'Value');
        g2 = get(ui_popup_grtab_intersect2,'Value');
        cohort.andgroup(g1,g2)
        update_grtab_table()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        update_console_panel()
    end

%% Console
CONSOLE_WIDTH = 1-LEFTCOLUMN_WIDTH-3*MARGIN_X;
CONSOLE_HEIGHT = HEADING_HEIGHT;
CONSOLE_X0 = LEFTCOLUMN_WIDTH+2*MARGIN_X;
CONSOLE_Y0 = 1-MARGIN_Y-CONSOLE_HEIGHT;
CONSOLE_POSITION = [CONSOLE_X0 CONSOLE_Y0 CONSOLE_WIDTH CONSOLE_HEIGHT];

CONSOLE_GROUPS_CMD = 'Groups & Demographics';
CONSOLE_GROUPS_SC = '1';
CONSOLE_GROUPS_TP = ['List of groups with sujects and demographic information. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_GROUPS_SC];

CONSOLE_SUBJECTS_CMD = 'Subject Data';
CONSOLE_SUBJECTS_SC = '2';
CONSOLE_SUBJECTS_TP = ['List of subjects with their measures. Shortcut: ' GUI.ACCELERATOR '+' CONSOLE_SUBJECTS_SC];

ui_panel_console = uipanel();
ui_button_console_groups = uicontrol(ui_panel_console,'Style', 'pushbutton');
ui_button_console_subjects = uicontrol(ui_panel_console,'Style', 'pushbutton');
init_console()
    function init_console()
        GUI.setUnits(ui_panel_console)
        GUI.setBackgroundColor(ui_panel_console)
        
        set(ui_panel_console,'Position',CONSOLE_POSITION)
        set(ui_panel_console,'BorderType','none')
        
        set(ui_button_console_groups,'Position',[.25 .30 .15 .40])
        set(ui_button_console_groups,'String',CONSOLE_GROUPS_CMD)
        set(ui_button_console_groups,'TooltipString',CONSOLE_GROUPS_TP)
        set(ui_button_console_groups,'Callback',{@cb_console_groups})
        
        set(ui_button_console_subjects,'Position',[.60 .30 .15 .40])
        set(ui_button_console_subjects,'String',CONSOLE_SUBJECTS_CMD)
        set(ui_button_console_subjects,'TooltipString',CONSOLE_SUBJECTS_TP)
        set(ui_button_console_subjects,'Callback',{@cb_console_subjects})
        
        
    end
    function update_console_panel_visibility(console_panel_cmd)
        switch console_panel_cmd
            case CONSOLE_SUBJECTS_CMD
                set(ui_panel_groups,'Visible','off')
                set(ui_panel_subjects,'Visible','on')
                
                set(ui_button_console_groups,'FontWeight','normal')
                set(ui_button_console_subjects,'FontWeight','bold')
                
            otherwise % CONSOLE_GROUPS_CMD
                set(ui_panel_groups,'Visible','on')
                set(ui_panel_subjects,'Visible','off')
                
                set(ui_button_console_groups,'FontWeight','bold')
                set(ui_button_console_subjects,'FontWeight','normal')
        end
    end
    function update_console_panel()
        if strcmpi(get(ui_panel_groups,'Visible'),'on')
            update_groups()
        end
        if strcmpi(get(ui_panel_subjects,'Visible'),'on')
            update_subjects_list()
            update_subjects_table()
        end
    end
    function cb_console_groups(~,~)  % (src,event)
        update_groups()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_console_subjects(~,~)  % (src,event)
        update_subjects_list()
        update_subjects_table()
        update_console_panel_visibility(CONSOLE_SUBJECTS_CMD)
    end

%% Panel 1 - Groups
TAB_GROUPS_SELECTED_COL = 1;
TAB_GROUPS_SUBCODE_COL = 2;
TAB_GROUPS_SUBAGE_COL = 3;
TAB_GROUPS_SUBGENDER_COL = 4;
TAB_GROUPS_SUBNOTES_COL = 5;

GROUPS_CREATE_CMD = 'New group from selection';
GROUPS_CREATE_TP = 'Create new group from selection';

ui_panel_groups = uipanel();

ui_table_groups = uitable(ui_panel_groups);
ui_button_groups_selectall_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_clearselection_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_add_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_addabove_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_addbelow_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_remove_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_moveup_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_movedown_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_move2top_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_move2bottom_subs = uicontrol(ui_panel_groups,'Style', 'pushbutton');
ui_button_groups_create = uicontrol(ui_panel_groups,'Style', 'pushbutton');
init_groups()
    function init_groups()
        GUI.setUnits(ui_panel_groups)
        GUI.setBackgroundColor(ui_panel_groups)
        
        set(ui_panel_groups,'Position',MAINPANEL_POSITION)
        set(ui_panel_groups,'Title',CONSOLE_GROUPS_CMD)
        
        set(ui_table_groups,'Position',[.02 .16 .96 .82])
        set(ui_table_groups,'ColumnEditable',true)
        set(ui_table_groups,'CellEditCallback',{@cb_groups_edit_sub});
        
        set(ui_button_groups_selectall_subs,'Position',[.02 .11 .10 .03])
        set(ui_button_groups_selectall_subs,'String',SELECTALL_SUB_CMD)
        set(ui_button_groups_selectall_subs,'TooltipString',SELECTALL_SUB_TP)
        set(ui_button_groups_selectall_subs,'Callback',{@cb_groups_selectall_sub})
        
        set(ui_button_groups_clearselection_subs,'Position',[.02 .08 .10 .03])
        set(ui_button_groups_clearselection_subs,'String',CLEARSELECTION_SUB_CMD)
        set(ui_button_groups_clearselection_subs,'TooltipString',CLEARSELECTION_SUB_TP)
        set(ui_button_groups_clearselection_subs,'Callback',{@cb_groups_clearselection_sub})
        
        set(ui_button_groups_add_subs,'Position',[.12 .11 .10 .03])
        set(ui_button_groups_add_subs,'String',ADD_SUB_CMD)
        set(ui_button_groups_add_subs,'TooltipString',ADD_SUBJECTS_TP);
        set(ui_button_groups_add_subs,'Callback',{@cb_groups_add_sub})
        
        set(ui_button_groups_addabove_subs,'Position',[.12 .08 .10 .03])
        set(ui_button_groups_addabove_subs,'String',ADDABOVE_SUB_CMD)
        set(ui_button_groups_addabove_subs,'TooltipString',ADDABOVE_SUB_TP)
        set(ui_button_groups_addabove_subs,'Callback',{@cb_groups_addabove_sub})
        
        set(ui_button_groups_addbelow_subs,'Position',[.12 .05 .10 .03])
        set(ui_button_groups_addbelow_subs,'String',ADDBELOW_SUB_CMD)
        set(ui_button_groups_addbelow_subs,'TooltipString',ADDBELOW_SUB_TP)
        set(ui_button_groups_addbelow_subs,'Callback',{@cb_groups_addbelow_sub})
        
        set(ui_button_groups_remove_subs,'Position',[.22 .11 .10 .03])
        set(ui_button_groups_remove_subs,'String',REMOVE_SUB_CMD)
        set(ui_button_groups_remove_subs,'TooltipString',REMOVE_SUB_TP);
        set(ui_button_groups_remove_subs,'Callback',{@cb_groups_remove_sub})
        
        set(ui_button_groups_moveup_subs,'Position',[.32 .11 .10 .03])
        set(ui_button_groups_moveup_subs,'String',MOVEUP_SUB_CMD)
        set(ui_button_groups_moveup_subs,'TooltipString',MOVEUP_SUB_TP);
        set(ui_button_groups_moveup_subs,'Callback',{@cb_groups_moveup_sub})
        
        set(ui_button_groups_movedown_subs,'Position',[.32 .08 .10 .03])
        set(ui_button_groups_movedown_subs,'String',MOVEDOWN_SUB_CMD)
        set(ui_button_groups_movedown_subs,'TooltipString',MOVEDOWN_SUB_TP);
        set(ui_button_groups_movedown_subs,'Callback',{@cb_groups_movedown_sub})
        
        set(ui_button_groups_move2top_subs,'Position',[.32 .05 .10 .03])
        set(ui_button_groups_move2top_subs,'String',MOVE2TOP_SUB_CMD)
        set(ui_button_groups_move2top_subs,'TooltipString',MOVE2TOP_SUB_TP);
        set(ui_button_groups_move2top_subs,'Callback',{@cb_groups_move2top_sub})
        
        set(ui_button_groups_move2bottom_subs,'Position',[.32 .02 .10 .03])
        set(ui_button_groups_move2bottom_subs,'String',MOVE2BOTTOM_SUB_CMD)
        set(ui_button_groups_move2bottom_subs,'TooltipString',MOVE2BOTTOM_SUB_TP);
        set(ui_button_groups_move2bottom_subs,'Callback',{@cb_groups_move2bottom_sub})
        
        set(ui_button_groups_create,'Position',[.72 .09 .26 .05])
        set(ui_button_groups_create,'String',GROUPS_CREATE_CMD)
        set(ui_button_groups_create,'TooltipString',GROUPS_CREATE_TP)
        set(ui_button_groups_create,'Callback',{@cb_groups_create})
    end
    function update_groups(varargin)
        
        % subjects and groups data table
        ColumnName = {'',' Subject Code ',' Age ',' Gender ',' Notes '};
        ColumnFormat = {'logical','char','numeric',EEGSubject.GENDER_OPTIONS,'char'};
        for g = 1:1:cohort.groupnumber()
            ColumnName{5+g} = cohort.getGroup(g).getProp(Group.NAME);
            ColumnFormat{5+g} = 'logical';
        end
        set(ui_table_groups,'ColumnName',ColumnName)
        set(ui_table_groups,'ColumnFormat',ColumnFormat)
        if exist('restricted','var') && restricted
            set(ui_table_groups,'ColumnEditable',[true(1,5) false(1,cohort.groupnumber())])
        end
        
        data = cell(cohort.length(),5+cohort.groupnumber());
        for i = 1:1:cohort.length()
            if any(selected_subjects==i)
                data{i,TAB_GROUPS_SELECTED_COL} = true;
            else
                data{i,TAB_GROUPS_SELECTED_COL} = false;
            end
            data{i,TAB_GROUPS_SUBCODE_COL} = cohort.get(i).getProp(EEGSubject.CODE);
            data{i,TAB_GROUPS_SUBAGE_COL} = cohort.get(i).getProp(EEGSubject.AGE);
            data{i,TAB_GROUPS_SUBGENDER_COL} = cohort.get(i).getProp(EEGSubject.GENDER);
            data{i,TAB_GROUPS_SUBNOTES_COL} = cohort.get(i).getProp(EEGSubject.NOTES);
        end
        for g = 1:1:cohort.groupnumber()
            temp = cohort.getGroup(g).getProp(Group.DATA);
            for i = 1:1:cohort.length()
                data{i,TAB_GROUPS_SUBNOTES_COL+g} = temp(i);
            end
        end
        set(ui_table_groups,'Data',data)
        update_group_popups()
    end
    function update_group_popups()
        % group popups
        GroupList = cell(1,cohort.groupnumber());
        for g = 1:1:cohort.groupnumber()
            GroupList{g} = cohort.getGroup(g).getProp(Group.NAME);
        end
        if isempty(GroupList)
            GroupList = {''};
        end
        set(ui_popup_grtab_invert,'String',GroupList)
        if get(ui_popup_grtab_invert,'Value')>cohort.groupnumber() || get(ui_popup_grtab_invert,'Value')<1
            set(ui_popup_grtab_invert,'Value',1)
        end
        set(ui_popup_grtab_merge1,'String',GroupList)
        if get(ui_popup_grtab_merge1,'Value')>cohort.groupnumber() || get(ui_popup_grtab_merge1,'Value')<1
            set(ui_popup_grtab_merge1,'Value',1)
        end
        set(ui_popup_grtab_merge2,'String',GroupList)
        if get(ui_popup_grtab_merge2,'Value')>cohort.groupnumber() || get(ui_popup_grtab_merge2,'Value')<1
            set(ui_popup_grtab_merge2,'Value',1)
        end
        set(ui_popup_grtab_intersect1,'String',GroupList)
        if get(ui_popup_grtab_intersect1,'Value')>cohort.groupnumber() || get(ui_popup_grtab_intersect1,'Value')<1
            set(ui_popup_grtab_intersect1,'Value',1)
        end
        set(ui_popup_grtab_intersect2,'String',GroupList)
        if get(ui_popup_grtab_intersect2,'Value')>cohort.groupnumber() || get(ui_popup_grtab_intersect2,'Value')<1
            set(ui_popup_grtab_intersect2,'Value',1)
        end
    end
    function cb_groups_edit_sub(~,event)  % (src,event)
        i = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        switch col
            case TAB_GROUPS_SELECTED_COL
                if newdata==1
                    selected_subjects = sort(unique([selected_subjects(:); i]));
                else
                    selected_subjects = selected_subjects(selected_subjects~=i);
                end
            case TAB_GROUPS_SUBCODE_COL
                cohort.get(i).setProp(EEGSubject.CODE,newdata)
            case TAB_GROUPS_SUBAGE_COL
                cohort.get(i).setProp(EEGSubject.AGE,newdata)
            case TAB_GROUPS_SUBGENDER_COL
                cohort.get(i).setProp(EEGSubject.GENDER,newdata)
            case TAB_GROUPS_SUBNOTES_COL
                cohort.get(i).setProp(EEGSubject.NOTES,newdata)
            otherwise
                g = col-5;
                data = cohort.getGroup(g).getProp(Group.DATA);
                data(i) = newdata;
                cohort.getGroup(g).setProp(Group.DATA,data);
        end
        update_grtab_table()
        update_groups()
    end
    function cb_groups_selectall_sub(~,~)  % (src,event)
        selected_subjects = (1:1:cohort.length())';
        update_groups()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_clearselection_sub(~,~)  % (src,event)
        selected_subjects = [];
        update_groups()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_add_sub(~,~)  % (src,event)
        cohort.add();
        update_grtab_table()
        update_console_panel()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_addabove_sub(~,~)  % (src,event)
        selected_subjects = cohort.addabove(selected_subjects);
        update_grtab_table()
        update_console_panel()        
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_addbelow_sub(~,~)  % (src,event)
        selected_subjects = cohort.addbelow(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_remove_sub(~,~)  % (src,event)
        selected_subjects = cohort.removeall(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_moveup_sub(~,~)  % (src,event)
        selected_subjects = cohort.moveup(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_movedown_sub(~,~)  % (src,event)
        selected_subjects = cohort.movedown(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_move2top_sub(~,~)  % (src,event)
        selected_subjects = cohort.move2top(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_move2bottom_sub(~,~)  % (src,event)
        selected_subjects = cohort.move2bottom(selected_subjects);
        update_grtab_table()
        update_console_panel()     
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
    end
    function cb_groups_create(~,~)  % (src,event)
        cohort.addgroup()
        cohort.addtogroup(cohort.groupnumber(),selected_subjects)
        update_grtab_table()
        update_groups()
    end

%% Panel 2 - Subjects

TAB_SUBJECTS_INDEX_COL = 1;

% SUBJECTS_SAVE_TXT_CMD = 'Save subjects as txt ...';
% SUBJECTS_SAVE_TXT_TP = 'Save group as txt file';

SUBJECTS_ADD_ROW_CMD = 'Add row';
SUBJECTS_ADD_ROW_TP = 'Add new data row';

ui_panel_subjects = uipanel();
ui_table_subjects = uitable(ui_panel_subjects);
ui_list_subjects = uicontrol(ui_panel_subjects,'Style', 'listbox');
% ui_button_subjects_save_txt = uicontrol(ui_panel_subjects,'Style', 'pushbutton');
ui_button_subjects_add_row = uicontrol(ui_panel_subjects,'Style', 'pushbutton');
init_subjects()
    function init_subjects()
        GUI.setUnits(ui_panel_subjects)
        GUI.setBackgroundColor(ui_panel_subjects)
        
        set(ui_panel_subjects,'Position',MAINPANEL_POSITION)
        set(ui_panel_subjects,'Title',CONSOLE_SUBJECTS_CMD)
        
        set(ui_table_subjects,'Position',[.25 .11 .73 .88])
        set(ui_table_subjects,'ColumnFormat',{'numeric'})
        set(ui_table_subjects,'ColumnEditable',true)
        set(ui_table_subjects,'CellEditCallback',{@cb_subjects_edit_data});
        
%         set(ui_button_subjects_save_txt,'Position',[.72 .03 .26 .05])
%         set(ui_button_subjects_save_txt,'String',SUBJECTS_SAVE_TXT_CMD)
%         set(ui_button_subjects_save_txt,'TooltipString',SUBJECTS_SAVE_TXT_TP)
%         set(ui_button_subjects_save_txt,'Callback',{@cb_subjects_save_txt})
        
        set(ui_button_subjects_add_row,'Position',[.25 .03 .15 .05])
        set(ui_button_subjects_add_row,'String',SUBJECTS_ADD_ROW_CMD)
        set(ui_button_subjects_add_row,'TooltipString',SUBJECTS_ADD_ROW_TP)
        set(ui_button_subjects_add_row,'Callback',{@cb_subjects_add_row})
        
        set(ui_list_subjects,'Position',[.03 .02 .2 .97])
        set(ui_list_subjects,'String','')
        set(ui_list_subjects,'TooltipString','Select EEG subject');
        set(ui_list_subjects,'Value',1)
        set(ui_list_subjects,'Max',-1,'Min',0)
        set(ui_list_subjects,'Callback',{@cb_subjects_list});
        
    end
    function update_subjects_list()
        if cohort.groupnumber()>0 && ~isempty(selected_group)
            groupdata = cohort.getGroup(selected_group).getProp(Group.DATA);
        else
            groupdata = true(1,cohort.length());
        end
        
        indices = find(groupdata==true);
        if ~isempty(indices)
            SubjectName = cell(length(indices),1);
            
            for j = 1:1:length(indices)
                SubjectName{j} = cohort.get(indices(j)).getProp(EEGSubject.CODE);
            end
            
            set(ui_list_subjects,'String',SubjectName)
        else
            set(ui_list_subjects,'String','---')
        end
        
    end
    function update_subjects_table(varargin)
        
        value = get(ui_list_subjects,'Value');
        
        if cohort.groupnumber()>0 && ~isempty(selected_group)
            groupdata = cohort.getGroup(selected_group).getProp(Group.DATA);
        else
            groupdata = true(1,cohort.length());
        end
        indices = find(groupdata==true);
        
        % region name
        atlas = cohort.getBrainAtlas();
        ColumnName = cell(1,atlas.length());
        for n = 1:1:atlas.length();
            ColumnName{n} = atlas.get(n).getProp(BrainAtlas.NAME);
        end
        set(ui_table_subjects,'ColumnName',ColumnName)
        
        if ~isempty(indices)
            if size(cohort.get(indices(value)).getProp(EEGSubject.DATA),2) ~= cohort.getBrainAtlas.length()
                cohort.get(indices(value)).setProp(EEGSubject.DATA,zeros(1,cohort.getBrainAtlas.length()))
            end
            data = cohort.get(indices(value)).getProp(EEGSubject.DATA);
            
            % subject data table
            RowName = cell(1,size(data,1));
            for j = 1:1:length(RowName)
                RowName{j} = j;
            end
            
            set(ui_table_subjects,'RowName',RowName)
            set(ui_table_subjects,'Data',data)
            
        else
            set(ui_table_subjects,'RowName','')
            set(ui_table_subjects,'Data',[])
        end
    end
    function cb_subjects_edit_data(~,event)  % (src,event)
        j = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        
        value = get(ui_list_subjects,'Value');
        
        if cohort.groupnumber()>0 && ~isempty(selected_group)
            groupdata = cohort.getGroup(selected_group).getProp(Group.DATA);
        else
            groupdata = true(1,cohort.length());
        end
        indices = find(groupdata==true);
        data = cohort.get(indices(value)).getProp(EEGSubject.DATA);
        
        data(j,col) = newdata;
        cohort.get(indices(value)).setProp(EEGSubject.DATA,data);
        
        update_grtab_table()
        update_subjects_table()
    end
    function cb_subjects_list(~,~)  % (src,event)
        update_subjects_table()
    end
    % function cb_subjects_save_txt(~,~)  % (src,event)
    %     % select indices
    %     if cohort.groupnumber()>0 && ~isempty(selected_group)
    %         groupdata = cohort.getGroup(selected_group).getProp(Group.DATA);
    %     else
    %         groupdata = true(1,cohort.length());
    %     end
    %     indices = find(groupdata==true);
    % 
    %     % create and save cohort
    %     cohorttmp = EEGCohort(cohort.getBrainAtlas());
    %     for i = indices
    %         cohorttmp.add(cohort.get(i));
    %     end
    %     cohorttmp.savetotxt(BNC.TXT_MSG_PUTFILE)
    % end
    function cb_subjects_add_row(~,~)  % (src,event)
        value = get(ui_list_subjects,'Value');
        
        if cohort.groupnumber()>0 && ~isempty(selected_group)
            groupdata = cohort.getGroup(selected_group).getProp(Group.DATA);
        else
            groupdata = true(1,cohort.length());
        end
        indices = find(groupdata==true);
        
        if ~isempty(indices)
            data = cohort.get(indices(value)).getProp(EEGSubject.DATA);
            
            data = [data ; zeros(1,cohort.getBrainAtlas.length())];
            cohort.get(indices(value)).setProp(EEGSubject.DATA,data);
            cohort.get(indices(value)).getProp(EEGSubject.DATA)
            
            % subject data table
            RowName = cell(1,size(data,1));
            for j = 1:1:length(RowName)
                RowName{j} = j;
            end
            
            set(ui_table_subjects,'RowName',RowName)
            set(ui_table_subjects,'Data',data)
        end
    end

%% Menus
MENU_FILE = GUI.MENU_FILE;
MENU_GROUPS = 'Groups';
MENU_SUBJECTS = 'Subjects';
MENU_VIEW = GUI.MENU_VIEW;
MENU_ANALYSIS = 'Graph Analysis';

ui_menu_file = uimenu(f,'Label',MENU_FILE);
ui_menu_file_open = uimenu(ui_menu_file);
ui_menu_file_save = uimenu(ui_menu_file);
ui_menu_file_saveas = uimenu(ui_menu_file);
ui_menu_file_import_xml = uimenu(ui_menu_file);
ui_menu_file_export_xml = uimenu(ui_menu_file);
ui_menu_file_close = uimenu(ui_menu_file);
ui_menu_groups = uimenu(f,'Label',MENU_GROUPS);
ui_menu_groups_load_xls = uimenu(ui_menu_groups);
ui_menu_groups_load_txt = uimenu(ui_menu_groups);
ui_menu_groups_load_xml = uimenu(ui_menu_groups);
ui_menu_groups_add = uimenu(ui_menu_groups);
ui_menu_groups_remove = uimenu(ui_menu_groups);
ui_menu_groups_moveup = uimenu(ui_menu_groups);
ui_menu_groups_movedown = uimenu(ui_menu_groups);
ui_menu_subjects = uimenu(f,'Label',MENU_SUBJECTS);
ui_menu_subjects_selectall = uimenu(ui_menu_subjects);
ui_menu_subjects_clearselection = uimenu(ui_menu_subjects);
ui_menu_subjects_add = uimenu(ui_menu_subjects);
ui_menu_subjects_addabove = uimenu(ui_menu_subjects);
ui_menu_subjects_addbelow = uimenu(ui_menu_subjects);
ui_menu_subjects_remove = uimenu(ui_menu_subjects);
ui_menu_subjects_moveup = uimenu(ui_menu_subjects);
ui_menu_subjects_movedown = uimenu(ui_menu_subjects);
ui_menu_subjects_move2top = uimenu(ui_menu_subjects);
ui_menu_subjects_move2bottom = uimenu(ui_menu_subjects);
ui_menu_view = uimenu(f,'Label',MENU_VIEW);
ui_menu_view_groups = uimenu(ui_menu_view);
ui_menu_view_subjects = uimenu(ui_menu_view);
ui_menu_analysis = uimenu(f,'Label',MENU_ANALYSIS);
ui_menu_analysis_ga = uimenu(ui_menu_analysis);
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
        
        set(ui_menu_groups_load_xls,'Label',GRTAB_LOAD_XLS_CMD)
        set(ui_menu_groups_load_xls,'Callback',{@cb_grtab_load_xls})
        
        set(ui_menu_groups_load_txt,'Label',GRTAB_LOAD_MAT_CMD)
        set(ui_menu_groups_load_txt,'Callback',{@cb_grtab_load_mat})
        
        set(ui_menu_groups_load_xml,'Label',GRTAB_LOAD_XML_CMD)
        set(ui_menu_groups_load_xml,'Callback',{@cb_grtab_load_xml})
        
        set(ui_menu_groups_add,'Separator','on')
        set(ui_menu_groups_add,'Label',ADD_GR_CMD)
        set(ui_menu_groups_add,'Callback',{@cb_grtab_add_gr})
        
        set(ui_menu_groups_remove,'Label',REMOVE_GR_CMD)
        set(ui_menu_groups_remove,'Callback',{@cb_grtab_remove_gr})
        
        set(ui_menu_groups_moveup,'Label',MOVEUP_GR_CMD)
        set(ui_menu_groups_moveup,'Callback',{@cb_grtab_moveup_gr})
        
        set(ui_menu_groups_movedown,'Label',MOVEDOWN_GR_CMD)
        set(ui_menu_groups_movedown,'Callback',{@cb_grtab_movedown_gr})
        
        set(ui_menu_subjects_selectall,'Separator','on')
        set(ui_menu_subjects_selectall,'Label',SELECTALL_SUB_CMD)
        set(ui_menu_subjects_selectall,'Callback',{@cb_groups_selectall_sub})
        
        set(ui_menu_subjects_clearselection,'Label',CLEARSELECTION_SUB_CMD)
        set(ui_menu_subjects_clearselection,'Callback',{@cb_groups_clearselection_sub})
        
        set(ui_menu_subjects_add,'Separator','on')
        set(ui_menu_subjects_add,'Label',ADD_SUB_CMD)
        set(ui_menu_subjects_add,'Callback',{@cb_groups_add_sub})
        
        set(ui_menu_subjects_addabove,'Label',ADDABOVE_SUB_CMD)
        set(ui_menu_subjects_addabove,'Callback',{@cb_groups_addabove_sub})
        
        set(ui_menu_subjects_addbelow,'Label',ADDBELOW_SUB_CMD)
        set(ui_menu_subjects_addbelow,'Callback',{@cb_groups_addbelow_sub});
        
        set(ui_menu_subjects_remove,'Separator','on')
        set(ui_menu_subjects_remove,'Label',REMOVE_SUB_CMD)
        set(ui_menu_subjects_remove,'Callback',{@cb_groups_remove_sub})
        
        set(ui_menu_subjects_moveup,'Separator','on')
        set(ui_menu_subjects_moveup,'Label',MOVEUP_SUB_CMD)
        set(ui_menu_subjects_moveup,'Callback',{@cb_groups_moveup_sub})
        
        set(ui_menu_subjects_movedown,'Label',MOVEDOWN_SUB_CMD)
        set(ui_menu_subjects_movedown,'Callback',{@cb_groups_movedown_sub})
        
        set(ui_menu_subjects_move2top,'Label',MOVE2TOP_SUB_CMD)
        set(ui_menu_subjects_move2top,'Callback',{@cb_groups_move2top_sub})
        
        set(ui_menu_subjects_move2bottom,'Label',MOVE2BOTTOM_SUB_CMD)
        set(ui_menu_subjects_move2bottom,'Callback',{@cb_groups_move2bottom_sub})
        
        set(ui_menu_view_groups,'Label',CONSOLE_GROUPS_CMD)
        set(ui_menu_view_groups,'Accelerator',CONSOLE_GROUPS_SC)
        set(ui_menu_view_groups,'Callback',{@cb_console_groups})
        
        set(ui_menu_view_subjects,'Label',CONSOLE_SUBJECTS_CMD)
        set(ui_menu_view_subjects,'Accelerator',CONSOLE_SUBJECTS_SC)
        set(ui_menu_view_subjects,'Callback',{@cb_console_subjects})
        
        set(ui_menu_analysis_ga,'Label',EEGGRAPHANALYSIS_CMD)
        set(ui_menu_analysis_ga,'Callback',{@cb_menu_ga})
    end
    function cb_menu_ga(~,~)  % (src,event)
        if cohort.length()>0
            GUIEEGGraphAnalysis(cohort.copy())
        else
            msgbox('In order to create an EEG analysis the cohort must have at least one subject.', ...
                'Warning: Empty EEG cohort', ...
                'warn')
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
        % get(findall(ui_toolbar),'Tag')
        delete(findall(ui_toolbar,'Tag','Standard.NewFigure'))
        % delete(findall(ui_toolbar,'Tag','Standard.FileOpen'))
        % delete(findall(ui_toolbar,'Tag','Standard.SaveFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.PrintFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.EditPlot'))
        delete(findall(ui_toolbar,'Tag','Exploration.ZoomIn'))
        delete(findall(ui_toolbar,'Tag','Exploration.ZoomOut'))
        delete(findall(ui_toolbar,'Tag','Exploration.Pan'))
        delete(findall(ui_toolbar,'Tag','Exploration.Rotate'))
        delete(findall(ui_toolbar,'Tag','Exploration.DataCursor'))
        delete(findall(ui_toolbar,'Tag','Exploration.Brushing'))
        delete(findall(ui_toolbar,'Tag','DataManager.Linking'))
        delete(findall(ui_toolbar,'Tag','Annotation.InsertColorbar'))
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

setup_restrictions()
    function setup_restrictions()
        if exist('restricted','var') && restricted
           
            set(ui_table_subjects,'ColumnEditable',false)
            
            set(ui_button_grtab_add_gr,'enable','off')
            set(ui_button_grtab_remove_gr,'enable','off')
            set(ui_button_grtab_moveup_gr,'enable','off')
            set(ui_button_grtab_movedown_gr,'enable','off')
            
            set(ui_button_groups_add_subs,'enable','off')
            set(ui_button_groups_addabove_subs,'enable','off')
            set(ui_button_groups_addbelow_subs,'enable','off')
            set(ui_button_groups_remove_subs,'enable','off')
            set(ui_button_groups_moveup_subs,'enable','off')
            set(ui_button_groups_movedown_subs,'enable','off')
            set(ui_button_groups_move2top_subs,'enable','off')
            set(ui_button_groups_move2bottom_subs,'enable','off')
            
            set(ui_menu_file_open,'enable','off')
            set(ui_menu_file_import_xml,'enable','off')
            set(ui_menu_groups_add,'enable','off')
            set(ui_menu_groups_remove,'enable','off')
            set(ui_menu_groups_moveup,'enable','off')
            set(ui_menu_groups_movedown,'enable','off')
            set(ui_menu_subjects_add,'enable','off')
            set(ui_menu_subjects_addabove,'enable','off')
            set(ui_menu_subjects_addbelow,'enable','off')
            set(ui_menu_subjects_remove,'enable','off')
            set(ui_menu_subjects_moveup,'enable','off')
            set(ui_menu_subjects_movedown,'enable','off')
            set(ui_menu_subjects_move2top,'enable','off')
            set(ui_menu_subjects_move2bottom,'enable','off')
            
            set(ui_toolbar_open,'enable','off')
        end
    end

%% Auxiliary functions

    function setup()
        
        % setup atlas
        update_atlas()
        
        % setup table
        update_grtab_cohortname()
        update_grtab_table()
        
        % setup main panel
        update_groups()
        update_console_panel_visibility(CONSOLE_GROUPS_CMD)
        
    end

end