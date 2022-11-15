% Calcul de statistiques sur une liste aléatoire d'omissions pour l'échelle 3 (tons entiers) de sournote4
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

% Construction de la matrice Omissions
rng('shuffle');
Nomissions = 200000;  
scale = [0 2 4 6 8 10 12]; 
Nnotes = size(scale, 2);
Omissions = zeros(Nomissions, 2*Nnotes); % initialisation
for essai = 1 : Nomissions
       % pattern_1
       ordrenotes_1 = randperm(Nnotes);
       pattern_1_demitons = [ ]; % c'est la succession des valeurs de la variable demitons  
       for i = 1 : Nnotes
              z = ordrenotes_1(1, i);
              demitons = scale(1, z);
              pattern_1_demitons = [pattern_1_demitons demitons]; 
       end
       Omissions(essai, 1 : Nnotes) = pattern_1_demitons;
       % pattern_2
       % Il faut que l'ordre des notes soit différent  
       drapeau = 0;
       while drapeau==0
            ordrenotes_2 = randperm(Nnotes);
            for i = 1:Nnotes
                   if ordrenotes_2(i) ~= ordrenotes_1(i)
                          drapeau = 1;
                   end
            end
       end
       % On définit une échelle 'scalediff' différente de 'scale' ;
       % la différence consiste en un déplacement d'un demi-ton d'une note prise au hasard,
       % en excluant les 2 notes extrêmes, qui forment une octave.
       drapeau = 0; 
       while drapeau ~= Nnotes
               notechange = 1 + ceil(rand * (Nnotes - 2));  % varie de 2 à Nnotes-1
               demitons_avant_changement = scale(notechange);
               if rand < 0.5
                   demitons_apres_changement = demitons_avant_changement - 1;
               else
                   demitons_apres_changement = demitons_avant_changement + 1;
               end
               drapeau = 0;
               for i = 1:Nnotes    
                        if scale(i) ~= demitons_apres_changement
                              drapeau = drapeau + 1;
                        end                        
               end 
       end 
       scalediff = scale;  % initialisation
       scalediff(notechange) = demitons_apres_changement;
       pattern_2_demitons = [ ];
       for i = 1:Nnotes
              z = ordrenotes_2(1, i);
              demitons = scalediff(1, z);
              pattern_2_demitons = [pattern_2_demitons demitons]; 
       end
       Omissions(essai, Nnotes+1 : 2*Nnotes) = pattern_2_demitons;   
end
%
%
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
Interv_sour = Interv_sour / Somme_Interv_sour
Violation_type = Violation_type / Nomissions
Average_mel_P2 = Average_mel_P2 / Nomissions
Std_mel_P2 = Std_mel_P2 / Nomissions
Position_2nd_key = Position_2nd_key / Nomissions
Average_mel_P1 = Average_mel_P1 / Nomissions
Std_mel_P1 = Std_mel_P1 / Nomissions
Corr_P1_P2 = Corr_P1_P2 / Nomissions
