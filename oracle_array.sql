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
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15); -- VARRAY type
  team Foursome; -- varray variable
  TYPE Roster IS TABLE OF VARCHAR2(15); -- nested table type
  names Roster := Roster('Adams', 'Patel'); -- nested table variable
BEGIN
  IF team IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('team IS NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('team IS NOT NULL');
  END IF;
  IF names IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('names IS NOT NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('names IS NULL');
  END IF;
END;
/
---------------------------------------------------------- 
DECLARE
  TYPE dnames_tab IS TABLE OF VARCHAR2(30); -- element type is not record type
  dept_names1 dnames_tab := dnames_tab('Shipping',
                                       'Sales',
                                       'Finance',
                                       'Payroll');
  dept_names2 dnames_tab := dnames_tab('Sales',
                                       'Finance',
                                       'Shipping',
                                       'Payroll');
  dept_names3 dnames_tab := dnames_tab('Sales', 'Finance', 'Payroll');
BEGIN
  IF dept_names1 = dept_names2 THEN
    DBMS_OUTPUT.PUT_LINE('dept_names1 = dept_names2');
  END IF;
  IF dept_names2 != dept_names3 THEN
    DBMS_OUTPUT.PUT_LINE('dept_names2 != dept_names3');
  END IF;
END;
/
---------------------------------------------------------- 
DECLARE
  TYPE nested_typ IS TABLE OF NUMBER;
  nt1 nested_typ := nested_typ(1, 2, 3);
  nt2 nested_typ := nested_typ(3, 2, 1);
  nt3 nested_typ := nested_typ(2, 3, 1, 3);
  nt4 nested_typ := nested_typ(1, 2, 4);
  PROCEDURE testify(truth BOOLEAN := NULL, quantity NUMBER := NULL) IS
  BEGIN
    IF truth IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(CASE truth
                             WHEN TRUE THEN
                              'True'
                             WHEN FALSE THEN
                              'False'
                           END);
    END IF;
    IF quantity IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE(quantity);
    END IF;
  END;
BEGIN
  testify(truth => (nt1 IN (nt2, nt3, nt4))); -- condition
  testify(truth => (nt1 SUBMULTISET OF nt3)); -- condition
  testify(truth => (nt1 NOT SUBMULTISET OF nt4)); -- condition
  testify(truth => (4 MEMBER OF nt1)); -- condition
  testify(truth => (nt3 IS A SET)); -- condition
  testify(truth => (nt3 IS NOT A SET)); -- condition
  testify(truth => (nt1 IS EMPTY)); -- condition
  testify(quantity => (CARDINALITY(nt3))); -- function
  testify(quantity => (CARDINALITY(SET(nt3)))); -- 2 functions
END;
/
----------------------------------------------------------
CREATE OR REPLACE TYPE nt_type IS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE print_nt(nt nt_type) AUTHID DEFINER IS
  i NUMBER;
BEGIN
  i := nt.FIRST;
  IF i IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('nt is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      DBMS_OUTPUT.PUT('nt.(' || i || ') = ');
      DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt(i)), 'NULL'));
      i := nt.NEXT(i);
    END LOOP;
  END IF;
  DBMS_OUTPUT.PUT_LINE('---');
END print_nt;
/
--DELETE Method with Nested Table
DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);
  nt.DELETE(2); -- Delete second element
  print_nt(nt);
  nt(2) := 2222; -- Restore second element
  print_nt(nt);
  nt.DELETE(2, 4); -- Delete range of elements
  print_nt(nt);
  nt(3) := 3333; -- Restore third element
  print_nt(nt);
  nt.DELETE; -- Delete all elements
  print_nt(nt);
END;
/
---------------------------------------------------------- 
--DELETE Method with Associative Array Indexed by String
DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str aa_type_str;
  PROCEDURE print_aa_str IS
    i VARCHAR2(10);
  BEGIN
    i := aa_str.FIRST;
    IF i IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('aa_str is empty');
    ELSE
      WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT('aa_str.(' || i || ') = ');
        DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(aa_str(i)), 'NULL'));
        i := aa_str.NEXT(i);
      END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('---');
  END print_aa_str;
BEGIN
  aa_str('M') := 13;
  aa_str('Z') := 26;
  aa_str('C') := 3;
  print_aa_str;
  aa_str.DELETE; -- Delete all elements
  print_aa_str;
  aa_str('M') := 13;  -- Replace deleted element with same value
  aa_str('Z') := 260; -- Replace deleted element with new value
  aa_str('C') := 30;  -- Replace deleted element with new value
  aa_str('W') := 23;  -- Add new element
  aa_str('J') := 10;  -- Add new element
  aa_str('N') := 14;  -- Add new element
  aa_str('P') := 16;  -- Add new element
  aa_str('W') := 23;  -- Add new element
  aa_str('J') := 10;  -- Add new element
  print_aa_str;
  aa_str.DELETE('C'); -- Delete one element
  print_aa_str;
  aa_str.DELETE('N', 'W'); -- Delete range of elements
  print_aa_str;
  aa_str.DELETE('Z', 'M'); -- Does nothing
  print_aa_str;
END;
/
----------------------------------------------------------    
--• TRIM removes one element from the end of the collection, if the collection has at
--least one element; otherwise, it raises the predefined exception
--SUBSCRIPT_BEYOND_COUNT.
--• TRIM(n) removes n elements from the end of the collection, if there are at least n
--elements at the end; otherwise, it raises the predefined exception
--SUBSCRIPT_BEYOND_COUNT.
DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);
  nt.TRIM; -- Trim last element
  print_nt(nt);
  nt.DELETE(4); -- Delete fourth element
  print_nt(nt);
  nt.TRIM(2); -- Trim last two elements
  print_nt(nt);
END;
/
----------------------------------------------------------
--The EXTEND method has these forms:
--• EXTEND appends one null element to the collection.
--• EXTEND(n) appends n null elements to the collection.
--• EXTEND(n,i) appends n copies of the ith element to the collection. 

--EXTEND Method with Nested Table 
DECLARE
  nt nt_type := nt_type(11, 22, 33);
BEGIN
  print_nt(nt);
  nt.EXTEND(2, 1); -- Append two copies of first element
  print_nt(nt);
  nt.DELETE(5); -- Delete fifth element
  print_nt(nt);
  nt.EXTEND; -- Append one null element
  print_nt(nt);
END;
/
----------------------------------------------------------
--EXISTS Method with Nested Table
DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1, 3, 5, 7);
BEGIN
  n.DELETE(2); -- Delete second element
  FOR i IN 1 .. 6 LOOP
    IF n.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') = ' || n(i));
    ELSE
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/
---------------------------------------------------------- 
--FIRST and LAST Values for Associative Array Indexed by PLS_INTEGER
DECLARE
  TYPE aa_type_int IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa_int aa_type_int;
  PROCEDURE print_first_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('FIRST = ' || aa_int.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST = ' || aa_int.LAST);
  END print_first_and_last;
BEGIN
  aa_int(1) := 3;
  aa_int(2) := 6;
  aa_int(3) := 9;
  aa_int(4) := 12;
  DBMS_OUTPUT.PUT_LINE('Before deletions:');
  print_first_and_last;
  aa_int.DELETE(1);
  aa_int.DELETE(4);
  DBMS_OUTPUT.PUT_LINE('After deletions:');
  print_first_and_last;
END;
/
---------------------------------------------------------- 
--FIRST and LAST Values for Associative Array Indexed by String
DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str aa_type_str;
  PROCEDURE print_first_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('FIRST = ' || aa_str.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST = ' || aa_str.LAST);
  END print_first_and_last;
BEGIN
  aa_str('Z') := 26;
  aa_str('A') := 1;
  aa_str('K') := 11;
  aa_str('R') := 18;
  DBMS_OUTPUT.PUT_LINE('Before deletions:');
  print_first_and_last;
  aa_str.DELETE('A');
  aa_str.DELETE('Z');
  DBMS_OUTPUT.PUT_LINE('After deletions:');
  print_first_and_last;
END;
/
---------------------------------------------------------- 
--Printing Varray with FIRST and LAST in FOR LOOP
DECLARE
  TYPE team_type IS VARRAY(4) OF VARCHAR2(15);
  team team_type;
  PROCEDURE print_team(heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
    IF team IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Has no members');
    ELSE
      FOR i IN team.FIRST .. team.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || team(i));
      END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('---');
  END;
BEGIN
  print_team('Team Status:');
  team := team_type(); -- Team is funded, but nobody is on it.
  print_team('Team Status:');
  team := team_type('John', 'Mary'); -- Put 2 members on team.
  print_team('Initial Team:');
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae'); -- Change team.
  print_team('New Team:');
END;
/
---------------------------------------------------------- 
--Printing Nested Table with FIRST and LAST in FOR LOOP
DECLARE
  TYPE team_type IS TABLE OF VARCHAR2(15);
  team team_type;
  PROCEDURE print_team(heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
    IF team IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Has no members');
    ELSE
      FOR i IN team.FIRST .. team.LAST LOOP
        DBMS_OUTPUT.PUT(i || '. ');
        IF team.EXISTS(i) THEN
          DBMS_OUTPUT.PUT_LINE(team(i));
        ELSE
          DBMS_OUTPUT.PUT_LINE('(to be hired)');
        END IF;
      END LOOP;
    END IF;
    DBMS_OUTPUT.PUT_LINE('---');
  END;
BEGIN
  print_team('Team Status:');
  team := team_type(); -- Team is funded, but nobody is on it.
  print_team('Team Status:');
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae'); -- Add members.
  print_team('Initial Team:');
  team.DELETE(2, 3); -- Remove 2nd and 3rd members.
  print_team('Current Team:');
END;
/
---------------------------------------------------------- 
--COUNT and LAST Values for Varray
DECLARE
  TYPE NumList IS VARRAY(10) OF INTEGER;
  n NumList := NumList(1, 3, 5, 7);
  PROCEDURE print_count_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT('n.COUNT = ' || n.COUNT || ', ');
    DBMS_OUTPUT.PUT_LINE('n.LAST = ' || n.LAST);
  END print_count_and_last;
BEGIN
  print_count_and_last;
  n.EXTEND(3);
  print_count_and_last;
  n.TRIM(5);
  print_count_and_last;
end;
/
---------------------------------------------------------- 
--COUNT and LAST Values for Nested Table
DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1, 3, 5, 7);
  PROCEDURE print_count_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT('n.COUNT = ' || n.COUNT || ', ');
    DBMS_OUTPUT.PUT_LINE('n.LAST = ' || n.LAST);
  END print_count_and_last;
BEGIN
  print_count_and_last;
  n.DELETE(3); -- Delete third element
  print_count_and_last;
  n.EXTEND(2); -- Add two null elements to end
  print_count_and_last;
  FOR i IN 1 .. 8 LOOP
    IF n.EXISTS(i) THEN
      IF n(i) IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('n(' || i || ') = ' || n(i));
      ELSE
        DBMS_OUTPUT.PUT_LINE('n(' || i || ') = NULL');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/
----------------------------------------------------------
--LIMIT is a function that returns the maximum number of elements that the collection
--can have. If the collection has no maximum number of elements, LIMIT returns NULL.
--Only a varray has a maximum size.

--LIMIT and COUNT Values for Different Collection Types
DECLARE
  TYPE aa_type IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa aa_type; -- associative array
  TYPE va_type IS VARRAY(4) OF INTEGER;
  va va_type := va_type(2, 4); -- varray
  TYPE nt_type IS TABLE OF INTEGER;
  nt nt_type := nt_type(1, 3, 5); -- nested table
BEGIN
  aa(1) := 3;
  aa(2) := 6;
  aa(3) := 9;
  aa(4) := 12;
  DBMS_OUTPUT.PUT('aa.COUNT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(aa.COUNT), 'NULL'));
  DBMS_OUTPUT.PUT('aa.LIMIT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(aa.LIMIT), 'NULL'));
  DBMS_OUTPUT.PUT('va.COUNT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(va.COUNT), 'NULL'));
  DBMS_OUTPUT.PUT('va.LIMIT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(va.LIMIT), 'NULL'));
  DBMS_OUTPUT.PUT('nt.COUNT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt.COUNT), 'NULL'));
  DBMS_OUTPUT.PUT('nt.LIMIT = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt.LIMIT), 'NULL'));
END;
/
---------------------------------------------------------- 
DECLARE
  TYPE Arr_Type IS VARRAY(10) OF NUMBER;
  v_Numbers Arr_Type := Arr_Type();
BEGIN
  v_Numbers.EXTEND(4);
  v_Numbers(1) := 10;
  v_Numbers(2) := 20;
  v_Numbers(3) := 30;
  v_Numbers(4) := 40;
  DBMS_OUTPUT.PUT_LINE(NVL(v_Numbers.prior(3400), -1));
  DBMS_OUTPUT.PUT_LINE(NVL(v_Numbers.next(3400), -1));
END;
/
----------------------------------------------------------
DECLARE
  TYPE nt_type IS TABLE OF NUMBER;
  nt nt_type := nt_type(18, NULL, 36, 45, 54, 63);
BEGIN
  nt.DELETE(4);
  DBMS_OUTPUT.PUT_LINE('nt(4) was deleted.');
  FOR i IN 1 .. 7 LOOP
    DBMS_OUTPUT.PUT('nt.PRIOR(' || i || ') = ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt.PRIOR(i)), 'NULL'));
    DBMS_OUTPUT.PUT('nt.NEXT(' || i || ') = ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(nt.NEXT(i)), 'NULL'));
  END LOOP;
END;
/
---------------------------------------------------------- 
--Printing Elements of Sparse Nested Table
DECLARE
  TYPE NumList IS TABLE OF NUMBER;
  n   NumList := NumList(1, 2, NULL, NULL, 5, NULL, 7, 8, 9, NULL);
  idx INTEGER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('First to last:');
  idx := n.FIRST;
  WHILE idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT('n(' || idx || ') = ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(n(idx)), 'NULL'));
    idx := n.NEXT(idx);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------');
  DBMS_OUTPUT.PUT_LINE('Last to first:');
  idx := n.LAST;
  WHILE idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT('n(' || idx || ') = ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(n(idx)), 'NULL'));
    idx := n.PRIOR(idx);
  END LOOP;
END;
/
---------------------------------------------------------- 
CREATE OR REPLACE PACKAGE pkg AS
  TYPE NumList IS TABLE OF NUMBER;
  PROCEDURE print_numlist(nums NumList);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_numlist(nums NumList) IS
  BEGIN
    FOR i IN nums.FIRST .. nums.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(nums(i));
    END LOOP;
  END;
END pkg;
/
DECLARE
  TYPE NumList IS TABLE OF NUMBER; -- local type identical to package type
  n1 pkg.NumList := pkg.NumList(2, 4); -- package type
  n2 NumList := NumList(6, 8); -- local type
BEGIN
  pkg.print_numlist(n1); -- succeeds
  pkg.print_numlist(n2); -- fails
END;
/
----------------------------------------------------------
CREATE OR REPLACE TYPE NumList IS TABLE OF NUMBER;
-- standalone collection type identical to package type
/
DECLARE
  n1 pkg.NumList := pkg.NumList(2, 4); -- package type
  n2 NumList := NumList(6, 8); -- standalone type
BEGIN
  pkg.print_numlist(n1); -- succeeds
  pkg.print_numlist(n2); -- fails
END;
/
---------------------------------------------------------- 
--When declaring a record constant, you must create a function that populates the
--record with its initial value and then invoke the function in the constant declaration.

--Declaring Record Constant
DROP PACKAGE MY_TYPES;
CREATE OR REPLACE PACKAGE MY_TYPES AUTHID CURRENT_USER IS
TYPE MY_REC IS RECORD(A NUMBER,B NUMBER);
FUNCTION INIT_MY_REC RETURN MY_REC;
END MY_TYPES;
/
CREATE OR REPLACE PACKAGE BODY MY_TYPES IS 
FUNCTION INIT_MY_REC RETURN MY_REC IS
  REC MY_REC;
  BEGIN
    REC.A:=0;
    REC.B:=1;
    RETURN REC;
  END  INIT_MY_REC;
END MY_TYPES;
/
DECLARE
  r CONSTANT My_Types.My_Rec := My_Types.Init_My_Rec();
BEGIN
  DBMS_OUTPUT.PUT_LINE('r.a = ' || r.a);
  DBMS_OUTPUT.PUT_LINE('r.b = ' || r.b);
END;
/
----------------------------------------------------------    
--RECORD Type Definition and Variable Declaration
DECLARE
  TYPE DEPTRECTYP IS RECORD(
    DEPT_ID   NUMBER(4) NOT NULL := 10,
    DEPT_NAME VARCHAR2(30) NOT NULL := 'Administration',
    MGR_ID    NUMBER(6) := 200,
    LOC_ID    NUMBER(4) := 1700);
  DEPT_REC DEPTRECTYP;
BEGIN
  DBMS_OUTPUT.PUT_LINE('dept_id: ' || DEPT_REC.DEPT_ID);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || DEPT_REC.DEPT_NAME);
  DBMS_OUTPUT.PUT_LINE('mgr_id: ' || DEPT_REC.MGR_ID);
  DBMS_OUTPUT.PUT_LINE('loc_id: ' || DEPT_REC.LOC_ID);
END;
/
---------------------------------------------------------- 
--RECORD Type with RECORD Field (Nested Record)
DROP TABLE EMPLOYEES2;
CREATE TABLE EMPLOYEES2(
FIRST_NAME VARCHAR2(20),
LAST_NAME VARCHAR2(20),
PHONE_NUMBER VARCHAR2(50));

DECLARE
  TYPE name_rec IS RECORD(
    first employees2.first_name%TYPE,
    last  employees2.last_name%TYPE);
  TYPE contact IS RECORD(
    name  name_rec, -- nested record
    phone employees2.phone_number%TYPE);
  friend contact;
BEGIN
  friend.name.first := 'John';
  friend.name.last  := 'Smith';
  friend.phone      := '1-650-555-1234';
  DBMS_OUTPUT.PUT_LINE(friend.name.first || ' ' || friend.name.last || ', ' ||
                       friend.phone);
END;
/
DROP TABLE EMPLOYEES2;

----------------------------------------------------------
--RECORD Type with Varray Field
DROP TABLE EMPLOYEES2;
CREATE TABLE EMPLOYEES2(
FIRST_NAME VARCHAR2(20),
LAST_NAME VARCHAR2(20),
PHONE_NUMBER VARCHAR2(50));

DECLARE
  TYPE full_name IS VARRAY(2) OF VARCHAR2(20);
  TYPE contact IS RECORD(
    name  full_name := full_name('John', 'Smith'), -- varray field
    phone employees2.phone_number%TYPE);
  friend contact;
BEGIN
  friend.phone := '1-650-555-1234';
  DBMS_OUTPUT.PUT_LINE(friend.name(1) || ' ' || friend.name(2) || ', ' ||
                       friend.phone);
END;
/
DROP TABLE EMPLOYEES2;

---------------------------------------------------------- 
--Identically Defined Package and Local RECORD Types
CREATE OR REPLACE PACKAGE pkg AS
  TYPE rec_type IS RECORD( -- package RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4));
  PROCEDURE print_rec_type(rec rec_type);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
PROCEDURE print_rec_type(rec rec_type) IS
BEGIN
DBMS_OUTPUT.PUT_LINE(rec.f1); DBMS_OUTPUT.PUT_LINE(rec.f2);
END;
END pkg;
/
DECLARE
  TYPE rec_type IS RECORD( -- local RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4));
  r1 pkg.rec_type; -- package type
  r2 rec_type; -- local type
BEGIN
  r1.f1 := 10;
  r1.f2 := 'abcd';
  r2.f1 := 25;
  r2.f2 := 'wxyz';
  pkg.print_rec_type(r1); -- succeeds
  pkg.print_rec_type(r2); -- fails
END;
/
----------------------------------------------------------
--%ROWTYPE Variable Represents Full Database Table Row
DROP TABLE DEPARTMENTS PURGE;
CREATE TABLE DEPARTMENTS
(
DEPARTMENT_ID NUMBER,
DEPARTMENT_NAME VARCHAR2(200),
MANAGER_ID NUMBER,
LOCATION_ID NUMBER); 
DECLARE
  DEPT_REC DEPARTMENTS%ROWTYPE;
BEGIN
  DEPT_REC.DEPARTMENT_ID   := 10;
  DEPT_REC.DEPARTMENT_NAME := 'ADMINISTRATION';
  DEPT_REC.MANAGER_ID      := 200;
  DEPT_REC.LOCATION_ID     := 1700;
  DBMS_OUTPUT.PUT_LINE('dept_id: ' || dept_rec.department_id);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || dept_rec.department_name);
  DBMS_OUTPUT.PUT_LINE('mgr_id: ' || dept_rec.manager_id);
  DBMS_OUTPUT.PUT_LINE('loc_id: ' || dept_rec.location_id);
END;
/
DROP TABLE DEPARTMENTS PURGE;

---------------------------------------------------------- 
--%ROWTYPE Variable Does Not Inherit Initial Values or Constraints
DROP TABLE T1 PURGE;
CREATE TABLE T1(
C1 INTEGER DEFAULT 0 NOT NULL,
C2 INTEGER DEFAULT 1 NOT NULL
);
DECLARE
  T1_ROW T1%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT('T1.C1=');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(T1_ROW.C1), 'NULL'));
  DBMS_OUTPUT.PUT('T1.C2=');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(t1_row.c2), 'NULL'));
END;
/
DROP TABLE T1 PURGE;

----------------------------------------------------------
DROP TABLE EMPLOYEES PURGE;
CREATE TABLE EMPLOYEES 
(
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
PHONE_NUMBER VARCHAR2(50),
MID_NAME VARCHAR2(50)); 
DECLARE
  CURSOR C1 IS
    SELECT FIRST_NAME, LAST_NAME, PHONE_NUMBER FROM EMPLOYEES;
  FRIEND C1%ROWTYPE;
BEGIN
  friend.first_name   := 'John';
  friend.last_name    := 'Smith';
  friend.phone_number := '1-650-555-1234';
  DBMS_OUTPUT.PUT_LINE(friend.first_name || ' ' || friend.last_name || ', ' ||
                       friend.phone_number);
END;
/
DROP TABLE EMPLOYEES PURGE;

---------------------------------------------------------- 
--%ROWTYPE Variable Represents Join Row
DROP TABLE EMPLOYEES PURGE;
CREATE TABLE EMPLOYEES 
(
employee_id NUMBER,
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
PHONE_NUMBER VARCHAR2(50),
DEPARTMENT_ID NUMBER,
manager_id NUMBER,
email VARCHAR2(50),
MID_NAME VARCHAR2(50));

DROP TABLE DEPARTMENTS PURGE;
CREATE TABLE DEPARTMENTS
(
DEPARTMENT_ID NUMBER,
DEPARTMENT_NAME VARCHAR2(200),
MANAGER_ID NUMBER,
LOCATION_ID NUMBER); 
DECLARE
  CURSOR c2 IS
    SELECT employee_id, email, employees.manager_id, location_id
      FROM employees, departments
     WHERE employees.department_id = departments.department_id;
  join_rec c2%ROWTYPE; -- includes columns from two tables
BEGIN
  NULL;
END;
/
---------------------------------------------------------- 
--Inserting %ROWTYPE Record into Table (Wrong)
DROP TABLE plch_departure purge;
CREATE TABLE plch_departure (
destination VARCHAR2(100),
departure_time DATE,
delay NUMBER(10),
expected GENERATED ALWAYS AS (departure_time + delay/24/60/60)
);
DECLARE
  dep_rec plch_departure%ROWTYPE;
BEGIN
  dep_rec.destination    := 'X';
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay          := 1500;
  INSERT INTO plch_departure VALUES dep_rec;
END;
/
--Inserting %ROWTYPE Record into Table (Right)
DECLARE
  dep_rec plch_departure%rowtype;
BEGIN
  dep_rec.destination    := 'X';
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay          := 1500;
  INSERT INTO plch_departure
    (destination, departure_time, delay)
  VALUES
    (dep_rec.destination, dep_rec.departure_time, dep_rec.delay);
end;
/
---------------------------------------------------------- 
--Orace12c
--%ROWTYPE Affected by Making Invisible Column Visible
drop table t purge;
CREATE TABLE t (a INT, b INT, c INT INVISIBLE);
INSERT INTO t (a, b, c) VALUES (1, 2, 3);
COMMIT;
DECLARE
  t_rec t%ROWTYPE; -- t_rec has fields a and b, but not c
BEGIN
  SELECT * INTO t_rec FROM t WHERE ROWNUM < 2; -- t_rec(a)=1, t_rec(b)=2
  DBMS_OUTPUT.PUT_LINE('c = ' || t_rec.c);
END;
/

ALTER TABLE t MODIFY (c VISIBLE);

DECLARE
  t_rec t%ROWTYPE; -- t_rec has fields a, b, and c
BEGIN
  SELECT * INTO t_rec FROM t WHERE ROWNUM < 2; -- t_rec(a)=1, t_rec(b)=2,
  -- t_rec(c)=3
  DBMS_OUTPUT.PUT_LINE('c = ' || t_rec.c);
END;
/

---------------------------------------------------------- 
--Assigning Record to Another Record of Same RECORD Type
DROP TABLE EMPLOYEES PURGE;
CREATE TABLE EMPLOYEES 
(
employee_id NUMBER,
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
PHONE_NUMBER VARCHAR2(50),
DEPARTMENT_ID NUMBER,
manager_id NUMBER,
email VARCHAR2(50),
MID_NAME VARCHAR2(50));

DECLARE
  TYPE name_rec IS RECORD(
    first employees.first_name%TYPE DEFAULT 'John',
    last  employees.last_name%TYPE DEFAULT 'Doe');
  name1 name_rec;
  name2 name_rec;
BEGIN
  name1.first := 'Jane';
  name1.last  := 'Smith';
  DBMS_OUTPUT.PUT_LINE('name1: ' || name1.first || ' ' || name1.last);
  name2 := name1;
  DBMS_OUTPUT.PUT_LINE('name2: ' || name2.first || ' ' || name2.last);
END;
/
---------------------------------------------------------- 
--Assigning %ROWTYPE Record to RECORD Type Record
DECLARE
  TYPE name_rec IS RECORD(
    first employees.first_name%TYPE DEFAULT 'John',
    last  employees.last_name%TYPE DEFAULT 'Doe');
  CURSOR c IS
    SELECT first_name, last_name FROM employees;
  target name_rec;
  source c%ROWTYPE;
BEGIN
  source.first_name := 'Jane';
  source.last_name  := 'Smith';
  DBMS_OUTPUT.PUT_LINE('source: ' || source.first_name || ' ' ||
                       source.last_name);
  target := source;
  DBMS_OUTPUT.PUT_LINE('target: ' || target.first || ' ' || target.last);
END;
/
---------------------------------------------------------- 
--Assigning Nested Record to Another Record of Same RECORD
DECLARE
  TYPE name_rec IS RECORD(
    first employees.first_name%TYPE,
    last  employees.last_name%TYPE);
  TYPE phone_rec IS RECORD(
    name  name_rec, -- nested record
    phone employees.phone_number%TYPE);
  TYPE email_rec IS RECORD(
    name  name_rec, -- nested record
    email employees.email%TYPE);
  phone_contact phone_rec;
  email_contact email_rec;
BEGIN
  phone_contact.name.first := 'John';
  phone_contact.name.last  := 'Smith';
  phone_contact.phone      := '1-650-555-1234';
  email_contact.name       := phone_contact.name;
  email_contact.email      := (email_contact.name.first || '.' ||
                              email_contact.name.last || '@' ||
                              'example.com');
  DBMS_OUTPUT.PUT_LINE(email_contact.email);
END;
/

---------------------------------------------------------- 
--SELECT INTO Assigns Values to Record Variable
drop table EMPLOYEES purge;
CREATE TABLE EMPLOYEES 
(
employee_id NUMBER,
FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50),
PHONE_NUMBER VARCHAR2(50),
DEPARTMENT_ID NUMBER,
manager_id NUMBER,
email VARCHAR2(50),
MID_NAME VARCHAR2(50),
job_id varchar2(50));
DECLARE
  TYPE RecordTyp IS RECORD(
    last employees.last_name%TYPE,
    id   employees.employee_id%TYPE);
  rec1 RecordTyp;
BEGIN
  SELECT last_name, employee_id
    INTO rec1
    FROM employees
   WHERE job_id = 'AD_PRES';
  DBMS_OUTPUT.PUT_LINE('Employee #' || rec1.id || ' = ' || rec1.last);
END;
/
---------------------------------------------------------- 
--FETCH Assigns Values to Record that Function Returns

----------------------------------------------------------
--Example 6-36 COMMIT Statement with COMMENT and WRITE Clauses
DROP TABLE accounts;
CREATE TABLE accounts (
account_id NUMBER(6),
balance NUMBER (10,2)
);

INSERT INTO accounts (account_id, balance)
VALUES (7715, 6350.00);
INSERT INTO accounts (account_id, balance)
VALUES (7720, 5100.50);

CREATE OR REPLACE PROCEDURE transfer (
from_acct NUMBER,
to_acct NUMBER,
amount NUMBER
) AUTHID CURRENT_USER AS
BEGIN
UPDATE accounts
SET balance = balance - amount
WHERE account_id = from_acct;
UPDATE accounts
SET balance = balance + amount
WHERE account_id = to_acct;
COMMIT WRITE IMMEDIATE NOWAIT;
END;
/

SELECT * FROM accounts;

BEGIN
transfer(7715, 7720, 250);
END;
/

SELECT * FROM accounts;

DROP TABLE accounts purge;

---------------------------------------------------------- 
--Example 6-37 ROLLBACK Statement
DROP TABLE emp_name purge;
CREATE TABLE emp_name AS
SELECT employee_id, last_name
FROM employees;

CREATE UNIQUE INDEX empname_ix
ON emp_name (employee_id);

DROP TABLE emp_sal purge;
CREATE TABLE emp_sal AS
SELECT employee_id, salary
FROM employees;

CREATE UNIQUE INDEX empsal_ix
ON emp_sal (employee_id);

DROP TABLE emp_job purge;
CREATE TABLE emp_job AS
SELECT employee_id, job_id
FROM employees;

CREATE UNIQUE INDEX empjobid_ix
ON emp_job (employee_id);

DECLARE
emp_id NUMBER(6);
emp_lastname VARCHAR2(25);
emp_salary NUMBER(8,2);
emp_jobid VARCHAR2(10);
BEGIN
SELECT employee_id, last_name, salary, job_id
INTO emp_id, emp_lastname, emp_salary, emp_jobid
FROM employees
WHERE employee_id = 120;
INSERT INTO emp_name (employee_id, last_name)
VALUES (emp_id, emp_lastname);
INSERT INTO emp_sal (employee_id, salary)
VALUES (emp_id, emp_salary);
INSERT INTO emp_job (employee_id, job_id)
VALUES (emp_id, emp_jobid);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Inserts were rolled back');
END;
/

DROP TABLE emp_name purge;
DROP TABLE emp_sal purge;
DROP TABLE emp_job purge;

----------------------------------------------------------
--Example 6-38 SAVEPOINT and ROLLBACK Statements
DROP TABLE emp_name;
CREATE TABLE emp_name AS
SELECT employee_id, last_name, salary
FROM employees;
CREATE UNIQUE INDEX empname_ix
ON emp_name (employee_id);
DECLARE
emp_id employees.employee_id%TYPE;
emp_lastname employees.last_name%TYPE;
emp_salary employees.salary%TYPE;
BEGIN
SELECT employee_id, last_name, salary
INTO emp_id, emp_lastname, emp_salary
FROM employees
WHERE employee_id = 120;
UPDATE emp_name
SET salary = salary * 1.1
WHERE employee_id = emp_id;
DELETE FROM emp_name
WHERE employee_id = 130;
SAVEPOINT do_insert;
INSERT INTO emp_name (employee_id, last_name, salary)
VALUES (emp_id, emp_lastname, emp_salary);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
ROLLBACK TO do_insert;
DBMS_OUTPUT.PUT_LINE('Insert was rolled back');
END;
/ 
----------------------------------------------------------
--Example 6-39 Reusing SAVEPOINT with ROLLBACK
DROP TABLE emp_name;
CREATE TABLE emp_name AS
SELECT employee_id, last_name, salary
FROM employees;
CREATE UNIQUE INDEX empname_ix
ON emp_name (employee_id);

DECLARE
  emp_id       employees.employee_id%TYPE;
  emp_lastname employees.last_name%TYPE;
  emp_salary   employees.salary%TYPE;
  emp_salary2  employees.salary%TYPE;

BEGIN
  SELECT employee_id, last_name, salary
    INTO emp_id, emp_lastname, emp_salary
    FROM employees
   WHERE employee_id = 120;
  DBMS_OUTPUT.PUT_LINE('before update emp_salary=' || emp_salary);

  SAVEPOINT my_savepoint;
  UPDATE emp_name SET salary = salary * 1.1 WHERE employee_id = emp_id;
  SELECT salary INTO emp_salary2 FROM emp_name WHERE employee_id = 120;
  DBMS_OUTPUT.PUT_LINE('after update emp_salary=' || emp_salary2);

  DELETE FROM emp_name WHERE employee_id = 130;
  SAVEPOINT my_savepoint;
  INSERT INTO emp_name
    (employee_id, last_name, salary)
  VALUES
    (emp_id, emp_lastname, emp_salary);
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    ROLLBACK TO my_savepoint;
    DBMS_OUTPUT.PUT_LINE('Transaction rolled back.');
  
END;
/

---------------------------------------------------------- 
--Example 6-40 SET TRANSACTION Statement in Read-Only Transaction
--
DECLARE
  daily_order_total   NUMBER(12, 2);
  weekly_order_total  NUMBER(12, 2);
  monthly_order_total NUMBER(12, 2);
BEGIN
  COMMIT; -- end previous transaction
  SET TRANSACTION READ ONLY NAME 'Calculate Order Totals';
  SELECT SUM(order_total)
    INTO daily_order_total
    FROM oe.orders
   WHERE order_date = SYSDATE;
  SELECT SUM(order_total)
    INTO weekly_order_total
    FROM oe.orders
   WHERE order_date = SYSDATE - 7;
  SELECT SUM(order_total)
    INTO monthly_order_total
    FROM oe.orders
   WHERE order_date = SYSDATE - 30;
  COMMIT; -- ends read-only transaction
END;
/
---------------------------------------------------------- 
--Example 6-41 FETCH with FOR UPDATE Cursor After COMMIT Statement
DROP TABLE emp;
CREATE TABLE emp AS SELECT * FROM employees;
DECLARE
  CURSOR c1 IS
    SELECT * FROM emp FOR UPDATE OF salary ORDER BY employee_id;
  emp_rec emp%ROWTYPE;
BEGIN
  OPEN c1;
  LOOP
    FETCH c1
      INTO emp_rec; -- fails on second iteration
    EXIT WHEN c1%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('emp_rec.employee_id = ' ||
                         TO_CHAR(emp_rec.employee_id));
    UPDATE emp SET salary = salary * 1.05 WHERE employee_id = 105;
    COMMIT; -- releases locks
  END LOOP;
END;
/
---------------------------------------------------------- 
--Example 6-42 Simulating CURRENT OF Clause with ROWID Pseudocolumn
DROP TABLE emp;
CREATE TABLE emp AS SELECT * FROM employees;
DECLARE
  CURSOR c1 IS
    SELECT last_name, job_id, rowid FROM emp; -- no FOR UPDATE clause
  my_lastname employees.last_name%TYPE;
  my_jobid    employees.job_id%TYPE;
  my_rowid    UROWID;
BEGIN
  OPEN c1;
  LOOP
    FETCH c1
      INTO my_lastname, my_jobid, my_rowid;
    EXIT WHEN c1%NOTFOUND;
    UPDATE emp SET salary = salary * 1.02 WHERE rowid = my_rowid; -- simulates WHERE CURRENT OF c1
    COMMIT;
  END LOOP;
  CLOSE c1;
END;
/
---------------------------------------------------------- 
--You cannot apply the AUTONOMOUS_TRANSACTION pragma to an entire package or ADT,
--but you can apply it to each subprogram in a package or each method of an ADT.
--Example 6-43 Declaring Autonomous Function in Package
CREATE OR REPLACE PACKAGE emp_actions AUTHID DEFINER AS
  -- package specification
  FUNCTION raise_salary(emp_id NUMBER, sal_raise NUMBER) RETURN NUMBER;
END emp_actions;
/
CREATE OR REPLACE PACKAGE BODY emp_actions AS
  -- package body
  -- code for function raise_salary
  FUNCTION raise_salary(emp_id NUMBER, sal_raise NUMBER) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    new_sal NUMBER(8, 2);
  BEGIN
    UPDATE employees
       SET salary = salary + sal_raise
     WHERE employee_id = emp_id;
    COMMIT;
    SELECT salary INTO new_sal FROM employees WHERE employee_id = emp_id;
    RETURN new_sal;
  END raise_salary;
END emp_actions;
/
---------------------------------------------------------- 
--Example 6-44 Declaring Autonomous Standalone Procedure
CREATE OR REPLACE PROCEDURE lower_salary(emp_id NUMBER, amount NUMBER)
  AUTHID DEFINER AS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE employees SET salary = salary - amount WHERE employee_id = emp_id;
  COMMIT;
END lower_salary;
/
---------------------------------------------------------- 
--Example 6-45 Declaring Autonomous PL/SQL Block
DROP TABLE emp;
CREATE TABLE emp AS SELECT * FROM employees;
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  emp_id NUMBER(6) := 200;
  amount NUMBER(6, 2) := 200;
BEGIN
  UPDATE employees SET salary = salary - amount WHERE employee_id = emp_id;
  COMMIT;
END;
/
---------------------------------------------------------- 
--Example 6-46 Autonomous Trigger Logs INSERT Statements
DROP TABLE emp;
CREATE TABLE emp AS SELECT * FROM employees;
-- Log table:
DROP TABLE log;
CREATE TABLE log (
log_id NUMBER(6),
up_date DATE,
new_sal NUMBER(8,2),
old_sal NUMBER(8,2)
);
-- Autonomous trigger on emp table:
CREATE OR REPLACE TRIGGER log_sal
  BEFORE UPDATE OF salary ON emp
  FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO log
    (log_id, up_date, new_sal, old_sal)
  VALUES
    (:old.employee_id, SYSDATE, :new.salary, :old.salary);
  COMMIT;
END;
/
UPDATE emp
SET salary = salary * 1.05
WHERE employee_id = 115;
COMMIT;
UPDATE emp
SET salary = salary * 1.05
WHERE employee_id = 116;
ROLLBACK;
-- Show that both committed and rolled-back updates
-- add rows to log table
SELECT * FROM log
WHERE log_id = 115 OR log_id = 116;
---------------------------------------------------------- 
--Example 7-1 Invoking Subprogram from Dynamic PL/SQL Block
-- Subprogram that dynamic PL/SQL block invokes:
CREATE OR REPLACE PROCEDURE create_dept(deptid IN OUT NUMBER,
                                        dname  IN VARCHAR2,
                                        mgrid  IN NUMBER,
                                        locid  IN NUMBER) AUTHID DEFINER AS
BEGIN
  deptid := departments_seq.NEXTVAL;
  INSERT INTO departments
    (department_id, department_name, manager_id, location_id)
  VALUES
    (deptid, dname, mgrid, locid);
END;
/

DECLARE
  plsql_block VARCHAR2(500);
  new_deptid  NUMBER(4);
  new_dname   VARCHAR2(30) := 'Advertising';
  new_mgrid   NUMBER(6) := 200;
  new_locid   NUMBER(4) := 1700;
BEGIN
  -- Dynamic PL/SQL block invokes subprogram:
  plsql_block := 'BEGIN create_dept(:a, :b, :c, :d); END;';
  /* Specify bind variables in USING clause.
  Specify mode for first parameter.
  Modes of other parameters are correct by default. */
  EXECUTE IMMEDIATE plsql_block
    USING IN OUT new_deptid, new_dname, new_mgrid, new_locid;
END;
/
----------------------------------------------------------
--oracle 11g 12c cannot run
--Example 7-2 Dynamically Invoking Subprogram with BOOLEAN Formal Parameter
DROP PROCEDURE P;

CREATE OR REPLACE PROCEDURE p(x BOOLEAN) AUTHID DEFINER AS
BEGIN
  IF x THEN
    DBMS_OUTPUT.PUT_LINE('x is true');
  END IF;
END;
/
DECLARE
  dyn_stmt VARCHAR2(200);
  b        BOOLEAN := TRUE;
BEGIN
  dyn_stmt := 'BEGIN p(:x); END;';
  EXECUTE IMMEDIATE dyn_stmt
    USING b;--here oracle 11g cannot run
END;
/
 
----------------------------------------------------------
--oracle 11g cannot run 12c can run
--Example 7-3 Dynamically Invoking Subprogram with RECORD Formal Parameter
DROP PACKAGE pkg;

CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE rec IS RECORD(
    n1 NUMBER,
    n2 NUMBER);
  PROCEDURE p(x OUT rec, y NUMBER, z NUMBER);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE p(x OUT rec, y NUMBER, z NUMBER) AS
  BEGIN
    x.n1 := y;
    x.n2 := z;
  END p;
END pkg;
/
DECLARE
  r       pkg.rec;
  dyn_str VARCHAR2(3000);
BEGIN
  dyn_str := 'BEGIN pkg.p(:x, 6, 8); END;';
  EXECUTE IMMEDIATE dyn_str
    USING OUT r;--here oracle 11g cannot run
  DBMS_OUTPUT.PUT_LINE('r.n1 = ' || r.n1);
  DBMS_OUTPUT.PUT_LINE('r.n2 = ' || r.n2);
END;
/
---------------------------------------------------------- 
--oracle 11g cannot run 12c can run

--Example 7-4 Dynamically Invoking Subprogram with Assoc. Array Formal Parameter
DROP PACKAGE PKG;

CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE number_names IS TABLE OF VARCHAR2(5) INDEX BY PLS_INTEGER;
  PROCEDURE print_number_names(x number_names);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_number_names(x number_names) IS
  BEGIN
    FOR i IN x.FIRST .. x.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(x(i));
    END LOOP;
  END;
END pkg;
/
DECLARE
  digit_names pkg.number_names;
  dyn_stmt    VARCHAR2(3000);
BEGIN
  digit_names(0) := 'zero';
  digit_names(1) := 'one';
  digit_names(2) := 'two';
  digit_names(3) := 'three';
  digit_names(4) := 'four';
  digit_names(5) := 'five';
  digit_names(6) := 'six';
  digit_names(7) := 'seven';
  digit_names(8) := 'eight';
  digit_names(9) := 'nine';
  dyn_stmt := 'BEGIN pkg.print_number_names(:x); END;';
  EXECUTE IMMEDIATE dyn_stmt
    USING digit_names;--oracle 11g cannot run
END;
/
---------------------------------------------------------- 
--oracle 11g cannot run 12c can run
--Example 7-5 Dynamically Invoking Subprogram with Nested Table Formal Parameter
DROP PACKAGE PKG;

CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE names IS TABLE OF VARCHAR2(10);
  PROCEDURE print_names(x names);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_names(x names) IS
  BEGIN
    FOR i IN x.FIRST .. x.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(x(i));
    END LOOP;
  END;
END pkg;
/
DECLARE
  fruits   pkg.names;
  dyn_stmt VARCHAR2(3000);
BEGIN
  fruits   := pkg.names('apple', 'banana', 'cherry');
  dyn_stmt := 'BEGIN pkg.print_names(:x); END;';
  EXECUTE IMMEDIATE dyn_stmt
    USING fruits;
END;
/
DROP PACKAGE PKG;

---------------------------------------------------------- 
--Example 7-6 Dynamically Invoking Subprogram with Varray Formal Parameter
DROP PACKAGE PKG;

CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE foursome IS VARRAY(4) OF VARCHAR2(5);
  PROCEDURE print_foursome(x foursome);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_foursome(x foursome) IS
  BEGIN
    IF x.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Empty');
    ELSE
      FOR i IN x.FIRST .. x.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(x(i));
      END LOOP;
    END IF;
  END;
END pkg;
/
DECLARE
  directions pkg.foursome;
  dyn_stmt   VARCHAR2(3000);
BEGIN
  directions := pkg.foursome('north', 'south', 'east', 'west');
  dyn_stmt   := 'BEGIN pkg.print_foursome(:x); END;';
  EXECUTE IMMEDIATE dyn_stmt
    USING directions;
END;
/
DROP PACKAGE PKG;

----------------------------------------------------------
--Example 7-7 Uninitialized Variable Represents NULL in USING Clause
DROP TABLE EMPLOYEES;
DROP TABLE employees_temp;
CREATE TABLE EMPLOYEES (commission_pct CHAR(1));
CREATE TABLE employees_temp AS SELECT * FROM EMPLOYEES;
DECLARE
a_null CHAR(1); -- Set to NULL automatically at run time
BEGIN
EXECUTE IMMEDIATE 'UPDATE employees_temp SET commission_pct = :x'
USING a_null;
END;
/
DROP TABLE EMPLOYEES;
DROP TABLE employees_temp;
---------------------------------------------------------- 
--Example 7-8 Native Dynamic SQL with OPEN FOR, FETCH, and CLOSE Statements
DECLARE
  TYPE EmpCurTyp IS REF CURSOR;
  v_emp_cursor EmpCurTyp;
  emp_record   employees%ROWTYPE;
  v_stmt_str   VARCHAR2(200);
--  v_e_job      employees.job%TYPE;
BEGIN
  -- Dynamic SQL statement with placeholder:
  v_stmt_str := 'SELECT * FROM employees WHERE job_id = :j';
  -- Open cursor & specify bind variable in USING clause:
  OPEN v_emp_cursor FOR v_stmt_str
    USING 'MANAGER';
  -- Fetch rows from result set one at a time:
  LOOP
    FETCH v_emp_cursor
      INTO emp_record;
    EXIT WHEN v_emp_cursor%NOTFOUND;
  END LOOP;
  -- Close cursor:
  CLOSE v_emp_cursor;
END;
/
---------------------------------------------------------- 
--Example 7-9 Querying a Collection with Native Dynamic SQL
--ORACLE 11G CANNOT RUN 
--ORACLE 12C CAN
DROP PACKAGE PKG;
CREATE OR REPLACE PACKAGE pkg AUTHID DEFINER AS
  TYPE rec IS RECORD(
    f1 NUMBER,
    f2 VARCHAR2(30));
  TYPE mytab IS TABLE OF rec INDEX BY pls_integer;
END;
/
DECLARE
  v1 pkg.mytab; -- collection of records
  v2 pkg.rec;
  c1 SYS_REFCURSOR;
BEGIN
  OPEN c1 FOR 'SELECT * FROM TABLE(:1)'
    USING v1;
  FETCH c1
    INTO v2;
  CLOSE c1;
  DBMS_OUTPUT.PUT_LINE('Values in record are ' || v2.f1 || ' and ' ||
                       v2.f2);
END;
/
DROP PACKAGE PKG;
----------------------------------------------------------
--Example 7-10 Repeated Placeholder Names in Dynamic PL/SQL Block
DROP PROCEDURE calc_stats;

CREATE PROCEDURE calc_stats(w NUMBER, x NUMBER, y NUMBER, z NUMBER) IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(w + x + y + z);
END;
/
DECLARE
  a           NUMBER := 4;
  b           NUMBER := 7;
  plsql_block VARCHAR2(100);
BEGIN
  plsql_block := 'BEGIN calc_stats(:x, :x, :y, :x); END;';
  EXECUTE IMMEDIATE plsql_block
    USING a, b; -- calc_stats(a, a, b, a)
END;
/
DROP PROCEDURE calc_stats;

----------------------------------------------------------
--Example 7-11 DBMS_SQL.RETURN_RESULT Procedure
CREATE OR REPLACE PROCEDURE p AUTHID DEFINER AS
  c1 SYS_REFCURSOR;
  c2 SYS_REFCURSOR;
BEGIN
  OPEN c1 FOR
    SELECT first_name, last_name FROM employees WHERE employee_id = 176;
  DBMS_SQL.RETURN_RESULT(c1);
  -- Now p cannot access the result.
  OPEN c2 FOR
    SELECT city, state_province FROM locations WHERE country_id = 'AU';
  DBMS_SQL.RETURN_RESULT(c2);
  -- Now p cannot access the result.
END;
/
BEGIN
  p;
END;
/
DROP PROCEDURE P;
---------------------------------------------------------- 
--ORACLE 11G CANNOT BECAUSE OF DBMS_SQL
--ORACLE 12C CAN RUN
--Example 7-12 DBMS_SQL.GET_NEXT_RESULT Procedure
DROP TABLE EMPLOYEES PURGE;
DROP TABLE JOB_HISTORY PURGE;
DROP TABLE JOBS PURGE;
DROP PROCEDURE GET_EMPLOYEE_INFO;

CREATE OR REPLACE PROCEDURE get_employee_info(id IN VARCHAR2) AUTHID DEFINER AS
  rc SYS_REFCURSOR;
BEGIN
  -- Return employee info
  OPEN rc FOR
    SELECT first_name, last_name, email, phone_number
      FROM employees
     WHERE employee_id = id;
  DBMS_SQL.RETURN_RESULT(rc);
  -- Return employee job history
  OPEN RC FOR
    SELECT job_title, start_date, end_date
      FROM job_history jh, jobs j
     WHERE jh.employee_id = id
       AND jh.job_id = j.job_id
     ORDER BY start_date DESC;
  DBMS_SQL.RETURN_RESULT(rc);
END;
/
<<main>>
DECLARE
  c            INTEGER;
  rc           SYS_REFCURSOR;
  n            NUMBER;
  first_name   VARCHAR2(20);
  last_name    VARCHAR2(25);
  email        VARCHAR2(25);
  phone_number VARCHAR2(20);
  job_title    VARCHAR2(35);
  start_date   DATE;
  end_date     DATE;
BEGIN
  c := DBMS_SQL.OPEN_CURSOR(true);
  DBMS_SQL.PARSE(c, 'BEGIN get_employee_info(:id); END;', DBMS_SQL.NATIVE);
  DBMS_SQL.BIND_VARIABLE(c, ':id', 176);
  n := DBMS_SQL.EXECUTE(c);
  -- Get employee info
  dbms_sql.get_next_result(c, rc);
  FETCH rc
    INTO first_name, last_name, email, phone_number;
  DBMS_OUTPUT.PUT_LINE('Employee: ' || first_name || ' ' || last_name);
  DBMS_OUTPUT.PUT_LINE('Email: ' || email);
  DBMS_OUTPUT.PUT_LINE('Phone: ' || phone_number);
  -- Get employee job history
  DBMS_OUTPUT.PUT_LINE('Titles:');
  DBMS_SQL.GET_NEXT_RESULT(c, rc);
  LOOP
    FETCH rc
      INTO job_title, start_date, end_date;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('- ' || job_title || ' (' || start_date || ' - ' ||
                         end_date || ')');
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(c);
END main;
/
DROP TABLE EMPLOYEES PURGE;
DROP TABLE JOB_HISTORY PURGE;
DROP TABLE JOBS PURGE;
DROP PROCEDURE GET_EMPLOYEE_INFO;
----------------------------------------------------------
--Example 7-13 uses the DBMS_SQL.TO_REFCURSOR function to switch from the DBMS_SQL package to native dynamic SQL. 
--Example 7-13 Switching from DBMS_SQL Package to Native Dynamic SQL
CREATE OR REPLACE TYPE vc_array IS TABLE OF VARCHAR2(200);
/
CREATE OR REPLACE TYPE numlist IS TABLE OF NUMBER;
/
CREATE OR REPLACE PROCEDURE do_query_1(placeholder vc_array,
                                       bindvars    vc_array,
                                       sql_stmt    VARCHAR2) AUTHID DEFINER IS
  TYPE curtype IS REF CURSOR;
  src_cur   curtype;
  curid     NUMBER;
  bindnames vc_array;
  empnos    numlist;
  depts     numlist;
  ret       NUMBER;
  isopen    BOOLEAN;
BEGIN
  -- Open SQL cursor number:
  curid := DBMS_SQL.OPEN_CURSOR;
  -- Parse SQL cursor number:
  DBMS_SQL.PARSE(curid, sql_stmt, DBMS_SQL.NATIVE);
  bindnames := placeholder;
  -- Bind variables:
  FOR i IN 1 .. bindnames.COUNT LOOP
    DBMS_SQL.BIND_VARIABLE(curid, bindnames(i), bindvars(i));
  END LOOP;
  -- Run SQL cursor number:
  ret := DBMS_SQL.EXECUTE(curid);
  -- Switch from DBMS_SQL to native dynamic SQL:
  src_cur := DBMS_SQL.TO_REFCURSOR(curid);
  FETCH src_cur BULK COLLECT
    INTO empnos, depts;
  -- This would cause an error because curid was converted to a REF CURSOR:
  -- isopen := DBMS_SQL.IS_OPEN(curid);
  CLOSE src_cur;
END;
/
---------------------------------------------------------- 
--Example 7-14 uses the DBMS_SQL.TO_CURSOR_NUMBER function to switch from native dynamic SQL to the DBMS_SQL package.
--Example 7-14 Switching from Native Dynamic SQL to DBMS_SQL Package
CREATE OR REPLACE PROCEDURE do_query_2(sql_stmt VARCHAR2) AUTHID DEFINER IS
  TYPE curtype IS REF CURSOR;
  src_cur curtype;
  curid   NUMBER;
  desctab DBMS_SQL.DESC_TAB;
  colcnt  NUMBER;
  namevar VARCHAR2(50);
  numvar  NUMBER;
  datevar DATE;
  empno   NUMBER := 100;
BEGIN
  -- sql_stmt := SELECT ... FROM employees WHERE employee_id = :b1';
  -- Open REF CURSOR variable:
  OPEN src_cur FOR sql_stmt
    USING empno;
  -- Switch from native dynamic SQL to DBMS_SQL package:
  curid := DBMS_SQL.TO_CURSOR_NUMBER(src_cur);
  DBMS_SQL.DESCRIBE_COLUMNS(curid, colcnt, desctab);
  -- Define columns:
  FOR i IN 1 .. colcnt LOOP
    IF desctab(i).col_type = 2 THEN
      DBMS_SQL.DEFINE_COLUMN(curid, i, numvar);
    ELSIF desctab(i).col_type = 12 THEN
      DBMS_SQL.DEFINE_COLUMN(curid, i, datevar);
      -- statements
    ELSE
      DBMS_SQL.DEFINE_COLUMN(curid, i, namevar, 50);
    END IF;
  END LOOP;
  -- Fetch rows with DBMS_SQL package:
  WHILE DBMS_SQL.FETCH_ROWS(curid) > 0 LOOP
    FOR i IN 1 .. colcnt LOOP
      IF (desctab(i).col_type = 1) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, namevar);
      ELSIF (desctab(i).col_type = 2) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, numvar);
      ELSIF (desctab(i).col_type = 12) THEN
        DBMS_SQL.COLUMN_VALUE(curid, i, datevar);
        -- statements
      END IF;
    END LOOP;
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR(curid);
END;
/
---------------------------------------------------------- 
--Example 7-15 Setup for SQL Injection Examples
DROP TABLE secret_records;
CREATE TABLE secret_records (
user_name VARCHAR2(9),
service_type VARCHAR2(12),
value VARCHAR2(30),
date_created DATE
);
INSERT INTO secret_records (
user_name, service_type, value, date_created
)
VALUES ('Andy', 'Waiter', 'Serve dinner at Cafe Pete', SYSDATE);
INSERT INTO secret_records (
user_name, service_type, value, date_created
)
VALUES ('Chuck', 'Merger', 'Buy company XYZ', SYSDATE);

--Example 7-16 Procedure Vulnerable to Statement Modification
CREATE OR REPLACE PROCEDURE get_record(user_name    IN VARCHAR2,
                                       service_type IN VARCHAR2,
                                       rec          OUT VARCHAR2) AUTHID DEFINER IS
  query VARCHAR2(4000);
BEGIN
  -- Following SELECT statement is vulnerable to modification
  -- because it uses concatenation to build WHERE clause.
  query := 'SELECT value FROM secret_records WHERE user_name=''' ||
           user_name || ''' AND service_type=''' || service_type || '''';
  DBMS_OUTPUT.PUT_LINE('Query: ' || query);
  EXECUTE IMMEDIATE query
    INTO rec;
  DBMS_OUTPUT.PUT_LINE('Rec: ' || rec);
END;
/
SET SERVEROUTPUT ON;
DECLARE
record_value VARCHAR2(4000);
BEGIN
get_record('Andy', 'Waiter', record_value);
END;
/

DECLARE
  record_value VARCHAR2(4000);
BEGIN
  get_record('Anybody '' OR service_type=''Merger''--',
             'Anything',
             record_value);
END;
/

--Example 7-17 Procedure Vulnerable to Statement Injection
CREATE OR REPLACE PROCEDURE p(user_name    IN VARCHAR2,
                              service_type IN VARCHAR2) AUTHID DEFINER IS
  block1 VARCHAR2(4000);
BEGIN
  -- Following block is vulnerable to statement injection
  -- because it is built by concatenation.
  block1 := 'BEGIN
DBMS_OUTPUT.PUT_LINE(''user_name: ' || user_name || ''');' ||
            'DBMS_OUTPUT.PUT_LINE(''service_type: ' || service_type || ''');
END;';
  DBMS_OUTPUT.PUT_LINE('Block1: ' || block1);
  EXECUTE IMMEDIATE block1;
END;
/
SET SERVEROUTPUT ON;
BEGIN
  p('Andy', 'Waiter');
END;
/

--A less known SQL injection technique uses NLS session parameters to modify or
--inject SQL statements.
--A datetime or numeric value that is concatenated into the text of a dynamic SQL
--statement must be converted to the VARCHAR2 data type. The conversion can be either
--implicit (when the value is an operand of the concatenation operator) or explicit (when
--the value is the argument of the TO_CHAR function). This data type conversion depends
--on the NLS settings of the database session that runs the dynamic SQL statement.
--The conversion of datetime values uses format models specified in the parameters
--NLS_DATE_FORMAT, NLS_TIMESTAMP_FORMAT, or NLS_TIMESTAMP_TZ_FORMAT, depending
--on the particular datetime data type. The conversion of numeric values applies decimal
--and group separators specified in the parameter NLS_NUMERIC_CHARACTERS.

--Example 7-18 Procedure Vulnerable to SQL Injection Through Data Type Conversion
CREATE OR REPLACE PROCEDURE get_recent_record(user_name    IN VARCHAR2,
                                              service_type IN VARCHAR2,
                                              rec          OUT VARCHAR2)
  AUTHID DEFINER IS
  query VARCHAR2(4000);
BEGIN
  /* Following SELECT statement is vulnerable to modification
  because it uses concatenation to build WHERE clause
  and because SYSDATE depends on the value of NLS_DATE_FORMAT. */
  query := 'SELECT value FROM secret_records WHERE user_name=''' ||
           user_name || ''' AND service_type=''' || service_type ||
           ''' AND date_created>''' || (SYSDATE - 30) || '''';
  DBMS_OUTPUT.PUT_LINE('Query: ' || query);
  EXECUTE IMMEDIATE query
    INTO rec;
  DBMS_OUTPUT.PUT_LINE('Rec: ' || rec);
END;
/

SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY';
DECLARE
record_value VARCHAR2(4000);
BEGIN
get_recent_record('Andy', 'Waiter', record_value);
END;
/

ALTER SESSION SET NLS_DATE_FORMAT='"'' OR service_type=''Merger"';
DECLARE
record_value VARCHAR2(4000);
BEGIN
get_recent_record('Anybody', 'Anything', record_value);
END;
/
---------------------------------------------------------- 
--Example 7-19 Bind Variables Guarding Against SQL Injection
CREATE OR REPLACE PROCEDURE get_record_2(user_name    IN VARCHAR2,
                                         service_type IN VARCHAR2,
                                         rec          OUT VARCHAR2) AUTHID DEFINER IS
  query VARCHAR2(4000);
BEGIN
  query := 'SELECT value FROM secret_records
WHERE user_name=:a
AND service_type=:b';
  DBMS_OUTPUT.PUT_LINE('Query: ' || query);
  EXECUTE IMMEDIATE query
    INTO rec
    USING user_name, service_type;
  DBMS_OUTPUT.PUT_LINE('Rec: ' || rec);
END;
/
SET SERVEROUTPUT ON;
DECLARE
  record_value VARCHAR2(4000);
BEGIN
  get_record_2('Andy', 'Waiter', record_value);
END;
/
DECLARE
  record_value VARCHAR2(4000);
BEGIN
  get_record_2('Anybody '' OR service_type=''Merger''--',
               'Anything',
               record_value);
END;
/
select * from secret_records;
---------------------------------------------------------- 
--you can use the DBMS_ASSERT.ENQUOTE_LITERAL function to
--enclose a string literal in quotation marks, as Example 7-20 does. This prevents a
--malicious user from injecting text between an opening quotation mark and its
--corresponding closing quotation mark.

--Example 7-20 Validation Checks Guarding Against SQL Injection
CREATE OR REPLACE PROCEDURE raise_emp_salary(column_value NUMBER,
                                             emp_column   VARCHAR2,
                                             amount       NUMBER) AUTHID DEFINER IS
  v_column VARCHAR2(30);
  sql_stmt VARCHAR2(200);
BEGIN
  -- Check validity of column name that was given as input:
  SELECT column_name
    INTO v_column
    FROM USER_TAB_COLS
   WHERE TABLE_NAME = 'EMPLOYEES'
     AND COLUMN_NAME = emp_column;
  sql_stmt := 'UPDATE employees SET salary = salary + :1 WHERE ' ||
              DBMS_ASSERT.ENQUOTE_NAME(v_column, FALSE) || ' = :2';
  EXECUTE IMMEDIATE sql_stmt
    USING amount, column_value;
  -- If column name is valid:
  IF SQL%ROWCOUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Salaries were updated for: ' || emp_column ||
                         ' = ' || column_value);
  END IF;
  -- If column name is not valid:
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid Column: ' || emp_column);
END raise_emp_salary;
/
DECLARE
  plsql_block VARCHAR2(500);
BEGIN
  -- Invoke raise_emp_salary from a dynamic PL/SQL block:
  plsql_block := 'BEGIN raise_emp_salary(:cvalue, :cname, :amt); END;';
  EXECUTE IMMEDIATE plsql_block
    USING 110, 'DEPARTMENT_ID', 10;
  -- Invoke raise_emp_salary from a dynamic SQL statement:
  EXECUTE IMMEDIATE 'BEGIN raise_emp_salary(:cvalue, :cname, :amt); END;'
    USING 112, 'EMPLOYEE_ID', 10;
END;
/
---------------------------------------------------------- 
--Example 7-21 Explicit Format Models Guarding Against SQL Injection
CREATE OR REPLACE PROCEDURE get_recent_record(user_name    IN VARCHAR2,
                                              service_type IN VARCHAR2,
                                              rec          OUT VARCHAR2)
  AUTHID DEFINER IS
  query VARCHAR2(4000);
BEGIN
  /* Following SELECT statement is vulnerable to modification
  because it uses concatenation to build WHERE clause. */
  query := 'SELECT value FROM secret_records WHERE user_name=''' ||
           user_name || ''' AND service_type=''' || service_type ||
           ''' AND date_created> DATE ''' ||
           TO_CHAR(SYSDATE - 30, 'YYYY-MM-DD') || '''';
  DBMS_OUTPUT.PUT_LINE('Query: ' || query);
  EXECUTE IMMEDIATE query
    INTO rec;
  DBMS_OUTPUT.PUT_LINE('Rec: ' || rec);
END;
/
ALTER SESSION SET NLS_DATE_FORMAT='"'' OR service_type=''Merger"';
DECLARE
record_value VARCHAR2(4000);
BEGIN
get_recent_record('Anybody', 'Anything', record_value);
END;
/
----------------------------------------------------------
--Example 8-1 Declaring, Defining, and Invoking a Simple PL/SQL Procedure
DECLARE
  first_name employees.first_name%TYPE;
  last_name  employees.last_name%TYPE;
  email      employees.email%TYPE;
  employer   VARCHAR2(8) := 'AcmeCorp';
  -- Declare and define procedure
  PROCEDURE create_email( -- Subprogram heading begins
                         name1   VARCHAR2,
                         name2   VARCHAR2,
                         company VARCHAR2) -- Subprogram heading ends
   IS
    -- Declarative part begins
    error_message VARCHAR2(30) := 'Email address is too long.';
  BEGIN
    -- Executable part begins
    email := name1 || '.' || name2 || '@' || company;
  EXCEPTION
    -- Exception-handling part begins
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE(error_message);
  END create_email;
BEGIN
  first_name := 'John';
  last_name  := 'Doe';
  create_email(first_name, last_name, employer); -- invocation
  DBMS_OUTPUT.PUT_LINE('With first name first, email is: ' || email);
  create_email(last_name, first_name, employer); -- invocation
  DBMS_OUTPUT.PUT_LINE('With last name first, email is: ' || email);
  first_name := 'Elizabeth';
  last_name  := 'MacDonald';
  create_email(first_name, last_name, employer); -- invocation
END;
/
----------------------------------------------------------
--Example 8-2 Declaring, Defining, and Invoking a Simple PL/SQL Function
DECLARE
  -- Declare and define function
  FUNCTION square(original NUMBER) -- parameter list
   RETURN NUMBER -- RETURN clause
   AS
    -- Declarative part begins
    original_squared NUMBER;
  BEGIN
    -- Executable part begins
    original_squared := original * original;
    RETURN original_squared; -- RETURN statement
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE(square(100)); -- invocation
END;
/
----------------------------------------------------------
--Example 8-3 Execution Resumes After RETURN Statement in Function
DECLARE
  x INTEGER;
  FUNCTION f(n INTEGER) RETURN INTEGER IS
  BEGIN
    RETURN(n * n);
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE('f returns ' || f(2) ||
                       '. Execution returns here (1).');
  x := f(2);
  DBMS_OUTPUT.PUT_LINE('Execution returns here (2).');
END;
/
---------------------------------------------------------- 
--Example 8-4 Function Where Not Every Execution Path Leads to RETURN Statement
CREATE OR REPLACE FUNCTION f(n INTEGER) RETURN INTEGER AUTHID DEFINER IS
BEGIN
  IF n = 0 THEN
    RETURN 1;
  ELSIF n = 1 THEN
    RETURN n;
  END IF;
END;
/
---------------------------------------------------------- 
--Example 8-5 Function Where Every Execution Path Leads to RETURN Statement
CREATE OR REPLACE FUNCTION f(n INTEGER) RETURN INTEGER AUTHID DEFINER IS
BEGIN
  IF n = 0 THEN
    RETURN 1;
  ELSIF n = 1 THEN
    RETURN n;
  ELSE
    RETURN n * n;
  END IF;
END;
/
BEGIN
  FOR i IN 0 .. 3 LOOP
    DBMS_OUTPUT.PUT_LINE('f(' || i || ') = ' || f(i));
  END LOOP;
END;
/
----------------------------------------------------------
--Example 8-6 Execution Resumes After RETURN Statement in Procedure
DECLARE
  PROCEDURE p IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside p');
    RETURN;
    DBMS_OUTPUT.PUT_LINE('Unreachable statement.');
  END;
BEGIN
  p;
  DBMS_OUTPUT.PUT_LINE('Control returns here.');
END;
/
---------------------------------------------------------- 
--Example 8-7 Execution Resumes After RETURN Statement in Anonymous Block
BEGIN
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside inner block.');
    RETURN;
    DBMS_OUTPUT.PUT_LINE('Unreachable statement.');
  END;
  DBMS_OUTPUT.PUT_LINE('Inside outer block. Unreachable statement.');
END;
/

---------------------------------------------------------- 
--Example 8-8 Nested Subprograms Invoke Each Other
DECLARE
  -- Declare proc1 (forward declaration):
  PROCEDURE proc1(number1 NUMBER);
  -- Declare and define proc2:
  PROCEDURE proc2(number2 NUMBER) IS
  BEGIN
    proc1(number2);
  END;
  -- Define proc 1:
  PROCEDURE proc1(number1 NUMBER) IS
  BEGIN
    proc2(number1);
  END;
BEGIN
  NULL;
END;
/
----------------------------------------------------------
--Example 8-9 Formal Parameters and Actual Parameters
DECLARE
  emp_num NUMBER(6) := 120;
  bonus   NUMBER(6) := 100;
  merit   NUMBER(4) := 50;
  PROCEDURE raise_salary(emp_id NUMBER, -- formal parameter
                         amount NUMBER -- formal parameter
                         ) IS
  BEGIN
    UPDATE employees
       SET salary = salary + amount -- reference to formal parameter
     WHERE employee_id = emp_id; -- reference to formal parameter
  END raise_salary;
BEGIN
  raise_salary(emp_num, bonus); -- actual parameters
  /* raise_salary runs this statement:
  UPDATE employees
  SET salary = salary + 100
  WHERE employee_id = 120; */
  raise_salary(emp_num, merit + bonus); -- actual parameters
  /* raise_salary runs this statement:
  UPDATE employees
  SET salary = salary + 150
  WHERE employee_id = 120; */
END;
/
---------------------------------------------------------- 
--Example 8-10 Actual Parameter Inherits Only NOT NULL from Subtype
DECLARE
  SUBTYPE License IS VARCHAR2(7) NOT NULL;
  n License := 'DLLLDDD';
  PROCEDURE p(x License) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(x);
  END;
BEGIN
  p('1ABC123456789'); -- Succeeds; size is not inherited
  p(NULL); -- Raises error; NOT NULL is inherited
END;
/
---------------------------------------------------------- 
--Example 8-11 Actual Parameter and Return Value Inherit Only Range From Subtype
DECLARE
  FUNCTION test(p INTEGER) RETURN INTEGER IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('p = ' || p);
    RETURN p;
  END test;
BEGIN
  DBMS_OUTPUT.PUT_LINE('test(p) = ' || test(0.66));
END;
/
----------------------------------------------------------
--Example 8-12 Function Implicitly Converts Formal Parameter to Constrained Subtype
DECLARE
  FUNCTION test(p NUMBER) RETURN NUMBER IS
    q INTEGER := p; -- Implicitly converts p to INTEGER
  BEGIN
    DBMS_OUTPUT.PUT_LINE('p = ' || q); -- Display q, not p
    RETURN q; -- Return q, not p
  END test;
BEGIN
  DBMS_OUTPUT.PUT_LINE('test(p) = ' || test(0.66));
END;
/
----------------------------------------------------------
--Example 8-13 Avoiding Implicit Conversion of Actual Parameters
CREATE OR REPLACE PROCEDURE p(n NUMBER) AUTHID DEFINER IS
BEGIN
  NULL;
END;
/
DECLARE x NUMBER := 1; y VARCHAR2(1) := '1';
BEGIN
p(x); -- No conversion needed
p(y); -- z implicitly converted from VARCHAR2 to NUMBER
p(TO_NUMBER(y)); -- z explicitly converted from VARCHAR2 to NUMBER
END;
/
---------------------------------------------------------- 
--Example 8-14 Parameter Values Before, During, and After Procedure Invocation
CREATE OR REPLACE PROCEDURE p(a PLS_INTEGER, -- IN by default
                              b IN PLS_INTEGER,
                              c OUT PLS_INTEGER,
                              d IN OUT BINARY_FLOAT) AUTHID DEFINER IS
BEGIN
  -- Print values of parameters:
  DBMS_OUTPUT.PUT_LINE('Inside procedure p:');
  DBMS_OUTPUT.PUT('IN a = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(a), 'NULL'));
  DBMS_OUTPUT.PUT('IN b = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(b), 'NULL'));
  DBMS_OUTPUT.PUT('OUT c = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(c), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('IN OUT d = ' || TO_CHAR(d));
  -- Can reference IN parameters a and b,
  -- but cannot assign values to them.
  c := a + 10; -- Assign value to OUT parameter
  d := 10 / b; -- Assign value to IN OUT parameter
END;
/
DECLARE
  aa CONSTANT PLS_INTEGER := 1;
  bb PLS_INTEGER := 2;
  cc PLS_INTEGER := 3;
  dd BINARY_FLOAT := 4;
  ee PLS_INTEGER;
  ff BINARY_FLOAT := 5;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Before invoking procedure p:');
  DBMS_OUTPUT.PUT('aa = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(aa), 'NULL'));
  DBMS_OUTPUT.PUT('bb = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(bb), 'NULL'));
  DBMS_OUTPUT.PUT('cc = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(cc), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('dd = ' || TO_CHAR(dd));
  p(aa, -- constant
    bb, -- initialized variable
    cc, -- initialized variable
    dd -- initialized variable
    );
  DBMS_OUTPUT.PUT_LINE('After invoking procedure p:');
  DBMS_OUTPUT.PUT('aa = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(aa), 'NULL'));
  DBMS_OUTPUT.PUT('bb = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(bb), 'NULL'));
  DBMS_OUTPUT.PUT('cc = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(cc), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('dd = ' || TO_CHAR(dd));
  DBMS_OUTPUT.PUT_LINE('Before invoking procedure p:');
  DBMS_OUTPUT.PUT('ee = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(ee), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('ff = ' || TO_CHAR(ff));
  p(1, -- literal
    (bb + 3) * 4, -- expression
    ee, -- uninitialized variable
    ff -- initialized variable
    );
  DBMS_OUTPUT.PUT_LINE('After invoking procedure p:');
  DBMS_OUTPUT.PUT('ee = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(ee), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('ff = ' || TO_CHAR(ff));
END;
/
---------------------------------------------------------- 
--Example 8-15 OUT and IN OUT Parameter Values After Exception Handling
DECLARE
  j PLS_INTEGER := 10;
  k BINARY_FLOAT := 15;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Before invoking procedure p:');
  DBMS_OUTPUT.PUT('j = ');
  DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(j), 'NULL'));
  DBMS_OUTPUT.PUT_LINE('k = ' || TO_CHAR(k));
  p(4, 0, j, k); -- causes p to exit with exception ZERO_DIVIDE
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('After invoking procedure p:');
    DBMS_OUTPUT.PUT('j = ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(j), 'NULL'));
    DBMS_OUTPUT.PUT_LINE('k = ' || TO_CHAR(k));
END;
/
---------------------------------------------------------- 
--Example 8-16 OUT Formal Parameter of Record Type with Non-NULL Default Value
CREATE OR REPLACE PACKAGE r_types AUTHID DEFINER IS
  TYPE r_type_1 IS RECORD(
    f VARCHAR2(5) := 'abcde');
  TYPE r_type_2 IS RECORD(
    f VARCHAR2(5));
END;
/
CREATE OR REPLACE PROCEDURE p(x OUT r_types.r_type_1, y OUT r_types.r_type_2, z OUT VARCHAR2)
  AUTHID CURRENT_USER IS
BEGIN
DBMS_OUTPUT.PUT_LINE('x.f is ' || NVL(x.f, 'NULL')); DBMS_OUTPUT.PUT_LINE('y.f is ' || NVL(y.f, 'NULL')); DBMS_OUTPUT.PUT_LINE('z is ' || NVL(z, 'NULL'));
END;
/
DECLARE r1 r_types.r_type_1; r2 r_types.r_type_2; s VARCHAR2(5) := 'fghij';
BEGIN
p(r1, r2, s);
END;
/
---------------------------------------------------------- 
--Example 8-17 Aliasing from Global Variable as Actual Parameter
DECLARE
  TYPE Definition IS RECORD(
    word    VARCHAR2(20),
    meaning VARCHAR2(200));
  TYPE Dictionary IS VARRAY(2000) OF Definition;
  lexicon Dictionary := Dictionary(); -- global variable
  PROCEDURE add_entry(word_list IN OUT NOCOPY Dictionary -- formal NOCOPY parameter
                      ) IS
  BEGIN
    word_list(1).word := 'aardvark';
  END;
BEGIN
  lexicon.EXTEND;
  lexicon(1).word := 'aardwolf';
  add_entry(lexicon); -- global variable is actual parameter
  DBMS_OUTPUT.PUT_LINE(lexicon(1).word);
END;
/
---------------------------------------------------------- 
--Example 8-18 Aliasing from Same Actual Parameter for Multiple Formal Parameters
DECLARE
  n NUMBER := 10;
  PROCEDURE p(n1 IN NUMBER, n2 IN OUT NUMBER, n3 IN OUT NOCOPY NUMBER) IS
  BEGIN
    n2 := 20; -- actual parameter is 20 only after procedure succeeds
    DBMS_OUTPUT.put_line(n1); -- actual parameter value is still 10
    n3 := 30; -- might change actual parameter immediately
    DBMS_OUTPUT.put_line(n1); -- actual parameter value is either 10 or 30
  END;
BEGIN
  p(n, n, n);
  DBMS_OUTPUT.put_line(n);
END;
/

----------------------------------------------------------
--Example 8-19 Aliasing from Cursor Variable Subprogram Parameters
DECLARE
  TYPE EmpCurTyp IS REF CURSOR;
  c1 EmpCurTyp;
  c2 EmpCurTyp;
  PROCEDURE get_emp_data(emp_cv1 IN OUT EmpCurTyp,
                         emp_cv2 IN OUT EmpCurTyp) IS
    emp_rec employees%ROWTYPE;
  BEGIN
    OPEN emp_cv1 FOR
      SELECT * FROM employees;
    emp_cv2 := emp_cv1; -- now both variables refer to same location
    FETCH emp_cv1
      INTO emp_rec; -- fetches first row of employees
    FETCH emp_cv1
      INTO emp_rec; -- fetches second row of employees
    FETCH emp_cv2
      INTO emp_rec; -- fetches third row of employees
    CLOSE emp_cv1; -- closes both variables
    FETCH emp_cv2
      INTO emp_rec; -- causes error when get_emp_data is invoked
  END;
BEGIN
  get_emp_data(c1, c2);
END;
/
 
---------------------------------------------------------- 
--Example 8-20 Procedure with Default Parameter Values
DECLARE
  PROCEDURE raise_salary(emp_id IN employees.employee_id%TYPE,
                         amount IN employees.salary%TYPE := 100,
                         extra  IN employees.salary%TYPE := 50) IS
  BEGIN
    UPDATE employees
       SET salary = salary + amount + extra
     WHERE employee_id = emp_id;
  END raise_salary;
BEGIN
  raise_salary(120); -- same as raise_salary(120, 100, 50)
  raise_salary(121, 200); -- same as raise_salary(121, 200, 50)
END;
/

----------------------------------------------------------
--Example 8-21 Function Provides Default Parameter Value
DECLARE
  global PLS_INTEGER := 0;
  FUNCTION f RETURN PLS_INTEGER IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside f.');
    global := global + 1;
    RETURN global * 2;
  END f;
  PROCEDURE p(x IN PLS_INTEGER := f()) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Inside p. ' || ' global = ' || global ||
                         ', x = ' || x || '.');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
  END p;
  PROCEDURE pre_p IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Before invoking p, global = ' || global || '.');
    DBMS_OUTPUT.PUT_LINE('Invoking p.');
  END pre_p;
BEGIN
  pre_p;
  p(); -- default expression is evaluated
  pre_p;
  p(100); -- default expression is not evaluated
  pre_p;
  p(); -- default expression is evaluated
END;
/
---------------------------------------------------------- 
--Example 8-22 Adding Subprogram Parameter Without Changing Existing Invocations
--Create procedure:
CREATE OR REPLACE PROCEDURE print_name(first VARCHAR2, last VARCHAR2) AUTHID DEFINER IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(first || ' ' || last);
END print_name;
/
--Invoke procedure:
BEGIN
print_name('John', 'Doe');
END;
/

--Add third parameter with default value:
CREATE OR REPLACE PROCEDURE print_name(first VARCHAR2,
                                       last  VARCHAR2,
                                       mi    VARCHAR2 := NULL) AUTHID DEFINER IS
BEGIN
  IF mi IS NULL THEN
    DBMS_OUTPUT.PUT_LINE(first || ' ' || last);
  ELSE
    DBMS_OUTPUT.PUT_LINE(first || ' ' || mi || '. ' || last);
  END IF;
END print_name;
/
--Invoke procedure:
BEGIN
  print_name('John', 'Doe'); -- original invocation
  print_name('John', 'Public', 'Q'); -- new invocation
END;
/
----------------------------------------------------------
--Example 8-23 Equivalent Invocations with Different Notations in Anonymous Block
DECLARE
  emp_num NUMBER(6) := 120;
  bonus   NUMBER(6) := 50;
  PROCEDURE raise_salary(emp_id NUMBER, amount NUMBER) IS
  BEGIN
    UPDATE employees
       SET salary = salary + amount
     WHERE employee_id = emp_id;
  END raise_salary;
BEGIN
  -- Equivalent invocations:
  raise_salary(emp_num, bonus); -- positional notation
  raise_salary(amount => bonus, emp_id => emp_num); -- named notation
  raise_salary(emp_id => emp_num, amount => bonus); -- named notation
  raise_salary(emp_num, amount => bonus); -- mixed notation
END;
/
----------------------------------------------------------
--Example 8-24 Equivalent Invocations with Different Notations in SELECT Statements
CREATE OR REPLACE FUNCTION compute_bonus(emp_id NUMBER, bonus NUMBER)
  RETURN NUMBER AUTHID DEFINER IS
  emp_sal NUMBER;
BEGIN
  SELECT salary INTO emp_sal FROM employees WHERE employee_id = emp_id;
  RETURN emp_sal + bonus;
END compute_bonus;
/
SELECT compute_bonus(120, 50) FROM DUAL; -- positional
SELECT compute_bonus(bonus => 50, emp_id => 120) FROM DUAL; -- named
SELECT compute_bonus(120, bonus => 50) FROM DUAL; -- mixed
----------------------------------------------------------
--Example 8-26 Overloaded Subprogram
DECLARE
  TYPE date_tab_typ IS TABLE OF DATE INDEX BY PLS_INTEGER;
  TYPE num_tab_typ IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  hiredate_tab date_tab_typ;
  sal_tab      num_tab_typ;
  PROCEDURE initialize(tab OUT date_tab_typ, n INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Invoked first version');
    FOR i IN 1 .. n LOOP
      tab(i) := SYSDATE;
    END LOOP;
  END initialize;
  PROCEDURE initialize(tab OUT num_tab_typ, n INTEGER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Invoked second version');
    FOR i IN 1 .. n LOOP
      tab(i) := 0.0;
    END LOOP;
  END initialize;
BEGIN
  initialize(hiredate_tab, 50);
  initialize(sal_tab, 100);
END;
/
 
----------------------------------------------------------
--Example 8-27 Overload Error Causes Compile-Time Error
CREATE OR REPLACE PACKAGE pkg1 AUTHID DEFINER IS
  PROCEDURE s(p VARCHAR2);
  PROCEDURE s(p VARCHAR2);
END pkg1;
/
--Example 8-28 Overload Error Compiles Successfully
CREATE OR REPLACE PACKAGE pkg2 AUTHID DEFINER IS
  SUBTYPE t1 IS VARCHAR2(10);
  SUBTYPE t2 IS VARCHAR2(10);
  PROCEDURE s(p t1);
  PROCEDURE s(p t2);
END pkg2;
/
--Example 8-29 Invoking Subprogram in Example 8-28 Causes Compile-Time Error
CREATE OR REPLACE PROCEDURE p AUTHID DEFINER IS
  a pkg2.t1 := 'a';
BEGIN
  pkg2.s(a); -- Causes compile-time error PLS-00307
END p;
/
--Example 8-30 Correcting Overload Error in Example 8-28
CREATE OR REPLACE PACKAGE pkg2 AUTHID DEFINER IS
  SUBTYPE t1 IS VARCHAR2(10);
  SUBTYPE t2 IS VARCHAR2(10);
  PROCEDURE s(p1 t1);
  PROCEDURE s(p2 t2);
END pkg2;
/
--Example 8-31 Invoking Subprogram in Example 8-30
CREATE OR REPLACE PROCEDURE p AUTHID DEFINER IS
  a pkg2.t1 := 'a';
BEGIN
  pkg2.s(p1 => a); -- Compiles without error
END p;
/
--Example 8-32 Package Specification Without Overload Errors
CREATE OR REPLACE PACKAGE pkg3 AUTHID DEFINER IS
  PROCEDURE s(p1 VARCHAR2);
  PROCEDURE s(p1 VARCHAR2, p2 VARCHAR2 := 'p2');
END pkg3;
/
--Example 8-33 Improper Invocation of Properly Overloaded Subprogram
CREATE OR REPLACE PROCEDURE p AUTHID DEFINER IS
  a1 VARCHAR2(10) := 'a1';
  a2 VARCHAR2(10) := 'a2';
BEGIN
  pkg3.s(p1 => a1, p2 => a2); -- Compiles without error
  pkg3.s(p1 => a1); -- Causes compile-time error PLS-00307
END p;
/
--Example 8-34 Implicit Conversion of Parameters Causes Overload Error
CREATE OR REPLACE PACKAGE pack1 AUTHID DEFINER AS
  PROCEDURE proc1(a NUMBER, b VARCHAR2);
  PROCEDURE proc1(a NUMBER, b NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY pack1 AS
  PROCEDURE proc1(a NUMBER, b VARCHAR2) IS
  BEGIN
    NULL;
  END;
  PROCEDURE proc1(a NUMBER, b NUMBER) IS
  BEGIN
    NULL;
  END;
END;
/
BEGIN
  pack1.proc1(1, '2'); -- Compiles without error
  pack1.proc1(1, 2); -- Compiles without error
  pack1.proc1('1', '2'); -- Causes compile-time error PLS-00307
  pack1.proc1('1', 2); -- Causes compile-time error PLS-00307
END;
/
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
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 
---------------------------------------------------------- 















































































