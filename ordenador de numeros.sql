create database ordNumeros
go

use ordNumeros
go

create table numerosSorteados
(codigoNumeroSorteado int identity(1,1) primary key not null,
 numeroSorteado int not null
)
go

-- desativando o numero nas linhas
set nocount on
go

--limpando a tabela
truncate table numerosSorteados
go

--criando a função para selecionar uma quantia aleatoria de numeros aleatorios e adicionando na tabela caso não seja repetido
declare @contador int, @valor int, @quantidadeNumeros int

set @contador = 1
set @valor = 0
set @quantidadeNumeros = rand()*10000

while @contador <= @quantidadeNumeros
	begin
	set @valor = rand()*@quantidadeNumeros
	
	if Not Exists (select numeroSorteado from numerosSorteados
				where numeroSorteado = @valor)
		begin
			insert into numerosSorteados values (@valor)
			print @valor
			set @contador = @contador + 1
		end
			set @valor = rand()*@quantidadeNumeros
	end
	Print 'Números sorteados ' + convert(varchar(5), @quantidadeNumeros)
go

select numeroSorteado from numerosSorteados
order by numeroSorteado Asc
go

select numeroSorteado from numerosSorteados
order by numeroSorteado Desc
go