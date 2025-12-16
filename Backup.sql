--Criando o banco de dados --
Create Database  BancoDaEscocia
Go

--Acessando --
use BancoDaEscocia
Go

--Alterando o Modelo de Recuperação para Simple--
Alter Database BancoDaEscocia
Set Recovery Simple
Go

--Realizando o Backup Database --
Backup Database BancoDaEscocia
To Disk = 'C:\Backup\Backup-Database-BancoDaEscocia.bak' -- Caminho e local--
With Init, -- Especifica que um novo arquivo de backup será criado --
	Description = 'Meu backup', -- Descrição do arquivo de backup --
	Stats = 5 -- Barra de progressão --
Go

--Criando uma tabela para simular a inserção de dados --
Create Table Valores
(Codigo Int Primary Key Identity(1,2),
Valor1 BigInt Default 1000000,
Valor2 BigInt Default 2000000,
Valor3 As (Valor1+Valor2))
Go

--Inserindo uma massa de dados --
Insert Into Valores Default Values
Go 100000

-- Consultando 2000 registros lógicos de forma aleatória --
Select Top 2000 Codigo Valor1, Valor2, Valor3 From Valores
Order By NewId() -- cria um ID interno aleatório em tempo de execução--
go
--Consultando o tamanho atual dos arquivos que formam o Banco de Dados--
Select filename, (size*8) As Kbs, (size/1024)*8 As Mbs From sys.sysfiles
Go

--Consultando o Tamanho da Tabela Valores --
Exec SP_SpaceUsed 'Valores'
Go

--Realizando um novo Backup Database --
Backup Database BancoDaEscocia
To Disk = 'C:\Backup\Meu-ArquivodeBackup-BancoDaEscocia-2.bak'
With Init,
Description = 'Meu segundo arquivo de backup',
Stats = 2,
CheckSum
Go
