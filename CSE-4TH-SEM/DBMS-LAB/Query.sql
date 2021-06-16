
/*My practice query*/
select dept_name, avg (salary) as avg_salary from instructor group by dept_name;
select distinct dept_name from instructor;
select ID , name, dept_name, salary * 1.1 from instructor;
select name from instructor where dept_name = 'computer.sci' and salary > 70000;
select name, instructor.dept_name, building from instructor, department where instructor.dept_name= department.dept_name;
select name, course_id from instructor, teaches where instructor.ID = teaches.ID ;
select name, course_id from instructor, teaches where instructor.ID = teaches.ID and instructor.dept_name = 'computer.sci';
select name, course_id from instructor natural join teaches;
select name, title from instructor natural join teaches, course where teaches.course_id= course.course_id;
select name, title from instructor natural join teaches natural join course;
select name, title from (instructor natural join teaches) join course using (course_id);
select name as instructor_name, course_id from instructor, teaches where instructor.ID = teaches.ID ;
select T.name, S.course_id from instructor as T, teaches as S where T.ID = S.ID ;
select T.name,S.course_id from instructor as T natural join teaches as S;
select distinct T.name from instructor as T, instructor as S where T.Salary > S.Salary and S.dept_name = 'Biology';


/*Pattern String Queries*/
select dept_name from department where building like '%watson%';
select instructor.* from instructor, teaches where instructor.ID = teaches.ID ;#02022A
select instructor.* from instructor natural join teaches;
select dept_name from course where dept_name like '___logy';
select dept_name from course where dept_name like '___%logy';
select dept_name from course where title like '%Intro%';
select dept_name as departnemt_name from course where title like 'Intro%';


/*Oerer Clouse,between operator*/
select name from instructor where dept_name='physics' order by name;
select * from instructor order by salary desc,name asc;
select name from instructor where salary between 90000 and 100000;
select * from instructor where salary>70000 and salary<100000;
select * from instructor where salary>=70000 and salary<=100000;
select name,course_id from instructor,teaches where instructor.ID=teaches.ID and dept_name='biology';
select name,course_id from instructor,teaches where (instructor.ID,dept_name)=(teaches.ID,'biology');

/*set operations Union and Intersection and except*/
select course_id from section where semester='fall' and year=2009;
select course_id from section where semester='spring' and year=2010;
(select course_id from section where semester='fall' and year=2009) union (select course_id from section where semester='spring' and year=2010);
(select course_id from section where semester='fall' and year=2009) union all (select course_id from section where semester='spring' and year=2010);
(select course_id from section where semester='fall' and year=2009) INTERSECT (select course_id from section where semester='spring' and year=2010);
(select course_id from section where semester = 'fall' and year= 2009) intersect (select course_id from section where semester = 'spring' and year= 2010);
select distinct course_id from section inner join course using(course_id);
(select course_id from section where semester = 'fall' and year= 2009) except all (select course_id from section where semester = 'spring' and year= 2010);

/*null values selector ,and,or,not*/
true and unknown=unknown
false and unknown=false
unknown and unknown=unknown 

true or unknown=true
false or unknown=unknown
unknown or unknown=unknown

not unknown=unknown

select name from instructor where salary is null;

/* Aggregate Functions average(avg),maximum(max),minimum(min),total(sum),count(count) */
select avg(salary) from instructor where dept_name='computer.sci';
select avg(salary) as avg_salary from instructor where dept_name='computer.sci';
select distinct avg(salary) as avg_salary from instructor where dept_name='computer.sci';
select count(*) from course;
select count(distinct ID) from teaches where semester='spring' and year=2010;
select count(distinct ID) from teaches;
select max(salary) as maximum_salary from instructor;
select max(distinct salary) as maximum_salary from instructor;
select min(salary) as minimum_salary from instructor;
select min(distinct salary) as minimum_salary from instructor;
select sum(salary) from instructor;
select NAME from instructor where dept_name = (select dept_name,count(*) from instructor group by dept_name having count(*) >1);

/*Aggregation with Grouping*/
select dept_name,max(salary) from instructor group by dept_name;
select dept_name,avg(salary) from instructor group by dept_name;
select dept_name,min(salary) from instructor group by dept_name;
select dept_name,count(salary) from instructor group by dept_name;
select dept_name,count(distinct ID) from instructor natural join teaches where semester='Spring' and year=2010 group by dept_name;

/* erroneous query */
select dept_name, ID , avg (salary) from instructor group by dept_name;

/*Having clouse*/
select dept_name, avg (salary) as avg_salary
from instructor
group by dept_name
having avg (salary) > 42000;

select course_id, semester, year, sec_id, avg(tot_cred)
from takes natural join student
where year = 2009
group by course_id,semester,year,sec_id
having count(ID)>= 2;

/*Nested query,Set Membership*/
(select course_id
from section
where semester = 'spring' and year= 2010);

select distinct course_id 
from section 
where semester = 'Fall'
and year= 2009 and course_id in 
(select course_id from section where semester = 'Spring' and year= 2010);

select distinct course_id 
from section 
where semester = 'fall'
and year= 2009 and course_id not in 
(select course_id from section where semester = 'spring' and year= 2010);

select course_id 
from section
where semester = 'fall' 
and year= 2009 and course_id in 
(select course_id from section where semester = 'spring' and year= 2010);

select distinct name
from instructor
where name not in ('Mozart', 'Einstein');

select distinct name
from instructor
where name in ('mozart', 'einstein');

/*Nested query,Set Comparison*/
select distinct T.name 
from instructor as T,instructor as S
where T.salary>S.salary and S.dept_name='biology';

select name
from instructor
where salary > some (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary >= some (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary < some (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary <= some (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary = some (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary >all (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary >=all (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary <all (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary <=all (select salary
from instructor
where dept_name = 'biology');

select name
from instructor
where salary =all (select salary
from instructor
where dept_name = 'biology');

select dept_name
from instructor
group by dept_name
having avg (salary) >= all (select avg (salary)
from instructor
group by dept_name);

/*Test for Empty relation*/
select course_id
from section as S
where semester = 'fall' and year= 2009 
and exists (select *
from section as T
where semester = 'spring' and year= 2010 and
S.course_id= T.course_id);

select distinct S.ID,S.name
from student as S
where not exists((select course_id
from course
where dept_name = 'biology')
except(select T.course_id
from takes as T
where S.ID = T.ID ));

select T.course_id
from course as T
where unique(select R.course_id
from section as R
where T.course_id=R.course_id
and R.year=2009);

select T.course_id
from course as T
where 1 <= (select count(R.course_id)
from section as R
where T.course_id= R.course_id and
R.year = 2009);

select T.course_id
from course as T
where not unique (select R.course_id
from section as R
where T.course_id= R.course_id and
R.year = 2009);

/*Subqueries in the From Clause*/
select dept_name,avg(SALARY)
from instructor
group by dept_name;
where avg(Salary)>42000;

select dept_name, avg_salary
from (select dept_name, avg(salary)
from instructor
group by dept_name)
as dept_avg(dept_name, avg_salary)
where avg_salary > 42000;

select max(tot_salary)
from (select dept_name, sum(salary)
from instructor
group by dept_name) as dept_total (dept_name, tot_salary);

select name, salary, avg_salary
from instructor I1, lateral (select avg(salary) as avg_salary
from instructor I2
where I2.dept_name= I1.dept_name);

/*The with Clause*/
with max_budget(value) as
(select max(budget)
from department)
select budget
from department, max_budget
where department.budget = max_budget.value;

with dept_total (dept_name, value) as
(select dept_name, sum(salary)
from instructor
group by dept_name),
dept_total_avg(value) as
(select avg(value)
from dept_total)
select dept_name
from dept_total, dept_total_avg
where dept_total.value >= dept_total_avg.value;

/*Scalar Subqueries*/
select dept_name,
(select count(*)
from instructor
where department.dept_name = instructor.dept_name)
as num_instructors
from department;

/*Modification of the Database*/
delete from instructor;
delete from instructor where dept name= 'finance';
delete from instructor where salary between 13000 and 15000;

delete from instructor
where dept_name in (select dept_name
from department
where building = 'watson');

delete from instructor
where salary< (select avg(salary)
from instructor);

select count(ID)
from takes
where (course_id, sec_id, semester, year) in (select course_id, sec_id, semester, year
from teaches
where teaches.ID = 10101);

select name from instructor where salary > some (select salary from instructor where dept_name = 'biology');

select distinct T.name
from instructor as T, instructor as S
where T.salary > S.salary and S.dept_name = 'biology';



select name
from instructor
where salary > all (select salary from instructor where dept_name = 'biology');

select dept_name all from instructor;
select name, course_id
from instructor, teaches
where instructor.ID = teaches.ID ;

select name,title
from instructor
natural join teaches
natural join course;
select instructor.* from instructor,teaches where instructor.ID=teaches.ID;
select name, title
from (instructor natural join teaches) join course using (course_id);


/*Intermediate query, joine expression*/
select * from student join takes on student.ID = takes.ID ;


