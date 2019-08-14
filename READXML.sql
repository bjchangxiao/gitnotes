create or replace procedure test_clob(v_itemid number) as
  l_clob         CLOB;
  l_parser       DBMS_XMLPARSER.parser;
  l_doc          DBMS_XMLDOM.domdocument;
  l_nl           DBMS_XMLDOM.domnodelist;
  l_n            DBMS_XMLDOM.domnode;
  l_exists       number(9):=0;
  TYPE tab_type IS TABLE OF bps%ROWTYPE;
  t_tab tab_type := tab_type();
BEGIN
--https://oracle-base.com/articles/9i/parse-xml-documents-9i
-- create table BPS
--(
--  guid VARCHAR2(32)
--)
  delete from bps;
  -- make sure implicit date conversions are performed correctly
  DBMS_SESSION.set_nls('NLS_DATE_FORMAT', '''DD-MON-YYYY''');
  -- Create a parser.
  l_parser := DBMS_XMLPARSER.newparser;
  select count(1)
    into l_exists
    from t_BDSC_FASP2_SEND
   where itemid = v_itemid;
  if l_exists > 0 then
    select send_content
      into l_clob
      from t_BDSC_FASP2_SEND
     where itemid = v_itemid;
    -- Parse the document and create a new DOM document.
  
    DBMS_XMLPARSER.parseclob(l_parser, l_clob);
    l_doc := DBMS_XMLPARSER.getdocument(l_parser);
  
    -- Free resources associated with the CLOB and Parser now they are no longer needed.
    DBMS_XMLPARSER.freeparser(l_parser);
  
    -- Get a list of all the EMP nodes in the document using the XPATH syntax.
    l_nl := DBMS_XSLPROCESSOR.selectnodes(dbms_xmldom.makeNode(l_doc),
                                          '/sbp/body/paramters/paramter/data/items/item');
  
    -- Loop through the list and create a new record in a tble collection
    -- for each EMP record.
    FOR cur_emp IN 0 .. dbms_xmldom.getLength(l_nl) - 1 LOOP
      l_n := DBMS_XMLDOM.item(l_nl, cur_emp);
      t_tab.extend;
    
      -- Use XPATH syntax to assign values to he elements of the collection.
      DBMS_XSLPROCESSOR.valueof(l_n, 'guid/text()', t_tab(t_tab.last).guid);
    
    END LOOP;
  
    COMMIT;
    -- Insert data into the real EMP table from the table collection.
    FORALL i IN t_tab.first .. t_tab.last
      INSERT INTO bps VALUES t_tab (i);
  
    COMMIT;
    -- Free any resources associated with the document now it
    -- is no longer needed.
    DBMS_XMLDOM.freedocument(l_doc);
  end if;
  commit;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_XMLPARSER.freeparser(l_parser);
    DBMS_XMLDOM.freedocument(l_doc);
    RAISE;
END;
