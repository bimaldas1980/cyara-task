/*
 IMPORTANT: This script is used to create database for this test application purpose only. 
 The database will be re-craeated if this script is re-run.
 */

use master
go

/* Drop any existing database if it exists. */
if (exists(select *
from sys.databases
where name = 'TokenManager'))	
	alter database TokenManager set single_user with rollback immediate;
go

if (exists(select *
from sys.databases
where name = 'TokenManager'))	
	while exists(select *
from sys.databases
where name='TokenManager')
	begin
	declare @SQL varchar(max)
	select @SQL = coalesce(@SQL,'') + 'Kill ' + convert(varchar, SPId) + ';'
	from master..SysProcesses
	where dbid = db_id(N'TokenManager') and SPId <> @@spid
	exec(@SQL)
	drop database if exists TokenManager;
end
go

set ansi_nulls, quoted_identifier on;
go

create database TokenManager
go

use TokenManager
go

create schema sec
go


/* Db Roles */

-- For readonly stored procedure access
if (database_principal_id('exec_readonly_role') is null)
begin
	create role exec_readonly_role;
end

-- For full database permissions - db_owner
if (database_principal_id('api_admin_role') is null)
begin
	create role api_admin_role;
	exec sys.sp_addrolemember 'db_datareader', 'api_admin_role';
	exec sys.sp_addrolemember 'db_owner', 'api_admin_role';
end

-- For app readonly access
if (database_principal_id('api_query_role') is null)
begin
	create role api_query_role;
	exec sys.sp_addrolemember 'db_datareader', 'api_query_role';
	exec sys.sp_addrolemember 'exec_readonly_role', 'api_query_role';
	grant execute to api_query_role;
end

-- For app write access
if (database_principal_id('api_command_role') is null)
begin
	create role api_command_role;
	exec sys.sp_addrolemember 'db_datawriter', 'api_command_role';
	exec sys.sp_addrolemember 'db_datareader', 'api_command_role';
	grant execute to api_command_role;
end



/* Db Users */

-- full db permissions user - used for services that require table creations
if not exists (select loginname
from master.dbo.syslogins
where name = 'tmappadmin')
	create login tmappadmin with password = '123456';
if (database_principal_id('tmadmin_user') is null) 
	create user tmadmin_user for login tmappadmin;
if is_rolemember ('api_admin_role', 'tmadmin_user') = 0
	exec sys.sp_addrolemember 'api_admin_role', 'tmadmin_user';
go

-- query user for read only queries
if not exists (select loginname
from master.dbo.syslogins
where name = 'tmappquery')
	create login tmappquery with password = '123456';
if (database_principal_id('tmquery_user') is null) 
	create user tmquery_user for login tmappquery;
if is_rolemember ('api_query_role', 'tmquery_user') = 0
	exec sys.sp_addrolemember 'api_query_role', 'tmquery_user';
go

-- command user for write only commands.
if not exists (select loginname
from master.dbo.syslogins
where name = 'tmappcommand')
	create login tmappcommand with password = '123456';
if (database_principal_id('tmcommand_user') is null) 
	create user tmcommand_user for login tmappcommand;
if is_rolemember ('api_command_role', 'tmcommand_user') = 0
	exec sys.sp_addrolemember 'api_command_role', 'tmcommand_user';
go


/*
	Authentication and user details should be separated. Keeping it in a single table as this is not part of requriements.
*/
create table sec.Users
(
	Id int primary key identity(1,1),
	GivenNames varchar(100) not null,
	FamilyName varchar(100) not null,
	Username varchar(100) not null,
	PasswordHash binary(64) not null,
	LastLoggedInAt datetime null
)
go

create table dbo.ApiToken
(
	Id int primary key identity(1,1),
	Token varchar(20) not null,
	StartDate date not null,
	EndDate date not null,
	CreatedAt datetime not null default(getdate()),
	ModifiedAt datetime null,
	CreatedByUserId int not null,
	ModifiedByUserId int null,
	IsDisabled bit not null default(0)
)
go

alter table dbo.ApiToken add foreign key (CreatedByUserId) references sec.Users(Id)
go

alter table dbo.ApiToken add foreign key (ModifiedByUserId) references sec.Users(Id)
go

insert into sec.Users
(GivenNames, FamilyName, Username, PasswordHash)
values
('Admin', 'User', 'adminuser', HASHBYTES('SHA2_512', '123456'))
go

declare @AdminUserId int
select top 1 @AdminUserId = Id from sec.Users

insert into dbo.ApiToken
(Token, StartDate, EndDate, CreatedAt, CreatedByUserId)
values
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), getdate(), dateadd(day, 7, getdate()), getdate(), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -1, getdate()), dateadd(day, 6, getdate()), dateadd(day, -1, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -2, getdate()), dateadd(day, 5, getdate()), dateadd(day, -2, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -3, getdate()), dateadd(day, 4, getdate()), dateadd(day, -3, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId),
(replace(SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 12), '-',''), dateadd(day, -8, getdate()), dateadd(day, -1, getdate()), dateadd(day, -8, getdate()), @AdminUserId)
go


create or alter procedure sec.proc_AuthenticateUser
(
	@Username varchar(100),
	@Password varchar(100)
)
as
	declare @UserId int 
	select 
		@UserId = Id
	from 
		sec.Users
	where
		Username = @Username
	and
		PasswordHash = HASHBYTES('SHA2_512', @Password)

	if @UserId is not null
	begin
		update
			sec.Users
		set
			LastLoggedInAt = getdate()
		where
			Id = @UserId
	end

	select 
		Id,
		Username,
		GivenNames,
		FamilyName
	from 
		sec.Users
	where
		Id = @UserId
go

create or alter procedure sec.proc_GetUserByUsername
(
	@Username varchar(100)
)
as
	select 
		Id,
		Username,
		GivenNames,
		FamilyName
	from 
		sec.Users
	where
		Username = @Username
	
go

create or alter procedure dbo.proc_SearchTokens
(
	@Search varchar(15),
	@PageNumber int,
	@PageSize int
)	
as

	declare @TokenIds table (Id int)
	declare @TotalRecords int

	insert @TokenIds
	select 
		Id
	from
		dbo.ApiToken 
	where @search is null or token like '' + @search + '%'

	select @TotalRecords = count(*) from @TokenIds

	select 
		t.Id,
		t.Token,
		t.StartDate,
		t.EndDate,
		t.CreatedAt,
		t.ModifiedAt,
		concat(cu.GivenNames, ' ', cu.FamilyName) as CreatedBy,
		concat(uu.GivenNames, ' ', uu.FamilyName) as ModifiedBy,
		t.IsDisabled
	from
		dbo.ApiToken t
	join @TokenIds ti on ti.Id = t.Id
	join sec.Users cu on cu.Id = t.CreatedByUserId
	left join sec.Users uu on uu.Id = t.ModifiedByUserId
	order by 
		CreatedAt desc
		offset (@PageNumber - 1) * @PageSize rows
		fetch next @PageSize rows only

	select @TotalRecords as TotalRecords
go


create or alter procedure dbo.proc_DisableToken
(
	@TokenId int,
	@ModifiedByUserId int
)
as

	update 
		dbo.ApiToken
	set
		IsDisabled = 1,
		ModifiedAt = getdate(),
		ModifiedByUserId = @ModifiedByUserId
	where
		Id = @TokenId
	and
		IsDisabled = 0
go


create or alter procedure dbo.proc_EnableToken
(
	@TokenId int,
	@ModifiedByUserId int
)
as

	update 
		dbo.ApiToken
	set
		IsDisabled = 0,
		ModifiedAt = getdate(),
		ModifiedByUserId = @ModifiedByUserId
	where
		Id = @TokenId
	and
		IsDisabled = 1
go

create or alter procedure dbo.proc_GenerateToken
(
	@CreatedByUserId int
)
as

	declare @Token varchar(20) = replace(SUBSTRING(CONVERT(varchar(255), newid()), 0, 12), '-','')
	declare @StartDate date = getdate()
	declare @NewTokenId int

	insert into dbo.ApiToken
	(Token, StartDate, EndDate, CreatedByUserId)
	values
	(@Token, @StartDate, dateadd(day, 7, @StartDate), @CreatedByUserId)

	select @NewTokenId = @@IDENTITY

	select 
		t.Id,
		t.Token,
		t.StartDate,
		t.EndDate,
		t.CreatedAt,
		t.ModifiedAt,
		concat(cu.GivenNames, ' ', cu.FamilyName) as CreatedBy,
		concat(uu.GivenNames, ' ', uu.FamilyName) as ModifiedBy,
		t.IsDisabled
	from
		dbo.ApiToken t
	join sec.Users cu on cu.Id = t.CreatedByUserId
	left join sec.Users uu on uu.Id = t.ModifiedByUserId
	where
		t.Id = @NewTokenId
go

create or alter procedure dbo.proc_ValidateToken
(
	@Token varchar(20),
	@AsOfDate date
)
as	
	declare @IsValid bit = 0 

	if exists (select * from dbo.ApiToken where @AsOfDate between StartDate and EndDate and IsDisabled = 0 and Token = @Token)
		begin
			set @IsValid = 1
		end

	select @IsValid as IsValid
go


	
		






		