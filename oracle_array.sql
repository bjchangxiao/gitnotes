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
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
----------------------------------------------------------    
































































