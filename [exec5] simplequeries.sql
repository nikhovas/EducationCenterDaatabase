-- student's payments list
SELECT t1.*
FROM CONTRACT_PAYMENT AS t1
INNER JOIN CONTRACT AS t2 ON t1.contract_id = t2.contract_id
where t2.student_person_id = 6;



-- student's courses num
SELECT person_name_nm, count(t2.contract_id) AS contracts_num
FROM PERSON_DOCUMENT t1
LEFT JOIN CONTRACT t2 ON t1.person_id = t2.student_person_id
where person_id in (
  SELECT person_id
  FROM STUDENT_PERSON
  )
GROUP BY t1.person_name_nm;



-- student and course matrix
SELECT t1.person_id, t2.course_id
FROM STUDENT_PERSON AS t1
INNER JOIN CONTRACT AS t2 ON t1.person_id = t2.student_person_id;



-- course's students count
SELECT t1.sphere_txt, t1.name_txt, count(t2.contract_id)
FROM COURSE AS t1
LEFT JOIN CONTRACT AS t2 ON t1.course_id = t2.course_id
GROUP BY t1.sphere_txt, t1.name_txt;



-- teacher's students count
SELECT person_name_nm, count(student_person_id)
FROM (
      SELECT distinct person_name_nm, t4.student_person_id
      FROM PERSON_DOCUMENT AS t1
      INNER JOIN TEACHER_PERSON AS t2 ON t1.person_id = t2.person_id
      LEFT JOIN COURSE AS t3 ON t3.teacher_person_id = t2.person_id
      LEFT JOIN CONTRACT AS t4 ON t4.course_id = t3.course_id
      ) t
GROUP BY person_name_nm;