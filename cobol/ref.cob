       *> ============================================================
       *> GnuCOBOL reference example
       *> Compile:  cobc -x reference.cob
       *> Run:      ./reference
       *>
       *> This program demonstrates:
       *>   - COBOL divisions and sections
       *>   - Variables and PICTURE clauses
       *>   - MOVE, arithmetic, DISPLAY, ACCEPT
       *>   - IF, EVALUATE, PERFORM loops
       *>   - Paragraphs and a simple sequential file
       *> ============================================================
       
       IDENTIFICATION DIVISION. *> Name the division (program)
       PROGRAM-ID. REFERENCE-DEMO.
       
       *> Define environment
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       *> Associate the logical file name EMPLOYEE-FILE
       *> with the physical file employees.dat
       SELECT EMPLOYEE-FILE
           ASSIGN TO "employees.dat"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-FILE-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       
       *> Record layout for each line in employees.dat
       FD EMPLOYEE-FILE.
       01 EMPLOYEE-RECORD.
          05 EMP-ID          PIC 9(5).
          05 EMP-NAME        PIC X(20).
          05 EMP-SALARY      PIC 9(7)V99.
       
       WORKING-STORAGE SECTION.
       
       *> ------------------------------------------------------------
       *> Numeric fields
       *> 9 = digit, V = implied decimal point, S = signed
       *> ------------------------------------------------------------
       01 WS-HOURS          PIC 9(3)V99 VALUE 40.00.
       01 WS-RATE           PIC 9(3)V99 VALUE 25.50.
       01 WS-PAY            PIC 9(7)V99 VALUE ZERO.
       01 WS-COUNTER        PIC 9(3) VALUE ZERO.
       01 WS-TOTAL          PIC 9(7)V99 VALUE ZERO.
       01 WS-AVERAGE        PIC 9(7)V99 VALUE ZERO.
       01 WS-SIGNED-NUMBER  PIC S9(5)V99 VALUE -123.45.
       
       *> ------------------------------------------------------------
       *> Alphanumeric and single-character fields
       *> X = any character, A = alphabetic
       *> ------------------------------------------------------------
       01 WS-USER-INPUT     PIC X(30) VALUE SPACES.
       01 WS-GRADE          PIC X VALUE SPACE.
       01 WS-STATUS-TEXT    PIC X(20) VALUE SPACES.
       
       *> File status: "00" means successful operation
       01 WS-FILE-STATUS    PIC XX VALUE "00".
       
       *> Constants: use VALUE clauses
       01 WS-COMPANY-NAME   PIC X(30) VALUE "Example Company".
       01 WS-MAX-EMPLOYEES  PIC 9(3) VALUE 3.
       
       PROCEDURE DIVISION.
       
       *> Main control paragraph
       0000-MAIN.
           DISPLAY "Company: " WS-COMPANY-NAME.
           DISPLAY "========================================".
       
           PERFORM 1000-DEMONSTRATE-VARIABLES
           PERFORM 2000-DEMONSTRATE-INPUT
           PERFORM 3000-DEMONSTRATE-DECISIONS
           PERFORM 4000-DEMONSTRATE-LOOPS
           PERFORM 5000-DEMONSTRATE-FILE
       
           DISPLAY "========================================".
           DISPLAY "Program complete."
           STOP RUN.
       
       *> ------------------------------------------------------------
       *> Variables, MOVE, arithmetic, DISPLAY
       *> ------------------------------------------------------------
       1000-DEMONSTRATE-VARIABLES.
           DISPLAY "1. VARIABLES AND ARITHMETIC".
       
           *> MOVE copies data from one field to another
           MOVE 40.00 TO WS-HOURS
           MOVE 25.50 TO WS-RATE
       
           *> COMPUTE evaluates an arithmetic expression
           COMPUTE WS-PAY = WS-HOURS * WS-RATE
       
           DISPLAY "Hours: " WS-HOURS.
           DISPLAY "Rate:  " WS-RATE.
           DISPLAY "Pay:   " WS-PAY.
       
           *> ADD, SUBTRACT, MULTIPLY, DIVIDE also work
           ADD 100 TO WS-TOTAL
           SUBTRACT 25 FROM WS-TOTAL
           MULTIPLY 2 BY WS-TOTAL
           DIVIDE 2 INTO WS-TOTAL
       
           DISPLAY "Total after arithmetic: " WS-TOTAL.
       
           *> ROUNDED rounds the result to the receiving field's precision
           COMPUTE WS-AVERAGE ROUNDED = WS-TOTAL / 2
           DISPLAY "Rounded average: " WS-AVERAGE.
       
           DISPLAY "Signed number: " WS-SIGNED-NUMBER.
           DISPLAY "".
       
       *> ------------------------------------------------------------
       *> ACCEPT reads keyboard input
       *> ------------------------------------------------------------
       2000-DEMONSTRATE-INPUT.
           DISPLAY "2. INPUT".
       
           DISPLAY "Enter your name: " WITH NO ADVANCING.
           ACCEPT WS-USER-INPUT.
       
           DISPLAY "Hello, " FUNCTION TRIM(WS-USER-INPUT) "!".
       
           *> FUNCTION TRIM removes leading and trailing spaces
           *> This example uses a fixed value so the program can run unattended
           MOVE "B" TO WS-GRADE
           DISPLAY "Grade used for decision example: " WS-GRADE.
           DISPLAY "".
       
       *> ------------------------------------------------------------
       *> IF and EVALUATE
       *> ------------------------------------------------------------
       3000-DEMONSTRATE-DECISIONS.
           DISPLAY "3. DECISIONS".
       
           *> IF ... ELSE ... END-IF
           IF WS-PAY > 500
               DISPLAY "Pay is greater than 500."
           ELSE
               DISPLAY "Pay is 500 or less."
           END-IF.
       
           *> EVALUATE is COBOL's multi-way branch
           EVALUATE WS-GRADE
               WHEN "A"
                   MOVE "Excellent" TO WS-STATUS-TEXT
               WHEN "B"
                   MOVE "Good" TO WS-STATUS-TEXT
               WHEN "C"
                   MOVE "Satisfactory" TO WS-STATUS-TEXT
               WHEN OTHER
                   MOVE "Unknown grade" TO WS-STATUS-TEXT
           END-EVALUATE.
       
           DISPLAY "Grade result: " WS-STATUS-TEXT.
           DISPLAY "".
       
       *> ------------------------------------------------------------
       *> PERFORM loops
       *> ------------------------------------------------------------
       4000-DEMONSTRATE-LOOPS.
           DISPLAY "4. LOOPS".
       
           *> PERFORM UNTIL repeats until the condition becomes true
           MOVE 1 TO WS-COUNTER.
           PERFORM UNTIL WS-COUNTER > 3
               DISPLAY "Loop count: " WS-COUNTER
               ADD 1 TO WS-COUNTER
           END-PERFORM.
       
           *> PERFORM VARYING is a counted loop
           PERFORM VARYING WS-COUNTER FROM 1 BY 1
               UNTIL WS-COUNTER > 3
               DISPLAY "Varying loop: " WS-COUNTER
           END-PERFORM.
       
           *> PERFORM ... TIMES runs a paragraph a fixed number of times
           PERFORM 4100-SHOW-MESSAGE 2 TIMES.
       
           DISPLAY "".
       
       4100-SHOW-MESSAGE.
           DISPLAY "This paragraph was performed by PERFORM ... TIMES."
       
       *> ------------------------------------------------------------
       *> Sequential file: create, read, display, close
       *> ------------------------------------------------------------
       5000-DEMONSTRATE-FILE.
           DISPLAY "5. SEQUENTIAL FILE".
       
           *> OPEN OUTPUT creates or replaces employees.dat
           OPEN OUTPUT EMPLOYEE-FILE.
       
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "Could not open file for output. Status: "
                   WS-FILE-STATUS
               GOBACK
           END-IF.
       
           *> Build and write three records
           MOVE 00001 TO EMP-ID
           MOVE "Alice Smith" TO EMP-NAME
           MOVE 52000.00 TO EMP-SALARY
           WRITE EMPLOYEE-RECORD
       
           MOVE 00002 TO EMP-ID
           MOVE "Bob Jones" TO EMP-NAME
           MOVE 61000.50 TO EMP-SALARY
           WRITE EMPLOYEE-RECORD
       
           MOVE 00003 TO EMP-ID
           MOVE "Carol Lee" TO EMP-NAME
           MOVE 48750.25 TO EMP-SALARY
           WRITE EMPLOYEE-RECORD
       
           CLOSE EMPLOYEE-FILE.
       
           *> Reopen the file for reading
           OPEN INPUT EMPLOYEE-FILE.
       
           IF WS-FILE-STATUS NOT = "00"
               DISPLAY "Could not open file for input. Status: "
                   WS-FILE-STATUS
               GOBACK
           END-IF.
       
           *> READ one record; AT END runs when no more records remain
           READ EMPLOYEE-FILE
               AT END
                   DISPLAY "No records found."
               NOT AT END
                   DISPLAY "Employee " EMP-ID
                   DISPLAY "Name: " EMP-NAME
                   DISPLAY "Salary: " EMP-SALARY
           END-READ.
       
           CLOSE EMPLOYEE-FILE.
           DISPLAY "".
       