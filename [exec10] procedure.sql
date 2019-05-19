CREATE OR REPLACE FUNCTION add_client(_person_name_mn VARCHAR(100),
_address_txt VARCHAR(200), _birth_dt DATE, _inn_no VARCHAR(12), _email_txt VARCHAR(100), _phone_no VARCHAR(20),
_document_series VARCHAR(10), _document_no INT, _document_type_txt VARCHAR(20), _document_authority_no VARCHAR(20)
)
 RETURNS INT
AS $$
DECLARE
  new_person_id INT;
BEGIN
  IF EXISTS(
    SELECT 1
    FROM PERSON_DOCUMENT pd
    WHERE pd.document_series = _document_series
      AND pd.document_no = _document_no
      AND pd.document_type_txt = _document_type_txt
  ) THEN RAISE 'cannot create user with document which is already in database';
  ELSEIF EXISTS (
    SELECT 1
    FROM PERSON p
    WHERE p.inn_no = _inn_no
  ) THEN RAISE 'cannot create user with inn which is already in database';
  END IF;

  INSERT INTO PERSON(BIRTH_DT, INN_NO, EMAIL_TXT, PHONE_NO)
  VALUES (_birth_dt, _inn_no, _email_txt, _phone_no) RETURNING person_id INTO new_person_id;

  INSERT INTO PERSON_DOCUMENT(document_no, document_series, document_type_txt, person_id, person_name_nm, authority_no, valid_from_dttm)
  VALUES (_document_no, _document_series, _document_type_txt, new_person_id, _person_name_mn, _document_authority_no, now());

  INSERT INTO PERSON_HOME_ADDRESS(person_id, address_txt, valid_from_dttm)
  VALUES (new_person_id, _address_txt, now());

  RETURN new_person_id;
END;

$$ LANGUAGE plpgsql;





select * from add_client(
  'fhgffhg gh ghgjh',
  'ghjkhgfdsdfghjjhgfdsdfgh', '12-12-1999', '123456789012', 'email@email.com', '+79990808087',
  '8006', 754324, 'Паспорт РФ', '564-985'
);


select * from add_client(
  'Акафьев Анатолий Иванович',
  'г. Долгопрудный, ул. Строителей, д. 48, кв. 7', '12-12-1999', '123456789000', 'address@example.com', '+79990808087',
  '8096', 752224, 'Паспорт РФ', '564-985'
);

