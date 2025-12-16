-- Criando o Banco de Dados Estoques --
Create Database Estoques
Go

-- Acessando --
Use Estoques
Go

-- Criando a Tabela de Produtos --
Create Table Produtos
(CodigoProduto Int Primary Key,
 NomeProduto Varchar(20) Not Null,
 QuantidadeProduto Float Not Null)
Go

-- Criando a Tabela de Estoques --
Create Table Estoques
(CodigoEstoque TinyInt Primary Key,
 DescricaoEstoque Varchar(20) Not Null)
Go

-- Criando a Tabela de Movimentacao --
Create Table Movimentacao
(CodigoMovimentacao Int Primary Key,
 CodigoProduto Int Not Null,
 CodigoEstoque TinyInt Not Null,
 DataMovimentacao Date Default GetDate(),
 Quantidade Float Not Null,
 TipoMovimentacao Char(1) Default 'E')
Go

-- Criando a Tabela de SaldosMovimentacaoProdutos --
Create Table SaldosMovimentacaoProdutos
(Codigo Int Identity(1,1) Primary Key,
 CodigoProduto Int Not Null,
 CodigoEstoque TinyInt Not Null,
 SaldoProduto Float Not Null)
Go

-- Inserindo os valores --
Insert Into Produtos
Values (1,'A',10), (2,'B',20), (3,'C',30), (4,'D',40)
Go

Insert Into Estoques
Values (1,'Estoque A'), (2,'Estoque B')
Go

Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque, Quantidade, TipoMovimentacao)
Values (1, 2, 2, 18,'E'), (2, 3, 2, 12,'E'), (3, 1, 1, 5,'E'), (4, 4, 2, 12,'S')
Go

-- Carga inicial na Tabela de SaldosMovimentacaoProdutos com a quantidade inicial de Zero para todos os produtos --
Insert Into SaldosMovimentacaoProdutos
Select Distinct CodigoProduto, CodigoEstoque, 0 As SaldoProduto From Movimentacao
Go

--Visualizando os dados --
Select M.CodigoMovimentacao, M.CodigoProduto,
	   P.NomeProduto,
	   M.CodigoEstoque,
	   E.DescricaoEstoque,
	   M.DataMovimentacao,
	   Case M.TipoMovimentacao
	    When 'E' Then 'Entrada'
		When 'S' Then 'Saida'
	   End As TipoMovimentacao,
	   M.Quantidade
From Movimentacao M Inner Join Produtos P

					On M.CodigoProduto = P.CodigoProduto
					Inner Join Estoques E
					On M.CodigoEstoque = E.CodigoEstoque
Go

-- Criando o Trigger T_ControleMovimentacaoSaldoProduto --
Alter Trigger T_ControleMovimentacaoSaldoProduto
On Movimentacao
After Insert, Update
As

Begin
	--Set NoCount On

	Declare @CodigoProduto Int, @Quantidade Float, @TipoMovimentacao Char(1), @CodigoEstoque Int
	Select @CodigoProduto = CodigoProduto, @Quantidade = Quantidade,
			@TipoMovimentacao = TipoMovimentacao, @CodigoEstoque = CodigoEstoque
	From inserted

	if @TipoMovimentacao = 'E'
	 Update SaldosMovimentacaoProdutos Set SaldoProduto = SaldoProduto+@Quantidade
	 Where CodigoProduto = @CodigoProduto And CodigoEstoque = @CodigoEstoque

	if @TipoMovimentacao = 'S'
	 Update SaldosMovimentacaoProdutos Set SaldoProduto = SaldoProduto-@Quantidade
	 Where CodigoProduto = @CodigoProduto And CodigoEstoque = @CodigoEstoque
End
Go


-- Inserindo novas movimentações de produtos --
Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque,
							Quantidade, TipoMovimentacao)
Values (5,1,2,18,'E')
Go

-- Inserindo novas movimentações de produtos --
Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque,
							Quantidade, TipoMovimentacao)
Values (6,3,2,10,'E')
Go

-- Inserindo novas movimentações de produtos --
Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque,
							Quantidade, TipoMovimentacao)
Values (7,3,2,5,'S')
Go

--Visualizando os dados --
Select M.CodigoMovimentacao, M.CodigoProduto,
	   P.NomeProduto,
	   M.CodigoEstoque,
	   E.DescricaoEstoque,
	   M.DataMovimentacao,
	   Case M.TipoMovimentacao
	    When 'E' Then 'Entrada'
		When 'S' Then 'Saida'
	   End As TipoMovimentacao,
	   M.Quantidade,
	   S.SaldoProduto As 'Saldo do Produto'
From Movimentacao M Inner Join Produtos P

					On M.CodigoProduto = P.CodigoProduto
					Inner Join Estoques E
					On M.CodigoEstoque = E.CodigoEstoque
					Inner Join SaldosMovimentacaoProdutos S
					On M.CodigoProduto = S.CodigoProduto
					And M.CodigoEstoque = S.CodigoEstoque
Go


-- Realizando um novo teste --
Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque,
							Quantidade, TipoMovimentacao)
Values (8,4,1, 25,'E')
Go

-- Inserindo manualmente o produto no estoque para contabilizar o seu saldo --
Insert Into SaldosMovimentacaoProdutos(CodigoProduto, CodigoEstoque, SaldoProduto)
Values (4,1,0)
Go

-- Realizando um novo teste --
Insert Into Movimentacao (CodigoMovimentacao, CodigoProduto, CodigoEstoque,
							Quantidade, TipoMovimentacao)
Values (9,4,1, 25,'E')
Go

Select * From Movimentacao
Select * From SaldosMovimentacaoProdutos

--Criando uma Sumarização da quantidade de estoque de acordo com o Produto, Estoque e Tipo --
Select CodigoProduto, CodigoEstoque, Sum(Quantidade) As Soma, TipoMovimentacao
From Movimentacao
Group By CodigoProduto, CodigoEstoque, TipoMovimentacao
Go

-- Criando as CTEs Entradas e Saidas --
;With Entradas (CodigoProduto, CodigoEstoque, Somatoria)
As
(Select CodigoProduto, CodigoEstoque, Sum(Quantidade) As Somatoria
From Movimentacao
Where TipoMovimentacao = 'E'
Group By CodigoProduto, CodigoEstoque
),
Saidas (CodigoProduto, CodigoEstoque, Somatoria)
As
(Select CodigoProduto, CodigoEstoque, Sum(Quantidade) As Somatoria
From Movimentacao
Where TipoMovimentacao = 'S'
Group By CodigoProduto, CodigoEstoque
)
--Executando a CTEs--
Select E.CodigoProduto, E.CodigoEstoque, E.Somatoria As Entrada, S.Somatoria As Saida,
		(E.Somatoria - S.Somatoria) As Saldo
From Entradas E Inner Join Saidas S
				On E.CodigoProduto = S.CodigoProduto
				And E.CodigoEstoque = S.CodigoEstoque
Go