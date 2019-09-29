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















































































