% Calcul de statistiques sur la liste des omissions faites par un sujet dans sournote4 avec l'échelle 3, tons entiers
% Au début, on donne une matrice de 'Nomissions' lignes et 14 colonnes (pattern_1_demitons pattern_2_demitons). 
% Output :
% Pour pattern 2 :
% --- Position_sour, temporal position of the sour note. Vector 7 columns ; values : 1 --> 7
% --- Interv_sour, melodic interval leading to the sour note. Vector 6 columns ; values : 1, 3, 5, 7, 9, 11
% --- Violation_type. Vector 10 columns ; values : 2-1, 2-3, 4-3, 4-5, 6-5, 6-7, 8-7, 8-9, 10-9, 10-11
% --- Average_mel_P2, average size of the successive melodic intervals. Scalar
% --- Std_mel_P2, standard deviation of the successive melodic intervals. Scalar
% Pour pattern 1 :
% --- Position_2nd_key, position of the 2nd key note presentation. Vector 7 columns ; values : 1 --> 7
%      (statistique équivalente à Position_key_unambiguous pour cette échelle 3)
% --- Average_mel_P1, average size of the successive melodic intervals. Scalar
% --- Std_mel_P1, standard deviation of the successive melodic intervals. Scalar
% Et finalement :
% --- Corr_P1_P2, Spearman correlation between the melodic contours of P1 and P2. Scalar
%

Omissions = [4	12	0	6	10	8	2		7	2	6	10	0	12	4
2	6	0	12	10	8	4		0	2	12	5	8	10	6
12	4	6	10	8	2	0		1	6	12	0	10	4	8
2	8	4	6	0	12	10		4	8	6	1	10	0	12
2	12	6	0	8	10	4		12	1	10	0	8	4	6
0	10	12	2	6	4	8		1	10	4	6	12	0	8
8	10	6	2	4	0	12		2	12	0	5	10	6	8
4	8	0	2	12	6	10		12	8	0	4	10	3	6
8	12	0	4	10	6	2		2	6	0	4	7	12	10
12	8	2	10	4	6	0		6	2	12	8	4	0	11
0	6	4	8	10	12	2		3	0	12	10	8	6	2
4	0	12	6	8	2	10		5	4	0	2	12	8	10
8	0	10	12	2	6	4		6	10	4	2	0	7	12
4	10	8	0	2	12	6		12	6	8	2	10	3	0
10	4	6	2	8	0	12		10	0	12	8	3	2	6
12	2	10	6	4	0	8		3	12	2	0	8	6	10
2	10	8	12	6	4	0		12	10	4	0	7	2	6
2	12	0	6	10	8	4		10	12	5	2	0	8	6
10	12	6	4	2	0	8		1	4	0	12	6	10	8
10	2	6	8	4	12	0		2	10	6	12	9	4	0
0	2	6	8	4	12	10		3	12	8	10	6	2	0
6	10	8	2	12	4	0		8	10	4	6	0	12	3
4	6	12	2	10	8	0		0	5	10	6	12	8	2
2	8	0	6	12	4	10		8	1	0	6	4	12	10
4	10	2	12	0	6	8		3	10	0	4	6	8	12
6	4	12	2	8	0	10		12	4	8	2	11	0	6
4	0	8	2	12	6	10		12	3	8	10	6	0	4
12	2	8	10	4	6	0		12	2	8	6	0	4	9
0	4	6	10	12	8	2		2	12	8	4	6	11	0
0	4	10	6	12	8	2		5	0	2	8	12	4	10
12	8	6	4	10	0	2		8	5	12	0	10	2	4
4	12	8	0	6	2	10		0	6	10	12	2	4	9
2	4	12	10	8	6	0		5	2	8	0	10	12	6
12	8	4	10	6	2	0		11	4	2	6	8	0	12
6	4	2	12	8	0	10		9	4	0	6	2	12	8
2	10	8	6	12	4	0		8	2	6	4	0	9	12
2	4	0	10	8	12	6		10	5	12	8	0	2	4
10	8	6	12	2	0	4		10	12	6	4	2	0	9
10	4	12	0	6	8	2		2	6	4	7	0	12	10
2	0	4	10	6	12	8		2	0	12	8	6	3	10
12	2	8	4	6	10	0		5	12	10	0	8	2	4
8	12	2	6	4	10	0		0	7	10	2	4	12	6
0	8	2	4	6	12	10		10	5	12	6	0	2	8
6	2	0	10	4	12	8		2	8	0	11	6	4	12
10	12	8	2	0	4	6		2	8	0	5	10	4	12
2	6	4	12	10	0	8		3	12	10	0	6	8	4
12	10	4	2	0	8	6		0	8	2	11	6	4	12
6	10	0	8	12	2	4		11	0	2	4	8	6	12
2	0	10	4	6	8	12		8	6	10	3	12	2	0
0	4	2	10	12	8	6		2	0	10	5	12	8	6
4	12	6	8	10	0	2		6	4	12	3	10	0	8
2	10	0	6	12	8	4		12	6	0	10	2	8	3
8	2	4	6	10	0	12		4	6	8	12	2	0	9
10	6	12	2	4	0	8		12	3	0	6	10	8	4
10	0	12	2	8	6	4		10	2	0	4	9	12	6
2	10	0	12	4	8	6		9	6	12	8	4	2	0
2	0	6	4	10	8	12		5	2	10	12	0	8	6
12	8	6	4	2	0	10		11	2	6	12	4	8	0
12	4	6	0	2	10	8		0	6	2	4	10	12	7
4	10	12	0	6	8	2		0	12	8	2	6	11	4
12	2	10	4	0	8	6		12	4	6	8	0	2	11
10	12	0	8	4	2	6		1	6	10	8	12	0	4
2	6	10	4	8	12	0		5	12	10	6	2	0	8
12	10	0	4	8	6	2		3	10	0	6	12	2	8
8	0	10	2	4	6	12		11	2	6	12	8	0	4
12	10	4	0	8	6	2		3	6	10	8	2	12	0
2	0	4	8	6	12	10		3	0	8	4	6	10	12
8	0	6	2	12	4	10		10	1	4	12	0	6	8
4	8	6	2	12	10	0		12	0	6	4	8	10	3
4	2	6	12	0	10	8		7	0	10	2	4	12	8
12	2	8	6	4	10	0		3	6	4	0	8	12	10
4	8	0	6	2	10	12		4	12	2	6	8	0	11
0	2	8	12	4	6	10		10	0	2	4	12	8	5
10	6	0	4	12	8	2		7	12	0	10	6	2	4
4	2	10	12	0	6	8		4	10	2	0	5	12	8
12	4	8	0	6	10	2		12	0	4	8	10	6	1
2	10	0	12	8	6	4		6	8	12	2	9	4	0
12	4	10	2	8	0	6		1	10	12	4	8	6	0
0	12	6	8	4	2	10		4	7	0	2	12	8	10
8	6	2	12	0	4	10		8	4	10	2	7	0	12
0	2	6	4	12	8	10		12	3	10	2	0	6	8
6	4	8	2	12	10	0		4	10	12	2	5	0	8
8	4	6	2	0	10	12		0	12	8	10	5	2	6
10	0	4	6	2	8	12		0	2	4	6	10	12	9
0	10	6	12	2	8	4		0	11	4	8	6	2	12
0	4	10	2	8	6	12		0	12	2	8	6	11	4
12	10	6	8	2	4	0		4	0	10	8	2	12	7
8	10	6	2	0	4	12		3	0	10	2	8	6	12
6	10	8	4	12	0	2		9	6	12	0	8	2	4
0	4	8	6	2	12	10		0	11	8	4	2	6	12
4	2	12	8	0	6	10		8	10	6	3	0	12	2
8	10	12	6	4	0	2		12	2	8	0	6	4	11
8	10	2	0	12	6	4		9	6	4	12	2	8	0
4	6	2	0	8	12	10		5	8	2	12	6	0	10
0	2	10	12	6	4	8		8	0	11	2	12	6	4
4	6	12	2	8	0	10		7	12	0	10	4	6	2
2	8	10	4	0	12	6		5	0	12	4	8	10	2
8	12	2	0	4	6	10		0	2	6	8	12	10	3
0	6	4	2	8	10	12		2	10	5	0	4	8	12
10	6	2	8	4	12	0		3	8	6	0	10	2	12
0	12	2	6	10	4	8		9	2	6	12	0	10	4
2	0	8	4	6	12	10		2	7	12	4	10	8	0
12	4	2	6	10	8	0		1	4	6	8	10	12	0
10	6	8	12	4	2	0		10	2	0	5	12	6	8
0	10	8	6	2	12	4		4	2	12	0	8	6	9
6	4	2	10	12	8	0		4	0	12	8	2	6	11
12	0	4	10	6	8	2		5	6	2	8	10	12	0
4	12	2	0	8	6	10		7	0	10	12	2	4	8
6	8	2	0	10	12	4		6	8	0	11	4	12	2
4	6	8	2	10	12	0		12	4	0	6	9	2	10
8	0	2	6	4	12	10		2	8	0	10	6	3	12
10	4	12	8	6	2	0		2	4	8	12	5	0	10
0	4	10	8	12	6	2		11	6	2	12	8	0	4
6	0	2	8	10	4	12		3	12	4	0	10	6	8
4	6	8	0	2	12	10		3	6	12	10	2	0	8
4	0	2	12	6	10	8		6	4	8	10	0	12	3
12	0	4	2	8	6	10		2	8	0	6	10	3	12
0	8	6	4	10	12	2		0	8	6	11	2	12	4
8	10	2	6	4	12	0		0	12	8	6	4	1	10
4	10	2	12	6	0	8		2	10	8	0	4	12	5
8	10	12	4	0	2	6		3	6	10	12	4	0	8
8	2	12	6	10	0	4		1	4	10	6	0	12	8
6	4	10	0	12	2	8		10	8	2	6	0	12	5
4	10	8	2	0	12	6		5	10	0	8	12	6	2
4	10	12	6	0	2	8		1	12	8	0	6	10	4
6	10	12	4	8	2	0		8	6	2	0	12	3	10
8	6	4	10	0	12	2		10	6	8	5	2	12	0
10	0	12	2	4	8	6		8	12	2	0	10	6	3
10	2	0	6	12	8	4		11	4	2	0	8	12	6
12	6	0	8	2	4	10		12	6	10	8	0	5	2
12	2	8	6	4	10	0		3	10	8	2	6	12	0
0	4	12	10	2	6	8		12	10	4	2	0	5	8
10	4	12	0	6	8	2		0	12	6	10	2	8	5
0	2	8	6	12	4	10		8	4	6	1	12	10	0
2	10	4	0	6	12	8		5	10	2	6	0	8	12
2	8	6	12	10	4	0		9	4	2	12	0	6	8
0	12	6	2	8	4	10		7	12	2	10	4	0	8
4	10	8	0	6	12	2		7	0	6	4	10	2	12
2	10	8	6	12	0	4		0	10	6	2	8	12	5
6	8	4	10	0	2	12		3	10	6	0	8	2	12
10	4	8	6	12	2	0		6	12	2	8	0	10	3
2	6	10	4	8	12	0		0	12	10	4	8	2	7
8	0	12	10	4	2	6		2	11	0	4	12	6	8
2	0	12	10	4	6	8		4	9	0	12	2	10	6
6	4	10	2	12	0	8		7	2	12	10	4	6	0
0	10	6	2	8	4	12		12	1	6	4	8	10	0
8	10	0	6	12	2	4		12	1	8	0	10	6	4
10	0	4	6	2	12	8		10	12	3	0	6	2	8
0	4	6	8	10	12	2		11	4	0	8	2	12	6
10	6	4	2	8	0	12		1	4	8	0	12	6	10
12	6	4	8	2	10	0		9	2	12	4	0	10	6
2	6	10	8	0	12	4		9	0	12	4	10	2	6
0	10	12	2	8	4	6		8	6	12	2	4	9	0
8	6	10	0	2	12	4		9	0	12	2	8	6	4
12	10	2	4	0	6	8		3	10	12	6	0	2	8
2	8	4	0	12	10	6		12	0	8	6	4	2	9
4	2	12	10	8	0	6		7	4	0	12	6	2	10
8	10	0	2	4	12	6		0	11	6	12	2	4	8
10	6	8	2	4	12	0		10	2	8	0	12	4	7
12	4	8	10	6	0	2		10	4	2	6	0	12	7
0	2	6	10	8	12	4		0	2	8	4	11	6	12
8	6	10	4	2	0	12		0	12	4	6	8	3	10
8	2	10	12	0	4	6		10	6	8	0	4	12	3
8	6	10	12	0	2	4		12	6	2	0	7	4	10
2	0	10	6	8	4	12		6	4	0	9	12	2	10
8	2	0	4	12	10	6		2	10	12	7	4	6	0
0	4	12	2	8	6	10		12	9	4	8	2	6	0
0	4	6	8	10	2	12		7	12	2	10	0	4	8
2	4	10	0	12	8	6		5	10	12	4	2	8	0
0	8	10	6	2	12	4		7	10	2	12	8	0	4
4	6	10	8	12	0	2		7	0	2	10	6	12	4
10	12	2	8	4	0	6		4	0	8	11	2	12	6
4	2	0	10	6	12	8		4	2	9	6	0	10	12
8	2	4	12	0	6	10		8	6	4	0	10	12	3
10	6	8	12	0	4	2		9	2	10	12	4	6	0
8	6	2	0	12	10	4		3	6	2	10	8	12	0
2	8	6	10	12	0	4		8	12	4	0	6	1	10
2	8	12	0	6	4	10		0	8	10	4	12	2	7
8	2	12	10	4	6	0		2	6	12	5	10	8	0
0	10	4	12	8	6	2		9	4	12	6	0	2	10
6	10	4	0	8	12	2		6	8	0	12	4	9	2
12	6	0	8	10	2	4		1	6	10	4	0	12	8
0	12	6	8	2	10	4		5	2	8	6	12	10	0
4	10	8	6	2	0	12		12	3	6	0	2	10	8
6	4	10	2	0	8	12		1	4	6	10	0	12	8
2	4	0	12	8	6	10		2	6	0	11	12	8	4
2	8	10	6	12	4	0		7	10	0	6	12	2	4
4	0	6	2	8	10	12		2	0	5	6	12	10	8
2	4	12	10	6	0	8		7	4	10	12	2	0	8
12	8	2	0	6	4	10		4	7	12	2	0	10	6
2	8	6	0	4	12	10		6	0	3	10	12	8	2
0	6	2	10	8	12	4		11	2	6	0	8	4	12
6	2	0	8	12	10	4		7	0	12	10	4	6	2
10	8	2	12	4	0	6		6	0	12	9	2	8	4
12	2	4	10	8	6	0		2	8	5	0	12	10	6
4	2	12	10	8	0	6		8	1	0	12	4	10	6
12	8	10	6	0	2	4		0	7	4	10	2	12	6
4	8	0	2	6	12	10		7	12	4	0	2	8	10
12	6	8	4	10	0	2		2	4	10	5	12	0	8
6	8	12	2	4	0	10		8	0	6	12	10	2	5
10	0	12	8	4	2	6		4	0	9	6	12	2	10
12	10	8	2	4	0	6		7	0	6	4	10	12	2
2	12	4	0	8	10	6		0	12	3	10	8	4	6
10	8	0	4	2	6	12		6	8	12	0	2	10	5
4	10	12	0	8	6	2		7	10	0	2	6	4	12
0	12	4	6	8	2	10		10	12	0	6	4	7	2
0	12	6	8	2	10	4		9	0	12	10	6	4	2
8	10	4	12	6	2	0		10	3	12	4	0	6	8];

Nomissions = size(Omissions, 1)
%
Position_sour = zeros(1, 7);
Interv_sour = zeros(1, 6); Somme_Interv_sour = 0; 
Violation_type = zeros(1, 10);
Average_mel_P2 = 0;
Std_mel_P2 = 0;
Position_2nd_key = zeros(1, 7);
Average_mel_P1 = 0;
Std_mel_P1 = 0;
Corr_P1_P2 = 0;
%
for i = 1 : Nomissions
        % Position_sour
        for j = 8 : 14
             if Omissions(i, j)==1 || Omissions(i, j)==3 || Omissions(i, j)==5 || Omissions(i, j)==7 || ...
                Omissions(i, j)==9 || Omissions(i, j)==11
                    Position_sour(1, j-7) =  Position_sour(1, j-7) + 1;   
             end
        end
        %
        %
        %
        % Interv_sour
        for j = 9 : 14
                  rang = j;
                  if Omissions(i, j)==1 || Omissions(i, j)==3 || Omissions(i, j)==5 || Omissions(i, j)==7 || ...
                     Omissions(i, j)==9 || Omissions(i, j)==11
                         Somme_Interv_sour = Somme_Interv_sour + 1;
                         interv = abs(Omissions(i, rang) - Omissions(i, rang-1));
                         interval = ceil(interv/2); % rang de l'intervalle correspondant à interv
                         Interv_sour(1, interval) = Interv_sour(1, interval) + 1;
                         break
                  end               
        end
        %
        %
        %
        % Violation_type
        Somme_demitons = 0;  % initialisation  
        for j = 8 : 14
                  if Omissions(i, j)==1 
                         Violation_type(1, 1) = Violation_type(1, 1) + 1; % erreur 2 --> 1
                  elseif Omissions(i, j)==3
                         for k = 8 : 14
                                Somme_demitons = Somme_demitons + Omissions(i, k);
                         end
                         if Somme_demitons > 42 % 42 = 0+2+4+6+8+10+12
                                Violation_type(1, 2) = Violation_type(1, 2) + 1; % erreur 2 --> 3
                         else
                                Violation_type(1, 3) = Violation_type(1, 3) + 1; % erreur 4 --> 3
                         end
                  elseif Omissions(i, j)==5
                         for k = 8 : 14
                                Somme_demitons = Somme_demitons + Omissions(i, k);
                         end
                         if Somme_demitons > 42 % 42 = 0+2+4+6+8+10+12
                                Violation_type(1, 4) = Violation_type(1, 4) + 1; % erreur 4 --> 5
                         else
                                Violation_type(1, 5) = Violation_type(1, 5) + 1; % erreur 6 --> 5
                         end
                  elseif Omissions(i, j)==7
                         for k = 8 : 14
                                Somme_demitons = Somme_demitons + Omissions(i, k);
                         end
                         if Somme_demitons > 42 % 42 = 0+2+4+6+8+10+12
                                Violation_type(1, 6) = Violation_type(1, 6) + 1; % erreur 6 --> 7
                         else
                                Violation_type(1, 7) = Violation_type(1, 7) + 1; % erreur 8 --> 7
                         end
                  elseif Omissions(i, j)==9
                       for k = 8 : 14
                                Somme_demitons = Somme_demitons + Omissions(i, k);
                       end
                       if Somme_demitons > 42 % 42 = 0+2+4+6+8+10+12
                                Violation_type(1, 8) = Violation_type(1, 8) + 1; % erreur 8 --> 9
                       else
                                Violation_type(1, 9) = Violation_type(1, 9) + 1; % erreur 10 --> 9
                       end
                  elseif Omissions(i, j)==11
                       Violation_type(1, 10) = Violation_type(1, 10) + 1; % erreur 10 --> 11
                  end
        end
        %
        %
        %
        % Average_mel_P2
        mel = [ ];
        for j = 9 : 14
             mel = [mel abs(Omissions(i, j) - Omissions(i, j-1))];   
        end
        Average_mel_P2 = Average_mel_P2 + mean(mel); 
        %
        %
        %
        % Std_mel_P2
        Std_mel_P2 = Std_mel_P2 + std(mel); 
        %
        %
        %
        % Position_2nd_key
        for j = 1 : 6
            if (Omissions(i, j)==0) || (Omissions(i, j)==12) 
                  first_key = j;
                  break
            end
        end
        for j = first_key + 1 : 7
            if (Omissions(i, j)==0) || (Omissions(i, j)==12) 
                  Position_2nd_key(1, j) = Position_2nd_key(1, j) + 1;
                  break
            end
        end
        %
        %
        %
        % Average_mel_P1
        mel = [ ];
        for j = 2 : 7
             mel = [mel abs(Omissions(i, j) - Omissions(i, j-1))];   
        end
        Average_mel_P1 = Average_mel_P1 + mean(mel); 
        %
        %
        %
        % Std_mel_P1
        Std_mel_P1 = Std_mel_P1 + std(mel); 
        %
        %
        %        
        % Corr_P1_P2
        Omi = zeros(7, 2); % initialisation
        for j = 1 : 7
             Omi(j, 1) = Omissions(i, j);
             Omi(j, 2) = Omissions(i, j+7);
        end
        spear = corr(Omi, 'type', 'Spearman');
        rho = spear(1, 2);
        Corr_P1_P2 = Corr_P1_P2 + rho;      
end

Position_sour = Position_sour / Nomissions
Somme_Interv_sour  % somme des omissions de fausses notes qui n'étaient pas la 1ère note
Interv_sour
Interv_sour = Interv_sour / Somme_Interv_sour
Violation_type = Violation_type / Nomissions
Average_mel_P2 = Average_mel_P2 / Nomissions
Std_mel_P2 = Std_mel_P2 / Nomissions
Position_2nd_key = Position_2nd_key / Nomissions
Average_mel_P1 = Average_mel_P1 / Nomissions
Std_mel_P1 = Std_mel_P1 / Nomissions
Corr_P1_P2 = Corr_P1_P2 / Nomissions
