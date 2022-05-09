-- 事务1:
use testdb1;
set session transaction isolation level read uncommitted;
start transaction;
-- 第1次查询航班'MU2455'的余票
SELECT tickets
FROM ticket
WHERE flight_no = 'MU2455' FOR SHARE;
set @n = sleep(5);
-- 第2次查询航班'MU2455'的余票
SELECT tickets
FROM ticket
WHERE flight_no = 'MU2455' FOR SHARE;
commit;
-- 第3次查询所有航班的余票，发生在事务2提交后
set @n = sleep(1);
select *
from ticket;