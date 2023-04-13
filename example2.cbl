       IDENTIFICATION DIVISION.
       PROGRAM-ID.    "NEWSALE".
       DATA DIVISION.

       WORKING-STORAGE SECTION.
       01  INSERT-STMT.
           05  FILLER   PIC X(24) VALUE "INSERT INTO SALES (SALES".
           05  FILLER   PIC X(24) VALUE "_PERSON,SALES) VALUES ('".
           05  SPERSON  PIC X(16).
           05  FILLER   PIC X(2) VALUE "',".
           05  SQTY     PIC S9(9).
           05  FILLER   PIC X(1) VALUE ")".
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  INS-SMT-INF.
           05  INS-STMT.
           49  INS-LEN   PIC S9(4) USAGE COMP.
           49  INS-TEXT  PIC X(100).
       01  SALESSUM      PIC S9(9)  USAGE COMP-5.
           EXEC SQL END DECLARE SECTION END-EXEC.
           EXEC SQL INCLUDE SQLCA END-EXEC.

       LINKAGE SECTION.
       01  IN-SPERSON    PIC X(15).
       01  IN-SQTY       PIC S9(9)  USAGE COMP-5.
       01  OUT-SALESSUM  PIC S9(9)  USAGE COMP-5.

       PROCEDURE DIVISION USING IN-SPERSON
                                IN-SQTY 
                                OUT-SALESSUM.
       MAINLINE.
           MOVE 0 TO SQLCODE.
           PERFORM INSERT-ROW.
           IF SQLCODE IS NOT EQUAL TO 0
              GOBACK
           END-IF.
           PERFORM SELECT-ROWS.
           PERFORM GET-SUM.
           GOBACK.
       INSERT-ROW.
           MOVE IN-SPERSON TO SPERSON.
           MOVE IN-SQTY TO SQTY.
           MOVE           INSERT-STMT TO INS-TEXT.
           MOVE LENGTH OF INSERT-STMT TO INS-LEN.
           EXEC SQL EXECUTE IMMEDIATE :INS-STMT END-EXEC.
       GET-SUM.
           EXEC SQL
              SELECT SUM(SALES) INTO :SALESSUM FROM SALES
           END-EXEC.
           MOVE SALESSUM TO OUT-SALESSUM.
       SELECT-ROWS.
           EXEC SQL
              DECLARE CUR CURSOR WITH RETURN FOR SELECT * FROM SALES
           END-EXEC.
           IF SQLCODE = 0
              EXEC SQL OPEN CUR END-EXEC
           END-IF.