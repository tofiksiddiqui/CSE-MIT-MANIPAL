For Starting The SqlPlus : sudo /etc/init.d/oracle-xe start
For Starting the SqplPlus :sudo /etc/init.d/oracle-xe stop


User Name : SYSTEM
Password : q1w2e3r4

For Connecting : SQL> connect SYSTEM/q1w2e3r4

For Creating User and Granting Permission :
SQL> create user universitydb identified by universitydb;
    User created.
SQL> grant dba to universitydb;
    Grant succeeded.
SQL> connect universitydb/universitydb;
    Connected.

After Above Operation You can create table and can do query :
SQL> create table 
demo(empenfo varchar(30),
 salary number(8));
  Table created.
SQL> drop table demo;
    Table dropped.

create table demo_user(
    user_id number(4) primary key,
    user_name varchar(20) not null,
    user_address varchar(30)
    );


