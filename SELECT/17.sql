-- 17 查询2022年2月购买基金的高峰期。至少连续三个交易日，所有投资者购买基金的总金额超过100万(含)，则称这段连续交易日为投资者购买基金的高峰期。只有交易日才能购买基金,但不能保证每个交易日都有投资者购买基金。2022年春节假期之后的第1个交易日为2月7日,周六和周日是非交易日，其余均为交易日。请列出高峰时段的日期和当日基金的总购买金额，按日期顺序排序。总购买金额命名为total_amount。
--    请用一条SQL语句实现该查询：
SELECT pro_purchase_time,
    total_amount
FROM (
        SELECT pro_purchase_time,
            total_amount,
            myRank1 - rank() over(
                PARTITION BY id1
                ORDER BY myRank1 ASC
            ) AS RANKS
        FROM (
                SELECT 1 AS id1,
                    pro_purchase_time,
                    SUM(pro_quantity * f_amount) AS total_amount,
                    (WEEK(pro_purchase_time) -5) * 5 + WEEKDAY(pro_purchase_time) AS myRank1
                FROM (
                        SELECT pro_pif_id,
                            pro_quantity,
                            pro_purchase_time
                        FROM property AS pFrom
                        WHERE pro_type = 3
                            AND MONTH(pro_purchase_time) = 2
                            AND YEAR(pro_purchase_time) = 2022
                    ) AS pOterFrom1
                    LEFT JOIN fund AS fOterFrom1 ON pOterFrom1.pro_pif_id = fOterFrom1.f_id
                GROUP BY pro_purchase_time
                HAVING total_amount > 1000000
                ORDER BY pro_purchase_time
            ) AS from1
    ) AS f1
    RIGHT JOIN (
        SELECT RANKS
        FROM(
                SELECT myRank2 - rank() over(
                        PARTITION BY id2
                        ORDER BY myRank2 ASC
                    ) AS RANKS
                FROM (
                        SELECT 1 AS id2,
                            SUM(pro_quantity * f_amount) AS total_amount2,
                            (WEEK(pro_purchase_time) -5) * 5 + WEEKDAY(pro_purchase_time) AS myRank2
                        FROM (
                                SELECT pro_pif_id,
                                    pro_quantity,
                                    pro_purchase_time
                                FROM property AS pFrom2
                                WHERE pro_type = 3
                                    AND MONTH(pro_purchase_time) = 2
                                    AND YEAR(pro_purchase_time) = 2022
                            ) AS pOterFrom2
                            LEFT JOIN fund AS fOterFrom2 ON pOterFrom2.pro_pif_id = fOterFrom2.f_id
                        GROUP BY pro_purchase_time
                        HAVING total_amount2 > 1000000
                    ) AS from1
            ) AS ff
        GROUP BY ff.RANKS
        HAVING COUNT(ff.RANKS) >= 3
    ) AS f2 ON f1.RANKS = f2.RANKS;
/*  end  of  your code  */