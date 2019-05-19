DROP TABLE IF EXISTS COMPLETION_CERTIFICATE;
DROP TABLE IF EXISTS CONTRACT_PAYMENT;
DROP TABLE IF EXISTS CONTRACT;
DROP TABLE IF EXISTS COURSE_CLASS;
DROP TABLE IF EXISTS COURSE;
DROP TABLE IF EXISTS PERSON_X_PERSON;
DROP TABLE IF EXISTS STUDENT_PERSON;
DROP TABLE IF EXISTS TEACHER_PERSON;
DROP TABLE IF EXISTS PERSON_DOCUMENT;
DROP TABLE IF EXISTS PERSON_HOME_ADDRESS;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE PERSON (
 	person_id SERIAL PRIMARY KEY,
 	birth_dt DATE NOT NULL,
 	inn_no VARCHAR(12) NOT NULL CHECK (inn_no ~ '\d{12}' ) UNIQUE,
  email_txt VARCHAR(100) NOT NULL CHECK (email_txt ~ '(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])' ),
 	phone_no VARCHAR(20) NOT NULL CHECK (phone_no ~ '^((\+7|7|8)+([0-9]){10})$' )
 );

 CREATE TABLE PERSON_HOME_ADDRESS (
 	person_home_address_id SERIAL,
  	person_id INT REFERENCES PERSON(person_id),
 	address_txt VARCHAR(200) NOT NULL,
 	valid_from_dttm TIMESTAMP(0),
 	valid_to_dttm TIMESTAMP(0) NOT NULL DEFAULT '9999-12-31',
 	PRIMARY KEY (person_home_address_id, valid_to_dttm)
 );

 CREATE TABLE PERSON_DOCUMENT (
 	person_document_id SERIAL,
 	document_no INT NOT NULL,
 	document_series VARCHAR(10),
 	document_type_txt VARCHAR(20) NOT NULL,
 	person_id INT REFERENCES PERSON(person_id),
 	person_name_nm VARCHAR(100) NOT NULL,
 	authority_no VARCHAR(20),
 	valid_from_dttm TIMESTAMP(0),
 	valid_to_dttm TIMESTAMP(0) NOT NULL DEFAULT '9999-12-31',
  PRIMARY KEY (person_document_id, valid_from_dttm)
 );

 CREATE TABLE TEACHER_PERSON (
 	person_id INT PRIMARY KEY REFERENCES PERSON(person_id),
 	working_start_dt DATE NOT NULL,
 	salary_amt INT NOT NULL CHECK ( salary_amt > 0 ),
 	employment_record_no INT NOT NULL
 );

 CREATE TABLE STUDENT_PERSON (
   person_id INT PRIMARY KEY REFERENCES PERSON(person_id),
   visits_start_dt DATE NOT NULL
 );

 CREATE TABLE PERSON_X_PERSON (
   person_id INT REFERENCES PERSON(person_id),
   x_person_id INT REFERENCES PERSON(person_id),
   connection_type_txt VARCHAR(50) NOT NULL,
   PRIMARY KEY (person_id, x_person_id)
 );

 CREATE TABLE COURSE (
   course_id SERIAL PRIMARY KEY,
   sphere_txt VARCHAR(100),
   name_txt VARCHAR(100) NOT NULL,
   course_start_dt DATE NOT NULL,
   course_end_dt DATE NOT NULL,
   month_price_amt INT NOT NULL CHECK ( month_price_amt >= 0 ),
   teacher_person_id INT REFERENCES PERSON(person_id)
 );

 CREATE TABLE COURSE_CLASS (
 	course_class_id SERIAL PRIMARY KEY,
 	week_day_txt VARCHAR(2) NOT NULL CHECK (week_day_txt ~ '[A-Z]{2}' ),
 	start_tm TIME NOT NULL,
 	end_tm TIME NOT NULL,
 	course_id INT REFERENCES COURSE(course_id)
 );

 CREATE TABLE CONTRACT (
   contract_id SERIAL PRIMARY KEY,
   contract_dttm TIMESTAMP(0) NOT NULL,
   student_person_id INT REFERENCES PERSON(person_id),
   payer_person_id INT REFERENCES PERSON(person_id),
   course_id  INT REFERENCES COURSE(course_id),
   termination_dttm TIMESTAMP(0)
 );

 CREATE TABLE CONTRACT_PAYMENT (
   contract_payment_id SERIAL PRIMARY KEY,
   classes_month_no INT NOT NULL CHECK ( classes_month_no >= 0 ),
   classes_year_no INT NOT NULL CHECK ( classes_year_no >= 0 ),
   payment_dttm TIMESTAMP(0) NOT NULL,
   payment_amt INT NOT NULL CHECK ( payment_amt >= 0 ),
   contract_id INT REFERENCES CONTRACT(contract_id),
   card_no VARCHAR(16) CHECK (card_no ~ '\d{16}' ),
   card_pay_flg BOOLEAN NOT NULL DEFAULT FALSE
 );

 CREATE TABLE COMPLETION_CERTIFICATE (
   certificate_id SERIAL PRIMARY KEY,
   course_id INT REFERENCES COURSE(course_id),
   student_person_id INT REFERENCES PERSON(person_id),
   classes_start_dt DATE NOT NULL,
   classes_end_dt DATE NOT NULL
 );


