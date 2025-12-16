use SuperMercadoBomPreco2025
go

--criando a tabela de motoristas--
create table motoristas
(codigoMotorista Int Primary Key Identity(1,1) not null,
 nome varchar(100) null,
 CPF varchar(11) null
)
go

--criando a tabela de carros
create table carros
(codigoCarro Int Primary Key Identity(1,1) not null,
 codigoMotorista Int null,
 modelo varchar(100) null,
 placa varchar(7) null)
go

alter table carros
 add constraint FK_carros_motoristas_codigoMotorista foreign key (codigoMotorista)
 References motoristas(codigoMotorista)
go

--Inserindo dados na tabela de motoristas--
insert into motoristas
values ('Pedro',2887458211), ('Eduardo',3887458231)
go

--Inserindo dados na tabela carros--
insert into carros(codigoMotorista,modelo,placa)
values (2,'Gol','FBD3127'),(1,'Voyage','ABC2432'), (1,'Fusca','CJN9852')
go

--consultando--
select codigoMotorista, nome, CPF from motoristas
go

select codigoCarro, codigoMotorista, modelo, placa from carros
go


--Inserindo um novo motorista--
insert into motoristas (nome,CPF) values ('João',488771582)
go

select C.codigoMotorista as 'Código do Motorista',
	   M.CPF as 'CPF',
	   M.nome as 'Nome do Motorista', 
	   C.codigoCarro as 'Código do carro',
	   C.modelo as 'Modelo do Carro',
	   C.placa as 'Placa do Carro'
	   from carros C inner join motoristas M
 on c.codigoMotorista = m.codigoMotorista
go


--criando a junção - left join--
select  m.codigoMotorista as 'Motorista',
		m.nome as 'Nome',
		IsNull(Convert(varchar(2),c.codigoCarro),'') as Carro,
		IsNull(c.modelo,'') as modelo,
		IsNull(Convert(varchar(10),c.placa),'Sem Placa') as placa
		from motoristas m left join carros c
			on m.codigoMotorista = c.codigoMotorista
			order by m.nome
		go


--criando o banco do premio nobel--

create database Nobel
go

use Nobel
go
--criando as tabelas
create table paises
(CodigoPais tinyint primary key identity(1,1) not null,
 NomePais varchar(16) not null,
 SiglaPais char(3) not null)
go

create table categorias
(CodigoCategoria tinyInt primary key identity(1,1) not null,
 NomeCategoria varchar(14) not null)
go

create table indicados
(CodigoIndicado tinyint primary key identity(1,1) not null,
 NomeIndicado varchar(20) not null,
 CodigoPaisIndicado tinyint not null,
 CodigoCategoriaIndicado tinyint not null)
go

--criando os relacionamentos--
alter table indicados
	add constraint FK_indicados_paises_CodigoPaisIndicado foreign key (CodigoPaisIndicado)
	references paises(CodigoPais)
go

alter table indicados
	add constraint FK_indicados_categorias_CodigoCategoriaIndicado foreign key (CodigoCategoriaIndicado)
	references categorias(CodigoCategoria)
go

--inserindo as categorias--
insert into categorias(NomeCategoria)
values ('Literatura'),('Economia'),('Medicina'),('Química'),('Física'),('Ativismo')
go

--inserindo os paises--
insert into paises(NomePais,SiglaPais)
values ('Estados Unidos','EUA'),('Turquia','TUR'),('Inglaterra','ING'),('Japão','JPN'),('Coreia do Sul','KOR')
go

--inserindo os indicados
insert into indicados(NomeIndicado,CodigoPaisIndicado,CodigoCategoriaIndicado)
values('Daron Acemoglu',2,2),
	  ('Demis Hassabis',3,4),
	  ('Han Kang',5,1)
go

select i.NomeIndicado as 'Nome',
       p.NomePais as 'País',
	   p.SiglaPais as 'Sigla',
	   c.NomeCategoria as 'Categoria',
	   i.CodigoPaisIndicado as 'Código do País',
	   i.CodigoCategoriaIndicado as 'Código da Categoria'
       from indicados i inner join paises p
		on i.CodigoPaisIndicado = p.CodigoPais 
		inner join categorias c
		on i.CodigoCategoriaIndicado = c.CodigoCategoria
go

--aplicando a junção cruzado - produto cartesiano - Linhas da tabela a esquerda
select i.NomeIndicado, p.NomePais, p.CodigoPais from indicados i cross join paises p
go

--consultando as categorias existentes --
select CodigoCategoria, NomeCategoria from categorias
where NomeCategoria like '%Me%'
go