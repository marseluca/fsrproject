clear
close
clc

pathFound = 0;
maxNIteration = 100; %Iteration of the algorithm in terms of how many qRand has to generate

maxAttempts = 1000000; %Attempts for the algorithm before reporting a failure
attempts = 1;

while pathFound == 0 && attempts < maxAttempts
    clear graph
    %Import Map
    load("image_map.mat");
    figure;
    hold on;
    imshow(image_map);
    
    %Initialization
    %Start Position
    qxStart = 30;
    qyStart = 125;
    
    %Goal Position
    qxGoal = 70;
    qyGoal = 250;
    
    %Actual Position
    qxActual = qxStart;
    qyActual = qyStart;
    
    %Map Dimensions
    qxDim = size(image_map, 1);
    qyDim = size(image_map, 2);
    
    %Map Symbols
    Uknown = -1;
    Obstacle = 0;
    Free = 1;
    
    %Graph
    graph{1,1} = [qxStart,qyStart];
    
    disp(graph);
    
    %Algorithm
    delta = 10;
    neighRadius = delta*2;
    currentStep = 0;
    
    %Reaching Goal
    maxDistToGoal = 50; %To Check if I can reach qGoal from qNear
    
    algorithmIsEnded = 0;
    nIteration = 1;  %Total Iterations
    nIterationToGoal = 100000000;   %Step For Goal as Rand
    

    while nIteration < maxNIteration
    
        %qRand Generation
        % look for a random point that doesn't belong to the visited list
        % after nIterationToGoal set qGoal as rand point
        qRand = GetQRand(qxDim, qyDim, nIteration, nIterationToGoal, qxGoal, qyGoal);
            
                          
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DA TOGLIERE
        % %Determining qNear
        % qNear = graph{1,1};  %[qxNear, qyNear] -> Accedi come qNear(1) per x e qNear(2) per y    
        % distance = sqrt((qxRand-qNear(1))^2 + (qyRand-qNear(2))^2);
        % 
        % %I choose q near evaluating the distance to the qRand position
        % qNearIndexInGraph = 1;
        % 
        % for j = 1:size(graph,2)
        %     tempDist = sqrt((qxRand-graph{1,j}(1))^2 + (qyRand-graph{1,j}(2))^2);
        %     if distance > tempDist
        %         distance = tempDist;
        %         qNearIndexInGraph = j;
        %     end
        % end    
        % qNear = graph{1,qNearIndexInGraph};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        pointsInNeigh = GetPointsInNeighborhood(neighRadius, graph, qRand);

        while isempty(pointsInNeigh)            
            qRand = GetQRand(qxDim, qyDim, nIteration, nIterationToGoal, qxGoal, qyGoal);
            pointsInNeigh = GetPointsInNeighborhood(neighRadius, graph, qRand);
        end

        qNear = GetMinorCostPoint(pointsInNeigh, graph);
        
        for j = 1:size(graph,2)
            if graph{1,j}(1) == qNear(1) && graph{1,j}(2) == qNear(2)
                qNearIndexInGraph = j;
            end
        end    

        % fprintf('\n-----qNear: x.%d - y.%d\n', qNear(1), qNear(2));
        %End Determining qNear        
        
        qxActual = qNear(1);
        qyActual = qNear(2);
        % fprintf('\n-----qActual: x.%d - y.%d\n', qxActual, qyActual);

        collisionOnPath = 0;

        qxRand = qRand(1);
        qyRand = qRand(2);

        distance = sqrt((qxRand-qNear(1))^2 + (qyRand-qNear(2))^2);

        %Angle of the segment connecting qNear and qRand
        angle = real(asin((qyRand-qNear(2))/(distance)));
        % fprintf('-----Angle: %d', angle);

        %Given The Angle I can Compute the point at a distance delta on
        %that segment
        qxNew = qxActual + round(cos(angle)*delta);
        qyNew = qyActual + round(sin(angle)*delta);
        % fprintf('\n-----qNew: x.%d - y.%d\n', qxNew, qyNew);
        
        %Given The angle I can split the segment in order to check
        %collision on the segment connecting qNear and qNew
        for n=0:delta  %Split the segment in delta parts
            qxActual = qNear(1) + round(cos(angle)*(delta-n));
            qyActual = qNear(2) + round(sin(angle)*(delta-n));
            % fprintf('\n-----qActual: x.%d - y.%d\n', qxActual, qyActual);
            if (qxActual > 0) && (qyActual > 0) && (qxActual<qxDim) && (qyActual<qyDim)
                if image_map(qxActual, qyActual) == Obstacle
                    collisionOnPath = 1;
                    break;
                end
            else
                collisionOnPath = 1; %Gestisco un punto fuori mappa come se fosse una collision
                break;
            end  
        end
        
        % fprintf('\n-----qNew: x.%d y.%d', qxNew, qyNew);
        %End Collision Check
        
        %Check Collision Condition and eventually ADD to Graph
        if collisionOnPath == 1
            fprintf('\n-----Current Step: %d\nCurrent q: x.%d y.%d\nCollision Check: There is a Collision\n', currentStep, qxActual, qyActual);
        else
            fprintf('\n-----Current Step: %d\nCurrent q: x.%d y.%d\nCollision Check: There is not a Collision\n', currentStep, qxActual, qyActual);
            
            %Check If qNew is in Graph already
            qNewIsInGraph = 0;
            for j = 1:size(graph,2)        
                if (graph{1,j}(1) == qxNew) && (graph{1,j}(2) == qyNew)
                    qNewIsInGraph = 1;
                end
            end
    
            if qNewIsInGraph == 0 %Add qNew to the Graph if not in Graph Already
                fprintf('-----Add qNew to Graph');
                nCol = size(graph,2);
                nextCol = nCol+1;
                graph{1,nextCol} = [qxNew, qyNew];                
    
                %Add connection from qNear to qNew
                connectionIsMade = 0;
                i=2;
                while connectionIsMade == 0
                    if i<size(graph,1)
                        if ~isempty(graph{i, qNearIndexInGraph})
                            i = i+1;
                        else
                            graph{i, qNearIndexInGraph} = [qxNew, qyNew];
                            connectionIsMade = 1;
                            fprintf('-----Added Connection to Graph for qNew: x.%d - y.%d', qxNew, qyNew);
                        end                
                    else
                        if i>size(graph,1)
                            fprintf('-----Added Connection to Graph for qNew: x.%d - y.%d', qxNew, qyNew);
                            graph{i, qNearIndexInGraph} = [qxNew, qyNew];
                            connectionIsMade = 1;
                        elseif ~isempty(graph{i, qNearIndexInGraph})
                            i = i+1;
                        elseif isempty(graph{i, qNearIndexInGraph})
                            graph{i, qNearIndexInGraph} = [qxNew, qyNew];
                        end
                   end  
                end
                disp(graph);
            end      
        end     
        nIteration = nIteration + 1;
    end
    
    %Plot Connections
    hold on;
    for j=1:size(graph,2)
        for i=2:size(graph,1)
            if ~isempty(graph{i, j})
                hold on;
                plot(graph{i,j}(2), graph{i,j}(1), '.');
                hold on;
                plot([graph{1,j}(2) graph{i,j}(2)],[graph{1,j}(1) graph{i,j}(1)]);
            end
        end
    end

    %Plot Start and Goal Positions
    hold on;
    plot(qyStart, qxStart, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    hold on
    plot(qyGoal, qxGoal, 'go', 'MarkerSize', 10, 'LineWidth', 2);

    %I choose qNearToGoal evaluating the distance to the qGoal position
    qNearToGoalIndexInGraph = 1;
    distanceToGoal = maxDistToGoal;

    for j = 1:size(graph,2)
        qxNear = graph{1,j}(1);
        qyNear = graph{1,j}(2);
        qxActual = qxNear;
        qyActual = qyNear;

        tempDist = sqrt((qxGoal-qxActual)^2 + (qyGoal-qyActual)^2);
        fprintf('\n-----qActual: x.%d - y.%d\nDistance: %d', qxActual, qyActual, tempDist);

        collisionOnPath = 0;
        if tempDist < distanceToGoal

            %Angle of the segment connecting qNear and qGoal
            angle = real(asin((qyGoal-qyActual)/(distance)));
            fprintf('-----Angle: %d', angle);

            %Given The angle I can split the segment in order to check
            %collision on the segment connecting qNear and qGoal
            for n=0:tempDist  %Split the segment in tempDist parts
                qxActual = qxNear + round(cos(angle)*(tempDist-n));
                qyActual = qyNear + round(sin(angle)*(tempDist-n));
                fprintf('\n-----qActual: x.%d - y.%d\n', qxActual, qyActual);
                if (qxActual > 0) && (qyActual > 0) && (qxActual<qxDim) && (qyActual<qyDim)
                    if image_map(qxActual, qyActual) == Obstacle
                        collisionOnPath = 1;
                    end
                else
                    collisionOnPath = 1; %Gestisco un punto fuori mappa come se fosse una collision
                end  
            end

            %End Collision Check

            if collisionOnPath == 0
                distanceToGoal = tempDist;
                qNearToGoalIndexInGraph = j;
                pathFound = 1;
            end
        end                     
    end

    if pathFound == 1
        hold on
        plot([qyGoal graph{1,qNearToGoalIndexInGraph}(2)],[qxGoal graph{1,qNearToGoalIndexInGraph}(1)])
    else
        maxNIteration = maxNIteration + 50;
    end

    attempts = attempts+1;
end    

if pathFound == 1
    fprintf('Path Found')
else
    fprintf('Path not Found')
end