% this function create the .txt files than then importTXT2MAT.m will
% transform to .mat. These .mat are read by Figure5b.m to create the figure
% you DON'T need to run this code again as the .mat are already in the
% folder Figure5b
% you can parallelize this code to send to a computation cluster
% --Initialize variables:
load Hosc3.mat
nTrees = 10000;
nSpecies = 3;
tTerm1 = 3e7;    % before pertur time 7e7
tEpoch = 2e7;    % after pertur
step = 1e4;
tol = nTrees*0.01;
repop = nTrees*0.01;
conquestFactor = 0.1; % NOW it's the % of population species 1 will have,ie perturbabion = 1 -conquestFactor

repetitionVector = 1:50;
radiusVector = [0.022, 0.0292 0.0391, 0.0522 0.0696,  0.0928 0.1237,  0.165 0.22];

for rr = 1:length(radiusVector)
    radius = radiusVector(rr)    
    
    for tt = 1:length(repetitionVector)
        repetition = repetitionVector(tt)
        
        X0 = rand(nSpecies,1);
        X0 = X0/sum(X0);
        ecosystem0 = rand(nTrees,1); % Ecosystem has the plant type in each position
        [sortedX0, I] = sort(X0,'descend');
        sortedX0 = cumsum(sortedX0);
        % Plan type = integer from 1 to nSpecies
        for j = 1:nSpecies
            ecosystem0(ecosystem0 < sortedX0(j)) = I(j);
        end
        ecosystem = ecosystem0; %every radius is computed with same the initial conditions and coordinates
        
        x = rand(nTrees,1); y = rand(nTrees,1);
        C = RandomGeometricGraphPBC_fixedXY_largeN(radius,nTrees,x,y);
        % C saves the indexes of the neighbours of very node (NB indexes from 1 to nTrees)
        density = zeros(nSpecies,1);
        for j = 1:nSpecies
            density(j) = nnz(ecosystem == j);
        end
        %% before perturbabion
        str = sprintf('pulse_RGG%dnodes_radius%.4f_term%.0e_epochs_%.0e_steps_%.0e_per%.3f_%.3d.txt',nTrees,radius,tTerm1,tEpoch,step,1-conquestFactor,repetition);
        file = fopen(str,'w');
        
        fprintf(file,'%f %f %f\n',density(1)/nTrees,density(2)/nTrees,density(3)/nTrees);
        for t = 2:tTerm1
            % Choose a random plant and kill it
            dead = randi(nTrees,1,1);
            deadSpecies = ecosystem(dead);
            % Find its neighbours,periodic neighbourhood
            neighbours = C{dead};
            nNeighs = length(neighbours);
            if nNeighs >= 2
                % Pick two at random: n1,n2 are indeces,
                %neigh1,neigh2 are the tree type
                idx = randi(nNeighs,1,1);
                n1 = neighbours(idx);
                idx2 = randi(nNeighs,1,1);
                while idx2 == idx
                    idx2 = randi(nNeighs,1,1);
                end
                n2 = neighbours(idx2);
                neigh1 = ecosystem(n1);
                neigh2 = ecosystem(n2);
                % Make them compete
                if rand < H(neigh1,neigh2)
                    ecosystem(dead) = ecosystem(n1);
                    % Update density vector
                    density(deadSpecies) = density(deadSpecies) - 1;
                    density(neigh1) = density(neigh1) + 1;
                else
                    ecosystem(dead) = ecosystem(n2);
                    % Update density vector
                    density(deadSpecies) = density(deadSpecies) - 1;
                    density(neigh2) = density(neigh2) + 1;
                end
                
            end
            if mod(t,step) == 1
                d = density; %Normalization!!!
                fprintf(file,'%f %f %f\n',d(1)/nTrees,d(2)/nTrees,d(3)/nTrees);
            end
            
            % 
            if sum(density(:) < tol) ~= 0
                endange =  find(density(:) < tol);
                for j = 1:repop
                    x = randi(nTrees,1,1);
                    old = ecosystem(x);
                    ecosystem(x) = endange(1);
                    density(endange(1)) = density(endange(1)) + 1;
                    density(old) = density(old) - 1;
                    
                end
            end
            
        end
        %% --PERTURBATION:
        
        pertur = nTrees - conquestFactor*nTrees;
        n_new_sp1 = pertur - density(1);
        
        if n_new_sp1 >= 0 %so pertur increases abundance of species 1
            idx_species1 = find(ecosystem == 1);
            idx_species2 = find(ecosystem == 2);
            idx_species3 = find(ecosystem == 3);
            
            both = [idx_species2; idx_species3];
            idx_new_sp1 = both(randperm(length(both),n_new_sp1));
            ecosystem(idx_new_sp1) = 1;
            
        else %pertur < n_sp1
            idx_species1 = find(ecosystem == 1);
            reshuffled_idx = idx_species1(randperm(length(idx_species1)));
            no_sp1_anymore = reshuffled_idx(pertur+1:end);
            midterm = round(length(no_sp1_anymore)/2);
            idx_new_sp2 = no_sp1_anymore(1:midterm);
            idx_new_sp3 = no_sp1_anymore(midterm+1:end);
            ecosystem(idx_new_sp2) = 2;
            ecosystem(idx_new_sp3) = 3;
            
        end
        
        density(1) =  sum(ecosystem == 1);
        density(2) = sum(ecosystem == 2);
        density(3) = sum(ecosystem == 3);
        
        %% --Epochs SAVING:
        fprintf(file,'%f %f %f\n',density(1)/nTrees,density(2)/nTrees,density(3)/nTrees);
        for t = 1:tEpoch
            % Choose a random plant and kill it
            dead = randi(nTrees,1,1);
            deadSpecies = ecosystem(dead);
            % Find its neighbours,periodic neighbourhood
            neighbours = C{dead};
            nNeighs = length(neighbours);
            if nNeighs >= 2
                % Pick two at random: n1,n2 are indeces,
                %neigh1,neigh2 are the tree type
                idx = randi(nNeighs,1,1);
                n1 = neighbours(idx);
                idx2 = randi(nNeighs,1,1);
                while idx2 == idx
                    idx2 = randi(nNeighs,1,1);
                end
                n2 = neighbours(idx2);
                neigh1 = ecosystem(n1);
                neigh2 = ecosystem(n2);
                % Make them compete
                if rand < H(neigh1,neigh2)
                    ecosystem(dead) = ecosystem(n1);
                    % Update density vector
                    density(deadSpecies) = density(deadSpecies) - 1;
                    density(neigh1) = density(neigh1) + 1;
                else
                    ecosystem(dead) = ecosystem(n2);
                    % Update density vector
                    density(deadSpecies) = density(deadSpecies) - 1;
                    density(neigh2) = density(neigh2) + 1;
                end
                
            end
            if mod(t,step) == 1
                d = density; %Normalization!!!
                fprintf(file,'%f %f %f\n',d(1)/nTrees,d(2)/nTrees,d(3)/nTrees);
            end
            
            if nnz(density) ~= nSpecies
                extinct =  find(density(:) <= 0);
                sprintf('extinct species = %d, rep%d',extinct,repetition) %extinct
                d = density;
                fprintf(file,'%f %f %f\n',d(1)/nTrees,d(2)/nTrees,d(3)/nTrees);
                t
                break
            end
            
        end
        %% Save Results of a certain radius and repetition:
        fclose(file);
        
    end
end