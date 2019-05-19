CREATE OR REPLACE VIEW INCREMENTING_PROFIT AS
WITH PAYMENT_DATES AS (
  SELECT DISTINCT payment_dttm
  FROM CONTRACT_PAYMENT
  ORDER BY payment_dttm
), TEACHER_IDS AS (
  SELECT person_id
  FROM TEACHER_PERSON
), TEACHER_PAYMENTS_BY_DATE AS (
  SELECT person_id,
         payment_dttm,
         payment_amt
  FROM TEACHER_PERSON
    LEFT JOIN COURSE
      ON TEACHER_PERSON.person_id = COURSE.teacher_person_id
    LEFT JOIN CONTRACT
      ON COURSE.course_id = CONTRACT.course_id
    LEFT JOIN CONTRACT_PAYMENT
      ON CONTRACT.contract_id = CONTRACT_PAYMENT.contract_id
)
SELECT person_id,
       payment_dttm,
       coalesce(sum(payment_amt) OVER (PARTITION BY person_id ORDER BY payment_dttm), 0) AS increase_sum
FROM TEACHER_PAYMENTS_BY_DATE
ORDER BY person_id, payment_dttm;


CREATE OR REPLACE VIEW TEACHER_TOP AS
SELECT rank() over (order by count(contract) DESC), TEACHER_PERSON.person_id, person_name_nm, count(contract)
FROM TEACHER_PERSON INNER JOIN COURSE ON TEACHER_PERSON.person_id = COURSE.teacher_person_id
INNER JOIN CONTRACT ON CONTRACT.course_id = COURSE.course_id
INNER JOIN PERSON_DOCUMENT ON TEACHER_PERSON.person_id = PERSON_DOCUMENT.person_id
WHERE CONTRACT.termination_dttm IS NULL
GROUP BY TEACHER_PERSON.person_id, person_name_nm;




SELECT *
FROM INCREMENTING_PROFIT;

SELECT *
FROM TEACHER_TOP;


