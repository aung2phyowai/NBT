function myPipe = alpha_features_pipeline(varargin)

import meegpipe.*;

import pset.selector.sensor_class;
import pset.selector.cascade;
import pset.selector.good_data;

USE_OGE = true;
DO_REPORT = true;
QUEUE = 'short.q';

nodeList = {};

%% Import
myImporter = physioset.import.physioset;
myNode = node.physioset_import.new('Importer', myImporter);
nodeList = [nodeList {myNode}];

%% copy data
% We create a temporary on the LOCAL temp dir. This should speed up
% processing considerably when the job is running at a node other than
% somerenserver (where the raw data is located).
myNode = node.copy.new('Path', @() tempdir);
nodeList = [nodeList {myNode}];

%% A BSS node that extracts alpha features
myFeat = spt.feature.psd_ratio(...
    'TargetBand',     [7 12], ...
    'RefBand',        [1 6;16 25], ...
    'TargetBandStat', @(power) max(power), ...
    'RefBandStat',    @(power) prctile(power, 90) ...
    );
    
myCrit = spt.criterion.threshold(myFeat, ...
    'Max', @(feat) median(feat)+2*mad(feat), 'MaxCard', 10);
mySel = pset.selector.cascade(...
    pset.selector.sensor_class('Class', 'EEG'), ...
    pset.selector.good_data);

myPCA = spt.pca(...
    'RetainedVar',  99.75, ...
    'MaxCard',      35);
    
myNode = node.bss.new(...
    'PCA',          myPCA, ...
    'DataSelector', mySel, ...
    'Criterion',    myCrit, ...
    'Feature',      {spt.feature.topo_full}, ...
    'FeatureTarget', 'selected', ...
    'Reject',       false, ...
    'IOReport',     report.plotter.io);
nodeList = [nodeList {myNode}];

%% Pipeline
myPipe = node.pipeline.new(...
    'NodeList',         nodeList, ...
    'Save',             true, ...
    'Parallelize',      USE_OGE, ...
    'GenerateReport',   DO_REPORT, ...
    'Name',             'alpha_features_pipe', ...
    'Queue',            QUEUE, ...
    'TempDir',          @() tempdir, ... 
    varargin{:} ...
    );

end