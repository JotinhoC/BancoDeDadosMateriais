create database FilmesIMDB
go

use FilmesIMDB
go


select * from [dbo].[filmesImdb]
go


create table Participacoes
(
codigo_participacoes int primary key identity(1,1) not null,
diretor varchar(200) null,
atores varchar(200) null,
roteirista varchar(200) null,
)
go

create table Filmagem
(
codigo_filmagem int primary key identity(1,1) not null,
genero varchar(200) null,
pais_origem varchar(200) null,
local_filmagem varchar(200) null,
compania_producao varchar(200) null,
ano varchar(200) null,
duracao varchar(200) null
)
go

create table avaliacao
(
codigo_avaliacao int primary key identity(1,1) not null,
nome_filme varchar(200) null,
classificacao varchar(200) null,
nota_imdb varchar(200) null,
votos varchar(200) null,
nominacoes varchar(200) null,
oscar varchar(200) null
)
go

create table Resultado
(
codigo_resultado int primary key identity(1,1) not null,
codigo_filmagem int null,
codigo_participantes int null,
codigo_avaliacao int null,
)
go

drop table avaliacao
go
alter table Resultado
add constraint FK_codigo_filmagem foreign key (codigo_filmagem) references Filmagem(codigo_filmagem)
go

alter table Resultado
add constraint FK_codigo_participantes foreign key (codigo_participantes) references Participacoes(codigo_participacoes)
go

alter table Resultado
add constraint fk_codigo_avaliacao foreign key (codigo_avaliacao) references avaliacao(codigo_avaliacao)
go

--insert
insert into Participacoes (diretor, atores, roteirista)
select director, star, writer from filmesImdb
go

select * from Participacoes
go

--Insert
insert into Filmagem (genero, pais_origem, local_filmagem, compania_producao, ano, duracao)
select genre, country_origin, filming_location, production_company, year, duration  from filmesImdb
go

select * from Filmagem
go

--Insert
insert into avaliacao (nome_filme, classificacao, nota_imdb, votos, nominacoes, oscar)
select title, rating_mpa, rating_imdb, vote, nomination, oscar from filmesImdb
go

select * from avaliacao
go

--Insert Resultado

insert into Resultado(codigo_filmagem, codigo_participantes, codigo_avaliacao)
select F.codigo_filmagem, P.codigo_participacoes, A.codigo_avaliacao
	from avaliacao A inner join Filmagem F
	on A.codigo_avaliacao = F.codigo_filmagem
	inner join Participacoes P
	on P.codigo_participacoes = F.codigo_filmagem
go

select * from Resultado
go

--Procedure para filtrar pelo pais
create procedure P_Pais
	@pais varchar(100)
as
begin
	select A.nome_filme, F.genero, F.ano, F.duracao, F.pais_origem
	from Resultado R inner join Filmagem F
	on R.codigo_filmagem = F.codigo_filmagem
	inner join avaliacao A
	on A.codigo_avaliacao = R.codigo_avaliacao
	where F.pais_origem like @pais
end

exec P_Pais @pais = 'Mexico'
go
	
--Procedure para filtrar pelo genero
create procedure P_Genero
	@genero varchar(100)
as
begin
	select A.nome_filme, F.genero, F.ano, F.duracao, F.pais_origem
	from Resultado R inner join Filmagem F
	on R.codigo_filmagem = F.codigo_filmagem
	inner join avaliacao A
	on A.codigo_avaliacao = R.codigo_avaliacao
	where F.genero like @genero
end

exec P_Genero @genero = '%Horror%'
go

--Mostrar apenas os filmes mostrando o nome, ano e a nota no imdb
create View V_FilmesInfoBasica
as
select A.nome_filme, F.genero, F.ano, A.nota_imdb
	from Resultado R inner join avaliacao A
	on R.codigo_avaliacao = A.codigo_avaliacao
	inner join Filmagem F
	on R.codigo_filmagem = F.codigo_filmagem
go

--Mostrar apenas os filmes que ja foram nominados a um oscar
create View V_FilmesNominacoes
as
select A.nome_filme, F.genero, F.ano, A.nominacoes
	from Resultado R inner join avaliacao A
	on R.codigo_avaliacao = A.codigo_avaliacao
	inner join Filmagem F
	on R.codigo_filmagem = F.codigo_filmagem
	where A.nominacoes != 0
go

--Mostrar apenas os filmes que ja receberam um oscar
create View V_FilmesOscar
as
select A.nome_filme, F.genero, F.ano, A.oscar
	from Resultado R inner join avaliacao A
	on R.codigo_avaliacao = A.codigo_avaliacao
	inner join Filmagem F
	on R.codigo_filmagem = F.codigo_filmagem
	where A.oscar != 0
go

--Configurando o backup
alter database FilmesIMDB
Set Recovery Simple
Go

Backup Database FilmesIMDB
To Disk = 'C:\Backup\Backup-Database-FilmesIMDB.bak'
With Init,
	 Description = 'Backup do FilmesIMDB',
	 Stats = 5
Go

