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
       SELECT INPUT-FILE *> define file to open
          ASSIGN TO DYNAMIC FILE-NAME *> name
          ORGANIZATION IS LINE SEQUENTIAL *> by lines
          FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.

       FILE SECTION.
       FD INPUT-FILE.
       01 INPUT-FILE-LINE PIC X(256). *> "file descriptor" type thing

       WORKING-STORAGE SECTION.
       *> processing
       01 WS-FILE-STATUS PIC XX VALUE "00".
       01 FILE-NAME PIC X(255) VALUE SPACES.
       01 INPUT-LINE PIC X(256) VALUE SPACES. *> STDIN
       01 KV-KEY PIC X(50) VALUE SPACES.
       01 KV-VALUE PIC X(50) VALUE SPACES.

       *> config
       01 STATEMENT-COUNT PIC 9(3) VALUE ZERO.
       01 STATEMENT-LIST.
           05 STATEMENT-ITEM OCCURS UNBOUNDED
               DEPENDING ON STATEMENT-COUNT PIC X(100) VALUE SPACES.
       01 STYLE PIC X(50) VALUE SPACES.
       01 SEED PIC 9(3) VALUE ZERO.

       *> numeral conversion
       01 NUM-AS-STRING PIC X(5).
       01 NUM-AS-NUM REDEFINES NUM-AS-STRING PIC 9(5).

       *> verbs
       01 VERB-LIST.
           05 VERB PIC X(50) VALUE SPACES OCCURS 128 TIMES.
       01  WS-VERB-COUNT PIC 9(3) VALUE ZERO.
       01  WS-VERB-POINTER PIC 9(4) VALUE 1.
       01  WS-VERB-WORD PIC X(50).

       *> nouns
       01 NOUN-LIST.
           05 NOUN PIC X(50) VALUE SPACES OCCURS 128 TIMES.
       01  WS-NOUN-COUNT PIC 9(3) VALUE ZERO.
       01  WS-NOUN-POINTER PIC 9(4) VALUE 1.
       01  WS-NOUN-WORD PIC X(50).

       *> adjectives
       01 ADJECTIVE-LIST.
           05 ADJECTIVE PIC X(50) VALUE SPACES OCCURS 128 TIMES.
       01  WS-ADJ-COUNT PIC 9(3) VALUE ZERO.
       01  WS-ADJ-POINTER PIC 9(4) VALUE 1.
       01  WS-ADJ-WORD PIC X(50).

       *> sentences
       01 SENTENCE-LIST.
           05 SENTENCE-ITEM PIC X(256) VALUE SPACES OCCURS 128 TIMES.
       01  WS-SEN-COUNT PIC 9(3) VALUE ZERO.
       01  WS-SEN-POINTER PIC 9(4) VALUE 1.
       01  WS-SEN-WORD PIC X(256).

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM 1000-GET-CONFIG
           PERFORM 2000-PRINT-RESULT
           STOP RUN.
       1000-GET-CONFIG.
           *> get config from stdin
           PERFORM 3 TIMES *> loop three times to cover all fields
               ACCEPT INPUT-LINE *> read one line

               MOVE SPACES TO KV-KEY
               MOVE SPACES TO KV-VALUE

               UNSTRING INPUT-LINE
                   DELIMITED BY "="
                   INTO KV-KEY KV-VALUE
               END-UNSTRING

               IF KV-KEY = "STYLE"
                   MOVE KV-VALUE TO STYLE
               ELSE
                   IF KV-KEY = "SEED"
                       MOVE KV-VALUE TO NUM-AS-STRING
                       MOVE NUM-AS-NUM TO SEED
                   ELSE
                       IF KV-KEY = "COUNT"
                           MOVE KV-VALUE TO NUM-AS-STRING
                           MOVE NUM-AS-NUM TO STATEMENT-COUNT
                       END-IF
                   END-IF
               END-IF

           END-PERFORM.

           *> get output config from given file
           STRING "./styles/" STYLE ".lst" *> construct file name
               INTO FILE-NAME
           END-STRING

           OPEN INPUT INPUT-FILE.
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "Failed to open file. Code:" WS-FILE-STATUS
               STOP RUN
           END-IF.

           *> parse file contents here

           READ INPUT-FILE *> Verbs on first line
               AT END
                   CONTINUE
               NOT AT END
                   MOVE 0 TO WS-VERB-COUNT
                   MOVE 1 TO WS-VERB-POINTER

                   PERFORM UNTIL WS-VERB-POINTER >
                       LENGTH OF INPUT-FILE-LINE
                       OR WS-VERB-COUNT = 128

                       UNSTRING INPUT-FILE-LINE
                           DELIMITED BY ";"
                           INTO WS-VERB-WORD
                           WITH POINTER WS-VERB-POINTER
                       END-UNSTRING

                       ADD 1 TO WS-VERB-COUNT
                       MOVE FUNCTION TRIM(WS-VERB-WORD)
                           TO VERB(WS-VERB-COUNT)
                   END-PERFORM
               END-READ

           READ INPUT-FILE *> Nouns on second line
               AT END
                   CONTINUE
               NOT AT END
                   MOVE 0 TO WS-NOUN-COUNT
                   MOVE 1 TO WS-NOUN-POINTER

                   PERFORM UNTIL WS-NOUN-POINTER >
                       LENGTH OF INPUT-FILE-LINE
                       OR WS-NOUN-COUNT = 128

                       UNSTRING INPUT-FILE-LINE
                           DELIMITED BY ";"
                           INTO WS-NOUN-WORD
                           WITH POINTER WS-NOUN-POINTER
                       END-UNSTRING

                       ADD 1 TO WS-NOUN-COUNT
                       MOVE FUNCTION TRIM(WS-NOUN-WORD)
                           TO NOUN(WS-NOUN-COUNT)
                   END-PERFORM
               END-READ

           READ INPUT-FILE *> Adjectives on third line
               AT END
                   CONTINUE
               NOT AT END
                   MOVE 0 TO WS-ADJ-COUNT
                   MOVE 1 TO WS-ADJ-POINTER

                   PERFORM UNTIL WS-ADJ-POINTER >
                       LENGTH OF INPUT-FILE-LINE
                       OR WS-ADJ-COUNT = 128

                       UNSTRING INPUT-FILE-LINE
                           DELIMITED BY ";"
                           INTO WS-ADJ-WORD
                           WITH POINTER WS-ADJ-POINTER
                       END-UNSTRING

                       ADD 1 TO WS-ADJ-COUNT
                       MOVE FUNCTION TRIM(WS-ADJ-WORD)
                           TO ADJECTIVE(WS-ADJ-COUNT)
                   END-PERFORM
               END-READ

           READ INPUT-FILE *> Sentences on fourth line
               AT END
                   CONTINUE
               NOT AT END
                   MOVE 0 TO WS-SEN-COUNT
                   MOVE 1 TO WS-SEN-POINTER

                   PERFORM UNTIL WS-SEN-POINTER >
                       LENGTH OF INPUT-FILE-LINE
                       OR WS-SEN-COUNT = 128

                       UNSTRING INPUT-FILE-LINE
                           DELIMITED BY ";"
                           INTO WS-SEN-WORD
                           WITH POINTER WS-SEN-POINTER
                       END-UNSTRING

                       ADD 1 TO WS-SEN-COUNT
                       MOVE FUNCTION TRIM(WS-SEN-WORD)
                           TO SENTENCE-ITEM(WS-SEN-COUNT)
                   END-PERFORM
               END-READ

           CLOSE INPUT-FILE

       2000-PRINT-RESULT.
           DISPLAY "====:====:====:====:====:====:===="
           DISPLAY "Config"
           DISPLAY "====:====:====:====:====:====:===="
           DISPLAY "Style:           " STYLE
           DISPLAY "Seed:            " SEED
           DISPLAY "Statement count: " STATEMENT-COUNT
           DISPLAY "Wordfile:        " FILE-NAME
           DISPLAY SPACE
           DISPLAY "====:====:====:====:====:====:===="
           DISPLAY "Wordlists"
           DISPLAY "====:====:====:====:====:====:===="
           DISPLAY "Verbs:              " VERB-LIST
           DISPLAY "Nouns:              " NOUN-LIST
           DISPLAY "Adjectives:         " ADJECTIVE-LIST
           DISPLAY "Sentence templates: " SENTENCE-LIST

