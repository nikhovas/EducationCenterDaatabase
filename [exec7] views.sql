-- PERSON
CREATE OR REPLACE VIEW PERSON_VIEW AS
SELECT birth_dt,
       SUBSTRING(inn_no, 1, 3) || 'xxxxxxxxxx' || SUBSTRING(inn_no, LENGTH(inn_no) - 2, LENGTH(inn_no)) as inn_no,
       email_txt,
       phone_no,
       person_name_nm
FROM (
      SELECT person_id, birth_dt, CAST(inn_no AS VARCHAR(15)) AS inn_no, email_txt, phone_no
      FROM PERSON
     ) t1
INNER JOIN PERSON_DOCUMENT t2 ON t1.person_id = t2.person_id
WHERE t2.valid_to_dttm = '9999-12-31';

-- PERSON_DOCUMENT
CREATE OR REPLACE VIEW  PERSON_DOCUMENT_VIEW AS
SELECT document_series, document_no, document_type_txt, person_name_nm, authority_no
FROM PERSON_DOCUMENT
WHERE valid_to_dttm = '9999-12-31';

-- PERSON_HOME_ADDRESS
CREATE OR REPLACE VIEW PERSON_HOME_ADDRESS_VIEW AS
SELECT person_name_nm, address_txt
FROM PERSON_HOME_ADDRESS t1
INNER JOIN PERSON_DOCUMENT t2 ON t1.person_id = t2.person_id
WHERE t1.valid_to_dttm = '9999-12-31';

-- PERSON_X_PERSON
CREATE OR REPLACE VIEW PERSON_X_PERSON_VIEW AS
SELECT t2.person_name_nm, t3.person_name_nm AS x_person_name_nm, connection_type_txt
FROM PERSON_X_PERSON t1
INNER JOIN PERSON_DOCUMENT t2 ON t1.person_id = t2.person_id
INNER JOIN PERSON_DOCUMENT t3 ON t1.x_person_id = t3.person_id
WHERE t2.valid_to_dttm = '9999-12-31' AND t3.valid_to_dttm = '9999-12-31';

-- STUDENT_PERSON
CREATE OR REPLACE VIEW STUDENT_PERSON_VIEW AS
SELECT birth_dt,
       SUBSTRING(inn_no, 1, 3) || 'xxxxxxxxxx' || SUBSTRING(inn_no, LENGTH(inn_no) - 2, LENGTH(inn_no)) as inn_no,
       email_txt,
       phone_no,
       person_name_nm, visits_start_dt
FROM (
      SELECT person_id, birth_dt, CAST(inn_no AS VARCHAR(15)) AS inn_no, email_txt, phone_no
      FROM PERSON
     ) t1
INNER JOIN PERSON_DOCUMENT t2 ON t1.person_id = t2.person_id
INNER JOIN STUDENT_PERSON t3 ON t1.person_id = t3.person_id
WHERE t2.valid_to_dttm = '9999-12-31';


-- TEACHER_PERSON
CREATE OR REPLACE VIEW TEACHER_PERSON_VIEW AS
  select birth_dt,
         SUBSTRING(inn_no, 1, 3) || 'xxxxxxxxxx' || SUBSTRING(inn_no, LENGTH(inn_no) - 2, LENGTH(inn_no)) as inn_no,
         email_txt,
         phone_no,
         person_name_nm,
         working_start_dt,
         salary_amt,
         'xxxx' || SUBSTRING(employment_record_no, LENGTH(employment_record_no) - 4, LENGTH(employment_record_no))
           AS employment_record_no
  from (
        SELECT person_id, birth_dt, CAST(inn_no AS VARCHAR(15)) AS inn_no, email_txt, phone_no
        FROM PERSON
       ) t1
    inner join PERSON_DOCUMENT t2 ON t1.person_id = t2.person_id
    INNER JOIN (
      select person_id, working_start_dt, salary_amt, CAST(employment_record_no AS VARCHAR(15)) AS employment_record_no
      from TEACHER_PERSON
    ) t3 on t1.person_id = t3.person_id
  WHERE t2.valid_to_dttm = '9999-12-31';

-- COURSE
CREATE OR REPLACE VIEW COURSE_VIEW AS
  SELECT sphere_txt, name_txt, COURSE_start_dt, COURSE_end_dt, month_price_amt, person_name_nm AS teacher
  FROM COURSE t1
  INNER JOIN PERSON_DOCUMENT t2 ON t1.TEACHER_PERSON_id = t2.person_id;

-- COURSE_CLASS
CREATE OR REPLACE VIEW COURSE_CLASS_VIEW AS
  SELECT week_day_txt, start_tm, end_tm, sphere_txt, name_txt
  FROM COURSE_class t1
  INNER JOIN COURSE t2 ON t1.COURSE_id = t2.COURSE_id;

-- CONTRACT
CREATE OR REPLACE VIEW CONTRACT_VIEW AS
  SELECT sphere_txt,
         name_txt,
         t2.person_name_nm AS STUDENT_PERSON,
         t3.person_name_nm AS payer_person,
         CONTRACT_dttm,
         termination_dttm
  FROM CONTRACT t1
  INNER JOIN PERSON_DOCUMENT t2 ON t1.STUDENT_PERSON_id = t2.person_id
  INNER JOIN COURSE t4 ON t1.COURSE_id = t4.COURSE_id
  LEFT JOIN PERSON_DOCUMENT t3 ON t1.payer_person_id = t3.person_id
  WHERE t2.valid_to_dttm = '9999-12-31' AND t3.valid_to_dttm = '9999-12-31'
  UNION
  SELECT sphere_txt,
         name_txt,
         t2.person_name_nm as STUDENT_PERSON,
         NULL as payer_person,
         CONTRACT_dttm,
         termination_dttm
  FROM (
    select CONTRACT_id, CONTRACT_dttm, STUDENT_PERSON_id, COURSE_id, termination_dttm
    from CONTRACT
    where payer_person_id IS NULL
    ) t1
  INNER JOIN PERSON_DOCUMENT t2 ON t1.STUDENT_PERSON_id = t2.person_id
  INNER JOIN COURSE t4 ON t1.COURSE_id = t4.COURSE_id
  WHERE t2.valid_to_dttm = '9999-12-31';

-- CONTRACT PAYMENT
CREATE OR REPLACE VIEW CONTRACT_PAYMENT_VIEW AS
  SELECT sphere_txt, name_txt, person_name_nm, payment_dttm, payment_amt, classes_year_no, CASE classes_month_no
    WHEN 1 THEN 'ЯНВ'
    WHEN 2 THEN 'ФЕВ'
    WHEN 3 THEN 'МАР'
    WHEN 4 THEN 'АПР'
    WHEN 5 THEN 'МАЙ'
    WHEN 6 THEN 'ИЮН'
    WHEN 7 THEN 'ИЮЛ'
    WHEN 8 THEN 'АВГ'
    WHEN 9 THEN 'СЕН'
    WHEN 10 THEN 'ОКТ'
    WHEN 11 THEN 'НОЯ'
    WHEN 12 THEN 'ДЕК'
    ELSE 'ОШИ'
    END AS month
  FROM CONTRACT_PAYMENT t1
  INNER JOIN CONTRACT t2 ON t1.CONTRACT_id = t2.CONTRACT_id
  INNER JOIN COURSE t3 ON t2.COURSE_id = t3.COURSE_id
  INNER JOIN PERSON_DOCUMENT t4 ON t2.STUDENT_PERSON_id = t4.person_id
  WHERE t4.valid_to_dttm = '9999-12-31';

-- COMPLETION_CERTIFICATE
CREATE OR REPLACE VIEW COMPLETION_CERTIFICATE_VIEW AS
  SELECT sphere_txt, name_txt, person_name_nm, classes_start_dt, classes_end_dt
  FROM COMPLETION_CERTIFICATE t1
  INNER JOIN COURSE t2 ON t1.COURSE_id = t2.COURSE_id
  INNER JOIN PERSON_DOCUMENT t3 ON t1.STUDENT_PERSON_id = t3.person_id
  WHERE t3.valid_to_dttm = '9999-12-31';
