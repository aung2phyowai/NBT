function [status, MEh] = test_bss_features()
% TEST_BSS_FEATURES- Tests extraction of BSS features

import mperl.file.spec.*;
import meegpipe.node.*;
import test.simple.*;
import pset.session;
import safefid.safefid;
import datahash.DataHash;
import misc.rmdir;
import oge.has_oge;

MEh     = [];

initialize(5);

%% Create a new session
try
    
    name = 'create new session';
    warning('off', 'session:NewSession');
    session.instance;
    warning('on', 'session:NewSession');
    hashStr = DataHash(randn(1,100));
    session.subsession(hashStr(1:5));
    ok(true, name);
    
catch ME
    
    ok(ME, name);
    status = finalize();
    return;
    
end

%% extract brainloc features 
try    
  
    name = 'extract brainloc features ';
    
    X = rand(4, 5000);
   
    eegSensors = sensors.eeg.from_template('egi256', 'PhysDim', 'uV');
   
    eegSensors   = subset(eegSensors, 1:4);
    
    importer = physioset.import.matrix(250, 'Sensors', eegSensors);
    
    data = import(importer, X);
    
    myCrit = spt.criterion.threshold(spt.feature.tkurtosis, ...
        'Max', @(x) median(x));
    myNode = meegpipe.node.bss.new(...
        'GenerateReport', false, ...
        'Criterion',      myCrit, ...
        'Feature',       {spt.feature.brainloc}, ...
        'FeatureTarget', 'all');
    run(myNode, data);
   
    featFile = catfile(get_full_dir(myNode, data), 'features.txt');
    ok(exist(featFile, 'file'), name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% extract tstat and topo_full features for all components
try    
  
    name = 'extract tstat and topo_full features for all components';
    
    X = rand(4, 5000);
   
    eegSensors = sensors.eeg.from_template('egi256', 'PhysDim', 'uV');
   
    eegSensors   = subset(eegSensors, 1:4);
    
    importer = physioset.import.matrix(250, 'Sensors', eegSensors);
    
    data = import(importer, X);
    
    myCrit = spt.criterion.threshold(spt.feature.tkurtosis, ...
        'Max', @(x) median(x));
    myNode = meegpipe.node.bss.new(...
        'GenerateReport', true, ...
        'Criterion',      myCrit, ...
        'Feature',       {spt.feature.tstat, spt.feature.topo_full}, ...
        'FeatureTarget', 'all');
    run(myNode, data);
   
    featFile = catfile(get_full_dir(myNode, data), 'features.txt');
    ok(exist(featFile, 'file'), name);
    
catch ME
    
    ok(ME, name);
    MEh = [MEh ME];
    
end

%% Cleanup
try
    
    name = 'cleanup';
    clear data dataCopy;
    rmdir(session.instance.Folder, 's');
    session.clear_subsession();
    ok(true, name);
    
catch ME
    ok(ME, name);
end

%% Testing summary
status = finalize();