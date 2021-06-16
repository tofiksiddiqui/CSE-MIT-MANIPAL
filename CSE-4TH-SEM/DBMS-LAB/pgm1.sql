-- 1
DROP TABLE salary_raise;

CREATE TABLE salary_raise(
    Instructor_ID   NUMBER(5),
    Raise_Date      DATE,
    Raise_Amt       NUMERIC(8,2)
);

DECLARE
    CURSOR c_raise IS
        SELECT * FROM Instructor WHERE dept_name = 'Biology' FOR UPDATE;
    r_amt NUMERIC(8, 2);

BEGIN
    FOR i IN c_raise 
    LOOP
		r_amt := i.salary * 1.05;
		UPDATE Instructor 
        SET salary = salary * 1.05;
		INSERT INTO salary_raise VALUES (i.ID, CURRENT_DATE, r_amt);
	END LOOP;
END;
/

SELECT * FROM salary_raise;

-- 2
DECLARE 
	CURSOR c2 is select * from student order by tot_cred;
	sname student.name%type;
	sid student.id%type;
	sdept_name student.dept_name%type;
	scred student.tot_cred%type;
BEGIN
	OPEN c2;
	LOOP
   	EXIT WHEN (c2%ROWCOUNT > 9) OR (c2%NOTFOUND);
   	fetch c2 into sid, sname, sdept_name, scred;
   	dbms_output.put_line(sid || ' ' || sname || ' ' || sdept_name
   	|| ' ' || scred);
   	END LOOP;
   	CLOSE c2;
END;
/


-- 3
declare
    cursor c1 is with stu as (select * from (student natural join takes natural join section)),ins as (select * from (instructor natural join teaches natural join section)) 
                select course_id,title,ins.dept_name,credits,ins.name,ins.building,ins.room_number,ins.time_slot_id,count(*) as no_of_students from stu inner join  ins using(course_id,sec_id,semester,year) natural join course
                group by (course_id,title,ins.dept_name,credits,ins.name,ins.building,ins.room_number,ins.time_slot_id);
begin
    for info in c1
        loop 
            dbms_output.put_line('Course ID : '|| info.course_id);
            dbms_output.put_line('Title : '|| info.title);
            dbms_output.put_line('Department : '|| info.dept_name);
            dbms_output.put_line('Credits : '|| info.credits);
            dbms_output.put_line('Instructor Name : '|| info.name);
            dbms_output.put_line('Building : '|| info.building);
            dbms_output.put_line('Room Number : '|| info.room_number);
            dbms_output.put_line('Time Slot ID : '|| info.time_slot_id);
            dbms_output.put_line('Total Students : '|| info.no_of_students);
            dbms_output.put_line('---------------------------------------------------------------------');
        end loop;
end;
/

-- 4
declare
cursor c is select * from Student natural join takes where course_id='CS-101' ;

begin
	for stud in c
    loop
    if stud.tot_cred < 30 then
    delete from takes where id=stud.id and course_id='CS-101';
    end if;
    end loop;
end;
/

-- 5
declare 
cursor c is select * from Studenttable for update;
begin
    for stud in c
    loop
    if stud.gpa between 0 and 4 then
        update Studenttable set LetterGrade='F' where current of c;
    elsif stud.gpa between 4 and 5 then
        update Studenttable set LetterGrade='E' where current of c;
    elsif stud.gpa between 5 and 6 then
        update Studenttable set LetterGrade='D' where current of c;
    elsif stud.gpa between 6 and 7 then
        update Studenttable set LetterGrade='C' where current of c;
    elsif stud.gpa between 7 and 8 then
        update Studenttable set LetterGrade='B' where current of c;
    elsif stud.gpa between 8 and 9 then
        update Studenttable set LetterGrade='A' where current of c;
    else
        update Studenttable set LetterGrade='A+' where current of c;
    end if;
    end loop;
end;
/

-- 6
declare
cursor c(cid teaches.course_id%TYPE) is select * from instructor natural join teaches where course_id=cid;

begin
for temp in c('CS-101')
loop
    dbms_output.put_line('Instructor ID:'||temp.id);
    dbms_output.put_line('Instructor Name:'||temp.name);
    dbms_output.put_line('---------------------------');
end loop;
end;
/


-- 7
declare
    cursor c1(a_id advisor.i_id%type,c_id takes.course_id%type) is select * from ((student s natural join takes t) inner join advisor a on (id=a.s_id)) where course_id = c_id and a_id=i_id;
    cursor c2 is select * from (instructor natural join teaches);
begin
    for ins_info in c2
        loop
            for info in c1(ins_info.id,ins_info.course_id)
                loop
                    dbms_output.put_line(info.name);
                end loop;
        end loop;
end;
/

-- 8
DECLARE
Total_sal department.budget%TYPE;
Bio_budg department.budget%TYPE;

BEGIN
    Savepoint nochange;
    Update instructor set salary = salary*1.2 where dept_name='Biology';
    Select sum(salary) into Total_sal from instructor where dept_name='Biology';
    Select budget into Bio_budg from department where dept_name='Biology';
    If Total_sal > Bio_budg then
    Rollback to nochange;
    End If;
    Commit;
End;
/