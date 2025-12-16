create database OlympicData
go

use OlympicData
go

create schema SchemaOlympicData
go

create table Pais
(CodigoPais int identity(1,1) primary key clustered not null,
 NomePais Varchar(25) not null,
 Sigla Varchar(3) not null,
 Continente Varchar(14))
go

create table Modalidade
(CodigoModalidade int identity(1,1) primary key clustered not null,
 NomeModalidade Varchar(30) not null,
 Tipo Varchar(16) not null,
 Categoria Varchar(20))
go


create table Atleta
(CodigoAtleta int identity(1,1) primary key clustered not null,
 NomeAtleta Varchar(30),
 Sexo varchar(1),
 Idade int,
 CodigoPais int)
go

create table Competicao
(CodigoCompeticao int identity(1,1) primary key clustered not null,
 Ano Date not null,
 CidadeSede Varchar(25) not null,
 TipoCompeticao Varchar(20) not null)
go

create table Resultado
(CodigoResultado int identity(1,1) primary key clustered not null,
 CodigoAtleta int not null,
 CodigoModalidade int not null,
 CodigoCompeticao int not null,
 Medalha Varchar(8) not null,
 Tempo float not null,
 Pontuacao numeric)
go


--relacionamentos
alter table Atleta
	add constraint [FK_Atleta_Pais_CodigoPais] foreign key (CodigoPais)
		references Pais(CodigoPais)
go

alter table Resultado
	add constraint [FK_Resultado_Atleta_CodigoAtleta] foreign key (CodigoAtleta)
		references Atleta(CodigoAtleta)
go

alter table Resultado
	add constraint [FK_Resultado_Competicao_CodigoCompeticao] foreign key (CodigoCompeticao)
		references Competicao(CodigoCompeticao)
go

alter table Resultado
	add constraint [FK_Resultado_Modalidade_CodigoModalidade] foreign key (CodigoModalidade)
		references Modalidade(CodigoModalidade)
go

alter table Competicao
 Alter Column Ano Varchar(10) not null
go

--inserindo valores
insert into Pais (NomePais, Sigla, Continente)
values	('Brasil', 'BRA', 'América'),
		('Estados Unidos','USA','América'),
		('Japão','JPN', 'Ásia'),
		('Portugal', 'POR', 'Europa'),
		('Australia', 'AUS', 'Oceania')
go

insert into Modalidade (NomeModalidade, Tipo, Categoria)
values	('Salto Com Vara', 'Individual', 'Campo'),
		('Corrida de 100 Metros', 'Individual', 'Campo'),
		('Ginastica Artistica', 'Individual', 'Quadra'),
		('Futsal', 'Coletivo', 'Quadra'),
		('Volei de Praia', 'Coletivo', 'Campo de areia')
go

insert into Atleta (NomeAtleta, Sexo, Idade, CodigoPais)
values	('Anton Almeida', 'M', 26, 1),
		('John Mach', 'M', 25, 2),
		('Komekichi Yamahiro', 'F', 26, 3),
		('Maria Consilva', 'F', 24, 4),
		('Mark Karmak', 'M', 27, 5)
go

insert into Competicao (Ano, CidadeSede, TipoCompeticao)
values	('21/10/2025', 'Tóquio', 'Verão'),
		('05/06/2020', 'California', 'Verão'),
		('04/04/2016', 'Republica Tcheca', 'Verão'),
		('21/06/2012', 'Londres', 'Verão'),
		('23/06/2012', 'Londres', 'Verão')
go



update Competicao
 set Ano = Year(Ano)
go


--tempo é em segundos
insert into Resultado (CodigoAtleta, CodigoModalidade, CodigoCompeticao, Medalha, Tempo, Pontuacao)
values	(1,1,2,'Prata',40.3,4),
		(2,2,4,'Ouro',23.5,8),
		(3,3,5,'Ouro',63,9),
		(4,4,3,'Prata', 2400,6),
		(5,5,1,'Bronze',2400,5)
go

-- Parte 2

Create NonClustered Index IND_NonClustered_NomePais
	On Pais (NomePais)
go

Create NonClustered Index IND_NonClustered_NomeAtleta
	On Atleta (NomeAtleta)
go

Create NonClustered Index IND_NonClustered_TipoCompeticao
	On Competicao (TipoCompeticao)
go

Create NonClustered Index IND_NonClustered_CidadeSede
	On Competicao (CidadeSede)
go

Create NonClustered Index IND_NonClustered_Medalhas
	On Resultado (Medalha)
go
Create NonClustered Index IND_NonClustered_Tempos
	On Resultado (Tempo)
go
Create NonClustered Index IND_NonClustered_Pontuacoes
	On Resultado (Pontuacao)
go

Create Unique NonClustered Index IND_NonClustered_Unique_SiglaPais
	On Pais (Sigla)
go

Create Unique NonClustered Index IND_NonClustered_Unique_Modalidades
	On Modalidade (NomeModalidade)
go

Create Statistics [EstatisticaAtletasIdade] On Atleta(Idade)
go

Create Statistics [EstatisticaResultadoPontuacao] On Resultado(Pontuacao)
go

-- Parte 3
--1
Select A.NomeAtleta as 'Nome do Atleta',
	   A.Sexo,
	   A.Idade,
	   P.NomePais as 'Pais de Origem'
	From Atleta A Inner Join Pais P
	on A.CodigoPais = P.CodigoPais
go

--2
Select A.NomeAtleta,
	   M.NomeModalidade,
	   R.Medalha,
	   R.Pontuacao
	From Resultado R Inner Join Atleta A
	on R.CodigoAtleta = A.CodigoAtleta
	Inner Join Modalidade M
	on R.CodigoModalidade = M.CodigoModalidade
go

--3
Select C.Ano,
	   C.CidadeSede,
	   A.NomeAtleta,
	   R.Tempo
	From Competicao C Inner Join Resultado R
	on C.CodigoCompeticao = R.CodigoCompeticao
	Inner Join Atleta A
	on A.CodigoAtleta = R.CodigoAtleta
go

--4
Select P.NomePais,
	   R.Medalha,
	   Count(R.Medalha) As TotalMedalhas
	From Atleta A Inner Join Resultado R
	on A.CodigoAtleta = R.CodigoAtleta
	Inner Join Pais P
	on A.CodigoPais = P.CodigoPais
	group by  P.NomePais, R.Medalha
go
	
--5
Select M.NomeModalidade,
	   C.TipoCompeticao
	From Resultado R Inner Join Competicao C
	on R.CodigoCompeticao = C.CodigoCompeticao
	Inner Join Modalidade M
	on R.CodigoModalidade = M.CodigoModalidade
go

--6
Select P.NomePais,
	   M.NomeModalidade,
	   A.NomeAtleta
	From Resultado R Inner Join Modalidade M
	on R.CodigoModalidade = M.CodigoModalidade
	Inner Join Atleta A
	on A.CodigoAtleta = R.CodigoAtleta
	Inner Join Pais P
	on A.CodigoPais = P.CodigoPais
go

-- Parte 4
--1
Select NomePais,Pvt.[Ouro], Pvt.[Prata], Pvt.[Bronze] from 
(Select CodigoResultado,P.NomePais,Medalha From Resultado R Inner Join Atleta A
on R.CodigoAtleta = A.CodigoAtleta
Inner Join Pais P
on P.CodigoPais = A.CodigoPais) As T 
Pivot (Count(CodigoResultado) For Medalha In ([Ouro],[Prata],[Bronze])) As Pvt
go

--2
Select NomeModalidade,Pvt.[Ouro], Pvt.[Prata], Pvt.[Bronze] from 
(Select CodigoResultado,M.NomeModalidade,Medalha From Resultado R Inner Join Modalidade M
on R.CodigoModalidade = M.CodigoModalidade) As T
Pivot (Count(CodigoResultado) For Medalha In ([Ouro],[Prata],[Bronze])) As Pvt
go

--3
Select Ano,Pvt.[Ouro], Pvt.[Prata], Pvt.[Bronze] from 
(Select CodigoResultado,C.Ano,Medalha From Resultado R Inner Join Competicao C
on R.CodigoCompeticao = C.CodigoCompeticao) As T 
Pivot (Count(CodigoResultado) For Medalha In ([Ouro],[Prata],[Bronze])) As Pvt
go

--4
Select NomeAtleta, TipoMedalha, Quantidade from 
(Select NomeAtleta,
		Count(Case When Medalha = 'Ouro' Then 1 End) As Ouro,
		Count(Case When Medalha = 'Prata' Then 1 End) As Prata,
		Count(Case When Medalha = 'Bronze' Then 1 End) As Bronze
		From Resultado R Inner Join Atleta A
on R.CodigoAtleta = A.CodigoAtleta
group by NomeAtleta) As T
Unpivot (Quantidade For TipoMedalha In (Ouro, Prata, Bronze)) As UnPvt
go

-- Parte 5

Alter Database OlympicData
Set Recovery Simple
go


Backup database OlympicData
To Disk = 'C:\Backup\Backup-OLYMPICDATA-Simple-1.bak'
With Init,
	Description = 'Meu Backup',
	Stats = 5
go

--drop table Atleta
--go

Backup database OlympicData
To Disk = 'C:\Backup\Backup-OLYMPICDATA-Simple-2.bak'
With Init,
	Description = 'Meu Backup 2',
	Stats = 5
go

Alter Database OlympicData
Set Recovery Full
go

Backup database OlympicData
To Disk = 'C:\Backup\Backup-OLYMPICDATA-Full-1.bak'
With Init,
	Description = 'Meu Backup full',
	Stats = 5
go

drop table Resultado
go

Restore Database OlympicData
From Disk = 'C:\Backup\Backup-OLYMPICDATA-Full-1.bak'
with Recovery,
	 Replace,
	 Stats = 5
go

