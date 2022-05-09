use finance1;

-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
delimiter $$
create procedure sp_transfer(
	                 IN applicant_id int,      
                     IN source_card_id char(30),
					 IN receiver_id int, 
                     IN dest_card_id char(30),
					 IN	amount numeric(10,2),
					 OUT return_code int)
BEGIN

	DECLARE a_type CHAR(20) DEFAULT 'NULL';
	DECLARE a_balance NUMERIC(10,2) DEFAULT 0;
	DECLARE bb_type CHAR(20) DEFAULT 'NULL';
	DECLARE bb_balance NUMERIC(10,2) DEFAULT 0;

	SELECT b_type,b_balance
	FROM bank_card
	WHERE b_c_id = applicant_id
		AND b_number = source_card_id
	INTO a_type,a_balance;

	SELECT b_type,b_balance
	FROM bank_card
	WHERE b_c_id = receiver_id
		AND b_number = dest_card_id
	INTO bb_type,bb_balance;

	IF a_type = '信用卡' THEN
		SET return_code = 0;
	ELSE
		IF a_balance < amount THEN
			SET return_code = 0;
		ELSE
			UPDATE bank_card 
			SET b_balance = (a_balance-amount) 
			WHERE b_c_id = applicant_id
				AND b_number = source_card_id;

			IF bb_type = '信用卡' THEN
				UPDATE bank_card 
				SET b_balance = (bb_balance - amount) 
				WHERE b_c_id = receiver_id
					AND b_number = dest_card_id;
				SET return_code = 1;     
			ELSE
				UPDATE bank_card 
				SET b_balance = (bb_balance + amount) 
				WHERE b_c_id = receiver_id
					AND b_number = dest_card_id;
				SET return_code = 1;
			END IF;

		END IF;
	END IF;

END$$

delimiter ;

/*  end  of  your code  */ 