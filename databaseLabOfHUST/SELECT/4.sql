-- 4) 查询办理了储蓄卡的客户名称、手机号、银行卡号。 查询结果结果依客户编号排序。
--    请用一条SQL语句实现该查询：
SELECT c_name,
    c_phone,
    b_number
FROM (
        SELECT DISTINCT c_name,
            c_phone,
            b_number,
            c_id
        FROM client c
            INNER JOIN bank_card b ON c.c_id = b.b_c_id
            AND b_type = "储蓄卡"
    ) f
ORDER BY c_id;
/*  end  of  your code  */