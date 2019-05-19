-- PERSON TABLE

INSERT INTO PERSON (birth_dt, inn_no, email_txt, phone_no)
VALUES ('1988-12-31', 254050002777, 'demo@mail.ru', '78005553535');

SELECT *
FROM PERSON;

UPDATE PERSON
SET email_txt = 'demo2@mail.ru'
WHERE person_id = (SELECT max(person_id) FROM PERSON);

SELECT *
FROM PERSON;

DELETE FROM PERSON
WHERE person_id = (SELECT max(person_id) FROM PERSON);

SELECT *
FROM PERSON;






-- COURSE TABLE

INSERT INTO COURSE(name_txt, course_start_dt, course_end_dt, month_price_amt, teacher_person_id)
VALUES ('demo course', '2019-10-22', '2019-12-22', '3000', '1');

SELECT *
FROM COURSE;

UPDATE COURSE
SET month_price_amt = 3500
WHERE name_txt = 'demo course';

SELECT *
FROM COURSE;

DELETE FROM COURSE
WHERE name_txt = 'demo course';

SELECT *
FROM COURSE;