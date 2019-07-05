function GUIPETGraphAnalysisWUViewMeas(fig_group,ga,bg)

% sets position of figure
APPNAME = GUI.PGA_NAME;
FigPosition = [.10 .30 .30 .40];
FigColor = GUI.BKGCOLOR;

% create a figure
if isempty(fig_group) || ~ishandle(fig_group)
    fig_group = figure('Visible','off');
end

set(fig_group,'units','normalized')
set(fig_group,'Position',FigPosition)
set(fig_group,'Color',FigColor)
set(fig_group,'Name',[APPNAME ' : Group settings - ' BNC.VERSION])
set(fig_group,'MenuBar','none')
set(fig_group,'Toolbar','none')
set(fig_group,'NumberTitle','off')
set(fig_group,'DockControls','off')

CALC_NOTIFICATION = 'measure not yet calculated';
measure_data = [];

% get all measures
mlist = GraphWU.measurelist(true);  % list of nodal measures
list_name = Graph.NAME(mlist);


%% initialization
ui_popup_grouplists = uicontrol(fig_group,'Style','popup','String',{''});
set(ui_popup_grouplists,'Units','normalized')
set(ui_popup_grouplists,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_grouplists,'Position',[.02 .885 .30 .05])
set(ui_popup_grouplists,'Value',1)
set(ui_popup_grouplists,'TooltipString','Select group');
set(ui_popup_grouplists,'Callback',{@cb_popup_grouplists})

ui_list_gr = uicontrol(fig_group,'Style', 'listbox');
set(ui_list_gr,'Units','normalized')
set(ui_list_gr,'BackgroundColor',GUI.BKGCOLOR)
set(ui_list_gr,'String',list_name)
set(ui_list_gr,'Value',1)
set(ui_list_gr,'Max',-1,'Min',0)
set(ui_list_gr,'BackgroundColor',[1 1 1])
set(ui_list_gr,'Position',[.02 .02 .30 .845])
set(ui_list_gr,'TooltipString','Select brain regions');
set(ui_list_gr,'Callback',{@cb_list_gr});

ui_text_view_meaas = uicontrol(fig_group,'Style','text');
set(ui_text_view_meaas,'Units','normalized')
set(ui_text_view_meaas,'Position',[0.4525 .935 .40 .05])
set(ui_text_view_meaas,'BackgroundColor',GUI.BKGCOLOR)
set(ui_text_view_meaas,'String','View measure')
set(ui_text_view_meaas,'HorizontalAlignment','center')
set(ui_text_view_meaas,'FontWeight','bold')

ui_panel_meas_scaling = uipanel();
ui_text_meas_offset = uicontrol(fig_group,'Style','text');
ui_edit_meas_offset = uicontrol(fig_group,'Style','edit');
ui_text_meas_rescaling = uicontrol(fig_group,'Style','text');
ui_edit_meas_rescaling = uicontrol(fig_group,'Style','edit');
ui_button_meas_automatic = uicontrol(fig_group,'Style','pushbutton');
ui_checkbox_meas_symbolsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_meas_symbolsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_meas_symbolcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_meas_initcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_meas_fincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_meas_sphereradius = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_meas_sphereradius = uicontrol(fig_group,'Style','edit');
ui_checkbox_meas_spherecolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_meas_sphinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_meas_sphfincolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_checkbox_meas_spheretransparency = uicontrol(fig_group,'Style', 'checkbox');
ui_slider_meas_spheretransparency = uicontrol(fig_group,'Style','slider');
ui_checkbox_meas_labelsize = uicontrol(fig_group,'Style', 'checkbox');
ui_edit_meas_labelsize = uicontrol(fig_group,'Style','edit');
ui_checkbox_meas_labelcolor = uicontrol(fig_group,'Style', 'checkbox');
ui_popup_meas_labelinitcolor = uicontrol(fig_group,'Style','popup','String',{''});
ui_popup_meas_labelfincolor = uicontrol(fig_group,'Style','popup','String',{''});
 
init_gr_meas()
% get all group names
update_popup_grouplist()
update_measure_data();

set(fig_group,'Visible','on')

%% Callback functions
    function init_gr_meas()
        
        set(ui_panel_meas_scaling,'Parent',fig_group)
        set(ui_panel_meas_scaling,'Position',[.35 .68 .605 .2550])
        
        set(ui_text_meas_offset,'Units','normalized')
        set(ui_text_meas_offset,'Position',[.38 .865 .25 .05])
        set(ui_text_meas_offset,'String','offset')
        set(ui_text_meas_offset,'HorizontalAlignment','left')
        set(ui_text_meas_offset,'FontWeight','bold')
     
        set(ui_edit_meas_offset,'Units','normalized')
        set(ui_edit_meas_offset,'String','0')
        set(ui_edit_meas_offset,'Enable','on')
        set(ui_edit_meas_offset,'Position',[.83 .87 .10 .05])
        set(ui_edit_meas_offset,'HorizontalAlignment','center')
        set(ui_edit_meas_offset,'FontWeight','bold')
        set(ui_edit_meas_offset,'Callback',{@cb_edit_meas_offset})
        
        set(ui_text_meas_rescaling,'Units','normalized')
        set(ui_text_meas_rescaling,'Position',[.38 .795 .25 .05])
        set(ui_text_meas_rescaling,'String','rescale')
        set(ui_text_meas_rescaling,'HorizontalAlignment','left')
        set(ui_text_meas_rescaling,'FontWeight','bold')
        
        set(ui_edit_meas_rescaling,'Units','normalized')
        set(ui_edit_meas_rescaling,'String','10')
        set(ui_edit_meas_rescaling,'Enable','on')
        set(ui_edit_meas_rescaling,'Position',[.83 .80 .10 .05])
        set(ui_edit_meas_rescaling,'HorizontalAlignment','center')
        set(ui_edit_meas_rescaling,'FontWeight','bold')
        set(ui_edit_meas_rescaling,'Callback',{@cb_edit_meas_rescaling})
        
        set(ui_button_meas_automatic,'Units','normalized')
        set(ui_button_meas_automatic,'Position',[.4525 .70 .40 .08])
        set(ui_button_meas_automatic,'String','Automatic rescaling')
        set(ui_button_meas_automatic,'HorizontalAlignment','center')
        set(ui_button_meas_automatic,'Callback',{@cb_meas_automatic})
        
        set(ui_checkbox_meas_symbolsize,'Units','normalized')
        set(ui_checkbox_meas_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_symbolsize,'Position',[.35 .615 .30 .05])
        set(ui_checkbox_meas_symbolsize,'String',' Symbol Size ')
        set(ui_checkbox_meas_symbolsize,'Value',false)
        set(ui_checkbox_meas_symbolsize,'FontWeight','bold')
        set(ui_checkbox_meas_symbolsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_symbolsize,'Callback',{@cb_checkbox_meas_symbolsize})
        
        set(ui_edit_meas_symbolsize,'Units','normalized')
        set(ui_edit_meas_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
        set(ui_edit_meas_symbolsize,'Enable','off')
        set(ui_edit_meas_symbolsize,'Position',[.7050 .62 .25 .05])
        set(ui_edit_meas_symbolsize,'HorizontalAlignment','center')
        set(ui_edit_meas_symbolsize,'FontWeight','bold')
        set(ui_edit_meas_symbolsize,'Callback',{@cb_edit_meas_symbolsize})
        
        set(ui_checkbox_meas_symbolcolor,'Units','normalized')
        set(ui_checkbox_meas_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_symbolcolor,'Position',[.35 .515 .23 .05])
        set(ui_checkbox_meas_symbolcolor,'String',' Symbol Color ')
        set(ui_checkbox_meas_symbolcolor,'Value',false)
        set(ui_checkbox_meas_symbolcolor,'FontWeight','bold')
        set(ui_checkbox_meas_symbolcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_symbolcolor,'Callback',{@cb_checkbox_meas_symbolcolor})
        
        set(ui_popup_meas_initcolor,'Units','normalized')
        set(ui_popup_meas_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_initcolor,'Enable','off')
        set(ui_popup_meas_initcolor,'Position',[.7050 .52 .11 .05])
        set(ui_popup_meas_initcolor,'String',{'R','G','B'})
        set(ui_popup_meas_initcolor,'Value',3)
        set(ui_popup_meas_initcolor,'TooltipString','Select symbol');
        set(ui_popup_meas_initcolor,'Callback',{@cb_meas_initcolor})
        
        set(ui_popup_meas_fincolor,'Units','normalized')
        set(ui_popup_meas_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_fincolor,'Enable','off')
        set(ui_popup_meas_fincolor,'Position',[0.8450 .52 .11 .05])
        set(ui_popup_meas_fincolor,'String',{'R','G','B'})
        set(ui_popup_meas_fincolor,'Value',1)
        set(ui_popup_meas_fincolor,'TooltipString','Select symbol');
        set(ui_popup_meas_fincolor,'Callback',{@cb_meas_fincolor})
        
        set(ui_checkbox_meas_sphereradius,'Units','normalized')
        set(ui_checkbox_meas_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_sphereradius,'Position',[.35 0.415 .30 .05])
        set(ui_checkbox_meas_sphereradius,'String',' Sphere Radius ')
        set(ui_checkbox_meas_sphereradius,'Value',false)
        set(ui_checkbox_meas_sphereradius,'FontWeight','bold')
        set(ui_checkbox_meas_sphereradius,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_sphereradius,'Callback',{@cb_checkbox_meas_sphereradius})
        
        set(ui_edit_meas_sphereradius,'Units','normalized')
        set(ui_edit_meas_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
        set(ui_edit_meas_sphereradius,'Enable','off')
        set(ui_edit_meas_sphereradius,'Position',[.7050 0.42 .25 .05])
        set(ui_edit_meas_sphereradius,'HorizontalAlignment','center')
        set(ui_edit_meas_sphereradius,'FontWeight','bold')
        set(ui_edit_meas_sphereradius,'Callback',{@cb_edit_meas_sphereradius})
        
        set(ui_checkbox_meas_spherecolor,'Units','normalized')
        set(ui_checkbox_meas_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_spherecolor,'Position',[.35 0.315 .45 .05])
        set(ui_checkbox_meas_spherecolor,'String',' Sphere Color ')
        set(ui_checkbox_meas_spherecolor,'Value',false)
        set(ui_checkbox_meas_spherecolor,'FontWeight','bold')
        set(ui_checkbox_meas_spherecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_spherecolor,'Callback',{@cb_checkbox_meas_spherecolor})
        
        set(ui_popup_meas_sphinitcolor,'Units','normalized')
        set(ui_popup_meas_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_sphinitcolor,'Enable','off')
        set(ui_popup_meas_sphinitcolor,'Position',[.7050 .32 .11 .05])
        set(ui_popup_meas_sphinitcolor,'String',{'R','G','B'})
        set(ui_popup_meas_sphinitcolor,'Value',1)
        set(ui_popup_meas_sphinitcolor,'TooltipString','Select symbol');
        set(ui_popup_meas_sphinitcolor,'Callback',{@cb_meas_sphinitcolor})
        
        set(ui_popup_meas_sphfincolor,'Units','normalized')
        set(ui_popup_meas_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_sphfincolor,'Enable','off')
        set(ui_popup_meas_sphfincolor,'Position',[0.8450 .32 .11 .05])
        set(ui_popup_meas_sphfincolor,'String',{'R','G','B'})
        set(ui_popup_meas_sphfincolor,'Value',3)
        set(ui_popup_meas_sphfincolor,'TooltipString','Select symbol');
        set(ui_popup_meas_sphfincolor,'Callback',{@cb_meas_sphfincolor})
        
        set(ui_checkbox_meas_spheretransparency,'Units','normalized')
        set(ui_checkbox_meas_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_spheretransparency,'Position',[.35 0.215 .32 .05])
        set(ui_checkbox_meas_spheretransparency,'String',' Sphere Transparency ')
        set(ui_checkbox_meas_spheretransparency,'Value',false)
        set(ui_checkbox_meas_spheretransparency,'FontWeight','bold')
        set(ui_checkbox_meas_spheretransparency,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_spheretransparency,'Callback',{@cb_checkbox_meas_spheretransparency})
        
        set(ui_slider_meas_spheretransparency,'Units','normalized')
        set(ui_slider_meas_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_slider_meas_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
        set(ui_slider_meas_spheretransparency,'Enable','off')
        set(ui_slider_meas_spheretransparency,'Position',[.7050 0.22 .25 .05])
        set(ui_slider_meas_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
        set(ui_slider_meas_spheretransparency,'Callback',{@cb_slider_meas_spheretransparency})
        
        set(ui_checkbox_meas_labelsize,'Units','normalized')
        set(ui_checkbox_meas_labelsize,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_labelsize,'Position',[.35 .115 .32 .05])
        set(ui_checkbox_meas_labelsize,'String',' Label Size ')
        set(ui_checkbox_meas_labelsize,'Value',false)
        set(ui_checkbox_meas_labelsize,'FontWeight','bold')
        set(ui_checkbox_meas_labelsize,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_labelsize,'Callback',{@cb_checkbox_meas_labelsize})
        
        set(ui_edit_meas_labelsize,'Units','normalized')
        set(ui_edit_meas_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
        set(ui_edit_meas_labelsize,'Enable','off')
        set(ui_edit_meas_labelsize,'Position',[.7050 .12 .25 .05])
        set(ui_edit_meas_labelsize,'HorizontalAlignment','center')
        set(ui_edit_meas_labelsize,'FontWeight','bold')
        set(ui_edit_meas_labelsize,'Callback',{@cb_edit_meas_labelsize})
        
        set(ui_checkbox_meas_labelcolor,'Units','normalized')
        set(ui_checkbox_meas_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_meas_labelcolor,'Position',[.35 0.0150 .32 .05])
        set(ui_checkbox_meas_labelcolor,'String',' Label Color ')
        set(ui_checkbox_meas_labelcolor,'Value',false)
        set(ui_checkbox_meas_labelcolor,'FontWeight','bold')
        set(ui_checkbox_meas_labelcolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_meas_labelcolor,'Callback',{@cb_checkbox_meas_labelcolor})
        
        set(ui_popup_meas_labelinitcolor,'Units','normalized')
        set(ui_popup_meas_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_labelinitcolor,'Enable','off')
        set(ui_popup_meas_labelinitcolor,'Position',[.7050 .02 .11 .05])
        set(ui_popup_meas_labelinitcolor,'String',{'R','G','B'})
        set(ui_popup_meas_labelinitcolor,'Value',1)
        set(ui_popup_meas_labelinitcolor,'TooltipString','Select symbol');
        set(ui_popup_meas_labelinitcolor,'Callback',{@cb_meas_labelinitcolor})
        
        set(ui_popup_meas_labelfincolor,'Units','normalized')
        set(ui_popup_meas_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_meas_labelfincolor,'Enable','off')
        set(ui_popup_meas_labelfincolor,'Position',[0.8450 .02 .11 .05])
        set(ui_popup_meas_labelfincolor,'String',{'R','G','B'})
        set(ui_popup_meas_labelfincolor,'Value',3)
        set(ui_popup_meas_labelfincolor,'TooltipString','Select symbol');
        set(ui_popup_meas_labelfincolor,'Callback',{@cb_meas_labelfincolor})
    end
    function cb_popup_grouplists(~,~)  % (src,event)
        update_measure_data()
        update_brain_meas_plot()
    end
    function cb_list_gr(~,~)
        update_measure_data()
        update_brain_meas_plot()
    end  % (src,event)
    function cb_edit_meas_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_meas_offset,'String')));
        if isempty(offset)
            set(ui_edit_meas_offset,'String','100')
        else
            set(ui_edit_meas_offset,'String',num2str(offset))
        end
        update_brain_meas_plot()
    end
    function cb_edit_meas_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_meas_rescaling,'String')));
        if isempty(rescaling) || isnan(rescaling) || rescaling<10^(-4) || rescaling>(10^+4)
            set(ui_edit_meas_rescaling,'String','10')
        else
            set(ui_edit_meas_rescaling,'String',num2str(rescaling))
        end
        update_brain_meas_plot()
    end
    function cb_meas_automatic(~,~)  %  (src,event)
        if ~isempty(measure_data)
        offset = min(measure_data);
        if isnan(offset) || offset == 0 || ~isreal(offset)
            set(ui_edit_meas_offset,'String','0');
        else
            set(ui_edit_meas_offset,'String',num2str(offset))
        end
        
        rescaling = max(measure_data) - offset;
        if rescaling == 0 || isnan(rescaling) || ~isreal(rescaling)
            set(ui_edit_meas_rescaling,'String','1');
        else
            set(ui_edit_meas_rescaling,'String',num2str(rescaling))
        end
        
        update_brain_meas_plot()
        end
    end
    function cb_checkbox_meas_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_meas_symbolsize,'Value')
            set(ui_edit_meas_symbolsize,'Enable','on')
            
            update_brain_meas_plot()
        else
            size = str2num(get(ui_edit_meas_symbolsize,'String'));
            size = 1 + size;
            bg.br_syms([],'Size',size);
            
            set(ui_edit_meas_symbolsize,'Enable','off')            
            update_brain_meas_plot()
        end
    end
    function cb_edit_meas_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_meas_symbolsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_meas_symbolsize,'String','1')
            size = 5;
        end
        update_brain_meas_plot()
    end
    function cb_checkbox_meas_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_meas_symbolcolor,'Value')
            set(ui_popup_meas_initcolor,'Enable','on')
            set(ui_popup_meas_fincolor,'Enable','on')
                       
            update_brain_meas_plot()
        else
            val = get(ui_popup_meas_initcolor,'Value');
            str = get(ui_popup_meas_initcolor,'String');
            bg.br_syms([],'Color',str{val});
            
            set(ui_popup_meas_initcolor,'Enable','off')
            set(ui_popup_meas_fincolor,'Enable','off')
            
            update_brain_meas_plot()
        end
    end
    function cb_meas_initcolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function cb_meas_fincolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function cb_checkbox_meas_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_meas_sphereradius,'Value')
            set(ui_edit_meas_sphereradius,'Enable','on')

            update_brain_meas_plot()
        else
            R = str2num(get(ui_edit_meas_sphereradius,'String'));
            R = R + 1;
            bg.br_sphs([],'R',R);

            set(ui_edit_meas_sphereradius,'Enable','off')
            update_brain_meas_plot()
        end
    end
    function cb_edit_meas_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_meas_sphereradius,'String')));
        if isempty(R) || R<=0
            set(ui_edit_meas_sphereradius,'String','1')
            R = 3;
        end
        update_brain_meas_plot()
    end
    function cb_checkbox_meas_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_meas_spherecolor,'Value')
            set(ui_popup_meas_sphinitcolor,'Enable','on')
            set(ui_popup_meas_sphfincolor,'Enable','on')
            update_brain_meas_plot()
        else
            val = get(ui_popup_meas_sphinitcolor,'Value');
            str = get(ui_popup_meas_sphinitcolor,'String');
            bg.br_sphs([],'Color',str{val});
            
            set(ui_popup_meas_sphinitcolor,'Enable','off')
            set(ui_popup_meas_sphfincolor,'Enable','off')
            update_brain_meas_plot()
        end
    end
    function cb_meas_sphinitcolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function cb_meas_sphfincolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function cb_checkbox_meas_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_meas_spheretransparency,'Value')
            set(ui_slider_meas_spheretransparency,'Enable','on')

            update_brain_meas_plot()
        else
            alpha = get(ui_slider_meas_spheretransparency,'Value');
            bg.br_sphs([],'Alpha',alpha);

            set(ui_slider_meas_spheretransparency,'Enable','off')
            update_brain_meas_plot()
        end
    end
    function cb_slider_meas_spheretransparency(~,~)  %  (src,event)
        update_brain_meas_plot();
    end
    function cb_checkbox_meas_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_meas_labelsize,'Value')
            set(ui_edit_meas_labelsize,'Enable','on')

            update_brain_meas_plot()
        else
            size = str2num(get(ui_edit_meas_labelsize,'String'));
            size = size + 1;
            bg.br_labs([],'FontSize',size);

            set(ui_edit_meas_labelsize,'Enable','off')
            update_brain_meas_plot()
        end
    end
    function cb_edit_meas_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_meas_labelsize,'String')));
        if isempty(size) || size<=0
            set(ui_edit_meas_labelsize,'String','1')
            size = 5;
        end
        update_brain_meas_plot()
    end
    function cb_checkbox_meas_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_meas_labelcolor,'Value')
            set(ui_popup_meas_labelinitcolor,'Enable','on')
            set(ui_popup_meas_labelfincolor,'Enable','on')

            update_brain_meas_plot()
        else
            val = get(ui_popup_meas_labelinitcolor,'Value');
            str = get(ui_popup_meas_labelinitcolor,'String');
            bg.br_labs([],'Color',str{val});

            set(ui_popup_meas_labelinitcolor,'Enable','off')
            set(ui_popup_meas_labelfincolor,'Enable','off')
            update_brain_meas_plot()
        end
    end
    function cb_meas_labelinitcolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function cb_meas_labelfincolor(~,~)  %  (src,event)
        update_brain_meas_plot()
    end
    function update_measure_data()
        i = get(ui_list_gr,'Value');
        if isempty(i) || length(i)>1
            i = 1;
        end
            [measures,~] = ga.getMeasures(mlist(get(ui_list_gr,'Value')),get(ui_popup_grouplists,'Value'));
            if isempty(measures)
                errordlg('The measure does not exist')
            else
                meas = measures{1};
                measure_data = meas.getProp(PETMeasureWU.VALUES1);
            end
    end
    function update_popup_grouplist()
        if ga.getCohort().groupnumber()>0
            % updates group lists of popups
            GroupList = {};
            for g = 1:1:ga.getCohort().groupnumber()
                GroupList{g} = ga.getCohort().getGroup(g).getProp(Group.NAME);
            end
        else
            GroupList = {''};
        end    
        set(ui_popup_grouplists,'String',GroupList)
    end
    function update_brain_meas_plot()
               
        if get(ui_checkbox_meas_symbolsize,'Value')
            
            size = str2num(get(ui_edit_meas_symbolsize,'String'));
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            size = 1 + ((measure_data - offset)./rescaling)*size;
            size(isnan(size)) = 0.1;
            size(size<=0) = 0.1;
            bg.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_meas_symbolcolor,'Value')
            
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            colorValue = (measure_data - offset)./rescaling;
            %colorValue = (measure_data - min(measure_data))./(max(measure_data)-min(measure_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_meas_initcolor,'Value');
            val2 = get(ui_popup_meas_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            
            bg.br_syms([],'Color',C);
        end
        
        if get(ui_checkbox_meas_sphereradius,'Value')
            
            R = str2num(get(ui_edit_meas_sphereradius,'String'));
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            R = 1 + ((measure_data - offset)./rescaling)*R;
            R(isnan(R)) = 0.1;
            R(R<=0) = 0.1;
            bg.br_sphs([],'R',R);
        end
        
        if get(ui_checkbox_meas_spherecolor,'Value')
            
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            colorValue = (measure_data - offset)./rescaling;
            %colorValue = (measure_data - min(measure_data))./(max(measure_data)-min(measure_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_meas_sphinitcolor,'Value');
            val2 = get(ui_popup_meas_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_sphs([],'Color',C);
        end
        
        if get(ui_checkbox_meas_spheretransparency,'Value')
            
            alpha = get(ui_slider_meas_spheretransparency,'Value');
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            alpha_vec = ((measure_data - offset)./rescaling).*alpha;
            alpha_vec(isnan(alpha_vec)) = 0;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            bg.br_sphs([],'Alpha',alpha_vec);
        end
        
        if get(ui_checkbox_meas_labelsize,'Value')
            
            size = str2num(get(ui_edit_meas_labelsize,'String'));
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            size = 1 + ((measure_data - offset)./rescaling)*size;
            size(isnan(size)) = 0.1;
            size(size<=0) = 0.1;
            bg.br_labs([],'FontSize',size);
        end
        
        if get(ui_checkbox_meas_labelcolor,'Value')
            
            offset = str2num(get(ui_edit_meas_offset,'String'));
            rescaling = str2num(get(ui_edit_meas_rescaling,'String'));
            
            colorValue = (measure_data - offset)./rescaling;
            %colorValue = (measure_data - min(measure_data))./(max(measure_data)-min(measure_data));
            colorValue(isnan(colorValue)) = 0;
            colorValue(colorValue<0) = 0;
            colorValue(colorValue>1) = 1;
            
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_meas_labelinitcolor,'Value');
            val2 = get(ui_popup_meas_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            bg.br_labs([],'Color',C);
        end
        
    end

end