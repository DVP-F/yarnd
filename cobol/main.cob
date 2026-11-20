       IDENTIFICATION DIVISION.
       PROGRAM-ID. YARNDGEN.

       *> Expected input structure:
       *> 
       *>  ```
       *>  STYLE=ABCD...
       *>  SEED=0123xxx
       *>  COUNT=012
       *>  ```

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT MY-FILE
          ASSIGN TO DYNAMIC FILE-NAME
          ORGANIZATION IS LINE SEQUENTIAL
          FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 INPUT-LINE PIC X(256) VALUE SPACES.
       01 KV-KEY PIC X(50) VALUE SPACES.
       01 KV-VALUE PIC X(50) VALUE SPACES.
       01 STATEMENT-COUNT PIC 9(3) VALUE ZERO.
       01 STATEMENT-LIST.
          05 STATEMENT-ITEM OCCURS ZERO TO 100 TIMES
             DEPENDING ON STATEMENT-COUNT PIC X(80) VALUE SPACES.
       01 STYLE PIC 9 VALUE ZERO.
       01 SEED PIC 9(3) VALUE ZERO.
       01 FILE-NAME PIC X(255) VALUE SPACES.
       01 WS-FILE-STATUS PIC XX VALUE "00".
       *> numeral conversion
       01 NUM-AS-STRING PIC X(5).
       01 NUM-AS-NUM REDEFINES NUM-AS-STRING PIC 9(5).

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-GET-CONFIG
           STOP RUN.
       1000-GET-CONFIG.
           MOVE SPACES TO FILE-NAME
           STRING "./styles/" STYLE ".txt" *> construct file name
              INTO FILE-NAME
           END-STRING
           PERFORM 3 TIMES *> loop three times to cover all fields
               ACCEPT INPUT-LINE *> read one line
               MOVE SPACES TO KV-KEY
               MOVE SPACES TO KV-VALUE
               UNSTRING INPUT-LINE
                   DELIMITED BY "="
                   INTO KV-KEY KV-VALUE
               END-UNSTRING
               IF KV-KEY = "STYLE"
                   MOVE KV-VALUE INTO STYLE
               ELSE
                   IF KV-KEY = "SEED"
                       MOVE KV-VALUE INTO NUM-AS-STRING
                       MOVE NUM-AS-NUM INTO SEED
                   ELSE
                       IF KV-KEY = "COUNT"
                           MOVE KV-VALUE INTO NUM-AS-STRING
                           MOVE NUM-AS-NUM INTO STATEMENT-COUNT
                       END-IF.
                   END-IF.
               END-IF.
           END-PERFORM.
