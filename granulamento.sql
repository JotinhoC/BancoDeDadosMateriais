-- Apresentando a Data e Hora Atual -- Para criação de níveis de Hierarquia --
Select GetDate()
Go


-- Exemplo 1 - Utilizando o Operador Union All --
Select '1 ->' As Nivel, Year(GetDate()) As Valor, 'Ano' As 'Descrição do Nível'
Union All
Select '2 -->', DatePart(q, GetDate()), 'Quartil'
Union All
Select '3 --->', Month(GetDate()) As Mes, 'Mês'
Union All
Select '4 ---->', Day(GetDate()) As Dia, 'Dia'
Union All
Select '5 ----->', DatePart(HH,GetDate()), 'Horas'
Union All
Select '6 ------>', DatePart(Minute,GetDate()), 'Minutos'
Union All
Select '7 ------->', DatePart(SS, GetDate()), 'Segundos'
Union All
Select '8 -------->', DatePart(MILLISECOND, GetDate()), 'Miléssimos'
Go