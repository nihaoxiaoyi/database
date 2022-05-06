-- 6) 查询资产表中所有资产记录里商品收益的众数和它出现的次数。
--    请用一条SQL语句实现该查询：
SELECT pro_income,
    COUNT(pro_income) AS presence
FROM property
GROUP BY pro_income
HAVING presence >= ALL(
        SELECT COUNT(pro_income)
        FROM property
        GROUP BY pro_income
    );
/*  end  of  your code  */