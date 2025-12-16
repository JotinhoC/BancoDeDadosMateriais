-- Criando o Banco de Dados - AlgebraRelacional --
Create Database AlgebraRelacional2025
Go

-- Acessando o Banco de Dados - AlgebraRelacional --
Use AlgebraRelacional2025
Go

-- Criando a Tabela Cargos --
Create Table Cargos
(CodigoCargo Char(2) Primary Key Not Null,
  DescricaoCargo Varchar(50) Not Null,
  VlrSalario Numeric(6,2) Not Null)
Go

-- Criando a Tabela Departamentos --
Create Table Departamentos
(CodigoDepartamento Char(2) Primary Key Not Null,
 DescricaoDepartamento Varchar(30) Not Null,
 RamalTel SmallInt Not Null)
Go

-- Criando a Tabela Funcionarios --
Create Table Funcionarios 
(NumeroRegistro Int Primary Key Not Null,
 NomeFuncionario Varchar(80) Not Null,
 DtAdmissao Date Default GetDate(),
 Sexo Char(1) Not Null Default 'M',
 CodigoCargo Char(2) Not Null,
 CodigoDepartamento Char(2) Not Null)
Go

-- Criando a Tabela Projetos --
Create Table Projetos
 (CodigoProjeto Char(8) Primary Key Not Null,
  DescricaoProjeto Varchar(50) Not Null)
Go

-- Criando a Tabela Equipes --
Create Table Equipes
(Codigo Int Primary Key Identity(1,1) Not Null,
 NumeroRegistroFuncionario Int Not Null,
 CodigoProjeto Char(8) Not Null)
Go

-- Criando os relacionamentos --
Alter Table Funcionarios
 Add Constraint [FK_Funcionarios_Cargos] Foreign Key (CodigoCargo)
  References Cargos(CodigoCargo)
Go

Alter Table Funcionarios
 Add Constraint [FK_Funcionarios_Departamentos] Foreign Key (CodigoDepartamento)
  References Departamentos(CodigoDepartamento)
Go

Alter Table Equipes
 Add Constraint [FK_Equipe_Funcionarios] Foreign Key (NumeroRegistroFuncionario)
  References Funcionarios(NumeroRegistro)
Go

Alter Table Equipes
 Add Constraint [FK_Equipe_Projetos] Foreign Key (CodigoProjeto)
  References Projetos(CodigoProjeto)
Go

-- Inserindo os Dados --
Insert Into Cargos (CodigoCargo, DescricaoCargo, VlrSalario)
Values ('C1', 'Aux.Vendas', 350.00), 
	         ('C2', 'Vigia', 400.00),
	         ('C3', 'Vendedor', 800.00),
	         ('C4', 'Aux.Cobrança', 250.00), 
	         ('C5', 'Gerente', 1000.00), 
	         ('C6', 'Diretor', 2500.00),
	         ('C7', 'Presidente', 2500.00)
Go

Insert Into Departamentos (CodigoDepartamento, DescricaoDepartamento, RamalTel)
Values ('D1', 'Assist.Técnica', 2246),
	         ('D2', 'Estoque', 2589),
	         ('D3', 'Administração', 2772),
	         ('D4', 'Segurança', 1810),
	         ('D5', 'Vendas', 2599),
	         ('D6', 'Cobrança', 2688)
Go

Insert Into Funcionarios (NumeroRegistro, NomeFuncionario, DtAdmissao, Sexo, CodigoCargo, CodigoDepartamento)
Values (101, 'Luis Sampaio', '2003-08-10', 'M', 'C3', 'D5'),
             (104, 'Carlos Pereira', '2004-03-02', 'M', 'C4', 'D6'),
	         (134, 'Jose Alves', '2002-05-03', 'M', 'C5', 'D1'),
	         (121, 'Luis Paulo Souza', '2001-12-10', 'M', 'C3', 'D5'),
             (195, 'Marta Silveira', '2002-01-05', 'F', 'C1', 'D5'),
	         (139, 'Ana Luiza', '2003-01-12', 'F', 'C4', 'D6'),
	         (123, 'Pedro Sergio', '2003-06-29', 'M', 'C7', 'D3'),
             (148, 'Larissa Silva', '2002-06-01', 'F', 'C4', 'D6'),
	         (115, 'Roberto Fernandes', '2003-10-15', 'M', 'C3', 'D5'),
             (22,  'Sergio Nogueira', '2000-02-10', 'M', 'C2', 'D4')
Go

Insert Into Projetos (CodigoProjeto, DescricaoProjeto)
Values ('Projeto1', 'Suporte'), ('Projeto2', 'Manutenção'), ('Projeto3', 'Desenvolvimento')
Go

Insert Into Equipes (NumeroRegistroFuncionario, CodigoProjeto)
Values (101, 'Projeto1'), (104, 'Projeto1'), (134, 'Projeto1'),
       (101, 'Projeto2'), (104, 'Projeto2'), (101, 'Projeto3')
Go

/* Exemplo - Operador - Projeção - Qual é o nome e a data de admissão dos funcionários? */
Select NomeFuncionario, DtAdmissao From Funcionarios
go

/* Exemplo - Operador - Seleção/Restrição - Quais os funcionários de sexo Masculino? */
Select NumeroRegistro, NomeFuncionario, DtAdmissao, Sexo, CodigoCargo,
	   CodigoDepartamento
From Funcionarios
Where Sexo = 'M'
Go
/*Exemplo - Operador - Produto Cartesiano - Trazer os dados dos funcionários e de seus cargos*/
Select F.NomeFuncionario, C.DescricaoCargo
From Funcionarios F Cross Join Cargos C
Order By F.NomeFuncionario Asc
Go

/*Exemplo - Operador - União -- Combinação de Tabelas e Linhas entre selects distintos*/
Select CodigoCargo, DescricaoCargo, VlrSalario
From Cargos
Where CodigoCargo In ('C1','C3','C5','C7')

Union

Select CodigoCargo, DescricaoCargo, VlrSalario
From Cargos
Where CodigoCargo In ('C2','C4','C6')
Go

/*Exemplo - Operador - Interseção -- Combinação de Tabelas e Linhas entre selects distintos sem repetir*/
Select CodigoCargo, DescricaoCargo, VlrSalario
From Cargos
Where CodigoCargo In ('C2','C4','C6')

Intersect

Select CodigoCargo, DescricaoCargo, VlrSalario
From Cargos
Where CodigoCargo In ('C2','C3','C6','C7')
Go

/* Exemplo - Operador - Diferença - Linhas existentes em uma Tabela que não existem em outra */
Insert Into Cargos(CodigoCargo, DescricaoCargo, VlrSalario)
Values ('C8','Aux Vendas II', 550.00)
Go

-- Oque Existe em Cargos e Existe em Funcionários --
Select F.NumeroRegistro, F.NomeFuncionario, F.DtAdmissao, F.Sexo,
	   F.CodigoCargo, F.CodigoDepartamento
From Funcionarios F
Where Exists (Select CodigoCargo From Cargos)
Order By F.CodigoCargo
Go

/*Diferença entre Cargos e Funcionários - O que Existe em Cargos que não existe em Funcionários */
Select CodigoCargo From Cargos
Where CodigoCargo Not In (Select CodigoCargo From Funcionarios)
Go

/*Exemplo - Operador - Junção -- Combinação de Linhas e Colunas 
entre tabelas que possuem algum tipo de vínculo relacional*/
Select F.NumeroRegistro, F.NomeFuncionario, F.DtAdmissao,
	   F.Sexo, C.CodigoCargo, C.DescricaoCargo,
	   C.VlrSalario, F.CodigoDepartamento
From Funcionarios F Inner Join Cargos C
	On F.CodigoCargo = C.CodigoCargo
Order By F.NomeFuncionario, F.CodigoCargo Asc
Go

-- Divisão --
Select F.NumeroRegistro, F.NomeFuncionario, F.DtAdmissao,
	   F.Sexo, C.CodigoCargo, C.DescricaoCargo,
	   C.VlrSalario, F.CodigoDepartamento
From Funcionarios F Inner Join Cargos C
	On F.CodigoCargo = C.CodigoCargo
Where F.Sexo = 'F'
Order By F.NomeFuncionario, F.CodigoCargo Asc
Go

--Exemplo - Operador de Atribuição --
Declare @Valor Int

Set @Valor = 1 -- Atribuição de valor para a variável --

Select @Valor = 2 -- Atribuição --

Set @Valor = @Valor+1 -- Atribuição--
Go

--Exemplo - Operador - Atribuição --
Select F.NumeroRegistro As 'Número de Registro', F.NomeFuncionario,
	   F.DtAdmissao As 'Data de Admissão',

	   Data=(GetDate()), -- Atribuindo um valor para uma coluna
	   (GETUTCDATE()) As NovaData, --Atribuindo um valor para uma coluna
	   Concat('Este é um texto -',NumeroRegistro) As Mensagem,'Este é um texto -'+Convert(Varchar(3),NumeroRegistro) As MensagemVeia
From Funcionarios F
Go