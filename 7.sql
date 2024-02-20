--Создание двух имен входа. 
CREATE LOGIN [User] WITH PASSWORD = 'qwerty', 
 
 
CREATE LOGIN [User1] WITH PASSWORD = 'qwerty123', 
 
 
--Создание двух пользователей. 
CREATE USER [user_sysadmin] FOR LOGIN [User1] 
 
CREATE USER [user_registry] FOR LOGIN [User] 
 
--Создадим две роли. 
CREATE ROLE [сисадмин] 
 
CREATE ROLE [регистратура] 
 
--Добавим наших пользователь к ролям. 
ALTER ROLE [сисадмин] ADD MEMBER [user_sysadmin] 
 
ALTER ROLE [регистратура] ADD MEMBER [user_registry] 
 
 
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[book_edition] TO [регистратура] 
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[purchase] TO [регистратура] 
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[sale] TO [регистратура] 
GRANT SELECT ON [dbo].[author] TO [регистратура] 
GRANT SELECT ON [dbo].[book] TO [регистратура] 
 
GRANT SELECT ON [dbo].[genre] TO [регистратура] 
GRANT SELECT ON [dbo].[theme] TO [регистратура] 
 
------------------------------------------------------------------------------------------- 
GRANT CREATE VIEW TO [регистратура] 
GRANT CREATE VIEW TO [сисадмин] 
GRANT CREATE TABLE, CREATE RULE, CREATE VIEW, CREATE PROCEDURE, EXECUTE TO [сисадмин]  
 
GRANT SELECT TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[author] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[book] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[book_edition] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[Famous_Theme] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[genre] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[present] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[theme] TO [сисадмин] 
GRANT INSERT, UPDATE, DELETE ON [dbo].[write] TO [сисадмин]
