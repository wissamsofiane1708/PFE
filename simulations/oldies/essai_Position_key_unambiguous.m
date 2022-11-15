     
% test du calcul de Position_key_unambiguous 
%

        reference = [0 2 4 5 7 9 11 12];
        Position_key_unambiguous = zeros(1, 8);
        
        Omissions = [2 4 0 7 9 5 11 12];
        
        note = reference; % liste des 8 degrés (valeurs en demi-tons) auxquels peut correspondre la 1ère note de pattern 1
        for rang = 2 : 8
             candidats_note_suivante = note + Omissions(1, rang) - Omissions(1, rang-1)
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
             note_suivante
             if size(note_suivante, 2)==1 % note_suivante ne peut jamais être égal à [0 12]             
                 Position_key_unambiguous(1, rang) = Position_key_unambiguous(1, rang) + 1;
                 break
             else
                 note = note_suivante;
             end
        end
        

Position_key_unambiguous
        