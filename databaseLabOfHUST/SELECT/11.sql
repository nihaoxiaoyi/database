-- 11) 给出黄姓用户的编号、名称、办理的银行卡的数量(没有办卡的卡数量计为0),持卡数量命名为number_of_cards,
--     按办理银行卡数量降序输出,持卡数量相同的,依客户编号排序。
-- 请用一条SQL语句实现该查询：
SELECT cfrom.c_id,
    cfrom.c_name,
    IFNULL(newfrom.number_of_cards, 0) AS number_of_cards
FROM (
        SELECT *
        FROM client
        WHERE c_name LIKE "黄%"
    ) cfrom
    LEFT JOIN (
        SELECT b_c_id,
            COUNT(b_c_id) AS number_of_cards
        FROM bank_card
        GROUP BY b_c_id
    ) newfrom ON cfrom.c_id = newfrom.b_c_id
ORDER BY number_of_cards DESC;
/*  end  of  your code  */