function sournote5(action,varargin)

% Identique � sournote2, sauf que : 
% 1) F_ref varie al�atoirement d'un essai � l'autre, comme dans sournote4 ;
% 2) les modifications de notes sont des d�placements de 1 demi-ton exact, comme dans sournote1 et sournote4, 
%      et non pas 1 demi-ton �tir�.
% 3) comme dans sournote4, on stocke dans un fichier .csv ce qui s'est pass� aux essais o� la r�ponse fut incorrecte
%     (ce n'�tait pas fait quand le programme a �t� ex�cut� sur LD en janvier et f�vrier 2021)
% Mars 2021

persistent  poignee  moment nom_sujet  essai  total_essais ... 
                rep_juste  rep  Hits  False_alarms  Misses  Correct_rejections ...
                echelle  Nnotes  scale  F_ref_min  F_ref_max  stretch ...
                pattern_1_demitons pattern_2_demitons fileID ...
                amp F_echan  F  duree_note  duree_ISI;  

if nargin==2 % 2 arguments dans la fonction sournote5
    poignee = varargin{1}; % poignee est le 1er (et le seul) des varargin suivant "action"
end
if nargin==0 % on ex�cute sournote5 tout court
    action = 'initialisations';
end


switch(lower(action))

   
    case 'initialisations',
    % fixe les param�tres, et puis lance l'interface graphique
    rng('shuffle'); % initialisation g�n�rateur nbs al�atoires    
    amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows � 26
    F_echan = 44100;
    F_ref_min = 370; % minimum de la fr�quence minimum : F#4
    F_ref_max = 2 * F_ref_min; % maximum de la fr�quence minimum   
    duree_note = 0.2;
    duree_ISI = 0.1;
    nom_sujet = inputdlg('votre nom :  ','s');   %%%%%%%%%%%%%%%%%%%%%% POUR COMPILATION
    nom_sujet = nom_sujet{1};
    echellebuff = inputdlg('num�ro de l''�chelle :  ');  %%%%%%%%%%%%%%%%%%% POUR COMPILATION
    echelle =  str2num(echellebuff{1});
    stretch = 1.2;
    if echelle==1
         scale = stretch * [0 2 5 7 9 12]; % pentatonique       
    elseif echelle==2
         scale = stretch * [0 2 4 5 7 9 11 12]; % diatonique, mode majeur
    elseif echelle==3
         scale = stretch * [0 2 4 6 8 10 12]; % tons entiers
    elseif echelle==4
         scale = stretch * [0 1 3 5 7 8 10 12]; % diatonique, mode de mi (phrygien)
    end
    Nnotes = size(scale, 2);
    total_essaisbuff = inputdlg('nombre d''essais :  '); %%%%%%%%%%%%%%%%%% POUR COMPILATION
    total_essais =  str2num(total_essaisbuff{1});
    interface_sournote5;

       
    case 'calibration',
    t = 5; % le son va durer 5 secondes
    temps = (0:1/F_echan:t)'; 
    signal_sinus = amp * sin(2*pi*1000*temps);
    son_pur = audioplayer(signal_sinus, F_echan, 24); 
    playblocking(son_pur); % joue le son et attend sa fin avant de rendre la main  
    
     
    case 'debut_bloc_essais',
    essai = 0;
    Hits = 0;  False_alarms = 0;  Misses = 0;  Correct_rejections = 0; 
    moment = datestr(now, 'yyyy mm dd HH MM'); % ann�e mois jour heure minute
    fileID = fopen('ErrorsXX_sournote5.csv','a'); % ouverture du fichier permettant l'analyse des erreurs
    % le fichier est cr�� s'il n'existe pas encore
    % s'il existe d�j�, le 'a' fait en sorte qu'on va �crire � la suite de ce qui existe d�j�
    fprintf(fileID,'%s;%d;%s\n', nom_sujet, echelle, moment);

    sournote5('synthese');
      
    
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
    % 1er pattern
    ordrenotes_1 = randperm(Nnotes);
    pattern_1_demitons = [ ]; % c'est la succession des valeurs de la variable demitons  
    pattern_1 = [ ];
    for i = 1:Nnotes
        z = ordrenotes_1(1, i);
        demitons = scale(1, z);
        pattern_1_demitons = [pattern_1_demitons demitons]; % concat�nation couteuse (d'o� le soulign�), mais on s'en fout
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_1 = [pattern_1 vecteur_note];  % concat�nation couteuse (d'o� le soulign�), mais on s'en fout
    end
    %
    % 2�me pattern
    % Il faut que l'ordre des notes soit diff�rent  
    % Voir script 'essai' pour v�rification de la proc�dure
    drapeau = 0;
    while drapeau==0
            ordrenotes_2 = randperm(Nnotes);
            for i = 1:Nnotes
                   if ordrenotes_2(i) ~= ordrenotes_1(i)
                          drapeau = 1;
                   end
            end
    end
    % On d�finit (mais sans forc�ment l'utiliser dans cet essai) une �chelle 'scalediff' diff�rente de 'scale' ;
    % la diff�rence consiste en un d�placement d'un demi-ton *exact* d'une note prise au hasard,
    % en excluant les 2 notes extr�mes comme d'habitude.
    %
    % D'abord, on fait comme si on d�placait d'un demi-ton *�tir�*, comme dans sournote2 ;
    % c'est n�cessaire pour que les possibilit�s de d�placement soient les m�mes que dans 
    % sournote1, sournote2, et sournote4.
    drapeau = 0; 
    while drapeau ~= Nnotes
            notechange = 1 + ceil(rand * (Nnotes - 2));  % varie de 2 � Nnotes-1
            demitons_avant_changement = scale(notechange);
            if rand < 0.5
                demitons_apres_changement = demitons_avant_changement - stretch;
            else
                demitons_apres_changement = demitons_avant_changement + stretch;
            end
            drapeau = 0;
            for i = 1:Nnotes    
                     if scale(i) ~= demitons_apres_changement
                           drapeau = drapeau + 1;
                     end                        
            end 
    end 
    % Ensuite on rectifie le d�placement : il devient �gal � un demi-ton *exact*.
    if demitons_apres_changement < demitons_avant_changement
          demitons_apres_changement = demitons_apres_changement + stretch - 1;
    else
          demitons_apres_changement = demitons_apres_changement - stretch + 1;       
    end        
    %
    scalediff = scale;  % initialisation
    scalediff(notechange) = demitons_apres_changement;
    %
    if rep_juste == 1
        scale_pattern_2 = scale;
    else
        scale_pattern_2 = scalediff;
    end
    % on a maintenant ce qu'il faut pour construire pattern_2
    pattern_2_demitons = [ ];
    pattern_2 = [ ];
    for i = 1:Nnotes
        z = ordrenotes_2(1, i);
        demitons = scale_pattern_2(1, z);
        pattern_2_demitons = [pattern_2_demitons demitons]; % concat�nation couteuse (d'o� le soulign�), mais on s'en fout
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_2 = [pattern_2 vecteur_note];  % concat�nation couteuse (d'o� le soulign�), mais on s'en fout
    end
    %
    amorce = [zeros(1, F_echan/5)]; % la dur�e de cette amorce silencieuse d�pend en fait du temps de calcul de matlab
    silence_intersequences = [zeros(1, F_echan)]; % 1 s de silence entre les deux s�quences
    silence_pour_windows = [zeros(1, F_echan/5)];
    deux_intervalles = [amorce  pattern_1  silence_intersequences  pattern_2  silence_pour_windows]'; % passage en colonnes
    musique = audioplayer(deux_intervalles, F_echan, 24);
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
    sournote5('traitement_reponse');      
     
      
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
    sournote5('traitement_reponse');      
               
    
    case 'traitement_reponse',
    if (rep_juste==1) && (rep==1)
        Correct_rejections = Correct_rejections + 1;
    elseif (rep_juste==1) && (rep==2)
        False_alarms = False_alarms + 1;
        fprintf(fileID,'%s;%d;%s;FA;P1', nom_sujet, echelle, moment);
        for i = 1:Nnotes
            fprintf(fileID,';%2.2f', pattern_1_demitons(i));
        end
        fprintf(fileID,';P2');
        for i = 1:Nnotes
            fprintf(fileID,';%2.2f', pattern_2_demitons(i));
        end
        fprintf(fileID,'\n');
    elseif (rep_juste==2) && (rep==1)
        Misses = Misses + 1;
        fprintf(fileID,'%s;%d;%s;OM;P1', nom_sujet, echelle, moment);
        for i = 1:Nnotes
            fprintf(fileID,';%2.2f', pattern_1_demitons(i));
        end
        fprintf(fileID,';P2');
        for i = 1:Nnotes
            fprintf(fileID,';%2.2f', pattern_2_demitons(i));
        end
        fprintf(fileID,'\n');
    elseif (rep_juste==2) && (rep==2)
        Hits = Hits + 1;
    end
    if essai < total_essais
        action = 'synthese';
    else
        close ('gcbf'); % fait disparaitre la figure interface
        fclose(fileID); % ferme le fichier des erreurs
        action = 'archivage';
        perf = 100 * (Correct_rejections + Hits) / total_essais;
        fprintf(1, 'Pourcentage de r�ponses correctes :\n');
        fprintf(1, '%6.2f;\n',perf);
    end
    sournote5(action);
    
    
    case 'archivage',
    fileID = fopen('ResultsXX_sournote5.txt','a');
    SOAms = round(1000 * (duree_note + duree_ISI));
    PourcentEtirement = round(100 *(stretch - 1));
    fprintf(fileID,'%s;%d;%d;%d;%d;%d;%s;%d;%d;%d;%d;%d\n', ...
        nom_sujet, echelle, PourcentEtirement, SOAms, F_ref_min, F_ref_max, moment, ...
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
