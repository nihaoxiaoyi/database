use hms1;

-- 编写一存储过程，自动安排某个连续期间的大夜班的值班表:
drop procedure if exists sp_night_shift_arrange;
delimiter $$
create procedure sp_night_shift_arrange(in start_date date, in end_date date)
begin
-- 声明普通变量
    DECLARE is_finished INT DEFAULT 0;
    DECLARE doctor_index DATE DEFAULT start_date;
    DECLARE week_op INT;
    DECLARE nurse_index DATE DEFAULT start_date;
    DECLARE nurse_op INT DEFAULT 0;
    DECLARE e_id INT;
    DECLARE e_name CHAR(30);
    DECLARE e_type INT;
    
    -- 声明游标
    DECLARE my_cursor CURSOR FOR SELECT * FROM employee;

    -- 声明处理器
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_finished = 1;

    -- 首先插入日期
    WHILE start_date <= end_date DO
        INSERT INTO night_shift_schedule VALUES (start_date,'sb','sb','sb');
        SET start_date = DATE_ADD(start_date,INTERVAL 1 DAY);
    END WHILE;

    -- 打开游标
    OPEN my_cursor;

    -- 然后更新医生护士信息
    WHILE nurse_index <= end_date DO
        -- 已到末尾，继续打开游标
        IF is_finished = 1 THEN
            CLOSE my_cursor;
            OPEN my_cursor;
            SET is_finished = 0;
        END IF;

        -- 获取表中下一个信息
        FETCH my_cursor INTO e_id,e_name,e_type;
        
        -- 排班逻辑处理
        IF e_type = 1 AND e_name!='NULL' THEN
            IF WEEKDAY(doctor_index) < 5 THEN
                UPDATE night_shift_schedule SET n_doctor_name = e_name WHERE n_date = doctor_index;
                SET doctor_index = DATE_ADD(doctor_index,INTERVAL 1 DAY);
            ELSE
                SET week_op = 7 - WEEKDAY(doctor_index);
                IF DATE_ADD(doctor_index,INTERVAL week_op DAY) <= end_date THEN
                    UPDATE night_shift_schedule SET n_doctor_name = e_name WHERE n_date = DATE_ADD(doctor_index,INTERVAL week_op DAY);
                END IF;
            END IF;
        ELSEIF e_type = 2 AND e_name!='NULL' THEN
            UPDATE night_shift_schedule SET n_doctor_name = e_name WHERE n_date = doctor_index;
            SET doctor_index = DATE_ADD(doctor_index,INTERVAL 1 DAY);
            IF week_op != 0 THEN
                SET week_op = week_op - 1;
                IF week_op = 0 THEN
                    SET doctor_index = DATE_ADD(doctor_index,INTERVAL 1 DAY);
                END IF;
            END IF;
        ELSEIF e_type = 3 AND e_name!='NULL' THEN
            IF nurse_op = 0 THEN
                UPDATE night_shift_schedule SET n_nurse1_name = e_name WHERE n_date = nurse_index;
                SET nurse_op = 1;
            ELSEIF nurse_op = 1 THEN
                UPDATE night_shift_schedule SET n_nurse2_name = e_name WHERE n_date = nurse_index;
                SET nurse_op = 0;
                SET nurse_index = DATE_ADD(nurse_index,INTERVAL 1 DAY);
            END IF;
        END IF;
        SET e_name = 'NULL';
    END WHILE;

    -- 关闭游标
    CLOSE my_cursor;
end$$

delimiter ;

/*  end  of  your code  */ 
