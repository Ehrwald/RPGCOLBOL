       program-id. Program1 as "RPG.Program1".

       Author. Franck H.

       data division.
       

       working-storage section.

       01 Personnage.
         05 Nom SQL CHAR-VARYING(20).
         05 Pv PIC 999.
         05 Niveau PIC 99.
         05 Xp PIC 99.

       01 Attaque.
         05 Nom SQL CHAR-VARYING(20).
         05 Degat PIC 99.

       01 Ennemi.
         05 Nom PIC X(20).
         05 Pv PIC 999.
         05 Niveau PIC 99.
         05 XpReward PIC 99.
       
       77 Saisi pic 9.
       77 CouleurFondEcran pic 99 value 15.
       77 CouleurCaractere pic 99 value 0.
       77 SaisiNom pic x(20).
       77 Action pic 9.
      *
       77 NULLe pic 99999999. 
       77 Temps pic 9999.
       77 CNXDB STRING.
       77 Trouve pic 9.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
           EXEC SQL
               INCLUDE SQLDA
           END-EXEC.

       screen section.

       01 menu-jeu background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.
         10 line 3 col 32 value " RPG  ".
     
         10 line 5 col 69 value " Option :".
         10 line 5 col 79 pic 9 from Saisi.
         10 line 8 col 5 value "- 1 - Creer un personnage ......................................... :".
         10 line 9 col 5 value "- 2 - Recuperer son personnage .................................... :".
         10 line 10 col 5 value "- 3 - Lancer le jeu .............................................. :".
         10 line 14 col 5 value "- 0 - Retour ..................................................... :".

       01 menu-clean background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line 1 col 1 Blank Screen.

       01 menu-combat background-color is CouleurFondEcran foreground-color is CouleurCaractere.
         10 line col 1 Blank Screen.
         10 line 3 col 12 pic x(20) from Nom of Personnage.
         10 line 3 col 32 value " en combat contre : ".
         10 line 3 col 52 pic x(20) from Nom of Ennemi.
         10 line 5 col 5 value "Votre adversaire a ".
         10 line 5 col 33 pic 999 from Pv of Ennemi.
         10 line 5 col 50 value "Points de vie ".
         10 line 6 col 5 value "Vous avez ".
         10 line 6 col 33 pic 999 from Pv of Personnage.
         10 line 6 col 50 value "Points de vie ".
         10 line 7 col 65 value " Votre Action :".
         10 line 7 col 80 pic 9 from Action.
         10 line 8 col 5 value "- 1 - Attaquer ............................................ :".
         10 line 9 col 5 value "- 2 - Defendre ............................................ :".
         10 line 10 col 5 value "- 3 - Fuire .............................................. :".




      *personnage
      *(nom, niveau, pv, xp)
      *
      *attaque
      *(nom, degat)


       procedure division.

      **********************************
      ******Description de Menu*********
      **********************************
           Menu.
           perform Menu-init.
           perform Menu-Trt Until Saisi = 0.
           perform Menu-Fin.
       Menu-init.
      *    accept DateSysteme from date.

           Move 9 to Saisi.
           Move 0 to Temps.

      ****** On initialise un Ennemi *******

           Move "Demon" to Nom of Ennemi.
           Move 150 to Pv of Ennemi.
           Move 1 to Niveau of Ennemi.
           Move 50 to XpReward of Ennemi.
      *TODO : Générer des ennemis différents et automatiquement. **********

      *    **************************
      * Connexion à la base de données *
      *    **************************
           MOVE
             "Trusted_Connection=yes;Database=RPGBDD;server=LAPTOP-9TTM3P87\SQLEXPRESS;factory=System.data.Sqlclient;"
             to CNXDB.
           exec sql
               Connect using :CNXDB
           end-exec.
           if (sqlcode not equal 0) then
               stop run
           end-if.
      *      gère les commits automatiqument.
           exec sql
             SET AUTOCOMMIT ON
           end-exec.

      *TODO : Prévoir la déconnexion de la base de donnée à la fin. **************


      *    ****************************
      ***** Le menu du jeu principal *****
      *    ****************************

       Menu-Trt.
           display menu-jeu.
           Move 0 to Saisi.
           accept Saisi line 5 col 79.
           evaluate Saisi
               when 1
                   perform CreerSonPersonnage
               when 2
                   perform RecupererSonPersonnage
               when 3
                   perform LancerLeJeu
           end-evaluate.
       Menu-Fin.
           stop run.

      *    *******************************************************
      *    Créer un nouveaux personnage et le sauver en BDD ******
      *    *******************************************************
       CreerSonPersonnage.
           perform CreerSonPersonnage-init.
           perform CreerSonPersonnage-trt.
           perform CreerSonPersonnage-fin.
       CreerSonPersonnage-init.
           MOVE 0 to Xp of Personnage.
           Move 1 to Niveau of Personnage.
           Move 100 to PV of Personnage.

       CreerSonPersonnage-trt.
           DISPLAY menu-clean.
           DISPLAY "Nom du personnage".
           ACCEPT Nom of Personnage.
      *    DISPLAY menu-clean.
      *    DISPLAY "Point de vie : "
      *    ACCEPT Pv of Personnage.
           perform EnregistreLePersonnage.


       EnregistreLePersonnage.

           exec sql
                    INSERT INTO [dbo].[personnage]
                  ([Nom]
                  ,[Pv]
                  ,[Niveau]
                  ,[Xp])
            VALUES
                  (:Personnage.Nom
                  ,:Personnage.Pv
                  ,:Personnage.Niveau
                  ,:Personnage.Xp)
           end-exec

           continue.
       CreerSonPersonnage-fin.

      *    *************************************
      *    Récupérer un personnage sauvé en BDD 
      *    *************************************

       RecupererSonPersonnage.
           perform RecupererSonPersonnage-init.

           perform RecupererSonPersonnage-trt
           UNTIL Trouve = 1.
       

           perform RecupererSonPersonnage-fin.
       RecupererSonPersonnage-init.
       RecupererSonPersonnage-trt.

           DISPLAY menu-clean.
           DISPLAY "Indiquer le nom de votre personnage".
           ACCEPT SaisiNom.

      *    * On récupère le personnage en fonction du nom que l'utilisateur indique.
      *    TODO : afficher les personnages disponibles en BDD
           exec sql
               select * into :Personnage
               from personnage
               where Nom =:SaisiNom
           end-exec.


           if (sqlcode <> 0 and sqlcode <> 1) then

               DISPLAY menu-clean
               DISPLAY "Le personnage n'a pu etre trouver, veulliez ressayer"
               ACCEPT SaisiNom

           end-if.

           if (sqlcode = 0) then

               Move 1 to Trouve

           end-if.

       RecupererSonPersonnage-fin.

      *    ***************************
      *    Lancer le jeu / Combat ****
      *    ***************************

       LancerLeJeu.
           perform LancerLeJeu-init.
           perform LancerLeJeu-trt Until Pv of Personnage is <= 0 and Pv of Ennemi is <= 0 or Action is = 3.
           perform LancerLeJeu-fin.
       LancerLeJeu-init.
           Move 9 to Action.

      *    *****************************************************************************************
      *    Tant que l'un des adversaires est en vie et que le joueur n'a pas fui le combat continu
      *    *****************************************************************************************

       LancerLeJeu-trt.

           display menu-combat.
           Move 0 to Action.
           accept Action line 7 col 80.
           evaluate Action
               when 1
                   perform attaquer
               when 2
                   perform defendre
               when 3
                   perform fuire
           end-evaluate.

      *    ********************************************************
      *    *Les différentes possibilités à la sortie de la boucle
      *    ********************************************************

       LancerLeJeu-fin.

           DISPLAY menu-clean.
           if (Action = 3) then
               DISPLAY "Vous avez fuie, appuyer sur entrer pour retourner au menu"
               ACCEPT NULLe
           end-if.
           if (Pv of Ennemi <= 0) then
               DISPLAY "Vous avez gagnez, appuyer sur entrer pour retourner au menu"
               ACCEPT NULLe
           end-if.
           if (Pv of Personnage <= 0) then
               DISPLAY "Vous etes KO, appuyer sur entrer pour retourner au menu"
               ACCEPT NULLe
           end-if.
           

       attaquer.
           perform attaquer-init.
           perform attaquer-trt.
           perform attaquer-fin.

      *    ****************************************************************************
      *    * table sql étant vie on initialise une attaques
      *    * TODO : récupérer en fichier en dure pour alimenter la base de données 
      *    * **************************************************************************

       attaquer-init.
           Move "coup d epee" to Nom of Attaque.
           Move 50 to Degat of Attaque.


      *    ******************************************************************************************************************
      *    * Applique les dégâts du joueur sur l'ennemi puis de l'ennemi sur le joueur
      *    * TODO : Montrer les dégâts infligés par chacun, prévoir de l'initiative pour déterminer qui attaque le premier
      *    ******************************************************************************************************************

       attaquer-trt.

      *    TODO : Random des degat + degat de base.

           subtract Degat of Attaque from Pv of Ennemi.
           
           subtract Degat of Attaque from Pv of Personnage.
       attaquer-fin.

       defendre.
           perform defendre-init.
           perform defendre-trt.
      *    Reduire les degats inflige
           perform defendre-fin.

       defendre-init.
       defendre-trt.
       defendre-fin.

       fuire.
           perform fuire-init.
           perform fuire-trt.
      *    Random la chance de fuire 
           perform fuire-fin.

       fuire-init.

       fuire-trt.

       fuire-fin.



       end program Program1.
