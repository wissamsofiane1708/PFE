% vérification du changement de scale dans sournote5

rng('shuffle');
Nnotes = 8;
stretch = 1.2;
scale = stretch * [0 2 4 5 7 9 11 12]
drapeau = 0; 
while drapeau ~= Nnotes
            notechange = 1 + ceil(rand * (Nnotes - 2)) % varie de 2 à (Nnotes - 1)
            demitons_avant_changement = scale(notechange);
            if rand < 0.5
                demitons_apres_changement = demitons_avant_changement - stretch;
            else
                demitons_apres_changement = demitons_avant_changement + stretch;
            end
            demitons_apres_changement
            drapeau = 0;
            drapeau_avant_boucle = drapeau
            for i = 1:Nnotes    
                     if scale(i) ~= demitons_apres_changement
                           drapeau = drapeau + 1;
                     end                        
            end 
            drapeau_apres_boucle = drapeau
end 
if demitons_apres_changement < demitons_avant_changement
          demitons_apres_changement = demitons_apres_changement + stretch - 1;
else
          demitons_apres_changement = demitons_apres_changement - stretch + 1;       
end  
demitons_apres_changement
