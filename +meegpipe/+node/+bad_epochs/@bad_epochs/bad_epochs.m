classdef bad_epochs < meegpipe.node.abstract_node
    % BAD_EPOCHS - Rejects bad data epochs
    %
    % import meegpipe.node.bad_epochs.*;
    % obj = bad_epochs
    % obj = bad_epochs('key', value, ...)
    %
    % ## Accepted key/value pairs:
    %
    % * All key/value pairs accepted by abstract_node
    %
    % * All key/value pairs accepted by meegpipe.node.bad_epochs.config
    %
    %
    % See also: config, abstract_node
    
    
    
    %% IMPLEMENTATION .....................................................
    
    % Helper methods
    methods (Access = private, Static)
        
        generate_rank_report(obj, data, sensors, rejIdx, rankVal);
        
    end
    
    % Helper static methods
    methods (Access = private, Static)
        
        % To generate the figures of Remark reports
        hFig = make_topo_plots(sens, rejIdx, xvar)
        
        hFig = make_rank_plots(sens, rejIdx, xvar);
        
    end
    
    
    %% PUBLIC INTERFACE ...................................................
    
    
    methods
        % meegpipe.node.node interface
        [data, dataNew] = process(data, varargin);
        
        % reimplementation of method from abstract_node
        disp(obj);
        
    end

    
    % Constructor
    methods
        
        function obj = bad_epochs(varargin)
            
            import pset.selector.sensor_class;
            import pset.selector.good_data;
            import pset.selector.cascade;
            
            obj = obj@meegpipe.node.abstract_node(varargin{:});
            
            if nargin > 0 && ~ischar(varargin{1}),
                % copy construction: keep everything like it is
                return;
            end
            
            % Default data selector selects only EEG and MEG channels
            dataSel1 = sensor_class('Class', {'EEG', 'MEG'});
            dataSel2 = good_data;
            dataSel  = cascade(dataSel1, dataSel2);
            
            if isempty(get_data_selector(obj));                
                set_data_selector(obj, dataSel);
            end
            
            if isempty(get_name(obj)),
                obj = set_name(obj, 'bad_epochs');
            end
            
        end
        
    end
    
end