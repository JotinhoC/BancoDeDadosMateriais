-- Criando um novo Banco com configurações personalizadas --
Create Database Fatec20252
On Primary
	(Name = 'FatecSR20252-Data', -- Nome interno do arquivo de dados --
	FileName = 'C:\Databases\Data\FatecSR20252-Data.mdf', -- caminho--
	Size = 50 MB, -- Tamahno inicial --	
	MaxSize = 500 MB, -- Tamango Máximo de crescimento --
	FileGrowth = 10 MB) -- Fator de crescimento --
Log On
	(Name = 'FatecSR20252-Log', -- Nome interno do arquivo de dados --
	FileName = 'C:\Databases\Log\FatecSR20252-Log.ldf', -- caminho --
	Size = 100 MB, -- Tamanho inicial --
	MaxSize = Unlimited, -- Tamanho máximo de crescimento --
	FileGrowth = 100 MB) -- Fator de crescimento --
Go

-- Acessando o Banco de Dados --
Use Fatec20252
Go

--  Alterando o modelo de recuperação para full
Alter Database Fatec20252
Set Recovery Full
Go

--Simulando a escrita e crescimento dos arquivos --
Create Table Jogadores
(JogadorId Int Primary Key Identity(1,1),
 JogadorNome Varchar(30) Not Null,
 JogadorData DateTime Not Null
)
Go

-- Criando o loop para inserção de dados --
Declare @Contador Int -- Declarando a variável --

Set @Contador = 1 -- Atribuindo o valor inicial --

while @Contador <=999999 -- Laço condicional --
 Begin
  Insert Into Jogadores
  Values ('Pedro Galvão', GetDate()+@Contador)

  Set @Contador = @Contador+1 -- Incremento --
 End
Go

-- Criando a Tabela Municipios--
Create Table Municipios
 (CodigoMunicipio SmallInt Identity(1,1) Primary Key,
 NomeMunicipio Varchar(100) Not Null Default 'São Roque',
 DataFundacaoMunicipio Date Not Null Default GetDate(),
 EstadoMunicipio Char(2) Not Null Default 'SP')
Go

-- Identificando a quantidade de linhas existentes no arquivo de log --
Select Count(*) From fn_dblog(Null, NULL)
Go

-- Inserindo dados na Tabela Municipios --
Insert Into Municipios Default Values
Go 100

-- Consultando as instruções Inserts armazenados no Log --
Select Operation, [Transaction Name], [Page Id],
	   [Slot Id], [Transaction Id], [Current LSN],
	   [Begin Time], [End Time]
From fn_dblog(null, null)
Where Operation In ('LOP_INSERT_ROWS')
And AllocUnitName Like '%Municipios%'
Go
