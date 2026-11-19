| Feature        | Example                          | Meaning                               |
| -------------- | -------------------------------- | ------------------------------------- |
| Comment        | *> note                          | Compiler ignores the rest of the line |
| Numeric field  | PIC 9(7)V99                      | Up to 7 digits plus 2 decimal places  |
| Signed number  | PIC S9(5)V99                     | Numeric field that can be negative    |
| Text field     | PIC X(20)                        | Fixed-length character field          |
| Constant       | VALUE "Example Company"          | Initial/default value                 |
| Assignment     | MOVE 40.00 TO WS-HOURS           | Copies a value into a field           |
| Calculation    | COMPUTE WS-PAY = ...             | Evaluates an expression               |
| Input          | ACCEPT WS-USER-INPUT             | Reads keyboard input                  |
| Output         | DISPLAY "text"                   | Writes to the terminal                |
| Decision       | IF ... END-IF                    | Conditional logic                     |
| Multi-branch   | EVALUATE ... END-EVALUATE        | Cleaner alternative to nested IFs     |
| Loop           | PERFORM UNTIL                    | Repeats until a condition is true     |
| Counted loop   | PERFORM VARYING                  | Repeats with a changing counter       |
| Paragraph call | PERFORM 4100-SHOW-MESSAGE        | Runs a named section of code          |
| File           | SELECT, OPEN, WRITE, READ, CLOSE | Sequential file operations            |

GnuCOBOL supports ACCEPT, DISPLAY, IF, EVALUATE, PERFORM, and sequential-file operations through SELECT, OPEN, READ, WRITE, and CLOSE; the official FAQ also documents EVALUATE ... WHEN OTHER and explicit scope terminators such as END-IF, END-PERFORM, and END-EVALUATE.
