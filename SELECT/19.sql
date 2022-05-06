-- 19) 以日历表格式列出2022年2月每周每日基金购买总金额，输出格式如下：
-- week_of_trading Monday Tuesday Wednesday Thursday Friday
--               1
--               2    
--               3
--               4
--   请用一条SQL语句实现该查询：
SELECT (@rowRank := @rowRank + 1) AS week_of_trading,
    SUM(
        IF(
            WEEKDAY(pro_purchase_time) = 0,
            pro_quantity * f_amount,
            NULL
        )
    ) AS Monday,
    SUM(
        IF(
            WEEKDAY(pro_purchase_time) = 1,
            pro_quantity * f_amount,
            NULL
        )
    ) AS Tuesday,
    SUM(
        IF(
            WEEKDAY(pro_purchase_time) = 2,
            pro_quantity * f_amount,
            NULL
        )
    ) AS Wednesday,
    SUM(
        IF(
            WEEKDAY(pro_purchase_time) = 3,
            pro_quantity * f_amount,
            NULL
        )
    ) AS Thursday,
    SUM(
        IF(
            WEEKDAY(pro_purchase_time) = 4,
            pro_quantity * f_amount,
            NULL
        )
    ) AS Friday
FROM (
        SELECT pro_pif_id,
            pro_quantity,
            pro_purchase_time
        FROM property AS pFrom
        WHERE pro_type = 3
            AND MONTH(pro_purchase_time) = 2
            AND YEAR(pro_purchase_time) = 2022
    ) AS pOterFrom
    JOIN (
        SELECT @rowRank := 0
    ) AS rowFrom
    LEFT JOIN fund AS fOterFrom ON pOterFrom.pro_pif_id = fOterFrom.f_id
GROUP BY WEEK(pro_purchase_time);
/*  end  of  your code  */