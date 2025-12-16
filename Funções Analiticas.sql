-- Criando o Banco de Dados --
Create Database FuncoesAnaliticas
Go

-- Acessando --
Use FuncoesAnaliticas
Go

-- Criando a Tabela de Produtos --
Create Table Produtos 
(CodigoProduto Int Primary Key,
 NomeProduto VarChar(10),
 PrecoProduto Decimal(6,2))
Go

-- Inserindo os dados na Tabela Produtos --
Insert Into Produtos (CodigoProduto, NomeProduto, PrecoProduto) 
Values (1, 'Produto A', 10.00),
       (2, 'Produto B', 20.00),
       (3, 'Produto C', 30.00),
       (4, 'Produto D', 40.00),
       (5, 'Produto E', 50.00),
       (6, 'Produto F', 60.00),
       (7, 'Produto G', 70.00),
       (8, 'Produto H', 80.00),
       (9, 'Produto I', 90.00),
       (10, 'Produto J', 100.00)
Go

-- Consultando a Tabela de Produtos --
Select CodigoProduto, NomeProduto, PrecoProduto From Produtos
Go
 
-- Exemplo 1 - Função Cume_Dist() - Calcular a distribuição cumulativa dos preços dos produtos --
Select NomeProduto, PrecoProduto, Cume_Dist() Over (Order By PrecoProduto) As Distribuicao
From Produtos
Go

-- Exemplo 2 - Função Percent_Rank() - Calcular a Percentual de Ranqueamento dos preços dos produtos --
Select NomeProduto, PrecoProduto, Percent_Rank() Over (Order By PrecoProduto) As Percentual
From Produtos
Go

-- Exemplo 3 - Função Percent_Rank() e Cume_Dist - Comparativo --
Select NomeProduto, PrecoProduto,
	   Percent_Rank() Over (Order By PrecoProduto) As Percentual,
	   Cume_Dist() Over (Order By PrecoProduto) As Distribuicao
From Produtos
Go

-- Exemplo 4 - Função First_Value() - Apresenta o primeiro preço na lista ordenada de produtos --
Select NomeProduto, PrecoProduto,
	   First_Value(PrecoProduto) Over (Order By PrecoProduto) As PrimeiroPrecoProduto
From Produtos
Go

-- Exemplo 5 - Função Last_Value() - Apresenta o ultimo preço na lista ordenada de produtos --
Select Distinct
	   Last_Value(PrecoProduto) Over (Order By PrecoProduto) As UltimoPrecoProduto
From Produtos
Order By UltimoPrecoProduto Desc
Go

-- Exemplo 6 - Função Lag() - Acessa o preço do produto anterior na lista ordenada --
Select NomeProduto, PrecoProduto,
	   Lag(PrecoProduto,1,0) Over (Order By PrecoProduto) As PrecoAnterior
From Produtos
Go

-- Exemplo 7 - Função Lead() - Acessa o preço do produto posterior na lista ordenada --
Select NomeProduto, PrecoProduto,
	   Lead(PrecoProduto,1,0) Over (Order By PrecoProduto) As ProximoAnterior
From Produtos
Go

-- Exemplo 8 - Função Percentile_Cont() - Calcula o percentil continuo (mediana) --
Select NomeProduto, PrecoProduto,
	   Percentile_Cont(0.5) Within Group (Order By PrecoProduto)
							Over() As MedianaPrecoProduto
From Produtos
Go

-- Exemplo 9 - Função Percentile_Disc() - Computa (Valor Especifico) o percentil especifico (mediana) --
Select NomeProduto, PrecoProduto,
	   Percentile_Disc(0.5) Within Group (Order By PrecoProduto)
							Over() As MedianaPrecoProduto
From Produtos
Go

--Exemplo 10 - Função Row_Number() - Criar uma numerção artificial de linhas --
Select Row_Number() Over (Order By PrecoProduto Desc) As NumeroDaLinha,
	   PrecoProduto
From Produtos
Go


--Removendo a Tabela de Produtos--
Drop Table Produtos
Go

--Criando a Tabela Produtos --
Create Table Produtos
 (Codigo SmallInt Identity Primary Key Clustered,
 Valor Int,
 DataCriacao Date,
 DataManipulacao Date)
 On [Primary]
Go

--Exemplo 1 - Inserindo Dados na Tabela Produtos e Retornando os valores em Tela --
Insert Into Produtos(Valor, DataCriacao, DataManipulacao)
Output inserted.Codigo, inserted.Valor, inserted.DataManipulacao,'Comando Insert'
Values (10, GetDate(), GetDate()+1),
	   (20, GetDate(), GetDate()+2),
	   (30, GetDate(), GetDate()+3),
	   (40, GetDate(), GetDate()+4),
	   (50, GetDate(), GetDate()+5)
Go

-- Exemplo 2 - Atualizando dados na Tabela Produtos e Retornando em Tela --
Update Produtos
Set DataManipulacao = GetDate()+30
Output Deleted.DataCriacao As 'Data Antiga', -- valor antigo
	   inserted.DataManipulacao As 'Data Atualizada' -- novo valor
Where Valor = 30
Go

--Exemplo 3 -- Excluindo dados na Tabela Produto e Retornando em Tela --
Delete From Produtos
Output Deleted.*
Where Codigo In(2,4)
Go

