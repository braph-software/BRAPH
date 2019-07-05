% File to test the use of PlotData, PlotDataElement, PlotDataArea.
%
% See also PlotData, PlotDataElement, PlotDataArea.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create PlotData from PlotDataElement and PlotDataArea list

pde1 = PlotDataElement(PlotDataElement.CODE,'element 1', ...
    PlotDataElement.X,[0:1:10], ...
    PlotDataElement.Y,[0:1:10]);

pde2 = PlotDataElement(PlotDataElement.CODE,'element 2', ...
    PlotDataElement.X,[0:1:5], ...
    PlotDataElement.Y,[0:1:5].^2);

pda1 = PlotDataArea(PlotDataArea.CODE,'area 1', ...
    PlotDataArea.X,[0:2:20], ...
    PlotDataArea.Y,[0:1:10], ...
    PlotDataArea.Y_HIGH,[0:1:10]+2, ...
    PlotDataArea.Y_LOW,[0:1:10]-2, ...
    PlotDataArea.Y_MID,[0:1:10]);

pds = {pde1 pde2 pda1};
pd = PlotData(pds,PlotData.NAME,'Plot',PlotData.XLABEL,'x',PlotData.YLABEL,'y');

%% Plot data
figure(1)

pd.plot_single_data(1,'LineWidth',2,'LineColor',[1 0 0])
pd.plot_single_data(3,'Marker','s')

figure(2)
pd2 = pd.copy()
pd2.plot_data()

pd.set_title()
pd.set_labels('fontsize',25)

%% Plot area
pd.plot_single_high(3,'Marker','s','LineWidth',2,'LineColor',[1 0 0]);
pd.plot_single_low(3,'Marker','s')
pd.plot_single_mid(3,'Marker','d','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 .5 .5],'LineStyle','--')
pd.plot_single_area(3,'EdgeWidth',10)

%% Settings
pd.plot_data_settings()
pd.plot_mid_settings();
pd.plot_low_settings();
pd.plot_high_settings();
pd.plot_area_settings();