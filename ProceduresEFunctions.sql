Create Database ProceduresBanco
Go

Use ProceduresBanco
Go

--Criando minha primeira Stored Procedure --
Create Procedure P_HelloWorld
As
Begin
 Set NoCount On

 Select 'Hello World...'+ SYSTEM_USER

End
Go

--Executando a Stored Procedure P_HelloWorld --
Execute P_HelloWorld
Go

Exec P_HelloWorld
Go

--Visualizando o código fonte da Stored Procedure --
SP_HelpText 'P_HelloWorld'
Go

--Outra maneira --
Select Object_Definition(Object_Id('P_HelloWorld'))
Go

--Alterando a Stored Procedure P_HelloWorld --
Alter Procedure P_HelloWorld @NomeUsuario Varchar(20)
As
Begin
 Set NoCount On

 Select 'Hello World...'+@NomeUsuario As 'Mensagem'

End
Go

--Executando --
Exec P_HelloWorld 'Pedro Galvão'
Go

Execute P_HelloWorld 'Chico'
Go

--Criando a Stored Procedure P_Calculadora --
Create Procedure P_Calculadora (@Valor1 Int=1, @Valor2 Int=1, @Operador Char(1))
As
Begin
 Set NoCount On -- Desativano a contagem e apresentação de linhas --

 Declare @Resultado Int

 If (@Valor1 <> 0 And @Valor2 <> 0)
 Begin
  If @Operador = '+'
   Set @Resultado = @Valor1 + @Valor2

  If @Operador = '-'
   Set @Resultado = @Valor1 - @Valor2
  
  If @Operador = '*'
   Set @Resultado = @Valor1 * @Valor2

  If @Operador = '/'
   Set @Resultado = @Valor1 / @Valor2 
  End


  Select Concat('O Resultado obtido é:', @Resultado)
  End
Go

-- Executando --
Exec P_Calculadora 20,12,'/'
Go


--Criando a Tabela Temporária
Create Table #Exemplo
 (Codigo Int Identity(1,1),
 Data DateTime)
 Go

 --Inserindo os dados --
 Insert Into #Exemplo Values(GetDate())
 Insert Into #Exemplo Values(GetDate()+1)
 Insert Into #Exemplo Values(GetDate()+2)
 Go

--Consultando--
Select Codigo, Data From #Exemplo
Go

--Criando a Stored Procedure P_PesquisarDatas --
Create Procedure P_PesquisarDatas (@Codigo Int, @Data DateTime)
As
Begin
Set NoCount On
Set @Data=(Select Case When
						@Data Is Null Then GetDate()
						Else @Data
					End)
Select Codigo, Data From #Exemplo
Where Codigo = @Codigo
And Data = @Data
End
Go

--Executando, não informando a Data
Exec P_PesquisarDatas 1, '25-11-2025 20:16:25.363'
Go

--Alterando o Codigo Fonte da Stored Procedure P_PesquisarDatas --
Alter Procedure P_PesquisarDatas (@Codigo Int, @Data DateTime)
As
Begin
Set NoCount On
Set @Data=(Select Case When
						@Data Is Null Then GetDate()
						Else @Data
					End)
Select Codigo, Data From #Exemplo
Where Codigo = @Codigo
And Convert(Date,Data)= @Data
End
Go

--Executando
Exec P_PesquisarDatas 1, '25/11/2025'
Go


--User Defined Functions--


--Criando a Function F_CalcularAreaDoTriangulo--
Create Function F_CalcularAreaDoTriangulo(@Base SmallInt, @Altura SmallInt)
Returns Int
As
Begin

Declare @Area Int
Set @Area = (@Base * @Altura)/2

Return @Area

End
Go

--Executando --
Select dbo.F_CalcularAreaDoTriangulo(10,20)
Go

--Alterando o codigo fonte da Function F_CalcularAreaDoTriangulo--
Alter Function F_CalcularAreaDoTriangulo(@Base SmallInt, @Altura SmallInt)
Returns Int
As
Begin

Return (@Base * @Altura)/2

End
Go

--Executando --
Select dbo.F_CalcularAreaDoTriangulo(6,3) As 'Área'
Go

--VIsualizando o código--
Exec sp_helptext 'F_CalcularAreaDoTriangulo'
go

--Criando a Função F_SubstituirNumerosPorLetras--
Create Function F_SubstituirNumerosPorLetras (@Frase Varchar(500))
Returns Varchar(500)
Begin
 Declare @Inicio Int
 Set @Inicio = PatIndex('%(0-9)%', @Frase)

 While @Inicio > 0
 Begin

  Set @Inicio = PatIndex('%(0-9)%', @Frase)
  If @Inicio > 0

   Set @Frase = Replace(@Frase, Substring(@Frase, @Inicio, 1),'X')
  Else
   Break
  End

  Return @Frase
 End
Go

--Executando--
Select dbo.F_SubstituirNumerosPorLetras('1231241')
Go

--Criando a Function F_ConverterInteiroParaBinario --
Create Function F_ConverterInteiroParaBinario(@ValorInteiro Int)
Returns Varchar(255)
As
Begin
 Declare @ValorResultado Varchar(255), @Contador Int
 Set @Contador = 255
 Set @ValorResultado = ''

 While @Contador > 0
 
 Begin
 Set @ValorResultado = Convert(Char(1), @ValorInteiro %2) + @ValorResultado
 
 Set @ValorInteiro = Convert(TinyInt, (@ValorInteiro/2))
 
 Set @Contador = @Contador - 1
 
 End
 
 Return(Select Right(@ValorResultado,8) As 'Binário')
End
Go

--Executando--

Select dbo.F_ConverterInteiroParaBinario(192) As 'Primeiro Octeto',
	   dbo.F_ConverterInteiroParaBinario(168) As 'Segundo Octeto',
	   dbo.F_ConverterInteiroParaBinario(100) As 'Terceiro Octeto', 
	   dbo.F_ConverterInteiroParaBinario(1) As 'Quarto Octeto'
Go