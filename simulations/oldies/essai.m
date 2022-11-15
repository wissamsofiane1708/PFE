% vérification de l'utilisation de randperm dans sournote1

rng('shuffle'); % initialisation générateur nbs aléatoires    
Nnotes = 3;
A = [2 1 3];
N123 = 0; N132 = 0; N213 = 0; N231 = 0; N312 = 0; N321 = 0;
for k = 1:20000
        drapeau = 0;
        while drapeau==0
            B = randperm(Nnotes);
            for i = 1:Nnotes
                 if B(i) ~= A(i)
                       drapeau = 1;
                 end
            end
        end
        if B == [1 2 3]
            N123 = N123 + 1;
        elseif B == [1 3 2]
            N132 = N132 + 1;
        elseif B == [2 1 3]
            N213 = N213 + 1;
        elseif B == [2 3 1]
            N231 = N231 + 1;
        elseif B == [3 1 2]
            N312 = N312 + 1;
        else
            N321 = N321 + 1;
        end
end
N123
N132
N213
N231
N312
N321