function fig_comparison = GUIPETCohortViewComparison(fig_comparison,cohort,bg)
% sets position of figure
APPNAME = GUI.PCE_NAME;
FigPosition = [.10 .30 .70 .35];
FigColor = GUI.BKGCOLOR;

% create a figure
if isempty(fig_comparison) || ~ishandle(fig_comparison)
    fig_comparison = figure('Visible','off');
end

set(fig_comparison,'units','normalized')
set(fig_comparison,'Position',FigPosition)
set(fig_comparison,'Color',FigColor)
set(fig_comparison,'Name',[APPNAME ' : Comparison settings - ' BNC.VERSION ' - ' cohort.getProp(PETCohort.NAME)])
set(fig_comparison,'MenuBar','none')
set(fig_comparison,'Toolbar','none')
set(fig_comparison,'NumberTitle','off')
set(fig_comparison,'DockControls','off')

comparison_ave_data = [];
comparison_std_data = [];
comparison_pval_data = [];

GroupList = cell(1,cohort.groupnumber());
for g = 1:1:cohort.groupnumber()
    GroupList{g} = cohort.getGroup(g).getProp(Group.NAME);
end
if isempty(GroupList)
    GroupList = {''};
end

% initialization
ui_list_group1 = uicontrol(fig_comparison,'Style', 'listbox');
set(ui_list_group1,'Units','normalized')
set(ui_list_group1,'BackgroundColor',GUI.BKGCOLOR)
set(ui_list_group1,'String',GroupList)
set(ui_list_group1,'Value',1)
set(ui_list_group1,'Max',2,'Min',0)
set(ui_list_group1,'BackgroundColor',[1 1 1])
set(ui_list_group1,'Position',[.01 .505 .20 .43])
set(ui_list_group1,'TooltipString','Select brain regions');
set(ui_list_group1,'Callback',{@cb_list_gr});

ui_text_comp_group1 = uicontrol(fig_comparison,'Style','text');
set(ui_text_comp_group1,'Units','normalized')
set(ui_text_comp_group1,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_comp_group1,'Position',[.085 .94 .05 .05])
set(ui_text_comp_group1,'String','group 1')
set(ui_text_comp_group1,'HorizontalAlignment','center')
set(ui_text_comp_group1,'FontWeight','bold')
        
ui_list_group2 = uicontrol(fig_comparison,'Style', 'listbox');
set(ui_list_group2,'Units','normalized')
set(ui_list_group2,'BackgroundColor',GUI.BKGCOLOR)
set(ui_list_group2,'String',GroupList)
set(ui_list_group2,'Value',1)
set(ui_list_group2,'Max',2,'Min',0)
set(ui_list_group2,'BackgroundColor',[1 1 1])
set(ui_list_group2,'Position',[.01 .02 .20 .43])
set(ui_list_group2,'TooltipString','Select brain regions');
set(ui_list_group2,'Callback',{@cb_list_gr});

ui_text_comp_group2 = uicontrol(fig_comparison,'Style','text');
set(ui_text_comp_group2,'Units','normalized')
set(ui_text_comp_group2,'Position',[.085 .455 .05 .05])
set(ui_text_comp_group2,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_comp_group2,'String','group 2')
set(ui_text_comp_group2,'HorizontalAlignment','center')
set(ui_text_comp_group2,'FontWeight','bold')

ui_text_average = uicontrol(fig_comparison,'Style','text');
set(ui_text_average,'Units','normalized')
set(ui_text_average,'Position',[0.2225 .94 .25 .05])
set(ui_text_average,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_average,'String','Comparison: average')
set(ui_text_average,'HorizontalAlignment','center')
set(ui_text_average,'FontWeight','bold')

ui_text_std = uicontrol(fig_comparison,'Style','text');
set(ui_text_std,'Units','normalized')
set(ui_text_std,'Position',[0.4825 .94 .25 .05])
set(ui_text_std,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_std,'String','Comparison: standard deviation')
set(ui_text_std,'HorizontalAlignment','center')
set(ui_text_std,'FontWeight','bold')

ui_text_pvalue = uicontrol(fig_comparison,'Style','text');
set(ui_text_pvalue,'Units','normalized')
set(ui_text_pvalue,'Position',[0.7425 .94 .25 .05])
set(ui_text_pvalue,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_pvalue,'String','Comparison: p-value')
set(ui_text_pvalue,'HorizontalAlignment','center')
set(ui_text_pvalue,'FontWeight','bold')

ui_panel_comp_ave_scaling = uipanel();
ui_text_comp_ave_offset = uicontrol(fig_comparison,'Style','text');
ui_edit_comp_ave_offset = uicontrol(fig_comparison,'Style','edit');
ui_text_comp_ave_rescaling = uicontrol(fig_comparison,'Style','text');
ui_edit_comp_ave_rescaling = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_ave_abs = uicontrol(fig_comparison,'Style', 'checkbox');
ui_button_comp_ave_automatic = uicontrol(fig_comparison,'Style','pushbutton');
ui_checkbox_comp_ave_symbolsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_ave_symbolsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_ave_symbolcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_ave_initcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_ave_fincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_ave_sphereradius = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_ave_sphereradius = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_ave_spherecolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_ave_sphinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_ave_sphfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_ave_spheretransparency = uicontrol(fig_comparison,'Style', 'checkbox');
ui_slider_comp_ave_spheretransparency = uicontrol(fig_comparison,'Style','slider');
ui_checkbox_comp_ave_labelsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_ave_labelsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_ave_labelcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_ave_labelinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_ave_labelfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});

ui_panel_comp_std_scaling = uipanel();
ui_text_comp_std_offset = uicontrol(fig_comparison,'Style','text');
ui_edit_comp_std_offset = uicontrol(fig_comparison,'Style','edit');
ui_text_comp_std_rescaling = uicontrol(fig_comparison,'Style','text');
ui_edit_comp_std_rescaling = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_std_abs = uicontrol(fig_comparison,'Style', 'checkbox');
ui_button_comp_std_automatic = uicontrol(fig_comparison,'Style','pushbutton');
ui_checkbox_comp_std_symbolsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_std_symbolsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_std_symbolcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_std_initcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_std_fincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_std_sphereradius = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_std_sphereradius = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_std_spherecolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_std_sphinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_std_sphfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_std_spheretransparency = uicontrol(fig_comparison,'Style', 'checkbox');
ui_slider_comp_std_spheretransparency = uicontrol(fig_comparison,'Style','slider');
ui_checkbox_comp_std_labelsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_std_labelsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_std_labelcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_std_labelinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_std_labelfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});

 ui_panel_comp_pval_scaling = uipanel();
ui_checkbox_comp_psingle = uicontrol(fig_comparison,'Style', 'checkbox');
ui_checkbox_comp_pdouble = uicontrol(fig_comparison,'Style', 'checkbox');
ui_checkbox_comp_pval_symbolsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_pval_symbolsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_pval_symbolcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_pval_initcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_pval_fincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_pval_sphereradius = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_pval_sphereradius = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_pval_spherecolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_pval_sphinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_pval_sphfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_checkbox_comp_pval_spheretransparency = uicontrol(fig_comparison,'Style', 'checkbox');
ui_slider_comp_pval_spheretransparency = uicontrol(fig_comparison,'Style','slider');
ui_checkbox_comp_pval_labelsize = uicontrol(fig_comparison,'Style', 'checkbox');
ui_edit_comp_pval_labelsize = uicontrol(fig_comparison,'Style','edit');
ui_checkbox_comp_pval_labelcolor = uicontrol(fig_comparison,'Style', 'checkbox');
ui_popup_comp_pval_labelinitcolor = uicontrol(fig_comparison,'Style','popup','String',{''});
ui_popup_comp_pval_labelfincolor = uicontrol(fig_comparison,'Style','popup','String',{''});


init_average()
init_std()
init_pval()

update_comp_ave()
update_comp_std()
update_comp_pval()

set(fig_comparison,'Visible','on')

    function init_average()
        
        set(ui_panel_comp_ave_scaling,'Parent',fig_comparison)
        set(ui_panel_comp_ave_scaling,'Position',[.22 .68 .2550 .2550])
        
        set(ui_text_comp_ave_offset,'Units','normalized')
        set(ui_text_comp_ave_offset,'Position',[.23 .845 .05 .05])
        set(ui_text_comp_ave_offset,'String','offset')
        set(ui_text_comp_ave_offset,'HorizontalAlignment','left')
        set(ui_text_comp_ave_offset,'FontWeight','bold')
        
        set(ui_edit_comp_ave_offset,'Units','normalized')
        set(ui_edit_comp_ave_offset,'String','0')
        set(ui_edit_comp_ave_offset,'Enable','on')
        set(ui_edit_comp_ave_offset,'Position',[.28 .85 .05 .05])
        set(ui_edit_comp_ave_offset,'HorizontalAlignment','center')
        set(ui_edit_comp_ave_offset,'FontWeight','bold')
        set(ui_edit_comp_ave_offset,'Callback',{@cb_edit_comp_ave_offset})
        
        set(ui_text_comp_ave_rescaling,'Units','normalized')
        set(ui_text_comp_ave_rescaling,'Position',[.23 0.735 .20 .05])
        set(ui_text_comp_ave_rescaling,'String','rescale')
        set(ui_text_comp_ave_rescaling,'HorizontalAlignment','left')
        set(ui_text_comp_ave_rescaling,'FontWeight','bold')
        
        set(ui_edit_comp_ave_rescaling,'Units','normalized')
        set(ui_edit_comp_ave_rescaling,'String','10')
        set(ui_edit_comp_ave_rescaling,'Enable','on')
        set(ui_edit_comp_ave_rescaling,'Position',[.28 .73 .05 .05])
        set(ui_edit_comp_ave_rescaling,'HorizontalAlignment','center')
        set(ui_edit_comp_ave_rescaling,'FontWeight','bold')
        set(ui_edit_comp_ave_rescaling,'Callback',{@cb_edit_comp_ave_rescaling})
        
        set(ui_checkbox_comp_ave_abs,'Units','normalized')
        set(ui_checkbox_comp_ave_abs,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_abs,'Position',[.35 .85 .12 .05])
        set(ui_checkbox_comp_ave_abs,'String',' Absolute value ')
        set(ui_checkbox_comp_ave_abs,'Value',false)
        set(ui_checkbox_comp_ave_abs,'FontWeight','bold')
        set(ui_checkbox_comp_ave_abs,'TooltipString','gets absolute values for rescaling')
        set(ui_checkbox_comp_ave_abs,'Callback',{@cb_checkbox_comp_ave_abs})
        
        set(ui_button_comp_ave_automatic,'Units','normalized')
        set(ui_button_comp_ave_automatic,'Position',[.35 .70 .12 .1])
        set(ui_button_comp_ave_automatic,'String','Automatic rescaling')
        set(ui_button_comp_ave_automatic,'HorizontalAlignment','center')
        set(ui_button_comp_ave_automatic,'Callback',{@cb_comp_ave_automatic})
        
        set(ui_checkbox_comp_ave_symbolsize,'Units','normalized')
        set(ui_checkbox_comp_ave_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_symbolsize,'Position',[.22 .615 .20 .05])
        set(ui_checkbox_comp_ave_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_comp_ave_symbolsize,'Value',false)
        set(ui_checkbox_comp_ave_symbolsize,'FontWeight','bold')
        set(ui_checkbox_comp_ave_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_symbolsize,'Callback',{@cb_checkbox_comp_ave_symbolsize})
        
        set(ui_edit_comp_ave_symbolsize,'Units','normalized')
        set(ui_edit_comp_ave_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_comp_ave_symbolsize,'Enable','off')
        set(ui_edit_comp_ave_symbolsize,'Position',[.360 .62 .115 .05])
        set(ui_edit_comp_ave_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_comp_ave_symbolsize,'FontWeight','bold')
        set(ui_edit_comp_ave_symbolsize,'Callback',{@cb_edit_comp_ave_symbolsize})
        
        set(ui_checkbox_comp_ave_symbolcolor,'Units','normalized')
        set(ui_checkbox_comp_ave_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_symbolcolor,'Position',[.22 .515 .23 .05])
        set(ui_checkbox_comp_ave_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_comp_ave_symbolcolor,'Value',false)
        set(ui_checkbox_comp_ave_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_comp_ave_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_symbolcolor,'Callback',{@cb_checkbox_comp_ave_symbolcolor})
        
        set(ui_popup_comp_ave_initcolor,'Units','normalized')
        set(ui_popup_comp_ave_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_initcolor,'Enable','off')
        set(ui_popup_comp_ave_initcolor,'Position',[.360 .52 .05 .05])
        set(ui_popup_comp_ave_initcolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_initcolor,'Value',3)
        set(ui_popup_comp_ave_initcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_initcolor,'Callback',{@cb_comp_ave_initcolor})
        
        set(ui_popup_comp_ave_fincolor,'Units','normalized')
        set(ui_popup_comp_ave_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_fincolor,'Enable','off')
        set(ui_popup_comp_ave_fincolor,'Position',[.4250 .52 .05 .05])
        set(ui_popup_comp_ave_fincolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_fincolor,'Value',1)
        set(ui_popup_comp_ave_fincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_fincolor,'Callback',{@cb_comp_ave_fincolor})
        
        set(ui_checkbox_comp_ave_sphereradius,'Units','normalized')
        set(ui_checkbox_comp_ave_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_sphereradius,'Position',[.22 0.415 .23 .05])
        set(ui_checkbox_comp_ave_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_comp_ave_sphereradius,'Value',false)
        set(ui_checkbox_comp_ave_sphereradius,'FontWeight','bold')
        set(ui_checkbox_comp_ave_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_sphereradius,'Callback',{@cb_checkbox_comp_ave_sphereradius})
        
        set(ui_edit_comp_ave_sphereradius,'Units','normalized')
        set(ui_edit_comp_ave_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_comp_ave_sphereradius,'Enable','off')
        set(ui_edit_comp_ave_sphereradius,'Position',[.360 0.42 .115 .05])
        set(ui_edit_comp_ave_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_comp_ave_sphereradius,'FontWeight','bold')
        set(ui_edit_comp_ave_sphereradius,'Callback',{@cb_edit_comp_ave_sphereradius})
        
        set(ui_checkbox_comp_ave_spherecolor,'Units','normalized')
        set(ui_checkbox_comp_ave_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_spherecolor,'Position',[.22 0.315 .45 .05])
        set(ui_checkbox_comp_ave_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_comp_ave_spherecolor,'Value',false)
        set(ui_checkbox_comp_ave_spherecolor,'FontWeight','bold')
        set(ui_checkbox_comp_ave_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_spherecolor,'Callback',{@cb_checkbox_comp_ave_spherecolor})
        
        set(ui_popup_comp_ave_sphinitcolor,'Units','normalized')
        set(ui_popup_comp_ave_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_sphinitcolor,'Enable','off')
        set(ui_popup_comp_ave_sphinitcolor,'Position',[.360 .32 .05 .05])
        set(ui_popup_comp_ave_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_sphinitcolor,'Value',1)
        set(ui_popup_comp_ave_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_sphinitcolor,'Callback',{@cb_comp_ave_sphinitcolor})
        
        set(ui_popup_comp_ave_sphfincolor,'Units','normalized')
        set(ui_popup_comp_ave_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_sphfincolor,'Enable','off')
        set(ui_popup_comp_ave_sphfincolor,'Position',[0.4250 .32 .05 .05])
        set(ui_popup_comp_ave_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_sphfincolor,'Value',3)
        set(ui_popup_comp_ave_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_sphfincolor,'Callback',{@cb_comp_ave_sphfincolor})
        
        set(ui_checkbox_comp_ave_spheretransparency,'Units','normalized')
        set(ui_checkbox_comp_ave_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_spheretransparency,'Position',[.22 0.215 .25 .05])
        set(ui_checkbox_comp_ave_spheretransparency,'String',' Sphere Transp. ')
        set(ui_checkbox_comp_ave_spheretransparency,'Value',false)
        set(ui_checkbox_comp_ave_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_comp_ave_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_spheretransparency,'Callback',{@cb_checkbox_comp_ave_spheretransparency})
        
        set(ui_slider_comp_ave_spheretransparency,'Units','normalized')
        set(ui_slider_comp_ave_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_comp_ave_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_comp_ave_spheretransparency,'Enable','off')
        set(ui_slider_comp_ave_spheretransparency,'Position',[.360 0.22 .115 .05])
        set(ui_slider_comp_ave_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_comp_ave_spheretransparency,'Callback',{@cb_slider_comp_ave_spheretransparency})
        
        set(ui_checkbox_comp_ave_labelsize,'Units','normalized')
        set(ui_checkbox_comp_ave_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_labelsize,'Position',[.22 .115 .20 .05])
        set(ui_checkbox_comp_ave_labelsize,'String',' Label Size ')
        set(ui_checkbox_comp_ave_labelsize,'Value',false)
        set(ui_checkbox_comp_ave_labelsize,'FontWeight','bold')
        set(ui_checkbox_comp_ave_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_labelsize,'Callback',{@cb_checkbox_comp_ave_labelsize})
        
        set(ui_edit_comp_ave_labelsize,'Units','normalized')
        set(ui_edit_comp_ave_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_comp_ave_labelsize,'Enable','off')
        set(ui_edit_comp_ave_labelsize,'Position',[.360 .12 .115 .05])
        set(ui_edit_comp_ave_labelsize,'HorizontalAlignment','center')
        set(ui_edit_comp_ave_labelsize,'FontWeight','bold')
        set(ui_edit_comp_ave_labelsize,'Callback',{@cb_edit_comp_ave_labelsize})
        
        set(ui_checkbox_comp_ave_labelcolor,'Units','normalized')
        set(ui_checkbox_comp_ave_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_ave_labelcolor,'Position',[.22 0.0150 .20 .05])
        set(ui_checkbox_comp_ave_labelcolor,'String',' Label Color ')
        set(ui_checkbox_comp_ave_labelcolor,'Value',false)
        set(ui_checkbox_comp_ave_labelcolor,'FontWeight','bold')
        set(ui_checkbox_comp_ave_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_ave_labelcolor,'Callback',{@cb_checkbox_comp_ave_labelcolor})
        
        set(ui_popup_comp_ave_labelinitcolor,'Units','normalized')
        set(ui_popup_comp_ave_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_labelinitcolor,'Enable','off')
        set(ui_popup_comp_ave_labelinitcolor,'Position',[.360 .02 .05 .05])
        set(ui_popup_comp_ave_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_labelinitcolor,'Value',1)
        set(ui_popup_comp_ave_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_labelinitcolor,'Callback',{@cb_comp_ave_labelinitcolor})
        
        set(ui_popup_comp_ave_labelfincolor,'Units','normalized')
        set(ui_popup_comp_ave_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_ave_labelfincolor,'Enable','off')
        set(ui_popup_comp_ave_labelfincolor,'Position',[.4250 .02 .05 .05])
        set(ui_popup_comp_ave_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_ave_labelfincolor,'Value',3)
        set(ui_popup_comp_ave_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_ave_labelfincolor,'Callback',{@cb_comp_ave_labelfincolor})
        
    end
    function init_std()       
        set(ui_panel_comp_std_scaling,'Parent',fig_comparison)
        set(ui_panel_comp_std_scaling,'Position',[.48 .68 .2550 .2550])
        
        set(ui_text_comp_std_offset,'Units','normalized')
        set(ui_text_comp_std_offset,'Enable','on')
        set(ui_text_comp_std_offset,'Position',[.49 .845 .05 .05])
        set(ui_text_comp_std_offset,'String','offset')
        set(ui_text_comp_std_offset,'HorizontalAlignment','left')
        set(ui_text_comp_std_offset,'FontWeight','bold')
         
        set(ui_edit_comp_std_offset,'Units','normalized')
        set(ui_edit_comp_std_offset,'String','0')
        set(ui_edit_comp_std_offset,'Enable','on')
        set(ui_edit_comp_std_offset,'Position',[.54 .85 .05 .05])
        set(ui_edit_comp_std_offset,'HorizontalAlignment','center')
        set(ui_edit_comp_std_offset,'FontWeight','bold')
        set(ui_edit_comp_std_offset,'Callback',{@cb_edit_comp_std_offset})
        
        set(ui_text_comp_std_rescaling,'Units','normalized')
        set(ui_text_comp_std_rescaling,'Enable','on')
        set(ui_text_comp_std_rescaling,'Position',[.49 0.735 .20 .05])
        set(ui_text_comp_std_rescaling,'String','rescale')
        set(ui_text_comp_std_rescaling,'HorizontalAlignment','left')
        set(ui_text_comp_std_rescaling,'FontWeight','bold')
        
        set(ui_edit_comp_std_rescaling,'Units','normalized')
        set(ui_edit_comp_std_rescaling,'String','10')
        set(ui_edit_comp_std_rescaling,'Enable','on')
        set(ui_edit_comp_std_rescaling,'Position',[.54 .73 .05 .05])
        set(ui_edit_comp_std_rescaling,'HorizontalAlignment','center')
        set(ui_edit_comp_std_rescaling,'FontWeight','bold')
        set(ui_edit_comp_std_rescaling,'Callback',{@cb_edit_comp_std_rescaling})
        
        set(ui_checkbox_comp_std_abs,'Units','normalized')
        set(ui_checkbox_comp_std_abs,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_abs,'Position',[.61 .845 .12 .05])
        set(ui_checkbox_comp_std_abs,'String',' Absolute value ')
        set(ui_checkbox_comp_std_abs,'Value',false)
        set(ui_checkbox_comp_std_abs,'FontWeight','bold')
        set(ui_checkbox_comp_std_abs,'TooltipString','gets absolute values for rescaling')
        set(ui_checkbox_comp_std_abs,'Callback',{@cb_checkbox_comp_std_abs})
        
        set(ui_button_comp_std_automatic,'Units','normalized')
        set(ui_button_comp_std_automatic,'Enable','on')
        set(ui_button_comp_std_automatic,'Position',[.61 .70 .12 .1])
        set(ui_button_comp_std_automatic,'String','Automatic rescaling')
        set(ui_button_comp_std_automatic,'HorizontalAlignment','center')
        set(ui_button_comp_std_automatic,'Callback',{@cb_comp_std_automatic})
        
        set(ui_checkbox_comp_std_symbolsize,'Units','normalized')
        set(ui_checkbox_comp_std_symbolsize,'Enable','on')
        set(ui_checkbox_comp_std_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_symbolsize,'Position',[.48 .615 .20 .05])
        set(ui_checkbox_comp_std_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_comp_std_symbolsize,'Value',false)
        set(ui_checkbox_comp_std_symbolsize,'FontWeight','bold')
        set(ui_checkbox_comp_std_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_symbolsize,'Callback',{@cb_checkbox_comp_std_symbolsize})
        
        set(ui_edit_comp_std_symbolsize,'Units','normalized')
        set(ui_edit_comp_std_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_comp_std_symbolsize,'Enable','off')
        set(ui_edit_comp_std_symbolsize,'Position',[.620 .62 .115 .05])
        set(ui_edit_comp_std_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_comp_std_symbolsize,'FontWeight','bold')
        set(ui_edit_comp_std_symbolsize,'Callback',{@cb_edit_comp_std_symbolsize})
        
        set(ui_checkbox_comp_std_symbolcolor,'Units','normalized')
        set(ui_checkbox_comp_std_symbolcolor,'Enable','on')
        set(ui_checkbox_comp_std_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_symbolcolor,'Position',[.48 .515 .23 .05])
        set(ui_checkbox_comp_std_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_comp_std_symbolcolor,'Value',false)
        set(ui_checkbox_comp_std_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_comp_std_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_symbolcolor,'Callback',{@cb_checkbox_comp_std_symbolcolor})
        
        set(ui_popup_comp_std_initcolor,'Units','normalized')
        set(ui_popup_comp_std_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_initcolor,'Enable','off')
        set(ui_popup_comp_std_initcolor,'Position',[.620 .52 .05 .05])
        set(ui_popup_comp_std_initcolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_initcolor,'Value',3)
        set(ui_popup_comp_std_initcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_initcolor,'Callback',{@cb_comp_std_initcolor})
        
        set(ui_popup_comp_std_fincolor,'Units','normalized')
        set(ui_popup_comp_std_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_fincolor,'Enable','off')
        set(ui_popup_comp_std_fincolor,'Position',[.6850 .52 .05 .05])
        set(ui_popup_comp_std_fincolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_fincolor,'Value',1)
        set(ui_popup_comp_std_fincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_fincolor,'Callback',{@cb_comp_std_fincolor})
        
        set(ui_checkbox_comp_std_sphereradius,'Units','normalized')
        set(ui_checkbox_comp_std_sphereradius,'Enable','on')
        set(ui_checkbox_comp_std_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_sphereradius,'Position',[.48 0.415 .23 .05])
        set(ui_checkbox_comp_std_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_comp_std_sphereradius,'Value',false)
        set(ui_checkbox_comp_std_sphereradius,'FontWeight','bold')
        set(ui_checkbox_comp_std_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_sphereradius,'Callback',{@cb_checkbox_comp_std_sphereradius})
        
        set(ui_edit_comp_std_sphereradius,'Units','normalized')
        set(ui_edit_comp_std_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_comp_std_sphereradius,'Enable','off')
        set(ui_edit_comp_std_sphereradius,'Position',[.620 0.42 .115 .05])
        set(ui_edit_comp_std_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_comp_std_sphereradius,'FontWeight','bold')
        set(ui_edit_comp_std_sphereradius,'Callback',{@cb_edit_comp_std_sphereradius})
        
        set(ui_checkbox_comp_std_spherecolor,'Units','normalized')
        set(ui_checkbox_comp_std_spherecolor,'Enable','on')
        set(ui_checkbox_comp_std_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_spherecolor,'Position',[.48 0.315 .45 .05])
        set(ui_checkbox_comp_std_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_comp_std_spherecolor,'Value',false)
        set(ui_checkbox_comp_std_spherecolor,'FontWeight','bold')
        set(ui_checkbox_comp_std_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_spherecolor,'Callback',{@cb_checkbox_comp_std_spherecolor})
        
        set(ui_popup_comp_std_sphinitcolor,'Units','normalized')
        set(ui_popup_comp_std_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_sphinitcolor,'Enable','off')
        set(ui_popup_comp_std_sphinitcolor,'Position',[.620 .32 .05 .05])
        set(ui_popup_comp_std_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_sphinitcolor,'Value',1)
        set(ui_popup_comp_std_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_sphinitcolor,'Callback',{@cb_comp_std_sphinitcolor})
        
        set(ui_popup_comp_std_sphfincolor,'Units','normalized')
        set(ui_popup_comp_std_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_sphfincolor,'Enable','off')
        set(ui_popup_comp_std_sphfincolor,'Position',[0.6850 .32 .05 .05])
        set(ui_popup_comp_std_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_sphfincolor,'Value',3)
        set(ui_popup_comp_std_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_sphfincolor,'Callback',{@cb_comp_std_sphfincolor})
        
        set(ui_checkbox_comp_std_spheretransparency,'Units','normalized')
        set(ui_checkbox_comp_std_spheretransparency,'Enable','on')
        set(ui_checkbox_comp_std_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_spheretransparency,'Position',[.48 0.215 .25 .05])
        set(ui_checkbox_comp_std_spheretransparency,'String',' Sphere Transp. ')
        set(ui_checkbox_comp_std_spheretransparency,'Value',false)
        set(ui_checkbox_comp_std_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_comp_std_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_spheretransparency,'Callback',{@cb_checkbox_comp_std_spheretransparency})
        
        set(ui_slider_comp_std_spheretransparency,'Units','normalized')
        set(ui_slider_comp_std_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_comp_std_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_comp_std_spheretransparency,'Enable','off')
        set(ui_slider_comp_std_spheretransparency,'Position',[.620 0.22 .115 .05])
        set(ui_slider_comp_std_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_comp_std_spheretransparency,'Callback',{@cb_slider_comp_std_spheretransparency})
        
        set(ui_checkbox_comp_std_labelsize,'Units','normalized')
        set(ui_checkbox_comp_std_labelsize,'Enable','on')
        set(ui_checkbox_comp_std_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_labelsize,'Position',[.48 .115 .20 .05])
        set(ui_checkbox_comp_std_labelsize,'String',' Label Size ')
        set(ui_checkbox_comp_std_labelsize,'Value',false)
        set(ui_checkbox_comp_std_labelsize,'FontWeight','bold')
        set(ui_checkbox_comp_std_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_labelsize,'Callback',{@cb_checkbox_comp_std_labelsize})
        
        set(ui_edit_comp_std_labelsize,'Units','normalized')
        set(ui_edit_comp_std_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_comp_std_labelsize,'Enable','off')
        set(ui_edit_comp_std_labelsize,'Position',[.620 .12 .115 .05])
        set(ui_edit_comp_std_labelsize,'HorizontalAlignment','center')
        set(ui_edit_comp_std_labelsize,'FontWeight','bold')
        set(ui_edit_comp_std_labelsize,'Callback',{@cb_edit_comp_std_labelsize})
        
        set(ui_checkbox_comp_std_labelcolor,'Units','normalized')
        set(ui_checkbox_comp_std_labelcolor,'Enable','on')
        set(ui_checkbox_comp_std_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_std_labelcolor,'Position',[.48 0.0150 .20 .05])
        set(ui_checkbox_comp_std_labelcolor,'String',' Label Color ')
        set(ui_checkbox_comp_std_labelcolor,'Value',false)
        set(ui_checkbox_comp_std_labelcolor,'FontWeight','bold')
        set(ui_checkbox_comp_std_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_std_labelcolor,'Callback',{@cb_checkbox_comp_std_labelcolor})
        
        set(ui_popup_comp_std_labelinitcolor,'Units','normalized')
        set(ui_popup_comp_std_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_labelinitcolor,'Enable','off')
        set(ui_popup_comp_std_labelinitcolor,'Position',[.620 .02 .05 .05])
        set(ui_popup_comp_std_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_labelinitcolor,'Value',1)
        set(ui_popup_comp_std_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_labelinitcolor,'Callback',{@cb_comp_std_labelinitcolor})
        
        set(ui_popup_comp_std_labelfincolor,'Units','normalized')
        set(ui_popup_comp_std_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_std_labelfincolor,'Enable','off')
        set(ui_popup_comp_std_labelfincolor,'Position',[.6850 .02 .05 .05])
        set(ui_popup_comp_std_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_std_labelfincolor,'Value',3)
        set(ui_popup_comp_std_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_std_labelfincolor,'Callback',{@cb_comp_std_labelfincolor})
        
    end
    function init_pval()
        set(ui_panel_comp_pval_scaling,'Parent',fig_comparison)
        set(ui_panel_comp_pval_scaling,'Position',[.74 .68 .2550 .2550])
         
        set(ui_checkbox_comp_psingle,'Units','normalized')
        set(ui_checkbox_comp_psingle,'Enable','on')
        set(ui_checkbox_comp_psingle,'Value',true)
        set(ui_checkbox_comp_psingle,'Position',[.76 .845 .22 .05])
        set(ui_checkbox_comp_psingle,'String','single tailed p-value')
        set(ui_checkbox_comp_psingle,'HorizontalAlignment','left')
        set(ui_checkbox_comp_psingle,'FontWeight','bold')
        set(ui_checkbox_comp_psingle,'Callback',{@cb_checkbox_psingle})
        
        set(ui_checkbox_comp_pdouble,'Units','normalized')
        set(ui_checkbox_comp_pdouble,'Enable','on')
        set(ui_checkbox_comp_pdouble,'Value',false)
        set(ui_checkbox_comp_pdouble,'Position',[.76 0.735 .22 .05])
        set(ui_checkbox_comp_pdouble,'String','double tailed p-value')
        set(ui_checkbox_comp_pdouble,'HorizontalAlignment','left')
        set(ui_checkbox_comp_pdouble,'FontWeight','bold')
        set(ui_checkbox_comp_pdouble,'Callback',{@cb_checkbox_pdouble})
         
        set(ui_checkbox_comp_pval_symbolsize,'Units','normalized')
        set(ui_checkbox_comp_pval_symbolsize,'Enable','on')
        set(ui_checkbox_comp_pval_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_symbolsize,'Position',[.74 .615 .20 .05])
        set(ui_checkbox_comp_pval_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_comp_pval_symbolsize,'Value',false)
        set(ui_checkbox_comp_pval_symbolsize,'FontWeight','bold')
        set(ui_checkbox_comp_pval_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_symbolsize,'Callback',{@cb_checkbox_comp_pval_symbolsize})
        
        set(ui_edit_comp_pval_symbolsize,'Units','normalized')
        set(ui_edit_comp_pval_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_comp_pval_symbolsize,'Enable','off')
        set(ui_edit_comp_pval_symbolsize,'Position',[.880 .62 .115 .05])
        set(ui_edit_comp_pval_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_comp_pval_symbolsize,'FontWeight','bold')
        set(ui_edit_comp_pval_symbolsize,'Callback',{@cb_edit_comp_pval_symbolsize})
        
        set(ui_checkbox_comp_pval_symbolcolor,'Units','normalized')
        set(ui_checkbox_comp_pval_symbolcolor,'Enable','on')
        set(ui_checkbox_comp_pval_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_symbolcolor,'Position',[.74 .515 .23 .05])
        set(ui_checkbox_comp_pval_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_comp_pval_symbolcolor,'Value',false)
        set(ui_checkbox_comp_pval_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_comp_pval_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_symbolcolor,'Callback',{@cb_checkbox_comp_pval_symbolcolor})
        
        set(ui_popup_comp_pval_initcolor,'Units','normalized')
        set(ui_popup_comp_pval_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_initcolor,'Enable','off')
        set(ui_popup_comp_pval_initcolor,'Position',[.880 .52 .05 .05])
        set(ui_popup_comp_pval_initcolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_initcolor,'Value',3)
        set(ui_popup_comp_pval_initcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_initcolor,'Callback',{@cb_comp_pval_initcolor})
        
        set(ui_popup_comp_pval_fincolor,'Units','normalized')
        set(ui_popup_comp_pval_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_fincolor,'Enable','off')
        set(ui_popup_comp_pval_fincolor,'Position',[.9450 .52 .05 .05])
        set(ui_popup_comp_pval_fincolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_fincolor,'Value',1)
        set(ui_popup_comp_pval_fincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_fincolor,'Callback',{@cb_comp_pval_fincolor})
         
        set(ui_checkbox_comp_pval_sphereradius,'Units','normalized')
        set(ui_checkbox_comp_pval_sphereradius,'Enable','on')
        set(ui_checkbox_comp_pval_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_sphereradius,'Position',[.74 0.415 .23 .05])
        set(ui_checkbox_comp_pval_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_comp_pval_sphereradius,'Value',false)
        set(ui_checkbox_comp_pval_sphereradius,'FontWeight','bold')
        set(ui_checkbox_comp_pval_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_sphereradius,'Callback',{@cb_checkbox_comp_pval_sphereradius})
        
        set(ui_edit_comp_pval_sphereradius,'Units','normalized')
        set(ui_edit_comp_pval_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_comp_pval_sphereradius,'Enable','off')
        set(ui_edit_comp_pval_sphereradius,'Position',[.880 0.42 .115 .05])
        set(ui_edit_comp_pval_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_comp_pval_sphereradius,'FontWeight','bold')
        set(ui_edit_comp_pval_sphereradius,'Callback',{@cb_edit_comp_pval_sphereradius})
        
        set(ui_checkbox_comp_pval_spherecolor,'Units','normalized')
        set(ui_checkbox_comp_pval_spherecolor,'Enable','on')
        set(ui_checkbox_comp_pval_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_spherecolor,'Position',[.74 0.315 .45 .05])
        set(ui_checkbox_comp_pval_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_comp_pval_spherecolor,'Value',false)
        set(ui_checkbox_comp_pval_spherecolor,'FontWeight','bold')
        set(ui_checkbox_comp_pval_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_spherecolor,'Callback',{@cb_checkbox_comp_pval_spherecolor})
        
        set(ui_popup_comp_pval_sphinitcolor,'Units','normalized')
        set(ui_popup_comp_pval_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_sphinitcolor,'Enable','off')
        set(ui_popup_comp_pval_sphinitcolor,'Position',[.880 .32 .05 .05])
        set(ui_popup_comp_pval_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_sphinitcolor,'Value',1)
        set(ui_popup_comp_pval_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_sphinitcolor,'Callback',{@cb_comp_pval_sphinitcolor})
        
        set(ui_popup_comp_pval_sphfincolor,'Units','normalized')
        set(ui_popup_comp_pval_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_sphfincolor,'Enable','off')
        set(ui_popup_comp_pval_sphfincolor,'Position',[0.9450 .32 .05 .05])
        set(ui_popup_comp_pval_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_sphfincolor,'Value',3)
        set(ui_popup_comp_pval_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_sphfincolor,'Callback',{@cb_comp_pval_sphfincolor})
        
        set(ui_checkbox_comp_pval_spheretransparency,'Units','normalized')
        set(ui_checkbox_comp_pval_spheretransparency,'Enable','on')
        set(ui_checkbox_comp_pval_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_spheretransparency,'Position',[.74 0.215 .25 .05])
        set(ui_checkbox_comp_pval_spheretransparency,'String',' Sphere Transp. ')
        set(ui_checkbox_comp_pval_spheretransparency,'Value',false)
        set(ui_checkbox_comp_pval_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_comp_pval_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_spheretransparency,'Callback',{@cb_checkbox_comp_pval_spheretransparency})
        
        set(ui_slider_comp_pval_spheretransparency,'Units','normalized')
        set(ui_slider_comp_pval_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_comp_pval_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_comp_pval_spheretransparency,'Enable','off')
        set(ui_slider_comp_pval_spheretransparency,'Position',[.880 0.22 .115 .05])
        set(ui_slider_comp_pval_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_comp_pval_spheretransparency,'Callback',{@cb_slider_comp_pval_spheretransparency})
        
        set(ui_checkbox_comp_pval_labelsize,'Units','normalized')
        set(ui_checkbox_comp_pval_labelsize,'Enable','on')
        set(ui_checkbox_comp_pval_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_labelsize,'Position',[.74 .115 .20 .05])
        set(ui_checkbox_comp_pval_labelsize,'String',' Label Size ')
        set(ui_checkbox_comp_pval_labelsize,'Value',false)
        set(ui_checkbox_comp_pval_labelsize,'FontWeight','bold')
        set(ui_checkbox_comp_pval_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_labelsize,'Callback',{@cb_checkbox_comp_pval_labelsize})
        
        set(ui_edit_comp_pval_labelsize,'Units','normalized')
        set(ui_edit_comp_pval_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_comp_pval_labelsize,'Enable','off')
        set(ui_edit_comp_pval_labelsize,'Position',[.880 .12 .115 .05])
        set(ui_edit_comp_pval_labelsize,'HorizontalAlignment','center')
        set(ui_edit_comp_pval_labelsize,'FontWeight','bold')
        set(ui_edit_comp_pval_labelsize,'Callback',{@cb_edit_comp_pval_labelsize})
        
        set(ui_checkbox_comp_pval_labelcolor,'Units','normalized')
        set(ui_checkbox_comp_pval_labelcolor,'Enable','on')
        set(ui_checkbox_comp_pval_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_comp_pval_labelcolor,'Position',[.74 0.0150 .20 .05])
        set(ui_checkbox_comp_pval_labelcolor,'String',' Label Color ')
        set(ui_checkbox_comp_pval_labelcolor,'Value',false)
        set(ui_checkbox_comp_pval_labelcolor,'FontWeight','bold')
        set(ui_checkbox_comp_pval_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_comp_pval_labelcolor,'Callback',{@cb_checkbox_comp_pval_labelcolor})
        
        set(ui_popup_comp_pval_labelinitcolor,'Units','normalized')
        set(ui_popup_comp_pval_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_labelinitcolor,'Enable','off')
        set(ui_popup_comp_pval_labelinitcolor,'Position',[.880 .02 .05 .05])
        set(ui_popup_comp_pval_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_labelinitcolor,'Value',1)
        set(ui_popup_comp_pval_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_labelinitcolor,'Callback',{@cb_comp_pval_labelinitcolor})
        
        set(ui_popup_comp_pval_labelfincolor,'Units','normalized')
        set(ui_popup_comp_pval_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_comp_pval_labelfincolor,'Enable','off')
        set(ui_popup_comp_pval_labelfincolor,'Position',[.9450 .02 .05 .05])
        set(ui_popup_comp_pval_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_comp_pval_labelfincolor,'Value',3)
        set(ui_popup_comp_pval_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_comp_pval_labelfincolor,'Callback',{@cb_comp_pval_labelfincolor})
        
     end
    
    function update_comp_ave()
        g1 = get(ui_list_group1,'Value');
        g2 = get(ui_list_group2,'Value');
        if isempty(g1) || length(g1)>1
            g1 = 1;
        end
        if isempty(g2) || length(g2)>1
            g2 = 1;
        end
        if get(ui_checkbox_comp_ave_abs,'Value')
            m1 = mean(abs(cohort.getSubjectData(g1)),1);
            m2 = mean(abs(cohort.getSubjectData(g2)),1);
            comparison_ave_data = abs(m1-m2);
        else
            comparison_ave_data = abs(cohort.mean(g1) - cohort.mean(g2));
        end 
    end
    function update_comp_std()
        g1 = get(ui_list_group1,'Value');
        g2 = get(ui_list_group2,'Value');
        if isempty(g1) || length(g1)>1
            g1 = 1;
        end
        if isempty(g2) || length(g2)>1
            g2 = 1;
        end
        if get(ui_checkbox_comp_std_abs,'Value')
            m1 = std(abs(cohort.getSubjectData(g1)),1);
            m2 = std(abs(cohort.getSubjectData(g2)),1);
            comparison_ave_data = abs(m1-m2);
        else
            comparison_std_data = abs(cohort.std(g1) - cohort.std(g2));
        end    
    end
    function update_comp_pval()
        
        g1 = get(ui_list_group1,'Value');
        g2 = get(ui_list_group2,'Value');
        if isempty(g1) || length(g1)>1
            g1 = 1;
        end
        if isempty(g2) || length(g2)>1
            g2 = 1;
        end
        [dm,p1,p2] = cohort.comparison(g1,g2,1000);
        
        if get(ui_checkbox_comp_psingle,'Value')
            comparison_pval_data = 1-p1;
        else if get(ui_checkbox_comp_pdouble,'Value')
                comparison_pval_data = 1-p2;
            end
        end
    end
    
    function cb_list_gr(src,~)
            oldValues = get(src,'UserData');
            newValues = get(src,'Value');
            if numel(newValues) > 1
                newValues = oldValues;
            end
            set(src,'Value',newValues)
            set(src,'UserData',newValues)
            
            update_comp_ave()
            update_comp_std()
            update_comp_pval()
            
            update_brain_comp_ave_plot()
            update_brain_comp_std_plot()
            update_brain_comp_pval_plot()

    end
    
    function cb_edit_comp_ave_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_comp_ave_offset,'String')));
        if isempty(offset)
            set(ui_edit_comp_ave_offset,'String','0')
        else
            set(ui_edit_comp_ave_offset,'String',num2str(offset))
        end
        update_brain_comp_ave_plot()
    end
    function cb_edit_comp_ave_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_comp_ave_rescaling,'String')));
        if isempty(rescaling) || rescaling<10^(-3) || rescaling>10^+3
            set(ui_edit_comp_ave_rescaling,'String','10')
        else
            set(ui_edit_comp_ave_rescaling,'String',num2str(rescaling))
        end
        update_brain_comp_ave_plot()
    end
    function cb_checkbox_comp_ave_abs(~,~)  %  (src,event)
        update_comp_ave()
        update_brain_comp_ave_plot()
    end
    function cb_comp_ave_automatic(~,~)  %  (src,event)
            offset = min(comparison_ave_data);
            if isnan(offset) || offset == 0
                set(ui_edit_comp_ave_offset,'String','0');
            else
                set(ui_edit_comp_ave_offset,'String',num2str(offset))
            end
            
            rescaling = max(comparison_ave_data) - offset;
            if rescaling == 0 || isnan(rescaling)
                set(ui_edit_comp_ave_rescaling,'String','10');
            else
                set(ui_edit_comp_ave_rescaling,'String',num2str(rescaling))
            end
        
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_symbolsize,'Value')
            set(ui_edit_comp_ave_symbolsize,'Enable','on')
            set(ui_checkbox_comp_std_symbolsize,'Enable','off')
            set(ui_checkbox_comp_pval_symbolsize,'Enable','off')
            update_brain_comp_ave_plot()
        else
            size = str2num(get(ui_edit_comp_ave_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_comp_ave_symbolsize,'Enable','off')
            set(ui_checkbox_comp_std_symbolsize,'Enable','on')
            set(ui_checkbox_comp_pval_symbolsize,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_edit_comp_ave_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_ave_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_ave_symbolsize,'String','1')
            size = 5;
        end
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_symbolcolor,'Value')
            set(ui_popup_comp_ave_initcolor,'Enable','on')
            set(ui_popup_comp_ave_fincolor,'Enable','on')
            set(ui_checkbox_comp_std_symbolcolor,'Enable','off')
            set(ui_checkbox_comp_pval_symbolcolor,'Enable','off')
            update_brain_comp_ave_plot()
        else
            val = get(ui_popup_comp_ave_initcolor,'Value');
            str = get(ui_popup_comp_ave_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_comp_ave_initcolor,'Enable','off')
            set(ui_popup_comp_ave_fincolor,'Enable','off')
            set(ui_checkbox_comp_std_symbolcolor,'Enable','on')
            set(ui_checkbox_comp_pval_symbolcolor,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_comp_ave_initcolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end
    function cb_comp_ave_fincolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_sphereradius,'Value')
            set(ui_edit_comp_ave_sphereradius,'Enable','on')
            set(ui_checkbox_comp_std_sphereradius,'Enable','off')
            set(ui_checkbox_comp_pval_sphereradius,'Enable','off')
            update_brain_comp_ave_plot()
        else
            R = str2num(get(ui_edit_comp_ave_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);
            
            set(ui_edit_comp_ave_sphereradius,'Enable','off')
            set(ui_checkbox_comp_std_sphereradius,'Enable','on')
            set(ui_checkbox_comp_pval_sphereradius,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_edit_comp_ave_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_comp_ave_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_comp_ave_sphereradius,'String','1')
            R = 3;
        end
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_spherecolor,'Value')
            set(ui_popup_comp_ave_sphinitcolor,'Enable','on')
            set(ui_popup_comp_ave_sphfincolor,'Enable','on')
            set(ui_checkbox_comp_std_spherecolor,'Enable','off');
            set(ui_checkbox_comp_pval_spherecolor,'Enable','off');
            update_brain_comp_ave_plot()
        else
            val = get(ui_popup_comp_ave_sphinitcolor,'Value');
            str = get(ui_popup_comp_ave_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_comp_ave_sphinitcolor,'Enable','off')
            set(ui_popup_comp_ave_sphfincolor,'Enable','off')
            set(ui_checkbox_comp_std_spherecolor,'Enable','on');
            set(ui_checkbox_comp_pval_spherecolor,'Enable','on');
            update_brain_comp_ave_plot()
        end
    end
    function cb_comp_ave_sphinitcolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end
    function cb_comp_ave_sphfincolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_spheretransparency,'Value')
            set(ui_slider_comp_ave_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_std_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_pval_spheretransparency,'Enable','off')
            update_brain_comp_ave_plot()
        else
            alpha = get(ui_slider_comp_ave_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_comp_ave_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_std_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_pval_spheretransparency,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_slider_comp_ave_spheretransparency(~,~)  %  (src,event)
        update_brain_comp_ave_plot();
    end

    function cb_checkbox_comp_ave_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_labelsize,'Value')
            set(ui_edit_comp_ave_labelsize,'Enable','on')
            set(ui_checkbox_comp_std_labelsize,'Enable','off')
            set(ui_checkbox_comp_pval_labelsize,'Enable','off')
            update_brain_comp_ave_plot()
        else
            size = str2num(get(ui_edit_comp_ave_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);
            
            set(ui_edit_comp_ave_labelsize,'Enable','off')
            set(ui_checkbox_comp_std_labelsize,'Enable','on')
            set(ui_checkbox_comp_pval_labelsize,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_edit_comp_ave_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_ave_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_ave_labelsize,'String','1')
            size = 5;
        end
        update_brain_comp_ave_plot()
    end

    function cb_checkbox_comp_ave_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_ave_labelcolor,'Value')
            set(ui_popup_comp_ave_labelinitcolor,'Enable','on')
            set(ui_popup_comp_ave_labelfincolor,'Enable','on')
            set(ui_checkbox_comp_std_labelcolor,'Enable','off')
            set(ui_checkbox_comp_pval_labelcolor,'Enable','off')
            update_brain_comp_ave_plot()
        else
            val = get(ui_popup_comp_ave_labelinitcolor,'Value');
            str = get(ui_popup_comp_ave_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});
            
            set(ui_popup_comp_ave_labelinitcolor,'Enable','off')
            set(ui_popup_comp_ave_labelfincolor,'Enable','off')
            set(ui_checkbox_comp_std_labelcolor,'Enable','on')
            set(ui_checkbox_comp_pval_labelcolor,'Enable','on')
            update_brain_comp_ave_plot()
        end
    end
    function cb_comp_ave_labelinitcolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end
    function cb_comp_ave_labelfincolor(~,~)  %  (src,event)
        update_brain_comp_ave_plot()
    end

    function update_brain_comp_ave_plot()
        
        if get(ui_checkbox_comp_ave_symbolsize,'Value')
            
            size = str2num(get(ui_edit_comp_ave_symbolsize,'String'));
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            size = 1 + ((comparison_ave_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_comp_ave_symbolcolor,'Value')
            
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            colorValue = (comparison_ave_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_ave_data - min(comparison_ave_data))./(max(comparison_ave_data)-min(comparison_ave_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_ave_initcolor,'Value');
            val2 = get(ui_popup_comp_ave_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_comp_ave_sphereradius,'Value')
            
            R = str2num(get(ui_edit_comp_ave_sphereradius,'String'));
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            R = 1 + ((comparison_ave_data - offset)./rescaling)*R;
            R(R<=0) = 0.1;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_comp_ave_spherecolor,'Value')
            
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            colorValue = (comparison_ave_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_ave_data - min(comparison_ave_data))./(max(comparison_ave_data)-min(comparison_ave_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_ave_sphinitcolor,'Value');
            val2 = get(ui_popup_comp_ave_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_comp_ave_spheretransparency,'Value')
            
            alpha = get(ui_slider_comp_ave_spheretransparency,'Value');
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            alpha_vec = ((comparison_ave_data - offset)./rescaling).*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_comp_ave_labelsize,'Value')
            
            size = str2num(get(ui_edit_comp_ave_labelsize,'String'));
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            size = 1 + ((comparison_ave_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_comp_ave_labelcolor,'Value')
            
            offset = str2num(get(ui_edit_comp_ave_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_ave_rescaling,'String'));
            
            colorValue = (comparison_ave_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_ave_data - min(comparison_ave_data))./(max(comparison_ave_data)-min(comparison_ave_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_ave_labelinitcolor,'Value');
            val2 = get(ui_popup_comp_ave_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
        
    end

    function cb_edit_comp_std_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_comp_std_offset,'String')));
        if isempty(offset)
            set(ui_edit_comp_std_offset,'String','100')
        else
            set(ui_edit_comp_std_offset,'String',num2str(offset))
        end
        update_brain_comp_std_plot()
    end
    function cb_edit_comp_std_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_comp_std_rescaling,'String')));
        if isempty(rescaling) || rescaling<10^(-3) || rescaling>10^+3
            set(ui_edit_comp_std_rescaling,'String','10')
        else
            set(ui_edit_comp_std_rescaling,'String',num2str(rescaling))
        end
        update_brain_comp_std_plot()
    end
    function cb_checkbox_comp_std_abs(~,~)  %  (src,event)
        update_comp_std()
        update_brain_comp_std_plot()
    end
    function cb_comp_std_automatic(~,~)  %  (src,event)
        offset = min(comparison_std_data);
        if isnan(offset) || offset == 0
            set(ui_edit_comp_std_offset,'String','0');
        else
            set(ui_edit_comp_std_offset,'String',num2str(offset))
        end
        
        rescaling = max(comparison_std_data) - offset;
        if rescaling == 0 || isnan(rescaling)
            set(ui_edit_comp_std_rescaling,'String','1');
        else
            set(ui_edit_comp_std_rescaling,'String',num2str(rescaling))
        end
        
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_symbolsize,'Value')
            set(ui_edit_comp_std_symbolsize,'Enable','on')
            set(ui_checkbox_comp_ave_symbolsize,'Enable','off')
            set(ui_checkbox_comp_pval_symbolsize,'Enable','off')
            update_brain_comp_std_plot()
        else
            size = str2num(get(ui_edit_comp_std_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_comp_std_symbolsize,'Enable','off')
            set(ui_checkbox_comp_ave_symbolsize,'Enable','on')
            set(ui_checkbox_comp_pval_symbolsize,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_edit_comp_std_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_std_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_std_symbolsize,'String','1')
            size = 5;
        end
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_symbolcolor,'Value')
            set(ui_popup_comp_std_initcolor,'Enable','on')
            set(ui_popup_comp_std_fincolor,'Enable','on')
            set(ui_checkbox_comp_ave_symbolcolor,'Enable','off')
            set(ui_checkbox_comp_pval_symbolcolor,'Enable','off')
            update_brain_comp_std_plot()
        else
            val = get(ui_popup_comp_std_initcolor,'Value');
            str = get(ui_popup_comp_std_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_comp_std_initcolor,'Enable','off')
            set(ui_popup_comp_std_fincolor,'Enable','off')
            set(ui_checkbox_comp_ave_symbolcolor,'Enable','on')
            set(ui_checkbox_comp_pval_symbolcolor,'Enable','on')
            
            update_brain_comp_std_plot()
        end
    end
    function cb_comp_std_initcolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end
    function cb_comp_std_fincolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_sphereradius,'Value')
            set(ui_edit_comp_std_sphereradius,'Enable','on')
            set(ui_checkbox_comp_ave_sphereradius,'Enable','off')
            set(ui_checkbox_comp_pval_sphereradius,'Enable','off')
            update_brain_comp_std_plot()
        else
            R = str2num(get(ui_edit_comp_std_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);
            
            set(ui_edit_comp_std_sphereradius,'Enable','off')
            set(ui_checkbox_comp_ave_sphereradius,'Enable','on')
            set(ui_checkbox_comp_pval_sphereradius,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_edit_comp_std_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_comp_std_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_comp_std_sphereradius,'String','1')
            R = 3;
        end
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_spherecolor,'Value')
            set(ui_popup_comp_std_sphinitcolor,'Enable','on')
            set(ui_popup_comp_std_sphfincolor,'Enable','on')
            set(ui_checkbox_comp_ave_spherecolor,'Enable','off')
            set(ui_checkbox_comp_pval_spherecolor,'Enable','off')
            update_brain_comp_std_plot()
        else
            val = get(ui_popup_comp_std_sphinitcolor,'Value');
            str = get(ui_popup_comp_std_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_comp_std_sphinitcolor,'Enable','off')
            set(ui_popup_comp_std_sphfincolor,'Enable','off')
            set(ui_checkbox_comp_ave_spherecolor,'Enable','on')
            set(ui_checkbox_comp_pval_spherecolor,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_comp_std_sphinitcolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end
    function cb_comp_std_sphfincolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_spheretransparency,'Value')
            set(ui_slider_comp_std_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_ave_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_pval_spheretransparency,'Enable','off')
            update_brain_comp_std_plot()
        else
            alpha = get(ui_slider_comp_std_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_comp_std_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_ave_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_pval_spheretransparency,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_slider_comp_std_spheretransparency(~,~)  %  (src,event)
        update_brain_comp_std_plot();
    end

    function cb_checkbox_comp_std_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_labelsize,'Value')
            set(ui_edit_comp_std_labelsize,'Enable','on')
            set(ui_checkbox_comp_ave_labelsize,'Enable','off')
            set(ui_checkbox_comp_pval_labelsize,'Enable','off')
            update_brain_comp_std_plot()
        else
            size = str2num(get(ui_edit_comp_std_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);
            
            set(ui_edit_comp_std_labelsize,'Enable','off')
            set(ui_checkbox_comp_ave_labelsize,'Enable','on')
            set(ui_checkbox_comp_pval_labelsize,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_edit_comp_std_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_std_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_std_labelsize,'String','1')
            size = 5;
        end
        update_brain_comp_std_plot()
    end

    function cb_checkbox_comp_std_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_std_labelcolor,'Value')
            set(ui_popup_comp_std_labelinitcolor,'Enable','on')
            set(ui_popup_comp_std_labelfincolor,'Enable','on')
            set(ui_checkbox_comp_ave_labelcolor,'Enable','off')
            set(ui_checkbox_comp_pval_labelcolor,'Enable','off')
            update_brain_comp_std_plot()
        else
            val = get(ui_popup_comp_std_labelinitcolor,'Value');
            str = get(ui_popup_comp_std_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});
            
            set(ui_popup_comp_std_labelinitcolor,'Enable','off')
            set(ui_popup_comp_std_labelfincolor,'Enable','off')
            set(ui_checkbox_comp_ave_labelcolor,'Enable','on')
            set(ui_checkbox_comp_pval_labelcolor,'Enable','on')
            update_brain_comp_std_plot()
        end
    end
    function cb_comp_std_labelinitcolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end
    function cb_comp_std_labelfincolor(~,~)  %  (src,event)
        update_brain_comp_std_plot()
    end

    function update_brain_comp_std_plot()
        
        if get(ui_checkbox_comp_std_symbolsize,'Value')
            
            size = str2num(get(ui_edit_comp_std_symbolsize,'String'));
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            size = 1 + ((comparison_std_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_comp_std_symbolcolor,'Value')
            
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            colorValue = (comparison_std_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_std_data - min(comparison_std_data))./(max(comparison_std_data)-min(comparison_std_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_std_initcolor,'Value');
            val2 = get(ui_popup_comp_std_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_comp_std_sphereradius,'Value')
            
            R = str2num(get(ui_edit_comp_std_sphereradius,'String'));
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            R = 1 + ((comparison_std_data - offset)./rescaling)*R;
            R(R<=0) = 0.1;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_comp_std_spherecolor,'Value')
            
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            colorValue = (comparison_std_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_std_data - min(comparison_std_data))./(max(comparison_std_data)-min(comparison_std_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_std_sphinitcolor,'Value');
            val2 = get(ui_popup_comp_std_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_comp_std_spheretransparency,'Value')
            
            alpha = get(ui_slider_comp_std_spheretransparency,'Value');
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            alpha_vec = ((comparison_std_data - offset)./rescaling).*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_comp_std_labelsize,'Value')
            
            size = str2num(get(ui_edit_comp_std_labelsize,'String'));
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            size = 1 + ((comparison_std_data - offset)./rescaling)*size;
            size(size<=0) = 0.1;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_comp_std_labelcolor,'Value')
            
            offset = str2num(get(ui_edit_comp_std_offset,'String'));
            rescaling = str2num(get(ui_edit_comp_std_rescaling,'String'));
            
            colorValue = (comparison_std_data - offset)./rescaling;
            % colors vector (0 - 1)
            %colorValue = (comparison_std_data - min(comparison_std_data))./(max(comparison_std_data)-min(comparison_std_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_std_labelinitcolor,'Value');
            val2 = get(ui_popup_comp_std_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
    end

    
    function cb_checkbox_psingle(~,~)  %  (src,event)
        if get(ui_checkbox_comp_psingle,'Value')
            set(ui_checkbox_comp_pdouble,'Value',false)
            update_comp_pval()
            update_brain_comp_pval_plot()
        end
    end
    function cb_checkbox_pdouble(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pdouble,'Value')
            set(ui_checkbox_comp_psingle,'Value',false)
            update_comp_pval()
            update_brain_comp_pval_plot()
        end
    end

    function cb_checkbox_comp_pval_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_symbolsize,'Value')
            set(ui_edit_comp_pval_symbolsize,'Enable','on')
            set(ui_checkbox_comp_ave_symbolsize,'Enable','off')
            set(ui_checkbox_comp_std_symbolsize,'Enable','off')
            update_brain_comp_pval_plot()
        else
            size = str2num(get(ui_edit_comp_pval_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_comp_pval_symbolsize,'Enable','off')
            set(ui_checkbox_comp_ave_symbolsize,'Enable','on')
            set(ui_checkbox_comp_std_symbolsize,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_edit_comp_pval_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_pval_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_pval_symbolsize,'String','1')
            size = 5;
        end
        update_brain_comp_pval_plot()
    end

    function cb_checkbox_comp_pval_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_symbolcolor,'Value')
            set(ui_popup_comp_pval_initcolor,'Enable','on')
            set(ui_popup_comp_pval_fincolor,'Enable','on')
            set(ui_checkbox_comp_ave_symbolcolor,'Enable','off')
            set(ui_checkbox_comp_std_symbolcolor,'Enable','off')
            update_brain_comp_pval_plot()
        else
            val = get(ui_popup_comp_pval_initcolor,'Value');
            str = get(ui_popup_comp_pval_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_comp_pval_initcolor,'Enable','off')
            set(ui_popup_comp_pval_fincolor,'Enable','off')
            set(ui_checkbox_comp_ave_symbolcolor,'Enable','on')
            set(ui_checkbox_comp_std_symbolcolor,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_comp_pval_initcolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end
    function cb_comp_pval_fincolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end

    function cb_checkbox_comp_pval_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_sphereradius,'Value')
            set(ui_edit_comp_pval_sphereradius,'Enable','on')
            set(ui_checkbox_comp_ave_sphereradius,'Enable','off')
            set(ui_checkbox_comp_std_sphereradius,'Enable','off')
            update_brain_comp_pval_plot()
        else
            R = str2num(get(ui_edit_comp_pval_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);
            
            set(ui_edit_comp_pval_sphereradius,'Enable','off')
            set(ui_checkbox_comp_ave_sphereradius,'Enable','on')
            set(ui_checkbox_comp_std_sphereradius,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_edit_comp_pval_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_comp_pval_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_comp_pval_sphereradius,'String','1')
            R = 3;
        end
        update_brain_comp_pval_plot()
    end

    function cb_checkbox_comp_pval_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_spherecolor,'Value')
            set(ui_popup_comp_pval_sphinitcolor,'Enable','on')
            set(ui_popup_comp_pval_sphfincolor,'Enable','on')
            set(ui_checkbox_comp_ave_spherecolor,'Enable','off')
            set(ui_checkbox_comp_std_spherecolor,'Enable','off')
            update_brain_comp_pval_plot()
        else
            val = get(ui_popup_comp_pval_sphinitcolor,'Value');
            str = get(ui_popup_comp_pval_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_comp_pval_sphinitcolor,'Enable','off')
            set(ui_popup_comp_pval_sphfincolor,'Enable','off')
            set(ui_checkbox_comp_ave_spherecolor,'Enable','on')
            set(ui_checkbox_comp_std_spherecolor,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_comp_pval_sphinitcolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end
    function cb_comp_pval_sphfincolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end

    function cb_checkbox_comp_pval_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_spheretransparency,'Value')
            set(ui_slider_comp_pval_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_ave_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_std_spheretransparency,'Enable','off')
            update_brain_comp_pval_plot()
        else
            alpha = get(ui_slider_comp_pval_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_comp_pval_spheretransparency,'Enable','off')
            set(ui_checkbox_comp_ave_spheretransparency,'Enable','on')
            set(ui_checkbox_comp_std_spheretransparency,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_slider_comp_pval_spheretransparency(~,~)  %  (src,event)
        update_brain_comp_pval_plot();
    end

    function cb_checkbox_comp_pval_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_labelsize,'Value')
            set(ui_edit_comp_pval_labelsize,'Enable','on')
            set(ui_checkbox_comp_ave_labelsize,'Enable','off')
            set(ui_checkbox_comp_std_labelsize,'Enable','off')
            update_brain_comp_pval_plot()
        else
            size = str2num(get(ui_edit_comp_pval_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);
            
            set(ui_edit_comp_pval_labelsize,'Enable','off')
            set(ui_checkbox_comp_ave_labelsize,'Enable','on')
            set(ui_checkbox_comp_std_labelsize,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_edit_comp_pval_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_comp_pval_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_comp_pval_labelsize,'String','1')
            size = 5;
        end
        update_brain_comp_pval_plot()
    end

    function cb_checkbox_comp_pval_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_comp_pval_labelcolor,'Value')
            set(ui_popup_comp_pval_labelinitcolor,'Enable','on')
            set(ui_popup_comp_pval_labelfincolor,'Enable','on')
            set(ui_checkbox_comp_ave_labelcolor,'Enable','off')
            set(ui_checkbox_comp_std_labelcolor,'Enable','off')
            update_brain_comp_pval_plot()
        else
            val = get(ui_popup_comp_pval_labelinitcolor,'Value');
            str = get(ui_popup_comp_pval_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});
            
            set(ui_popup_comp_pval_labelinitcolor,'Enable','off')
            set(ui_popup_comp_pval_labelfincolor,'Enable','off')
            set(ui_checkbox_comp_ave_labelcolor,'Enable','on')
            set(ui_checkbox_comp_std_labelcolor,'Enable','on')
            update_brain_comp_pval_plot()
        end
    end
    function cb_comp_pval_labelinitcolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end
    function cb_comp_pval_labelfincolor(~,~)  %  (src,event)
        update_brain_comp_pval_plot()
    end

    function update_brain_comp_pval_plot()
        
        if get(ui_checkbox_comp_pval_symbolsize,'Value')
            
            size = str2num(get(ui_edit_comp_pval_symbolsize,'String'));
            size = 1 + comparison_pval_data*size;
            size(size<=0) = 0.001;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_comp_pval_symbolcolor,'Value')

            colorValue = comparison_pval_data;
            % colors vector (0 - 1)
            %colorValue = (comparison_pval_data - min(comparison_pval_data))./(max(comparison_pval_data)-min(comparison_pval_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_pval_initcolor,'Value');
            val2 = get(ui_popup_comp_pval_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_comp_pval_sphereradius,'Value')
            
            R = str2num(get(ui_edit_comp_pval_sphereradius,'String'));
 
            R = 1 + comparison_pval_data*R;
            R(R<=0) = 0.001;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_comp_pval_spherecolor,'Value')

            colorValue = comparison_pval_data;
            % colors vector (0 - 1)
            %colorValue = (comparison_pval_data - min(comparison_pval_data))./(max(comparison_pval_data)-min(comparison_pval_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_pval_sphinitcolor,'Value');
            val2 = get(ui_popup_comp_pval_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_comp_pval_spheretransparency,'Value')
            
            alpha = get(ui_slider_comp_pval_spheretransparency,'Value');

            alpha_vec = comparison_pval_data*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_comp_pval_labelsize,'Value')
            
            size = str2num(get(ui_edit_comp_pval_labelsize,'String'));

            size = 1 + comparison_pval_data*size;
            size(size<=0) = 0.001;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_comp_pval_labelcolor,'Value')
 
            colorValue = comparison_pval_data;
            % colors vector (0 - 1)
            %colorValue = (comparison_pval_data - min(comparison_pval_data))./(max(comparison_pval_data)-min(comparison_pval_data));            
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_comp_pval_labelinitcolor,'Value');
            val2 = get(ui_popup_comp_pval_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
    end

end