     
% test du calcul de Position_key_unambiguous 
%

rng('shuffle');
reference = [0 2 4 5 7 9 11 12];
Position_key_unambiguous = zeros(1, 8);

compteur_0_12 = 0; % compteur de [0 12]

for essais = 1 : 10000
        
        Omissions = zeros(1, 8);
        z = randperm(8);
        for k = 1 : 8
              if z(1, k)==1
                  Omissions(1, k) = 0;
              elseif z(1, k)==2    
                  Omissions(1, k) = 2;
              elseif z(1, k)==3    
                  Omissions(1, k) = 4;   
              elseif z(1, k)==4    
                  Omissions(1, k) = 5;    
              elseif z(1, k)==5    
                  Omissions(1, k) = 7;   
              elseif z(1, k)==6    
                  Omissions(1, k) = 9;   
              elseif z(1, k)==7    
                  Omissions(1, k) = 11;   
              elseif z(1, k)==8    
                  Omissions(1, k) = 12;  
              end
        end
                                     
        note = reference; % liste des 8 degrés (valeurs en demi-tons) auxquels peut correspondre la 1ère note de pattern 1
        for rang = 2 : 8
             candidats_note_suivante = note + Omissions(1, rang) - Omissions(1, rang-1);
             % on va retenir tous les candidats faisant partie du vecteur reference, sans tenir compte du fait que dans l'expérience
             % un degré donné n'apparait qu'une seule fois dans pattern 1
             note_suivante = [ ]; % initialisation
             for cand = 1 : size(candidats_note_suivante, 2)
                 candidat = candidats_note_suivante(cand);
                 for degre = 1 : 8
                     if candidat==reference(degre)
                         note_suivante = [note_suivante candidat];
                     end
                 end
             end
             
             if size(note_suivante, 2)==2
                 if note_suivante==[0 12]
                     compteur_0_12 = compteur_0_12 + 1;
                 end
             end
             
             if size(note_suivante, 2)==1  % note_suivante ne peut jamais être égal à [0 12]             
                 Position_key_unambiguous(1, rang) = Position_key_unambiguous(1, rang) + 1;
                 break
             else
                 note = note_suivante;
             end
        end
      
end

Position_key_unambiguous
compteur_0_12
        