
% Calcul de la distribution statistique des intervalles entre notes CONSECUTIVES dans sournote4

    rng('shuffle'); 
    echelle = input('num�ro de l''�chelle (2 ou 3) :  ');
    if echelle==2
         scale = [0 2 4 5 7 9 11 12]; % diatonique, mode majeur
    elseif echelle==3
         scale = [0 2 4 6 8 10 12]; % tons entiers
    end
    Nnotes = size(scale, 2);
    total_essais = input('nombre d''essais :  ');
    Interv = zeros(1, 12); % l'ensemble des intervalles m�lodiques possibles : de 1 � 12 demi-tons
    %
    for essais = 1 : total_essais
             ordrenotes = randperm(Nnotes);
             patterndemitons = [ ]; % c'est la succession des valeurs de la variable demitons  
             for i = 1:Nnotes
                        z = ordrenotes(1, i);
                        demitons = scale(1, z);
                        patterndemitons = [patterndemitons demitons]; % concat�nation couteuse (d'o� le soulign�), mais on s'en fout
             end   
             for i = 2 : Nnotes
                        absinterv = abs(patterndemitons(i) - patterndemitons(i-1));
                        Interv(1, absinterv) = Interv(1, absinterv) + 1;                 
             end      
    end
    Interv*100/(sum(Interv)) % intervalles en pourcentages
    
