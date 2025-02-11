IDENTIFICATION DIVISION.
PROGRAM-ID. EMPLOYEE-REPORT.
AUTHOR. ASHLEY CHANCE.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT EMP-FILE ASSIGN TO "EMPLOYEES.IN"
        ORGANIZATION IS LINE SEQUENTIAL.
    SELECT REPORT-FILE ASSIGN TO "REPORT.OUT"
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD EMP-FILE.
01 EMP-RECORD.
   05 EMP-ID     PIC X(10).
   05 EMP-NAME   PIC X(30).
   05 EMP-SALARY PIC 9(6).

FD REPORT-FILE.
01 REPORT-RECORD PIC X(80).

WORKING-STORAGE SECTION.
01 WS-THRESHOLD        PIC 9(6) VALUE 50000.
01 WS-REPORT-LINE      PIC X(80).
01 WS-EOF              PIC X VALUE "N".

PROCEDURE DIVISION.
    OPEN INPUT EMP-FILE
         OUTPUT REPORT-FILE
    PERFORM UNTIL WS-EOF = "Y"
        READ EMP-FILE INTO EMP-RECORD
           AT END
               MOVE "Y" TO WS-EOF
           NOT AT END
               IF EMP-SALARY > WS-THRESHOLD
                   STRING EMP-ID SPACE EMP-NAME SPACE EMP-SALARY
                       DELIMITED BY SIZE INTO WS-REPORT-LINE
                   WRITE REPORT-RECORD FROM WS-REPORT-LINE
               END-IF
        END-READ
    END-PERFORM
    CLOSE EMP-FILE REPORT-FILE
    DISPLAY "Report generated successfully!"
    STOP RUN.
