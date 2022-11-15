function sournote6(action,varargin)

% Même principe général que sournote4/sournote5, mais ...
% Les mélodies sont des patterns de 6 notes constitués d'un triplet grave et 
% d'un triplet plus aigu qui est toujours une transposition exacte du triplet grave.
% Les 6 notes sont ordonnées au hasard.
% Notes du triplet grave (T1) : 3 conditions : 0  t  6,   0  t  7,   0  t  8.
% Possibilités pour t : 1.5, 2.5, 3.5 ou 4.5.
% Triplet aigu (T2) : 3 conditions : T1+11, T1+12, T1+13.
% 5 conditions sélectionnées sur les 9 combinaisons possibles :
%                                                          0-t-7-13-(13+t)-20 [condition 4] 	
%   0-t-6-12-(12+t)-18 [condition 1]       0-t-7-12-(12+t)-19 [condition 3]       0-t-8-12-(12+t)-20 [condition 5] 
%			                                               0-t-7-11-(11+t )-18 [condition 2] 
% Posiibilités de changement pour t :
% 1.5 devient 2.5 ou vice versa ; 2.5 devient 3.5 ou vice versa ; 3.5 devient 4.5 ou vice versa.


persistent  poignee  moment  nom_sujet  essai  total_essais ... 
                rep_juste  rep  Hits  False_alarms  Misses  Correct_rejections ...
                condition  echelle  F_ref_min  F_ref_max ...
                pattern_1_demitons  pattern_2_demitons ...
                amp F_echan  F  duree_note  duree_ISI;  

if nargin==2 % 2 arguments dans la fonction sournote6
    poignee = varargin{1}; % poignee est le 1er (et le seul) des varargin suivant "action"
end
if nargin==0 % on exécute sournote6 tout court
    action = 'initialisations';
end


switch(lower(action))

   
    case 'initialisations',
    % fixe les paramètres, et puis lance l'interface graphique
    rng('shuffle'); % initialisation générateur nbs aléatoires  
    randperm(5)    % pour définir l'ordre des conditions dans la séance
    amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
    F_echan = 44100;
    F_ref_min = 250; % minimum de la fréquence minimum
    F_ref_max = 2 * F_ref_min; % maximum de la fréquence minimum
    duree_note = 0.2;
    duree_ISI = 0.1;
    nom_sujet = input('votre nom :  ','s');
    condition = 0; % initialisation 
    while (condition < 1) || (condition > 5)
          condition = input('condition [1 - 5] :  ');
    end
    total_essais = input('nombre d''essais (normalement 55) :  ');
    interface_sournote6;

       
    case 'calibration',
    t = 5; % le son va durer 5 secondes
    temps = (0:1/F_echan:t)'; 
    signal_sinus = amp * sin(2*pi*1000*temps);
    son_pur = audioplayer(signal_sinus, F_echan, 24); 
    playblocking(son_pur); % joue le son et attend sa fin avant de rendre la main  
    
     
    case 'debut_bloc_essais',
    essai = 0;
    Hits = 0;  False_alarms = 0;  Misses = 0;  Correct_rejections = 0; 
    moment = datestr(now, 'yyyy mm dd HH MM'); % année mois jour heure minute
    sournote6('synthese');
      
    
    case 'synthese',
    set (poignee.Bouton1,'Enable','Inactive');
    set (poignee.Bouton2,'Enable','Inactive');        
    essai = essai+1;
    F_ref = F_ref_min * (2^rand); 
    if rand < 0.5
       rep_juste = 1; % Normal
    else
       rep_juste = 2; % Anormal  
    end  
    %
    % 1er pattern (qui sera répété une fois, tel quel)
    t1 = ceil(4*rand) + 0.5;  % 1.5, 2.5, 3.5 ou 4.5
    if condition==1
          t2 = t1 + 12;
          echelle = [0  t1  6  12  t2  18];   
    elseif condition==2
          t2 = t1 + 11;
          echelle = [0  t1  7  11  t2  18];   
    elseif condition==3
          t2 = t1 + 12;
          echelle = [0  t1  7  12  t2  19];  
    elseif condition==4
          t2 = t1 + 13;
          echelle = [0  t1  7  13  t2  20]; 
    elseif condition==5
          t2 = t1 + 12;
          echelle = [0  t1  8  12  t2  20];         
    end
    pattern_1_demitons = [ ]; % c'est la succession des valeurs de la variable demitons  
    pattern_1 = [ ]; 
    ordrenotes_1 = randperm(6);
    for i = 1:6
          z = ordrenotes_1(1, i);
          demitons = echelle(1, z);
          pattern_1_demitons = [pattern_1_demitons demitons]; % concaténation couteuse (d'où le souligné), mais on s'en fout
          F = F_ref * 2 ^ (demitons/12);
          vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
          pattern_1 = [pattern_1 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end  
    %
    % 2ème pattern, qui sera présenté en 3ème position (le 1er pattern étant répété 1 fois)
    % et dans lequel l'ordre des notes sera différent  
    drapeau = 0;
    while drapeau==0
            ordrenotes_2 = randperm(6);
            for i = 1:6
                   if ordrenotes_2(i) ~= ordrenotes_1(i)
                          drapeau = 1;
                   end
            end
    end
    % on définit (mais sans forcément l'utiliser dans cet essai) une échelle 'echellediff' différente de 'echelle' ;
    % la différence consiste en un déplacement d'un demi-ton de t1 et t2, dans le même sens. 
    if t1==1.5
          t1 = 2.5;
    elseif t1==2.5
          if rand < 0.5
                 t1 = 1.5;
          else
                 t1 = 3.5;
          end
    elseif t1==3.5
          if rand < 0.5
                 t1 = 2.5;
          else
                 t1 = 4.5;
          end
    elseif t1==4.5
          t1 = 3.5;
    end
    %
    echellediff = echelle;  % initialisation
    echellediff(1, 2) = t1;
    if (condition==1) || (condition==3) || (condition==5)
          t2 = t1 + 12;
    elseif condition==2
          t2 = t1 + 11;
    elseif condition==4
          t2 = t1 + 13;
    end
    echellediff(1, 5) = t2;   
    if rep_juste == 1
        echelle_pattern_2 = echelle;
    else
        echelle_pattern_2 = echellediff;
    end
    % on a maintenant ce qu'il faut pour construire pattern_2
    pattern_2_demitons = [ ];
    pattern_2 = [ ];
    for i = 1:6
        z = ordrenotes_2(1, i);
        demitons = echelle_pattern_2(1, z);
        pattern_2_demitons = [pattern_2_demitons demitons]; % concaténation couteuse (d'où le souligné), mais on s'en fout
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_2 = [pattern_2 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end
    %
    amorce = [zeros(1, F_echan/5)]; % la durée de cette amorce silencieuse dépend en fait du temps de calcul de matlab
    silintermel = [zeros(1, F_echan)]; % 1 s de silence entre les mélodies successives
    silwindows = [zeros(1, F_echan/5)];
    chaine = [amorce   pattern_1   silintermel  pattern_1  silintermel  pattern_2  silwindows]'; % passage en colonnes
    musique = audioplayer(chaine, F_echan, 24);
    playblocking(musique); % joue le son et attend sa fin avant de rendre la main 
    pause(0.1);
    set (poignee.Bouton1,'Enable','On');
    set (poignee.Bouton2,'Enable','On');
   
    
    case 'reponse_1', % callback d'une pression sur la touche 1
    rep = 1;
    if rep_juste==1
        set(poignee.Bouton1, 'BackgroundColor', [0 1 0]); % vert
    else
        set(poignee.Bouton1, 'BackgroundColor', [1 0 0]); % rouge
    end
    pause(0.2); 
    set(poignee.Bouton1, 'BackgroundColor', [1 1 1]); % blanc
    drawnow;
    sournote6('traitement_reponse');      
     
      
    case 'reponse_2', % callback d'une pression sur la touche 2
    rep = 2;
    if rep_juste==2
        set(poignee.Bouton2, 'BackgroundColor', [0 1 0]); % vert
    else
        set(poignee.Bouton2, 'BackgroundColor', [1 0 0]); % rouge
    end
    pause(0.2); 
    set(poignee.Bouton2, 'BackgroundColor', [1 1 1]); % blanc
    drawnow;
    sournote6('traitement_reponse');      
               
    
    case 'traitement_reponse',
    if (total_essais~=55) || (total_essais==55 && essai > 5)
    % dans les blocs "normaux" (comprenant 55 essais), on ignore les 5 premiers essais
            if (rep_juste==1) && (rep==1)
                Correct_rejections = Correct_rejections + 1;
            elseif (rep_juste==1) && (rep==2)
                False_alarms = False_alarms + 1;
            elseif (rep_juste==2) && (rep==1)
                Misses = Misses + 1;
            elseif (rep_juste==2) && (rep==2)
                Hits = Hits + 1;
            end
    end
    if essai < total_essais
        action = 'synthese';
    else
        close ('gcbf'); % fait disparaitre la figure interface
        action = 'archivage';
        perf = 100 * (Correct_rejections + Hits) / total_essais;
        fprintf(1, 'Pourcentage de réponses correctes :\n');
        fprintf(1, '%6.2f;\n',perf);
    end
    sournote6(action);
    
    
    case 'archivage',
    fileID = fopen('Résultats_sournote6.txt','a'); % ouverture du fichier Résultats
    % le fichier est créé s'il n'existe pas encore
    % s'il existe déjà, le 'a' fait en sorte qu'on va écrire à la suite de ce qui existe déjà
    SOAms = round(1000 * (duree_note + duree_ISI));
    fprintf(fileID,'%s;%d;%d;%d;%d;%s;%d;%d;%d;%d;%d\n', ...
        nom_sujet, condition, SOAms, F_ref_min, F_ref_max, moment, ...
        total_essais, Hits, Correct_rejections, Misses, False_alarms); 
    fclose(fileID);
    
     
end % du switch initial



function [vecteur_note] = note(F_echan, amp, duree_note, duree_ISI, F) % fabrique une note suivie d'un ISI
nb_echan_son = round(F_echan * duree_note);
temps_son = 1:nb_echan_son;
duree_rampe = 0.02;
nb_echan_rampe = round(F_echan*duree_rampe);
temps_rampe = 1:nb_echan_rampe;
freq_rampe = 0.5/nb_echan_rampe; % 0.5 car les rampes ne font qu'un demi cycle de sinus
onset = (1 + sin(2*pi*freq_rampe*temps_rampe - (pi/2)))/2;
offset = (1 + sin(2*pi*freq_rampe*temps_rampe + (pi/2)))/2;
nb_echan_plateau = nb_echan_son - (2*nb_echan_rampe);
plateau = ones(1, nb_echan_plateau); 
enveloppe = [onset plateau offset];
vecteur_note_sans_ISI = amp * sin(2*pi*F*temps_son./F_echan + rand*2*pi) .* enveloppe;
nb_echan_ISI = round(F_echan * duree_ISI);
ISI = zeros(1, nb_echan_ISI);
vecteur_note = [vecteur_note_sans_ISI ISI];
