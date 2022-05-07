# 请在以下适当的空白处填写SQL语句，完成任务书的要求。空白行可通过回车换行添加。 
DROP DATABASE IF EXISTS TestDb;
CREATE DATABASE TestDb;
USE TestDb;
CREATE TABLE IF NOT EXISTS t_emp(
    deptId INT,
    id INT PRIMARY KEY,
    name VARCHAR(32),
    salary FLOAT
);
/* *********** 结束 ************* */