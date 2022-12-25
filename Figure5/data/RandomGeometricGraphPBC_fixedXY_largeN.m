function C = RandomGeometricGraphPBC_fixedXY_largeN(radius,nTrees,x,y) 
%This function only supports Euclidean distance

%% Adjacency matrix
C = cell(nTrees,1);        %Cell of neighbours' coordinates INDEXES arrays
%C{j} are the indexes of the coordinates vectors x and y of j's neighbours

%--Finding neighbourhood for each tree--
for j = 1:nTrees
    x0 = x(j); y0 = y(j);
    distance = sqrt((x - x0).^2 + (y - y0).^2);
    neigh = false(nTrees,1);
    neigh(distance <= radius)= true; %1 in trees that are neighbours of (x0,y0)  
    %PBCs   
    neigh = FindOuterNeighbours(neigh, x0, x, y0, y, radius) ;
    neigh(j) = false;                 %no self-loops
    neighIndexes = find(neigh); %Single index in x or y of neighbours
    C{j} = neighIndexes;
end
