function GUIMRIGraphAnalysisWUCalcRand(ga,mlist,selected_calc)
%% MRI Graph Analysis Measure Calculator

Check.isa('Error: The MRI graph analysis ga must be a MRIGraphAnalysisWU',ga,'MRIGraphAnalysisWU')

%% General Constants
APPNAME = [GUI.MGA_NAME 'weighted'];  % application name
NAME = [APPNAME ' : Weighted Undirected Graph ' ];

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

ui_table_calc = uitable(ui_panel);
ui_button_calc_selectall = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_clearselection = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_global = uicontrol(ui_panel,'Style', 'pushbutton');
ui_button_calc_nodal = uicontrol(ui_panel,'Style', 'pushbutton');

ui_popup_group = uicontrol(ui_panel,'Style','popup','String',{''});
ui_text_M = uicontrol(ui_panel,'Style','text');
ui_edit_M = uicontrol(ui_panel,'Style','edit');
ui_text_swaps = uicontrol(ui_panel,'Style','text');
ui_edit_swaps = uicontrol(ui_panel,'Style','edit');
ui_text_info = uicontrol(ui_panel,'Style','text');
ui_edit_info = uicontrol(ui_panel,'Style','edit');
ui_button_stop = uicontrol(ui_panel,'Style','pushbutton');
ui_button_resume = uicontrol(ui_panel,'Style','pushbutton');
init_calculate()
update_popups_grouplists()
update_calc_table()

%% Menu
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,APPNAME);

%% Make the GUI visible.
set(f,'Visible','on');

%% Callback functions
    function init_calculate()
        GUI.setUnits(ui_panel)
        GUI.setBackgroundColor(ui_panel)
        
        set(ui_panel,'Position',PANEL_POSITION)
        set(ui_panel,'BorderType','none')
        
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
        
        set(ui_popup_group,'Position',[.49 .90 .49 .08])
        set(ui_popup_group,'TooltipString','Select group');
        
        set(ui_text_M,'Position',[.49 .807 .23 .08])
        set(ui_text_M,'String','random matrix no.')
        set(ui_text_M,'FontWeight','normal')
        set(ui_text_M,'HorizontalAlignment','left')
        set(ui_text_M,'FontSize',10)
        
        set(ui_edit_M,'Position',[.75 .825 .23 .08])
        set(ui_edit_M,'FontWeight','normal')
        set(ui_edit_M,'String','1000')
        set(ui_edit_M,'HorizontalAlignment','center')
        set(ui_edit_M,'FontSize',10)
        set(ui_edit_M,'Callback',{@cb_edit_M})
        
        set(ui_text_swaps,'Position',[.49 .707 .23 .08])
        set(ui_text_swaps,'String','random swaps no.')
        set(ui_text_swaps,'FontWeight','normal')
        set(ui_text_swaps,'HorizontalAlignment','left')
        set(ui_text_swaps,'FontSize',10)
        
        set(ui_edit_swaps,'Position',[.75 .725 .23 .08])
        set(ui_edit_swaps,'FontWeight','normal')
        set(ui_edit_swaps,'String','10')
        set(ui_edit_swaps,'HorizontalAlignment','center')
        set(ui_edit_swaps,'FontSize',10)
        set(ui_edit_swaps,'Callback',{@cb_edit_swaps})
        
        set(ui_text_info,'Position',[.49 .46 .49 .08])
        set(ui_text_info,'String',ga.getProp(MRIGraphAnalysis.NAME))
        set(ui_text_info,'FontWeight','bold')
        set(ui_text_info,'FontSize',12)
        
        set(ui_edit_info,'BackgroundColor',[1 1 1])
        set(ui_edit_info,'Position',[.49 .15 .49 .30])
        set(ui_edit_info,'Max',2)
        set(ui_edit_info,'HorizontalAlignment','left')
        set(ui_edit_info,'Enable','inactive')
        
        set(ui_button_stop,'Position',[.49 .02 .24 .12])
        set(ui_button_stop,'String','Calculate measures')
        set(ui_button_stop,'Callback',{@cb_stop})
        
        set(ui_button_resume,'Position',[.74 .02 .24 .12])
        set(ui_button_resume,'String','Resume')
        set(ui_button_resume,'Enable','off')
        set(ui_button_resume,'Callback',{@cb_resume})
    end
    function deactivate_components()

        set(ui_table_calc,'Enable','off')
        set(ui_button_calc_selectall,'Enable','off')
        set(ui_button_calc_clearselection,'Enable','off')
        set(ui_button_calc_global,'Enable','off')
        set(ui_button_calc_nodal,'Enable','off')
        set(ui_popup_group,'Enable','off')
        set(ui_text_M,'Enable','off')
        set(ui_edit_M,'Enable','off')
        set(ui_text_swaps,'Enable','off')
        set(ui_edit_swaps,'Enable','off')
    end
    function activate_components()
        
        set(ui_table_calc,'Enable','on')
        set(ui_button_calc_selectall,'Enable','on')
        set(ui_button_calc_clearselection,'Enable','on')
        set(ui_button_calc_global,'Enable','on')
        set(ui_button_calc_nodal,'Enable','on')
        set(ui_popup_group,'Enable','on')
        set(ui_text_M,'Enable','on')
        set(ui_edit_M,'Enable','on')
        set(ui_text_swaps,'Enable','on')
        set(ui_edit_swaps,'Enable','on')
    end
    function cb_stop(src,~)  % (src,event)
        deactivate_components()
        start = tic;
        if strcmp(get(src,'String'),'Calculate measures')
            if ga.getCohort().groupnumber()>0
                if isempty(selected_calc)
                    errordlg('Select measures to be calculated','Select measures','modal');
                    activate_components()
                else
                    set(ui_button_stop,'String','stop')
                    g = get(ui_popup_group,'Value');
                    mlist = mlist(selected_calc);
                    M = str2num(get(ui_edit_M,'String'));
                    swaps = str2num(get(ui_edit_swaps,'String'));
                   
                    calculate(ga,mlist,g,M,swaps)
                end
            else
                errordlg('Define a group in order to perform calculations','Define a group','modal');
                activate_components()
            end
            
        else if strcmp(get(src,'String'),'stop')
                set(ui_button_stop,'String','Calculate measures')
                set(ui_button_stop,'Enable','off')
                set(ui_button_resume,'Enable','on')
                stop = true;
            end
        end
        set(ui_button_stop,'String','Calculate measures')
    end
    function cb_resume(~,~)  % (src,event)
        stop = false;
        set(ui_button_stop,'Enable','on')
        set(ui_button_resume,'Enable','off')
        set(ui_button_stop,'String','stop')
        g = get(ui_popup_group,'Value');
        M = str2num(get(ui_edit_M,'String'));
        swaps = str2num(get(ui_edit_swaps,'String'));
        
        calculate(ga,mlist,g,M,swaps)
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
    function cb_edit_M(~,~)  % (src,event)
        M = ceil(real(str2num(get(ui_edit_M,'String'))));
        if isempty(M) || M<2
            set(ui_edit_M,'String','2')
        elseif M>1e+6
            set(ui_edit_M,'String','1000000')
        else
            set(ui_edit_M,'String',num2str(M))
        end   
    end
    function cb_edit_swaps(~,~)  % (src,event)
        swaps = ceil(real(str2num(get(ui_edit_swaps,'String'))));
        if isempty(swaps) || swaps<1
            set(ui_edit_swaps,'String','1')
        elseif swaps>1e+6
            set(ui_edit_swaps,'String','1000000')
        else
            set(ui_edit_swaps,'String',num2str(swaps))
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
        set(ui_popup_group,'String',GroupList)
    end
    function calculate(ga,mlist,g,M,swaps)
        L = 100;
        txt = cell(1,L);
        
            for mi = 1:1:length(mlist)
                
                m = ga.randomcompare(mlist(mi),g,'M',M,'swaps',swaps,'Verbose',false);
                msg = ['time = ' int2str(toc(start)) '.' int2str(mod(toc(start)*10,10)) 's - group = ' int2str(g) ' - ' Graph.NAME{m.getProp(MRIMeasure.CODE)}];

                % visualize status
                txt(2:L) = txt(1:L-1);
                txt{1} = msg;
                set(ui_edit_info,'String',txt)
                
                pause(.001)
                
                if stop
                    break
                end
            end
        if (isempty(mlist) || mi==length(mlist))
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