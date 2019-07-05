function GUIfMRIGraphAnalysisWUSetGraph(f,ga,bg)

APPNAME = [GUI.fMGA_NAME];  % application name
NAME_GRAPH = [APPNAME ' : Weighted Undirected Graph ' ];
fig_graph = GUI.init_figure(NAME_GRAPH,.2,.5,'west');

ui_text_graph_group = uicontrol(fig_graph,'Style','text');
ui_popup_graph_group = uicontrol(fig_graph,'Style','popup','String',{''});
ui_checkbox_graph_density = uicontrol(fig_graph,'Style','checkbox');
ui_text_graph_density = uicontrol(fig_graph,'Style','text');
ui_edit_graph_bs = uicontrol(fig_graph,'Style','edit');
ui_slider_graph_bs = uicontrol(fig_graph,'Style','slider');
ui_checkbox_graph_threshold = uicontrol(fig_graph,'Style','checkbox');
ui_text_graph_threshold = uicontrol(fig_graph,'Style','text');
ui_edit_graph_bt = uicontrol(fig_graph,'Style','edit');
ui_slider_graph_bt = uicontrol(fig_graph,'Style','slider');
ui_checkbox_graph_weighted = uicontrol(fig_graph,'Style','checkbox');
ui_checkbox_graph_linecolor = uicontrol(fig_graph,'Style', 'checkbox');
ui_popup_graph_initcolor = uicontrol(fig_graph,'Style','popup','String',{''});
ui_popup_graph_fincolor = uicontrol(fig_graph,'Style','popup','String',{''});
ui_checkbox_graph_lineweight = uicontrol(fig_graph,'Style', 'checkbox');
ui_edit_graph_lineweight = uicontrol(fig_graph,'Style','edit');
ui_button_graph_show = uicontrol(fig_graph,'Style','pushbutton');
ui_button_graph_hide = uicontrol(fig_graph,'Style','pushbutton');
ui_button_graph_color = uicontrol(fig_graph,'Style','pushbutton');
ui_text_graph_thickness = uicontrol(fig_graph,'Style','text');
ui_edit_graph_thickness = uicontrol(fig_graph,'Style','edit');

init_BUDgraph()
update_popups_grouplists()
update_graph()

%% Make the GUI visible.
set(fig_graph,'Visible','on');

    function init_BUDgraph()
        
        set(ui_text_graph_group,'Units','normalized')
        set(ui_text_graph_group,'Position',[.05 .86 .20 .10])
        set(ui_text_graph_group,'String','Group  ')
        set(ui_text_graph_group,'HorizontalAlignment','left')
        set(ui_text_graph_group,'FontWeight','bold')
        set(ui_text_graph_group,'FontSize',10)
        
        set(ui_popup_graph_group,'Units','normalized')
        set(ui_popup_graph_group,'Position',[.33 .87 .40 .10])
        set(ui_popup_graph_group,'TooltipString','Select group');
        set(ui_popup_graph_group,'Callback',{@cb_popup_group})
        
        set(ui_checkbox_graph_density,'Units','normalized')
        set(ui_checkbox_graph_density,'Position',[.05 .780 .40 .146])
        set(ui_checkbox_graph_density,'String','Fix density')
        set(ui_checkbox_graph_density,'Value',true)
        set(ui_checkbox_graph_density,'TooltipString','Select density')
        set(ui_checkbox_graph_density,'FontWeight','bold')
        set(ui_checkbox_graph_density,'Callback',{@cb_checkbox_density})
        
        set(ui_text_graph_density,'Units','normalized')
        set(ui_text_graph_density,'Position',[.05 .705 .20 .10])
        set(ui_text_graph_density,'String','Density  ')
        set(ui_text_graph_density,'HorizontalAlignment','left')
        set(ui_text_graph_density,'FontWeight','bold')
        set(ui_text_graph_density,'FontSize',10)
        
        set(ui_edit_graph_bs,'Units','normalized')
        set(ui_edit_graph_bs,'Position',[.760 .760 .20 .05])
        set(ui_edit_graph_bs,'String','50.00');
        set(ui_edit_graph_bs,'TooltipString','Set density.');
        set(ui_edit_graph_bs,'FontWeight','bold')
        set(ui_edit_graph_bs,'Callback',{@cb_graph_edit_bs});
        
        set(ui_slider_graph_bs,'Units','normalized')
        set(ui_slider_graph_bs,'Position',[.33 .760 .40 .05])
        set(ui_slider_graph_bs,'Min',0,'Max',100,'Value',50)
        set(ui_slider_graph_bs,'TooltipString','Set density.')
        set(ui_slider_graph_bs,'Callback',{@cb_graph_slider_bs})
        
        set(ui_checkbox_graph_threshold,'Units','normalized')
        set(ui_checkbox_graph_threshold,'Position',[.05 .60 .40 .15])
        set(ui_checkbox_graph_threshold,'String','Fix threshold')
        set(ui_checkbox_graph_threshold,'Value',false)
        set(ui_checkbox_graph_threshold,'TooltipString','Select density')
        set(ui_checkbox_graph_threshold,'FontWeight','bold')
        set(ui_checkbox_graph_threshold,'Callback',{@cb_checkbox_threshold})
        
        set(ui_text_graph_threshold,'Units','normalized')
        set(ui_text_graph_threshold,'Enable','off')
        set(ui_text_graph_threshold,'Position',[.05 .515 .25 .10])
        set(ui_text_graph_threshold,'String','Threshold  ')
        set(ui_text_graph_threshold,'HorizontalAlignment','left')
        set(ui_text_graph_threshold,'FontWeight','bold')
        set(ui_text_graph_threshold,'FontSize',10)
        
        set(ui_edit_graph_bt,'Units','normalized')
        set(ui_edit_graph_bt,'Enable','off')
        set(ui_edit_graph_bt,'Position',[.760 .570 .20 .05])
        set(ui_edit_graph_bt,'String','0');
        set(ui_edit_graph_bt,'TooltipString','Set threshold.');
        set(ui_edit_graph_bt,'FontWeight','bold')
        set(ui_edit_graph_bt,'Callback',{@cb_graph_edit_bt});
        
        set(ui_slider_graph_bt,'Units','normalized')
        set(ui_slider_graph_bt,'Enable','off')
        set(ui_slider_graph_bt,'Position',[.33 .570 .40 .05])
        set(ui_slider_graph_bt,'Min',-1,'Max',1,'Value',0)
        set(ui_slider_graph_bt,'TooltipString','Set threshold.')
        set(ui_slider_graph_bt,'Callback',{@cb_graph_slider_bt})
        
        set(ui_checkbox_graph_weighted,'Units','normalized')
        set(ui_checkbox_graph_weighted,'Position',[.05 .40 .40 .15])
        set(ui_checkbox_graph_weighted,'String','Weighted graph')
        set(ui_checkbox_graph_weighted,'Value',false)
        set(ui_checkbox_graph_weighted,'TooltipString','Select density')
        set(ui_checkbox_graph_weighted,'FontWeight','bold')
        set(ui_checkbox_graph_weighted,'Callback',{@cb_checkbox_weighted})
        
        set(ui_checkbox_graph_linecolor,'Units','normalized')
        set(ui_checkbox_graph_linecolor,'Enable','off')
        set(ui_checkbox_graph_linecolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_graph_linecolor,'Position',[.10 .340 .23 .10])
        set(ui_checkbox_graph_linecolor,'String',' Color ')
        set(ui_checkbox_graph_linecolor,'Value',false)
        set(ui_checkbox_graph_linecolor,'FontWeight','bold')
        set(ui_checkbox_graph_linecolor,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_graph_linecolor,'Callback',{@cb_checkbox_linecolor})
        
        set(ui_popup_graph_initcolor,'Units','normalized')
        set(ui_popup_graph_initcolor,'Enable','off')
        set(ui_popup_graph_initcolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_graph_initcolor,'Enable','off')
        set(ui_popup_graph_initcolor,'Position',[.355 .315 .155 .10])
        set(ui_popup_graph_initcolor,'String',{'R','G','B'})
        set(ui_popup_graph_initcolor,'Value',3)
        set(ui_popup_graph_initcolor,'TooltipString','Select symbol');
        set(ui_popup_graph_initcolor,'Callback',{@cb_popup_initcolor})
        
        set(ui_popup_graph_fincolor,'Units','normalized')
        set(ui_popup_graph_fincolor,'Enable','off')
        set(ui_popup_graph_fincolor,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_popup_graph_fincolor,'Enable','off')
        set(ui_popup_graph_fincolor,'Position',[.575 .315 .155 .10])
        set(ui_popup_graph_fincolor,'String',{'R','G','B'})
        set(ui_popup_graph_fincolor,'Value',1)
        set(ui_popup_graph_fincolor,'TooltipString','Select symbol');
        set(ui_popup_graph_fincolor,'Callback',{@cb_popup_fincolor})
        
        set(ui_checkbox_graph_lineweight,'Units','normalized')
        set(ui_checkbox_graph_lineweight,'Enable','off')
        set(ui_checkbox_graph_lineweight,'BackgroundColor',GUI.BKGCOLOR)
        set(ui_checkbox_graph_lineweight,'Position',[.10 .270 .28 .10])
        set(ui_checkbox_graph_lineweight,'String',' Thickness ')
        set(ui_checkbox_graph_lineweight,'Value',false)
        set(ui_checkbox_graph_lineweight,'FontWeight','bold')
        set(ui_checkbox_graph_lineweight,'TooltipString','Shows brain regions by label')
        set(ui_checkbox_graph_lineweight,'Callback',{@cb_checkbox_lineweight})
        
        set(ui_edit_graph_lineweight,'Units','normalized')
        set(ui_edit_graph_lineweight,'Enable','off')
        set(ui_edit_graph_lineweight,'Position',[.35 .29 .38 .05])
        set(ui_edit_graph_lineweight,'String','1');
        set(ui_edit_graph_lineweight,'TooltipString','Set line weight.');
        set(ui_edit_graph_lineweight,'FontWeight','bold')
        set(ui_edit_graph_lineweight,'Callback',{@cb_edit_lineweight});
        
        set(ui_button_graph_show,'Units','normalized')
        set(ui_button_graph_show,'Position',[.05 .16 .20 .08])
        set(ui_button_graph_show,'String',' Show ')
        set(ui_button_graph_show,'HorizontalAlignment','center')
        set(ui_button_graph_show,'FontWeight','bold')
        set(ui_button_graph_show,'FontSize',10)
        set(ui_button_graph_show,'Callback',{@cb_graph_show})
        
        set(ui_button_graph_hide,'Units','normalized')
        set(ui_button_graph_hide,'Position',[.405 .16 .20 .08])
        set(ui_button_graph_hide,'String',' Hide ')
        set(ui_button_graph_hide,'HorizontalAlignment','center')
        set(ui_button_graph_hide,'FontWeight','bold')
        set(ui_button_graph_hide,'FontSize',10)
        set(ui_button_graph_hide,'Callback',{@cb_graph_hide})
        
        set(ui_button_graph_color,'Units','normalized')
        set(ui_button_graph_color,'Position',[.76 .16 .20 .08])
        set(ui_button_graph_color,'String',' Color ')
        set(ui_button_graph_color,'HorizontalAlignment','center')
        set(ui_button_graph_color,'FontWeight','bold')
        set(ui_button_graph_color,'FontSize',10)
        set(ui_button_graph_color,'Callback',{@cb_graph_color})
        
        set(ui_text_graph_thickness,'Units','normalized')
        set(ui_text_graph_thickness,'Position',[.05 .0 .30 .10])
        set(ui_text_graph_thickness,'String','Set thickness  ')
        set(ui_text_graph_thickness,'HorizontalAlignment','left')
        set(ui_text_graph_thickness,'FontWeight','bold')
        set(ui_text_graph_thickness,'FontSize',10)
        
        set(ui_edit_graph_thickness,'Units','normalized')
        set(ui_edit_graph_thickness,'Position',[.405 .06 .20 .05])
        set(ui_edit_graph_thickness,'String','1');
        set(ui_edit_graph_thickness,'TooltipString','Set density.');
        set(ui_edit_graph_thickness,'FontWeight','bold')
        set(ui_edit_graph_thickness,'Callback',{@cb_graph_thickness});
    end
    function cb_checkbox_density(~,~)  % (src,event)
        if get(ui_checkbox_graph_density,'Value')
            
            set(ui_slider_graph_bs,'Enable','on')
            set(ui_text_graph_density,'Enable','on')
            set(ui_edit_graph_bs,'Enable','on')
            set(ui_edit_graph_thickness,'enable','on')
            
            set(ui_checkbox_graph_threshold,'Value',false)
            set(ui_slider_graph_bt,'Enable','off')
            set(ui_text_graph_threshold,'Enable','off')
            set(ui_edit_graph_bt,'Enable','off')
            
            set(ui_checkbox_graph_weighted,'Value',false)
            set(ui_checkbox_graph_linecolor,'Enable','off')
            set(ui_checkbox_graph_linecolor,'Value',false)
            set(ui_popup_graph_initcolor,'Enable','off')
            set(ui_popup_graph_fincolor,'Enable','off')
            set(ui_checkbox_graph_lineweight,'Enable','off')
            set(ui_checkbox_graph_lineweight,'Value',false)
            set(ui_edit_graph_lineweight,'Enable','off')
            
            update_graph()
        else
            set(ui_checkbox_graph_density,'Value',true)
        end
    end
    function cb_checkbox_threshold(~,~)  % (src,event)
        if get(ui_checkbox_graph_threshold,'Value')
            
            set(ui_slider_graph_bt,'Enable','on')
            set(ui_text_graph_threshold,'Enable','on')
            set(ui_edit_graph_bt,'Enable','on')
            set(ui_edit_graph_thickness,'enable','on')
            
            set(ui_checkbox_graph_density,'Value',false)
            set(ui_slider_graph_bs,'Enable','off')
            set(ui_text_graph_density,'Enable','off')
            set(ui_edit_graph_bs,'Enable','off')
            
            set(ui_checkbox_graph_weighted,'Value',false)
            set(ui_checkbox_graph_linecolor,'Enable','off')
            set(ui_checkbox_graph_linecolor,'Value',false)
            set(ui_popup_graph_initcolor,'Enable','off')
            set(ui_popup_graph_fincolor,'Enable','off')
            set(ui_checkbox_graph_lineweight,'Enable','off')
            set(ui_checkbox_graph_lineweight,'Value',false)
            set(ui_edit_graph_lineweight,'Enable','off')
            
            update_graph()
        else
            set(ui_checkbox_graph_threshold,'Value',true)
        end
    end
    function cb_checkbox_weighted(~,~)  % (src,event)
        if get(ui_checkbox_graph_weighted,'Value')
            
            set(ui_checkbox_graph_linecolor,'Enable','on')
            set(ui_checkbox_graph_lineweight,'Enable','on')
            set(ui_edit_graph_thickness,'enable','off')
            
            set(ui_checkbox_graph_threshold,'Value',false)
            set(ui_text_graph_threshold,'Enable','off')
            set(ui_slider_graph_bt,'Enable','off')
            set(ui_edit_graph_bt,'Enable','off')
            
            set(ui_checkbox_graph_density,'Value',false)
            set(ui_slider_graph_bs,'Enable','off')
            set(ui_text_graph_density,'Enable','off')
            set(ui_edit_graph_bs,'Enable','off')
        else
            set(ui_checkbox_graph_weighted,'Enable','on')
        end
    end
    function cb_checkbox_linecolor(~,~)  % (src,event)
        if get(ui_checkbox_graph_linecolor,'Value')
            set(ui_popup_graph_initcolor,'Enable','on')
            set(ui_popup_graph_fincolor,'Enable','on')
            update_graph()
        else
            set(ui_popup_graph_initcolor,'Enable','off')
            set(ui_popup_graph_fincolor,'Enable','off')
            
            g = get(ui_popup_graph_group,'Value');
            groupdata = ga.getCohort().getGroup(g).getProp(Group.DATA);
            indices = find(groupdata==true);
            Ad = zeros(ga.getCohort().getBrainAtlas.length());
            for i=1:1:length(indices)
                Ad = Ad+ga.getA(indices(i));
            end
            
            Ad = Ad/length(indices);
            graph = GraphWU(Ad);
            A = graph.A;
            for indices = 1:1:numel(A)
                [row,column] = ind2sub(size(A), indices);
                bg.link_lins(row,column,'Color',[0 0 0])
            end
        end
    end
    function cb_checkbox_lineweight(~,~)  % (src,event)
        if get(ui_checkbox_graph_lineweight,'Value')
            set(ui_edit_graph_lineweight,'Enable','on')
            update_graph()
        else
            set(ui_edit_graph_lineweight,'Enable','off')
            
            g = get(ui_popup_graph_group,'Value');
            groupdata = ga.getCohort().getGroup(g).getProp(Group.DATA);
            indices = find(groupdata==true);
            Ad = zeros(ga.getCohort().getBrainAtlas.length());
            for i=1:1:length(indices)
                Ad = Ad+ga.getA(indices(i));
            end
            
            Ad = Ad/length(indices);
            graph = GraphWU(Ad);
            A = graph.A;
            weight = str2num(get(ui_edit_graph_lineweight,'String'));
            for indices = 1:1:numel(A)
                [row,column] = ind2sub(size(A), indices);
                bg.link_lins(row,column,'LineWidth',weight)
            end
        end
    end
    function cb_graph_edit_bs(~,~)  % (src,event)
        density = real(str2num(get(ui_edit_graph_bs,'String')));
        if isnan(density) || density <= 0 || density > 100
            set(ui_edit_graph_bs,'String','50');
            set(ui_slider_graph_bs,'Value',str2num(get(ui_edit_graph_bs,'String')));
        else
            set(ui_slider_graph_bs,'Value',density);
        end
        update_graph()
    end
    function cb_graph_slider_bs(src,~)  % (src,event)
        set(ui_edit_graph_bs,'String',get(src,'Value'))
        update_graph()
    end
    function cb_graph_edit_bt(~,~)  % (src,event)
        threshold = real(str2num(get(ui_edit_graph_bt,'String')));
        if isnan(threshold) || threshold < -1 || threshold > 1
            set(ui_edit_graph_bt,'String','0');
            set(ui_slider_graph_bt,'Value',str2num(get(ui_edit_graph_bt,'String')));
        else
            set(ui_slider_graph_bt,'Value',threshold);
        end
        update_graph()
    end
    function cb_graph_slider_bt(src,~)  % (src,event)
        set(ui_edit_graph_bt,'String',get(src,'Value'))
        update_graph()
    end
    function cb_edit_lineweight(~,~)  % (src,event)
        weigth = real(str2num(get(ui_edit_graph_bs,'String')));
        if isnan(weigth) || weigth <= 0
            set(ui_edit_graph_lineweight,'String','5');
        end
        update_graph()
    end
    function cb_popup_initcolor(~,~)  % (src,event)
        update_graph()
    end
    function cb_popup_fincolor(~,~)  % (src,event)
        update_graph()
    end
    function cb_popup_group(~,~)  % (src,event)
        update_graph()
    end
    function cb_graph_show(~,~)  % (src,event)
        update_graph()
    end
    function cb_graph_hide(~,~)  % (src,event)
        bg.link_lins_off([],[])
    end
    function cb_graph_color(~,~)  % (src,event)
        color = uisetcolor();
        if length(color)==3
            for i = 1:1:ga.getBrainAtlas.length()
                for j = 1:1:ga.getBrainAtlas.length()
                   bool = link_lin_is_on(bg,i,j);
                   if bool
                        bg.link_lin(i,j,'Color',color)
                   end
                end
            end
        end
    end
    function cb_graph_thickness(~,~)  % (src,event)
        thickness = real(str2num(get(ui_edit_graph_thickness,'String')));
        if isnan(thickness) || thickness <= 0
            set(ui_edit_graph_thickness,'String','1');
        end
        update_graph()
    end
    function update_graph()
            g = get(ui_popup_graph_group,'Value');  % selected group
            groupdata = ga.getCohort.getGroup(g).getProp(Group.DATA);
            indices = find(groupdata==true);
            A = zeros(ga.getCohort.getBrainAtlas.length());
            for i=1:1:length(indices)
                A = A+ga.getA(indices(i));
            end
            A = A/length(indices);
              
        if get(ui_checkbox_graph_weighted,'Value')
            
            if get(ui_checkbox_graph_linecolor,'Value')
                graph = GraphWU(A);
                A = graph.A;
                reshA = reshape(A,[1,numel(A)]);
                
                reshA(reshA<0) = 0;
                reshA(reshA>1) = 1;
                
                C = zeros(length(reshA),3);
                val1 = get(ui_popup_graph_initcolor,'Value');
                val2 = get(ui_popup_graph_fincolor,'Value');
                C(:,val1) = reshA;
                C(:,val2) = 1 - reshA;
                
                ui_contextmenu_links = uicontextmenu('Parent',f);
                ui_contextmenu_links_settings = uimenu(ui_contextmenu_links);
                set(ui_contextmenu_links_settings,'Label','Set links settings')
                set(ui_contextmenu_links_settings,'Callback',{@cb_graph_links_settings})

                for indices = 1:1:length(reshA)
                    [row,column] = ind2sub(size(A), indices);
                    bg.link_lins(row,column,'Color',[C(indices,1) C(indices,2) C(indices,3)],'UIContextMenu',ui_contextmenu_links)
                end
            end
            
            if get(ui_checkbox_graph_lineweight,'Value')
                graph = GraphWU(A);
                A = graph.A;
                reshA = reshape(A,[1,numel(A)]);
                
                reshA(reshA<0) = 0;
                reshA(reshA>1) = 1;
                
                weight = str2num(get(ui_edit_graph_lineweight,'String'));
                weight_fin = 1 + reshA*weight;
                
                ui_contextmenu_links = uicontextmenu('Parent',f);
                ui_contextmenu_links_settings = uimenu(ui_contextmenu_links);
                set(ui_contextmenu_links_settings,'Label','Set links settings')
                set(ui_contextmenu_links_settings,'Callback',{@cb_graph_links_settings})
                
                for indices = 1:1:length(reshA)
                    [row,column] = ind2sub(size(A), indices);
                    bg.link_lins(row,column,'LineWidth',weight_fin(indices),'UIContextMenu',ui_contextmenu_links)
                end
            end
        else
            if get(ui_checkbox_graph_density,'Value')
                density = str2num(get(ui_edit_graph_bs,'String'));
                graph = GraphBU(A,'density',density);
            end
            if get(ui_checkbox_graph_threshold,'Value')
                threshold = str2num(get(ui_edit_graph_bt,'String'));
                graph = GraphBU(A,'threshold',threshold);
            end
            
            A = graph.A;
            indices = find(A~=0);
            [row,column] = ind2sub(size(A), indices);
            
            ui_contextmenu_links = uicontextmenu('Parent',f);
            ui_contextmenu_links_settings = uimenu(ui_contextmenu_links);
            set(ui_contextmenu_links_settings,'Label','Set links settings')
            set(ui_contextmenu_links_settings,'Callback',{@cb_graph_links_settings})
            
            thickness = str2num(get(ui_edit_graph_thickness,'String'));
            bg.link_lins_off([],[])
            bg.link_lins(row,column,'LineWidth',thickness,'UIContextMenu',ui_contextmenu_links)
            bg.link_lins_on(row,column)
            
            set(ui_edit_graph_bt,'String',num2str(graph.threshold,'%6.3f'))
            set(ui_slider_graph_bt,'Value',graph.threshold)
            
            set(ui_edit_graph_bs,'String',num2str(graph.density,'%6.2f'))
            set(ui_slider_graph_bs,'Value',graph.density)
        end
    end
    function cb_graph_links_settings(~,~)  % (src,event)
        
        [i,j] = bg.get_line_ij(gco);
        
        if isfinite(i) && isfinite(j)
            bg.link_lins_settings(i,j);%('FigName',[APPNAME ' - ' BRAINVIEW_LAB_SETTINGS ' - '])
        else
            bg.link_lins_settings([],[]);
        end
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
        set(ui_popup_graph_group,'String',GroupList)
    end
end