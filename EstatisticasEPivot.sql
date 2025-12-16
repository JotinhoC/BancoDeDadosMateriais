--Criando o Banco de Dados Estatisticas --
Create Database Estatisticas
Go

--Acessando o Banco de Dados --
Use Estatisticas
Go

--Criando a Tabela Pedidos --
Create Table Pedidos
	(ID Int Identity(1,1) Not Null Primary Key,
	Cliente Int Not Null,
	Vendedor Varchar(30) Not Null,
	Quantidade SmallInt Not Null,
	Valor Numeric(18, 2) Not Null,
	Data Date Not Null)
Go

-- Inserindo a Massa de Dados na Tabela Pedidos --
Declare @Texto Char(130), 
        @Posicao TinyInt, 
        @ContadorLinhas SmallInt
 
Set @Texto = '0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ\_abcdefghijklmnopqrstuvwxyzŽŸ¡ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåæçèéêëìíîïðñòóôõöùúûüýÿ' -- Existem 130 caracteres neste texto --
 
Set @ContadorLinhas = Rand()*10000 -- Definir a quantidade de linhas para serem inseridas --
 
While (@ContadorLinhas >=1)
Begin
 
Set @Posicao=Rand()*130
 
Insert Into Pedidos (Cliente, Vendedor, Quantidade, Valor, Data)
Values(@ContadorLinhas, 
            Concat(SubString(@Texto,@Posicao,1),SubString(@Texto,@Posicao+2,1),SubString(@Texto,@Posicao+3,1)),
            Rand()*1000, 
		    Rand()*100+5, 
		    DATEADD(d, 1000*Rand() ,GetDate()))
 
Set @ContadorLinhas = @ContadorLinhas - 1
End
Go

--Contando a quantidade de linhas da Tabela Pedidos
Select Count(Id) From Pedidos
Go

--Descobrindo o tamanho da Tabela Pedidos--
Exec sp_spaceused 'Pedidos'
Go

-- Consultando os Metadados das Estatisticas --
Select OBJECT_NAME(s.object_id) As Tabela,
	   s.name As Estatistica,
	   s.auto_created As Tipo,
	   c.name As Coluna
From sys.stats_columns sc Inner Join sys.columns c
						  On sc.object_id = c.object_id
						  And sc.column_id = c.column_id
						  Inner Join sys.stats s
						  On sc.object_id = s.object_id
						  And sc.stats_id = s.stats_id
Where Object_Name(s.object_id) = 'Pedidos'
Go

-- Processando o primeiro Select para gerar amostras de linhas afim de popular Histograma
Select Id, Cliente, Quantidade From Pedidos
Where Id <= 500
Order By Quantidade Desc
Go

/*Executando o Select aplicado a coluna Quantidade, fazendo com que uma nova estatística seja
criada para esta coluna */
--Ativando o Plano de Execução -- CTRL + M
Select Cliente, Vendedor, Quantidade, Valor From Pedidos
Where Quantidade >= 0 and Quantidade <= 7
Order By Quantidade Desc
Go

DBCC Show_Statistics ('Pedidos',[_WA_Sys_00000004_48CFD27E]) With Histogram
Go

--Criando uma nova Estatística para a Tabela Pedidos aplicada a coluna Valor --
Create Statistics [EstatisticaColunaValor] On Pedidos(Valor)
Go

--Apresentatndo o Cabeçalho da Estatística --
DBCC SHOW_STATISTICS('Pedidos', [EstatisticaColunaValor]) With STAT_HEADER
Go

--Apresentatndo o Vetor de Densidade da Estatistica --
DBCC SHOW_STATISTICS('Pedidos', [EstatisticaColunaValor]) With Density_Vector
Go

-- Atualizando a Estatísticas da coluna Valor --
Update Statistics Pedidos[EstatisticaColunaValor]
Go


---|-|-|-|-|-|-|-|-|-|-|-|-|-|--
-- Pivot e Unpivot

--Exemplo 1 - Criando um Pivot Básico -- Contando Valores Numéricos --
Create Table Usuarios
	(Codigo TinyInt,
	 Nome Varchar(10))
Go

--Inserindo--
Insert Into Usuarios Values (1,'José')
Insert Into Usuarios Values (2,'Mario')
Insert Into Usuarios Values (1,'José')
Insert Into Usuarios Values (2,'Mario')
Insert Into Usuarios Values (3,'Celso')
Insert Into Usuarios Values (4,'André')
Go

--Consultando--
Select Codigo, Nome From Usuarios
Go

--Montando o Pivot Table -- Transformando os nomes em colunas distintas com Totais --
Select * From Usuarios
Pivot (Count(Codigo)For Nome In ([José], [Mario], [Celso], [André])) As Pvt
Go

Select [José], [Mario], [Celso], [André] From Usuarios
Pivot (Count(Codigo)For Nome In ([José], [Mario], [Celso], [André])) As Pvt
Go

Select Pvt.André, Pvt.Celso, Pvt.José, Pvt.Mario From Usuarios
Pivot (Count(Codigo)For Nome In ([José], [Mario], [Celso], [André])) As Pvt
Go

--Exemplo 2 -- Criando um Pivot Básico -- Contando valores caracteres --
--Removendo a Tabela Usuarios --
Drop Table Usuarios
Go

-- Recriando a Tabela Usuarios --
Create Table Usuarios
(Codigo TinyInt Identity(1,1),
Nome Varchar(10),
IdUsuario TinyInt)
Go

--Inserindo--
Insert Into Usuarios Values ('jose',12), ('mario',10), ('jose',12)
Insert Into Usuarios Values ('mario',10), ('celso',8), ('andre',6)
Go

--Consultando--
Select Codigo, Nome, IdUsuario From Usuarios
Go

-- Montando o Pivot Table - Transformando os valores do IdUsuario em Colunas --
Select Pvt.[6], Pvt.[8], Pvt.[10], Pvt.[12] From Usuarios
Pivot (Count(Nome) For IdUsuario In ([6],[8],[10],[12])) As Pvt
Go

--Removendo a repetição de linhas--
Select Pvt.[10] From -- Select de apresentação --
(Select Nome, IdUsuario From Usuarios) As T -- Select base para o Pivot --
Pivot (Count(Nome) For IdUsuario In ([6],[8],[10],[12])) As Pvt
Go