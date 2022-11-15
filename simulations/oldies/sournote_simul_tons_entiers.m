% Simulation d'un bloc d'essais sournote1 ou sournote4 avec échelle tons entiers
% L'auditeur est idéal : il connait parfaitement l'échelle et les fausses notes possibles.
% Les erreurs de l'auditeur proviennent entièrement d'un bruit gaussien (écart-type sigma, en demi-tons) 
% dans son encodage des notes présentées (les deux notes extrêmes étant encodées parfaitement).
% Ce programme reproduit fidèlement la logique de sournote_simul_diatonique.m.
% Mars 2021 

% Résultats avec total_essais==2000,000
% Nota Nene : on obtient des critères très laxistes, cela s'explique facilement
% 1) exposant==2
% sigma==0.50    d'==0.78    critère (c)==-1.43    
% sigma==0.30    d'==2.12    critère (c)==-0.79
% 2) exposant==1
% sigma==0.50    d'==0.78    critère (c)==-1.44    
% sigma==0.30    d'==2.12    critère (c)==-0.79


rng('shuffle'); % initialisation générateur nbs aléatoires    
D = [0 2 4 6 8 10 12]; % échelle tons entiers
Nnotes = size(D, 2);
% Liste des échelles avec une fausse note comme dans sournote4
E1 = [0 1 4 6 8 10 12];
E2 = [0 3 4 6 8 10 12]; 
E3 = [0 2 3 6 8 10 12]; 
E4 = [0 2 5 6 8 10 12]; 
E5 = [0 2 4 5 8 10 12]; 
E6 = [0 2 4 7 8 10 12]; 
E7 = [0 2 4 6 7 10 12]; 
E8 = [0 2 4 6 9 10 12]; 
E9 = [0 2 4 6 8 9 12]; 
E10 = [0 2 4 6 8 11 12]; 
exposant = input('différences entre notes théoriques et entendues mises au carré (2) ou non (1) :  ');
sigma = input('écart-type du bruit gaussien :  ');
total_essais = input('nombre d''essais :  ');
Hits = 0;  False_alarms = 0;  Misses = 0;  Correct_rejections = 0; 
%
%
%
for essai = 1:total_essais
    %
    %
    %
    % On définit une échelle E (scalediff) différente de D (scale), exactement de la même façon que dans sournote4 
    % (Dans le cas de la gamme tons entiers, cette procédure est inutilement complexe)
    drapeau = 0; 
    while drapeau ~= Nnotes
            notechange = 1 + ceil(rand * (Nnotes - 2));  % varie de 2 à Nnotes-1
            demitons_avant_changement = D(notechange);
            if rand < 0.5
                demitons_apres_changement = demitons_avant_changement - 1;
            else
                demitons_apres_changement = demitons_avant_changement + 1;
            end
            drapeau = 0;
            for i = 1:Nnotes    
                     if D(i) ~= demitons_apres_changement
                           drapeau = drapeau + 1;
                     end                        
            end 
    end    
    E = D;  % initialisation
    E(notechange) = demitons_apres_changement; 
    %
    %
    %
    % On définit la bonne réponse et les notes entendues lors de l'essai
    if rand < 0.5
        S = D; % S est l'échelle utilisée dans l'essai; 
        repjuste = 1; % la bonne réponse est Normal
    else
        S = E; 
        repjuste = 2; % la bonne réponse est Anormal
    end
    % On corrompt les notes non-extrêmes de S avec du bruit gaussien, indépendant pour chaque note
    T = S; % initialisation; T est l'ensemble des notes entendues
    for i = 2 : Nnotes-1
        T(i) = S(i) + sigma*randn;
    end
    %
    %
    %
    % On compare T à D ainsi qu'à E1, E2, ... E10.
    % Si D est l'échelle qui ressemble le plus à T, on répond Normal (S==D), sinon on répond Anormal
    TD=0; TE1=0; TE2=0; TE3=0; TE4=0; TE5=0; TE6=0; TE7=0; TE8=0; TE9=0; TE10=0; % initialisations
    for i = 2 : Nnotes-1
        TD = TD + abs(T(i) - D(i)) ^ exposant;
        TE1 = TE1 + abs(T(i) - E1(i)) ^ exposant;
        TE2 = TE2 + abs(T(i) - E2(i)) ^ exposant;
        TE3 = TE3 + abs(T(i) - E3(i)) ^ exposant;
        TE4 = TE4 + abs(T(i) - E4(i)) ^ exposant;
        TE5 = TE5 + abs(T(i) - E5(i)) ^ exposant;
        TE6 = TE6 + abs(T(i) - E6(i)) ^ exposant;
        TE7 = TE7 + abs(T(i) - E7(i)) ^ exposant;
        TE8 = TE8 + abs(T(i) - E8(i)) ^ exposant;
        TE9 = TE9 + abs(T(i) - E9(i)) ^ exposant;
        TE10 = TE10 + abs(T(i) - E10(i)) ^ exposant;
        
    end
    TEmin = min([TE1, TE2, TE3, TE4, TE5, TE6, TE7, TE8, TE9, TE10]);
    if (repjuste==1) && (TD < TEmin)
        Correct_rejections = Correct_rejections + 1;
    elseif (repjuste==1) && (TEmin < TD)
        False_alarms = False_alarms + 1;    
    elseif (repjuste==2) && (TEmin < TD)
        Hits = Hits + 1;    
    elseif (repjuste==2) && (TD < TEmin)
        Misses = Misses + 1;    
    end
end
%
%
%
Resultats = [Hits   Correct_rejections   Misses   False_alarms] 

