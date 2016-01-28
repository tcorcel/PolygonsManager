function pcaLoadings(obj)

[cp1, cp2] = pcaLoadingsPrompt(length(obj.model.pca.loadings.rowNames));

if isnumeric([cp1 cp2])
    fen = PolygonsManagerMainFrame;
    setupNewFrame(fen, obj.model.pca.loadings.rowNames, obj.model.PolygonArray, ...
                                         'factorTable', obj.model.factorTable, ...
                                                 'pca', obj.model.pca, ...
                       obj.model.pca.loadings(:, cp1).data, ...
                       obj.model.pca.loadings(:, cp2).data, ...
                       'off');
    
    if isa(fen.model.factorTable, 'Table')
        set(fen.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Loadings']);
    else
        set(fen.handles.figure, 'name', 'Polygons Manager | PCA - Loadings');
    end
    
    % create legends
    annotateFactorialPlot(fen.model.pca, fen.handles.axes{1}, cp1, cp2);
end

function [cp1, cp2] = pcaLoadingsPrompt(nbCP)
%COLORFACTORPROMPT  A dialog figure on which the user can select
%which factor he wants to see colored and if he wants to display the
%legend or not
%
%   Inputs : none
%   Outputs : 
%       - factor : selected factor
%       - leg : display option of the legend

    % default value of the ouput to prevent errors
    cp1 = '?';
    cp2 = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 165);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'CP 1 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
                    'Position', [130 117 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbCP);

    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'CP 2 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup2 = uicontrol('Parent', d, ...
                    'Position', [130 82 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbCP, ...
                       'value', 2);

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate',...
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback(~,~)
        cp1 = popup1.Value;
        cp2 = popup2.Value;
        
        delete(gcf);
    end
end

end