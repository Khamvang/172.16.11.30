


-- 1. XA
-- 1.1 create user and give access permission
create user 'xa5246'@'%' identified by 'Admin@xa5246';
grant all privileges on *.* to 'xa5246'@'%';
flush privileges;

-- 1.2 fix the access issue
ALTER USER 'xa5246'@'%' IDENTIFIED WITH mysql_native_password BY 'Admin@xa5246';
FLUSH PRIVILEGES;

-- 1.3 access 
mysql -u xa5246 -pAdmin@xa5246 -h 172.16.11.30

-- 1.4 drop use
drop user 'xa5246'@'%';



