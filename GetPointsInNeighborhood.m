function pointsInNeigh = GetPointsInNeighborhood(neighRadius,graph, qRand)
    pointsInNeigh = [];
    for i=1:size(graph,2)
        if (sqrt((qRand(1)-graph{1,i}(1))^2 + (qRand(2)-graph{1,i}(2))^2)) < neighRadius
            pointsInNeigh=[pointsInNeigh;graph{1,i}]
        end
    end
end