% Calcul de statistiques sur la liste des omissions faites par un sujet dans sournote8 avec l'échelle 1, Phrygian.
% Au début, on donne une matrice de 'Nomissions' lignes et 16 colonnes (pattern_1_demitons pattern_2_demitons). 
% Output :
% Pour pattern 2 :
% --- Position_sour, temporal position of the sour note. Vector 8 columns ; values : 1 --> 8
% --- Violation_type. Vector 4 columns ; values : 5-->4, 5-->6, 7-->6, 8-->9


Omissions = [0	12	1	5	10	3	7	8		6	5	8	3	10	1	12	0
12	8	0	5	1	7	10	3		4	3	1	8	0	10	7	12
10	0	5	3	7	8	12	1		6	8	12	3	0	5	10	1
7	12	3	10	0	8	1	5		5	7	12	9	3	1	0	10
0	7	10	12	3	1	5	8		5	12	3	6	1	0	10	8
7	1	8	10	12	0	3	5		6	1	0	5	8	3	12	10];

Nomissions = size(Omissions, 1)
%
Position_sour = zeros(1, 8);
Violation_type = zeros(1, 4);
%
for i = 1 : Nomissions
        % Position_sour
        for j = 9 : 16
             if Omissions(i, j)==4 || Omissions(i, j)==6 || Omissions(i, j)==9 
                    Position_sour(1, j-8) =  Position_sour(1, j-8) + 1;   
             end
        end
        %
        %
        %
        % Violation_type
        Somme_demitons = 0;  % initialisation  
        for j = 9 : 16
                  if Omissions(i, j)==4 
                         Violation_type(1, 1) = Violation_type(1, 1) + 1; % erreur 5 --> 4
                  elseif Omissions(i, j)==6
                         for k = 9 : 16
                                Somme_demitons = Somme_demitons + Omissions(i, k);
                         end
                         if Somme_demitons > 46 % 46 = 0+1+3+5+7+8+10+12
                                Violation_type(1, 2) = Violation_type(1, 2) + 1; % erreur 5 --> 6
                         else
                                Violation_type(1, 3) = Violation_type(1, 3) + 1; % erreur 7 --> 6
                         end
                  elseif Omissions(i, j)==9
                         Violation_type(1, 4) = Violation_type(1, 4) + 1; % erreur 8 --> 9                     
                  end
        end
end

Position_sour = Position_sour / Nomissions
Violation_type = Violation_type / Nomissions
