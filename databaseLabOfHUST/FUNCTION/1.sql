USE finance1;
SET GLOBAL log_bin_trust_function_creators=1;
DROP FUNCTION IF EXISTS get_deposit;
/*
   用create function语句创建符合以下要求的函数：
   依据客户编号计算该客户所有储蓄卡的存款总额。
   函数名为：get_Records。函数的参数名可以自己命名:*/

delimiter $$
CREATE FUNCTION get_deposit(client_id INT)
RETURNS NUMERIC(10,2) 
BEGIN
    DECLARE total NUMERIC(10,2) DEFAULT 0;

    SELECT SUM(b_balance) AS totals
    FROM client AS c
    LEFT JOIN bank_card AS bc ON c.c_id=bc.b_c_id
    WHERE bc.b_type='储蓄卡' AND c.c_id = client_id
    GROUP BY c.c_id
    INTO total;

    RETURN total;
END$$
delimiter ;

/*  应用该函数查询存款总额在100万以上的客户身份证号，姓名和存储总额(total_deposit)，
    结果依存款总额从高到代排序  */
SELECT *
FROM (
    SELECT c_id_card,c_name,get_deposit(c_id) AS total_deposit
    FROM client
) AS c
WHERE total_deposit >= 1000000
ORDER BY total_deposit DESC;

/*  代码文件结束     */