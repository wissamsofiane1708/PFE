function sournote2(action,varargin)
% Identique à sournote1, sauf pour le fait que les échelles sont ici étirées, 
% d'un facteur défini par le paramètre 'stretch', normalement égal à 1.2.
% En conséquence, les anormalités à détecter sont des décalage d'un demi-ton étiré lui aussi.
% January 2021

persistent  poignee  nom_sujet  essai  total_essais ... 
                rep_juste  rep  Hits  False_alarms  Misses  Correct_rejections ...
                echelle Nnotes scale stretch ...
                amp F_echan  F_ref  F  duree_note  duree_ISI;  

if nargin==2 % 2 arguments dans la fonction sournote2
    poignee = varargin{1}; % poignee est le 1er (et le seul) des varargin suivant "action"
end
if nargin==0 % on exécute sournote2 tout court
    action = 'initialisations';
end


switch(lower(action))

   
    case 'initialisations',
    % fixe les paramètres, et puis lance l'interface graphique
    rng('shuffle'); % initialisation générateur nbs aléatoires    
    amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
    F_echan = 44100;
    F_ref = 523.25; % lowest frequency: C5
    duree_note = 0.2;
    duree_ISI = 0.1;
    nom_sujet = input('votre nom :  ','s');
    echelle = input('numéro de l''échelle :  ');
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
    total_essais = input('nombre d''essais :  ');
    interface_sournote2;

       
    case 'calibration',
    t = 5; % le son va durer 5 secondes
    temps = (0:1/F_echan:t)'; 
    signal_sinus = amp * sin(2*pi*1000*temps);
    son_pur = audioplayer(signal_sinus, F_echan, 24); 
    playblocking(son_pur); % joue le son et attend sa fin avant de rendre la main  
    
     
    case 'debut_bloc_essais',
    essai = 0;
    Hits = 0;  False_alarms = 0;  Misses = 0;  Correct_rejections = 0; 
    sournote2('synthese');
      
    
    case 'synthese',
    set (poignee.Bouton1,'Enable','Inactive');
    set (poignee.Bouton2,'Enable','Inactive');        
    essai = essai+1;
    if rand < 0.5
       rep_juste = 1; % Normal
    else
       rep_juste = 2; % Anormal  
    end  
    %
    % 1er pattern
    ordrenotes_1 = randperm(Nnotes);
    pattern_1 = [ ];
    for i = 1:Nnotes
        z = ordrenotes_1(1, i);
        demitons = scale(1, z);
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_1 = [pattern_1 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end
    %
    % 2ème pattern
    % Il faut que l'ordre des notes soit différent  
    % Voir script 'essai' pour vérification de la procédure
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
    % la différence consiste en un déplacement d'un demi-ton *étiré* d'une note prise au hasard,
    % en excluant les 2 notes extrêmes comme dans sournote1.
    drapeau = 0; 
    while drapeau ~= Nnotes
            notechange = 1 + ceil(rand * (Nnotes - 2));  % varie de 2 à Nnotes-1
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
    scalediff = scale;  % initialisation
    scalediff(notechange) = demitons_apres_changement;
    %
    if rep_juste == 1
        scale_pattern_2 = scale;
    else
        scale_pattern_2 = scalediff;
    end
    % on a maintenant ce qu'il faut pour construire pattern_2
    pattern_2 = [ ];
    for i = 1:Nnotes
        z = ordrenotes_2(1, i);
        demitons = scale_pattern_2(1, z);
        F = F_ref * 2 ^ (demitons/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        pattern_2 = [pattern_2 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
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
    sournote2('traitement_reponse');      
     
      
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
    sournote2('traitement_reponse');      
               
    
    case 'traitement_reponse',
    if (rep_juste==1) && (rep==1)
        Correct_rejections = Correct_rejections + 1;
    elseif (rep_juste==1) && (rep==2)
        False_alarms = False_alarms + 1;
    elseif (rep_juste==2) && (rep==1)
        Misses = Misses + 1;
    elseif (rep_juste==2) && (rep==2)
        Hits = Hits + 1;
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
    sournote2(action);
    
    
    case 'archivage',
    moment = datestr(now, 0); % 0 est un format qui donne à la fois la date et l'heure
    fichier_resultats = which('Résultats_sournote2.txt'); % donne le chemin du fichier Résultats_sournote2.txt
    fid = fopen(fichier_resultats,'a'); % le 'a' fait en sorte que les nouvelles données vont etre écrites à la suite des anciennes
    SOAms = round(1000 * (duree_note + duree_ISI));
    PourcentEtirement = round(100 *(stretch - 1));
    Frefround = round(F_ref);
    fprintf(fid,'%s;%d;%d;%d;%d;%s;%d;%d;%d;%d;%d\n', ...
        nom_sujet, echelle, PourcentEtirement, SOAms, Frefround, moment, total_essais, Hits, Correct_rejections, Misses, False_alarms); 
    st = fclose(fid);

   
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
