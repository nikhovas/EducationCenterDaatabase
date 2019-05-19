CREATE OR REPLACE FUNCTION change_previous_end_dttm() RETURNS trigger AS $trigger$
  BEGIN
    UPDATE PERSON_DOCUMENT
      SET valid_to_dttm = NEW.valid_from_dttm
      WHERE person_id = NEW.person_id
      AND valid_to_dttm = '9999-12-31'
      AND document_no <> NEW.document_no
      AND document_series <> NEW.document_series;
    RETURN NEW;
  END;
$trigger$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS change_previous_end_dttm_trigger ON PERSON_DOCUMENT;
CREATE TRIGGER change_previous_end_dttm_trigger AFTER INSERT ON PERSON_DOCUMENT
    FOR EACH ROW EXECUTE PROCEDURE change_previous_end_dttm();





CREATE OR REPLACE FUNCTION check_contracts_links() RETURNS trigger AS $trigger$
  BEGIN
    IF NOT EXISTS (
      SELECT 1
      FROM STUDENT_PERSON
      WHERE person_id = NEW.student_person_id
    ) THEN
      RAISE EXCEPTION 'no student with such student id';
    ELSEIF NOT EXISTS (
      SELECT 1
      FROM PERSON
      WHERE person_id = NEW.payer_person_id
    ) THEN
      RAISE EXCEPTION 'no person with such payer id';
    ELSEIF NOT EXISTS (
      SELECT 1
      FROM COURSE
      WHERE course_id = NEW.course_id
    ) THEN
      RAISE EXCEPTION 'no course with such course id';
    END IF;

    RETURN NULL;
  END;
$trigger$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS check_contracts_links_trigger ON CONTRACT;
CREATE TRIGGER check_contracts_links_trigger BEFORE INSERT ON CONTRACT
    FOR EACH ROW EXECUTE PROCEDURE check_contracts_links();




INSERT INTO PERSON_DOCUMENT(document_no, document_series, document_type_txt, person_id, person_name_nm, authority_no, valid_from_dttm)
VALUES (123456, 5432, 'Диппаспорт РФ', 14, 'Сергеев Сергей Сергеевич', '752-067', '2018-07-21 00:00:00');

SELECT *
FROM PERSON_DOCUMENT;

INSERT INTO CONTRACT(contract_dttm, student_person_id, payer_person_id, course_id, termination_dttm)
VALUES ('2019-01-01', 222, 222, 222, NULL);