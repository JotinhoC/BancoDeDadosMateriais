-- Atividade: CTE em cenário de vendas de vinhos --
-- Criando o Banco de Dados CTEVinhos --
Create Database CTEVinhos
Go

-- Acessando --
Use CTEVinhos
Go

-- Criação das tabelas principais --
Create Table Vinhos 
(CodigoVinhos Int Primary Key Identity(1,1),
  Nome Varchar(100),
  Tipo Varchar(50),
  Safra Int)
Go

Create Table Clientes
(CodigoClientes Int Primary Key Identity(1,1),
  Nome Varchar(100),
  Cidade Varchar(100))
Go

Create Table Regioes 
(CodigoRegioes Int Primary Key Identity(1,1),
  Nome Varchar(100))
Go

Create Table Funcionarios 
(CodigoFuncionarios Int Primary Key Identity(1,1),
  Nome Varchar(100),
  SupervisorDe Int)
Go

Create Table Vendas 
(CodigoVendas Int Primary Key Identity(1,1),
 CodigoClientes Int,
 CodigoVinhos Int,
 CodigoFuncionarios Int,
 CodigoRegioes Int,
 Quantidade Int,
 ValorUnitario Decimal(10,2),
 DataVenda Date)
Go


-- Criação dos relacionamentos após as tabelas --

Alter Table Vendas 
 Add Constraint FK_Vendas_Clientes_CodigoClientes Foreign Key (CodigoClientes) 
  References Clientes(CodigoClientes)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Vinhos_CodigoVinhos Foreign Key (CodigoVinhos) 
  References Vinhos(CodigoVinhos)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Funcionarios_CodigoFuncionarios Foreign Key (CodigoFuncionarios) 
  References Funcionarios(CodigoFuncionarios)
Go

Alter Table Vendas 
 Add Constraint FK_Vendas_Regioes_CodigoRegioes Foreign Key (CodigoRegioes) 
  References Regioes(CodigoRegioes)
Go

-- Inserção de dados nas tabelas --
-- Vinhos --
Insert Into Vinhos (Nome, Tipo, Safra)
 Values ('Cabernet Sauvignon', 'Tinto', 2018),
             ('Merlot', 'Tinto', 2019),
             ('Chardonnay', 'Branco', 2020),
             ('Rosé da Serra', 'Rosé', 2021),
             ('Espumante São Roque', 'Espumante', 2022)
Go

-- Clientes --
Insert Into Clientes (Nome, Cidade)
Values ('Alice Borges', 'São Roque'),
            ('Marcos Tavares', 'Sorocaba'),
            ('Fernanda Lopes', 'Jundiaí'),
            ('Rafael Costa', 'São Paulo'),
            ('Juliana Prado', 'Campinas')
Go

-- Regioes --
Insert Into Regioes (Nome)
Values ('Centro'),
            ('Zona Norte'),
            ('Zona Sul'),
            ('Zona Leste'),
            ('Zona Oeste')
Go

-- Funcionarios --
Insert Into Funcionarios (Nome, SupervisorDe)
Values ('Carlos Ribeiro', NULL),
            ('Beatriz Lima', 1),
            ('Eduardo Martins', 1),
            ('Tatiane Souza', 2),
            ('João Pedro', 2)
Go

-- Vendas --
Insert Into Vendas (CodigoClientes, CodigoVinhos, CodigoFuncionarios, CodigoRegioes, Quantidade, ValorUnitario, DataVenda)
Values (1, 1, 2, 1, 10, 45.00, '2025-10-01'),
            (2, 3, 3, 2, 5, 60.00, '2025-10-02'),
            (3, 2, 4, 3, 8, 50.00, '2025-10-03'),
            (4, 5, 5, 4, 3, 80.00, '2025-10-04'),
            (5, 4, 2, 5, 6, 55.00, '2025-10-05')
Go

--Implementando as CTEs--
--Exemplo 1-- CTE - Total de vendas por região --

;With CTE_IVendasPorRegiao(Regiao, TotalVendas)
As
(
Select R.Nome As Regiao, Sum(V.Quantidade * V.ValorUnitario) As TotalVendas
From Vendas V Inner Join Regioes R
	On V.CodigoRegioes = R.CodigoRegioes
Group By R.Nome
) --Delimitando o bloco de código da CTE
--Executando--
Select Regiao, TotalVendas from CTE_IVendasPorRegiao
Go

--Exemplo 2 -- CTE Recursiva - Hierarquia de Funcionarios --
;With CTE_Hierarquia(CodigoFuncionarios, Nome, Supervisor, Nivel)
As
(
Select CodigoFuncionarios, Nome, SupervisorDe, 1 As Nivel
From Funcionarios
Where SupervisorDe Is Null

Union All

Select F.CodigoFuncionarios, F.Nome, F.SupervisorDe, H.Nivel+1
From Funcionarios F Inner Join CTE_Hierarquia H
	On F.SupervisorDe = H.CodigoFuncionarios
)
--Executando --
Select C.CodigoFuncionarios, C.Nome,
	   C.Supervisor,
	   F.Nome As 'Supervisor',
	   C.Nivel
	   From CTE_Hierarquia C Inner Join Funcionarios F
	On C.Nivel = F.CodigoFuncionarios
Go

--Exemplo 3 -- CTE com Pivot -- Vendas por tipo de Vinho --
;With CTE_VendasPorTipo
As
(
 Select V.Tipo, R.Nome As Regiao, VD.Quantidade * VD.ValorUnitario As ValorTotal
 From Vendas VD Inner Join Vinhos V
				On VD.CodigoVinhos = V.CodigoVinhos
				Inner Join Regioes R
				On VD.CodigoRegioes = R.CodigoRegioes
)
,CTE_Pivot(Regiao,Tinto,Branco,Rose,Espumante)
As
(
--Executando--
Select Regiao, IsNull(Tinto,0) As Tinto, IsNull(Branco,0) As Branco, IsNull(Rosé,0) As Rosé,
		IsNUll(Espumante,0) As Espumante
From (Select Regiao, Tipo, ValorTotal From CTE_VendasPorTipo) As SelectBase
Pivot (Sum(ValorTotal) For Tipo In ([Tinto],[Branco],[Rosé],[Espumante])) As Pvt
)
Select Regiao, Tinto, Branco, Rose, Espumante, Branco+Rose+Espumante As Total From CTE_Pivot
Go

--Exemplo 4 -- CTE - Clientes que mais compram em cada mês --
;With CTE_VendasMensais (Cliente, Mes, TotalComprado)
As
(
Select C.Nome As Cliente,
		Month(V.DataVenda) As Mes,
		Sum(V.Quantidade * V.ValorUnitario) As TotalComprado
From Vendas V Inner Join Clientes C
				On V.CodigoClientes = C.CodigoClientes
Group By C.Nome, Month(V.DataVenda)
)
--Executando --
Select Cliente, Mes, TotalComprado From CTE_VendasMensais
Order By Mes, TotalComprado Desc
Go

-- CTE para Calcular o Fatorial numérico --
;With Fatorial (f, Numero)
As
(Select Cast (1 As BigInt) As F, 0 As Numero -- Fatorial de 0 é 1
Union All
Select Cast (1 As BigInt) As F, 1 As Numero -- Fatorial de 1 é 1
Union All
Select f * (Numero+1),Numero + 1 From Fatorial
Where Numero < 20
And Numero > 0)
--Executando --
Select F from Fatorial
Where Numero = 6
Go