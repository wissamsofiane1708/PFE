function demo_scale

% Fabrique en wav une gamme ascendante puis descendante à partir d'une
% échelle choisie dans l'ensemble des échelles de Sournote

echelle = input('echelle : 1=Maj_N, 2=WT_N, 3=Maj_S, 4=WT_S, 5=Phrygien, 6=Locrien    ');
 if echelle==1
        scale = [0  2  4  5  7  9  11  12]; % Major_N
 elseif echelle==2
        scale = [0  2  4  6  8  10  12]; % Whole-tone_N
 elseif echelle==3
        scale = [0  2.4  4.8  6.0  8.4  10.8  13.2  14.4]; % Major_S  
 elseif echelle==4
        scale = [0  2.4  4.8  7.2  9.6  12.0  14.4]; % Whole-tone_S         
 elseif echelle==5
        scale = [0  1  3  5  7  8  10  12]; % Phrygien
 elseif echelle==6
        scale = [0  1  3  5  6  8  10  12]; % Locrien        
 end
 %
 Nnotes = size(scale, 2);
 amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
 F_echan = 44100;
 F_ref = 523.26; % C4
 duree_note = 0.2;
 duree_ISI = 0.1;
%
gamme = [ ];
 for i = 1 : Nnotes
        F = F_ref * 2 ^ (scale(1, i)/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        gamme = [gamme vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
 end
 for i = Nnotes : -1 : 1
        F = F_ref * 2 ^ (scale(1, i)/12);
        vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
        gamme = [gamme vecteur_note];  % concaténation couteuse (d'où le souligné), mais on s'en fout
 end

%
blanc = [zeros(1, F_echan/5)]; % 200 ms
sequence = [blanc gamme blanc]'; % passage en colonnes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  wavwrite(sequence, 44100, 'Locrien');

musique = audioplayer(sequence, F_echan, 24);
playblocking(musique); % joue le son et attend sa fin avant de rendre la main 
 

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
