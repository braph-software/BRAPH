function f = GUIPETGraphAnalysisStructure(f,ga,restricted,varargin)

%% General Constants
FigName = [GUI.PGA_NAME ' : Community structure - ' BNC.VERSION ' - ' ga.getProp(PETGraphAnalysis.NAME)];
FigPosition = [.05 .10 .90 .80];
FigColor = GUI.BKGCOLOR;
for n = 1:2:length(varargin)
    switch lower(varargin{n})
        case 'figname'
            FigName = varargin{n+1};
        case 'figposition'
            FigPosition = varargin{n+1};
        case 'figcolor'
            FigColor = varargin{n+1};
    end
end

% Dimensions
MARGIN_X = .02;
MARGIN_Y = .02;
HEIGHT = 1-2*MARGIN_Y;

%% Application data

% atlas
atlas = ga.getBrainAtlas();
ba = PlotBrainAtlas(atlas);
colors = get(groot,'DefaultAxesColorOrder');

% structure
cs = copy(ga.getStructure());  % deep copy of structure

%% GUI Inizialization
if isempty(f) || ~ishandle(f)
    f = figure('Visible','off');
end
set(f,'units','normalized')
set(f,'Position',FigPosition)
set(f,'Color',FigColor)
set(f,'Name',FigName)
set(f,'MenuBar','none')
set(f,'Toolbar','none')
set(f,'NumberTitle','off')
set(f,'DockControls','off')

%% Panel Table
TAB_LABELS_COL = 1;
TAB_TITLE_CMD = 'Community Structure';

TAB_NOTES_FIXED = 'Custom community structure';

TABLE_X0 = MARGIN_X;
TABLE_Y0 = MARGIN_Y;
TABLE_WIDTH = .5-2*MARGIN_Y;
TABLE_HEIGHT = HEIGHT;
TABLE_POSITION = [TABLE_X0 TABLE_Y0 TABLE_WIDTH TABLE_HEIGHT];

ui_panel_table = uipanel('Parent',f);
ui_table = uitable(ui_panel_table);

ui_checkbox_table_fixed = uicontrol(ui_panel_table,'Style', 'checkbox');
ui_checkbox_table_dynamic = uicontrol(ui_panel_table,'Style', 'checkbox');
ui_checkbox_table_newman = uicontrol(ui_panel_table,'Style', 'checkbox');
ui_checkbox_table_louvain = uicontrol(ui_panel_table,'Style', 'checkbox');
ui_text_table_gamma = uicontrol(ui_panel_table,'Style', 'text');
ui_edit_table_gamma = uicontrol(ui_panel_table,'Style', 'edit');
ui_popup_table_group = uicontrol(ui_panel_table,'Style','popup','String',{''});
ui_text_table_parameter = uicontrol(ui_panel_table,'Style','text');
ui_edit_table_parameter = uicontrol(ui_panel_table,'Style','edit');
ui_button_table_set = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_reset = uicontrol(ui_panel_table,'Style', 'pushbutton');
ui_button_table_calc = uicontrol(ui_panel_table,'Style', 'pushbutton');
init_table()
    function init_table()
        GUI.setUnits(ui_panel_table)
        GUI.setBackgroundColor(ui_panel_table)
        
        set(ui_panel_table,'Position',TABLE_POSITION)
        set(ui_panel_table,'Title',TAB_TITLE_CMD)
        
        set(ui_table,'Position',[.02 .22 .96 .76])
        set(ui_table,'ColumnEditable',true)
        set(ui_table,'CellEditCallback',{@cb_table_edit});
        
        set(ui_checkbox_table_fixed,'Position',[0.02 0.16 .20 .04])
        set(ui_checkbox_table_fixed,'String','Fixed structure')
        set(ui_checkbox_table_fixed,'TooltipString','Fix the community structure for future use')
        set(ui_checkbox_table_fixed,'Callback',{@cd_table_fixed})
        
        set(ui_checkbox_table_dynamic,'Position',[0.30 0.16 .20 .04])
        set(ui_checkbox_table_dynamic,'String','Dynamic structure')
        set(ui_checkbox_table_dynamic,'TooltipString','Recalculate the community structure every time')
        set(ui_checkbox_table_dynamic,'Callback',{@cd_table_dynamic})
        
        set(ui_checkbox_table_louvain,'Position',[0.52 0.16 .20 .04])
        set(ui_checkbox_table_louvain,'String','Louvain algorithm')
        set(ui_checkbox_table_louvain,'TooltipString','Calculate community structure using Louvain algorithm')
        set(ui_checkbox_table_louvain,'Callback',{@cd_table_louvain})
        
        set(ui_checkbox_table_newman,'Position',[0.52 0.11 .20 .04])
        set(ui_checkbox_table_newman,'String','Newman algorithm')
        set(ui_checkbox_table_newman,'TooltipString','Calculate community structure using Newman algorithm')
        set(ui_checkbox_table_newman,'Callback',{@cd_table_newman})
        
        set(ui_text_table_gamma,'Position',[0.52 0.07 .07 .02])
        set(ui_text_table_gamma,'String','Gamma')
        set(ui_text_table_gamma,'TooltipString','Gamma parameter for community structure calculation')
        set(ui_edit_table_gamma,'Position',[0.60 0.07 .07 .02])
        set(ui_edit_table_gamma,'String','1')
        set(ui_edit_table_gamma,'TooltipString','Gamma parameter for community structure calculation')
        set(ui_edit_table_gamma,'Callback',{@cd_table_gamma})
        
        set(ui_popup_table_group,'Position',[.74 .15 .20 .04])
        set(ui_popup_table_group,'TooltipString','Select group');
        set(ui_popup_table_group,'Callback',{@cd_table_group});
        
        set(ui_text_table_parameter,'Position',[0.74 0.07 .07 .02])
        set(ui_edit_table_parameter,'Position',[0.84 0.07 .07 .02])
        if isa(ga,'PETGraphAnalysisWU')
            set(ui_text_table_parameter,'Visible','off')
            set(ui_edit_table_parameter,'Visible','off')
        elseif isa(ga,'PETGraphAnalysisBUD')
            set(ui_text_table_parameter,'String','density')
            set(ui_edit_table_parameter,'TooltipString','Density')
            set(ui_edit_table_parameter,'String','10')
            set(ui_edit_table_parameter,'Callback',{@cb_table_parameterBUD})
        elseif isa(ga,'PETGraphAnalysisBUT')
            set(ui_text_table_parameter,'String','threshold')
            set(ui_edit_table_parameter,'TooltipString','Threshold')
            set(ui_edit_table_parameter,'String','.5')
            set(ui_edit_table_parameter,'Callback',{@cb_table_parameterBUT})
        end
        
        set(ui_button_table_set,'Position',[.02 .02 .30 .04])
        set(ui_button_table_set,'String','Set')
        set(ui_button_table_set,'TooltipString','Apply the community structure parameteres to the graph analysis')
        set(ui_button_table_set,'Callback',{@cd_table_set})

        set(ui_button_table_reset,'Position',[.34 .02 .30 .04])
        set(ui_button_table_reset,'String','Reset')
        set(ui_button_table_reset,'TooltipString','Reset the community structure parameters to the last saved ones')
        set(ui_button_table_reset,'Callback',{@cd_table_reset})

        set(ui_button_table_calc,'Position',[.68 .02 .30 .04])
        set(ui_button_table_calc,'String','Calculate')
        set(ui_button_table_calc,'TooltipString','Calculate community structure for current parameters')
        set(ui_button_table_calc,'Callback',{@cd_table_calc})
    end
    function update_table()
        
        % get and format structure
        Ci = cs.getCi();
        if isempty(Ci)
            Ci = ones(atlas.length(),1);
        end
        N = max(Ci);
        
        % create table
        ColumnName = {'Brain region'};
        ColumnFormat = {'char'};
        for n = 1:1:N
            ColumnName{1+n} = ['Module' int2str(n)];
            ColumnFormat{1+n} = 'logical';
        end
        set(ui_table,'ColumnName',ColumnName)
        set(ui_table,'ColumnFormat',ColumnFormat)
        
        data = cell(atlas.length(),N+1);
        for i = 1:1:atlas.length()
            data{i,TAB_LABELS_COL} = atlas.get(i).getProp(BrainRegion.LABEL);
        end
        for i = 1:1:atlas.length()
            data{i,Ci(i)+1} = true;
        end
        set(ui_table,'Data',data)
        
        % update table console
        if cs.isFixed()
            set(ui_checkbox_table_fixed,'Value',true)
            set(ui_checkbox_table_fixed,'FontWeight','bold')
            
            set(ui_button_table_calc,'enable','off')

            set(ui_checkbox_table_dynamic,'Value',false)
            set(ui_checkbox_table_dynamic,'FontWeight','normal')
            
            set(ui_checkbox_table_louvain,'Value',false)
            set(ui_checkbox_table_louvain,'enable','off')
            set(ui_checkbox_table_louvain,'FontWeight','normal')

            set(ui_checkbox_table_newman,'Value',false)
            set(ui_checkbox_table_newman,'enable','off')
            set(ui_checkbox_table_newman,'FontWeight','normal')

            set(ui_text_table_gamma,'enable','off')

            set(ui_edit_table_gamma,'enable','off')

            set(ui_popup_table_group,'enable','off')

            set(ui_text_table_parameter,'enable','off')

            set(ui_edit_table_parameter,'enable','off')
        else
            set(ui_checkbox_table_fixed,'Value',false)
            set(ui_checkbox_table_fixed,'FontWeight','normal')
            
            set(ui_button_table_calc,'enable','on')

            set(ui_checkbox_table_dynamic,'Value',true)
            set(ui_checkbox_table_dynamic,'FontWeight','bold')
            
            set(ui_checkbox_table_louvain,'Value',false)
            set(ui_checkbox_table_louvain,'enable','on')
            if strcmp(cs.getAlgorithm(),Structure.ALGORITHM_LOUVAIN)
                set(ui_checkbox_table_louvain,'Value',true)
                set(ui_checkbox_table_louvain,'FontWeight','bold')
            else
                set(ui_checkbox_table_louvain,'Value',false)
                set(ui_checkbox_table_louvain,'FontWeight','normal')
            end

            set(ui_checkbox_table_newman,'Value',false)
            set(ui_checkbox_table_newman,'enable','on')
            if strcmp(cs.getAlgorithm(),Structure.ALGORITHM_NEWMAN)
                set(ui_checkbox_table_newman,'Value',true)
                set(ui_checkbox_table_newman,'FontWeight','bold')
            else
                set(ui_checkbox_table_newman,'Value',false)
                set(ui_checkbox_table_newman,'FontWeight','normal')
            end

            set(ui_text_table_gamma,'enable','on')

            set(ui_edit_table_gamma,'enable','on')
            set(ui_edit_table_gamma,'String',num2str(cs.getGamma()))

            set(ui_popup_table_group,'enable','on')

            set(ui_text_table_parameter,'enable','on')

            set(ui_edit_table_parameter,'enable','on')
        end
        
        % update Brainview
        update_brainview()
    end
    function Ci = table2Ci()
        data = get(ui_table,'Data');
        data = data(:,2:end);
        Ci = zeros(1,atlas.length());
        for i = 1:1:atlas.length()
            for n = 1:1:size(data,2)
                if data{i,n}
                    Ci(i) = n;
                end
            end
        end
    end
    function cb_table_edit(~,event)  % (src,event)
        
        i = event.Indices(1);
        col = event.Indices(2);
        newdata = event.NewData;
        
        switch col
            case TAB_LABELS_COL
                atlas.get(i).setProp(BrainRegion.LABEL,newdata)
            otherwise
                Ci = table2Ci();
                if newdata==true
                    Ci(i) = col-1;
                else
                    Ci(i) = max(Ci)+1;
                end

                cs.setAlgorithm(Structure.ALGORITHM_FIXED)
                cs.setNotes(TAB_NOTES_FIXED)
                cs.setCi(Ci)
        end
        update_table()
    end
    function cd_table_fixed(~,~)  % (src,event)
        
        cs.setAlgorithm(Structure.ALGORITHM_FIXED)
        cs.setNotes(TAB_NOTES_FIXED)
        cs.setCi(table2Ci())

        update_table()
    end
    function cd_table_dynamic(~,~)  % (src,event)

        cs.setAlgorithm(Structure.ALGORITHM_LOUVAIN);

        update_table()
    end
    function cd_table_louvain(~,~)  % (src,event)
        
        cs.setAlgorithm(Structure.ALGORITHM_LOUVAIN);
        
        update_table()
    end
    function cd_table_newman(~,~)  % (src,event)

        cs.setAlgorithm(Structure.ALGORITHM_NEWMAN);

        update_table()
    end
    function cd_table_gamma(~,~)  % (src,event)
        
        gamma = real(str2num(get(ui_edit_table_gamma,'String')));
        if isempty(gamma) || gamma<0
            gamma = 1;
        end        
        cs.setGamma(gamma)
        
        update_table()
    end
    function cd_table_group(~,~)  % (src,event)
        update_table()
    end
    function cb_table_parameterBUD(~,~)  % (src,event)
        
        density = real(str2num(get(ui_edit_table_parameter,'String')));
        if isempty(density) || density<0 || density>100
            density = 10;
        end        
        set(ui_edit_table_parameter,'String',num2str(density))
        
        update_table()
    end
    function cb_table_parameterBUT(~,~)  % (src,event)

        threshold = real(str2num(get(ui_edit_table_parameter,'String')));
        if isempty(threshold) || threshold<-1 || threshold>1
            threshold = .5;
        end        
        set(ui_edit_table_parameter,'String',num2str(threshold))

        update_table()
    end
    function cd_table_set(~,~)  % (src,event)

        ga.getStructure().setAlgorithm(cs.getAlgorithm());
        ga.getStructure().setNotes(cs.getNotes());
        if cs.isFixed()
            ga.getStructure().setCi(cs.getCi());
        else
            ga.getStructure().setGamma(cs.getGamma());
        end
        
        cs = copy(ga.getStructure());  % deep copy of structure
        
        update_table()
    end
    function cd_table_reset(~,~)  % (src,event)

        cs = copy(ga.getStructure());  % deep copy of structure
        
        update_table()
    end
    function cd_table_calc(~,~)  % (src,event)

        group = get(ui_popup_table_group,'value');

        if isa(ga,'PETGraphAnalysisWU')
            graph = GraphWU(ga.getA(group),'structure',cs);
        elseif isa(ga,'PETGraphAnalysisBUT')
            graph = GraphBU(ga.getA(group),'structure',cs,'threshold',str2num(get(ui_edit_table_parameter,'String')));
        elseif isa(ga,'PETGraphAnalysisBUD')
            graph = GraphBU(ga.getA(group),'structure',cs,'density',str2num(get(ui_edit_table_parameter,'String')));
        end
        
        [Ci,~] = graph.structure();
        cs.setCi(Ci)
        
        update_table()
    end

%% Panel Brainview
BRAIN_X0 = 3*MARGIN_X + TABLE_WIDTH;
BRAIN_Y0 = MARGIN_Y;
BRAIN_WIDTH = 1-TABLE_WIDTH-4*MARGIN_Y;
BRAIN_HEIGHT = HEIGHT;
BRAIN_POSITION = [BRAIN_X0 BRAIN_Y0 BRAIN_WIDTH BRAIN_HEIGHT];

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

BRAINVIEW_INSERTCOLORBAR_CMD = 'Colorbar';
BRAINVIEW_INSERTCOLORBAR_TP = 'Insert colorbar';

BRAINVIEW_BRAIN_CMD = 'Brain';
BRAINVIEW_BRAIN_TP = 'Brain surface on/off';

BRAINVIEW_BR_CMD = 'Regions';
BRAINVIEW_BR_TP = 'Brain regions on/off';

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

BRAINVIEW_XLABEL = 'x';
BRAINVIEW_YLABEL = 'y';
BRAINVIEW_ZLABEL = 'z';
BRAINVIEW_UNITS = 'mm';

ui_panel_brainview = uipanel('Parent',f);
ui_axes_brainview = axes();
init_brainview()
    function init_brainview()
        GUI.setUnits(ui_panel_brainview)
        GUI.setBackgroundColor(ui_panel_brainview)
        
        set(ui_panel_brainview,'Position',BRAIN_POSITION)
        set(ui_panel_brainview,'BorderType','none')
        
        set(ui_axes_brainview,'Parent',ui_panel_brainview)
        set(ui_axes_brainview,'Position',[.10 .10 .80 .80])
    end
    function update_brainview()
        
    	% update colors
        N = max(cs.getCi());
        if size(colors,1)<N
            colors = [ ...
                colors; ...
                rand(N-size(colors,1),3)];
        end
    
        % brain
        if strcmpi(get(ui_toolbar_brain,'State'),'on')
            ba.brain_on()
            
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
            ba.brain('UIContextMenu',ui_contextmenu_brain)
            
        else
            ba.brain_off()
        end
        
        % brain regions symbols
        if strcmpi(get(ui_toolbar_sym,'State'),'on')
            Ci = table2Ci();
            for i = 1:1:atlas.length()
                ba.br_sym(i,'Color',colors(Ci(i),:))
            end
            ba.br_syms_on()
            
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
            ba.br_syms([],'UIContextMenu',ui_contextmenu_sym)
            
        else
            ba.br_syms_off()
        end
        
        % brain regions
        if strcmpi(get(ui_toolbar_br,'State'),'on')
            Ci = table2Ci();
            for i = 1:1:atlas.length()
                ba.br_sph(i,'Color',colors(Ci(i),:))
            end
            ba.br_sphs_on()
            
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
            ba.br_sphs([],'UIContextMenu',ui_contextmenu_br)
            
        else
            ba.br_sphs_off()
        end
        
        % brain region labels
        if strcmpi(get(ui_toolbar_label,'State'),'on')
            Ci = table2Ci();
            for i = 1:1:atlas.length()
                ba.br_lab(i,'Color',colors(Ci(i),:))
            end
            ba.br_labs_on()
            
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
            ba.br_labs([],'UIContextMenu',ui_contextmenu_lab)
            
        else
            ba.br_labs_off()
        end
        
        % Update light
        ba.update_light()
        
        % axis
        if strcmpi(get(ui_toolbar_axis,'State'),'on')
            ba.axis_on()
        else
            ba.axis_off()
        end
        
        % grid
        if strcmpi(get(ui_toolbar_grid,'State'),'on')
            ba.grid_on()
        else
            ba.grid_off()
        end
        
    end
    function cb_brainview_brain_settings(~,~)  % (src,event)
        ba.brain_settings('FigName',[FigName ' - ' BRAINVIEW_BRAIN_SETTINGS])
    end
    function cb_brainview_sym_settings(~,~)  % (src,event)
        
        i = ba.get_sym_i(gco);
        
        if isfinite(i)
            ba.br_syms_settings(i,'FigName',[FigName ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        else
            ba.br_syms_settings([],'FigName',[FigName ' - ' BRAINVIEW_SYM_SETTINGS ' - '])
        end
    end
    function cb_brainview_br_settings(~,~)  % (src,event)
        
        i = ba.get_sph_i(gco);
        
        if isfinite(i)
            ba.br_sphs_settings(i,'FigName',[FigName ' - ' BRAINVIEW_BR_SETTINGS ' - '])
        else
            ba.br_sphs_settings([],'FigName',[FigName ' - ' BRAINVIEW_BR_SETTINGS ' - '])
        end
    end
    function cb_brainview_lab_settings(~,~)  % (src,event)
        
        i = ba.get_lab_i(gco);
        
        if isfinite(i)
            ba.br_labs_settings(i,'FigName',[FigName ' - ' BRAINVIEW_LAB_SETTINGS ' - '])
        else
            ba.br_labs_settings([],'FigName',[FigName ' - ' BRAINVIEW_LAB_SETTINGS ' - '])
        end
    end

%% Menus
FIGURE_CMD = GUI.FIGURE_CMD; 
FIGURE_SC = GUI.FIGURE_SC;
FIGURE_TP = ['Generate figure. Shortcut: ' GUI.ACCELERATOR '+' FIGURE_SC];
MENU_COMMUNITYVIEW = 'Figure';

ui_menu_brainview = uimenu(f,'Label',MENU_COMMUNITYVIEW);
ui_menu_brainview_figure = uimenu(ui_menu_brainview);
init_menu()
    function init_menu()
        set(ui_menu_brainview_figure,'Label',FIGURE_CMD)
        set(ui_menu_brainview_figure,'Accelerator',FIGURE_SC)
        set(ui_menu_brainview_figure,'Callback',{@cb_menu_figure})
    end
    function cb_menu_figure(~,~)  % (src,event)
        h = figure('Name',FigName);
        set(gcf,'color','w')
        copyobj(ba.get_axes(),h)
        set(gca,'Units','normalized')
        set(gca,'OuterPosition',[0 0 1 1])
    end
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,FigName);

%% Toolbar
set(f,'Toolbar','figure')
ui_toolbar = findall(f,'Tag','FigureToolBar');
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
        delete(findall(ui_toolbar,'Tag','Standard.FileOpen'))
        delete(findall(ui_toolbar,'Tag','Standard.SaveFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.PrintFigure'))
        delete(findall(ui_toolbar,'Tag','Standard.EditPlot'))
        % delete(findall(ui_toolbar,'Tag','Exploration.ZoomIn'))
        % delete(findall(ui_toolbar,'Tag','Exploration.ZoomOut'))
        delete(findall(ui_toolbar,'Tag','Exploration.Pan'))
        % delete(findall(ui_toolbar,'Tag','Exploration.Rotate'))
        delete(findall(ui_toolbar,'Tag','Exploration.DataCursor'))
        delete(findall(ui_toolbar,'Tag','Exploration.Brushing'))
        delete(findall(ui_toolbar,'Tag','DataManager.Linking'))
        delete(findall(ui_toolbar,'Tag','Annotation.InsertColorbar'))
        delete(findall(ui_toolbar,'Tag','Annotation.InsertLegend'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOff'))
        delete(findall(ui_toolbar,'Tag','Plottools.PlottoolsOn'))
        
        set(ui_toolbar_3D,'TooltipString',BRAINVIEW_3D_CMD);
        set(ui_toolbar_3D,'CData',imread('icon_view_3d.png'));
        set(ui_toolbar_3D,'Separator','off');
        set(ui_toolbar_3D,'ClickedCallback',{@cb_toolbar_3D})
        function  cb_toolbar_3D(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_3D)
            ba.update_light()
        end
        
        set(ui_toolbar_SL,'TooltipString',BRAINVIEW_SL_CMD);
        set(ui_toolbar_SL,'CData',imread('icon_view_sl.png'));
        set(ui_toolbar_SL,'ClickedCallback',{@cb_toolbar_SL})
        function  cb_toolbar_SL(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_SL)
            ba.update_light()
        end
        
        set(ui_toolbar_SR,'TooltipString',BRAINVIEW_SR_CMD);
        set(ui_toolbar_SR,'CData',imread('icon_view_sr.png'));
        set(ui_toolbar_SR,'ClickedCallback',{@cb_toolbar_SR})
        function  cb_toolbar_SR(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_SR)
            ba.update_light()
        end
        
        set(ui_toolbar_AD,'TooltipString',BRAINVIEW_AD_CMD);
        set(ui_toolbar_AD,'CData',imread('icon_view_ad.png'));
        set(ui_toolbar_AD,'ClickedCallback',{@cb_toolbar_AD})
        function  cb_toolbar_AD(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_AD)
            ba.update_light()
        end
        
        set(ui_toolbar_AV,'TooltipString',BRAINVIEW_AV_CMD);
        set(ui_toolbar_AV,'CData',imread('icon_view_av.png'));
        set(ui_toolbar_AV,'ClickedCallback',{@cb_toolbar_AV})
        function  cb_toolbar_AV(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_AV)
            ba.update_light()
        end
        
        set(ui_toolbar_CA,'TooltipString',BRAINVIEW_CA_CMD);
        set(ui_toolbar_CA,'CData',imread('icon_view_ca.png'));
        set(ui_toolbar_CA,'ClickedCallback',{@cb_toolbar_CA})
        function  cb_toolbar_CA(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_CA)
            ba.update_light()
        end
        
        set(ui_toolbar_CP,'TooltipString',BRAINVIEW_CP_CMD);
        set(ui_toolbar_CP,'CData',imread('icon_view_cp.png'));
        set(ui_toolbar_CP,'ClickedCallback',{@cb_toolbar_CP})
        function  cb_toolbar_CP(~,~)  % (src,event)
            ba.view(PlotBrainSurf.VIEW_CP)
            ba.update_light()
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
        set(ui_toolbar_br,'CData',imread('icon_sphere.png'));
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

setup_restrictions()
    function setup_restrictions()
        if exist('restricted','var') && restricted 
            set(ui_button_table_set,'Enable','off')
        end
    end

%% Auxilary functions
    function setup()
        
        % update group popups
        update_popup()

        % update table
        update_table()
        
        % setup brain view
        cla(ui_axes_brainview)
        ba.set_axes(ui_axes_brainview);
        ba.hold_on()
        ba.view(PlotBrainSurf.VIEW_3D)
        
        ba.brain()
        ba.axis_equal()
        
        ba.update_light()
        
        xlabel([BRAINVIEW_XLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
        ylabel([BRAINVIEW_YLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
        zlabel([BRAINVIEW_ZLABEL ' ' GUI.BRA_UNITS BRAINVIEW_UNITS GUI.KET_UNITS])
        
        % update brain view
        update_brainview()
    end
    function update_popup()
        if ga.getCohort().groupnumber()>0
            % updates group lists of popups
            GroupList = {};
            for g = 1:1:ga.getCohort().groupnumber()
                GroupList{g} = ga.getCohort().getGroup(g).getProp(Group.NAME);
            end
        else
            GroupList = {''};
        end
        set(ui_popup_table_group,'String',GroupList)
    end

end