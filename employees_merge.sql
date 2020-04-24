--  Sample employee database 
--  See changelog table for details
--  Copyright (C) 2007,2008, MySQL AB
--  
--  Original data created by Fusheng Wang and Carlo Zaniolo
--  http://www.cs.aau.dk/TimeCenter/software.htm
--  http://www.cs.aau.dk/TimeCenter/Data/employeeTemporalDataSet.zip
-- 
--  Current schema by Giuseppe Maxia 
--  Data conversion from XML to relational by Patrick Crews
-- 
-- This work is licensed under the 
-- Creative Commons Attribution-Share Alike 3.0 Unported License. 
-- To view a copy of this license, visit 
-- http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
-- Creative Commons, 171 Second Street, Suite 300, San Francisco, 
-- California, 94105, USA.
-- 
--  DISCLAIMER
--  To the best of our knowledge, this data is fabricated, and
--  it does not correspond to real people. 
--  Any similarity to existing people is purely coincidental.
-- 

DROP DATABASE IF EXISTS employees_merge;
CREATE DATABASE IF NOT EXISTS employees_merge;
USE employees_merge;

SELECT 'CREATING DATABASE STRUCTURE' as 'INFO';

DROP TABLE IF EXISTS dept_emp,
                     dept_manager,
                     titles,
                     salaries, 
                     employees, 
                     departments;

set default_storage_engine = MyISAM;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

CREATE TABLE employees (
    emp_no      INT             NOT NULL,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,    
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no     CHAR(4)         NOT NULL,
    dept_name   VARCHAR(40)     NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE  KEY (dept_name)
);

CREATE TABLE dept_manager (
   emp_no       INT             NOT NULL,
   dept_no      CHAR(4)         NOT NULL,
   from_date    DATE            NOT NULL,
   to_date      DATE            NOT NULL,
   FOREIGN KEY (emp_no)  REFERENCES employees (emp_no)    ON DELETE CASCADE,
   FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
   PRIMARY KEY (emp_no,dept_no)
); 

CREATE TABLE dept_emp (
    emp_no      INT             NOT NULL,
    dept_no     CHAR(4)         NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no)  REFERENCES employees   (emp_no)  ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,dept_no)
);

CREATE TABLE titles (
    emp_no      INT             NOT NULL,
    title       VARCHAR(50)     NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no,title, from_date)
) 
;

-- This table will be used as a template to merge tables.
CREATE TABLE salaries_template (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
) ENGINE=MERGE UNION=()
;

CREATE TABLE salaries_myisam_template (
    emp_no      INT             NOT NULL,
    salary      INT             NOT NULL,
    from_date   DATE            NOT NULL,
    to_date     DATE            NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
)
;

CREATE TABLE salaries_1986 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1987 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1988 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1989 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1990 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1991 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1992 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1993 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1994 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1995 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1996 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1997 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1998 LIKE salaries_myisam_template ;
CREATE TABLE salaries_1999 LIKE salaries_myisam_template ;
CREATE TABLE salaries_2000 LIKE salaries_myisam_template ;
CREATE TABLE salaries_2001 LIKE salaries_myisam_template ;
CREATE TABLE salaries_2002 LIKE salaries_myisam_template ;

DROP TABLE salaries_myisam_template ;

CREATE OR REPLACE VIEW dept_emp_latest_date AS
    SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM dept_emp
    GROUP BY emp_no;

# shows only the current department for each employee
CREATE OR REPLACE VIEW current_dept_emp AS
    SELECT l.emp_no, dept_no, l.from_date, l.to_date
    FROM dept_emp d
        INNER JOIN dept_emp_latest_date l
        ON d.emp_no=l.emp_no AND d.from_date=l.from_date AND l.to_date = d.to_date;

flush /*!50503 binary */ logs;

SELECT 'LOADING departments' as 'INFO';
source load_departments.dump ;
SELECT 'LOADING employees' as 'INFO';
source load_employees.dump ;
SELECT 'LOADING dept_emp' as 'INFO';
source load_dept_emp.dump ;
SELECT 'LOADING dept_manager' as 'INFO';
source load_dept_manager.dump ;
SELECT 'LOADING titles' as 'INFO';
source load_titles.dump ;

SELECT 'LOADING salaries_1986' as 'INFO';
source load_salaries_1986.dump ;
SELECT 'LOADING salaries_1987' as 'INFO';
source load_salaries_1987.dump ;
SELECT 'LOADING salaries_1988' as 'INFO';
source load_salaries_1988.dump ;
SELECT 'LOADING salaries_1989' as 'INFO';
source load_salaries_1989.dump ;
SELECT 'LOADING salaries_1990' as 'INFO';
source load_salaries_1990.dump ;
SELECT 'LOADING salaries_1991' as 'INFO';
source load_salaries_1991.dump ;
SELECT 'LOADING salaries_1992' as 'INFO';
source load_salaries_1992.dump ;
SELECT 'LOADING salaries_1993' as 'INFO';
source load_salaries_1993.dump ;
SELECT 'LOADING salaries_1994' as 'INFO';
source load_salaries_1994.dump ;
SELECT 'LOADING salaries_1995' as 'INFO';
source load_salaries_1995.dump ;
SELECT 'LOADING salaries_1996' as 'INFO';
source load_salaries_1996.dump ;
SELECT 'LOADING salaries_1997' as 'INFO';
source load_salaries_1997.dump ;
SELECT 'LOADING salaries_1998' as 'INFO';
source load_salaries_1998.dump ;
SELECT 'LOADING salaries_1999' as 'INFO';
source load_salaries_1999.dump ;
SELECT 'LOADING salaries_2000' as 'INFO';
source load_salaries_2000.dump ;
SELECT 'LOADING salaries_2001' as 'INFO';
source load_salaries_2001.dump ;
SELECT 'LOADING salaries_2002' as 'INFO';
source load_salaries_2002.dump ;

source show_elapsed.sql ;
