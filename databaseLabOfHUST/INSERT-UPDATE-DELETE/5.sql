use finance1;
-- 请用一条update语句将手机号码为“13686431238”的这位客户的投资资产(理财、保险与基金)的状态置为“冻结”。：
UPDATE client AS c
    LEFT JOIN property AS p ON c.c_id = p.pro_c_id
SET p.pro_status = '冻结'
WHERE c.c_phone = 13686431238;
/* the end of your code */