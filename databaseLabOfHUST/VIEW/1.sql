use finance1;
-- 创建包含所有保险资产记录的详细信息的视图v_insurance_detail，包括购买客户的名称、客户的身份证号、保险名称、保障项目、商品状态、商品数量、保险金额、保险年限、商品收益和购买时间。
-- 请用1条SQL语句完成上述任务：
DROP VIEW IF EXISTS v_insurance_detail;
CREATE OR REPLACE VIEW v_insurance_detail AS
SELECT c.c_name,
    c.c_id_card,
    i.i_name,
    i.i_project,
    p.pro_status,
    p.pro_quantity,
    i.i_amount,
    i.i_year,
    p.pro_income,
    p.pro_purchase_time
FROM property AS p
    LEFT JOIN client AS c ON p.pro_c_id = c.c_id
    LEFT JOIN insurance AS i ON i.i_id = p.pro_pif_id
WHERE p.pro_type = 2;
/*   end  of your code  */