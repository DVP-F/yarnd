       IDENTIFICATION DIVISION.
       PROGRAM-ID. YARNDGEN.

       *> Expected input structure:
       *> 
       *>  ```
       *>  STYLE=ABCD...
       *>  SEED=0123xxx
       *>  COUNT=012
       *>  ```

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 STATEMENT-COUNT PIC 9(3) VALUE ZERO.
       01 STATEMENT-LIST.
          05 STATEMENT-ITEM OCCURS ZERO TO 999 TIMES
             DEPENDING ON STATEMENT-COUNT PIC X(80).
       01 STYLE PIC 9 VALUE ZERO.
       01 SEED PIC 9(3) VALUE ZERO.
