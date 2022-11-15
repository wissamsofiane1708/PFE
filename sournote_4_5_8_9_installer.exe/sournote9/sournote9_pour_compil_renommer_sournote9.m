function sournote9(action,varargin)

% Identique à sournote8, sauf que chaque bloc de N essais inclut, pour la 1ère des 2 mélodies,
% N/2 essais avec l'échelle 1 et N/2 essais avec l'échelle 2.
% Ces deux ensembles de N/2 essais sont intriqués au hasard. 
% Juillet 2022

persistent  poignee  moment nom_sujet  condition  essai  total_essais ... 
                rep_juste  rep  Hits  False_alarms  Misses  Correct_rejections ...
                echelle  tableauessais  Nnotes  F_ref_min  ...
                pattern_1_demitons pattern_2_demitons fileID ...
                amp F_echan  F  duree_note  duree_ISI;  

if nargin==2 % 2 arguments dans la fonction sournote9
    poignee = varargin{1}; % poignee est le 1er (et le seul) des varargin suivant "action"
end
if nargin==0 % on exécute sournote9 tout court
    action = 'initialisations';
end


switch(lower(action))

   
    case 'initialisations',
    % fixe les paramètres, et puis lance l'interface graphique
    rng('shuffle'); % initialisation générateur nbs aléatoires    
    amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
    F_echan = 44100;
    F_ref_min = 370; % minimum de la fréquence minimum : F#4
    duree_note = 0.2;
    duree_ISI = 0.1;
    nom_sujet = inputdlg('votre nom :  ','s');  %%%%%%%%%%%%%%%%%%%%%%%% POUR COMPILATION
    nom_sujet = nom_sujet{1};
    conditionbuff = inputdlg('Prelim (0) ou Exper (1) :  ');  %%%%%%%%%%%%%%%%%%%%%%%% POUR COMPILATION
    condition = str2num(conditionbuff{1});
    if condition==0
        Nnotes = 5;  % échelle 0 de sournote8
    else
        Nnotes = 8;  % échelle 1 ou 2 (Phrygien ou Locrien)
    end
    total_essaisbuff = inputdlg('nombre d''essais :  ');  %%%%%%%%%%%%%%%%%%%%%%%% POUR COMPILATION
    total_essais = str2num(total_essaisbuff{1});
    interface_sournote9;

       
    case 'calibration',
    t = 5; % le son va durer 5 secondes
    temps = (0:1/F_echan:t)'; 
    signal_sinus = amp * sin(2*pi*1000*temps);
    son_pur = audioplayer(signal_sinus, F_echan, 24); 
    playblocking(son_pur); % joue le son et attend sa fin avant de rendre la main  
    
     
    case 'debut_bloc_essais',
    essai = 0;
    Hits = zeros(1, 2);  False_alarms = zeros(1, 2);  Misses = zeros(1, 2);  Correct_rejections = zeros(1, 2);  % 2 colonnes car 2 échelles
    % (2 fois l'échelle 0 dans la condition 0)
    %
    % Construction d'un tableau qui va donner l'échelle utilisée à chaque essai
    if condition==0
        echelles = [0 0];  % seulement l'échelle 0
    else
        echelles = [1 2];  % Phrygien ou Locrien
    end
    echellesrepet = repmat(echelles, 1, total_essais/2);
    aleaperm = randperm(total_essais);
    tableauessais = zeros(1, total_essais); % initialisation
    for i = 1:total_essais
        z = aleaperm(1, i);
        tableauessais(1, i) = echellesrepet(1, z);
    end
    %
    moment = datestr(now, 'yyyy mm dd HH MM'); % année mois jour heure minute
    fileID = fopen('ErrorsXX_sournote9.csv','a'); % ouverture du fichier permettant l'analyse des erreurs
    % le fichier est créé s'il n'existe pas encore
    % s'il existe déjà, le 'a' fait en sorte qu'on va écrire à la suite de ce qui existe déjà
    fprintf(fileID,'%s;%d;%s\n', nom_sujet, condition, moment);
    sournote9('synthese');
      
    
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
    if tableauessais(1, essai)==0
        echelle = 0;
        scale = [0 3 5 8 12];
    elseif tableauessais(1, essai)==1
        echelle = 1;
        scale = [0 1 3 5 7 8 10 12];  % Phrygien
    elseif tableauessais(1, essai)==2
        echelle = 2;
        scale = [0 1 3 5 6 8 10 12];  % Locrien
    end
    ordrenotes_1 = randperm(Nnotes);
    pattern_1_demitons = [ ]; % c'est la succession des valeurs de la variable demitons  
    pattern_1 = [ ];
    for i = 1:Nnotes
        z = ordrenotes_1(1, i);
        demitons = scale(1, z);
        pattern_1_demitons = [pattern_1_demitons demitons]; % concaténation couteuse (d'où le souligné), mais on s'en fout
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_1 = [pattern_1 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end
    %
    % 2ème pattern
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
    % On définit (mais sans forcément l'utiliser dans cet essai) une échelle 'scalediff' différente de 'scale' ;
    % La différence consiste en un déplacement d'un demi-ton d'une note prise au hasard parmi 3 possibilités.
    % Pour les échelles 1 et 2, on exclut les 3 notes les plus basses (0, 1, 3) et les 2 notes les plus hautes (10, 12) ;
    % restent les 3 notes intermédiaires : 5, 7 et 8 pour phrygien, 5, 6 et 8 pour locrien ; il y a 4 déplacements possibles.
    % Pour l'échelle 0 (familiarisation), on exclut les 2 notes extrêmes (0 et 12) et on se limite à 4 déplacements possibles.
    chance = ceil(4*rand);
    if echelle==0
        if chance==1
            scalediff = [0 2 5 8 12]; % 3 devient 2
        elseif chance==2
            scalediff = [0 4 5 8 12]; % 3 devient 4
        elseif chance==3
            scalediff = [0 3 4 8 12]; % 5 devient 4 
        elseif chance==4
            scalediff = [0 3 5 9 12]; % 8 devient 9         s
        end
    elseif echelle==1
        if chance==1
            scalediff = [0 1 3 4 7 8 10 12]; % 5 devient 4
        elseif chance==2
            scalediff = [0 1 3 6 7 8 10 12]; % 5 devient 6
        elseif chance==3
            scalediff = [0 1 3 5 6 8 10 12]; % 7 devient 6 ; on obtient le locrien normal
        elseif chance==4
            scalediff = [0 1 3 5 7 9 10 12]; % 8 devient 9          
        end
    elseif echelle==2
        if chance==1
            scalediff = [0 1 3 4 6 8 10 12]; % 5 devient 4
        elseif chance==2
            scalediff = [0 1 3 5 7 8 10 12]; % 6 devient 7 ; on obtient le phrygien normal
        elseif chance==3
            scalediff = [0 1 3 5 6 7 10 12]; % 8 devient 7
        elseif chance==4
            scalediff = [0 1 3 5 6 9 10 12]; % 8 devient 9          
        end   
    end
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
        pattern_2_demitons = [pattern_2_demitons demitons]; % concaténation couteuse (d'où le souligné), mais on s'en fout
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_2 = [pattern_2 vecteur_note]; % concaténation couteuse (d'où le souligné), mais on s'en fout
    end
    %
    amorce = [zeros(1, F_echan/5)]; % la durée de cette amorce silencieuse dépend en fait du temps de calcul de matlab
    silence_intersequences = [zeros(1, F_echan)]; % 1 s de silence entre les deux séquences
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
    sournote9('traitement_reponse');      
     
      
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
    sournote9('traitement_reponse');      
               
    
    case 'traitement_reponse',
    if (rep_juste==1) && (rep==1)
            if echelle==0
                Correct_rejections(1, 1) = Correct_rejections(1, 1) + 1;
                Correct_rejections(1, 2) = Correct_rejections(1, 2) + 1;
            elseif echelle==1
                Correct_rejections(1, 1) = Correct_rejections(1, 1) + 1;  
            elseif echelle==2
                Correct_rejections(1, 2) = Correct_rejections(1, 2) + 1;  
            end
    elseif (rep_juste==1) && (rep==2)
            if echelle==0
                False_alarms(1, 1) = False_alarms(1, 1) + 1;
                False_alarms(1, 2) = False_alarms(1, 2) + 1;
            elseif echelle==1
                False_alarms(1, 1) = False_alarms(1, 1) + 1;  
            elseif echelle==2
                False_alarms(1, 2) = False_alarms(1, 2) + 1;  
            end
            fprintf(fileID,'%s;%d;%s;FA;P1', nom_sujet, echelle, moment);
            for i = 1:Nnotes
                   fprintf(fileID,';%d', pattern_1_demitons(i));
            end
            fprintf(fileID,';P2');
            for i = 1:Nnotes
                   fprintf(fileID,';%d', pattern_2_demitons(i));
            end
            fprintf(fileID,'\n');
    elseif (rep_juste==2) && (rep==1)
            if echelle==0
                Misses(1, 1) = Misses(1, 1) + 1;
                Misses(1, 2) = Misses(1, 2) + 1;
            elseif echelle==1
                Misses(1, 1) = Misses(1, 1) + 1;  
            elseif echelle==2
                Misses(1, 2) = Misses(1, 2) + 1;  
            end
            fprintf(fileID,'%s;%d;%s;OM;P1', nom_sujet, echelle, moment);
            for i = 1:Nnotes
                   fprintf(fileID,';%d', pattern_1_demitons(i));
            end
            fprintf(fileID,';P2');
            for i = 1:Nnotes
                   fprintf(fileID,';%d', pattern_2_demitons(i));
            end
            fprintf(fileID,'\n');
    elseif (rep_juste==2) && (rep==2)
            if echelle==0
                Hits(1, 1) = Hits(1, 1) + 1;
                Hits(1, 2) = Hits(1, 2) + 1;
            elseif echelle==1
                Hits(1, 1) = Hits(1, 1) + 1;  
            elseif echelle==2
                Hits(1, 2) = Hits(1, 2) + 1;  
            end
    end
    if essai < total_essais
        action = 'synthese';
    else
        close ('gcbf'); % fait disparaitre la figure interface
        fclose(fileID); % ferme le fichier des erreurs
        action = 'archivage';
    end
    sournote9(action);
    
    
    case 'archivage',
    fileID = fopen('ResultsXX_sournote9.txt','a');
    if condition==0
            total_correct = Hits(1, 1) + Correct_rejections(1, 1); 
    else
            total_correct = Hits(1, 1) + Correct_rejections(1, 1) + Hits(1, 2) + Correct_rejections(1, 2); 
    end
    fprintf(fileID,'%s;%d;%s;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d\n', ...
        nom_sujet, condition, moment, total_essais, total_correct, ...
        Hits(1, 1), Correct_rejections(1, 1), Misses(1, 1), False_alarms(1, 1), ...
        Hits(1, 2), Correct_rejections(1, 2), Misses(1, 2), False_alarms(1, 2)); 
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
