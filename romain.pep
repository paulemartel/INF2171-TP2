; INF 2171 - Travail Pratique 2
; Mars 2020 Trismestre d'hiver
; Par Paule Martel (MARP16569700)
; courriel : gh191039@ens.uqam.ca
;
; Description du programme:
; Ce programme fait la convertion d'un nombre entré par l'utilisateur
; allant de 1 à 3999 et imprime en son équivalent en chiffre romain
; L'entrée de tout autre nombre génère un message d'erreur


call     main
         STOP

         
main:    NOP0
         LDX     0,i
         ;stocker le nombre décimal
         STRO    mess1,d
         DECI    nombreIn,d
         LDA     nombreIn,d  

         ;verifier que le chiffre est entre 0 et 3999
         CPA     0,i
         BREQ    erreur
         CPA     3999,i
         BRGT    erreur

         ;determiner nombre de chiffres
         CPA     1000,i
         BRGE    quatre
         CPA     100,i
         BRGE    trois
         CPA     10,i
         BRGE    deux
         BR      un
un:      LDX     1,i
         BR      finPos
deux:    LDX     2,i
         BR      finPos
trois:   LDX     3,i
         BR      finPos
quatre:  LDX     4,i
         BR      finPos

finPos:  STX     nombrePo,d
         LDX     0,i

         

         ;separer le nombre en ses positions
mille:   CPA     1000,i
         BRLT    centai
         
boucMil: ADDX    1,i         ;compte nombre de chiffres
         SUBA    1000,i
         CPA     1000,i
         BRLT    finMil
         BR      boucMil

finMil:  STX     posMil,d
         LDX     0,i
         
centai:  CPA     100,i
         BRLT    dizaine
bouclCe: ADDX    1,i
         SUBA    100,i
         CPA     100,i
         BRLT    finCen
         BR      bouclCe

finCen:  STX     posCe,d
         LDX     0,i

dizaine: CPA     10,i
         BRLT    unite
bouclDi: ADDX    1,i
         SUBA    10,i
         CPA     10,i
         BRLT    finDiz
         BR      bouclDi

finDiz:  STX     posDi,d
         LDX     0,i
     
unite:   CPA     0,i
         BREQ    fin
         STA     posUn,d
         BR      fin



erreur:  STRO    err1,d
         BR      exit

fin:     NOP0



         ;appel de la fonction romain pour chaque chiffre
         
         ;chiffre a la position mille

         ;storer le nombre qui représente la position (4 pour milliers)
         LDA     4,i
         STA     positi,d    

         ;ignorer si =0
         LDA     posMil,d
         CPA     0,i
         BREQ    mainCen     ;si chiffre est 0 ignoré
         ;paramètres
         LDA     posMil,d    ;le nombre a encoder
         call romain

         
         ;nombre a la position centaine
mainCen: LDA     3,i
         STA     positi,d
         ;ignorer si =0
         LDA     posCe,d
         CPA     0,i
         BREQ    mainDi
         ;paramètres
         LDA     posCe,d
         call    romain


         ;nombre a la position des dizaines
mainDi:  LDA     2,i
         STA     positi,d
         ;ignorer si =0
         LDA     posDi,d
         CPA     0,i
         BREQ    mainUni
         ;paramètres
         LDA     posDi,d
         call romain


         ;nombre a la position des unité
mainUni: LDA     1,i
         STA     positi,d
         ;ignorer si =0
         LDA     posUn,d
         CPA     0,i
         BREQ    finMai
         ;paramètres
         LDA     posUn,d
         call romain
         
finMai:  NOP0
         

         ;stocker tous les nombres de differentes positions
         ;dans la liste principale
         
         LDBYTEA chifMil,i 
         LDX     0,i
boucMa:  NOP0
         CPX     15,i        ;vu que max 15 chiffres
         BRGT    finTab 
         LDA     chifMil,x 
         CPA     0,i         ;ne pas stocker si vide
         BREQ    noSto
         BR      sto    
         ;stocker
sto:     STA     chifRom,x
         ADDX    1,i     
  
noSto:   ADDX    1,i
         BR      boucMa

finTab:  NOP0
         ;afficher listeRom
         LDX     0,i
bouAff:  CPX     15,i
         BREQ    finProg
         CHARO   chifRom,x 
         ADDX    1,i
         BR      bouAff



finProg: NOP0         
exit:    RET0

; Romain:Prend un chiffre et retourne sa conversion en chiffre romain
;        rempli les liste chifUn,chifDiz,chifCen,chifMil
; IN:    A: nombre a encoder
;        positi: indique la position du chiffre (1-unite 2-dizaine 3-centaine
;        4-millier)
;

romain:  NOP0
         ;storer les variables globales
         STA     nombCo,d
         ;determiner adresse encodage
         ;et quelle adresse stocker resultat
         LDA     positi,d
         CPA     4,i
         BREQ    mill
         CPA     3,i
         BREQ    cent
         CPA     2,i
         BREQ    dix
         CPA     1,i
         BREQ    uni

uni:     NOP0 
         LDA     romSymb,i   ;stocker adresse encodage
         STA     addrCo,d
         LDA     chifUn,i   ;stocker adresse resultat
         STA     adrssRe,d 
         call    chiffre
         BR      finRom

dix:     NOP0
         LDA     romSymb,i
         ADDA    2,i         ;encodage X
         STA     addrCo,d
         LDA     chifDiz,i
         STA     adrssRe,d
         call    chiffre
         BR      finRom

cent:    LDA     romSymb,i
         ADDA    4,i         ;encodage C
         STA     addrCo,d
         LDA     chifCen,i
         STA     adrssRe,d
         call    chiffre
         BR      finRom
         

mill:    LDA     romSymb,i 
         ADDA    6,i         ;encodage M
         STA     addrCo,d
         LDA     chifMil,i
         STA     adrssRe,d
         call    chiffre
         BR      finRom

finRom:  NOP0
         RET0





; Chiffre: Encode un chiffre de 0 à 9 pour chaque position et 
;          Fait sa conversiton en chiffre romain en plaçant le
;          resultat de la chaine dans la liste appropriée de sa
;          sa position
; 
; IN:    nombCo: nombre a encoder
;        addrCo: adresse pour le rang spécifié (I,X,C etc.)
;        positi: rang du chiffre(1-unite 2-dizaine 3-centaine
;        4-millier)
;        adrssRe: adresse ou placer le resultat
;

chiffre: NOP0
         ;determiner categorie
         LDA     nombCo,d
         CPA     3,i
         BRLE    UnTrois
         CPA     4,i
         BREQ    quatr
         CPA     9,i
         BREQ    neuf
         BR      cinqhui
         

UnTrois: NOP0
         ;si entre un trois
         LDA     nombCo,d
         STA     nbRep,d
         ;encodage de la lettre a pas besoin de modifier
         LDA     addrCo,d
         LDX     adrssRe,d
         call    repeter
         BR      finChif
         
         ;chiffre 4 
quatr:   NOP0 
         ;1er lettre 
         LDA     1,i
         STA     nbRep,d
         LDA     addrCo,d
         LDX     adrssRe,d
         call    repeter
         ;2eme lettre
         LDA     1,i
         STA     nbRep,d
         LDA     addrCo,d
         ADDA    1,i         ;2me nombre encodé
         LDX     adrssRe,d
         ADDX    1,i         ;2eme nombre
         call repeter
         BR      finChif

         ;chiffre neuf
neuf:    NOP0
         ;1er lettre
         LDA     1,i
         STA     nbRep,d
         LDA     addrCo,d
         LDX     adrssRe,d 
         call    repeter    
         ;2eme lettre
         LDA     1,i
         STA     nbRep,d
         LDA     addrCo,d
         ADDA    2,i         ;3eme lettre encodé
         LDX     adrssRe,d 
         ADDX    1,i         ;2eme chiffre
         call    repeter
         BR      finChif

         ;5 à 8
         ;1er lettre encodé
cinqhui: NOP0
         ;premier chiffre : 2eme nombre encodé
         LDA     1,i
         STA     nbRep,d
         LDA     addrCo,d 
         ADDA    1,i         ;2eme nombre encodé
         LDX     adrssRe,d 
         call    repeter

         ;trouver le nombre de prochaine lettres
         LDA     nombCo,d
         SUBA    5,i
         STA     nbRep,d
         ;encodé par 1er nombre a partir de la position 2
         LDA     addrCo,d      ;1er nombre encodé 
         LDX     adrssRe,d    ;deuxieme postion 
         ADDX    1,i
         call    repeter 
         BR      finChif 
         


         


finChif: RET0

; repeter: fonction qui repete un lettre un certain nombre de plus de 1 fois
; IN:    nbRep:nombre de repetitions met l'encodage dans addResu
;        A: adresse d'encodage exact de la lettre ex 'I'
;        X: adresse exacte ou mettre le resultat
; OUT:   AddResu: adresse apres l'encodage resultat
repeter: SUBSP   6,i
         ;stocker variables locales
         STA     addEnco,s
         STX     addResu,s
         LDA     0,i
         STA     index,s
         ;CHARO   addEnco,sf
         LDX     index,s
             
                  
boucle:  LDA     nbRep,d
         CPA     index,s     ;fin si index=nbRepi
         BREQ    fini
         ;sinon ajoute lettre
         LDBYTEA addEnco,sf  ;load la lettre
         STBYTEA addResu,sxf 
         ;CHARO   addResu,sxf 
         ADDX    1,i         ;incrementer index
         STX    index,s 
         
         BR      boucle


fini:    NOP0
         RET6          
         
addEnco: .EQUATE 4
addResu: .EQUATE 2
index:   .EQUATE 0







;
; variables globales
;



nombreIn:.BLOCK  2          ;nombre decimal stockee par utilisateur
nombrePo:.BLOCK  2          ;nombre de chiffre dans le nombre decimal
positi:  .BLOCK  2          ;la position du nombre actuel (rang)
nombCo:  .BLOCK  2          ;nombre a encoder
addrCo:  .ADDRSS romSymb    ;adresse de l'encodage
adrssRe: .ADDRSS chifMil    ;adresse ou mettre l'encodage romain d'un rang
nbRep:   .BLOCK  2          ;nombre de repetitions pour fonction repeter


;sauvegarder chaque position des chiffre
posUn:   .BLOCK 2
posDi:   .BLOCK 2
posCe:   .BLOCK 2
posMil:  .BLOCK 2

;messages
mess1:   .ASCII   "Entrez un nombre de 1 à 3999:\n\x00"
err1:    .ASCII   "Le nombre entré est invalide\x00"



;liste chiffre position mille max 3000 alors max 3
chifMil: .BYTE 0
         .BYTE 0
         .BYTE 0

;liste chiffre position centaine
chifCen: .BYTE 0 
         .BYTE 0
         .BYTE 0
         .BYTE 0

;liste chiffre position dizaine
chifDiz: .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0

;liste des chiffres romain unite (max VIII donc 4)
chifUn:  .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0


;liste de tous les symboles d'encodage
romSymb: .BYTE   'I'
         .BYTE   'V'
         .BYTE   'X'
         .BYTE   'L'
         .BYTE   'C'
         .BYTE   'D'
         .BYTE   'M'


;liste du resultat final (max 15 chiffres)
chifRom: .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0
         .BYTE 0





         .END




         

 

