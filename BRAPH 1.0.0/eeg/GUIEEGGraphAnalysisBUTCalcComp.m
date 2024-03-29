function GUIEEGGraphAnalysisBUTCalcComp(ga,mlist,selected_calc)
%% EEG Graph Analysis Measure Calculator

Check.isa('Error: The EEG graph analysis ga must be a EEGGraphAnalysisBUT',ga,'EEGGraphAnalysisBUT')

%% General Constants
APPNAME = [GUI.EGA_NAME ' fixed threshold'];  % application name
NAME = [APPNAME ' : Binary Undirected Graph ' ];

CALC_SELECTED_COL = 1;
CALC_NAME_COL = 2;
CALC_NODAL_COL = 3;
CALC_NODAL_NO = 'Global';
CALC_NODAL_YES = 'Nodal';
CALC_TXT_COL = 4;
SELECTALL_CALC_CMD = GUI.SELECTALL_CMD;
SELECTALL_CALC_TP = 'Select all measures';

CLEARSELECTION_CALC_CMD = GUI.CLEARSELECTION_CMD;
CLEARSELECTION_CALC_TP = 'Clear measure selection';

SELECTGLOBAL_CALC_CMD = 'Select Global';
SELECTGLOBAL_CALC_TP = 'Select all global measures';

SELECTNODAL_CALC_CMD = 'Select Nodal';
SELECTNODAL_CALC_TP = 'Select all nodal measures';

%% Application data
vi = 1;
stop = false;
start = 0;

%% GUI inizialization
f = GUI.init_figure(NAME,.4,.4,'west');

%% Main Panel
PANEL_POSITION = [0 0 1 1];

ui_panel = uipanel();

ui_text_calc_bt_min = uicontrol(ui_panel,'Style','text');
ui_edit_calc_bt_min = uicontrol(ui_panel,'Style','edit');
ui_text_calc_bt_max = uicontrol(ui_panel,'Style','text');
ui_edit_calc_bt_max = uicontrol(ui_panel,'Style','edit');
ui_text_calc_bt_increment = uicontrol(ui_panel,'Style','text');
ui_edit_calc_bt_increment = uicontrol(ui_panel,'Style','edit');
ui_table_calc = uitable(ui_panel);
ui_button_calc_selectall = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_clearselection = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_global = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_nodal = uicontrol(ui_panel,'Style', 'pushbutton');
ui_popup_group1 = uicontrol(ui_panel,'Style','popup','String',{''});
ui_popup_group2 = uicontrol(ui_panel,'Style','popup','String',{''});
ui_text_M = uicontrol(ui_panel,'Style','text');
ui_edit_M = uicontrol(ui_panel,'Style','edit');
ui_checkbox_longitudinal = uicontrol(ui_panel,'Style', 'checkbox');
ui_edit_info = uicontrol(ui_panel,'Style','edit');
ui_text_selectthreshold = uicontrol(ui_panel,'Style','text');
ui_button_stop = uicontrol(ui_panel,'Style','pushbutton');
ui_button_resume = uicontrol(ui_panel,'Style','pushbutton');

init_compare()
update_popups_grouplists()
update_calc_table()

%% Menu
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,APPNAME);

%% Make the GUI visible.
set(f,'Visible','on');

%% Callback functions
    function init_compare()
        GUI.setUnits(ui_panel)
        GUI.setBackgroundColor(ui_panel)
        
        set(ui_panel,'Position',PANEL_POSITION)
        set(ui_panel,'BorderType','none')
        
        set(ui_text_selectthreshold,'Position',[.49 .74 .49 .05])
        set(ui_text_selectthreshold,'String','Select threshold values')
        set(ui_text_selectthreshold,'FontWeight','normal')
        set(ui_text_selectthreshold,'HorizontalAlignment','left')
        set(ui_text_selectthreshold,'FontSize',10)
        
        set(ui_text_calc_bt_min,'Position',[.49 .67 .05 .05])
        set(ui_text_calc_bt_min,'String','Min ')
        set(ui_text_calc_bt_min,'HorizontalAlignment','left')
        
        set(ui_edit_calc_bt_min,'Position',[.54 .675 .05 .05])
        set(ui_edit_calc_bt_min,'String','-1')
        set(ui_edit_calc_bt_min,'FontWeight','bold')
        set(ui_edit_calc_bt_min,'Callback',{@cb_calc_bt_min})
        
        set(ui_text_calc_bt_max,'Position',[.685 .67 .05 .05])
        set(ui_text_calc_bt_max,'String','Max ')
        set(ui_text_calc_bt_max,'HorizontalAlignment','left')
        
        set(ui_edit_calc_bt_max,'Position',[.7350 .675 .05 .05])
        set(ui_edit_calc_bt_max,'String','1')
        set(ui_edit_calc_bt_max,'FontWeight','bold')
        set(ui_edit_calc_bt_max,'Callback',{@cb_calc_bt_max})
        
        set(ui_text_calc_bt_increment,'Position',[.88 .67 .05 .05])
        set(ui_text_calc_bt_increment,'String','step ')
        set(ui_text_calc_bt_increment,'HorizontalAlignment','left')
        
        set(ui_edit_calc_bt_increment,'Position',[.93 .675 .05 .05])
        set(ui_edit_calc_bt_increment,'String','0.1')
        set(ui_edit_calc_bt_increment,'FontWeight','bold')
        set(ui_edit_calc_bt_increment,'Callback',{@cb_calc_bt_increment})

        set(ui_table_calc,'BackgroundColor',GUI.TABBKGCOLOR)
        set(ui_table_calc,'Position',[.02 .15 .44 .83])
        set(ui_table_calc,'ColumnName',{'','   Brain Measure   ',' global/nodal ','   notes   '})
        set(ui_table_calc,'ColumnFormat',{'logical','char',{CALC_NODAL_NO CALC_NODAL_YES},'char'})
        set(ui_table_calc,'ColumnEditable',[true false false true])
        set(ui_table_calc,'CellEditCallback',{@cb_calc_edit});
        
        set(ui_button_calc_selectall,'Position',[.02 .08 .22 .06])
        set(ui_button_calc_selectall,'String',SELECTALL_CALC_CMD)
        set(ui_button_calc_selectall,'TooltipString',SELECTALL_CALC_TP)
        set(ui_button_calc_selectall,'Callback',{@cb_calc_selectall})
        
        set(ui_button_calc_clearselection,'Position',[.24 .08 .22 .06])
        set(ui_button_calc_clearselection,'String',CLEARSELECTION_CALC_CMD)
        set(ui_button_calc_clearselection,'TooltipString',CLEARSELECTION_CALC_TP)
        set(ui_button_calc_clearselection,'Callback',{@cb_calc_clearselection})
        
        set(ui_button_calc_global,'Position',[.02 .02 .22 .06])
        set(ui_button_calc_global,'String',SELECTGLOBAL_CALC_CMD)
        set(ui_button_calc_global,'TooltipString',SELECTGLOBAL_CALC_TP)
        set(ui_button_calc_global,'Callback',{@cb_calc_global})
        
        set(ui_button_calc_nodal,'Position',[.24 .02 .22 .06])
        set(ui_button_calc_nodal,'String',SELECTNODAL_CALC_CMD)
        set(ui_button_calc_nodal,'TooltipString',SELECTNODAL_CALC_TP)
        set(ui_button_calc_nodal,'Callback',{@cb_calc_nodal})
        
        set(ui_popup_group1,'Position',[.49 .90 .23 .08])
        set(ui_popup_group1,'TooltipString','Select group 1');
        
        set(ui_popup_group2,'Position',[.75 .90 .23 .08])
        set(ui_popup_group2,'TooltipString','Select group 1');
        
        set(ui_text_M,'Position',[.49 .807 .23 .08])
        set(ui_text_M,'String','permutation number')
        set(ui_text_M,'FontWeight','normal')
        set(ui_text_M,'HorizontalAlignment','left')
        set(ui_text_M,'FontSize',10)
        
        set(ui_edit_M,'Position',[.75 .825 .23 .08])
        set(ui_edit_M,'FontWeight','normal')
        set(ui_edit_M,'String','1000')
        set(ui_edit_M,'HorizontalAlignment','center')
        set(ui_edit_M,'FontSize',10)
        set(ui_edit_M,'Callback',{@cb_edit_M})
        
        set(ui_checkbox_longitudinal,'Position',[.75 .55 .23 .08])
        set(ui_checkbox_longitudinal,'String','longitudinal')
        set(ui_checkbox_longitudinal,'Value',false)
        set(ui_checkbox_longitudinal,'TooltipString','Select whether the analysis should be longitudinal')
        
        set(ui_edit_info,'BackgroundColor',[1 1 1])
        set(ui_edit_info,'Position',[.49 .15 .49 .35])
        set(ui_edit_info,'Max',2)
        set(ui_edit_info,'HorizontalAlignment','left')
        set(ui_edit_info,'Enable','inactive')
        
        set(ui_button_stop,'Position',[.49 .02 .24 .12])
        set(ui_button_stop,'String','Compare Groups')
        set(ui_button_stop,'Callback',{@cb_stop})
        
        set(ui_button_resume,'Position',[.74 .02 .24 .12])
        set(ui_button_resume,'String','Resume')
        set(ui_button_resume,'Enable','off')
        set(ui_button_resume,'Callback',{@cb_resume})
    end
    function deactivate_components()
        set(ui_text_selectthreshold,'Enable','off')
        set(ui_text_calc_bt_min,'Enable','off')
        set(ui_edit_calc_bt_min,'Enable','off')
        set(ui_text_calc_bt_max,'Enable','off')
        set(ui_edit_calc_bt_max,'Enable','off')
        set(ui_text_calc_bt_increment,'Enable','off')
        set(ui_edit_calc_bt_increment,'Enable','off')
        
        set(ui_table_calc,'Enable','off')
        set(ui_button_calc_selectall,'Enable','off')
        set(ui_button_calc_clearselection,'Enable','off')
        set(ui_button_calc_global,'Enable','off')
        set(ui_button_calc_nodal,'Enable','off')
        set(ui_popup_group1,'Enable','off')
        set(ui_popup_group2,'Enable','off')
        set(ui_text_M,'Enable','off')
        set(ui_edit_M,'Enable','off')
        set(ui_checkbox_longitudinal,'Enable','off')
    end
    function activate_components()
        set(ui_text_selectthreshold,'Enable','on')
        set(ui_text_calc_bt_min,'Enable','on')
        set(ui_edit_calc_bt_min,'Enable','on')
        set(ui_text_calc_bt_max,'Enable','on')
        set(ui_edit_calc_bt_max,'Enable','on')
        set(ui_text_calc_bt_increment,'Enable','on')
        set(ui_edit_calc_bt_increment,'Enable','on')
        
        set(ui_table_calc,'Enable','on')
        set(ui_button_calc_selectall,'Enable','on')
        set(ui_button_calc_clearselection,'Enable','on')
        set(ui_button_calc_global,'Enable','on')
        set(ui_button_calc_nodal,'Enable','on')
        set(ui_popup_group1,'Enable','on')
        set(ui_popup_group2,'Enable','on')
        set(ui_text_M,'Enable','on')
        set(ui_edit_M,'Enable','on')
    end
    function update_calc_table()
        
        update_popups_grouplists()
        
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
    function cb_stop(src,~)  % (src,event)
        deactivate_components()
        start = tic;
        if strcmp(get(src,'String'),'Compare Groups')
            if ga.getCohort().groupnumber()>0
                if isempty(selected_calc)
                    errordlg('Select measures to be calculated','Select measures','modal');
                    activate_components()
                    set(ui_button_stop,'String','Compare Groups')
                else
                    set(ui_button_stop,'String','stop')
                    g1 = get(ui_popup_group1,'Value');
                    g2 = get(ui_popup_group2,'Value');
                    M = str2num(get(ui_edit_M,'String'));
                    mlist = mlist(selected_calc);
                    values = str2num(get(ui_edit_calc_bt_min,'String')) ...
                            : str2num(get(ui_edit_calc_bt_increment,'String')) ...
                            : str2num(get(ui_edit_calc_bt_max,'String'));
                        
                    compare(ga,mlist,g1,g2,values,M)       
                end
            else
                errordlg('Define a group in order to perform calculations','Define a group','modal');
                activate_components()
            end
            
        else if strcmp(get(src,'String'),'stop')
                set(ui_button_resume,'Enable','on')
                set(ui_button_stop,'String','Compare Groups')
                set(ui_button_stop,'Enable','off')
                stop = true;
            end
        end
        set(ui_button_stop,'String','Compare Groups')
    end
    function cb_resume(~,~)  % (src,event)
        stop = false;
        set(ui_button_stop,'Enable','on')
        set(ui_button_resume,'Enable','off')
        set(ui_button_stop,'String','stop')
        g1 = get(ui_popup_group1,'Value');
        g2 = get(ui_popup_group2,'Value');
        M = str2num(get(ui_edit_M,'String'));
        values = str2num(get(ui_edit_calc_bt_min,'String')) ...
                        : str2num(get(ui_edit_calc_bt_increment,'String')) ...
                        : str2num(get(ui_edit_calc_bt_max,'String'));
            
        compare(ga,mlist,g1,g2,values,M)
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
        selected_calc = (1:1:length(mlist))';
        update_calc_table()
    end
    function cb_calc_clearselection(~,~)  % (src,event)
        selected_calc = [];
        update_calc_table()
    end
    function cb_calc_global(~,~)  % (src,event)
        selected_calc = [];
        for mi = 1:1:length(mlist)
            if Graph.isglobal(mlist(mi))
                selected_calc = [selected_calc; mi];
            end
        end
        update_calc_table()
    end
    function cb_calc_nodal(~,~)  % (src,event)
        selected_calc = [];
        for mi = 1:1:length(mlist)
            if Graph.isnodal(mlist(mi))
                selected_calc = [selected_calc; mi];
            end
        end
        update_calc_table()
    end
    function cb_calc_bt_min(~,~)  % (src,event)
        min = real(str2num(get(ui_edit_calc_bt_min,'String')));
        if isempty(min)
            set(ui_edit_calc_bt_min,'String','-1')
        else
            max = str2num(get(ui_edit_calc_bt_max,'String'));
            if min<-1
                set(ui_edit_calc_bt_min,'String','-1')
            elseif min>max
                set(ui_edit_calc_bt_min,'String',num2str(max))
            else
                set(ui_edit_calc_bt_min,'String',num2str(min))
            end
        end
    end
    function cb_calc_bt_max(~,~)  % (src,event)
        max = real(str2num(get(ui_edit_calc_bt_max,'String')));
        if isempty(max)
            set(ui_edit_calc_bt_min,'String','1')
        else
            min = str2num(get(ui_edit_calc_bt_min,'String'));
            if max>1
                set(ui_edit_calc_bt_max,'String','1')
            elseif max<min
                set(ui_edit_calc_bt_max,'String',num2str(min))
            else
                set(ui_edit_calc_bt_max,'String',num2str(max))
            end
        end
    end
    function cb_calc_bt_increment(~,~)  % (src,event)
        increment = real(str2num(get(ui_edit_calc_bt_increment,'String')));
        if isempty(increment) || increment<=0
            set(ui_edit_calc_bt_increment,'String','0.1')
        else
            set(ui_edit_calc_bt_increment,'String',num2str(increment))
        end
    end
    function cb_edit_M(~,~)  % (src,event)
        M = ceil(real(str2num(get(ui_edit_M,'String'))));
        if isempty(M) || M<1
            set(ui_edit_M,'String','1')
        elseif M>1e+6
            set(ui_edit_M,'String','1000000')
        else
            set(ui_edit_M,'String',num2str(M))
        end
        
    end

%% Auxiliary functions
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
        set(ui_popup_group1,'String',GroupList)
        set(ui_popup_group2,'String',GroupList)
    end
    function compare(ga,mlist,g1,g2,threshold,M)
        L = 100;
        txt = cell(1,L);
        for vi = vi:1:length(threshold)
            for mi = 1:1:length(mlist)
               
               m = ga.compare(mlist(mi),g1,g2,threshold(vi),'M',M,'Verbose',false,'Longitudinal',get(ui_checkbox_longitudinal,'Value'));
               msg = ['time = ' int2str(toc(start)) '.' int2str(mod(toc(start)*10,10)) 's - threshold = ' num2str(m.getProp(EEGMeasureBUT.THRESHOLD)) ' (' num2str(threshold(vi)) ') - compare group ' int2str(g1) ' and ' int2str(g2) ' - ' Graph.NAME{m.getProp(EEGMeasureBUT.CODE)}]; %
                
                % visualize status
                txt(2:L) = txt(1:L-1);
                txt{1} = msg;
                set(ui_edit_info,'String',txt)
                
                pause(.001)
                
                if stop
                    break
                end
            end
            if stop
                break
            end
        end
        if vi==length(threshold) && (isempty(mlist) || mi==length(mlist))
            txt(4:L) = txt(1:L-3);
            txt{1} = 'DONE!!!';
            txt{2} = ['time = ' int2str(toc(start)) '.' int2str(mod(toc(start)*10,10)) 's'];
            txt{3} = '';
            set(ui_edit_info,'String',txt)
            
            set(ui_button_stop,'Enable','off')
            set(ui_button_resume,'Enable','off')
        end
    end

end