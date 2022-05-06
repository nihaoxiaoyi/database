-- 18) 查询至少有一张信用卡余额超过5000元的客户编号，以及该客户持有的信用卡总余额，总余额命名为credit_card_amount。
--    请用一条SQL语句实现该查询：
SELECT bcOterFrom1.b_c_id,
    SUM(b_balance) AS credit_card_amount
FROM bank_card AS bcOterFrom1
    RIGHT JOIN (
        SELECT b_c_id
        FROM bank_card AS bcFrom
        WHERE b_type = '信用卡'
            AND b_balance > 5000
    ) AS bcOterFrom2 ON bcOterFrom1.b_c_id = bcOterFrom2.b_c_id
WHERE b_type = '信用卡'
GROUP BY bcOterFrom1.b_c_id
ORDER BY bcOterFrom1.b_c_id;
/*  end  of  your code  */