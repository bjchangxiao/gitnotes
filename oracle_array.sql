--ASSOCIATIVE ARRAYS

DECLARE
  TYPE POPULATION IS TABLE OF NUMBER INDEX BY VARCHAR2(54);
  CITY_POPULATION POPULATION;
  I               VARCHAR2(64);
BEGIN
  CITY_POPULATION('SMALLVILLE') := 2000;
  CITY_POPULATION('MIDLAND') := 750000;
  CITY_POPULATION('MEGALOPOLIS') := 1000000;
  CITY_POPULATION('SMALLVILLE') := 2001;
  I := CITY_POPULATION.FIRST;
  WHILE I IS NOT NULL LOOP
    DBMS_OUTPUT.PUT_LINE('POPULATION OF ' || I || ' IS ' ||
                         CITY_POPULATION(I));
    I := CITY_POPULATION.NEXT(I);
  END LOOP;
END;
----------------------------------------------------------
--ASSOCIATIVE ARRAYS

DECLARE
  TYPE SUM_MULTIPLES IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  N  PLS_INTEGER := 5;
  SN PLS_INTEGER :=10;
  M  PLS_INTEGER := 3;
  FUNCTION GET_SUM_MULTIPLES(MULTIPLE IN PLS_INTEGER, NUM IN PLS_INTEGER)
    RETURN SUM_MULTIPLES AS
    S SUM_MULTIPLES;
  BEGIN
    FOR I IN 1 .. NUM LOOP
      S(I) := MULTIPLE * ((I * (I + 1)) / 2);
    END LOOP;
    RETURN S;
  END GET_SUM_MULTIPLES;
BEGIN
  FOR I IN 1..SN LOOP
  DBMS_OUTPUT.PUT_LINE('Sum of the first ' || TO_CHAR(N) ||
                       ' multiples of ' || TO_CHAR(M) || ' is ' ||
                       TO_CHAR(GET_SUM_MULTIPLES(M, SN) (I)));
  END LOOP;
END;
/
----------------------------------------------------------
--ASSOCIATIVE VARRAYS
DROP PACKAGE MY_TYPES;

CREATE OR REPLACE PACKAGE MY_TYPES AUTHID CURRENT_USER IS 
TYPE MY_AA IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
FUNCTION INIT_MY_AA RETURN MY_AA;
END MY_TYPES;
/
CREATE OR REPLACE PACKAGE BODY MY_TYPES IS
  FUNCTION INIT_MY_AA RETURN MY_AA IS
    RET MY_AA;
  BEGIN
    Ret(-10) := '-ten';
    Ret(0) := 'zero';
    Ret(1) := 'one';
    Ret(2) := 'two';
    Ret(3) := 'three';
    Ret(4) := 'four';
    Ret(9) := 'nine';
    RETURN Ret;
  END Init_My_AA;
END My_Types;
/

DECLARE
  V CONSTANT MY_TYPES.MY_AA := MY_TYPES.INIT_MY_AA();
BEGIN
  DECLARE
    IDX PLS_INTEGER := V.FIRST();
  BEGIN
    WHILE IDX IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(IDX, '999') || LPAD(V(IDX), 7));
      IDX := V.NEXT(IDX);
    END LOOP;
  END;
END;
/
----------------------------------------------------------    
--VARRAY
DECLARE
  TYPE FOURSOME IS VARRAY(4) OF VARCHAR2(15);
  TEAM FOURSOME := FOURSOME('JOHN', 'MARY', 'ALBERTO', 'JUANITA');
  PROCEDURE PRINT_TEAM(HEADING VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(HEADING);
    FOR I IN 1 .. 4 LOOP
      DBMS_OUTPUT.PUT_LINE(I || '.' || TEAM(I));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---');
  END;
BEGIN
  PRINT_TEAM('2001 TEAM:');
  TEAM(3) := 'PIERRE';
  TEAM(4) := 'YVONNE';
  PRINT_TEAM('2005 TEAM:');
  TEAM := FOURSOME('ARUN', 'AMITHA', 'ALLAN', 'MAE');
  PRINT_TEAM('2009 TEAM:');
END;
/
----------------------------------------------------------    
--NESTED TABLE
DECLARE
  TYPE ROSTER IS TABLE OF VARCHAR2(15);
  NAMES ROSTER := ROSTER('D CARUSO', 'J HAMIL', 'D PIRO', 'R SINGH');
  PROCEDURE PRINT_NAMES(HEADING VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(HEADING);
    FOR I IN NAMES.FIRST .. NAMES.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(NAMES(I));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('---');
  END;
BEGIN
  PRINT_NAMES('INITIAL VALUES:');
  NAMES(3) := 'P PEREZ';
  PRINT_NAMES('CURRENT VALUES:');
  NAMES := ROSTER('A JANSEN', 'B GUPTA');
  PRINT_NAMES('CURRENT VALUES:');
END;

----------------------------------------------------------    
--NESTED TABLE
DROP TYPE NT_TYPE;
CREATE OR REPLACE TYPE NT_TYPE IS TABLE OF NUMBER;
DROP PROCEDURE PRINT_NT;
CREATE OR REPLACE PROCEDURE PRINT_NT(NT NT_TYPE) AUTHID DEFINER IS
  I NUMBER;
BEGIN
  I := NT.FIRST;
  IF I IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('NT IS EMPTY');
  ELSE
    WHILE I IS NOT NULL LOOP
      DBMS_OUTPUT.PUT('NT.(' || I || ')=');
      DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(NT(I)), 'NULL'));
      I := NT.NEXT(I);
    END LOOP;
  END IF;
  DBMS_OUTPUT.PUT_LINE('---');
END PRINT_NT;
/
DECLARE
 NT NT_TYPE := NT_TYPE();
BEGIN
 PRINT_NT(NT);
 NT := NT_TYPE(90, 9, 29, 58);
 PRINT_NT(NT);
END;
/
----------------------------------------------------------
--Conceptually, a nested table is like a one-dimensional array with an arbitrary number
--of elements. However, a nested table differs from an array in these important ways:
--• An array has a declared number of elements, but a nested table does not. The
--  size of a nested table can increase dynamically.
--• An array is always dense. A nested array is dense initially, but it can become
--  sparse, because you can delete elements from it.

--A nested table is appropriate when:
--• The number of elements is not set.
--• Index values are not consecutive.
--• You must delete or update some elements, but not all elements simultaneously.
--  Nested table data is stored in a separate store table, a system-generated
--  database table. When you access a nested table, the database joins the nested
--  table with its store table. This makes nested tables suitable for queries and
--  updates that affect only some elements of the collection.
--• You would create a separate lookup table, with multiple entries for each row of the
--   main table, and access it through join queries.
---------------------------------------------------------- 
--Initializing Collection (Varray) Variable to Empty   
DECLARE
  TYPE FOURSOME IS VARRAY(4) OF VARCHAR2(15);
  TEAM FOURSOME := FOURSOME(); --INITIALIZE TO EMPTY
  PROCEDURE PRINT_TEAM(HEADING VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(HEADING);
    IF TEAM.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('EMPTY');
    ELSE
      FOR I IN 1 .. 4 LOOP
        DBMS_OUTPUT.PUT_LINE(I || '.' || TEAM(I));
      END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('---');
  END;
BEGIN
  PRINT_TEAM('TEAM:');
  TEAM := FOURSOME('JOHN', 'MARY', 'ALBERTO', 'JUANITA');
  PRINT_TEAM('TEAM:');
END;

----------------------------------------------------------
--only oracle 19c 
DROP PACKAGE PKG;
CREATE PACKAGE PKG IS
TYPE REC_T IS RECORD(YEAR PLS_INTEGER:=2,NAME VARCHAR2(100));
END;

DECLARE
  V_REC1 PKG.REC_T := PKG.REC_T(1847, 'ONE EIGHT FOUR SEVEN');
  V_REC2 PKG.REC_T := PKG.REC_T(YEAR => 1, NAME => 'ONE');
  V_REC3 PKG.REC_T := PKG.REC_T(NULL, NULL);
  PROCEDURE PRINT_REC(PI_REC PKG.REC_T := PKG.REC_T(1847 + 1, 'A' || 'B')) IS
    V_REC1 PKG.REC_T := PKG.REC_T(2847, 'TOWN EIGHT FOUR SEVEN');
  BEGIN
    DBMS_OUTPUT.PUT_LINE(NVL(v_rec1.year, 0) || ' ' ||
                         NVL(v_rec1.name, 'N/A'));
    DBMS_OUTPUT.PUT_LINE(NVL(pi_rec.year, 0) || ' ' ||
                         NVL(pi_rec.name, 'N/A'));
  END;
BEGIN
  print_rec(v_rec1);
  print_rec(v_rec2);
  print_rec(v_rec3);
  print_rec();
END;
   
---------------------------------------------------------- 
--only oracle 19c
DROP FUNCTION PRINT_BOOL;
CREATE OR REPLACE FUNCTION PRINT_BOOL(V IN BOOLEAN)
RETURN VARCHAR2
IS
V_RTN VARCHAR2(10);
BEGIN
  CASE V
    WHEN TRUE THEN
      V_RTN:='TRUE';
    WHEN FALSE THEN
      V_RTN:='FALSE';
    ELSE
      V_RTN:='NULL';
  END CASE;
  RETURN V_RTN;
END PRINT_BOOL;

DECLARE
  TYPE T_AA IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
  V_AA1 T_AA := T_AA(1 => FALSE, 2 => TRUE, 3 => NULL);
BEGIN
  DBMS_OUTPUT.PUT_LINE(print_bool(v_aa1(1)));
  DBMS_OUTPUT.PUT_LINE(print_bool(v_aa1(2)));
  DBMS_OUTPUT.PUT_LINE(print_bool(v_aa1(3)));
END;
   
----------------------------------------------------------
DECLARE
  TYPE TRIPLET IS VARRAY(3) OF VARCHAR2(15);
  TYPE TRIO IS VARRAY(3) OF VARCHAR2(15);
  GROUP1 TRIPLET := TRIPLET('JONES', 'WONG', 'MARCEAU');
  GROUP2 TRIPLET;
  GROUP3 TRIO;
BEGIN
  GROUP2 := GROUP1;
  GROUP3 := GROUP1;
END;
/
   
----------------------------------------------------------  
 DECLARE
   TYPE DNAMES_TAB IS TABLE OF VARCHAR2(30);
   DEPT_NAMES DNAMES_TAB := DNAMES_TAB('SHIPPING',
                                       'SALES',
                                       'FINANCE',
                                       'PAYROLL');
   EMPTY_SET  DNAMES_TAB;
   PROCEDURE PRINT_DEPT_NAMES_STATUS IS
   BEGIN
     IF DEPT_NAMES IS NULL THEN
       DBMS_OUTPUT.PUT_LINE('DEPT_NAMES IS NULL.');
     ELSE
       DBMS_OUTPUT.PUT_LINE('DEPT_NAMES IS NOT NULL.');
     END IF;
   END;
 BEGIN
   PRINT_DEPT_NAMES_STATUS;
   DEPT_NAMES:=EMPTY_SET;
   PRINT_DEPT_NAMES_STATUS;
   DEPT_NAMES := DNAMES_TAB('SHIPPING', 'SALES', 'FINANCE', 'PAYROLL');
   PRINT_DEPT_NAMES_STATUS;
 END;
----------------------------------------------------------    
DECLARE
  TYPE NESTED_TYP IS TABLE OF NUMBER;
  NT1    NESTED_TYP := NESTED_TYP(1, 2, 3);
  NT2    NESTED_TYP := NESTED_TYP(3, 2, 1);
  NT3    NESTED_TYP := NESTED_TYP(2, 3, 1, 3);
  NT4    NESTED_TYP := NESTED_TYP(1, 2, 4);
  ANSWER NESTED_TYP;
  PROCEDURE PRINT_NESTED_TABLE(NT NESTED_TYP) IS
    OUTPUT VARCHAR2(128);
  BEGIN
    IF NT IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('RESULT:NULL SET');
    ELSIF NT.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('RESUTL EMPTY SET');
    ELSE
      FOR I IN NT.FIRST .. NT.LAST LOOP
        OUTPUT := OUTPUT || NT(I) || ' ';
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('RESULT:' || OUTPUT);
    END IF;
  END;
BEGIN
  ANSWER := NT1 MULTISET UNION NT4;
  print_nested_table(ANSWER);
  ANSWER := NT1 MULTISET UNION NT3;
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER := NT1 MULTISET UNION DISTINCT NT3;
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER := NT2 MULTISET INTERSECT NT3;
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER := NT2 MULTISET INTERSECT DISTINCT NT3;
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER:=SET(NT3);
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER := NT3 MULTISET EXCEPT NT2;
  PRINT_NESTED_TABLE(ANSWER);
  ANSWER := NT3 MULTISET EXCEPT DISTINCT NT2;
  PRINT_NESTED_TABLE(ANSWER);
END;
---------------------------------------------------------- 
--Two-Dimensional Varray (Varray of Varrays)
DECLARE
  TYPE T1 IS VARRAY(10) OF INTEGER;
  VA T1 := T1(2, 3, 5);
  TYPE NT1 IS VARRAY(10) OF T1;
  NVA NT1 := NT1(VA, T1(55, 6, 73), T1(2, 4), VA);
  I   INTEGER;
  VAL T1;
BEGIN
  I := NVA(2) (3);
  DBMS_OUTPUT.PUT_LINE('I=' || I);
  NVA.EXTEND;
  NVA(5) := T1(56, 32);
  NVA(4) := T1(45, 43, 67, 4335);
  NVA(4)(4) := 1;
  NVA(4).EXTEND;
  NVA(4)(5) := 89;
END;
/

----------------------------------------------------------    
--Nested Tables of Nested Tables and Varrays of Integers

DECLARE
  TYPE TB1 IS TABLE OF VARCHAR2(20);
  VTB1 TB1 := TB1('ONE', 'TWO');
  TYPE NTB1 IS TABLE OF TB1;
  VNTB1 NTB1 := NTB1(VTB1);
  TYPE TV1 IS VARRAY(10) OF INTEGER;
  TYPE NTB2 IS TABLE OF TV1;
  VNTB2 NTB2 := NTB2(TV1(3, 5), TV1(5, 7, 3));
BEGIN
  VNTB1.EXTEND;
  VNTB1(2) := VNTB1(1);
  VNTB1.DELETE(1);
  VNTB1(2).DELETE(1);
END;


----------------------------------------------------------  
--Nested Tables of Associative Arrays and Varrays of Strings
DECLARE
  TYPE tb1 IS TABLE OF INTEGER INDEX BY PLS_INTEGER; -- associative arrays
  v4 tb1;
  v5 tb1;
  TYPE aa1 IS TABLE OF tb1 INDEX BY PLS_INTEGER; -- associative array of
  v2 aa1; -- associative arrays
  TYPE va1 IS VARRAY(10) OF VARCHAR2(20); -- varray of strings
  v1 va1 := va1('hello', 'world');
  TYPE ntb2 IS TABLE OF va1 INDEX BY PLS_INTEGER; -- associative array of varrays
  v3 ntb2;
BEGIN
  v4(1) := 34; -- populate associative array
  v4(2) := 46456;
  v4(456) := 343;
  v2(23) := v4; -- populate associative array of associative arrays
  v3(34) := va1(33, 456, 656, 343); -- populate associative array varrays
  v2(35) := v5; -- assign empty associative array to v2(35)
  v2(35)(2) := 78;
END;

  
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    















































































