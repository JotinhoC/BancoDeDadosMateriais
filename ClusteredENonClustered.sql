-- Criando o Banco de Dados -- 
Create Database Indices
Go

-- Acessando --
Use Indices
Go

-- Criando uma Heap Table --
Create Table HeapTableAlunos
 (CodigoAluno Int,
 NomeAluno Varchar(20),
 DataAluno Date)
Go

-- Inserindo os dados na Tablea HeapTableAlunos --
Insert Into HeapTableAlunos (CodigoAluno, NomeAluno, DataAluno)
Values (1,'Aluno 1', GetDate()), (2, 'Aluno 2', GetDate()+1),
	   (3,'Aluno 3', GetDate()+2), (4,'Aluno 4',GetDate()+3), (5,'Aluno 5',GetDate()+4)
Go

-- Desativando a Contagem de Linhas --
Set NoCount On
Go

-- Ativar o Plano de Execução antes de realizar Select - Teclando CTRL + M --
Select CodigoAluno, NomeAluno, DataAluno From HeapTableAlunos
Go

-- Alternando a coluna CodigoAluno para não aceitar valor Nulo --
Alter Table HeapTableAlunos
 Alter Column CodigoAluno Int Not Null
Go

-- Adicionando uma Primary Key na Tabela HHeapTableAlunos --
Alter Table HeapTableAlunos
 Add Constraint PK_Codigo_HeapTableAlunos Primary Key Clustered (CodigoAluno)
Go

-- Testando o uso da chave primária --
Select NomeAluno, DataAluno From HeapTableAlunos
Where CodigoAluno = 4
Go

-- Realizando a ordenação de valores --
Select NomeAluno, DataAluno From HeapTableAlunos
Order By DataAluno Desc
Go

--Criando um novo índice NonClustered na Tabela HeapTableAlunos --
Create NonClustered Index IND_NonCLustered_DataAluno
 On HeapTableAlunos (DataAluno)
Go

-- Simulando o uso do índice NonClustered --4
-- Exemplo 1 --
Select NomeAluno, DataAluno From HeapTableAlunos
Where DataAluno Between '2025-09-16' And '2025-09-18'
Go

-- Exemplo 2 --
Select DataAluno From HeapTableAlunos Where CodigoAluno = 1
Go

--Exemplo 3 -- Será utilizado o índice NonClustered --
Select DataAluno From HeapTableAlunos
Go

-- Exemplo 4 -- Será utilizado o índice NonClustered --
Select DataAluno From HeapTableAlunos
Where DataAluno = '2025-09-17'
Go

-- Exemplo 5 -- Forçando o uso do Index NonClustered --
Select CodigoAluno, NomeAluno, DataAluno
From HeapTableAlunos With (Index= IND_NonClustered_DataAluno)
Where DataAluno = '2025-09-17'
Go

-- Exemplo 6 -- Utilizando o Index NonClustered --
Select CodigoAluno, DataAluno From HeapTableAlunos
Where DataAluno >= '2025-09-17'
Order By DataAluno Desc
Go