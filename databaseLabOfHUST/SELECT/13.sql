-- 13) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、
--     保险表(insurance)、基金表(fund)和投资资产表(property)，
--     列出所有客户的编号、名称和总资产，总资产命名为total_property。
--     总资产为储蓄卡余额，投资总额，投资总收益的和，再扣除信用卡透支的金额
--     (信用卡余额即为透支金额)。客户总资产包括被冻结的资产。
--    请用一条SQL语句实现该查询：
SELECT c_id,
    c_name,
    (
        IFNULL(p_amount, 0) + IFNULL(i_amount, 0) + IFNULL(f_amount, 0) + IFNULL(b_balance_a, 0) - IFNULL(b_balance_b, 0)
    ) AS total_property
FROM client AS cFrom
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id1,
            SUM(pro_quantity * p_amount + pro_income) AS p_amount
        FROM property AS pFrom1
            LEFT JOIN finances_product AS fpFrom ON pro_pif_id = p_id
        WHERE pro_type = 1
        GROUP BY pro_c_id
    ) AS fpOterFrom ON c_id = pro_c_id1
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id2,
            SUM(pro_quantity * i_amount + pro_income) AS i_amount
        FROM property AS pFrom2
            LEFT JOIN insurance AS iFrom ON pro_pif_id = i_id
        WHERE pro_type = 2
        GROUP BY pro_c_id
    ) AS iOterFrom ON c_id = pro_c_id2
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id3,
            SUM(pro_quantity * f_amount + pro_income) AS f_amount
        FROM property AS pFrom3
            LEFT JOIN fund AS fFrom ON pro_pif_id = f_id
        WHERE pro_type = 3
        GROUP BY pro_c_id
    ) AS fOterFrom ON c_id = pro_c_id3
    LEFT JOIN(
        SELECT b_c_id,
            SUM(IFNULL(b_balance, 0)) AS b_balance_a
        FROM bank_card AS bcFrom1
        WHERE b_type = '储蓄卡'
        GROUP BY b_c_id
    ) AS bcOterFrom1 ON bcOterFrom1.b_c_id = c_id
    LEFT JOIN(
        SELECT b_c_id,
            SUM(IFNULL(b_balance, 0)) AS b_balance_b
        FROM bank_card AS bcFrom2
        WHERE b_type = '信用卡'
        GROUP BY b_c_id
    ) AS bcOterFrom2 ON bcOterFrom2.b_c_id = c_id;
    /*  end  of  your code  */