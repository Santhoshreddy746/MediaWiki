CREATE DATABASE mediawiki;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
ON mediawiki.*
TO mediawiki@localhost
IDENTIFIED BY 'Password';
FLUSH PRIVILEGES;
