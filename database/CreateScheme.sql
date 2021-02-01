CREATE TABLE public.departments
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE public.students
(
    id SERIAL PRIMARY KEY,
    department_id INT NOT NULL REFERENCES departments(id),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL
);

INSERT INTO departments (name) VALUES ('IRC');
INSERT INTO departments (name) VALUES ('ETI');
INSERT INTO departments (name) VALUES ('CGP');

INSERT INTO students (department_id, first_name, last_name) VALUES (1, "Eli", "Copter")
INSERT INTO students (department_id, first_name, last_name) VALUES (2, "alpha", "boby")
INSERT INTO students (department_id, first_name, last_name) VALUES (3, "beta", "shepard")
INSERT INTO students (department_id, first_name, last_name) VALUES (4, "charlie", "yolo")