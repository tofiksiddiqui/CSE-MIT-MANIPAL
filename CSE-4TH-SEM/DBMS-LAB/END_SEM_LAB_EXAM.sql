CREATE TABLE part(
     part_no INTEGER PRIMARY KEY,
     vehicle_name VARCHAR(4) not null,
     vehicle_type varchar(5) CHECK(vehicle_type in('v1','v2','v3','v4','v5')),
     unite_price numeric(5,0) CHECK(unite_price>0),
     sale_price numeric(5,0) CHECK(sale_price>0)
);

CREATE TABLE service(
     service_no INTEGER,
     part_no INTEGER,
     service_date varchar(20),
     customer_no varchar(10),
     quantity number(5),
     PRIMARY KEY(service_no,part_no),
     FOREIGN KEY(part_no) REFERENCES part(part_no) ON DELETE CASCADE
);

INSERT into part VALUES(1,'p1','v1',10,12);
INSERT into part VALUES(2,'p2','v2',100,110);
INSERT into part VALUES(3,'p3','v1',150,175);
INSERT into part VALUES(4,'p4','v3',200,250);
INSERT into part VALUES(5,'p5','v2',75,90);


INSERT into service VALUES(1,1,'01-jan-17','c1',5);
INSERT into service VALUES(1,3,'01-jan-17','c1',4);
INSERT into service VALUES(2,3,'05-feb-18','c2',10);
INSERT into service VALUES(3,1,'15-may-18','c3',9);
INSERT into service VALUES(4,1,'03-jun-19','c1',5);

A. Write the following queries in SQL:
i.
List the Part Names which are not used to service the vehicle of any customer. (2M)

SELECT vehicle_name FROM part WHERE part_no NOT IN(SELECT part_no FROM service);

ii.List the customer number who has got his vehicle serviced maximum number of times. (4M)
with c as
(select service_no, part_no, customer_no from part natural join service)
select count(*) cntCustomer, customer_no from  c group by customer_no
having count(*) >= all (select count(*) cntCustomer from  c group by customer_no);

iii.
List the customer number whose vehicle service used all the parts of vehicle type V1.(2M)

select distinct customer_no from service s1
where NOT EXISTS
((select part_no from part where vehicle_type = 'v1') minus
(select distinct part_no from service s2 where s1.customer_no = s2.customer_no));

B. Write a PL/SQL program to find the total profit done in the sales of a given part number in
the service of different customer vehicles. Raise an exception for invalid part number. (8M)

set serveroutput on;

declare
    prtno part.part_no%type;
    cursor customers is select distinct customer_no from service;
    cursor servicedetails(customer service.customer_no%type,part part.part_no%type)is
        select unite_price,sale_price,quantity
        from service natural join part
        where customer_no = customer and part_no = part;
    total_cost number;
    total_profit number;
begin
    prtno := '&part_number';
    total_profit := 0;
    select part_no into prtno from part where part_no = prtno;
    for customer in customers
        loop
            total_cost := 0;
            for details in servicedetails(customer.customer_no,prtno)
                loop
                    total_cost := total_cost + (details.sale_price - details.unite_price) * details.quantity;
                end loop;
            dbms_output.put_line('Total profit done in sales of part number '||prtno||' in the service of customer '||customer.customer_no||' is '||total_cost);
            total_profit := total_profit + total_cost;
        end loop;
        dbms_output.put_line('Total profit done in sales of part number '||prtno||' is '||total_profit);
    exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Invalid part number.');

        END;
        /
