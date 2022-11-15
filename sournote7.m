function sournote7(action,varargin)

% Détection de changements dans des mélodies micro-tonales (empan : 4 demi-tons)
% Entre les 2 mélodies à comparer (C1, C2), vient une troisème mélodie (T) qui est
% une transposition de C1 à un intervalle intervtranspo égal à une quinte, une octave, ou d'autres intervalles.
% On mesure l'effet de intervtranspo sur la performance.
% Septembre 2021


persistent  poignee  moment  nom_sujet  essai  total_essais ... 
                rep_juste  rep  Hits  False_alarms  Misses  Correct_rejections ...
                intervtranspo  F_ref_min  F_ref_max ...
                amp F_echan  F  duree_note  duree_ISI;  

if nargin==2 % 2 arguments dans la fonction sournote7
    poignee = varargin{1}; % poignee est le 1er (et le seul) des varargin suivant "action"
end
if nargin==0 % on exécute sournote7 tout court
    action = 'initialisations';
end


switch(lower(action))

   
    case 'initialisations',
    % fixe les paramètres, et puis lance l'interface graphique
    rng('shuffle'); % initialisation générateur nbs aléatoires    
    amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
    F_echan = 44100;
    F_ref_min = 220; % minimum de la fréquence minimum
    F_ref_max = 2 * F_ref_min; % maximum de la fréquence minimum
    duree_note = 0.2;
    duree_ISI = 0.3;
    nom_sujet = input('votre nom :  ','s');
    intervtranspo = input('intervtranspo en demi-tons :  ');  
    total_essais = input('nombre d''essais :  ');
    interface_sournote7;

       
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
    sournote7('synthese');
      
    
    case 'synthese',
    set (poignee.Bouton1,'Enable','Inactive');
    set (poignee.Bouton2,'Enable','Inactive');        
    essai = essai+1;
    F_ref = F_ref_min * (2^rand); 
    if rand < 0.5
       rep_juste = 1; % Pareil
    else
       rep_juste = 2; % Différent  
    end  
    %
    % détermination des échelles de C1 et C2
    liste_echelles =  [0  1.0  2.0  4
                              0  1.0  2.5  4
                              0  1.5  2.0  4
                              0  1.5  2.5  4
                              0  1.5  3.0  4
                              0  2.0  2.5  4
                              0  2.0  3.0  4];
    alea_C1 = ceil(7 * rand);  % il y a 7 échelles possibles
    echelle_C1 = liste_echelles(alea_C1, :);
    if rep_juste==1
          echelle_C2 = echelle_C1;
    else
          alea_C2 = alea_C1;
          while alea_C2==alea_C1;
                      alea_C2 = ceil(7 * rand);
          end
          echelle_C2 = liste_echelles(alea_C2, :); 
    end
    %
    ordrenotes = randperm(4);  % l'ordre des notes est le même pour les 3 mélodies
    %
    % fabriquons la mélodie C1
    C1_demitons = [ ];
    C1 = [ ]; 
    for i = 1:4
          z = ordrenotes(1, i);
          demitons = echelle_C1(1, z);
          C1_demitons = [C1_demitons demitons];  % concaténation couteuse (d'où le souligné), mais on s'en fout
          F = F_ref * 2 ^ (demitons/12);
          vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
          C1 = [C1 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end   
    %
    % fabriquons la mélodie T
    T = [ ];
    for i = 1:4
          demitons = C1_demitons(1, i) + intervtranspo; 
          F = F_ref * 2 ^ (demitons/12);
          vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
          T = [T vecteur_note];  
    end    
    %
    % fabriquons la mélodie C2
    C2 = [ ]; 
    for i = 1:4
          z = ordrenotes(1, i);
          demitons = echelle_C2(1, z);     
          F = F_ref * 2 ^ (demitons/12);
          vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
          C2 = [C2 vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
    end  
    %
    %
    amorce = [zeros(1, F_echan/5)]; % la durée de cette amorce silencieuse dépend en fait du temps de calcul de matlab
    silintermel = [zeros(1, F_echan)]; % 1 s de silence entre les mélodies successives
    silwindows = [zeros(1, F_echan/5)];
    chaine = [amorce   C1   silintermel  T  silintermel  C2  silwindows]'; % passage en colonnes
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
    sournote7('traitement_reponse');      
     
      
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
    sournote7('traitement_reponse');      
               
    
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
    sournote7(action);
    
    
    case 'archivage',
    fileID = fopen('Résultats_sournote7.txt','a'); % ouverture du fichier Résultats
    % le fichier est créé s'il n'existe pas encore
    % s'il existe déjà, le 'a' fait en sorte qu'on va écrire à la suite de ce qui existe déjà
    SOAms = round(1000 * (duree_note + duree_ISI));
    fprintf(fileID,'%s;%d;%d;%d;%d;%s;%d;%d;%d;%d;%d\n', ...
        nom_sujet, intervtranspo, SOAms, F_ref_min, F_ref_max, moment, ...
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
