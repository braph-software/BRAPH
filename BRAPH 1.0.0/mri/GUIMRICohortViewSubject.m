function fig_subject = GUIMRICohortViewSubject(fig_subject,cohort,ba)

% sets position of figure
APPNAME = GUI.MCE_NAME;
FigPosition = [.50 .30 .40 .35];
FigColor = GUI.BKGCOLOR;
FigName = 'View Subjects Settings';

% create a figure
if isempty(fig_subject) || ~ishandle(fig_subject)
    fig_subject = figure('Visible','off');
end

set(fig_subject,'units','normalized')
set(fig_subject,'Position',FigPosition)
set(fig_subject,'Color',FigColor)
set(fig_subject,'Name',[APPNAME ' : Subject settings - ' BNC.VERSION ' - ' cohort.getProp(MRICohort.NAME)])
set(fig_subject,'MenuBar','none')
set(fig_subject,'Toolbar','none')
set(fig_subject,'NumberTitle','off')
set(fig_subject,'DockControls','off')

subject_data = [];

% initialization
ui_list = uicontrol(fig_subject,'Style', 'listbox');
set(ui_list,'Units','normalized')
set(ui_list,'BackgroundColor',GUI.BKGCOLOR)
set(ui_list,'String',cohort.getProps(MRISubject.CODE))
set(ui_list,'Value',1)
set(ui_list,'Max',2,'Min',0)
set(ui_list,'BackgroundColor',[1 1 1])
set(ui_list,'Position',[.05 .05 .30 .90])
set(ui_list,'TooltipString','Select brain regions');
set(ui_list,'Callback',{@cb_list});

ui_panel_scaling = uipanel();
set(ui_panel_scaling,'parent',fig_subject)
set(ui_panel_scaling,'Position',[.38 .71 .5650 .2550])

ui_text_offset = uicontrol(fig_subject,'Style','text');
set(ui_text_offset,'Units','normalized')
set(ui_text_offset,'Position',[.40 .865 .20 .05])
set(ui_text_offset,'String','offset')
set(ui_text_offset,'HorizontalAlignment','left')
set(ui_text_offset,'FontWeight','bold')

ui_edit_offset = uicontrol(fig_subject,'Style','edit');
set(ui_edit_offset,'Units','normalized')
set(ui_edit_offset,'String','0')
set(ui_edit_offset,'Enable','on')
set(ui_edit_offset,'Position',[.5 .87 .1 .05])
set(ui_edit_offset,'HorizontalAlignment','center')
set(ui_edit_offset,'FontWeight','bold')
set(ui_edit_offset,'Callback',{@cb_edit_offset})

ui_text_rescaling = uicontrol(fig_subject,'Style','text');
set(ui_text_rescaling,'Units','normalized')
set(ui_text_rescaling,'Position',[.40 0.785 .20 .05])
set(ui_text_rescaling,'String','rescale')
set(ui_text_rescaling,'HorizontalAlignment','left')
set(ui_text_rescaling,'FontWeight','bold')

ui_edit_rescaling = uicontrol(fig_subject,'Style','edit');
set(ui_edit_rescaling,'Units','normalized')
set(ui_edit_rescaling,'String','10')
set(ui_edit_rescaling,'Enable','on')
set(ui_edit_rescaling,'Position',[.5 .79 .1 .05])
set(ui_edit_rescaling,'HorizontalAlignment','center')
set(ui_edit_rescaling,'FontWeight','bold')
set(ui_edit_rescaling,'Callback',{@cb_edit_rescaling})

ui_checkbox_abs = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_abs,'Units','normalized')
set(ui_checkbox_abs,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_abs,'Position',[.65 .87 .20 .05])
set(ui_checkbox_abs,'String',' Absolute value ')
set(ui_checkbox_abs,'Value',false)
set(ui_checkbox_abs,'FontWeight','bold')
set(ui_checkbox_abs,'TooltipString','gets absolute values for rescaling')
set(ui_checkbox_abs,'Callback',{@cb_checkbox_abs})

ui_button_automatic = uicontrol(fig_subject,'Style','pushbutton');
set(ui_button_automatic,'Units','normalized')
set(ui_button_automatic,'Position',[.65 .76 .25 .08])
set(ui_button_automatic,'String','Automatic rescaling')
set(ui_button_automatic,'HorizontalAlignment','center')
set(ui_button_automatic,'Callback',{@cb_automatic})

ui_checkbox_symbolsize = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_symbolsize,'Units','normalized')
set(ui_checkbox_symbolsize,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_symbolsize,'Position',[.40 .645 .20 .05])
set(ui_checkbox_symbolsize,'String',' Symbol Size ')
set(ui_checkbox_symbolsize,'Value',false)
set(ui_checkbox_symbolsize,'FontWeight','bold')
set(ui_checkbox_symbolsize,'TooltipString','Shows brain regions by label')
set(ui_checkbox_symbolsize,'Callback',{@cb_checkbox_symbolsize})

ui_edit_symbolsize = uicontrol(fig_subject,'Style','edit');
set(ui_edit_symbolsize,'Units','normalized')
set(ui_edit_symbolsize,'String',PlotBrainGraph.INIT_SYM_SIZE)
set(ui_edit_symbolsize,'Enable','off')
set(ui_edit_symbolsize,'Position',[.67 .65 .20 .05])
set(ui_edit_symbolsize,'HorizontalAlignment','center')
set(ui_edit_symbolsize,'FontWeight','bold')
set(ui_edit_symbolsize,'Callback',{@cb_edit_symbolsize})

ui_checkbox_symbolcolor = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_symbolcolor,'Units','normalized')
set(ui_checkbox_symbolcolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_symbolcolor,'Position',[.40 .545 .23 .05])
set(ui_checkbox_symbolcolor,'String',' Symbol Color ')
set(ui_checkbox_symbolcolor,'Value',false)
set(ui_checkbox_symbolcolor,'FontWeight','bold')
set(ui_checkbox_symbolcolor,'TooltipString','Shows brain regions by label')
set(ui_checkbox_symbolcolor,'Callback',{@cb_checkbox_symbolcolor})

ui_popup_initcolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_initcolor,'Units','normalized')
set(ui_popup_initcolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_initcolor,'Enable','off')
set(ui_popup_initcolor,'Position',[.67 .55 .08 .05])
set(ui_popup_initcolor,'String',{'R','G','B'})
set(ui_popup_initcolor,'Value',3)
set(ui_popup_initcolor,'TooltipString','Select symbol');
set(ui_popup_initcolor,'Callback',{@cb_initcolor})

ui_popup_fincolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_fincolor,'Units','normalized')
set(ui_popup_fincolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_fincolor,'Enable','off')
set(ui_popup_fincolor,'Position',[.79 .55 .08 .05])
set(ui_popup_fincolor,'String',{'R','G','B'})
set(ui_popup_fincolor,'Value',1)
set(ui_popup_fincolor,'TooltipString','Select symbol');
set(ui_popup_fincolor,'Callback',{@cb_fincolor})

ui_checkbox_sphereradius = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_sphereradius,'Units','normalized')
set(ui_checkbox_sphereradius,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_sphereradius,'Position',[.40 0.445 .23 .05])
set(ui_checkbox_sphereradius,'String',' Sphere Radius ')
set(ui_checkbox_sphereradius,'Value',false)
set(ui_checkbox_sphereradius,'FontWeight','bold')
set(ui_checkbox_sphereradius,'TooltipString','Shows brain regions by label')
set(ui_checkbox_sphereradius,'Callback',{@cb_checkbox_sphereradius})

ui_edit_sphereradius = uicontrol(fig_subject,'Style','edit');
set(ui_edit_sphereradius,'Units','normalized')
set(ui_edit_sphereradius,'String',PlotBrainGraph.INIT_SPH_R)
set(ui_edit_sphereradius,'Enable','off')
set(ui_edit_sphereradius,'Position',[.67 0.45 .20 .05])
set(ui_edit_sphereradius,'HorizontalAlignment','center')
set(ui_edit_sphereradius,'FontWeight','bold')
set(ui_edit_sphereradius,'Callback',{@cb_edit_sphereradius})

ui_checkbox_spherecolor = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_spherecolor,'Units','normalized')
set(ui_checkbox_spherecolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_spherecolor,'Position',[.40 0.345 .45 .05])
set(ui_checkbox_spherecolor,'String',' Sphere Color ')
set(ui_checkbox_spherecolor,'Value',false)
set(ui_checkbox_spherecolor,'FontWeight','bold')
set(ui_checkbox_spherecolor,'TooltipString','Shows brain regions by label')
set(ui_checkbox_spherecolor,'Callback',{@cb_checkbox_spherecolor})

ui_popup_sphinitcolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_sphinitcolor,'Units','normalized')
set(ui_popup_sphinitcolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_sphinitcolor,'Enable','off')
set(ui_popup_sphinitcolor,'Position',[.67 .35 .08 .05])
set(ui_popup_sphinitcolor,'String',{'R','G','B'})
set(ui_popup_sphinitcolor,'Value',1)
set(ui_popup_sphinitcolor,'TooltipString','Select symbol');
set(ui_popup_sphinitcolor,'Callback',{@cb_sphinitcolor})

ui_popup_sphfincolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_sphfincolor,'Units','normalized')
set(ui_popup_sphfincolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_sphfincolor,'Enable','off')
set(ui_popup_sphfincolor,'Position',[.79 .35 .08 .05])
set(ui_popup_sphfincolor,'String',{'R','G','B'})
set(ui_popup_sphfincolor,'Value',3)
set(ui_popup_sphfincolor,'TooltipString','Select symbol');
set(ui_popup_sphfincolor,'Callback',{@cb_sphfincolor})

ui_checkbox_spheretransparency = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_spheretransparency,'Units','normalized')
set(ui_checkbox_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_spheretransparency,'Position',[.40 0.245 .25 .05])
set(ui_checkbox_spheretransparency,'String',' Sphere Transparency ')
set(ui_checkbox_spheretransparency,'Value',false)
set(ui_checkbox_spheretransparency,'FontWeight','bold')
set(ui_checkbox_spheretransparency,'TooltipString','Shows brain regions by label')
set(ui_checkbox_spheretransparency,'Callback',{@cb_checkbox_spheretransparency})

ui_slider_spheretransparency = uicontrol(fig_subject,'Style','slider');
set(ui_slider_spheretransparency,'Units','normalized')
set(ui_slider_spheretransparency,'BackgroundColor',GUI.BKGCOLOR)
set(ui_slider_spheretransparency,'Min',0,'Max',1,'Value',PlotBrainGraph.INIT_SPH_FACE_ALPHA);
set(ui_slider_spheretransparency,'Enable','off')
set(ui_slider_spheretransparency,'Position',[.67 0.25 .20 .05])
set(ui_slider_spheretransparency,'TooltipString','Brain region transparency (applied both to faces and edges)')
set(ui_slider_spheretransparency,'Callback',{@cb_slider_spheretransparency})

ui_checkbox_labelsize = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_labelsize,'Units','normalized')
set(ui_checkbox_labelsize,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_labelsize,'Position',[.40 .145 .20 .05])
set(ui_checkbox_labelsize,'String',' Label Size ')
set(ui_checkbox_labelsize,'Value',false)
set(ui_checkbox_labelsize,'FontWeight','bold')
set(ui_checkbox_labelsize,'TooltipString','Shows brain regions by label')
set(ui_checkbox_labelsize,'Callback',{@cb_checkbox_labelsize})

ui_edit_labelsize = uicontrol(fig_subject,'Style','edit');
set(ui_edit_labelsize,'Units','normalized')
set(ui_edit_labelsize,'String',PlotBrainGraph.INIT_LAB_FONT_SIZE)
set(ui_edit_labelsize,'Enable','off')
set(ui_edit_labelsize,'Position',[.67 .15 .20 .05])
set(ui_edit_labelsize,'HorizontalAlignment','center')
set(ui_edit_labelsize,'FontWeight','bold')
set(ui_edit_labelsize,'Callback',{@cb_edit_labelsize})

ui_checkbox_labelcolor = uicontrol(fig_subject,'Style', 'checkbox');
set(ui_checkbox_labelcolor,'Units','normalized')
set(ui_checkbox_labelcolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_checkbox_labelcolor,'Position',[.40 .045 .20 .05])
set(ui_checkbox_labelcolor,'String',' Label Color ')
set(ui_checkbox_labelcolor,'Value',false)
set(ui_checkbox_labelcolor,'FontWeight','bold')
set(ui_checkbox_labelcolor,'TooltipString','Shows brain regions by label')
set(ui_checkbox_labelcolor,'Callback',{@cb_checkbox_labelcolor})

ui_popup_labelinitcolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_labelinitcolor,'Units','normalized')
set(ui_popup_labelinitcolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_labelinitcolor,'Enable','off')
set(ui_popup_labelinitcolor,'Position',[.67 .05 .08 .05])
set(ui_popup_labelinitcolor,'String',{'R','G','B'})
set(ui_popup_labelinitcolor,'Value',1)
set(ui_popup_labelinitcolor,'TooltipString','Select symbol');
set(ui_popup_labelinitcolor,'Callback',{@cb_labelinitcolor})

ui_popup_labelfincolor = uicontrol(fig_subject,'Style','popup','String',{''});
set(ui_popup_labelfincolor,'Units','normalized')
set(ui_popup_labelfincolor,'BackgroundColor',GUI.BKGCOLOR)
set(ui_popup_labelfincolor,'Enable','off')
set(ui_popup_labelfincolor,'Position',[.79 .05 .08 .05])
set(ui_popup_labelfincolor,'String',{'R','G','B'})
set(ui_popup_labelfincolor,'Value',3)
set(ui_popup_labelfincolor,'TooltipString','Select symbol');
set(ui_popup_labelfincolor,'Callback',{@cb_labelfincolor})

set(fig_subject,'Visible','on')

update_subject_data()

    function cb_list(src,~)  %  (src,event)
        oldValues = get(src,'UserData');
        newValues = get(src,'Value');
        if numel(newValues) > 1
            newValues = oldValues;
        end
        set(src,'Value',newValues)
        set(src,'UserData',newValues)
        update_subject_data()
        update_brain_plot()
    end
    function cb_edit_offset(~,~)  %  (src,event)
        offset = real(str2num(get(ui_edit_offset,'String')));
        if isempty(offset)
            set(ui_edit_offset,'String','0')
        else
            set(ui_edit_offset,'String',num2str(offset))
        end
        update_brain_plot()
    end
    function cb_edit_rescaling(~,~)  %  (src,event)
        rescaling = real(str2num(get(ui_edit_rescaling,'String')));
        if isempty(rescaling) || rescaling<10^(-3) || rescaling>10^+3
            set(ui_edit_rescaling,'String','1')
        else
            set(ui_edit_rescaling,'String',num2str(rescaling))
        end
        update_brain_plot()
    end
    function cb_checkbox_abs(~,~)  %  (src,event)
        update_subject_data()
        update_brain_plot()
    end
    function cb_automatic(~,~)  %  (src,event)
        offset = min(subject_data);
        rescaling = max(subject_data) - offset;
        
        set(ui_edit_offset,'String',num2str(offset))
        set(ui_edit_rescaling,'String',num2str(rescaling))
        
        update_brain_plot()
    end

    function cb_checkbox_symbolsize(~,~)  %  (src,event)
        if get(ui_checkbox_symbolsize,'Value')
            set(ui_edit_symbolsize,'Enable','on')
            update_brain_plot()
        else
            size = str2num(get(ui_edit_symbolsize,'String'));
            size = 1 + size;
            ba.br_syms([],'Size',size);
            
            set(ui_edit_symbolsize,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_edit_symbolsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_symbolsize,'String')));
        if isempty(size) || size<0
            set(ui_edit_symbolsize,'String','1')
            size = 5;
        end
        update_brain_plot()
    end
    function cb_checkbox_symbolcolor(~,~)  %  (src,event)
        if get(ui_checkbox_symbolcolor,'Value')
            set(ui_popup_initcolor,'Enable','on')
            set(ui_popup_fincolor,'Enable','on')
            update_brain_plot()
        else
            val = get(ui_popup_initcolor,'Value');
            str = get(ui_popup_initcolor,'String');
            ba.br_syms([],'Color',str{val});
            
            set(ui_popup_initcolor,'Enable','off')
            set(ui_popup_fincolor,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_initcolor(~,~)  %  (src,event)
        update_brain_plot()
    end
    function cb_fincolor(~,~)  %  (src,event)
        update_brain_plot()
    end

    function cb_checkbox_sphereradius(~,~)  %  (src,event)
        if get(ui_checkbox_sphereradius,'Value')
            set(ui_edit_sphereradius,'Enable','on')
            update_brain_plot()
        else
            R = str2num(get(ui_edit_sphereradius,'String'));
            R = R + 1;
            ba.br_sphs([],'R',R);
            
            set(ui_edit_sphereradius,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_edit_sphereradius(~,~)  %  (src,event)
        R = real(str2num(get(ui_edit_sphereradius,'String')));
        if isempty(R) || R<0
            set(ui_edit_sphereradius,'String','1')
            R = 3;
        end
        update_brain_plot()
    end
    function cb_checkbox_spherecolor(~,~)  %  (src,event)
        if get(ui_checkbox_spherecolor,'Value')
            set(ui_popup_sphinitcolor,'Enable','on')
            set(ui_popup_sphfincolor,'Enable','on')
            update_brain_plot()
        else
            val = get(ui_popup_sphinitcolor,'Value');
            str = get(ui_popup_sphinitcolor,'String');
            ba.br_sphs([],'Color',str{val});
            
            set(ui_popup_sphinitcolor,'Enable','off')
            set(ui_popup_sphfincolor,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_sphinitcolor(~,~)  %  (src,event)
        update_brain_plot()
    end
    function cb_sphfincolor(~,~)  %  (src,event)
        update_brain_plot()
    end
    function cb_checkbox_spheretransparency(~,~)  %  (src,event)
        if get(ui_checkbox_spheretransparency,'Value')
            set(ui_slider_spheretransparency,'Enable','on')
            update_brain_plot()
        else
            alpha = get(ui_slider_spheretransparency,'Value');
            ba.br_sphs([],'Alpha',alpha);
            
            set(ui_slider_spheretransparency,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_slider_spheretransparency(~,~)  %  (src,event)
        update_brain_plot();
    end

    function cb_checkbox_labelsize(~,~)  %  (src,event)
        if get(ui_checkbox_labelsize,'Value')
            set(ui_edit_labelsize,'Enable','on')
            update_brain_plot()
        else
            size = str2num(get(ui_edit_labelsize,'String'));
            size = size + 1;
            ba.br_labs([],'FontSize',size);
            
            set(ui_edit_labelsize,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_edit_labelsize(~,~)  %  (src,event)
        size = real(str2num(get(ui_edit_labelsize,'String')));
        if isempty(size) || size<0
            set(ui_edit_labelsize,'String','1')
            size = 5;
        end
        update_brain_plot()
    end
    function cb_checkbox_labelcolor(~,~)  %  (src,event)
        if get(ui_checkbox_labelcolor,'Value')
            set(ui_popup_labelinitcolor,'Enable','on')
            set(ui_popup_labelfincolor,'Enable','on')
            update_brain_plot()
        else
            val = get(ui_popup_labelinitcolor,'Value');
            str = get(ui_popup_labelinitcolor,'String');
            ba.br_labs([],'Color',str{val});
            
            set(ui_popup_labelinitcolor,'Enable','off')
            set(ui_popup_labelfincolor,'Enable','off')
            update_brain_plot()
        end
    end
    function cb_labelinitcolor(~,~)  %  (src,event)
        update_brain_plot()
    end
    function cb_labelfincolor(~,~)  %  (src,event)
        update_brain_plot()
    end

    function update_brain_plot()
        if get(ui_checkbox_symbolsize,'Value')
            
            size = str2num(get(ui_edit_symbolsize,'String'));
            offset = str2num(get(ui_edit_offset,'String'));
            rescaling = str2num(get(ui_edit_rescaling,'String'));
            
            size = 1 + ((subject_data - offset)./rescaling)*size;
            size(size<0) = 0.1;
            ba.br_syms([],'Size',size);
        end
        
        if get(ui_checkbox_symbolcolor,'Value')
            
            % colors vector (0 - 1)
            colorValue = (subject_data - min(subject_data))./(max(subject_data)-min(subject_data));
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_initcolor,'Value');
            val2 = get(ui_popup_fincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            ba.br_syms([],'Color',C);
            
        end
        
        if get(ui_checkbox_sphereradius,'Value')
            
            R = str2num(get(ui_edit_sphereradius,'String'));
            offset =  str2num(get(ui_edit_offset,'String'));
            rescaling = str2num(get(ui_edit_rescaling,'String'));
            
            R = 1 + ((subject_data - offset)./rescaling)*R;
            R(R<0) = 0.1;
            ba.br_sphs([],'R',R);
            
        end
        
        if get(ui_checkbox_spherecolor,'Value')
            
            % colors vector (0 - 1)
            colorValue = (subject_data - min(subject_data))./(max(subject_data)-min(subject_data));
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_sphinitcolor,'Value');
            val2 = get(ui_popup_sphfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            ba.br_sphs([],'Color',C);
            
        end
        
        if get(ui_checkbox_spheretransparency,'Value')
            
            alpha = get(ui_slider_spheretransparency,'Value');
            offset =  str2num(get(ui_edit_offset,'String'));
            rescaling = str2num(get(ui_edit_rescaling,'String'));
            
            alpha_vec = ((subject_data - offset)./rescaling).*alpha;
            alpha_vec(alpha_vec<0) = 0;
            alpha_vec(alpha_vec>1) = 1;
            ba.br_sphs([],'Alpha',alpha_vec);
            
        end
        
        if get(ui_checkbox_labelsize,'Value')
            
            size = str2num(get(ui_edit_labelsize,'String'));
            offset =  str2num(get(ui_edit_offset,'String'));
            rescaling = str2num(get(ui_edit_rescaling,'String'));
            
            size = 1 + ((subject_data - offset)./rescaling)*size;
            size(size<0) = 0.1;
            ba.br_labs([],'FontSize',size);
            
        end
        
        if get(ui_checkbox_labelcolor,'Value')
            
            % colors vector (0 - 1)
            colorValue = (subject_data - min(subject_data))./(max(subject_data)-min(subject_data));
            C = zeros(length(colorValue),3);
            
            val1 = get(ui_popup_labelinitcolor,'Value');
            val2 = get(ui_popup_labelfincolor,'Value');
            C(:,val1) = colorValue;
            C(:,val2) = 1 - colorValue;
            ba.br_labs([],'Color',C);
            
        end
        
    end
    function update_subject_data()
        i = get(ui_list,'Value');
        if isempty(i) || length(i)>1
            i = 1;
        end
        if get(ui_checkbox_abs,'Value')
            subject_data = abs(cohort.get(i).getProp(MRISubject.DATA));
        else
            subject_data = cohort.get(i).getProp(MRISubject.DATA);
        end
    end
end