% File to test the use of BrainAtlas.
%
% See also BrainAtlas, BrainRegion, List, ListElement.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Create BrainAtlas from BrainRegion list

br1 = BrainRegion(BrainRegion.LABEL,'REG. 1', ...
    BrainRegion.NAME,'Brain Region 1', ...
    BrainRegion.X,1, ...
    BrainRegion.Y,1, ...
    BrainRegion.Z,1, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes1 ...');

br2 = BrainRegion(BrainRegion.LABEL,'REG. 2', ...
    BrainRegion.NAME,'Brain Region 2', ...
    BrainRegion.X,2, ...
    BrainRegion.Y,-2, ...
    BrainRegion.Z,2, ...
    BrainRegion.HS,BrainRegion.HS_RIGHT, ...
    BrainRegion.NOTES,'notes2 ...');

br3 = BrainRegion(BrainRegion.LABEL,'REG. 3', ...
    BrainRegion.NAME,'Brain Region 3', ...
    BrainRegion.X,3, ...
    BrainRegion.Y,3, ...
    BrainRegion.Z,-3, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes3 ...');

br4 = BrainRegion(BrainRegion.LABEL,'REG. 4', ...
    BrainRegion.NAME,'Brain Region 4', ...
    BrainRegion.X,-4, ...
    BrainRegion.Y,4, ...
    BrainRegion.Z,4, ...
    BrainRegion.HS,BrainRegion.HS_RIGHT, ...
    BrainRegion.NOTES,'notes4 ...');

brs = {br1 br2 br3 br4};
atlas = BrainAtlas(brs,BrainAtlas.NAME,'Atlas1')

%% length, get, getProps

length = atlas.length()  % number of brain regions in an atlas
br = atlas.get(1)  % gets the property of brain region 1
props = atlas.getProps(BrainRegion.NAME)  % gets names of all brain regions

%% add, remove, replace, invert, moveto

br5 = BrainRegion(BrainRegion.LABEL,'REG. 5', ...
    BrainRegion.NAME,'Brain Region 5', ...
    BrainRegion.X,-5, ...
    BrainRegion.Y,-5, ...
    BrainRegion.Z,5, ...
    BrainRegion.HS,BrainRegion.HS_LEFT, ...
    BrainRegion.NOTES,'notes5 ...');

atlas.add(br5,3)  % add br5 to position 3
atlas.remove(5)
atlas.replace(3,br4)
atlas.invert(3,4)  % invert brain region at positions 3 and 4
atlas.add(br5,5)
atlas.moveto(5,3) % add brain region at position 5 to position 3
atlas.moveto(3,5)

atlas

%% removeall, addabove, addbelow, moveup, movedown, move2top, move2bottom

removedall = atlas.removeall([1 2 3]);  % remove brain regions at positions 1, 2 and 3
atlas.add(br1,1)
atlas.add(br2,2)
atlas.add(br3,3)

[selected,added] = atlas.addabove([1 3 5]);  % add brain regions above ones at positions 1, 3 and 5 
atlas.removeall(added);

selected = atlas.moveup([1 3 5]);
selected = atlas.movedown(selected(2:3));
selected = atlas.move2top([4 5]);
selected = atlas.move2bottom([1 2]);

atlas

%% toXML, fromXML

% save atlas to XML file
Document = com.mathworks.xml.XMLUtils.createDocument('xml');
RootNode = Document.getDocumentElement;
ElementNode = atlas.toXML(Document,RootNode);
xmltext = xmlwrite(Document)

% load atlas from XML file
xml_atlas = BrainAtlas();
fromXML(xml_atlas,ElementNode)
 
%% elementClass, getTags, getFormats, getDefaults, getOptions

atlas.elementClass()
TAGS = atlas.getTags()
FORMATS = atlas.getFormats()
DEFAULTS = atlas.getDefaults()
OPTIONS = atlas.getOptions(BrainAtlas.BRAINSURF)

%% clear and copy
clc
atlas2 = atlas.copy();
atlas.get(2).clear()

atlas
atlas2

atlas.clear()

atlas
atlas2
