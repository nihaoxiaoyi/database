-- 12) 综合客户表(client)、资产表(property)、理财产品表(finances_product)、保险表(insurance)和
--     基金表(fund)，列出客户的名称、身份证号以及投资总金额（即投资本金，
--     每笔投资金额=商品数量*该产品每份金额)，注意投资金额按类型需要查询不同的表，
--     投资总金额是客户购买的各类资产(理财,保险,基金)投资金额的总和，总金额命名为total_amount。
--     查询结果按总金额降序排序。
-- 请用一条SQL语句实现该查询：
SELECT c_name,
    c_id_card,
    (
        IFNULL(p_amount, 0) + IFNULL(i_amount, 0) + IFNULL(f_amount, 0)
    ) AS total_amount
FROM client AS cFrom
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id1,
            SUM(pro_quantity * p_amount) AS p_amount
        FROM property AS pFrom1
            LEFT JOIN finances_product AS fpFrom ON pro_pif_id = p_id
        WHERE pro_type = 1
        GROUP BY pro_c_id
    ) AS fpOterFrom ON c_id = pro_c_id1
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id2,
            SUM(pro_quantity * i_amount) AS i_amount
        FROM property AS pFrom2
            LEFT JOIN insurance AS iFrom ON pro_pif_id = i_id
        WHERE pro_type = 2
        GROUP BY pro_c_id
    ) AS iOterFrom ON c_id = pro_c_id2
    LEFT JOIN (
        SELECT pro_c_id AS pro_c_id3,
            SUM(pro_quantity * f_amount) AS f_amount
        FROM property AS pFrom3
            LEFT JOIN fund AS fFrom ON pro_pif_id = f_id
        WHERE pro_type = 3
        GROUP BY pro_c_id
    ) AS fOterFrom ON c_id = pro_c_id3
ORDER BY total_amount DESC;
/*  end  of  your code  */