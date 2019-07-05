function fig_group = GUIMRICohortViewGroup(fig_group,cohort,bg)

% sets position of figure
APPNAME = GUI.MCE_NAME;
FigPosition = [.10 .30 .60 .50];
FigColor = GUI.BKGCOLOR;

% create a figure
if isempty(fig_group) || ~ishandle(fig_group)
    fig_group = figure('Visible','off');
end

set(fig_group,'units','normalized')
set(fig_group,'Position',FigPosition)
set(fig_group,'Color',FigColor)
set(fig_group,'Name',[APPNAME ' : Group settings - ' BNC.VERSION ' - ' cohort.getProp(MRICohort.NAME)])
set(fig_group,'MenuBar','none')
set(fig_group,'Toolbar','none')
set(fig_group,'NumberTitle','off')
set(fig_group,'DockControls','off')

average_data = [];
std_data = [];
% get all group names
data = cell(cohort.groupnumber(),1);
for g = 1:1:cohort.groupnumber()
    data{g,1} = cohort.getGroup(g).getProp(Group.NAME);
end

% initialization
ui_list_gr = uicontrol(fig_group,'Style', 'listbox');
set(ui_list_gr,'Units','normalized')
set(ui_list_gr,'BackgroundColor',GUI.BKGCOLOR)
set(ui_list_gr,'String',data)
set(ui_list_gr,'Value',1)
set(ui_list_gr,'Max',2,'Min',0)
set(ui_list_gr,'BackgroundColor',[1 1 1])
set(ui_list_gr,'Position',[.02 .02 .20 .96])
set(ui_list_gr,'TooltipString','Select brain regions');
set(ui_list_gr,'Callback',{@cb_list_gr});

ui_text_average = uicontrol(fig_group,'Style','text');
set(ui_text_average,'Units','normalized')
set(ui_text_average,'Position',[0.3475 .935 .15 .05])
set(ui_text_average,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_average,'String','average')
set(ui_text_average,'HorizontalAlignment','center')
set(ui_text_average,'FontWeight','bold')

ui_text_std = uicontrol(fig_group,'Style','text');
set(ui_text_std,'Units','normalized')
set(ui_text_std,'Position',[0.7275 .935 .15 .05])
set(ui_text_std,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_std,'String','standard deviation')
set(ui_text_std,'HorizontalAlignment','center')
set(ui_text_std,'FontWeight','bold')

ui_panel_ave_scaling = uipanel();
ui_text_ave_offset = uicontrol(fig_group,'Style','text');
ui_edit_ave_offset = uicontrol(fig_group,'Style','edit');
ui_text_ave_rescaling = uicontrol(fig_group,'Style','text');
ui_edit_ave_rescaling = uicontrol(fig_group,'Style','edit');
ui_checkbox_ave_abs = uicontrol(fig_group,'Style', 'checkbox');
ui_button_ave_automatic = uicontrol(fig_group,'Style','pushbutton');
ui_checkbox_ave_symbolsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_ave_symbolsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_ave_symbolcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_ave_initcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_ave_fincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_ave_sphereradius = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_ave_sphereradius = uicontrol(fig_group,'Style','edit');
ui_checkbox_ave_spherecolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_ave_sphinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_ave_sphfincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_ave_spheretransparency = uicontrol(fig_group,'Style', 'checkbox');
ui_slider_ave_spheretransparency = uicontrol(fig_group,'Style','slider');
ui_checkbox_ave_labelsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_ave_labelsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_ave_labelcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_ave_labelinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_ave_labelfincolor = uicontrol(fig_group,'Style','popup','String',{''});

ui_panel_std_scaling = uipanel();
ui_text_std_offset = uicontrol(fig_group,'Style','text');
ui_edit_std_offset = uicontrol(fig_group,'Style','edit');
ui_text_std_rescaling = uicontrol(fig_group,'Style','text');
ui_edit_std_rescaling = uicontrol(fig_group,'Style','edit');
ui_checkbox_std_abs = uicontrol(fig_group,'Style', 'checkbox');
ui_button_std_automatic = uicontrol(fig_group,'Style','pushbutton');
ui_checkbox_std_symbolsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_std_symbolsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_std_symbolcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_std_initcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_std_fincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_std_sphereradius = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_std_sphereradius = uicontrol(fig_group,'Style','edit');
ui_checkbox_std_spherecolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_std_sphinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_std_sphfincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_std_spheretransparency = uicontrol(fig_group,'Style', 'checkbox');
ui_slider_std_spheretransparency = uicontrol(fig_group,'Style','slider');
ui_checkbox_std_labelsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_std_labelsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_std_labelcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_std_labelinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_std_labelfincolor = uicontrol(fig_group,'Style','popup','String',{''});

init_gr_ave()
init_gr_std()
update_average_data();
update_std_data();

set(fig_group,'Visible','on')

    function update_average_data()
        i = get(ui_list_gr,'Value');
        if isempty(i) || length(i)>1
            i = 1;
        end
        
        if get(ui_checkbox_ave_abs,'Value')
            average_data = mean(abs(cohort.getSubjectData(i)),1);
        else
            average_data = cohort.mean(i);
        end
    end
    function update_std_data()
        i = get(ui_list_gr,'Value');
        if isempty(i) || length(i)>1
            i = 1;
        end
        
        if get(ui_checkbox_std_abs,'Value')
            std_data = std(abs(cohort.getSubjectData(i)),1);
        else
            std_data = cohort.std(i);
        end
    end
    function init_gr_ave()
        
        set(ui_panel_ave_scaling,'Parent',fig_group)
        set(ui_panel_ave_scaling,'Position',[.24 .68 .3650 .2550])
        
        set(ui_text_ave_offset,'Units','normalized')
        set(ui_text_ave_offset,'Position',[.26 .845 .10 .05])
        set(ui_text_ave_offset,'String','offset')
        set(ui_text_ave_offset,'HorizontalAlignment','left')
        set(ui_text_ave_offset,'FontWeight','bold')
        
        set(ui_edit_ave_offset,'Units','normalized')
        set(ui_edit_ave_offset,'String','0')
        set(ui_edit_ave_offset,'Enable','on')
        set(ui_edit_ave_offset,'Position',[.36 .85 .05 .05])
        set(ui_edit_ave_offset,'HorizontalAlignment','center')
        set(ui_edit_ave_offset,'FontWeight','bold')
        set(ui_edit_ave_offset,'Callback',{@cb_edit_ave_offset})
        
        set(ui_text_ave_rescaling,'Units','normalized')
        set(ui_text_ave_rescaling,'Position',[.26 .725 .10 .05])
        set(ui_text_ave_rescaling,'String','rescale')
        set(ui_text_ave_rescaling,'HorizontalAlignment','left')
        set(ui_text_ave_rescaling,'FontWeight','bold')

        set(ui_edit_ave_rescaling,'Units','normalized')
        set(ui_edit_ave_rescaling,'String','10')
        set(ui_edit_ave_rescaling,'Enable','on')
        set(ui_edit_ave_rescaling,'Position',[.36 .73 .05 .05])
        set(ui_edit_ave_rescaling,'HorizontalAlignment','center')
        set(ui_edit_ave_rescaling,'FontWeight','bold')
        set(ui_edit_ave_rescaling,'Callback',{@cb_edit_ave_rescaling})
        
        set(ui_checkbox_ave_abs,'Units','normalized')
        set(ui_checkbox_ave_abs,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_abs,'Position',[.425 .85 .15 .05])
        set(ui_checkbox_ave_abs,'String',' Absolute value ')
        set(ui_checkbox_ave_abs,'Value',false)
        set(ui_checkbox_ave_abs,'FontWeight','bold')
        set(ui_checkbox_ave_abs,'TooltipString','gets absolute values for rescaling')
        set(ui_checkbox_ave_abs,'Callback',{@cb_checkbox_ave_abs})
        
        set(ui_button_ave_automatic,'Units','normalized')
        set(ui_button_ave_automatic,'Position',[.425 .7 .175 .08])
        set(ui_button_ave_automatic,'String','Automatic rescaling')
        set(ui_button_ave_automatic,'HorizontalAlignment','center')
        set(ui_button_ave_automatic,'Callback',{@cb_ave_automatic})
        
        set(ui_checkbox_ave_symbolsize,'Units','normalized')
        set(ui_checkbox_ave_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_symbolsize,'Position',[.24 .615 .20 .05])
        set(ui_checkbox_ave_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_ave_symbolsize,'Value',false)
        set(ui_checkbox_ave_symbolsize,'FontWeight','bold')
        set(ui_checkbox_ave_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_symbolsize,'Callback',{@cb_checkbox_ave_symbolsize})
        
        set(ui_edit_ave_symbolsize,'Units','normalized')
        set(ui_edit_ave_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_ave_symbolsize,'Enable','off')
        set(ui_edit_ave_symbolsize,'Position',[.4250 .62 .18 .05])
        set(ui_edit_ave_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_ave_symbolsize,'FontWeight','bold')
        set(ui_edit_ave_symbolsize,'Callback',{@cb_edit_ave_symbolsize})
        
        set(ui_checkbox_ave_symbolcolor,'Units','normalized')
        set(ui_checkbox_ave_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_symbolcolor,'Position',[.24 .515 .23 .05])
        set(ui_checkbox_ave_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_ave_symbolcolor,'Value',false)
        set(ui_checkbox_ave_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_ave_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_symbolcolor,'Callback',{@cb_checkbox_ave_symbolcolor})
        
        set(ui_popup_ave_initcolor,'Units','normalized')
        set(ui_popup_ave_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_initcolor,'Enable','off')
        set(ui_popup_ave_initcolor,'Position',[.4250 .52 .08 .05])
        set(ui_popup_ave_initcolor,'String',{'R','G','B'})
        set(ui_popup_ave_initcolor,'Value',3)
        set(ui_popup_ave_initcolor,'TooltipString','Select symbol');
        set(ui_popup_ave_initcolor,'Callback',{@cb_ave_initcolor})
        
        set(ui_popup_ave_fincolor,'Units','normalized')
        set(ui_popup_ave_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_fincolor,'Enable','off')
        set(ui_popup_ave_fincolor,'Position',[0.5250 .52 .08 .05])
        set(ui_popup_ave_fincolor,'String',{'R','G','B'})
        set(ui_popup_ave_fincolor,'Value',1)
        set(ui_popup_ave_fincolor,'TooltipString','Select symbol');
        set(ui_popup_ave_fincolor,'Callback',{@cb_ave_fincolor})
        
        set(ui_checkbox_ave_sphereradius,'Units','normalized')
        set(ui_checkbox_ave_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_sphereradius,'Position',[.24 0.415 .23 .05])
        set(ui_checkbox_ave_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_ave_sphereradius,'Value',false)
        set(ui_checkbox_ave_sphereradius,'FontWeight','bold')
        set(ui_checkbox_ave_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_sphereradius,'Callback',{@cb_checkbox_ave_sphereradius})
        
        set(ui_edit_ave_sphereradius,'Units','normalized')
        set(ui_edit_ave_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_ave_sphereradius,'Enable','off')
        set(ui_edit_ave_sphereradius,'Position',[.4250 0.42 .18 .05])
        set(ui_edit_ave_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_ave_sphereradius,'FontWeight','bold')
        set(ui_edit_ave_sphereradius,'Callback',{@cb_edit_ave_sphereradius})
        
        set(ui_checkbox_ave_spherecolor,'Units','normalized')
        set(ui_checkbox_ave_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_spherecolor,'Position',[.24 0.315 .45 .05])
        set(ui_checkbox_ave_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_ave_spherecolor,'Value',false)
        set(ui_checkbox_ave_spherecolor,'FontWeight','bold')
        set(ui_checkbox_ave_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_spherecolor,'Callback',{@cb_checkbox_ave_spherecolor})
        
        set(ui_popup_ave_sphinitcolor,'Units','normalized')
        set(ui_popup_ave_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_sphinitcolor,'Enable','off')
        set(ui_popup_ave_sphinitcolor,'Position',[.4250 .32 .08 .05])
        set(ui_popup_ave_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_ave_sphinitcolor,'Value',1)
        set(ui_popup_ave_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_ave_sphinitcolor,'Callback',{@cb_ave_sphinitcolor})
        
        set(ui_popup_ave_sphfincolor,'Units','normalized')
        set(ui_popup_ave_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_sphfincolor,'Enable','off')
        set(ui_popup_ave_sphfincolor,'Position',[0.5250 .32 .08 .05])
        set(ui_popup_ave_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_ave_sphfincolor,'Value',3)
        set(ui_popup_ave_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_ave_sphfincolor,'Callback',{@cb_ave_sphfincolor})
        
        set(ui_checkbox_ave_spheretransparency,'Units','normalized')
        set(ui_checkbox_ave_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_spheretransparency,'Position',[.24 0.215 .25 .05])
        set(ui_checkbox_ave_spheretransparency,'String',' Sphere Transparency ')
        set(ui_checkbox_ave_spheretransparency,'Value',false)
        set(ui_checkbox_ave_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_ave_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_spheretransparency,'Callback',{@cb_checkbox_ave_spheretransparency})
        
        set(ui_slider_ave_spheretransparency,'Units','normalized')
        set(ui_slider_ave_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_ave_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_ave_spheretransparency,'Enable','off')
        set(ui_slider_ave_spheretransparency,'Position',[.4250 0.22 .18 .05])
        set(ui_slider_ave_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_ave_spheretransparency,'Callback',{@cb_slider_ave_spheretransparency})
        
        set(ui_checkbox_ave_labelsize,'Units','normalized')
        set(ui_checkbox_ave_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_labelsize,'Position',[.24 .115 .20 .05])
        set(ui_checkbox_ave_labelsize,'String',' Label Size ')
        set(ui_checkbox_ave_labelsize,'Value',false)
        set(ui_checkbox_ave_labelsize,'FontWeight','bold')
        set(ui_checkbox_ave_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_labelsize,'Callback',{@cb_checkbox_ave_labelsize})
        
        set(ui_edit_ave_labelsize,'Units','normalized')
        set(ui_edit_ave_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_ave_labelsize,'Enable','off')
        set(ui_edit_ave_labelsize,'Position',[.4250 .12 .18 .05])
        set(ui_edit_ave_labelsize,'HorizontalAlignment','center')
        set(ui_edit_ave_labelsize,'FontWeight','bold')
        set(ui_edit_ave_labelsize,'Callback',{@cb_edit_ave_labelsize})
        
        set(ui_checkbox_ave_labelcolor,'Units','normalized')
        set(ui_checkbox_ave_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_ave_labelcolor,'Position',[.24 0.0150 .20 .05])
        set(ui_checkbox_ave_labelcolor,'String',' Label Color ')
        set(ui_checkbox_ave_labelcolor,'Value',false)
        set(ui_checkbox_ave_labelcolor,'FontWeight','bold')
        set(ui_checkbox_ave_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_ave_labelcolor,'Callback',{@cb_checkbox_ave_labelcolor})
        
        set(ui_popup_ave_labelinitcolor,'Units','normalized')
        set(ui_popup_ave_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_labelinitcolor,'Enable','off')
        set(ui_popup_ave_labelinitcolor,'Position',[.4250 .02 .08 .05])
        set(ui_popup_ave_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_ave_labelinitcolor,'Value',1)
        set(ui_popup_ave_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_ave_labelinitcolor,'Callback',{@cb_ave_labelinitcolor})
        
        set(ui_popup_ave_labelfincolor,'Units','normalized')
        set(ui_popup_ave_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_ave_labelfincolor,'Enable','off')
        set(ui_popup_ave_labelfincolor,'Position',[0.5250 .02 .08 .05])
        set(ui_popup_ave_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_ave_labelfincolor,'Value',3)
        set(ui_popup_ave_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_ave_labelfincolor,'Callback',{@cb_ave_labelfincolor})
        
        
    end
    function init_gr_std()
        
        set(ui_panel_std_scaling,'Parent',fig_group)
        set(ui_panel_std_scaling,'Position',[.62 .68 .3650 .2550])
        
        set(ui_text_std_offset,'Units','normalized')
        set(ui_text_std_offset,'Enable','on')
        set(ui_text_std_offset,'Position',[.64 .845 .10 .05])
        set(ui_text_std_offset,'String','offset')
        set(ui_text_std_offset,'HorizontalAlignment','left')
        set(ui_text_std_offset,'FontWeight','bold')
        
        set(ui_edit_std_offset,'Units','normalized')
        set(ui_edit_std_offset,'String','0')
        set(ui_edit_std_offset,'Enable','on')
        set(ui_edit_std_offset,'Position',[.74 .85 .05 .05])
        set(ui_edit_std_offset,'HorizontalAlignment','center')
        set(ui_edit_std_offset,'FontWeight','bold')
        set(ui_edit_std_offset,'Callback',{@cb_edit_std_offset})
        
        set(ui_text_std_rescaling,'Units','normalized')
        set(ui_text_std_rescaling,'Enable','on')
        set(ui_text_std_rescaling,'Position',[.64 .725 .10 .05])
        set(ui_text_std_rescaling,'String','rescale')
        set(ui_text_std_rescaling,'HorizontalAlignment','left')
        set(ui_text_std_rescaling,'FontWeight','bold')
       
        set(ui_edit_std_rescaling,'Units','normalized')
        set(ui_edit_std_rescaling,'String','10')
        set(ui_edit_std_rescaling,'Enable','on')
        set(ui_edit_std_rescaling,'Position',[.74 .73 .05 .05])
        set(ui_edit_std_rescaling,'HorizontalAlignment','center')
        set(ui_edit_std_rescaling,'FontWeight','bold')
        set(ui_edit_std_rescaling,'Callback',{@cb_edit_std_rescaling})
        
        set(ui_checkbox_std_abs,'Units','normalized')
        set(ui_checkbox_std_abs,'Enable','on')
        set(ui_checkbox_std_abs,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_abs,'Position',[.8050 .85 .15 .05])
        set(ui_checkbox_std_abs,'String',' Absolute value ')
        set(ui_checkbox_std_abs,'Value',false)
        set(ui_checkbox_std_abs,'FontWeight','bold')
        set(ui_checkbox_std_abs,'TooltipString','gets absolute values for rescaling')
        set(ui_checkbox_std_abs,'Callback',{@cb_checkbox_std_abs})
        
        set(ui_button_std_automatic,'Units','normalized')
        set(ui_button_std_automatic,'Enable','on')
        set(ui_button_std_automatic,'Position',[.8050 .70 .175 .08])
        set(ui_button_std_automatic,'String','Automatic rescaling')
        set(ui_button_std_automatic,'HorizontalAlignment','center')
        set(ui_button_std_automatic,'Callback',{@cb_std_automatic})
        
        set(ui_checkbox_std_symbolsize,'Units','normalized')
        set(ui_checkbox_std_symbolsize,'Enable','on')
        set(ui_checkbox_std_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_symbolsize,'Position',[.62 .615 .20 .05])
        set(ui_checkbox_std_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_std_symbolsize,'Value',false)
        set(ui_checkbox_std_symbolsize,'FontWeight','bold')
        set(ui_checkbox_std_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_symbolsize,'Callback',{@cb_checkbox_std_symbolsize})
        
        set(ui_edit_std_symbolsize,'Units','normalized')
        set(ui_edit_std_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_std_symbolsize,'Enable','off')
        set(ui_edit_std_symbolsize,'Position',[.8050 .62 .18 .05])
        set(ui_edit_std_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_std_symbolsize,'FontWeight','bold')
        set(ui_edit_std_symbolsize,'Callback',{@cb_edit_std_symbolsize})
        
        set(ui_checkbox_std_symbolcolor,'Units','normalized')
        set(ui_checkbox_std_symbolcolor,'Enable','on')
        set(ui_checkbox_std_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_symbolcolor,'Position',[.62 .515 .23 .05])
        set(ui_checkbox_std_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_std_symbolcolor,'Value',false)
        set(ui_checkbox_std_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_std_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_symbolcolor,'Callback',{@cb_checkbox_std_symbolcolor})
        
        set(ui_popup_std_initcolor,'Units','normalized')
        set(ui_popup_std_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_initcolor,'Enable','off')
        set(ui_popup_std_initcolor,'Position',[.8050 .52 .08 .05])
        set(ui_popup_std_initcolor,'String',{'R','G','B'})
        set(ui_popup_std_initcolor,'Value',3)
        set(ui_popup_std_initcolor,'TooltipString','Select symbol');
        set(ui_popup_std_initcolor,'Callback',{@cb_std_initcolor})
        
        set(ui_popup_std_fincolor,'Units','normalized')
        set(ui_popup_std_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_fincolor,'Enable','off')
        set(ui_popup_std_fincolor,'Position',[0.9050 .52 .08 .05])
        set(ui_popup_std_fincolor,'String',{'R','G','B'})
        set(ui_popup_std_fincolor,'Value',1)
        set(ui_popup_std_fincolor,'TooltipString','Select symbol');
        set(ui_popup_std_fincolor,'Callback',{@cb_std_fincolor})
        
        set(ui_checkbox_std_sphereradius,'Units','normalized')
        set(ui_checkbox_std_sphereradius,'Enable','on')
        set(ui_checkbox_std_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_sphereradius,'Position',[.62 0.415 .23 .05])
        set(ui_checkbox_std_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_std_sphereradius,'Value',false)
        set(ui_checkbox_std_sphereradius,'FontWeight','bold')
        set(ui_checkbox_std_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_sphereradius,'Callback',{@cb_checkbox_std_sphereradius})
        
        set(ui_edit_std_sphereradius,'Units','normalized')
        set(ui_edit_std_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_std_sphereradius,'Enable','off')
        set(ui_edit_std_sphereradius,'Position',[.8050 0.42 .18 .05])
        set(ui_edit_std_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_std_sphereradius,'FontWeight','bold')
        set(ui_edit_std_sphereradius,'Callback',{@cb_edit_std_sphereradius})
        
        set(ui_checkbox_std_spherecolor,'Units','normalized')
        set(ui_checkbox_std_spherecolor,'Enable','on')
        set(ui_checkbox_std_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_spherecolor,'Position',[.62 0.315 .45 .05])
        set(ui_checkbox_std_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_std_spherecolor,'Value',false)
        set(ui_checkbox_std_spherecolor,'FontWeight','bold')
        set(ui_checkbox_std_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_spherecolor,'Callback',{@cb_checkbox_std_spherecolor})
        
        set(ui_popup_std_sphinitcolor,'Units','normalized')
        set(ui_popup_std_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_sphinitcolor,'Enable','off')
        set(ui_popup_std_sphinitcolor,'Position',[.8050 .32 .08 .05])
        set(ui_popup_std_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_std_sphinitcolor,'Value',1)
        set(ui_popup_std_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_std_sphinitcolor,'Callback',{@cb_std_sphinitcolor})
        
        set(ui_popup_std_sphfincolor,'Units','normalized')
        set(ui_popup_std_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_sphfincolor,'Enable','off')
        set(ui_popup_std_sphfincolor,'Position',[0.9050 .32 .08 .05])
        set(ui_popup_std_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_std_sphfincolor,'Value',3)
        set(ui_popup_std_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_std_sphfincolor,'Callback',{@cb_std_sphfincolor})
        
        set(ui_checkbox_std_spheretransparency,'Units','normalized')
        set(ui_checkbox_std_spheretransparency,'Enable','on')
        set(ui_checkbox_std_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_spheretransparency,'Position',[.62 0.215 .25 .05])
        set(ui_checkbox_std_spheretransparency,'String',' Sphere Transparency ')
        set(ui_checkbox_std_spheretransparency,'Value',false)
        set(ui_checkbox_std_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_std_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_spheretransparency,'Callback',{@cb_checkbox_std_spheretransparency})
        
        set(ui_slider_std_spheretransparency,'Units','normalized')
        set(ui_slider_std_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_std_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_std_spheretransparency,'Enable','off')
        set(ui_slider_std_spheretransparency,'Position',[.8050 0.22 .18 .05])
        set(ui_slider_std_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_std_spheretransparency,'Callback',{@cb_slider_std_spheretransparency})
        
        set(ui_checkbox_std_labelsize,'Units','normalized')
        set(ui_checkbox_std_labelsize,'Enable','on')
        set(ui_checkbox_std_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_labelsize,'Position',[.62 .115 .20 .05])
        set(ui_checkbox_std_labelsize,'String',' Label Size ')
        set(ui_checkbox_std_labelsize,'Value',false)
        set(ui_checkbox_std_labelsize,'FontWeight','bold')
        set(ui_checkbox_std_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_labelsize,'Callback',{@cb_checkbox_std_labelsize})
        
        set(ui_edit_std_labelsize,'Units','normalized')
        set(ui_edit_std_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_std_labelsize,'Enable','off')
        set(ui_edit_std_labelsize,'Position',[.8050 .12 .18 .05])
        set(ui_edit_std_labelsize,'HorizontalAlignment','center')
        set(ui_edit_std_labelsize,'FontWeight','bold')
        set(ui_edit_std_labelsize,'Callback',{@cb_edit_std_labelsize})
        
        set(ui_checkbox_std_labelcolor,'Units','normalized')
        set(ui_checkbox_std_labelcolor,'Enable','on')
        set(ui_checkbox_std_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_std_labelcolor,'Position',[.62 0.0150 .20 .05])
        set(ui_checkbox_std_labelcolor,'String',' Label Color ')
        set(ui_checkbox_std_labelcolor,'Value',false)
        set(ui_checkbox_std_labelcolor,'FontWeight','bold')
        set(ui_checkbox_std_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_std_labelcolor,'Callback',{@cb_checkbox_std_labelcolor})
        
        set(ui_popup_std_labelinitcolor,'Units','normalized')
        set(ui_popup_std_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_labelinitcolor,'Enable','off')
        set(ui_popup_std_labelinitcolor,'Position',[.8050 .02 .08 .05])
        set(ui_popup_std_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_std_labelinitcolor,'Value',1)
        set(ui_popup_std_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_std_labelinitcolor,'Callback',{@cb_std_labelinitcolor})
        
        set(ui_popup_std_labelfincolor,'Units','normalized')
        set(ui_popup_std_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_std_labelfincolor,'Enable','off')
        set(ui_popup_std_labelfincolor,'Position',[0.9050 .02 .08 .05])
        set(ui_popup_std_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_std_labelfincolor,'Value',3)
        set(ui_popup_std_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_std_labelfincolor,'Callback',{@cb_std_labelfincolor})
        
    end
    
    function cb_list_gr(src,~)
        oldValues = get(src,'UserData');
        newValues = get(src,'Value');
        if numel(newValues) > 1
            newValues = oldValues;
        end
        set(src,'Value',newValues)
        set(src,'UserData',newValues)
        
        update_average_data()
        update_std_data()
        update_brain_ave_plot()
        update_brain_std_plot()
        
    end
    function cb_edit_ave_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_ave_offset,'String')));
        if isempty(offset)
            set(ui_edit_ave_offset,'String','0')
        else
            set(ui_edit_ave_offset,'String',num2str(offset))
        end
        update_brain_ave_plot()
    end
    function cb_edit_ave_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_ave_rescaling,'String')));
        if isempty(rescaling) || rescaling<10^(-3) || rescaling>10^+3
            set(ui_edit_ave_rescaling,'String','10')
        else
            set(ui_edit_ave_rescaling,'String',num2str(rescaling))
        end
        update_brain_ave_plot()
    end
    function cb_checkbox_ave_abs(~,~)  %  (src,event)
        update_average_data()
        update_brain_ave_plot()
    end
    function cb_ave_automatic(~,~)  %  (src,event)
        offset = min(average_data);
        rescaling = max(average_data) - offset;
        
        set(ui_edit_ave_offset,'String',num2str(offset))
        set(ui_edit_ave_rescaling,'String',num2str(rescaling))
        
        update_brain_ave_plot()
    end
    function cb_checkbox_ave_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_ave_symbolsize,'Value')
            set(ui_edit_ave_symbolsize,'Enable','on')
            set(ui_checkbox_std_symbolsize,'Enable','off')
            
            update_brain_ave_plot()
        else
            size = str2num(get(ui_edit_ave_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_ave_symbolsize,'Enable','off')
            set(ui_checkbox_std_symbolsize,'Enable','on');
            update_brain_ave_plot()
        end
    end
    function cb_edit_ave_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_ave_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_ave_symbolsize,'String','1')
            size = 5;
        end
        update_brain_ave_plot()
    end

    function cb_checkbox_ave_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_ave_symbolcolor,'Value')
            set(ui_popup_ave_initcolor,'Enable','on')
            set(ui_popup_ave_fincolor,'Enable','on')
            set(ui_checkbox_std_symbolcolor,'Enable','off')
                        
            update_brain_ave_plot()
        else
            val = get(ui_popup_ave_initcolor,'Value');
            str = get(ui_popup_ave_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_ave_initcolor,'Enable','off')
            set(ui_popup_ave_fincolor,'Enable','off')
            set(ui_checkbox_std_symbolcolor,'Enable','on');
            
            update_brain_ave_plot()
        end
    end
    function cb_ave_initcolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end
    function cb_ave_fincolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end

    function cb_checkbox_ave_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_ave_sphereradius,'Value')
            set(ui_edit_ave_sphereradius,'Enable','on')
            set(ui_checkbox_std_sphereradius,'Enable','off')
            update_brain_ave_plot()
        else
            R = str2num(get(ui_edit_ave_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);
            
            set(ui_edit_ave_sphereradius,'Enable','off')
            set(ui_checkbox_std_sphereradius,'Enable','on')
            update_brain_ave_plot()
        end
    end
    function cb_edit_ave_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_ave_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_ave_sphereradius,'String','1')
            R = 3;
        end
        update_brain_ave_plot()
    end

    function cb_checkbox_ave_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_ave_spherecolor,'Value')
            set(ui_popup_ave_sphinitcolor,'Enable','on')
            set(ui_popup_ave_sphfincolor,'Enable','on')
            set(ui_checkbox_std_spherecolor,'Enable','off')
            update_brain_ave_plot()
        else
            val = get(ui_popup_ave_sphinitcolor,'Value');
            str = get(ui_popup_ave_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_ave_sphinitcolor,'Enable','off')
            set(ui_popup_ave_sphfincolor,'Enable','off')
            set(ui_checkbox_std_spherecolor,'Enable','on')
            update_brain_ave_plot()
        end
    end
    function cb_ave_sphinitcolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end
    function cb_ave_sphfincolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end

    function cb_checkbox_ave_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_ave_spheretransparency,'Value')
            set(ui_slider_ave_spheretransparency,'Enable','on')
            set(ui_checkbox_std_spheretransparency,'Enable','off')
            update_brain_ave_plot()
        else
            alpha = get(ui_slider_ave_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_ave_spheretransparency,'Enable','off')
            set(ui_checkbox_std_spheretransparency,'Enable','on')
            update_brain_ave_plot()
        end
    end
    function cb_slider_ave_spheretransparency(~,~)  %  (src,event)
        update_brain_ave_plot();
    end

    function cb_checkbox_ave_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_ave_labelsize,'Value')
            set(ui_edit_ave_labelsize,'Enable','on')
            set(ui_checkbox_std_labelsize,'Enable','off')
            update_brain_ave_plot()
        else
            size = str2num(get(ui_edit_ave_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);
            
            set(ui_edit_ave_labelsize,'Enable','off')
            set(ui_checkbox_std_labelsize,'Enable','on')
            update_brain_ave_plot()
        end
    end
    function cb_edit_ave_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_ave_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_ave_labelsize,'String','1')
            size = 5;
        end
        update_brain_ave_plot()
    end

    function cb_checkbox_ave_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_ave_labelcolor,'Value')
            set(ui_popup_ave_labelinitcolor,'Enable','on')
            set(ui_popup_ave_labelfincolor,'Enable','on')
            set(ui_checkbox_std_labelcolor,'Enable','off')
            update_brain_ave_plot()
        else
            val = get(ui_popup_ave_labelinitcolor,'Value');
            str = get(ui_popup_ave_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});
            
            set(ui_popup_ave_labelinitcolor,'Enable','off')
            set(ui_popup_ave_labelfincolor,'Enable','off')
            set(ui_checkbox_std_labelcolor,'Enable','on')
            update_brain_ave_plot()
        end
    end
    function cb_ave_labelinitcolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end
    function cb_ave_labelfincolor(~,~)  %  (src,event)
        update_brain_ave_plot()
    end
    
    function update_brain_ave_plot()
               
        if get(ui_checkbox_ave_symbolsize,'Value')
            
            size = str2num(get(ui_edit_ave_symbolsize,'String'));
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            size = 1 + ((average_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_ave_symbolcolor,'Value')
            
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            colorValue = (average_data - offset)./rescaling;
            %colorValue = (average_data - min(average_data))./(max(average_data)-min(average_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_ave_initcolor,'Value');
            val2 = get(ui_popup_ave_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_ave_sphereradius,'Value')
            
            R = str2num(get(ui_edit_ave_sphereradius,'String'));
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            R = 1 + ((average_data - offset)./rescaling)*R;
            R(R<=0) = 0.1;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_ave_spherecolor,'Value')
            
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            colorValue = (average_data - offset)./rescaling;
            %colorValue = (average_data - min(average_data))./(max(average_data)-min(average_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_ave_sphinitcolor,'Value');
            val2 = get(ui_popup_ave_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_ave_spheretransparency,'Value')
            
            alpha = get(ui_slider_ave_spheretransparency,'Value');
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            alpha_vec = ((average_data - offset)./rescaling).*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_ave_labelsize,'Value')
            
            size = str2num(get(ui_edit_ave_labelsize,'String'));
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            size = 1 + ((average_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_ave_labelcolor,'Value')
            
            offset = str2num(get(ui_edit_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_ave_rescaling,'String'));
            
            colorValue = (average_data - offset)./rescaling;
            %colorValue = (average_data - min(average_data))./(max(average_data)-min(average_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_ave_labelinitcolor,'Value');
            val2 = get(ui_popup_ave_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
        
    end

    function cb_edit_std_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_std_offset,'String')));
        if isempty(offset)
            set(ui_edit_std_offset,'String','0')
        else
            set(ui_edit_std_offset,'String',num2str(offset))
        end
        update_brain_std_plot()
    end
    function cb_edit_std_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_std_rescaling,'String')));
        if isempty(rescaling) || rescaling<10^(-3) || rescaling>10^+3
            set(ui_edit_std_rescaling,'String','10')
        else
            set(ui_edit_std_rescaling,'String',num2str(rescaling))
        end
        update_brain_std_plot()
    end
    function cb_checkbox_std_abs(~,~)  %  (src,event)
        update_std_data()
        update_brain_std_plot()
    end
    function cb_std_automatic(~,~)  %  (src,event)
        offset = min(std_data);
        rescaling = max(std_data) - offset;

        set(ui_edit_std_offset,'String',num2str(offset))
        set(ui_edit_std_rescaling,'String',num2str(rescaling))
        
        update_brain_std_plot()
    end

    function cb_checkbox_std_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_std_symbolsize,'Value')
            set(ui_edit_std_symbolsize,'Enable','on')
            set(ui_checkbox_ave_symbolsize,'Enable','off')
            update_brain_std_plot()
        else
            size = str2num(get(ui_edit_std_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_std_symbolsize,'Enable','off')
            set(ui_checkbox_ave_symbolsize,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_edit_std_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_std_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_std_symbolsize,'String','1')
            size = 5;
        end
        update_brain_std_plot()
    end

    function cb_checkbox_std_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_std_symbolcolor,'Value')
            set(ui_popup_std_initcolor,'Enable','on')
            set(ui_popup_std_fincolor,'Enable','on')
            set(ui_checkbox_ave_symbolcolor,'Enable','off')
            update_brain_std_plot()
        else
            val = get(ui_popup_std_initcolor,'Value');
            str = get(ui_popup_std_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_std_initcolor,'Enable','off')
            set(ui_popup_std_fincolor,'Enable','off')
            set(ui_checkbox_ave_symbolcolor,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_std_initcolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end
    function cb_std_fincolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end

    function cb_checkbox_std_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_std_sphereradius,'Value')
            set(ui_edit_std_sphereradius,'Enable','on')
            set(ui_checkbox_ave_sphereradius,'Enable','off')
            update_brain_std_plot()
        else
            R = str2num(get(ui_edit_std_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);
            
            set(ui_edit_std_sphereradius,'Enable','off')
            set(ui_checkbox_ave_sphereradius,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_edit_std_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_std_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_std_sphereradius,'String','1')
            R = 3;
        end
        update_brain_std_plot()
    end

    function cb_checkbox_std_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_std_spherecolor,'Value')
            set(ui_popup_std_sphinitcolor,'Enable','on')
            set(ui_popup_std_sphfincolor,'Enable','on')
            set(ui_checkbox_ave_spherecolor,'Enable','off')
            update_brain_std_plot()
        else
            val = get(ui_popup_std_sphinitcolor,'Value');
            str = get(ui_popup_std_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_std_sphinitcolor,'Enable','off')
            set(ui_popup_std_sphfincolor,'Enable','off')
            set(ui_checkbox_ave_spherecolor,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_std_sphinitcolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end
    function cb_std_sphfincolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end

    function cb_checkbox_std_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_std_spheretransparency,'Value')
            set(ui_slider_std_spheretransparency,'Enable','on')
            set(ui_checkbox_ave_spheretransparency,'Enable','off')
            update_brain_std_plot()
        else
            alpha = get(ui_slider_std_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_std_spheretransparency,'Enable','off')
            set(ui_checkbox_ave_spheretransparency,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_slider_std_spheretransparency(~,~)  %  (src,event)
        update_brain_std_plot();
    end

    function cb_checkbox_std_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_std_labelsize,'Value')
            set(ui_edit_std_labelsize,'Enable','on')
            set(ui_checkbox_ave_labelsize,'Enable','off')
            update_brain_std_plot()
        else
            size = str2num(get(ui_edit_std_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);
            
            set(ui_edit_std_labelsize,'Enable','off')
            set(ui_checkbox_ave_labelsize,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_edit_std_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_std_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_std_labelsize,'String','1')
            size = 5;
        end
        update_brain_std_plot()
    end

    function cb_checkbox_std_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_std_labelcolor,'Value')
            set(ui_popup_std_labelinitcolor,'Enable','on')
            set(ui_popup_std_labelfincolor,'Enable','on')
            set(ui_checkbox_ave_labelcolor,'Enable','off')
            update_brain_std_plot()
        else
            val = get(ui_popup_std_labelinitcolor,'Value');
            str = get(ui_popup_std_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});
            
            set(ui_popup_std_labelinitcolor,'Enable','off')
            set(ui_popup_std_labelfincolor,'Enable','off')
            set(ui_checkbox_ave_labelcolor,'Enable','on')
            update_brain_std_plot()
        end
    end
    function cb_std_labelinitcolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end
    function cb_std_labelfincolor(~,~)  %  (src,event)
        update_brain_std_plot()
    end

    function update_brain_std_plot()
        
        if get(ui_checkbox_std_symbolsize,'Value')
            
            size = str2num(get(ui_edit_std_symbolsize,'String'));
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            size = 1 + ((std_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_std_symbolcolor,'Value')
            
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            colorValue = (std_data - offset)./rescaling;
            %colorValue = (std_data - min(std_data))./(max(std_data)-min(std_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
                        
            val1 = get(ui_popup_std_initcolor,'Value');
            val2 = get(ui_popup_std_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_std_sphereradius,'Value')
            
            R = str2num(get(ui_edit_std_sphereradius,'String'));
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            R = 1 + ((std_data - offset)./rescaling)*R;
            R(R<=0) = 0.1;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_std_spherecolor,'Value')
            
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            colorValue = (std_data - offset)./rescaling;
            %colorValue = (std_data - min(std_data))./(max(std_data)-min(std_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_std_sphinitcolor,'Value');
            val2 = get(ui_popup_std_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_std_spheretransparency,'Value')
            
            alpha = get(ui_slider_std_spheretransparency,'Value');
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            alpha_vec = ((std_data - offset)./rescaling).*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_std_labelsize,'Value')
            
            size = str2num(get(ui_edit_std_labelsize,'String'));
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            size = 1 + ((std_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_std_labelcolor,'Value')
            
            offset = str2num(get(ui_edit_std_offset,'String'));
            rescaling = str2num(get(ui_edit_std_rescaling,'String'));
            
            colorValue = (std_data - offset)./rescaling;
            %colorValue = (std_data - min(std_data))./(max(std_data)-min(std_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_std_labelinitcolor,'Value');
            val2 = get(ui_popup_std_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
        
    end

end