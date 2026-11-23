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
       01  WS-FILE-STATUS PIC XX VALUE "00".
       01  FILE-NAME.
           05  FILE-NAME-LEN PIC 9(3) VALUE ZERO.
           05  FILE-NAME-BUF PIC X(255) VALUE SPACES.
       01  INPUT-LINE PIC X(256) VALUE SPACES. *> STDIN
       01  KV-KEY PIC X(50) VALUE SPACES.
       01  KV-VALUE PIC X(50) VALUE SPACES.

      *> config
       01  STATEMENT-COUNT PIC 9(3) VALUE ZERO.
       01  STATEMENT-LIST.
           05  STATEMENT-ITEM OCCURS 128 TIMES.
               10  STATEMENT-ITEM-LEN PIC 9(3) VALUE ZERO.
               10  STATEMENT-ITEM-BUF PIC X(100) VALUE SPACES.
       01  STYLE.
           05  STYLE-LEN PIC 9(3) VALUE ZERO.
           05  STYLE-BUF PIC X(50) VALUE SPACES.
       01  SEED PIC 9(3) VALUE ZERO.

      *> numeral conversion
       01  NUM-AS-STRING PIC X(5).
       01  NUM-AS-NUM REDEFINES NUM-AS-STRING PIC 9(5).

      *> verbs
       01  VERB-LIST.
           05  VERB OCCURS 128 TIMES.
               10  VERB-LEN PIC 9(3) VALUE ZERO.
               10  VERB-BUF PIC X(50) VALUE SPACES.
       01  WS-VERB-COUNT PIC 9(3) VALUE ZERO.
       01  WS-VERB-POINTER PIC 9(4) VALUE 1.
       01  WS-VERB-WORD PIC X(50).

      *> nouns
       01  NOUN-LIST.
           05  NOUN OCCURS 128 TIMES.
               10  NOUN-LEN PIC 9(3) VALUE ZERO.
               10  NOUN-BUF PIC X(50) VALUE SPACES.
       01  WS-NOUN-COUNT PIC 9(3) VALUE ZERO.
       01  WS-NOUN-POINTER PIC 9(4) VALUE 1.
       01  WS-NOUN-WORD PIC X(50).

      *> adjectives
       01  ADJECTIVE-LIST.
           05  ADJECTIVE OCCURS 128 TIMES.
               10  ADJECTIVE-LEN PIC 9(3) VALUE ZERO.
               10  ADJECTIVE-BUF PIC X(50) VALUE SPACES.
       01  WS-ADJ-COUNT PIC 9(3) VALUE ZERO.
       01  WS-ADJ-POINTER PIC 9(4) VALUE 1.
       01  WS-ADJ-WORD PIC X(50).

      *> sentences
       01  SENTENCE-LIST.
           05  SENTENCE-ITEM OCCURS 128 TIMES.
               10  SENTENCE-ITEM-LEN PIC 9(3) VALUE ZERO.
               10  SENTENCE-ITEM-BUF PIC X(256) VALUE SPACES.
       01  WS-SEN-COUNT PIC 9(3) VALUE ZERO.
       01  WS-SEN-POINTER PIC 9(4) VALUE 1.
       01  WS-SEN-WORD PIC X(256).

       PROCEDURE DIVISION.
       0000-MAIN.
           DISPLAY "Running..."
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
                   MOVE FUNCTION LENGTH(FUNCTION TRIM(KV-VALUE))
                       TO STYLE-LEN
                   MOVE FUNCTION TRIM(KV-VALUE) TO STYLE-BUF
               ELSE
                   IF KV-KEY = "SEED"
                       MOVE FUNCTION TRIM(KV-VALUE) TO NUM-AS-STRING
                       MOVE NUM-AS-NUM TO SEED
                   ELSE
                       IF KV-KEY = "COUNT"
                           MOVE FUNCTION TRIM(KV-VALUE) TO NUM-AS-STRING
                           MOVE NUM-AS-NUM TO STATEMENT-COUNT
                       END-IF
                   END-IF
               END-IF

           END-PERFORM.

           *> get output config from given file
               *> construct file name
           STRING "./styles/" STYLE-BUF(1:STYLE-LEN) ".lst"
               INTO FILE-NAME-BUF
           END-STRING

           MOVE FUNCTION LENGTH(FUNCTION TRIM(FILE-NAME-BUF))
               TO FILE-NAME-LEN

           OPEN INPUT INPUT-FILE.
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "Failed to open file '"
                   FILE-NAME-BUF(1:FILE-NAME-LEN)
                   "'. Code:" WS-FILE-STATUS
               GOBACK *> return
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
                       MOVE FUNCTION LENGTH(
                           FUNCTION TRIM(WS-VERB-WORD))
                           TO VERB-LEN(WS-VERB-COUNT)
                       MOVE FUNCTION TRIM(WS-VERB-WORD)
                           TO VERB-BUF(WS-VERB-COUNT)
                   END-PERFORM
               END-READ.

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
                       MOVE FUNCTION LENGTH(
                           FUNCTION TRIM(WS-NOUN-WORD))
                           TO NOUN-LEN(WS-NOUN-COUNT)
                       MOVE FUNCTION TRIM(WS-NOUN-WORD)
                           TO NOUN-BUF(WS-NOUN-COUNT)
                   END-PERFORM
               END-READ.

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
                       MOVE FUNCTION LENGTH(
                           FUNCTION TRIM(WS-ADJ-WORD))
                           TO ADJECTIVE-LEN(WS-ADJ-COUNT)
                       MOVE FUNCTION TRIM(WS-ADJ-WORD)
                           TO ADJECTIVE-BUF(WS-ADJ-COUNT)
                   END-PERFORM
               END-READ.

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
                       MOVE FUNCTION LENGTH(
                           FUNCTION TRIM(WS-SEN-WORD))
                           TO SENTENCE-ITEM-LEN(WS-SEN-COUNT)
                       MOVE FUNCTION TRIM(WS-SEN-WORD)
                           TO SENTENCE-ITEM-BUF(WS-SEN-COUNT)
                   END-PERFORM
               END-READ.

           CLOSE INPUT-FILE.

       2000-PRINT-RESULT.
           DISPLAY "====:====:====:====:====:====:====:====:===="
           DISPLAY "Config"
           DISPLAY "====:====:====:====:====:====:====:====:===="
           DISPLAY "Style:           " STYLE-BUF(1:STYLE-LEN)
           DISPLAY "Seed:            " SEED
           DISPLAY "Statement count: " STATEMENT-COUNT
           DISPLAY "Wordfile:        " FILE-NAME-BUF(1:FILE-NAME-LEN)
           DISPLAY SPACE
           DISPLAY "====:====:====:====:====:====:====:====:===="
           DISPLAY "Wordlists"
           DISPLAY "====:====:====:====:====:====:====:====:===="

           DISPLAY "Verbs:"
           PERFORM VARYING WS-VERB-COUNT FROM 1 BY 1
               UNTIL WS-VERB-COUNT > 128
                   OR VERB-LEN(WS-VERB-COUNT) = ZERO
               DISPLAY "  "
                   VERB-BUF(WS-VERB-COUNT)
                       (1:VERB-LEN(WS-VERB-COUNT))
           END-PERFORM

           DISPLAY "Nouns:"
           PERFORM VARYING WS-NOUN-COUNT FROM 1 BY 1
               UNTIL WS-NOUN-COUNT > 128
                   OR NOUN-LEN(WS-NOUN-COUNT) = ZERO
               DISPLAY "  "
                   NOUN-BUF(WS-NOUN-COUNT)
                       (1:NOUN-LEN(WS-NOUN-COUNT))
           END-PERFORM

           DISPLAY "Adjectives:"
           PERFORM VARYING WS-ADJ-COUNT FROM 1 BY 1
               UNTIL WS-ADJ-COUNT > 128
                   OR ADJECTIVE-LEN(WS-ADJ-COUNT) = ZERO
               DISPLAY "  "
                   ADJECTIVE-BUF(WS-ADJ-COUNT)
                       (1:ADJECTIVE-LEN(WS-ADJ-COUNT))
           END-PERFORM

           DISPLAY "Sentence templates:"
           PERFORM VARYING WS-SEN-COUNT FROM 1 BY 1
               UNTIL WS-SEN-COUNT > 128
                   OR SENTENCE-ITEM-LEN(WS-SEN-COUNT) = ZERO
               DISPLAY "  "
                   SENTENCE-ITEM-BUF(WS-SEN-COUNT)
                       (1:SENTENCE-ITEM-LEN(WS-SEN-COUNT))
           END-PERFORM

           DISPLAY SPACE

       .
