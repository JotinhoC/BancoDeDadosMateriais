--Alterando o idioma de apresentação--
Set Language Portuguese
Go

--Diretiva--
Set ArithAbort On -- Aborte a execução e apresente erros matemáticos
Set Ansi_Warnings On -- Exiba alertas ou warnings --
Go

Set ArithAbort Off 
Set Ansi_Warnings Off 
Go

--Desativando a contagem de linhas manipuladas --
Set NoCount On
Go

Begin Try -- Abertura do bloco de código protegido contra erros --

Print 1/0

End Try
Begin Catch --Abertura do bloco de código para tratamento de erros --

Select 'Não é possivel dividir por zero...' As Mensagem,
		ERROR_LINE() As 'Número da Linha',
		ERROR_SEVERITY() As 'Nível de erro'

End Catch -- Fechamento do bloco de código para tratamento --
go