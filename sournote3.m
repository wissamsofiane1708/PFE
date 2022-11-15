function sournote3
% Etirement progressif de la gamme diatonique majeure
% Janvier 2021

rng('shuffle'); % initialisation générateur nbs aléatoires    
amp = 0.079; % va donner 65 dB SPL sur Dell M4700 avec Sennheiser HD 650 si slider windows à 26
F_echan = 44100;
F_ref = 523.25; % lowest frequency: C5
duree_note = 0.2;
duree_ISI = 0.1;
stretchpourcent = 16.6667/20; % pourcentage d'étirement des demi-tons d'une gamme à la suivante
stretchfinalpourcent = 16.6667; % pourcentage final d'étirement
Ncycles = round(stretchfinalpourcent / stretchpourcent); 
scale = [0 2 4 5 7 9 11 12];
sequence = [ ];
for i = 1:Ncycles
        for j =  1:8
            demitons = scale(1, j);
            F = F_ref * 2 ^ (demitons/12);
            vecteur_note = note(F_echan, amp, duree_note, duree_ISI, F);
            sequence = [sequence vecteur_note];  % concaténation couteuse mais on s'en fout
        end  
        scale = (1 + (stretchpourcent/100)) * scale;
end
silence_pour_windows = [zeros(1, F_echan/5)];
sequence = [sequence silence_pour_windows];
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
