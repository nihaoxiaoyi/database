use MyDb;
#请在以下空白处添加适当的SQL语句，实现编程要求
ALTER TABLE addressBook
MODIFY QQ CHAR(12),
    RENAME COLUMN weixin TO wechat;