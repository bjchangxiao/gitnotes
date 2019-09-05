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

