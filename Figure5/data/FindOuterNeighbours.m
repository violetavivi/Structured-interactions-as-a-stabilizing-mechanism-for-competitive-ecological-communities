function totNeigh = FindOuterNeighbours(neigh, x0, x, y0, y, radius)
if x0 + radius > 1 %rigth exit
    x0 = x0-1;
    if  y0 + radius  > 1 %rigth top exit
        y0 = y0-1;
    elseif y0 <= radius     %rigth bottom exit
        y0 = y0+1;
    end
    distance = sqrt((x - x0).^2 + (y - y0).^2);
    newNeigh = false(length(neigh),1);
    newNeigh(distance <= radius)= true;
    totNeigh = newNeigh + neigh;
elseif x0 < radius    %left exit
    x0 = x0+1;
    if y0 + radius  > 1 %left top exit
        y0 = y0-1;
    elseif y0 <= radius     %left bottom exit
        y0 = y0 +1;
    end
    distance = sqrt((x - x0).^2 + (y - y0).^2);
    newNeigh = false(length(neigh),1);
    newNeigh(distance <= radius)= true;
    totNeigh = newNeigh + neigh;
    
    %%%%%%%%%%%%%%%
elseif y0 + radius > 1 && x0 <= 1
    y0 = y0-1;
    
    distance = sqrt((x - x0).^2 + (y - y0).^2);
    newNeigh = false(length(neigh),1);
    newNeigh(distance <= radius)= true;
    totNeigh = newNeigh + neigh;
elseif y0 < radius  && x0 <= 1
    y0 = y0+1;
    
    distance = sqrt((x - x0).^2 + (y - y0).^2);
    newNeigh = false(length(neigh),1);
    newNeigh(distance <= radius)= true;
    totNeigh = newNeigh + neigh;  
    
else
    totNeigh = neigh;
end