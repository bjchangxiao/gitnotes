create or replace function func_changxiao_dec(input_string       VARCHAR2)
return varchar
as
   output_string      VARCHAR2 (200);
   encrypted_raw      RAW (2000);             -- stores encrypted binary text
   decrypted_raw      RAW (2000);             -- stores decrypted binary text
   num_key_bytes      NUMBER := 256/8;        -- key length 256 bits (32 bytes)
   key_bytes_raw      RAW (32);               -- stores 256-bit encryption key
   encryption_type    PLS_INTEGER :=          -- total encryption type
                            DBMS_CRYPTO.ENCRYPT_AES256
                          + DBMS_CRYPTO.CHAIN_CBC
                          + DBMS_CRYPTO.PAD_PKCS5;
BEGIN
  --select func_changxiao_enc('the shi sa') from dual;
--select func_changxiao_de('BBAF9259A41236C55790ACF6A0DAC302') from dual;

 --  DBMS_OUTPUT.PUT_LINE ( 'Original string: ' || input_string);
 --  key_bytes_raw := DBMS_CRYPTO.RANDOMBYTES (num_key_bytes);
   key_bytes_raw := UTL_I18N.string_to_raw('sAoSklds$sd@#$50swSfS(&*%$$^%GH2','AL32UTF8');
    -- The encrypted value "encrypted_raw" can be used here
   decrypted_raw := DBMS_CRYPTO.DECRYPT
      (
         src => input_string,
         typ => encryption_type,
         key => key_bytes_raw
      );
   output_string := UTL_I18N.RAW_TO_CHAR (decrypted_raw, 'AL32UTF8');

 --  DBMS_OUTPUT.PUT_LINE ('Decrypted string: ' || output_string);
   return output_string;
EXCEPTION
  WHEN OTHERS THEN
    RETURN input_string;
END;
/
