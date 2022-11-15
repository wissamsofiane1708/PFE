% Calcul de statistiques sur la liste des omissions faites par un sujet dans sournote5 avec l'échelle 3
% Au début, on donne une matrice de 'Nomissions' lignes et 14 colonnes (pattern_1_demitons pattern_2_demitons).
% Output :
% Pour pattern 2 :
% --- Position_sour, temporal position of the sour note. Vector 7 columns ; values : 1 --> 7
% --- Interv_sour, melodic interval leading to the sour note. Vector 10 columns ; values : 
%      1.4, 3.4, 3.8, 5.8, 6.2, 8.2, 8.6, 10.6, 11, 13
% --- Violation_type. Vector 10 columns ; values : 
%       2.4-1.4, 2.4-3.4, 4.8-3-8, 4.8-5.8, 7.2-6.2, 7.2-8.2, 9.6-8.6, 9.6-10.6, 12-11, 12-13
% --- Average_mel_P2, average size of the successive melodic intervals. Scalar
% --- Std_mel_P2, standard deviation of the successive melodic intervals. Scalar
% Pour pattern 1 :
% --- Position_0_12, position of 0 if it comes after 12, or vice versa. Vector 7 columns ; values : 1 --> 7
% --- Average_mel_P1, average size of the successive melodic intervals. Scalar
% --- Std_mel_P1, standard deviation of the successive melodic intervals. Scalar
% Et finalement :
% --- Corr_P1_P2, Spearman correlation between the melodic contours of P1 and P2. Scalar
%

Omissions = [7.20	2.40	14.40	4.80	9.60	0.00	12.00		5.80	12.00	0.00	9.60	14.40	2.40	7.20
7.20	0.00	4.80	12.00	2.40	9.60	14.40		14.40	9.60	4.80	0.00	12.00	7.20	3.40
0.00	14.40	9.60	4.80	7.20	2.40	12.00		13.00	4.80	14.40	2.40	7.20	0.00	9.60
4.80	2.40	14.40	0.00	12.00	7.20	9.60		0.00	1.40	14.40	7.20	9.60	12.00	4.80
9.60	7.20	14.40	0.00	12.00	2.40	4.80		3.80	12.00	9.60	7.20	14.40	2.40	0.00
14.40	7.20	2.40	0.00	9.60	4.80	12.00		0.00	9.60	5.80	12.00	7.20	14.40	2.40
7.20	12.00	14.40	2.40	9.60	0.00	4.80		12.00	8.20	14.40	2.40	9.60	0.00	4.80
7.20	9.60	4.80	12.00	0.00	14.40	2.40		4.80	8.20	12.00	9.60	2.40	0.00	14.40
4.80	2.40	14.40	0.00	9.60	7.20	12.00		0.00	9.60	12.00	14.40	4.80	1.40	7.20
12.00	7.20	9.60	2.40	4.80	14.40	0.00		14.40	9.60	4.80	7.20	0.00	1.40	12.00
4.80	0.00	14.40	9.60	2.40	12.00	7.20		10.60	14.40	2.40	4.80	12.00	0.00	7.20
2.40	9.60	14.40	7.20	4.80	12.00	0.00		4.80	7.20	14.40	10.60	0.00	2.40	12.00
7.20	4.80	9.60	14.40	2.40	0.00	12.00		8.60	14.40	0.00	7.20	12.00	4.80	2.40
14.40	12.00	9.60	7.20	2.40	0.00	4.80		9.60	14.40	7.20	0.00	11.00	2.40	4.80
14.40	4.80	2.40	0.00	7.20	9.60	12.00		10.60	7.20	12.00	14.40	2.40	0.00	4.80
14.40	9.60	0.00	4.80	7.20	2.40	12.00		14.40	5.80	9.60	7.20	12.00	2.40	0.00
12.00	14.40	4.80	2.40	9.60	7.20	0.00		0.00	8.20	2.40	4.80	12.00	9.60	14.40
2.40	4.80	9.60	7.20	14.40	0.00	12.00		10.60	2.40	7.20	14.40	4.80	0.00	12.00
2.40	14.40	9.60	4.80	12.00	7.20	0.00		0.00	7.20	12.00	9.60	5.80	14.40	2.40
14.40	2.40	12.00	9.60	7.20	4.80	0.00		11.00	14.40	2.40	7.20	9.60	0.00	4.80
7.20	9.60	0.00	14.40	2.40	12.00	4.80		12.00	0.00	4.80	7.20	2.40	10.60	14.40
12.00	0.00	14.40	9.60	2.40	7.20	4.80		4.80	9.60	12.00	14.40	2.40	8.20	0.00
14.40	7.20	4.80	2.40	12.00	9.60	0.00		0.00	7.20	13.00	4.80	2.40	9.60	14.40
12.00	0.00	7.20	2.40	9.60	14.40	4.80		9.60	5.80	14.40	12.00	2.40	7.20	0.00
7.20	14.40	12.00	9.60	2.40	0.00	4.80		2.40	7.20	5.80	12.00	9.60	14.40	0.00
12.00	14.40	4.80	2.40	0.00	7.20	9.60		2.40	8.20	4.80	14.40	9.60	12.00	0.00
4.80	12.00	2.40	7.20	9.60	0.00	14.40		14.40	1.40	7.20	12.00	4.80	0.00	9.60
2.40	12.00	0.00	7.20	14.40	4.80	9.60		10.60	4.80	0.00	7.20	2.40	14.40	12.00
12.00	14.40	7.20	2.40	4.80	0.00	9.60		6.20	0.00	4.80	2.40	12.00	9.60	14.40
0.00	7.20	2.40	12.00	4.80	9.60	14.40		14.40	5.80	2.40	9.60	0.00	12.00	7.20
9.60	2.40	0.00	4.80	12.00	7.20	14.40		12.00	7.20	0.00	2.40	9.60	14.40	5.80
12.00	4.80	9.60	0.00	2.40	14.40	7.20		10.60	2.40	4.80	12.00	7.20	14.40	0.00
4.80	9.60	7.20	12.00	14.40	0.00	2.40		4.80	7.20	11.00	14.40	0.00	2.40	9.60
7.20	0.00	9.60	12.00	14.40	4.80	2.40		0.00	4.80	2.40	14.40	6.20	9.60	12.00
14.40	9.60	12.00	4.80	0.00	7.20	2.40		9.60	13.00	2.40	14.40	4.80	0.00	7.20
9.60	2.40	0.00	4.80	14.40	12.00	7.20		5.80	0.00	2.40	9.60	7.20	14.40	12.00
14.40	9.60	7.20	12.00	0.00	2.40	4.80		8.60	12.00	14.40	7.20	0.00	4.80	2.40
9.60	2.40	12.00	0.00	4.80	14.40	7.20		9.60	14.40	7.20	2.40	4.80	11.00	0.00
0.00	7.20	12.00	9.60	4.80	14.40	2.40		9.60	3.80	14.40	0.00	7.20	12.00	2.40
2.40	4.80	7.20	0.00	14.40	9.60	12.00		14.40	0.00	13.00	7.20	4.80	9.60	2.40
2.40	7.20	12.00	4.80	14.40	0.00	9.60		11.00	0.00	4.80	7.20	2.40	9.60	14.40
14.40	4.80	9.60	2.40	0.00	12.00	7.20		3.80	7.20	0.00	14.40	12.00	9.60	2.40
14.40	0.00	9.60	7.20	12.00	4.80	2.40		4.80	7.20	10.60	14.40	0.00	2.40	12.00
9.60	0.00	2.40	7.20	4.80	14.40	12.00		4.80	2.40	14.40	0.00	11.00	7.20	9.60
7.20	9.60	4.80	14.40	2.40	0.00	12.00		3.40	12.00	14.40	0.00	7.20	4.80	9.60
2.40	4.80	0.00	12.00	14.40	9.60	7.20		9.60	11.00	4.80	0.00	7.20	14.40	2.40
4.80	7.20	0.00	9.60	14.40	2.40	12.00		0.00	8.20	14.40	9.60	12.00	2.40	4.80
12.00	4.80	14.40	2.40	9.60	7.20	0.00		8.60	0.00	12.00	2.40	4.80	14.40	7.20
7.20	2.40	4.80	0.00	14.40	12.00	9.60		10.60	2.40	14.40	4.80	7.20	12.00	0.00
12.00	4.80	14.40	7.20	9.60	2.40	0.00		12.00	14.40	7.20	3.40	9.60	0.00	4.80
0.00	2.40	4.80	7.20	14.40	12.00	9.60		2.40	8.60	14.40	0.00	4.80	12.00	7.20
4.80	0.00	12.00	14.40	2.40	9.60	7.20		4.80	9.60	0.00	3.40	7.20	14.40	12.00
4.80	2.40	0.00	12.00	9.60	14.40	7.20		13.00	7.20	0.00	14.40	2.40	9.60	4.80
0.00	9.60	4.80	2.40	7.20	12.00	14.40		14.40	0.00	2.40	7.20	12.00	3.80	9.60
0.00	14.40	2.40	9.60	12.00	7.20	4.80		9.60	7.20	14.40	1.40	12.00	4.80	0.00
2.40	4.80	14.40	12.00	7.20	9.60	0.00		3.40	12.00	14.40	4.80	9.60	7.20	0.00
0.00	7.20	12.00	9.60	14.40	2.40	4.80		10.60	0.00	12.00	2.40	4.80	14.40	7.20
7.20	14.40	12.00	0.00	4.80	2.40	9.60		4.80	7.20	1.40	12.00	0.00	14.40	9.60
7.20	4.80	0.00	12.00	9.60	2.40	14.40		5.80	12.00	9.60	7.20	0.00	14.40	2.40
0.00	4.80	9.60	2.40	7.20	12.00	14.40		5.80	12.00	14.40	2.40	0.00	7.20	9.60
12.00	0.00	4.80	7.20	2.40	9.60	14.40		6.20	12.00	14.40	2.40	0.00	9.60	4.80
12.00	9.60	2.40	4.80	0.00	14.40	7.20		2.40	11.00	7.20	0.00	9.60	14.40	4.80
4.80	0.00	14.40	9.60	12.00	7.20	2.40		8.60	12.00	14.40	7.20	2.40	4.80	0.00
7.20	4.80	12.00	0.00	9.60	14.40	2.40		8.20	14.40	9.60	2.40	0.00	4.80	12.00
9.60	14.40	7.20	12.00	0.00	2.40	4.80		4.80	2.40	13.00	7.20	14.40	0.00	9.60
9.60	12.00	2.40	7.20	0.00	14.40	4.80		10.60	2.40	4.80	14.40	7.20	12.00	0.00
9.60	12.00	4.80	2.40	14.40	7.20	0.00		4.80	0.00	1.40	9.60	12.00	7.20	14.40
0.00	14.40	9.60	4.80	12.00	2.40	7.20		8.60	2.40	7.20	0.00	4.80	14.40	12.00
9.60	14.40	12.00	7.20	2.40	4.80	0.00		14.40	12.00	4.80	0.00	2.40	7.20	10.60
0.00	14.40	4.80	12.00	7.20	9.60	2.40		0.00	8.60	4.80	14.40	7.20	2.40	12.00
12.00	14.40	4.80	2.40	0.00	9.60	7.20		10.60	4.80	0.00	12.00	7.20	2.40	14.40
9.60	14.40	4.80	7.20	12.00	0.00	2.40		7.20	11.00	2.40	14.40	0.00	4.80	9.60
2.40	9.60	4.80	7.20	0.00	12.00	14.40		1.40	14.40	9.60	12.00	0.00	7.20	4.80
4.80	12.00	9.60	2.40	0.00	7.20	14.40		14.40	3.40	9.60	0.00	4.80	12.00	7.20
4.80	2.40	7.20	0.00	12.00	14.40	9.60		7.20	14.40	12.00	4.80	0.00	2.40	8.60
7.20	4.80	0.00	14.40	9.60	12.00	2.40		5.80	0.00	9.60	12.00	7.20	2.40	14.40
9.60	2.40	4.80	7.20	14.40	0.00	12.00		3.40	0.00	14.40	9.60	12.00	7.20	4.80
4.80	9.60	12.00	2.40	0.00	7.20	14.40		3.40	7.20	4.80	14.40	0.00	9.60	12.00
2.40	9.60	12.00	14.40	7.20	0.00	4.80		12.00	0.00	3.80	14.40	7.20	9.60	2.40
4.80	14.40	12.00	9.60	2.40	7.20	0.00		5.80	14.40	0.00	12.00	7.20	2.40	9.60
9.60	14.40	12.00	7.20	0.00	4.80	2.40		8.20	4.80	2.40	9.60	0.00	12.00	14.40
0.00	2.40	7.20	14.40	4.80	12.00	9.60		2.40	10.60	0.00	12.00	7.20	4.80	14.40
7.20	14.40	12.00	4.80	0.00	9.60	2.40		8.20	0.00	2.40	12.00	9.60	14.40	4.80
14.40	2.40	4.80	7.20	12.00	9.60	0.00		8.20	2.40	9.60	14.40	0.00	12.00	4.80];

Nomissions = size(Omissions, 1)
%
Position_sour = zeros(1, 7);
Interv_sour = zeros(1, 10); Somme_Interv_sour = 0; 
Violation_type = zeros(1, 10);
Average_mel_P2 = 0;
Std_mel_P2 = 0;
Position_0_12 = zeros(1, 7);
Average_mel_P1 = 0;
Std_mel_P1 = 0;
Corr_P1_P2 = 0;
%
for i = 1 : Nomissions
        % Position_sour
        for j = 8 : 14
             if round(10*Omissions(i, j))==14 || round(10*Omissions(i, j))==34 || round(10*Omissions(i, j))==38 || ...
                round(10*Omissions(i, j))==58 || round(10*Omissions(i, j))==62 || round(10*Omissions(i, j))==82 || ...
                round(10*Omissions(i, j))==86 || round(10*Omissions(i, j))==106 || round(10*Omissions(i, j))==110  || ...
                round(10*Omissions(i, j))==130                
                    Position_sour(1, j-7) =  Position_sour(1, j-7) + 1;  
                    break
             end
        end
        %
        %
        %
        % Interv_sour
        for j = 9 : 14
                  rang = j;
                  if round(10*Omissions(i, j))==14 || round(10*Omissions(i, j))==34 || round(10*Omissions(i, j))==38 || ...
                     round(10*Omissions(i, j))==58 || round(10*Omissions(i, j))==62 || round(10*Omissions(i, j))==82 || ...
                     round(10*Omissions(i, j))==86 || round(10*Omissions(i, j))==106 || round(10*Omissions(i, j))==110  || ...
                     round(10*Omissions(i, j))==130     
                         Somme_Interv_sour = Somme_Interv_sour + 1;
                         interv = abs(Omissions(i, rang) - Omissions(i, rang-1));
                         if round(10*interv)==14
                             Interv_sour(1, 1) = Interv_sour(1, 1) + 1;
                         elseif round(10*interv)==34
                             Interv_sour(1, 2) = Interv_sour(1, 2) + 1;
                         elseif round(10*interv)==38
                             Interv_sour(1, 3) = Interv_sour(1, 3) + 1;
                         elseif round(10*interv)==58
                             Interv_sour(1, 4) = Interv_sour(1, 4) + 1;
                         elseif round(10*interv)==62
                             Interv_sour(1, 5) = Interv_sour(1, 5) + 1;                          
                         elseif round(10*interv)==82
                             Interv_sour(1, 6) = Interv_sour(1, 6) + 1;                         
                         elseif round(10*interv)==86
                             Interv_sour(1, 7) = Interv_sour(1, 7) + 1; 
                         elseif round(10*interv)==106
                             Interv_sour(1, 8) = Interv_sour(1, 8) + 1;                           
                         elseif round(10*interv)==110
                             Interv_sour(1, 9) = Interv_sour(1, 9) + 1;                           
                         elseif round(10*interv)==130
                             Interv_sour(1, 10) = Interv_sour(1, 10) + 1;                       
                         end
                  end
        end
        %
        %
        %
        % Violation_type
        for j = 8 : 14
                  if round(10*Omissions(i, j))==14 
                         Violation_type(1, 1) = Violation_type(1, 1) + 1; % erreur 2.4 --> 1.4
                  elseif round(10*Omissions(i, j))==34
                         Violation_type(1, 2) = Violation_type(1, 2) + 1; % erreur 2.4 --> 3.4
                  elseif round(10*Omissions(i, j))==38
                         Violation_type(1, 3) = Violation_type(1, 3) + 1; % erreur 4.8 --> 3.8
                  elseif round(10*Omissions(i, j))==58
                         Violation_type(1, 4) = Violation_type(1, 4) + 1; % erreur 4.8 --> 5.8
                  elseif round(10*Omissions(i, j))==62
                         Violation_type(1, 5) = Violation_type(1, 5) + 1; % erreur 7.2 --> 6.2
                  elseif round(10*Omissions(i, j))==82
                         Violation_type(1, 6) = Violation_type(1, 6) + 1; % erreur 7.2 --> 8.2
                  elseif round(10*Omissions(i, j))==86
                         Violation_type(1, 7) = Violation_type(1, 7) + 1; % erreur 9.6 --> 8.6
                  elseif round(10*Omissions(i, j))==106
                         Violation_type(1, 8) = Violation_type(1, 8) + 1; % erreur 9.6 --> 10.6
                  elseif round(10*Omissions(i, j))==110
                         Violation_type(1, 9) = Violation_type(1, 9) + 1; % erreur 12 --> 11
                  elseif round(10*Omissions(i, j))==130
                         Violation_type(1, 10) = Violation_type(1, 10) + 1; % erreur 12 --> 13  
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
        % Position_0_12
        for j = 1 : 6
            if (Omissions(i, j)==0) || (Omissions(i, j)==12) 
                  first_note = j;
                  break
            end
        end
        for j = first_note + 1 : 7
            if (Omissions(i, j)==0) || (Omissions(i, j)==12) 
                  Position_0_12(1, j) = Position_0_12(1, j) + 1;
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
Position_0_12 = Position_0_12 / Nomissions
Average_mel_P1 = Average_mel_P1 / Nomissions
Std_mel_P1 = Std_mel_P1 / Nomissions
Corr_P1_P2 = Corr_P1_P2 / Nomissions
