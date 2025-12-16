create database funcoes
go

use funcoes
go

--criando as tabelas--

create table Marca
(MarcaCod int primary key identity(1,1),
 MarcaDesc varchar(100) not null)
go

create table Modelo
(ModeloCod int primary key identity(1,1),
 ModeloDesc varchar(100) not null)
go

create table Automovel
(AutoCod int primary key identity(1,1),
 MarcaCod int not null,
 ModeloCod int not null,
 AutoNome varchar(100) not null)
go

-- criando os relacionamentos --
alter table Automovel
 add constraint [FK_Automovel_Marca] foreign key (MarcaCod)
  references Marca(MarcaCod)
go

alter table Automovel
 add constraint [FK_Automovel_Modelo] foreign key (ModeloCod)
  references Modelo(ModeloCod)
go

-- realizando os inserts --
insert into Marca values ('Fiat'),('Ford'),('GM')
go

insert into Modelo values ('1.4'),('1.0'),('1.6')
go

insert into Automovel (MarcaCod, ModeloCod, AutoNome)
values (1,1,'Palio'), (1,2,'Fiat 147'), (2,3,'Fiesta'), (3,1,'Onix LT'), (3,2,'Cruze'), (2,1,'Ka')
go

-- brincando com as funções --
-- utilizando a função Count() para contar a quantidade de carros --
select Count(AutoCod) as Quantidade from Automovel
go

-- Utilizando a Função AVG() para cálcular a média da potência dos modelos --
select AVG(Convert(float,ModeloDesc)) as 'Média da Potência' from Modelo
go 

-- arredondando o valor
select Round(AVG(Convert(float,ModeloDesc)),2) as 'Média da Potência' from Modelo
go

-- utilizando as Funções Min() para obter o menor e Max() para obter o maior valor --
select Min(Convert(Float,ModeloDesc)) As MenorPotencia,
	   Max(Convert(Float,ModeloDesc)) As MaiorPotencia
from Modelo
go

-- estabelecendo a junção entre as tabelas Marcas e Automovel --
select M.MarcaDesc,A.AutoCod, A.AutoNome
from Marca M inner join Automovel A
		On M.MarcaCod = A.MarcaCod
go

-- contando a quantidade de carros por marca --
Select Count(MarcaCod) As Quantidade, MarcaCod From Automovel
group by MarcaCod
go

-- Melhorando o código --
Select Count(A.MarcaCod) As Quantidade, M.MarcaDesc
From Marca M Inner Join Automovel A
		On M.MarcaCod = A.MarcaCod
Group By M.MarcaDesc
go

-- criando as tabelas temporárias - #produtos e #vendas --
create table #Produtos
(Codigo int primary key identity(1,1) not null,
 DescricaoProdutos varchar(50) not null,
 DescricaoCategoria varchar(50) not null,
 Preco numeric(18,2) not null)
go

create table #Vendas
(Codigo int identity(1,1) not null primary key,
 DataVenda DateTime not null,
 CodigoProduto int not null)
go

insert into #Produtos (DescricaoProdutos, DescricaoCategoria, Preco)
values
	('Processador i7', 'Tecnologia', 1500.00),
	('Processador i5', 'Tecnologia', 1000.00),
	('Processador i3', 'Tecnologia', 500.00),
	('Celular Sony', 'Smart Phone', 4200.00),
	('Cadeira', 'Utilidades do Lar', 200.00)
go

-- Inserindo 1000 registros lógicos pseudoaleatórios na tabela de #vendas --
Declare @Contador int, @CodigoProduto int

-- Atrinuindo o valor inicial para vaiável
Set @Contador = 1

--Iniciando o loop de execução --

While @Contador <= 1000
 Begin
  --selecionando o produto de forma pseudoaleatória com base na função NewID() --
	Set @CodigoProduto = (select top 1 Codigo From #Produtos Order By NEWID())

	insert into #Vendas (CodigoProduto,DataVenda)
	values (@CodigoProduto, GetDate()+@CodigoProduto+@Contador)

	Set @Contador += 1-- operador composto, devemos tomar cuidado, ele pode ser um pouco mais lento --
 End
go

-- Consultando a tabela de #Vendas --
select Codigo, DataVenda, CodigoProduto From #Vendas
go

-- realizando a sumarização de valores através de agrupamentos, exibindo totais --
select P.DescricaoCategoria, P.DescricaoProdutos
from #Vendas V inner join #Produtos P
		on V.CodigoProduto = P.Codigo
go

--melhorando--
select P.DescricaoCategoria, P.DescricaoProdutos,
	   Count(V.Codigo) As QuantidadeDeVendas,
	   Sum(P.Preco) As ValorTotal
from #Vendas V inner join #Produtos P
		on V.CodigoProduto = P.Codigo
group By Rollup(P.DescricaoCategoria, P.DescricaoProdutos)
go

--tratando os valores nulos --
select IsNull(P.DescricaoCategoria, 'Total') As 'Categoria', 
	   IsNull(P.DescricaoProdutos, 'SubTotal') As 'Produto',
	   Count(V.Codigo) As QuantidadeDeVendas,
	   Format(Sum(P.Preco),'C','PT-BR') As ValorTotal
from #Vendas V inner join #Produtos P
		on V.CodigoProduto = P.Codigo
group By Rollup(P.DescricaoCategoria, P.DescricaoProdutos)
go

--realizando a sumarização de valores através dos agrupamentos, apresentando totais gerais
select IsNull(Convert(varchar(10), Month(V.DataVenda)), 'Total') As MesVenda,
	   IsNull(P.DescricaoCategoria, 'Subtotal') As DescricaoCategoria,
	   Count(V.Codigo) As QuantidadeVendas,
	   Format(Sum(P.Preco),'C','PT-BR') As ValorTotal
from #Vendas V inner join #Produtos P
		On V.CodigoProduto = P.Codigo
Group by cube(Month(V.DataVenda), P.DescricaoCategoria)
go