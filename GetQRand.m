function qRand = GetQRand(qxDim,qyDim,nIteration, nIterationToGoal, qxGoal, qyGoal)
    % if mod(nIteration, nIterationToGoal) == 0
    %     %Non fa parte della implementazione standard, è stato
    %     %aggiunto successivamente per sperimentare con le performance
    %     fprintf('\n-----qGoal scelto come qRand\n');    
    %     qxRand = qxGoal;
    %     qyRand = qyGoal;
    %     nIterationToGoal = 0;
    %     qRand = [qxRand, qyRand];
    % else
    %     fprintf('\n-----qRand scelto Casualmente\n');
    %     qxRand = randi(qxDim);
    %     qyRand = randi(qyDim);
    %     qRand = [qxRand, qyRand];
    % end
    qxRand = randi(qxDim);
    qyRand = randi(qyDim);
    qRand = [qxRand, qyRand];
    % fprintf('\n-----qRand: x.%d y.%d\n', qRand);
end