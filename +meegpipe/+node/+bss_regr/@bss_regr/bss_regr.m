classdef bss_regr < meegpipe.node.abstract_node
    % bss_regr - Blind Source Separation (and regression)
    %
    % See: <a href="matlab:misc.md_help('meegpipe.node.bss_regr')">misc.md_help(''meegpipe.node.bss_regr'')</a>
    
    
    %% IMPLEMENTATION .....................................................
    methods (Static, Access = private)
        
        generate_win_report(subRep, sensors, bss, ics, idx, rej);
        generate_rank_report(subRep, critObj, rankIdx, nbSelComp);
        generate_filt_report(subRep, icsIn, icsOut);
        
    end
    
    %% PUBLIC INTERFACE ...................................................
    
    % meegpipe.node.node interface
    methods
        
        [data, dataNew] = process(obj, data, varargin);
        
    end
    
    % Constructor
    methods
        
        function obj = bss_regr(varargin)
            
            import exceptions.*;
            import report.plotter.io;
            
            obj = obj@meegpipe.node.abstract_node(varargin{:});
            
            if nargin > 0 && ~ischar(varargin{1}),
                % copy construction: keep everything like it is
                return;
            end
            
            if isempty(get_data_selector(obj));
                set_data_selector(obj, pset.selector.good_data);
            end
            
            if isempty(get_name(obj)),
                obj = set_name(obj, 'bss_regr');
            end
            
        end
        
    end
    
    
end