function detectLineClick(h,~, obj)
%CREATEFACTORS  callback used when the user clicks on one of the axis' line
%
%   Inputs :
%       - h : handle of the object that sent the callback 
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

    % check is the 'ctrl' key is pressed   
    modifiers = get(obj.handles.figure,'currentModifier');
    ctrlIsPressed = ismember('control',modifiers);
    
    if ~ctrlIsPressed
        % if the 'ctrl' key wasn't pressed
        if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
            % if the clicked line was already selected
            if length(obj.model.selectedPolygons) == 1
                % if the clicked line was the only selected line, deselect it
                obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
            else
                % if the clicked line wasn't the only selected line, set it as the only selected line
                obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
            end
        else
            % if the line wasn't already selected, set it as the only selected line
            obj.model.selectedPolygons = obj.model.nameList(strcmp(get(h,'tag'), obj.model.nameList));
        end
    else
        % if the 'ctrl' key was pressed
        if find(strcmp(get(h,'tag'), obj.model.selectedPolygons))
            % if the clicked line was already selected, deselect it
            obj.model.selectedPolygons(strcmp(get(h,'tag'), obj.model.selectedPolygons)) = [];
        else
            % if the clicked line wasn't selected, add it to the list of
            % selected lines
            obj.model.selectedPolygons{end+1} = obj.model.nameList{strcmp(get(h,'tag'), obj.model.nameList)};
        end
    end
    %update the lines displayed
    updateSelectedPolygonsDisplay(obj);
    
    % match the selection of the name list to the selection of the axis
    set(obj.handles.list, 'value', find(ismember(obj.model.nameList, obj.model.selectedPolygons)));
end