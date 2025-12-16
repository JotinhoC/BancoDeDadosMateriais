-- Criando um novo banco de dados --
Create Database Agosto2025
Go

--Obtendo informações sobre o Banco de Dados --
Select name, 
	   database_id, 
	   compatibility_level as 'Nível',
	   recovery_model As 'Modelo', 
	   recovery_model_desc As 'Descrição do Modelo'
From sys.databases
Where Name = 'Agosto2025'
Go

--Utilizando a função DatabasePropertyEx --
Use Agosto2025
Go

Select DATABASEPROPERTYEX('Agosto2025', 'Collation'),
	   DATABASEPROPERTYEX('Agosto2025', 'Recovery'),
	   DATABASEPROPERTYEX('Agosto2025','Status'),
	   DATABASEPROPERTYEX('Agosto2025','Version') As 'Versão'
Go

-- Obtendo a versão do SQL Server -- CTRL+T
Select @@VERSION
Go

-- Utilizando a Stored Procedure -- CTRL+D
Exec sp_server_info
Go

Exec XP_MSVer
Go

-- Alterando o Status do Banco de Dados Agosto2025 --
Use Master
Go

-- Offline --
Alter Database Agosto2025
Set Offline
Go

-- Online --
Alter Database Agosto2025
Set Online
Go

-- Emergency --
Alter Database Agosto2025
Set Emergency
Go 

-- Alterando o Recovery Model --
Alter Database Agosto2025
Set Recovery Full
Go

-- Alterando o Recovery Model -- Recovery Model para Simple --
Alter Database Agosto2025
Set Recovery Simple
Go

-- Alterando o Recovery Model -- Recovey Model para Bulk_Logged --
Alter Database Agosto2025
Set Recovery Bulk_Logged
Go

-- Utilizar a Stored SP_HelpDB principais propriedades e espaço físico al--
Exec SP_HelpDB 'Agosto2025'
Go

-- Obtendo informaões sobre a distribuição de espaço ocupado --
Use Agosto2025
Go

-- Stored Procedure --
SP_SpaceUsed
Go