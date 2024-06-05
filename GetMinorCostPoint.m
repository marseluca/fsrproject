function MinorCostPoint = GetMinorCostPoint(pointsInNeigh, graph)
%scorro tutti i punti
%scelgo come euristica la distanza tra due punti
pathTotalCosts = [];

    for i=1:size(pointsInNeigh,1)
        actualPoint = pointsInNeigh(i,:)
    
        %Find actualPoint index in Graph
        posInGraph=1;
        while ~isequal(actualPoint,graph{1,posInGraph})
        % while (actualPoint(1) ~= graph{1,posInGraph}(1)) && (actualPoint(2) ~= graph{1,posInGraph}(2))
            posInGraph = posInGraph + 1
            if (actualPoint(1) == graph{1,posInGraph}(1)) && (actualPoint(2) == graph{1,posInGraph}(2))
                fprintf("Trovato posInGraph: %d",posInGraph);
            end
        end
    
        %parto da un punto, cerco a chi è collegato vedendo nelle colonne precedenti
        reversePath = [actualPoint];
    
       
        while actualPoint(1) ~= graph{1,1}(1) && actualPoint(2) ~= graph{1,1}(2)
            for j = 1:posInGraph-1
                for k = 2:size(graph,1)
                    if ~isempty(graph{k,j})                       
                        if graph{k,j}(1) == actualPoint(1) && graph{k,j}(2) == actualPoint(2)                       
                            reversePath = [reversePath; graph{1,j}];
                            actualPoint = graph{1,j};
                        end
                    end
                end
            end
        end
    
        tempCost = 0;
        for c = 1:size(reversePath,1)-1
            tempCost = tempCost + sqrt((reversePath(c,1)-reversePath(c+1,1))^2 + (reversePath(c,2)-reversePath(c+1,2)^2));
        end
    
        pathTotalCosts = [pathTotalCosts; tempCost];

        reversePath
    %prendo la prima riga della colonna trovata
    %itero fino a start point
    end

    indexOfMinorCostPoint = find(pathTotalCosts == min(pathTotalCosts), 1);
    MinorCostPoint = pointsInNeigh(indexOfMinorCostPoint,:);
    display(MinorCostPoint);
end