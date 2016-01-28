function pcaScores(obj)

if isempty(obj.handles.Panels{1}.type)
    [cp1, cp2, equal] = pcaScoresPrompt(length(obj.model.pca.scores.rowNames));
    
    if isnumeric([cp1 cp2])
        fen = PolygonsManagerMainFrame;
        % set the new polygon array as the current polygon array
        model = PolygonsManagerData('PolygonArray', obj.model.PolygonArray, ...
                                        'nameList', obj.model.nameList, ...
                                     'factorTable', obj.model.factorTable, ...
                                             'pca', obj.model.pca);

        setupNewFrame(fen, model, ...
                      obj.model.pca.scores(:, cp1).data, ...
                      obj.model.pca.scores(:, cp2).data, ...
                      equal, 'pcaScores');

        if isa(fen.model.factorTable, 'Table')
            set(fen.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Scores']);
        else
            set(fen.handles.figure, 'name', 'Polygons Manager | PCA - Scores');
        end
        
        fen.handles.Panels{1}.uiAxis.UserData = {cp1, cp2};

        xlim(fen.handles.Panels{1}.uiAxis, [min(obj.model.pca.scores(:, cp1).data)-1 max(obj.model.pca.scores(:, cp1).data)+1]);
        ylim(fen.handles.Panels{1}.uiAxis, [min(obj.model.pca.scores(:, cp2).data)-1 max(obj.model.pca.scores(:, cp2).data)+1]);

        % create legends
        annotateFactorialPlot(fen.model.pca, fen.handles.Panels{1}.uiAxis, cp1, cp2);

    end
else
    ud = obj.handles.Panels{1}.uiAxis.UserData;
    displayPca(obj.handles.Panels{1}, obj.model.pca.scores(:, ud{1}).data, obj.model.pca.scores(:, ud{2}).data);
end
function [cp1, cp2, equal] = pcaScoresPrompt(nbCP)
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
    equal = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 200);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    uicontrol('parent', d, ...
            'position', [30 150 90 20], ...
               'style', 'text', ...
              'string', 'CP 1 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup1 = uicontrol('Parent', d, ...
                    'Position', [130 152 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbCP);

    uicontrol('parent', d, ...
            'position', [30 115 90 20], ...
               'style', 'text', ...
              'string', 'CP 2 :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    popup2 = uicontrol('Parent', d, ...
                    'Position', [130 117 90 20], ...
                       'Style', 'popup', ...
                      'string', 1:nbCP, ...
                       'value', 2);

    uicontrol('parent', d, ...
            'position', [30 80 90 20], ...
               'style', 'text', ...
              'string', 'Axis equal :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    toggleB = uicontrol('parent', d, ...
                   'position', [130 81 90 20], ...
                      'style', 'toggleButton', ...
                     'string', 'On', ...
                   'callback', @toggle);


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
        equal = lower(get(toggleB,'String'));
        
        delete(gcf);
    end
    

    function toggle(~,~)
        if get(toggleB,'Value') == 1
            set(toggleB, 'string', 'Off');
        else 
            set(toggleB, 'string', 'On');
        end
    end
end

end