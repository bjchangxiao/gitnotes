DROP TABLE my_table PURGE;
create table my_table(
json_doc blob,
constraint cons_json_check check(json_doc is json));
insert into my_table(json_doc)
values(
utl_raw.convert(utl_raw.cast_to_raw('{"PONumber" : 1600,
"Reference" : "ABULL-20140421",
"Requestor" : "Alexis Bull",
"User" : "ABULL",
"CostCenter" : "A50",
"ShippingInstructions" : {"name" : "Alexis Bull",
"Address" : {"street" : "200 Sporting Green",
"city" : "South San Francisco",
"state" : "CA",
"zipCode" : 99236,
"country" : "United States of America"},
"Phone" : [{"type" : "Office", "number" :
"909-555-7307"},
{"type" : "Mobile", "number" :
"415-555-1234"}]},
"Special Instructions" : null,
"AllowPartialShipment" : true,
"LineItems" : [{"ItemNumber" : 1,
"Part" : {"Description" : "One Magic Christmas",
"UnitPrice" : 19.95,
"UPCCode" : 13131092899},
"Quantity" : 9.0},
{"ItemNumber" : 2,
"Part" : {"Description" : "Lethal Weapon",
"UnitPrice" : 19.95,
"UPCCode" : 85391628927},
"Quantity" : 5.0}]}'),'AL32UTF8','WE8MSWIN1252')
);
insert into my_table(json_doc)
values(
utl_raw.convert(utl_raw.cast_to_raw('{"PONumber" : 1600,
"Reference" : "ABULL-20140421",
"Requestor" : "Alexis Bull",
"User" : "ABULL",
"CostCenter" : "A50",
"ShippingInstructions" : {"name" : "Alexis Bull",
"Address" : {"street" : "200 Sporting Green",
"city" : "北京",
"state" : "CA",
"zipCode" : 99236,
"country" : "中国人民共和国"},
"Phone" : [{"type" : "Office", "number" :
"909-555-7307"},
{"type" : "Mobile", "number" :
"415-555-1234"}]},
"Special Instructions" : null,
"AllowPartialShipment" : true,
"LineItems" : [{"ItemNumber" : 1,
"Part" : {"Description" : "One Magic Christmas",
"UnitPrice" : 19.95,
"UPCCode" : 13131092899},
"Quantity" : 9.0},
{"ItemNumber" : 2,
"Part" : {"Description" : "Lethal Weapon",
"UnitPrice" : 19.95,
"UPCCode" : 85391628927},
"Quantity" : 5.0}]}'),'AL16UTF16','ZHS16GBK')
);
SELECT * FROM my_table;
drop table J_PURCHASEORDER purge;
create table J_PURCHASEORDER
(
  id          VARCHAR2(32) not null,
  date_loaded TIMESTAMP(6) WITH TIME ZONE,
  po_document VARCHAR2(4000)
)
tablespace test
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table J_PURCHASEORDER
  add primary key (ID)
  using index 
  tablespace test
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate check constraints 
alter table J_PURCHASEORDER
  add constraint ENSURE_JOSON
  check (PO_DOCUMENT IS JSON);
insert into J_PURCHASEORDER
values(sys_guid(),sysdate,'{"PONumber" : 1600,
"Reference" : "ABULL-20140421",
"Requestor" : "Alexis Bull",
"User" : "ABULL",
"CostCenter" : "A50",
"ShippingInstructions" : {"name" : "Alexis Bull",
"Address" : {"street" : "200 Sporting Green",
"city" : "South San Francisco",
"state" : "CA",
"zipCode" : 99236,
"country" : "United States of America"},
"Phone" : [{"type" : "Office", "number" :
"909-555-7307"},
{"type" : "Mobile", "number" :
"415-555-1234"}]},
"Special Instructions" : null,
"AllowPartialShipment" : true,
"LineItems" : [{"ItemNumber" : 1,
"Part" : {"Description" : "One Magic Christmas",
"UnitPrice" : 19.95,
"UPCCode" : 13131092899},
"Quantity" : 9.0},
{"ItemNumber" : 2,
"Part" : {"Description" : "Lethal Weapon",
"UnitPrice" : 19.95,
"UPCCode" : 85391628927},
"Quantity" : 5.0}]}');
insert into J_PURCHASEORDER
values(sys_guid(),sysdate,'{"PONumber" : 672,
"Reference" : "SBELL-20141017",
"Requestor" : "Sarah Bell",
"User" : "SBELL",
"CostCenter" : "A50",
"ShippingInstructions" : {"name" : "Sarah Bell",
"Address" : {"street" : "200 Sporting Green",
"city" : "South San Francisco",
"state" : "CA",
"zipCode" : 99236,
"country" : "United States of America"},
"Phone" : "983-555-6509"},
"Special Instructions" : "Courier",
"LineItems" : [{"ItemNumber" : 1,
"Part" : {"Description" : "Making the Grade",
"UnitPrice" : 20,
"UPCCode" : 27616867759},
"Quantity" : 8.0},
{"ItemNumber" : 2,
"Part" : {"Description" : "Nixon",
"UnitPrice" : 19.95,
"UPCCode" : 717951002396},
"Quantity" : 5},
{"ItemNumber" : 3,
"Part" : {"Description" : "Eric Clapton: Best Of 1981-1999",
"UnitPrice" : 19.95,
"UPCCode" : 75993851120},
"Quantity" : 5.0}
]}');
select * from j_purchaseorder;
--19c才有这个json_mergepath
UPDATE j_purchaseorder
   SET po_document = json_mergepatch(po_document,
                                     '{"Special Instructions":"1"}');
SELECT json_mergepatch(po_document,
                       '{"Special Instructions":null}' RETURNING CLOB PRETTY)
  FROM j_purchaseorder;

select * from user_tables;
select * from j_purchaseorder;
select json_query(po_document, '$.LineItems' WITH ARRAY WRAPPER),
       json_query(po_document, '$.LineItems[0]' WITH ARRAY WRAPPER),
       json_query(po_document, '$.LineItems[1]' WITH ARRAY WRAPPER),
       json_query(po_document,
                  '$.LineItems[1].ItemNumber' WITH ARRAY WRAPPER),
       json_query(po_document, '$.LineItems[2].Part' WITH ARRAY WRAPPER),
       json_query(po_document, '$.LineItems[2].*' WITH ARRAY WRAPPER),
       
       json_query(po_document, '$.LineItems[*].Part' WITH ARRAY WRAPPER),
       po_document
  from j_purchaseorder;
select json_query(po_document,
                  '$.LineItems[*].Part?(@.UnitPrice==19.95)' WITH ARRAY
                  WRAPPER),
       po_document
  from j_purchaseorder;
select json_query(po_document,
                  '$.LineItems[*]?(@.Part.UnitPrice==19.95)' WITH ARRAY
                  WRAPPER),
       po_document
  from j_purchaseorder;
select t.*, t.rowid from j_purchaseorder t;
select json_query(po_document,
                  '$..UnitPrice' WITH ARRAY
                  WRAPPER),
       po_document
  from j_purchaseorder;
select t.*, t.rowid from j_purchaseorder t;

--returning 
SELECT CAST(JSON_VALUE('{"a":"2019-01-02T12:34:56"}',
                       '$.a' RETURNING TIMESTAMP) AS DATE)
  FROM DUAL;
--JSON IS CASE-SENSTIVE
SELECT JSON_VALUE('{"A":"TET"}', '$.A' RETURNING VARCHAR2) FROM DUAL;

SELECT JSON_QUERY('{"ID":38327}', '$.ID' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('{"ID":38327}', '$.ID' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('{"ID":38327}', '$.ID' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('[42,"A",true]', '$' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[42,"A",true]', '$' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[42,"A",true]', '$' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('{a:100, b:200, c:300}', '$.*' WITH WRAPPER) AS value
  FROM DUAL;
SELECT JSON_QUERY('{a:100, b:200, c:300}', '$.*' WITHOUT WRAPPER) AS value
  FROM DUAL;
SELECT JSON_QUERY('{a:100, b:200, c:300}', '$.*' WITH CONDITIONAL WRAPPER) AS value
  FROM DUAL;

SELECT JSON_QUERY('42', '$' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('42', '$' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('42', '$' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('42,"A",true', '$' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('42,"A",true', '$' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('42,"A",true', '$' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('[0,1,2,3,4]','$') FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4]','$' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4]','$' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4]','$' WITH CONDITIONAL WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4]','$[*]') FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4]','$[*]' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[0,1,2,3,4,5,6,7,8]', '$[0,3,5,7]' WITH WRAPPER)
  FROM DUAL;
--ERROR USE TO BUT THE OFFICIAL DOCUMENTS CITE THIS AS AN EXAMPLE
SELECT JSON_QUERY('[0,1,2,3,4,5,6,7,8]', '$[0, 3 TO 5, 7]' WITH WRAPPER) AS value
  FROM DUAL;

SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[0]') FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[0]' WITH CONDITIONAL WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[0]' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[0]' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[*]' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[*]' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[*]' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[*]' RETURNING VARCHAR2 WITH CONDITIONAL WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[1]' ) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[9]' ) FROM DUAL;
SELECT JSON_QUERY('[{A:100},{B:200},{C:300}]','$[9]' EMPTY ON ERROR ) FROM DUAL;

--double quota is not necessary!!!
SELECT JSON_QUERY('[{"A":100},{B:200},{"C":300}]','$[0]') FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[0]' WITH CONDITIONAL WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[0]' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[0]' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[*]' WITHOUT WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[*]' WITH WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[*]' WITH CONDITIONAL WRAPPER) FROM DUAL;

SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[*]' RETURNING VARCHAR2 WITH CONDITIONAL WRAPPER) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[1]' ) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[9]' ) FROM DUAL;
SELECT JSON_QUERY('[{"A":100},{"B":200},{"C":300}]','$[9]' EMPTY ON ERROR ) FROM DUAL;


SELECT JSON_QUERY('[{"A":100}]','$[9]' ERROR ON ERROR ) FROM DUAL;
SELECT JSON_QUERY('[{"A":100}]','$[9]' NULL ON ERROR ) FROM DUAL;

CREATE TABLE t (name VARCHAR2(100));
INSERT INTO t VALUES ('[{first:"John"}, {middle:"Mark"}, {last:"Smith"}]');
INSERT INTO t VALUES ('[{first:"Mary"}, {last:"Jones"}]');
INSERT INTO t VALUES ('[{first:"Jeff"}, {last:"Williams"}]');
INSERT INTO t VALUES ('[{first:"Jean"}, {middle:"Anne"}, {last:"Brown"}]');
INSERT INTO t VALUES (NULL);
INSERT INTO t VALUES ('This is not well-formed JSON data');
commit;
SELECT name FROM t WHERE JSON_EXISTS(name, '$[0].first');
SELECT name FROM t WHERE JSON_EXISTS(name, '$[0].first2');
SELECT name FROM t WHERE JSON_EXISTS(name, '$[0].first2' false on error);
SELECT name FROM t WHERE JSON_EXISTS(name, '$[1].middle' TRUE ON ERROR);

SELECT JSON_QUERY('[{"A":100}]','$[9]' EMPTY OBJECT ON ERROR ) FROM DUAL;
SELECT JSON_QUERY('[{"A":100}]','$[9]' EMPTY ARRAY ON ERROR ) FROM DUAL;
SELECT JSON_QUERY('[{"A":100}]','$[9]' DEFAULT '{"A":900}' ON ERROR) FROM DUAL;

SELECT JSON_VALUE('{a:100}', '$.a') AS value FROM DUAL;
SELECT JSON_VALUE('{a:100}', '$.a' RETURNING NUMBER) AS value FROM DUAL;
SELECT JSON_VALUE('{a:{b:100}}', '$.a.b') AS value FROM DUAL;
SELECT JSON_VALUE('{a:{b:100}}', '$.*.b') AS value FROM DUAL;
SELECT JSON_VALUE('{a:{b:100}, c:{d:200}, e:{f:300}}', '$.*.d') FROM DUAL;

SELECT JSON_VALUE('{A:{C:1200}}','$.A.C.D') FROM DUAL;
SELECT JSON_VALUE('{A:{C:1200}}','$.A.C.D' DEFAULT '100' ON ERROR) FROM DUAL;

SELECT JSON_VALUE('[0, 1, 2, 3]', '$[3]') AS value FROM DUAL;
SELECT JSON_VALUE('[0, 1, 2, 3]', '$[30]' DEFAULT 'A' ON ERROR) AS value FROM DUAL;
SELECT JSON_VALUE('{a:[5, 10, 15, 20]}', '$.a[2]') AS value FROM DUAL;
SELECT JSON_VALUE('[{a:100}, {a:200}, {a:300}]', '$[1].a') FROM DUAL;
SELECT JSON_VALUE('[{a:100}, {b:200}, {c:300}]', '$[*].c') FROM DUAL;
SELECT JSON_VALUE('{firstname:"John"}', '$.lastname') FROM DUAL;
SELECT JSON_VALUE('{firstname:"John"}', '$.lastname' null on error) FROM DUAL;
SELECT JSON_VALUE('{firstname:"John"}', '$.lastname' DEFAULT 'No last name found' ON ERROR) FROM DUAL;
SELECT JSON_VALUE('{firstname:"John"}', '$.lastname') FROM DUAL;

SELECT PO.*
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT, '$.LineItems.Part.UPCCode');

--three equivalent method
SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$?(@.LineItems.Part.UPCCode == 85391628927)');

SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$.LineItems?(@.Part.UPCCode == 85391628927)');

SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$.LineItems.Part?(@.UPCCode == 85391628927)');

--If you use this example or similar with SQL*Plus 
--then you must use SET DEFINE OFF
--first, so that SQL*Plus does not 
--interpret && exists as a substitution variable and
--prompt you to define it.
SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$?(@.LineItems.Part.UPCCode == 85391628927 && @.LineItems.Quantity > 3)');

SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$.LineItems?(@.Part.UPCCode == 85391628927 && @.Quantity > 3)');

SELECT PO.PO_DOCUMENT
  FROM J_PURCHASEORDER PO
 WHERE JSON_EXISTS(PO.PO_DOCUMENT,
                   '$?(@.User == "ABULL" && exists(@.LineItems?(@.Part.UPCCode == 85391628927 && @.Quantity > 3)))');


SELECT JT.*
  FROM J_PURCHASEORDER,
       JSON_TABLE(PO_DOCUMENT,
                  '$.ShippingInstructions.Phone[*]'
                  COLUMNS(ROW_NUMBER FOR ORDINALITY,
                          PHONE_TYPE VARCHAR2(10) PATH '$.type',
                          PHONE_NUM VARCHAR2(20) PATH '$.number')) AS JT;

SELECT REQUESTOR, HAS_ZIP
  FROM J_PURCHASEORDER,
       JSON_TABLE(PO_DOCUMENT,
                  '$' COLUMNS(REQUESTOR VARCHAR2(32) PATH '$.Requestor',
                          HAS_ZIP VARCHAR2(5) EXISTS PATH
                          '$.ShippingInstructions.Address.zipCode'));

SELECT REQUESTOR
  FROM J_PURCHASEORDER,
       JSON_TABLE(PO_DOCUMENT,
                  '$' COLUMNS(REQUESTOR VARCHAR2(32) PATH '$.Requestor',
                          HAS_ZIP VARCHAR2(5) EXISTS PATH
                          '$.ShippingInstructions.Address.zipCode'))
 WHERE (HAS_ZIP = 'true');

SELECT *
  FROM JSON_TABLE('[1,2,["a","b"]]',
                  '$'
                  COLUMNS(OUTER_VALUE_0 NUMBER PATH '$[0]',
                          OUTER_VALUE_1 NUMBER PATH '$[1]',
                          OUTER_VALUE_2 VARCHAR2(20) FORMAT JSON PATH '$[2]'));

SELECT *
  FROM JSON_TABLE('[1,2,["a","b"]]',
                  '$'
                  COLUMNS(OUTER_VALUE_0 NUMBER PATH '$[0]',
                          OUTER_VALUE_1 NUMBER PATH '$[1]',
                          NESTED PATH '$[2]'
                          COLUMNS(NESTED_VALUE_0 VARCHAR2(1) PATH '$[0]',
                                  NESTED_VALUE_1 VARCHAR2(1) PATH '$[1]')));

SELECT *
  FROM JSON_TABLE('{a:100, b:200, c:{d:300, e:400}}',
                  '$' COLUMNS(OUTER_VALUE_0 NUMBER PATH '$.a',
                          OUTER_VALUE_1 NUMBER PATH '$.b',
                          NESTED PATH '$.c'
                          COLUMNS(NESTED_VALUE_0 NUMBER PATH '$.d',
                                  NESTED_VALUE_1 NUMBER PATH '$.e')));

SELECT JT.*
  FROM J_PURCHASEORDER,
       JSON_TABLE(PO_DOCUMENT,
                  '$'
                  COLUMNS(REQUESTOR VARCHAR2(32) PATH '$.Requestor',
                          NESTED PATH '$.ShippingInstructions.Phone[*]'
                          COLUMNS(PHONE_TYPE VARCHAR2(32) PATH '$.type',
                                  PHONE_NUM VARCHAR2(20) PATH '$.number'))) AS JT;
