DECLARE SUB DatLoad (FLNM$, X!, Y!, Sx!, Sy!)
DECLARE SUB PRKEY ()
DECLARE SUB MUSIC (FILENAME$, R!)
DECLARE SUB PAUSE (WAITS!)
REM ---------------------------------------------------------------------------
REM Alien Attack ver. 1.1 for PC POISK
REM Kolevatow & Maslow Sergey
REM QB version 1.0
REM ---------------------------------------------------------------------------
CLS
PRINT TAB(28); "Alien Attack ver. 1.1"
LOCATE 5, 27
PRINT "Choose graphics adapter:"
PRINT
LOCATE , 30: PRINT "1).VGA adapter"
LOCATE , 30: PRINT "2).CGA adapter"
LOCATE , 30: PRINT "3).CGA-mono adapter"
PRINT
LOCATE , 30: PRINT "Select is - "; : COLOR 23: PRINT "_": COLOR 7, 0, 0
FST:
A$ = INKEY$
IF A$ = "" THEN GOTO FST
AD = VAL(A$)
IF AD = 2 OR AD = 3 THEN GOTO CONT00
GOTO FST
CONT00:
LOCATE 11, 41: PRINT AD
LOCATE 5, 27
PRINT "Choose sound card:              "
PRINT
LOCATE , 30: PRINT "1).No Sound        "
LOCATE , 30: PRINT "2).IBM beeper      "
LOCATE , 30: PRINT "3).POISK beeper    "
PRINT
LOCATE , 30: PRINT "Select is - "; : COLOR 23: PRINT "_": COLOR 7, 0, 0
SCD:
A$ = INKEY$
IF A$ = "" THEN GOTO SCD
SD = VAL(A$)
IF SD = 1 OR SD = 3 THEN GOTO Cont01
GOTO SCD
Cont01:
LOCATE 11, 41: PRINT SD
LOCATE 5, 27
PRINT "Choose your PC type:            "
PRINT
LOCATE , 30: PRINT "1).IBM-286         "
LOCATE , 30: PRINT "2).IBM-386         "
LOCATE , 30: PRINT "3).PC POISK        "
PRINT
LOCATE , 30: PRINT "Select is - "; : COLOR 23: PRINT "_": COLOR 7, 0, 0
FRD:
A$ = INKEY$
IF A$ = "" THEN GOTO FRD
PC = VAL(A$)
IF PC = 1 OR PC = 2 OR PC = 3 THEN GOTO ContLST
GOTO FRD
ContLST:
LOCATE 11, 41: PRINT PC
CLS
PRINT "Please Wait ..."
IF AD = 2 THEN
        SEGMENT = &HB800
        SCR = 1
        COL = 5
        EXT$ = ".CGA"
ELSEIF AD = 3 THEN
        SEGMENT = &HB800
        SCR = 2
        COL = 1
        EXT$ = ".CGA"
END IF
IF PC = 1 THEN SPD = .5
IF PC = 2 THEN SPD = .1
IF PC = 3 THEN SPD = 8
SCREEN SCR
DEF SEG = SEGMENT
IF SD = 3 THEN CALL MUSIC("LOGO00.MUS", 1)
BLOAD "LOGO00" + EXT$
CALL PRKEY
IF SD = 3 THEN CALL MUSIC("LOGO01.MUS", 1)
BLOAD "LOGO01" + EXT$
CALL PRKEY
CLS
PRINT "Please Wait ... Start Setup"
DIM Human(128): CALL DatLoad("Human", 8, 16, 0, 8): GET (0, 8)-(8, 24), Human
DIM Crest(128): CALL DatLoad("Crest", 8, 16, 0, 8): GET (0, 8)-(8, 24), Crest
DIM Skelet(128): CALL DatLoad("Skelet", 8, 16, 0, 8): GET (0, 8)-(8, 24), Skelet
DIM UFO(128): CALL DatLoad("UFO", 16, 8, 0, 8): GET (0, 8)-(16, 16), UFO
DIM Babah(64): CALL DatLoad("Babah", 8, 8, 0, 16): GET (0, 16)-(8, 24), Babah
DIM Bomb00(64): CALL DatLoad("Bomb00", 8, 8, 0, 16): GET (0, 16)-(8, 24), Bomb00
DIM Bomb01(64): CALL DatLoad("Bomb01", 8, 8, 0, 16): GET (0, 16)-(8, 24), Bomb01
DIM Kills(11): LEV = 1
Logo:
FOR A = 0 TO 11: Kills(A) = 2: NEXT A
UX = 100: UY = 120: Posit = INT(RND * 12): BX = 16 * Posit + 8: BY = 8: B = 0: H = 12: S = 0: D = 0
CLS
BLOAD "GAMELOGO" + EXT$
LOCATE 7, 37: PRINT LTRIM$(STR$(B)) + " "
LOCATE 10, 37: PRINT LTRIM$(STR$(H)) + " "
LOCATE 13, 37: PRINT LTRIM$(STR$(S)) + " "
LOCATE 16, 37: PRINT LTRIM$(STR$(D)) + " "
FOR A = 8 TO 198 STEP 16
PUT (A, 180), Human
NEXT A
CALL PRKEY
PUT (UX, UY), UFO: PUT (BX, BY), Bomb00
Game:
Fors:
PUT (BX, BY), Bomb00
PUT (BX, BY), Bomb01
PUT (BX, BY), Bomb01
BY = BY + SPD
PUT (BX, BY), Bomb00
A$ = INKEY$
IF MID$(A$, 2, 1) = CHR$(75) THEN
                IF UX - 16 < 4 THEN GOTO Cont02
                IF SD = 3 THEN SOUND 100, .1
                PUT (UX, UY), UFO
                UX = UX - 16
                PUT (UX, UY), UFO
ELSEIF MID$(A$, 2, 1) = CHR$(77) THEN
                IF UX + 16 > 183 THEN GOTO Cont02
                IF SD = 3 THEN SOUND 100, .1
                PUT (UX, UY), UFO
                UX = UX + 16
                PUT (UX, UY), UFO
ELSEIF A$ = CHR$(27) THEN
                IF SD = 3 THEN SOUND 1000, .5
                CLS
                END
END IF
Cont02:
IF INT(BY) = 112 AND BX = UX + 4 THEN
        IF SD = 3 THEN SOUND 400, 1
        PUT (BX, BY), Bomb00
        B = B + 1: LOCATE 7, 37
        PRINT LTRIM$(STR$(B))
        Posit = INT(RND * 12)
        BY = 8: BX = 16 * Posit + 8
        PUT (BX, BY), Bomb00
        IF B = 50 AND H >= 3 THEN GOTO NextLEV
        IF B = 50 AND H < 3 THEN GOTO Death
ELSEIF INT(BY) >= 172 THEN
        PUT (BX, BY), Bomb00
        IF Kills(Posit) = 2 THEN
                IF SD = 3 THEN SOUND 200, 1
                H = H - 1: S = S + 1
                LOCATE 10, 37: PRINT LTRIM$(STR$(H)) + " "
                LOCATE 13, 37: PRINT LTRIM$(STR$(S)) + " "
                DX = (Posit * 16 + 8)
                PUT (DX, 180), Human
                PUT (DX, 180), Babah
                PUT (DX, 180), Babah
                PUT (DX, 180), Skelet
                Kills(Posit) = 1
        ELSEIF Kills(Posit) = 1 THEN
                IF SD = 3 THEN SOUND 300, 1
                S = S - 1: D = D + 1
                LOCATE 13, 37: PRINT LTRIM$(STR$(S)) + " "
                LOCATE 16, 37: PRINT LTRIM$(STR$(D))
                DX = (Posit * 16 + 8)
                PUT (DX, 180), Skelet
                PUT (DX, 180), Crest
                Kills(Posit) = 0
                IF D = 12 THEN GOTO Death
        END IF
        WHILE Kills(Posit) = 0
        Posit = INT(RND * 12)
        WEND
        BY = 8: BX = 16 * Posit + 8
        PUT (BX, BY), Bomb00
END IF
GOTO Fors
Death:
CLS
IF SD = 3 THEN CALL MUSIC("LOGO01.MUS", 1)
BLOAD "GAME02" + EXT$
CALL PRKEY
SCREEN 0: WIDTH 80
PRINT "Thank you for plaing Alien Attack !"
END
NextLEV:
CLS
IF SD = 3 THEN CALL MUSIC("LOGO01.MUS", 1)
BLOAD "GAME03" + EXT$
CALL PRKEY
CLS
LEV = LEV + 1
IF LEV = 6 THEN GOTO Win:
IF PC = 1 THEN DOP = .5
IF PC = 2 THEN DOP = .05
IF PC = 1 THEN DOP = 1
SPD = SPD + DOP
GOTO Logo
END
Win:
CLS
IF SD = 3 THEN CALL MUSIC("LOGO01.MUS", 1)
BLOAD "GAME04" + EXT$
CALL PRKEY
SCREEN 0: WIDTH 80
PRINT "Thank you for plaing Alien Attack !"
END

SUB DatLoad (FLNM$, X, Y, Sx, Sy)
A = 1
OPEN "B", #1, FLNM$ + ".DAT"
FOR TX = 0 TO X
FOR TY = 0 TO Y
SEEK #1, A: D$ = " ": GET #1, , D$: D = ASC(D$)
PSET (TX + Sx, TY + Sy), D
A = A + 1
NEXT TY, TX
CLOSE #1
END SUB

SUB MUSIC (FILENAME$, R)
OPEN "I", #1, FILENAME$
INPUT #1, MELODY$
CLOSE #1
FOR TMP = 0 TO R
PLAY MELODY$
NEXT TMP
END SUB

SUB PAUSE (WAITS)
FOR WT = 0 TO WAITS
NEXT WT
END SUB

SUB PRKEY
WHILE INKEY$ = ""
WEND
END SUB

