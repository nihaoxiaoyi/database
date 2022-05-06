-- 16) 查询持有相同基金组合的客户对，如编号为A的客户持有的基金，编号为B的客户也持有，反过来，编号为B的客户持有的基金，编号为A的客户也持有，则(A,B)即为持有相同基金组合的二元组，请列出这样的客户对。为避免过多的重复，如果(1,2)为满足条件的元组，则不必显示(2,1)，即只显示编号小者在前的那一对，这一组客户编号分别命名为c_id1,c_id2。

-- 请用一条SQL语句实现该查询：
SELECT c_id1,
    c_id2
FROM(
        SELECT pOterFrom1.pro_c_id AS c_id1,
            GROUP_CONCAT(
                fOterFrom1.f_name
                ORDER BY fOterFrom1.f_name
            ) AS names1
        FROM property AS pOterFrom1
            LEFT JOIN (
                SELECT f_name,
                    f_id
                FROM fund AS fFrom1
                ORDER BY f_id,
                    f_name
            ) AS fOterFrom1 ON pOterFrom1.pro_pif_id = fOterFrom1.f_id
        WHERE pOterFrom1.pro_status = '可用'
            AND pOterFrom1.pro_type = 3
        GROUP BY c_id1
    ) AS from1
    JOIN (
        SELECT pOterFrom2.pro_c_id AS c_id2,
            GROUP_CONCAT(
                fOterFrom2.f_name
                ORDER BY fOterFrom2.f_name
            ) AS names2
        FROM property AS pOterFrom2
            LEFT JOIN (
                SELECT f_name,
                    f_id
                FROM fund AS fFrom2
                ORDER BY f_id,
                    f_name
            ) AS fOterFrom2 ON pOterFrom2.pro_pif_id = fOterFrom2.f_id
        WHERE pOterFrom2.pro_status = '可用'
            AND pOterFrom2.pro_type = 3
        GROUP BY c_id2
    ) AS from2
WHERE from1.names1 = from2.names2
    AND c_id1 < c_id2;
/*  end  of  your code  */