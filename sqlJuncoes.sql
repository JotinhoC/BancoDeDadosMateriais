-- Criando o Banco de Dados Junções
create database Juncoes2025
go

-- Acessando --
use Juncoes2025
go

-- Criando a Tabela Cursos --
create table Cursos
 (CodigoCurso Int Primary Key Identity(1,1),
  NomeCurso Varchar(10) Default 'Curso')
Go

-- Criando a tabela de Professores --
create table Professores
 (CodigoProfessor Int Primary Key Identity(1,1),
  CodigoCurso Int Not Null,
  NomeProfessor Varchar(40) Default 'Professor')
go

-- Adicionando o Relacionamento entre as Tabelas Professores e Cursos --
Alter Table Professores
 Add Constraint FK_Professores_Cursos_CodigoCurso Foreign Key (CodigoCurso)
 References Cursos(CodigoCurso)
Go

-- Inserindo 5 novos cursos --
Insert Into Cursos Default Values
Go 5

-- Inserindo 5 novos Professores --
Insert Into Professores (CodigoCurso, NomeProfessor)
Values (1, 'Chicão'), (2, 'Zelão'), (3, 'Betão'), (4, 'Gamarra'), (5, 'Felix')
Go

-- Consultando --
Select CodigoCurso, NomeCurso From Cursos
Go

Select CodigoProfessor, CodigoCurso, NomeProfessor From Professores
Go

-- Criando a minha primeira junção 
Select C.NomeCurso, P.CodigoProfessor, P.NomeProfessor
From Cursos C Inner Join Professores P -- Junção da verdade --
	On C.CodigoCurso = P.CodigoCurso-- Linha da condição --
Go

-- Atualizando os dados na Tabela Cursos --
Update Cursos
Set NomeCurso = 'ADS'
Where CodigoCurso = 1
Go

Update Cursos
Set NomeCurso = 'Culinária'
Where CodigoCurso = 2
Go

Update Cursos
Set NomeCurso = 'Costura'
Where CodigoCurso = 3
Go

-- Consultando a Tabela Cursos --
Select CodigoCurso, NomeCurso From Cursos
Where CodigoCurso In (1,2,3)
Go

--Estabelecendo uma nova junção entre as Tabelas Cursos e Professores --
Select C.CodigoCurso As 'Código Curso',
	   C.NomeCurso As 'Nome do Curso',
	   P.CodigoProfessor As 'Código do Professor',
	   P.NomeProfessor As 'Nome do Professor'
From Cursos C Inner Join Professores P
	On C.CodigoCurso = P.CodigoCurso

Where C.CodigoCurso <= 3
Order By NomeCurso Desc
Go

-- Inserindo um novo Professor --
Insert Into Professores (CodigoCurso, NomeProfessor)
Values (3, 'Amarildo')
Go

-- Inserindo um novo Curso --
Insert Into Cursos (NomeCurso) Values ('Aviação')
Go

--Estabelecendo uma nova junção entre as Tabelas Cursos e Professores -- Left Join --
Select C.CodigoCurso As 'Código Curso',
	   C.NomeCurso As 'Nome do Curso',
	   P.CodigoProfessor As 'Código do Professor',
	   P.NomeProfessor As 'Nome do Professor'
From Cursos C Left Join Professores P
	On C.CodigoCurso = P.CodigoCurso

Order By NomeCurso Desc
Go

--Estabelecendo uma nova junção entre as Tabelas Cursos e Professores -- Right Join --
Select C.CodigoCurso As 'Código Curso',
	   C.NomeCurso As 'Nome do Curso',
	   P.CodigoProfessor As 'Código do Professor',
	   P.NomeProfessor As 'Nome do Professor'
From Professores P Right Join Cursos C
	On C.CodigoCurso = P.CodigoCurso

Order By NomeCurso Desc
Go