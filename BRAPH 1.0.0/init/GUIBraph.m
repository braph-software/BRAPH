function GUIBraph()
%% General Constants
APPNAME = GUI.BN_NAME;  % application name

% Dimensions
MARGIN_X = .02;
MARGIN_Y = .02;

BOTTOM_X0 = MARGIN_X;
BOTTOM_Y0 = MARGIN_Y;
BOTTOM_WIDTH = 1-2*MARGIN_X;
BOTTOM_HEIGHT = .06;
BOTTOM_POSITION = [BOTTOM_X0 BOTTOM_Y0 BOTTOM_WIDTH BOTTOM_HEIGHT];

MAIN_X0 = MARGIN_X;
MAIN_Y0 = BOTTOM_HEIGHT+2*MARGIN_Y;
MAIN_WIDTH = .70;
MAIN_HEIGHT = 1-BOTTOM_HEIGHT-3*MARGIN_Y;
MAIN_POSITION = [MAIN_X0 MAIN_Y0 MAIN_WIDTH MAIN_HEIGHT];

RIGHT_X0 = MAIN_WIDTH+2*MARGIN_X;
RIGHT_Y0 = BOTTOM_HEIGHT+2*MARGIN_Y;
RIGHT_WIDTH = 1-MAIN_WIDTH-3*MARGIN_Y;
RIGHT_HEIGHT = MAIN_HEIGHT;
RIGHT_POSITION = [RIGHT_X0 RIGHT_Y0 RIGHT_WIDTH RIGHT_HEIGHT];

%% GUI inizialization
f = GUI.init_figure(APPNAME,.6,.6,'center');
set(f,'Color','w')
    
%% Main
tmp = load('sample_atlas.atlas','-mat','atlas');
atlas = tmp.atlas;
clear tmp
bg = PlotBrainGraph(atlas);

ui_panel_main = uipanel();
ui_axes_main = axes();
ui_text_main = uicontrol(ui_panel_main,'Style','text');
init_main()
    function init_main()
        GUI.setUnits(ui_panel_main)

        set(ui_panel_main,'Position',MAIN_POSITION)
        set(ui_panel_main,'BackgroundColor','w')        
        set(ui_panel_main,'BorderType','none')

        set(ui_axes_main,'Parent',ui_panel_main)
        set(ui_axes_main,'Position',[0 0 1 1])
        
        set(ui_text_main,'Position',[0 0 1 0.15])
        set(ui_text_main,'String','')
        set(ui_text_main,'BackgroundColor','w')
        set(ui_text_main,'Visible','off')
        
    end
    function update_main()
        if get(ui_checkbox_bottom_animation,'Value')
            set(ui_axes_main,'Position',[0 0 1 1])
            set(ui_text_main,'Visible','off')
            
            bg.hold_on()
            
            bg.brain()
            bg.brain('FaceAlpha',.1)
            bg.br_sphs([],'R',5,'FaceColor',GUI.COLOR,'FaceAlpha',.2,'EdgeAlpha',0)
            
            n1 = 1;
            n2 = 2;
            n3 = [3 5 7 9];
            n4 = [4 6 8 10 12 14];
            bg.br_sph(n1,'R',9,'FaceColor',GUI.COLOR.^3,'FaceAlpha',1,'EdgeAlpha',0)
            bg.br_sph(n2,'R',8,'FaceColor',GUI.COLOR.^2.5,'FaceAlpha',.8,'EdgeAlpha',0)
            bg.br_sphs(n3,'R',7,'FaceColor',GUI.COLOR.^2,'FaceAlpha',.4,'EdgeAlpha',0)
            bg.br_sphs(n4,'R',6,'FaceColor',GUI.COLOR.^1.5,'FaceAlpha',.2,'EdgeAlpha',0)
            bg.link_lin(n1,n2,'LineWidth',2)
            bg.link_lins(n2,n3,'LineWidth',1)
            bg.link_lins(n3(end),n4,'LineWidth',.5)
            
            n5 = 11;
            n6 = 13;
            n7 = 15;
            n8 = 16;
            bg.br_sph(n5,'R',9,'FaceColor',GUI.COLOR*1/5,'FaceAlpha',1,'EdgeAlpha',0)
            bg.br_sph(n6,'R',8,'FaceColor',GUI.COLOR*2/5,'FaceAlpha',.8,'EdgeAlpha',0)
            bg.br_sphs(n7,'R',7,'FaceColor',GUI.COLOR*3/5,'FaceAlpha',.4,'EdgeAlpha',0)
            bg.br_sphs(n8,'R',6,'FaceColor',GUI.COLOR*4/5,'FaceAlpha',.2,'EdgeAlpha',0)
            bg.link_lin(n5,n6,'LineWidth',2)
            bg.link_lins(n6,n7,'LineWidth',1)
            bg.link_lins(n7(end),n8,'LineWidth',.5)
            
            bg.axis_off()
            bg.view(bg.VIEW_SL)
            bg.axis_equal()
            bg.axis_tight()
            bg.rotate(-25,0)
            bg.update_light()
            
        elseif get(ui_checkbox_bottom_slideshow,'Value')
            slide_show()
        end
    end
    function rotate()
        try 
            while get(ui_checkbox_bottom_animation,'Value')
                bg.rotate(2,0)
                pause(.01)
            end
        end
    end
    function slide_show()
        try
            image1 = 'degree.tif';
            image2 = 'strength.tif';
            image3 = 'eccentricity.tif';
            image4 = 'eccentricity.tif';
            image5 = 'triangles.tif';
            image6 = 'clustering.tif';
            image7 = 'eccentricity.tif';
            image8 = 'betweeness.tif';
            image9 = 'modularity.tif';
            image10 = 'zscore.tif';
            image11 = 'participation.tif';
            images = {image1, image2, image3, image4, image5, image6, ...
                image7, image8, image9, image10, image11};
            
            string1 = ['DEGREE of a node is the number of edges connected to the node. Connection weights are ignored in calculations.'];
            string2 = ['STRENGTH of a node is the sum of the weights of the edges connected to the node. Number of connections are ignored in calculations.'];
            string3 = ['ECCENTRICITY of a node is the maximal shortest path length between that node and any other node. If more than one path exist between' ...
                'a node and other node, the shortest path is chosen (red path in the figure).'];
            string4 = ['PATH LENGTH of a node is the average path length from that note to all other nodes. If more than one path exist between' ...
                'a node and other node, the shortest path is chosen (red path in the figure).'];
            string5 = ['Number of TRIANGLES around a node is the number of neighbors of that node that are neightbors to each other.'];
            string6 = ['CLUSTERING coefficient is the fraction of triangles around a node. It is equivalent to the fraction of the neighbors of the node that are neighbors of each other.'];
            string7 = ['GLOBAL EFFICIENCY is the average inverse shortest path length in the graph. It is inversely related to the characteristic path length.' ...
                'If more than one path exist between a node and other node, the shortest path is chosen (red path in the figure).'];
            string8 = ['BETWEENNESS CENTRALITY of a node is the fraction of all shortest paths in the graph that contain a given node. Nodes with high values of betweenness centrality' ...
                'participate in a large number of shortest paths.'];
            string9 = ['MODULARITY is a statistic that quantifies the degree to which the graph may be subdivided into clearly delineated groups.'];
            string10 = ['Within-module degree Z-SCORE of a node shows how well connected a node is in a given cluster by comparing the degree of the node' ...
                'in that cluster to the average degree of all nodes in the same cluster. This measure requires a previously determined community structure.'];
            string11 = ['PARTICIPATION coefficient compares the number of links of a node has with nodes of other cluster to the number of links within its'...
                'cluster. Nodes with a high participation coefficient (known as connector hubs) are connected to many clusters and are likely to facilitate global intermodular integration.'];
            
            strings = {string1 string2 string3 string4 string5 string6 string7 string8 string9 string10 string11};
            set(ui_axes_main,'Position',[0 .1 1 .9])
            set(ui_text_main,'Visible','on')
            pause on;
            for i= 1:1:length(images)
                pause(0.1);
                if get(ui_checkbox_bottom_slideshow,'Value')
                    set(ui_text_main,'String',strings{i},'FontWeight','bold',...
                        'FontSize',12);
                    a=imread(images{i});
                    imshow(a);
                    drawnow;
                    if i == length(images)
                        i = 1;
                    end
                    pause(5)
                else
                    
                end
            end
        end
    end

%% Bottom
ui_panel_bottom = uipanel();
ui_checkbox_bottom_animation = uicontrol(ui_panel_bottom,'Style', 'checkbox');
ui_checkbox_bottom_slideshow = uicontrol(ui_panel_bottom,'Style', 'checkbox');
ui_checkbox_bottom_mri = uicontrol(ui_panel_bottom,'Style', 'checkbox');
ui_checkbox_bottom_fmri = uicontrol(ui_panel_bottom,'Style', 'checkbox');
ui_checkbox_bottom_pet = uicontrol(ui_panel_bottom,'Style', 'checkbox');
ui_checkbox_bottom_eeg = uicontrol(ui_panel_bottom,'Style', 'checkbox');
init_bottom()
    function init_bottom()
        GUI.setUnits(ui_panel_bottom)
        GUI.setBackgroundColor(ui_panel_bottom)

        set(ui_panel_bottom,'Position',BOTTOM_POSITION)
        set(ui_panel_bottom,'BorderType','none')

        set(ui_checkbox_bottom_animation,'Position',[.05 .1 .10 .8])
        set(ui_checkbox_bottom_animation,'String','animation')
        set(ui_checkbox_bottom_animation,'Value',true)
        set(ui_checkbox_bottom_animation,'TooltipString','Toggles on/off brain animation')
        set(ui_checkbox_bottom_animation,'Callback',{@cb_bottom_animation})
        
        set(ui_checkbox_bottom_slideshow,'Position',[.20 .1 .10 .8])
        set(ui_checkbox_bottom_slideshow,'String','slide show')
        set(ui_checkbox_bottom_slideshow,'Value',false)
        set(ui_checkbox_bottom_slideshow,'TooltipString','Toggles on/off slide show')
        set(ui_checkbox_bottom_slideshow,'Callback',{@cb_bottom_slideshow})

        set(ui_checkbox_bottom_mri,'Position',[.60 .1 .10 .8])
        set(ui_checkbox_bottom_mri,'String','MRI')
        set(ui_checkbox_bottom_mri,'Value',true)
        set(ui_checkbox_bottom_mri,'TooltipString','Visualize structural MRI analysis workflow')
        set(ui_checkbox_bottom_mri,'Callback',{@cb_bottom_mri})

        set(ui_checkbox_bottom_fmri,'Position',[.70 .1 .10 .8])
        set(ui_checkbox_bottom_fmri,'String','fMRI')
        set(ui_checkbox_bottom_fmri,'Value',false)
        set(ui_checkbox_bottom_fmri,'TooltipString','Visualize functional fMRI analysis workflow')
        set(ui_checkbox_bottom_fmri,'Callback',{@cb_bottom_fmri})

        set(ui_checkbox_bottom_pet,'Position',[.80 .1 .10 .8])
        set(ui_checkbox_bottom_pet,'String','PET')
        set(ui_checkbox_bottom_pet,'Value',false)
        set(ui_checkbox_bottom_pet,'TooltipString','Visualize functional PET analysis workflow')
        set(ui_checkbox_bottom_pet,'Callback',{@cb_bottom_pet})

        set(ui_checkbox_bottom_eeg,'Position',[.90 .1 .10 .8])
        set(ui_checkbox_bottom_eeg,'String','EEG')
        set(ui_checkbox_bottom_eeg,'Value',false)
        set(ui_checkbox_bottom_eeg,'TooltipString','Visualize functional EEG analysis workflow')
        set(ui_checkbox_bottom_eeg,'Callback',{@cb_bottom_eeg})
    end
    function update_bottom_panel_visibility(bottom_panel_cmd)
        switch bottom_panel_cmd
            case 'mri'
                set(ui_checkbox_bottom_mri,'Value',true)
                set(ui_checkbox_bottom_fmri,'Value',false)
                set(ui_checkbox_bottom_pet,'Value',false)
                set(ui_checkbox_bottom_eeg,'Value',false)

                set(ui_panel_mri,'Visible','on')
                set(ui_panel_fmri,'Visible','off')
                set(ui_panel_pet,'Visible','off')
                set(ui_panel_eeg,'Visible','off')
                
            case 'fmri'
                set(ui_checkbox_bottom_mri,'Value',false)
                set(ui_checkbox_bottom_fmri,'Value',true)
                set(ui_checkbox_bottom_pet,'Value',false)
                set(ui_checkbox_bottom_eeg,'Value',false)

                set(ui_panel_mri,'Visible','off')
                set(ui_panel_fmri,'Visible','on')
                set(ui_panel_pet,'Visible','off')
                set(ui_panel_eeg,'Visible','off')

            case 'pet'
                set(ui_checkbox_bottom_mri,'Value',false)
                set(ui_checkbox_bottom_fmri,'Value',false)
                set(ui_checkbox_bottom_pet,'Value',true)
                set(ui_checkbox_bottom_eeg,'Value',false)

                set(ui_panel_mri,'Visible','off')
                set(ui_panel_fmri,'Visible','off')
                set(ui_panel_pet,'Visible','on')
                set(ui_panel_eeg,'Visible','off')

            case 'eeg'
                set(ui_checkbox_bottom_mri,'Value',false)
                set(ui_checkbox_bottom_fmri,'Value',false)
                set(ui_checkbox_bottom_pet,'Value',false)
                set(ui_checkbox_bottom_eeg,'Value',true)

                set(ui_panel_mri,'Visible','off')
                set(ui_panel_fmri,'Visible','off')
                set(ui_panel_pet,'Visible','off')
                set(ui_panel_eeg,'Visible','on')
        end
    end
    function cb_bottom_animation(~,~)  % (src,event)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        set(ui_checkbox_bottom_animation,'Value',true)
        cla;
        update_main()
        rotate()
    end
    function cb_bottom_slideshow(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',true)
        cla;
        view(2) 
        update_main()
    end
    function cb_bottom_mri(~,~)  % (src,event)
        update_bottom_panel_visibility('mri')
    end
    function cb_bottom_fmri(~,~)  % (src,event)
        update_bottom_panel_visibility('fmri')
    end
    function cb_bottom_pet(~,~)  % (src,event)
        update_bottom_panel_visibility('pet')
    end
    function cb_bottom_eeg(~,~)  % (src,event)
        update_bottom_panel_visibility('eeg')
    end

%% Panel 1 - MRI
ui_panel_mri = uipanel();
ui_text_mri_braph = uicontrol(ui_panel_mri,'Style','text');
ui_text_mri = uicontrol(ui_panel_mri,'Style','text');
ui_text_mri_atlas = uicontrol(ui_panel_mri,'Style','text');
ui_button_mri_atlas = uicontrol(ui_panel_mri,'Style','pushbutton');
ui_text_mri_mc = uicontrol(ui_panel_mri,'Style','text');
ui_button_mri_mc = uicontrol(ui_panel_mri,'Style','pushbutton');
ui_text_mri_ga = uicontrol(ui_panel_mri,'Style','text');
ui_button_mri_ga = uicontrol(ui_panel_mri,'Style','pushbutton');
init_mri()
    function init_mri()
        GUI.setUnits(ui_panel_mri)
        GUI.setBackgroundColor(ui_panel_mri)

        set(ui_panel_mri,'Position',RIGHT_POSITION)
        set(ui_panel_mri,'BorderType','none')

        set(ui_text_mri_braph,'Position',[.1 .87 .8 .1])
        set(ui_text_mri_braph,'String','Braph')
        set(ui_text_mri_braph,'FontName',GUI.FONT)
        set(ui_text_mri_braph,'FontSize',50)
        set(ui_text_mri_braph,'FontWeight','bold')
        set(ui_text_mri_braph,'ForegroundColor',GUI.COLOR)        
        set(ui_text_mri_braph,'HorizontalAlignment','center')

        set(ui_text_mri,'Position',[.1 .75 .8 .1])
        set(ui_text_mri,'String',{'Structural MRI' 'Analysis Workflow'})
        set(ui_text_mri,'FontSize',15)
        set(ui_text_mri,'FontWeight','bold')
        set(ui_text_mri,'HorizontalAlignment','center')
        
        set(ui_text_mri_atlas,'Position',[.1 .65 .8 .1])
        set(ui_text_mri_atlas,'String','1. Define the brain atlas to be used')
        set(ui_text_mri_atlas,'HorizontalAlignment','center')

        set(ui_button_mri_atlas,'Position',[.1 .6 .8 .1])
        set(ui_button_mri_atlas,'String','Brain Atlas')
        set(ui_button_mri_atlas,'FontName',GUI.FONT)
        set(ui_button_mri_atlas,'FontSize',15)
        set(ui_button_mri_atlas,'FontWeight','bold')
        set(ui_button_mri_atlas,'ForegroundColor',GUI.COLOR)        
        set(ui_button_mri_atlas,'TooltipString',['Open ' GUI.BAE_NAME])
        set(ui_button_mri_atlas,'Callback',{@cb_mri_atlas})

        set(ui_text_mri_mc,'Position',[.1 .4 .8 .1])
        set(ui_text_mri_mc,'String','2. Import subject MRI data')
        set(ui_text_mri_mc,'HorizontalAlignment','center')

        set(ui_button_mri_mc,'Position',[.1 .35 .8 .1])
        set(ui_button_mri_mc,'String','MRI Cohort')
        set(ui_button_mri_mc,'FontName',GUI.FONT)
        set(ui_button_mri_mc,'FontSize',15)
        set(ui_button_mri_mc,'FontWeight','bold')
        set(ui_button_mri_mc,'ForegroundColor',GUI.COLOR)        
        set(ui_button_mri_mc,'TooltipString',['Open ' GUI.MCE_NAME])
        set(ui_button_mri_mc,'Callback',{@cb_mri_mc})

        set(ui_text_mri_ga,'Position',[.1 .15 .8 .1])
        set(ui_text_mri_ga,'String','3. Perform brain connectivity analysis')
        set(ui_text_mri_ga,'HorizontalAlignment','center')

        set(ui_button_mri_ga,'Position',[.1 .1 .8 .1])
        set(ui_button_mri_ga,'String','MRI Graph Analysis')
        set(ui_button_mri_ga,'FontName',GUI.FONT)
        set(ui_button_mri_ga,'FontSize',15)
        set(ui_button_mri_ga,'FontWeight','bold')
        set(ui_button_mri_ga,'ForegroundColor',GUI.COLOR)        
        set(ui_button_mri_ga,'TooltipString',['Open ' GUI.MGA_NAME])
        set(ui_button_mri_ga,'Callback',{@cb_mri_ga})
    end
    function cb_mri_atlas(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIBrainAtlas()
    end
    function cb_mri_mc(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIMRICohort()
    end
    function cb_mri_ga(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIMRIGraphAnalysis()
    end

%% Panel 2 - fMRI
ui_panel_fmri = uipanel();
ui_text_fmri_braph = uicontrol(ui_panel_fmri,'Style','text');
ui_text_fmri = uicontrol(ui_panel_fmri,'Style','text');
ui_text_fmri_atlas = uicontrol(ui_panel_fmri,'Style','text');
ui_button_fmri_atlas = uicontrol(ui_panel_fmri,'Style','pushbutton');
ui_text_fmri_mc = uicontrol(ui_panel_fmri,'Style','text');
ui_button_fmri_mc = uicontrol(ui_panel_fmri,'Style','pushbutton');
ui_text_fmri_ga = uicontrol(ui_panel_fmri,'Style','text');
ui_button_fmri_ga = uicontrol(ui_panel_fmri,'Style','pushbutton');
init_fmri()
    function init_fmri()
        GUI.setUnits(ui_panel_fmri)
        GUI.setBackgroundColor(ui_panel_fmri)

        set(ui_panel_fmri,'Position',RIGHT_POSITION)
        set(ui_panel_fmri,'BorderType','none')

        set(ui_text_fmri_braph,'Position',[.1 .87 .8 .1])
        set(ui_text_fmri_braph,'String','Braph')
        set(ui_text_fmri_braph,'FontName',GUI.FONT)
        set(ui_text_fmri_braph,'FontSize',50)
        set(ui_text_fmri_braph,'FontWeight','bold')
        set(ui_text_fmri_braph,'ForegroundColor',GUI.COLOR)        
        set(ui_text_fmri_braph,'HorizontalAlignment','center')

        set(ui_text_fmri,'Position',[.1 .75 .8 .1])
        set(ui_text_fmri,'String',{'Functional MRI' 'Analysis Workflow'})
        set(ui_text_fmri,'FontSize',15)
        set(ui_text_fmri,'FontWeight','bold')
        set(ui_text_fmri,'HorizontalAlignment','center')

        set(ui_text_fmri_atlas,'Position',[.1 .65 .8 .1])
        set(ui_text_fmri_atlas,'String','1. Define the brain atlas to be used')
        set(ui_text_fmri_atlas,'HorizontalAlignment','center')

        set(ui_button_fmri_atlas,'Position',[.1 .6 .8 .1])
        set(ui_button_fmri_atlas,'String','Brain Atlas')
        set(ui_button_fmri_atlas,'FontName',GUI.FONT)
        set(ui_button_fmri_atlas,'FontSize',15)
        set(ui_button_fmri_atlas,'FontWeight','bold')
        set(ui_button_fmri_atlas,'ForegroundColor',GUI.COLOR)        
        set(ui_button_fmri_atlas,'TooltipString',['Open ' GUI.BAE_NAME])
        set(ui_button_fmri_atlas,'Callback',{@cb_fmri_atlas})

        set(ui_text_fmri_mc,'Position',[.1 .4 .8 .1])
        set(ui_text_fmri_mc,'String','2. Import subject fMRI data')
        set(ui_text_fmri_mc,'HorizontalAlignment','center')

        set(ui_button_fmri_mc,'Position',[.1 .35 .8 .1])
        set(ui_button_fmri_mc,'String','fMRI Cohort')
        set(ui_button_fmri_mc,'FontName',GUI.FONT)
        set(ui_button_fmri_mc,'FontSize',15)
        set(ui_button_fmri_mc,'FontWeight','bold')
        set(ui_button_fmri_mc,'ForegroundColor',GUI.COLOR)        
        set(ui_button_fmri_mc,'TooltipString',['Open ' GUI.fMCE_NAME])
        set(ui_button_fmri_mc,'Callback',{@cb_fmri_mc})

        set(ui_text_fmri_ga,'Position',[.1 .15 .8 .1])
        set(ui_text_fmri_ga,'String','3. Perform brain connectivity analysis')
        set(ui_text_fmri_ga,'HorizontalAlignment','center')

        set(ui_button_fmri_ga,'Position',[.1 .1 .8 .1])
        set(ui_button_fmri_ga,'String','fMRI Graph Analysis')
        set(ui_button_fmri_ga,'FontName',GUI.FONT)
        set(ui_button_fmri_ga,'FontSize',15)
        set(ui_button_fmri_ga,'FontWeight','bold')
        set(ui_button_fmri_ga,'ForegroundColor',GUI.COLOR)        
        set(ui_button_fmri_ga,'TooltipString',['Open ' GUI.fMGA_NAME])
        set(ui_button_fmri_ga,'Callback',{@cb_fmri_ga})
    end
    function cb_fmri_atlas(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIBrainAtlas()
    end
    function cb_fmri_mc(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIfMRICohort()
    end
    function cb_fmri_ga(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        set(ui_checkbox_bottom_slideshow,'Value',false)
        pause(1)
        GUIfMRIGraphAnalysis()
    end

%% Panel 3 - PET
ui_panel_pet = uipanel();
ui_text_pet_braph = uicontrol(ui_panel_pet,'Style','text');
ui_text_pet = uicontrol(ui_panel_pet,'Style','text');
ui_text_pet_atlas = uicontrol(ui_panel_pet,'Style','text');
ui_button_pet_atlas = uicontrol(ui_panel_pet,'Style','pushbutton');
ui_text_pet_mc = uicontrol(ui_panel_pet,'Style','text');
ui_button_pet_mc = uicontrol(ui_panel_pet,'Style','pushbutton');
ui_text_pet_ga = uicontrol(ui_panel_pet,'Style','text');
ui_button_pet_ga = uicontrol(ui_panel_pet,'Style','pushbutton');
init_pet()
    function init_pet()
        GUI.setUnits(ui_panel_pet)
        GUI.setBackgroundColor(ui_panel_pet)

        set(ui_panel_pet,'Position',RIGHT_POSITION)
        set(ui_panel_pet,'BorderType','none')

        set(ui_text_pet_braph,'Position',[.1 .87 .8 .1])
        set(ui_text_pet_braph,'String','Braph')
        set(ui_text_pet_braph,'FontName',GUI.FONT)
        set(ui_text_pet_braph,'FontSize',50)
        set(ui_text_pet_braph,'FontWeight','bold')
        set(ui_text_pet_braph,'ForegroundColor',GUI.COLOR)        
        set(ui_text_pet_braph,'HorizontalAlignment','center')

        set(ui_text_pet,'Position',[.1 .75 .8 .1])
        set(ui_text_pet,'String',{'PET' 'Analysis Workflow'})
        set(ui_text_pet,'FontSize',15)
        set(ui_text_pet,'FontWeight','bold')
        set(ui_text_pet,'HorizontalAlignment','center')
        
        set(ui_text_pet_atlas,'Position',[.1 .65 .8 .1])
        set(ui_text_pet_atlas,'String','1. Define the brain atlas to be used')
        set(ui_text_pet_atlas,'HorizontalAlignment','center')

        set(ui_button_pet_atlas,'Position',[.1 .6 .8 .1])
        set(ui_button_pet_atlas,'String','Brain Atlas')
        set(ui_button_pet_atlas,'FontName',GUI.FONT)
        set(ui_button_pet_atlas,'FontSize',15)
        set(ui_button_pet_atlas,'FontWeight','bold')
        set(ui_button_pet_atlas,'ForegroundColor',GUI.COLOR)        
        set(ui_button_pet_atlas,'TooltipString',['Open ' GUI.BAE_NAME])
        set(ui_button_pet_atlas,'Callback',{@cb_pet_atlas})

        set(ui_text_pet_mc,'Position',[.1 .4 .8 .1])
        set(ui_text_pet_mc,'String','2. Import subject PET data')
        set(ui_text_pet_mc,'HorizontalAlignment','center')

        set(ui_button_pet_mc,'Position',[.1 .35 .8 .1])
        set(ui_button_pet_mc,'String','PET Cohort')
        set(ui_button_pet_mc,'FontName',GUI.FONT)
        set(ui_button_pet_mc,'FontSize',15)
        set(ui_button_pet_mc,'FontWeight','bold')
        set(ui_button_pet_mc,'ForegroundColor',GUI.COLOR)        
        set(ui_button_pet_mc,'TooltipString',['Open ' GUI.MCE_NAME])
        set(ui_button_pet_mc,'Callback',{@cb_pet_mc})

        set(ui_text_pet_ga,'Position',[.1 .15 .8 .1])
        set(ui_text_pet_ga,'String','3. Perform brain connectivity analysis')
        set(ui_text_pet_ga,'HorizontalAlignment','center')

        set(ui_button_pet_ga,'Position',[.1 .1 .8 .1])
        set(ui_button_pet_ga,'String','PET Graph Analysis')
        set(ui_button_pet_ga,'FontName',GUI.FONT)
        set(ui_button_pet_ga,'FontSize',15)
        set(ui_button_pet_ga,'FontWeight','bold')
        set(ui_button_pet_ga,'ForegroundColor',GUI.COLOR)        
        set(ui_button_pet_ga,'TooltipString',['Open ' GUI.MGA_NAME])
        set(ui_button_pet_ga,'Callback',{@cb_pet_ga})
    end
    function cb_pet_atlas(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIBrainAtlas()
    end
    function cb_pet_mc(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIPETCohort()
    end
    function cb_pet_ga(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIPETGraphAnalysis()
    end

%% Panel 4 - EEG
ui_panel_eeg = uipanel();
ui_text_eeg_braph = uicontrol(ui_panel_eeg,'Style','text');
ui_text_eeg = uicontrol(ui_panel_eeg,'Style','text');
ui_text_eeg_atlas = uicontrol(ui_panel_eeg,'Style','text');
ui_button_eeg_atlas = uicontrol(ui_panel_eeg,'Style','pushbutton');
ui_text_eeg_mc = uicontrol(ui_panel_eeg,'Style','text');
ui_button_eeg_mc = uicontrol(ui_panel_eeg,'Style','pushbutton');
ui_text_eeg_ga = uicontrol(ui_panel_eeg,'Style','text');
ui_button_eeg_ga = uicontrol(ui_panel_eeg,'Style','pushbutton');
init_eeg()
    function init_eeg()
        GUI.setUnits(ui_panel_eeg)
        GUI.setBackgroundColor(ui_panel_eeg)

        set(ui_panel_eeg,'Position',RIGHT_POSITION)
        set(ui_panel_eeg,'BorderType','none')

        set(ui_text_eeg_braph,'Position',[.1 .87 .8 .1])
        set(ui_text_eeg_braph,'String','Braph')
        set(ui_text_eeg_braph,'FontName',GUI.FONT)
        set(ui_text_eeg_braph,'FontSize',50)
        set(ui_text_eeg_braph,'FontWeight','bold')
        set(ui_text_eeg_braph,'ForegroundColor',GUI.COLOR)        
        set(ui_text_eeg_braph,'HorizontalAlignment','center')

        set(ui_text_eeg,'Position',[.1 .75 .8 .1])
        set(ui_text_eeg,'String',{'EEG' 'Analysis Workflow'})
        set(ui_text_eeg,'FontSize',15)
        set(ui_text_eeg,'FontWeight','bold')
        set(ui_text_eeg,'HorizontalAlignment','center')
        
        set(ui_text_eeg_atlas,'Position',[.1 .65 .8 .1])
        set(ui_text_eeg_atlas,'String','1. Define the brain atlas to be used')
        set(ui_text_eeg_atlas,'HorizontalAlignment','center')

        set(ui_button_eeg_atlas,'Position',[.1 .6 .8 .1])
        set(ui_button_eeg_atlas,'String','Brain Atlas')
        set(ui_button_eeg_atlas,'FontName',GUI.FONT)
        set(ui_button_eeg_atlas,'FontSize',15)
        set(ui_button_eeg_atlas,'FontWeight','bold')
        set(ui_button_eeg_atlas,'ForegroundColor',GUI.COLOR)        
        set(ui_button_eeg_atlas,'TooltipString',['Open ' GUI.BAE_NAME])
        set(ui_button_eeg_atlas,'Callback',{@cb_eeg_atlas})

        set(ui_text_eeg_mc,'Position',[.1 .4 .8 .1])
        set(ui_text_eeg_mc,'String','2. Import subject EEG data')
        set(ui_text_eeg_mc,'HorizontalAlignment','center')

        set(ui_button_eeg_mc,'Position',[.1 .35 .8 .1])
        set(ui_button_eeg_mc,'String','EEG Cohort')
        set(ui_button_eeg_mc,'FontName',GUI.FONT)
        set(ui_button_eeg_mc,'FontSize',15)
        set(ui_button_eeg_mc,'FontWeight','bold')
        set(ui_button_eeg_mc,'ForegroundColor',GUI.COLOR)        
        set(ui_button_eeg_mc,'TooltipString',['Open ' GUI.MCE_NAME])
        set(ui_button_eeg_mc,'Callback',{@cb_eeg_mc})

        set(ui_text_eeg_ga,'Position',[.1 .15 .8 .1])
        set(ui_text_eeg_ga,'String','3. Perform brain connectivity analysis')
        set(ui_text_eeg_ga,'HorizontalAlignment','center')

        set(ui_button_eeg_ga,'Position',[.1 .1 .8 .1])
        set(ui_button_eeg_ga,'String','EEG Graph Analysis')
        set(ui_button_eeg_ga,'FontName',GUI.FONT)
        set(ui_button_eeg_ga,'FontSize',15)
        set(ui_button_eeg_ga,'FontWeight','bold')
        set(ui_button_eeg_ga,'ForegroundColor',GUI.COLOR)        
        set(ui_button_eeg_ga,'TooltipString',['Open ' GUI.MGA_NAME])
        set(ui_button_eeg_ga,'Callback',{@cb_eeg_ga})
    end
    function cb_eeg_atlas(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIBrainAtlas()
    end
    function cb_eeg_mc(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIEEGCohort()
    end
    function cb_eeg_ga(~,~)  % (src,event)
        set(ui_checkbox_bottom_animation,'Value',false)
        GUIEEGGraphAnalysis()
    end

%% Menu
[ui_menu_about,ui_menu_about_about] = GUI.setMenuAbout(f,APPNAME);

%% Make the GUI visible.
update_bottom_panel_visibility('mri')
update_main()
set(f,'Visible','on');
rotate()

end