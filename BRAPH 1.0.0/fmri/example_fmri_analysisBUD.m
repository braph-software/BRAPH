% An example file of graph analysis of binary undirected graph with fixed
%   density created from fMRI cohort.
%
% See also fMRIGraphAnalysisBUD, fMRICohort.

% Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
% Date: 2016/01/01

close all
clear all
clc

%% Load fMRI cohort

[file,path,filterindex] = uigetfile('*.fc');
% load file
if filterindex
    filename = fullfile(path,file);
    tmp = load(filename,'-mat','cohort');
    if isa(tmp.cohort,'fMRICohort')
        cohort = tmp.cohort;
        
        disp(['Loaded fMRI cohort ' filename])
    else
        disp('Failed to load fMRI cohort.')
        return
    end
    clear file path filename filterindex tmp;
else
    disp('Failed to load fMRI Cohort.')
    return
end

%% Create fMRI graph analysis

ga = fMRIGraphAnalysisBUD(cohort, Structure(), ...
    fMRIGraphAnalysis.CORR, fMRIGraphAnalysis.CORR_PEARSON, ...  % Choose one: CORR_PEARSON CORR_SPEARMAN CORR_KENDALL CORR_PARTIALPEARSON CORR_PARTIALSPEARMAN
    fMRIGraphAnalysis.NEG, fMRIGraphAnalysis.NEG_ZERO ... Choose one: NEG_ZERO NEG_NONE NEG_ABS
    );

disp(' ')
disp('MEASURES')
for m = GraphBU.MEASURES_BU
    name = Graph.NAME{m};
    nodal = Graph.NODAL(m);
    if nodal 
        disp([int2str(m) ' - ' name ' (nodal)' ])
    else
        disp([int2str(m) ' - ' name ' (global)' ])
    end
end
clear m name nodal;

disp(' ')
disp('GROUPS')
for g = 1:1:ga.cohort.groupnumber()
    gr = cohort.getGroup(g);
    disp([int2str(g) ' - ' gr.getPropValue(Group.NAME)])
end
clear gr;

%% Calculate measure/comparison

while ~exist('stop')
    disp(' ')
    MCF = input('New measure (M) or comparison (C) or random comparison (R) or finish (F) ? ','S');
    
    switch lower(MCF)
        
        case 'm'
            
            groupnumber = input('Group number ');
            measurecode = input('Measure number ');
            density = input('Density ');
            
            ga.calculate(measurecode,groupnumber,density);
            m = ga.getMeasure(measurecode,groupnumber,density);
            gr = ga.getCohort().getGroup(groupnumber);

            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Average measure value = ' num2str(m.mean())])
                disp(['Measure value per subject = ' num2str(m.getProp(fMRIMeasure.VALUES1)')])
                disp('=== === ===')
            end

            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                measure = m.getProp(fMRIMeasureWU.VALUES1);

                values = m.mean();
                ba = ga.getBrainAtlas();
                disp(['Average measure values (per region) = ' num2str(values)])
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) ' - ' br.getPropValue(BrainRegion.NAME)])
                end

                disp('=== === ===')
            end

        case 'c'
            
            groupnumber1 = input('1st group number ');
            groupnumber2 = input('2nd group number ');
            measurecode = input('Measure number ');
            density = input('Density ');
            M = input('Permutation number (typically 1000) ');

            ga.compare(measurecode,groupnumber1,groupnumber2,density,'Verbose',false,'M',M);
            c = ga.getComparison(measurecode,groupnumber1,groupnumber2,density);
            gr1 = ga.getCohort().getGroup(groupnumber1);
            gr2 = ga.getCohort().getGroup(groupnumber2);

            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group numbers = ' int2str(groupnumber1) ' and ' int2str(groupnumber2)])
                disp(['Group names = ' gr1.getPropValue(Group.NAME) ' and ' gr2.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Difference = ' num2str(c.diff()) ])
                disp(['p-value (1) = ' num2str(c.getProp(fMRIComparisonBUD.PVALUE1)) ])
                disp(['p-value (2) = ' num2str(c.getProp(fMRIComparisonBUD.PVALUE2)) ])
                disp(['confidence interval = ' num2str(c.CI(5)') ])
                disp('=== === ===')
            end

            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group numbers = ' int2str(groupnumber1) ' and ' int2str(groupnumber2)])
                disp(['Group names = ' gr1.getPropValue(Group.NAME) ' and ' gr2.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])

                values = c.diff();
                p1 = c.getProp(fMRIComparisonBUD.PVALUE1);
                p2 = c.getProp(fMRIComparisonBUD.PVALUE2);
                ci = c.CI(5);
                ba = ga.getBrainAtlas();
                disp(['Differences (per region) = ' num2str(values)])
                disp(['p-value (1) (per region) = ' num2str(p1)])
                disp(['p-value (2) (per region) = ' num2str(p2)])
                disp(['con.int.do  (per region) = ' num2str(ci(1,:))])
                disp(['con.int.up  (per region) = ' num2str(ci(2,:))])
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) ' - ' br.getPropValue(BrainRegion.NAME)])
                end

                disp('=== === ===')
            end

        case 'r'

            groupnumber = input('Group number ');
            measurecode = input('Measure number ');
            density = input('Density ');
            M = input('random graph number (typically 1000)');
            
            ga.randomcompare(measurecode,groupnumber,density,'Verbose',true,'M',M);
            n = ga.getRandomComparison(measurecode,groupnumber,density);
            gr = ga.getCohort().getGroup(groupnumber);
            
            if Graph.isglobal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' GLOBAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                disp(['Average measure value = ' num2str(n.mean())])
                disp(['Measure value per subject = ' num2str(n.getProp(fMRIMeasure.VALUES1)')])
                disp('=== === ===')
            end

            if Graph.isnodal(measurecode)
                disp('=== === ===')
                disp(['Group number = ' int2str(groupnumber)])
                disp(['Group name = ' gr.getPropValue(Group.NAME)])
                disp(['Measure code = ' int2str(measurecode) ' NODAL MEASURE'])
                disp(['Measure name = ' Graph.NAME{measurecode}])
                measure = n.getProp(fMRIMeasureWU.VALUES1);

                values = n.mean();
                ba = ga.getBrainAtlas();
                disp(['Average measure values (per region) = ' num2str(values)])
                for i = 1:1:ba.length()
                    br = ba.get(i);
                    disp([num2str(values(i)) ' - ' br.getPropValue(BrainRegion.NAME)])
                end

                disp('=== === ===')
            end

        otherwise
            stop = true;
    end
end