# 你写的命令将在linux的命令行运行
# 利用备份文件residents_bak.sql还原数据库:
mysqladmin -h127.0.0.1 -uroot create residents
mysql -h127.0.0.1 -uroot residents < residents_bak.sql
