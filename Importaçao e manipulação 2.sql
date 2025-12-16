Use AlgebraRelacional2025
Go

--Consultando a Tabela de Queimadas2024
Select * From Queimadas2024
Go

-- Contando a quantidade geral de registros lógicos existentes --
Select Count(DataHora) From Queimadas2024
Go

--Trazendo a menor e a maior data de queimada --
Select Min(DataHora) As menor, Max(DataHora) As Maior From Queimadas2024
Go

--Adicionando a coluna CodigoQueimada --
Alter Table Queimadas2024
 Add CodigoQueimada Int Identity(1,1) Not Null
Go

--Consultando a coluna CodigoQueimada --
Select Top 5 CodigoQueimada From Queimadas2024
Order By NewId()
Go

-- Definindo a coluna CodigoQueimada como Primary Key --
Alter Table Queimadas2024
 Add Constraint Pk_Queimadas2024_CodigoQueimada Primary Key (CodigoQueimada)
Go

-- Removendo as colunas LatitudeAproximada, LongitudeAproximada --
Alter Table Queimadas2024
 Drop Column LatitudeAproximada, LongitudeAproximada
Go

--Alterando o Tipo de Dados da Coluna DiaSemChuva --
Alter Table Queimadas2024
 Alter Column DiaSemChuva Int Not Null
Go

--- Utilizando as Funções de Agregação e Sumarização de Dados --
Select Count(CodigoQueimada) As Contar,
	   Sum(ABS(DiaSemChuva)) As Soma,
	   ABS(Sum(DiaSemChuva)) As SomaABS,
	   Sum(DiaSemChuva) As SomaNaoAbsoluta,
	   AVG(DiaSemChuva) As Media,
	   Min(DiaSemChuva) As Menor,
	   Max(DiaSemChuva) As Maior
From Queimadas2024
Go

--Pesquisando os Paises --
Select Distinct Pais, Len(Pais) As 'Quantidade de Caracteres',
	DATALENGTH(Pais) As 'Quantidade de Bytes'
From Queimadas2024
Go

--Alterando o Tamanho de Tipo de Dados da Coluna Pais --
Alter Table Queimadas2024
 Alter Column Pais Char(6) Not Null
Go

-- Identificando os tamanhos de dados e bytes da Coluna Satelite --
Select Satelite, Len(Satelite) As 'Quantidade de Caracteres',
	   DATALENGTH(Satelite) As 'Quantidade de Bytes',
	   Max(Len(Satelite)) As 'Tamanho Máximo de Caracteres'
From Queimadas2024
Group By Satelite
Go

--Alterando o Tamanho e Tipo de Dados da coluna Satelite --
Alter Table Queimadas2024
 Alter Column Satelite Varchar(9) Not Null
Go

--Consultando as 1000 primeiras linhas da Tabela Queimadas2024
select top 1000 * from Queimadas2024
go

--Alterando o Tipo de Dados da Coluna DataHora
Alter Table Queimadas2024
 Alter Column DataHora DateTime Not Null
Go

--Convertendo o formato de armazenamento dos valores DataHora --
Alter Table Queimadas2024
 Alter Column DataHora Date Not Null
Go

Update Queimadas2024
Set DataHora = Convert(Varchar(10), DataHora, 102)
Go

--Apresentando os valores de Data em diversos formatos
Select Count(CodigoQueimada) As Quantidade,
	   Convert(Char(10), DataHora, 4) As DataNoFormato4,
	   Convert(Char(10), DataHora, 104) As DataNoFormato104,
	   Convert(Char(10), DataHora, 103) As DataNoFormato103,
	   Convert(Char(10), DataHora, 11) As DataNoFormato11,
	   Convert(Char(10), DataHora, 112) As DataNoFormato112
From Queimadas2024
Group By DataHora
Order By Quantidade
Go

--Adicionando as novas colunas Ano, Mês e Dia através da Coluna Datahora--
Alter Table Queimadas2024
	Add Ano As Year(DataHora),
		Mes As Month(DataHora),
		Dia As Day(DataHora)
Go

--consultando as novas colunas--
Select Distinct Top 20 DataHora, Ano, Mes, Dia From Queimadas2024
Go

--Agrupando dados através da função Count e filtrando datas --
Select Estado, Municipio,
	   Convert(Char(10), DataHora, 110) As Data,
	   Count(CodigoQueimada) As Quantidade
From Queimadas2024
Where Mes = 10
And Estado = 'São Paulo'
Group By Estado, Municipio, DataHora
Order By DataHora Desc, Quantidade Asc
Go

--Agrupando e Filtrando com Having--
Select Estado, Municipio,
	   Convert(Char(10), DataHora, 110) As Data,
	   Count(CodigoQueimada) As Quantidade
From Queimadas2024
Where Mes = 10
And Estado = 'São Paulo'
Group By Estado, Municipio, DataHora
Having Count(CodigoQueimada) > 2 --Filtro, Where do group by
Order By DataHora Desc, Quantidade Asc
Go

--Agrupando dados através da função Count(), Filtrando as datas para contagem e Condicional--
Select Estado, Municipio,
	   Convert(Char(10), DataHora, 110) As Data,
	   Count(CodigoQueimada) As Quantidade
From Queimadas2024
Where DataHora between '01-10-2024' And '31-10-2024'
Group By Estado, Municipio, DataHora
Having Count(CodigoQueimada) >= 4 --Filtro, Where do group by
Order By Municipio, DataHora Desc, Quantidade Desc
Go

--Grouping Sets--
Select IsNull(Day(DataHora), '') As Dia,
	   IsNull(Municipio, '') As Municipio,
	   IsNull(Bioma,'') As Bioma,
	   IsNull(Count(CodigoQueimada), 0) As Quantidade
From Queimadas2024
Where Mes = 10
And Estado = 'Minas Gerais'
Group By Grouping Sets (DataHora, Bioma, Municipio)
--Order By DataHora Asc, Bioma Asc
Go

--Grouping Sets - 2 grupos--
Select IsNull(Convert(Varchar(2),Day(DataHora)), '') As Dia,
	   IsNull(Municipio, '') As Municipio,
	   IsNull(Bioma,'') As Bioma,
	   IsNull(Count(CodigoQueimada), 0) As Quantidade
From Queimadas2024
Where Mes = 12
And Dia Between 10 and 20
And Estado = 'Minas Gerais'
Group By Grouping Sets (
						(DataHora), 
						(Municipio, Bioma)
						)
--Order By DataHora Asc, Bioma Asc
Go


