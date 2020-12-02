#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ INTRJ    ∫Autor  ≥Elielson Nascimento ∫ Data ≥29.08.2013   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫          ≥ Faz a integracao do chamado Rio de Janeiro atraves do      ∫±±
±±∫          ≥ imput dos dados pela filial Guarulhos, devido ao saldo     ∫±±
±±∫          ≥ de estoque. Gera o pedido aglutinado para transferencia    ∫±±
±±∫          ≥ com base no atendimentos integrados entre as filiais.      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫           Manutencao                                                  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Data:     ≥ Autor:                                                     ∫±±
±±∫          ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ OUROLUX                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function INTRJ()

// Processa( {|| U_INTRJProc() }, 'Aguarde, processando registros...' )

MsAguarde({|| U_INTRJProc() }, 'Integra Guarulhos x RJ...', "Aguarde, processando registros...", .T.)

Return

User Function INTRJProc()

Local aCabSUA	:= {}
Local aItemSUB	:= {}
Local aCabSC5	:= {}
Local aItemSC6	:= {}
Local aCabEst	:= {}
Local aItemEst	:= {}
Local aItemTMP	:= {}
Local aPedInteg	:= {}

Local cPerg		:= "INTRJ"
//Local nItem		:= 0
Local cItem     := "00"
Local cNumF01	:= ""
Local cNumInt1	:= ""
Local cNumInt2	:= ""
Local lItem     := .T.

Local cTMKRJCL	:= SubStr(AllTrim(GetMV("FS_TMKRJCL")),1,6)	//Cliente Padr„o
Local cTMKRJLJ	:= SubStr(AllTrim(GetMV("FS_TMKRJCL")),8,2)	//Loja Padr„o
Local cTMKRJCP	:= SubStr(AllTrim(GetMV("FS_TMKRJCP")),1,3)	//CondiÁ„o de Pagamento Padr„o
Local cTMKRJTB	:= SubStr(AllTrim(GetMV("FS_TMKRJTB")),1,3)	//Tabela de PreÁos Padr„o
Local cTMKRJTS	:= SubStr(AllTrim(GetMV("FS_TMKRJTS")),1,3)	//Tes de SaÌda Padr„o
Local cTMKRJTI	:= SubStr(AllTrim(GetMV("FS_TMKRJTI")),1,3)	//Tes de SaÌda Padr„o
Local cTMKRJFP	:= SubStr(AllTrim(GetMV("FS_TMKRJFP")),1,6)	//Forma de Pagamento Padr„o
Local cTMKRJTE	:= SubStr(AllTrim(GetMV("FS_TMKRJTE")),1,1)	//Tipo de entrada Padr„o
Local cTMKRJTR	:= SubStr(AllTrim(GetMV("FS_TMKRJTR")),1,6)	//Transportadora Padr„o
Local cTMKRJTF	:= SubStr(AllTrim(GetMV("FS_TMKRJTF")),1,1)	//Tipo de Frete Padr„o
Local cTMKRJLC	:= SubStr(AllTrim(GetMV("FS_TMKRJLC")),1,2)	//Local Padr„o
Local cVDTRANS	:= SubStr(AllTrim(GetMV("FS_VDTRANS")),1,6)	//Vendedor Padr„o para Transferencia
Local _lSldIni  := .T. // Variavel para controle de inclusao de saldo zerado na SB9. Claudino 04/09/13.
Local cTabtrrj  := ''
Local cDatAte   := ''
Local cCli      := '008360'
Local cLoj      := '04'
Local nPrcTab   := 0
LOCAL cFim		:= chr (13) + chr (10)
Local aPedLog	:= {}
Local cCODSYP   := ""
Local _cObs     := ""
Local _aSYP     := {}

Private cLOG 	:= ""

If cFilAnt == "01"
	
	If Pergunte(cPerg,.T.)
		
		cTRANSP	:= MV_PAR03
		
		// Claudino - 04/01/16 - Inicio
		If Empty(cTRANSP)
			ApMsgStop("Favor informar a Transportadora!","INTRJ")
			Return()
		Else
			If !ExistCpo("SA4",cTRANSP)
				ApMsgStop("Transportadora informada n„o esta cadastrada!","INTRJ")
				Return()
			Else
				dbSelectArea("SA4")
				SA4->(dbSetOrder(1))
				If DbSeek(xFilial("SA4")+cTRANSP) .And. SA4->A4_MSBLQL == "1"
					ApMsgStop("Transportadora Bloqueada!","INTRJ")
					Return()
				EndIf
			EndIf
		EndIf
		// Claudino - 04/01/16 - Fim
		
		If Select("TRC") > 0
			dbSelectArea("TRC")
			dbCloseArea("TRC")
		EndIf
		
		If Empty(cTMKRJCL)
			Alert("Cliente padr„o para transferÍncia n„o informado. Verifique o par‚metro FS_TMKRJCL. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJLJ)
			Alert("Loja do Cliente padr„o para transferÍncia n„o informada. Verifique o par‚metro FS_TMKRJCL. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJCP)
			Alert("CondiÁ„o de Pagamento padr„o para transferÍncia n„o informada. Verifique o par‚metro FS_TMKRJCP. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJTB)
			Alert("Tabela de PreÁos padr„o para transferÍncia n„o informada. Verifique o par‚metro FS_TMKRJTB. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJTS)
			Alert("TES padr„o para transferÍncia n„o informado. Verifique o par‚metro FS_TMKRJTS. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJFP)
			Alert("Forma de Pagamento padr„o para transferÍncia n„o informada. Verifique o par‚metro FS_TMKRJFP. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJTE)
			Alert("Tipo de Entrada padr„o para transferÍncia n„o informado. Verifique o par‚metro FS_TMKRJTE. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJTR)
			Alert("Transportadora padr„o para transferÍncia n„o informada. Verifique o par‚metro FS_TMKRJTR. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJTF)
			Alert("Tipo de Frete padr„o para transferÍncia n„o informado. Verifique o par‚metro FS_TMKRJTF. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		If Empty(cTMKRJLC)
			Alert("Local padr„o para transferÍncia n„o informado. Verifique o par‚metro FS_TMKRJLC. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		
		If Empty(cVDTRANS)
			Alert("Vendedor Padr„o n„o cadastrado, por favor informar. IntegraÁ„o n„o realizada. Informe ao TI.")
			Return()
		EndIf
		
		// TABELA DE TRANSFER
		
		cTabtrrj := GetAdvFVal("SA1","A1_TABELA",xFilial("SA1")+cTMKRJCL+cTMKRJLJ,1,"")
		
		If !Empty(cTabtrrj)
			
			cTabtrrj := GetAdvFVal("DA0","DA0_CODTAB",xFilial("DA0")+AllTrim(cTabtrrj),1,"")
			
			If Empty(cTabtrrj) .Or. cTabtrrj <> cTMKRJTB
				
				Alert("Favor cadastrar a tabela" + cTMKRJTB + "na filial RJ.")
				Return()
				
			EndIf
			
		EndIf
		
		/*
		If !Empty(cTMKRJTB)
		
		cDatAte := GetAdvFVal("DA0","DA0_DATATE",xFilial("DA0")+AllTrim(cTMKRJTB),1,"")
		
		If Dtos(DA0->DA0_DATATE) <= Dtos(dDataBase).AND. !Empty(Dtos(DA0->DA0_DATATE))
		ApMsgStop( 'Tabela de preco' + AllTrim(cTMKRJTB) + ' esta inativa!', 'INTRJ' )
		Return()
		EndIf
		
		EndIf
		*/
		
		//cQuery := " SELECT * "																					+CHR(13)+CHR(10)
		
		cQuery := " SELECT  C5_NUM,C5_TIPO,C5_CLIENTE,C5_LOJACLI,C5_CONDPAG,C5_TABELA,C6_TES,C6_PRODUTO,C6_PEDCLI,C9_QTDLIB" + CHR(13)+CHR(10)
		cQuery += " FROM " + RetSqlName("SC5") + " AS SC5 "														+CHR(13)+CHR(10)
		cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON (C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM  AND C6_CLI = C5_CLIENTE AND C6_LOJA = C5_LOJACLI AND SC6.D_E_L_E_T_ <> '*') "												+CHR(13)+CHR(10)
		cQuery += " INNER JOIN " + RetSqlName("SC9") + " SC9 ON (C9_FILIAL = C5_FILIAL AND C9_PEDIDO = C5_NUM AND C9_CLIENTE = C5_CLIENTE AND C9_LOJA = C5_LOJACLI AND C9_PRODUTO = C6_PRODUTO AND SC9.D_E_L_E_T_ <> '*') "			+CHR(13)+CHR(10)
		cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON (A1_FILIAL = A1_FILIAL AND A1_COD = C5_CLIENTE  AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ <> '*') "																	+CHR(13)+CHR(10)
		cQuery += " WHERE C5_FILIAL = '01' "																	+CHR(13)+CHR(10)
		cQuery += " AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) +  "' AND '" + DtoS(MV_PAR02) + "' "				+CHR(13)+CHR(10)
		cQuery += " AND A1_EST = 'RJ' "																			+CHR(13)+CHR(10)
		cQuery += " AND C5_XNUMTRF = '' "																		+CHR(13)+CHR(10)
		cQuery += " AND C6_PEDCLI <> ''"																		+CHR(13)+CHR(10)
		cQuery += " AND C9_BLEST = '' "																			+CHR(13)+CHR(10)
		cQuery += " AND C9_BLCRED = '' "																		+CHR(13)+CHR(10)
		cQuery += " AND SC5.D_E_L_E_T_ <> '*' "																	+CHR(13)+CHR(10)
		cQuery += " ORDER BY C6_PEDCLI, C6_NUM, C6_ITEM "														+CHR(13)+CHR(10)
		
		TCQUERY cQuery NEW ALIAS "TRC"
		
		_cPed	:=""
		
		cLOG += "lista de Pedidos Liberados no Processamento"
		cLOG += cFim
		cLOG += ""
		cLOG += cFim
		
		dbSelectArea("TRC")
		dbGoTop()
		While !Eof()
			cPEDCLI	:= TRC->C6_PEDCLI
			cNUM	:= TRC->C5_NUM
			cLOG +=  "Item "+ALLTRIM(TRC->C6_PRODUTO)+" - Quant: "+TRANSFORM(TRC->C9_QTDLIB,"@E 999,999.99")+ " do Pedido: "+cNUM+" do Atendimento: "+cPEDCLI
			cLOG += cFim
			dbskip()
		END
		
		cLOG += "------------------------------------------"
		cLOG += cFim
		cLOG += ""
		cLOG += cFim
		
		dbSelectArea("TRC")
		dbGoTop()
		While !Eof()
			
			lTabelaSUA	:= .T.
			lTeste		:= .F.
			
			If SubStr(TRC->C6_PEDCLI,4,6) != _cPed
				
				_cPed := SubStr(TRC->C6_PEDCLI,4,6)
				
				dbSelectArea("SUA")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFILIAL("SUA")+SubStr(TRC->C6_PEDCLI,4,6))
					
					dbSelectArea("DA0")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek(xFILIAL("DA0")+SUA->UA_TABELA)
						
						If DA0->DA0_ATIVO != "1" .Or. DA0->DA0_DATDE > dDataBase .Or. IIf(Empty(DA0->DA0_DATATE),.F.,DA0->DA0_DATATE < dDataBase)
							
							Alert("Tabela de PreÁo "+AllTrim(SUA->UA_TABELA)+" do Atendimento indisponÌvel.")
							// erro na tabela de preÁo 1
							cLOG += "Pedido: "+TRC->C5_NUM+" do Atendimento: "+TRC->C6_PEDCLI+" tem tabela de preÁo indisponivel. Pedido n„o processado"
							cLOG += cFim
							
							// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
							
						Else
							
							dbSelectArea("DA0")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek(xFILIAL("DA0")+Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_TABELA"))
								
								If DA0->DA0_ATIVO != "1" .Or. DA0->DA0_DATDE > dDataBase .Or. IIf(Empty(DA0->DA0_DATATE),.F.,DA0->DA0_DATATE < dDataBase)
									
									Alert("Tabela de PreÁo "+AllTrim(Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE,"A1_TABELA"))+" do Cadastro do Cliente indisponÌvel.")
									// erro na tabela de preÁo 2
									cLOG += "Pedido: "+TRC->C5_NUM+" do Atendimento: "+TRC->C6_PEDCLI+" tem tabela de preÁo do Cliente indisponivel. Pedido n„o processado"
									cLOG += cFim
									
									// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
									
								Else
									
									dbSelectArea("SUA")
									
									cCODSYP := ""
									_cObs := ""
									_aSYP := {}
									
									_aSYP := IntRjMem(SUA->UA_CODOBS,1000)
									If Len(_aSYP) > 0
										For nI := 1 To Len(_aSYP)
											_cObs += _aSYP[nI]
										Next nI
									Endif
									
									If !Empty(_cObs)
										cCODSYP	:= GetSxeNum("SYP","YP_CHAVE")
									EndIf
									
									// por Icaro Queiroz em 11/Fev/2015 - adicionado o campo UA_TESINT
									
									// Claudino - 04/01/16 - AlteraÁ„o Transportadora Execauto
									//{"UA_TRANSP"	,UA_TRANSP			,NIL},;  // Como Estava
									//{"UA_TRANSP"	,AllTrim(cTRANSP)	,NIL},;  // Como Ficou
									
									aCabSUA	:=	{	{"UA_CLIENTE"	,UA_CLIENTE			,NIL},;
									{"UA_LOJA"		,UA_LOJA			,NIL},;
									{"UA_FORMPAG"	,UA_FORMPAG			,NIL},;
									{"UA_CONDPG"	,UA_CONDPG			,NIL},;
									{"UA_TIPOENT"	,UA_TIPOENT			,NIL},;
									{"UA_TRANSP"	,AllTrim(cTRANSP)	,NIL},;
									{"UA_OPER"		,UA_OPER			,NIL},;
									{"UA_TMK"		,UA_TMK				,NIL},;
									{"UA_OBS"	    ,_cObs			    ,NIL},;
									{"UA_CODOBS"	,cCODSYP			,NIL},;
									{"UA_TABELA"	,UA_TABELA			,NIL},;
									{"UA_TPFRETE"	,UA_TPFRETE			,NIL},;
									{"UA_FIM"		,UA_FIM				,NIL},;
									{"UA_INICIO"	,UA_INICIO			,NIL},;
									{"UA_OPERADO"	,UA_OPERADO			,NIL},;
									{"UA_VEND"		,UA_VEND			,NIL},;
									{"UA_MOEDA"		,UA_MOEDA			,NIL},;
									{"UA_FRETE"		,UA_FRETE			,NIL},;
									{"UA_DESCONT"	,UA_DESCONT			,NIL},;
									{"UA_DESPESA"	,UA_DESPESA			,NIL},;
									{"UA_PROSPEC"	,UA_PROSPEC			,NIL},;
									{"UA_CODCONT"	,UA_CODCONT			,NIL},;
									{"UA_DESCNT"	,UA_DESCNT			,NIL},;
									{"UA_DTLIM"		,UA_DTLIM			,NIL},;
									{"UA_XPEDREP"	,UA_XPEDREP			,NIL},;
									{"UA_ENDCOB"	,UA_ENDCOB			,NIL},;
									{"UA_ENDENT"	,UA_ENDENT			,NIL},;
									{"UA_BAIRROC"	,UA_BAIRROC			,NIL},;
									{"UA_BAIRROE"	,UA_BAIRROE			,NIL},;
									{"UA_ESTC"		,UA_ESTC			,NIL},;
									{"UA_MUNE"		,UA_MUNE			,NIL},;
									{"UA_MUNC"		,UA_MUNC			,NIL},;
									{"UA_ESTE"		,UA_ESTE			,NIL},;
									{"UA_CEPC"		,UA_CEPC			,NIL},;
									{"UA_CEPE"		,UA_CEPE			,NIL},;
									{"UA_XNUMF01"	,UA_NUM				,NIL},;
									{"UA_TIPO"		,UA_TIPO			,NIL},;
									{"UA_TESINT"	,UA_TESINT			,NIL}}
									
									cCODSYP := ""
									_cObs := ""
									_aSYP := {}
									
									dbSelectArea("SUB")
									dbSetOrder(1)
									dbGoTop()
									dbSeek(xFILIAL("SUB")+SUA->UA_NUM)
									lTES := .T.
									While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM == xFILIAL("SUB")+SUA->UA_NUM
										
										// VALIDA«√O DA TABELA DE PRE«OS DE TRANSFERENCIA
										
										DBSELECTAREA("DA1")
										DBSETORDER(1)
										DBGOTOP()
										IF !DBSEEK(XFILIAL("DA1")+cTMKRJTB+SUB->UB_PRODUTO)
											cLOG += "Produto: "+ALLTRIM(SUB->UB_PRODUTO)+" do Atendimento: "+SUB->UB_NUM+" n„o esta cadastrado na tabela de transferencia"
											cLOG += cFim
											lTES := .F.
											
											// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
											
											EXIT
										ENDIF
																				
										// FIM DA VALIDA«√O DA TABELA DE PRE«OS DE TRANSFERENCIA
										
										// TES INTELIGENTE
										//CALCSZT(cMOD,cProduto,cCliente,cLoja,cOperSZT)
										
										// INICIO | por Icaro Queiroz em 11/Fev/2015
										xFilAnt	:= cFilAnt
										xNumEmp	:= cNumEmp
										
										cFilAnt	:= "04"
										cNumEmp	:= cEmpAnt+cFilAnt
										
										dbSelectArea("SM0")
										If Select( "SM0" ) > 0
											SM0->( dbCloseArea() )
										EndIf
										OpenSM0(cEmpAnt+cFilAnt)
										
										//cTES04	:= u__MEGAM020(SUB->UB_PRODUTO,"N",SUA->UA_CLIENTE,SUA->UA_LOJA,cTMKRJTS)
										//cTES04	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,TRC->C5_TESINT)
										cTES04	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_TESINT)	// por Icaro Queiroz em 11/Fev/2015
										
										cFilAnt	:= xFilAnt
										cNumEmp	:= cEmpAnt+cFilAnt
										
										dbSelectArea("SM0")
										If Select( "SM0" ) > 0
											SM0->( dbCloseArea() )
										EndIf
										OpenSM0(cEmpAnt+cFilAnt)
										// FINAL | por Icaro Queiroz em 11/Fev/2015
										
										//cTES	:= Iif(Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_IPI")>0,cTMKRJTI,cTMKRJTS)
										//cTES	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,TRC->C5_TESINT)
										//¡cTES	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_TESINT) // por Icaro Queiroz em 11/Fev/2015
										cTES	:= u_CALCSZT("AUT",SUB->UB_PRODUTO, cTMKRJCL, cTMKRJLJ,"05"/*SUA->UA_TESINT*/) // por Icaro Queiroz em 11/Fev/2015 > Romera 20/02 - deve considerar operaÁ„o transferencia
										
										IF EMPTY(cTES04) .OR. EMPTY(cTES)
											cLOG += "Pedido: "+TRC->C5_NUM+" do Atendimento: "+TRC->C6_PEDCLI+" tem produto sem a TES localizada. Pedido n„o processado"
											cLOG += cFim
											lTES := .F.
											
											// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
											
											EXIT
										ENDIF
										
										dbSelectArea("SUB")
										dbSkip()
									EndDo
									
									IF lTES
										
										dbSelectArea("SUB")
										dbSetOrder(1)
										dbGoTop()
										dbSeek(xFILIAL("SUB")+SUA->UA_NUM)
										While !Eof() .And. SUB->UB_FILIAL+SUB->UB_NUM == xFILIAL("SUB")+SUA->UA_NUM
																			
											xFilAnt	:= cFilAnt
											xNumEmp	:= cNumEmp
											
											cFilAnt	:= "04"
											cNumEmp	:= cEmpAnt+cFilAnt
											
											dbSelectArea("SM0")
											If Select( "SM0" ) > 0
												SM0->( dbCloseArea() )
											EndIf
											OpenSM0(cEmpAnt+cFilAnt)
											
											// TES INTELIGENTE
											// cTES04	:= u__MEGAM020(SUB->UB_PRODUTO,"N",SUA->UA_CLIENTE,SUA->UA_LOJA,cTMKRJTS)
											//cTES04	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,TRC->C5_TESINT)
											cTES04	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,SUA->UA_TESINT) // por Icaro Queiroz em 11/Fev/2015
											
											_lSldIni := SaldIni(SUB->UB_PRODUTO) // SB9. Claudino 04/09/13.
											
											cFilAnt	:= xFilAnt
											cNumEmp	:= cEmpAnt+cFilAnt
											
											dbSelectArea("SM0")
											If Select( "SM0" ) > 0
												SM0->( dbCloseArea() )
											EndIf
											OpenSM0(cEmpAnt+cFilAnt)
											
											dbSelectArea("SUB")
											
											// Pedido de bonificaÁao: DigitaÁao do TES e manual
											/* wadih 11-02-2015
											// TES INTELIGENTE ELIMINAR
											If SUA->UA_XTPPED == '2'
											cTES04 := SUB->UB_TES
											EndIf
											// TES INTELIGENTE ELIMINAR
											*/
											aAdd(aItemSUB,{	{"UB_PRODUTO"	,UB_PRODUTO			,NIL},;
											{"UB_QUANT"		,UB_QUANT			,NIL},;
											{"UB_ITEM"		,UB_ITEM			,NIL},;
											{"UB_VRUNIT"	,UB_VRUNIT			,NIL},;
											{"UB_VLRITEM"	,UB_VLRITEM			,NIL},;
											{"UB_TES"		,cTES04				,NIL},;
											{"UB_LOCAL"		,"01"				,NIL},;
											{"UB_DTENTRE"	,UB_DTENTRE			,NIL},;
											{"UB_ITEMPC"	,UB_ITEMPC			,NIL},;
											{"UB_NUMPCOM"	,UB_NUMPCOM			,NIL},;
											{"UB_EMISSAO"	,UB_EMISSAO			,NIL}})
											
											// TES INTELIGENTE
											//cTES	:= Iif(Posicione("SB1",1,xFilial("SB1")+SUB->UB_PRODUTO,"B1_IPI")>0,cTMKRJTI,cTMKRJTS)
											//cTES	:= u_CALCSZT("AUT",SUB->UB_PRODUTO,SUA->UA_CLIENTE,SUA->UA_LOJA,TRC->C5_TESINT)
											cTES	:= u_CALCSZT("AUT",SUB->UB_PRODUTO, cTMKRJCL, cTMKRJLJ,"05"/*SUA->UA_TESINT*/) // por Icaro Queiroz em 11/Fev/2015 > Romera 20/02 - deve considerar operaÁ„o transferencia
											nPrcTab := GetAdvFVal("DA1","DA1_PRCVEN",xFilial("DA1")+SUB->UB_PRODUTO+cTMKRJTB,2,0)
											
											aAdd(aItemTMP,{	{"C6_PRODUTO"	,UB_PRODUTO			,NIL},;
											{"C6_QTDVEN"	,UB_QUANT			,NIL},;
											{"C6_ITEM"		,UB_ITEM			,NIL},;
											{"C6_PRCVEN"	,nPrcTab			,NIL},;
											{"C6_PRUNIT"	,nPrcTab			,NIL},;
											{"C6_TES"		,cTES				,NIL},;
											{"C6_LOCAL"		,"01"		 		,NIL},;
											{"C6_EMISSAO"	,UB_EMISSAO			,NIL}})
											
											aAdd(aItemEST,{	{"LINPOS"		,"C6_ITEM"			,SUB->UB_ITEM},;
											{"AUTDELETA"	,"N"				,Nil},;
											{"C6_FILIAL"	,SUB->UB_FILIAL		,Nil},;
											{"C6_NUM"		,SUA->UA_NUMSC5		,Nil},;
											{"C6_PRODUTO"	,SUB->UB_PRODUTO	,Nil},;
											{"C6_QTDVEN"	,SUB->UB_QUANT+1	,Nil},;
											{"C6_PRCVEN"	,SUB->UB_VRUNIT		,Nil},;
											{"C6_PRUNIT"	,SUB->UB_VRUNIT		,Nil},;
											{"C6_TES"		,TRC->C6_TES		,Nil},;
											{"C6_SERVIC"    ,"001" 				,Nil},;
											{"C6_ENDPAD"	,PADR("DOCA",15) 	,Nil},;
											{"C6_PEDCLI"	,TRC->C6_PEDCLI		,Nil}})
											
											
											dbSelectArea("SUB")
											dbSkip()
										EndDo
										
										aadd(aCabEst,{"C5_NUM"   	,TRC->C5_NUM		,Nil})
										aadd(aCabEst,{"C5_TIPO" 	,TRC->C5_TIPO		,Nil})
										aadd(aCabEst,{"C5_CLIENTE"	,TRC->C5_CLIENTE	,Nil})
										aadd(aCabEst,{"C5_LOJACLI"	,TRC->C5_LOJACLI	,Nil})
										aadd(aCabEst,{"C5_LOJAENT"	,TRC->C5_LOJACLI	,Nil})
										aadd(aCabEst,{"C5_CONDPAG"	,TRC->C5_CONDPAG	,Nil})
										aadd(aCabEst,{"C5_TABELA"	,TRC->C5_TABELA		,Nil})
										aadd(aCabEst,{"C5_TPFRETE"	,"C"				,Nil})
										aadd(aCabEst,{"C5_TIPOENT"	,cTMKRJTE			,Nil})
										aadd(aCabEst,{"C5_TPCARGA"	,"1"				,Nil})
										aadd(aCabEst,{"C5_GERAWMS"	,"2"				,Nil})
										
										cLOG += "Pedido: "+TRC->C5_NUM+" do Atendimento: TMK"+_cPed+" foi processado com sucesso!!"
										cLOG += cFim
										
										
									ENDIF
									
									// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
									
								EndIf			//DA0->DA0_ATIVO != "1" .Or. DA0->DA0_DATDE > dDataBase .Or. IIf(Empty(DA0->DA0_DATATE),.F.,DA0->DA0_DATATE < dDataBase)
								
							EndIf				//dbSeek(xFILIAL("SA1")+Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE,"A1_TABELA"))
							
							// LOBATO - PONTO DE ELIMINA«√O DE INTEGRA«√O
							
						EndIf					//DA0->DA0_ATIVO != "1" .Or. DA0->DA0_DATDE > dDataBase .Or. IIf(Empty(DA0->DA0_DATATE),.F.,DA0->DA0_DATATE < dDataBase)
						
					EndIf						//If dbSeek(xFILIAL("DA0")+SUA->UA_TABELA)
					
				EndIf							//If dbSeek(xFILIAL("SUA")+SubStr(TRC->C6_PEDCLI,4,6))
				
			EndIf								//If SubStr(TRC->C6_PEDCLI,4,6) != _cPed
			
			//	 TESTE LOBATO
			//			dbSelectArea("TRC")
			//			dbSkip()
			//			LOOP
						
			If Len(aItemSUB) > 0
				
				lMSHelpAuto := .T.
				lMsErroAuto := .F.
				
				xFilAnt	:= cFilAnt
				xNumEmp	:= cNumEmp
				
				cFilAnt	:= "04"
				cNumEmp	:= cEmpAnt+cFilAnt
				
				dbSelectArea("SM0")
				dbCloseArea()
				OpenSM0(cEmpAnt+cFilAnt)
				
				MSExecAuto({|x,y,z,w| tmka271(x,y,z,w)},aCabSUA,aItemSUB,3,"2")   //// GRAVA
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
					CONOUT("Integracao no RJ NAO REALIZADA.")
					cLOG += "Pedido: "+TRC->C5_NUM+" n„o foi integrado na Filial RJ !!"
					cLOG += cFim
					
				Else
					CONOUT("Integracao no RJ OK.")
					cLOG += "Pedido: "+TRC->C5_NUM+" integrado na Filial RJ com sucesso!!"
					cLOG += cFim
					
				Endif
				
				cFilAnt	:= xFilAnt
				cNumEmp	:= cEmpAnt+cFilAnt
				
				dbSelectArea("SM0")
				dbCloseArea()
				OpenSM0(cEmpAnt+cFilAnt)
				
				If Len(aItemTMP)> 0 .And. !lMsErroAuto
					
					For x:=1 to Len(aItemTMP)
						
						lItem	:= .T.
						
						If Len(aItemSC6) > 0
							
							For nI := 1 to Len(aItemSC6)
								If aItemSC6[nI][1][2] == aItemTMP[x][1][2]
									aItemSC6[nI][2][2] := aItemSC6[nI][2][2] + aItemTMP[x][2][2]
									lItem	:= .F.
								EndIf
							Next
							
						EndIf
						
						If lItem
							
							cItem := Soma1(AllTrim(cItem),2)
							
							aAdd(aItemSC6,{	{"C6_PRODUTO"	,aItemTMP[x][1][2]	,NIL},;
							{"C6_QTDVEN"	,aItemTMP[x][2][2]	,NIL},;
							{"C6_ITEM"		,cItem				,NIL},;
							{"C6_PRCVEN"	,aItemTMP[x][4][2]	,NIL},;
							{"C6_PRUNIT"	,aItemTMP[x][5][2]	,NIL},;
							{"C6_TES"		,aItemTMP[x][6][2]	,NIL},;
							{"C6_LOCAL"		,aItemTMP[x][7][2]	,NIL},;
							{"C6_EMISSAO"	,aItemTMP[x][8][2]	,NIL},;
							{"C6_SERVIC"	,"001"				,NIL},;
							{"C6_ENDPAD"	,"DOCA"				,NIL}})
							
						EndIf
						
					Next
					
					aItemTMP	:= {}
					
				EndIf
				
				If Len(aItemEst)> 0 .And. !lMsErroAuto
					
					dbSelectArea("SC5")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek(xFILIAL("SC5")+aCabEst[1][2])
						MATA410(aCabEst,aItemEst,4)
						If lMsErroAuto
							MostraErro()
							DisarmTransaction()
							CONOUT("Estorno Liberacao NAO REALIZADA.")
							cLOG += "Pedido: "+TRC->C5_NUM+" n„o foi estornado na Filial SP!!"
							cLOG += cFim
						Else
							
							aadd(aPedInteg,{aCabEst[1][2]})
							
							For nI := 1 to Len(aItemEst)
								dbSelectArea("SC6")
								dbSetOrder(2)
								dbGoTop()
								If dbSeek(xFILIAL("SC6")+aItemEst[nI][5][2]+aItemEst[nI][4][2])
									SC6->(RecLock( "SC6", .F. ))
									SC6->C6_QTDEMP	:= 0
									SC6->(MsUnLock())
								EndIf
							Next
							CONOUT("Estorno Liberacao OK.")
							cLOG += "Pedido: "+TRC->C5_NUM+" estornado na Filial SP com sucesso!!"
							cLOG += cFim
							
							aadd(aPedLog,trc->c5_num)
							
						Endif
					EndIf
					
				EndIf
				
				aCabSUA		:= {}
				aItemSUB	:= {}
				aCabEst		:= {}
				aItemEst	:= {}
				aItemTMP	:= {}
				
			EndIf
			
			dbSelectArea("TRC")
			dbSkip()
		EndDo
		
		If Len(aItemSC6) > 0
						
			cNumPed	:=	GetSxeNum("SC5","C5_NUM")
			
			aCabSC5 :=	{	{"C5_NUM"		,cNumPed			,NIL},;
			{"C5_TIPO"     	,"N"   				,Nil},;
			{"C5_CLIENTE"  	,cTMKRJCL			,Nil},;
			{"C5_LOJACLI"  	,cTMKRJLJ			,Nil},;
			{"C5_CLIENT"  	,cTMKRJCL		 	,Nil},;
			{"C5_LOJAENT"  	,cTMKRJLJ			,Nil},;
			{"C5_TRANSP"	,AllTrim(cTRANSP)	,Nil},;
			{"C5_TIPOCLI"	,"S"				,Nil},;
			{"C5_CONDPAG"	,cTMKRJCP			,Nil},;
			{"C5_TIPOENT"	,cTMKRJTE			,Nil},;
			{"C5_FORMPAG"	,cTMKRJFP			,NIL},;
			{"C5_VEND1"		,cVDTRANS			,NIL},;
			{"C5_TABELA"	,cTMKRJTB			,Nil},;
			{"C5_EMISSAO"  	,dDataBase			,Nil},;
			{"C5_TPFRETE"  	,cTMKRJTF			,Nil},;
			{"C5_MOEDA"  	,1					,Nil},;
			{"C5_TXMOEDA"  	,1.000				,Nil},;
			{"C5_CDPG"		,"BOLETO"			,Nil},;
			{"C5_PEDREP"	,"TRNSFRJ"			,Nil},;
			{"C5_ORCAM"		,"P"				,Nil},;
			{"C5_MENPAD"  	,""					,Nil},;
			{"C5_TESINT"  	,"05"				,Nil},;  //Romera - 20/02 - Considerar operaÁ„o transferencia
			{"C5_TPCARGA"	,"1"				,Nil},;
			{"C5_GERAWMS"  	,"2"				,Nil}}
			
			
			lMSHelpAuto := .T.
			lMsErroAuto := .F.
			
			MATA410(aCabSC5,aItemSC6,3)
			
			If lMsErroAuto
				
				MostraErro()
				DisarmTransaction()
				CONOUT("Pedido de transferencia NAO REALIZADO.")
				cLOG += "Os pedidos abaixo n„o foram integrados na filialm RJ!! Verifique os motivos no TI"
				cLOG += cFim
				IF LEN(aPEDLOG) > 0
					For X:= 1 TO LEN(aPEDLOG)
						cLOG += "Pedido: "+aPEDLOG[X]
						cLOG += cFim
					Next
				ENDIF
								
			Else
				
				ConfirmSX8()
				
				cLOG += "Pedido N∫ "+cNUMPED+" de IntegraÁ„o Gerado com sucesso"
				cLOG += cFim
								
				_cPedSC5	:= ""
				
				If Len(aPedInteg) > 0
					
					For x:= 1 To Len(aPedInteg)
						
						dbSelectArea("SC5")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek(xFILIAL("SC5")+aPedInteg[x][1])
							SC5->(RecLock( "SC5", .F. ))
							SC5->C5_XNUMTRF	:= cNumPed
							SC5->(MsUnLock())
							
							dbSelectArea("SUA")
							dbSetOrder(8)
							dbGoTop()
							If dbSeek(xFILIAL("SUA")+aPedInteg[x][1])
								SUA->(RecLock( "SUA", .F. ))
								SUA->UA_XNUMTRF	:= cNumPed
								SUA->(MsUnLock())
								
								cNumF01	:= SUA->UA_NUM
								cNumInt1:= SUA->UA_NUMSC5
							EndIf
							
							dbSelectArea("SUA")
							dbOrderNickname("XNUMF01")
							dbGoTop()
							If dbSeek("04"+cNumF01)
								SUA->(RecLock( "SUA", .F. ))
								SUA->UA_XNUMTRF	:= cNumPed
								SUA->(MsUnLock())
							EndIf
							
							dbSelectArea("SC5")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek("04"+SUA->UA_NUMSC5)
								SC5->(RecLock( "SC5", .F. ))
								SC5->C5_XNUMTRF	:= cNumPed
								SC5->C5_XNUMINT	:= cNumInt1
								SC5->(MsUnLock())
								
								cNumInt2:= SC5->C5_NUM
								
								dbSelectArea("SC5")
								dbSetOrder(1)
								dbGoTop()
								If dbSeek(xFILIAL("SC5")+aPedInteg[x][1])
									SC5->(RecLock( "SC5", .F. ))
									SC5->C5_XNUMINT	:= cNumInt2
									SC5->(MsUnLock())
								EndIf
								
							EndIf
							
						EndIf
						
					Next

				EndIf
								
				CONOUT("Pedido de transferencia OK.")
				cLOG += "Os pedidos abaixo foram integrados na filialm RJ com sucesso!!"
				cLOG += cFim
				IF LEN(aPEDLOG) > 0
					FOR X:= 1 TO LEN(aPEDLOG)
						cLOG += "Pedido: "+aPEDLOG[X]
						cLOG += cFim
					Next
				ENDIF
				
				LibPV(cNUMPED)
				
			EndIf
			
		EndIf
		
		If Select("TRC") > 0
			dbSelectArea("TRC")
			dbCloseArea("TRC")
		EndIf
		
	EndIf
	
EndIf

IF cLOG <> ""
	u_MErro()
ENDIF

Return


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫ Programa ≥ SaldIni() ≥ Autor ≥ Claudino P Domingues ≥ Data ≥ 04/09/13  ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫ Funcao Padrao ≥                                                        ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫ Desc.    ≥ Caso o produto nao tenha SB9, essa rotina ira incluir com   ∫±±
±±∫			 ≥ saldo zerado.                                               ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function SaldIni(_cProd)

Local _aReaSB9 := SB9->(GetArea())
Local _aDados  := {}
Local _lRet	   := .T.

DbSelectArea("SB9")
SB9->(DbSetOrder(1))

If !DbSeek(xFilial("SB9")+_cProd+"01")
	aAdd(_aDados  ,{"B9_FILIAL",xFilial("SB9"),NIL})
	aAdd(_aDados  ,{"B9_COD"   ,_cProd,NIL})
	aAdd(_aDados  ,{"B9_LOCAL" ,"01",NIL})
	aAdd(_aDados  ,{"B9_QINI"  ,0,NIL})
	lMSErroAuto = .F.
	MsExecAuto({|x,y,z|MATA220(x,y,z)},_aDados,3)
	If lMsErroAuto
		_lRet := .F.
		MostraErro()
		DisarmTransaction()
		Break
	Else
		_lRet := .T.
	EndIf
EndIf

RestArea(_aReaSB9)

Return(_lRet)


User Function MErro(cPath,cNome)

Local oDlg
Local cMemo
Local cFile      :=""
Local cMask      := "Arquivos Texto (*.TXT) |*.txt|"
Local oFont
Local cStartPath := GetSrvProfString("Startpath","")

cPath := If(cPath = Nil, "", cPath)
__cFileLog := Criatrab(,.f.)+".LOG"
cNome := __cFileLog
cMemo := cLog
MemoWrite(cNome,cMemo)
cLogName := "RIO"+STRZERO(DAY(dDATAbASE),2)+STRZERO(MONTH(DDATABASE),2)+STRZERO(YEAR(dDATAbASE),4)+".LOG"

Copy File (cStartPath + __cFileLog) To (cPath + "\INTRJ\" + cLOGNAME)

If Empty(cPath)
	DEFINE FONT oFont NAME "Courier New" SIZE 5,0   //6,15
	
	DEFINE MSDIALOG oDlg TITLE __cFileLog From 3,0 to 340,617 PIXEL
	
	@ 5,5 GET oMemo  VAR cMemo MEMO SIZE 300,145 OF oDlg PIXEL
	oMemo:bRClicked := {||AllwaysTrue()}
	oMemo:oFont:=oFont
	
	DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
	DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,OemToAnsi("Salvar Como...")),If(cFile="",.t.,MemoWrite(cFile,cMemo)),oDlg:End()) ENABLE OF oDlg PIXEL // //
	DEFINE SBUTTON  FROM 153,115 TYPE 6 ACTION (PrintAErr(__cFileLog,cMemo),oDlg:End()) ENABLE OF oDlg PIXEL //
	
	ACTIVATE MSDIALOG oDlg CENTER
Else
	ConOut("Processo nao concluido. Verificar arquivo " + cNome)
	Copy File (cStartPath + "\" + __cFileLog) To (cPath + "\" + cNome)
EndIf

Ferase(__cFileLog)
__cFileLog := Nil

Return(cMemo)


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Programa  ≥ IntRjMem ∫Autor  ≥Armando M. Tessaroli∫ Data ≥  25/03/03   ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Desc.     ≥Monta o texto conforme foi digitado pelo operador e quebra  ∫±±
±±∫          ≥as linhas no tamanho especificado sem cortar palavras e     ∫±±
±±∫          ≥devolve um array com os textos a serem impressos.           ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±∫Parametros≥ cCodigo - Codigo de referencia da gravacao do memo         ∫±±
±±∫          ≥ nTaM    - Tamanho maximo de colunas do texto               ∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function IntRjMem(cCodigo,nTam)

Local cString := MSMM(cCodigo,nTam)	// Carrega o memo da base de dados
Local nI	  := 0    				// Contador dos caracteres
Local nJ	  := 0    				// Contador dos caracteres
Local nL	  := 0					// Contador das linhas
Local cLinha  := ""					// Guarda a linha editada no campo memo
Local aLinhas := {}					// Array com o memo dividido em linhas

For nI := 1 TO Len(cString)
	If (MsAscii(SubStr(cString,nI,1)) <> 13) .AND. (nL < nTam) // MsAscii
		// Enquanto n„o houve enter na digitacao e a linha nao atingiu o tamanho maximo
		cLinha+=SubStr(cString,nI,1)
		nL++
	Else
		// Se a linha atingiu o tamanho maximo ela vai entrar no array
		If MsAscii(SubStr(cString,nI,1)) <> 13
			nI--
			For nJ := Len(cLinha) To 1 Step -1
				// Verifica se a ultima palavra da linha foi quebrada, entao retira e passa pra frente
				If SubStr(cLinha,nJ,1) <> " "
					nI--
					nL--
				Else
					Exit
				Endif
			Next nJ
			// Se a palavra for maior que o tamanho maximo entao ela vai ser quebrada
			If nL <=0
				nL := Len(cLinha)
			Endif
		Endif
		
		// Testa o valor de nL para proteger o fonte e insere a linha no array
		If nL >= 0
			cLinha := SubStr(cLinha,1,nL)
			AAdd(aLinhas, cLinha)
			cLinha := ""
			nL := 0
		Endif
	Endif
Next nI

// Se o nL > 0, eh porque o usuario nao deu enter no fim do memo e eu adiciono a linha no array.
If nL >= 0
	cLinha := SubStr(cLinha,1,nL)
	AAdd(aLinhas, cLinha)
	cLinha := ""
	nL := 0
Endif

Return(aLinhas)


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Programa ≥ LibPed ≥ Claudino Domingues ≥ Data 22/03/2016 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Desc.    ≥ Libera o pedido de vendas                     ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function LibPV(cPv)

	Local _cNumPed   := cPv
	
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1)) // C5_FILIAL + C5_NUM
	If MsSeek(xFilial("SC5")+_cNumPed)
	
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
		If MsSeek(xFilial("SC6")+_cNumPed+"01") // Posiciono no primeiro item do pedido
		
			While !SC6->(EOF()) .And. SC6->C6_NUM == _cNumPed
				
				If RecLock("SC5")
					nQtdLib := SC6->C6_QTDVEN
					
					//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					// Recalcula a Quantidade Liberada ±±
					//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					RecLock("SC6") // Forca a atualizacao do Buffer no Top
					
					//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					// Libera por Item de Pedido       ±±
					//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					// Este comando define que as operaÁıes seguintes, delimitadas pelo comando END TRANSACTION,        ±±
					// devem ser processadas como uma transaÁ„o, ou seja, como um bloco ˙nico e indivisÌvel. Durante    ±±
					// uma recuperaÁ„o de falha, todas as operaÁıes de manipulaÁ„o de dados realizadas ser„o            ±±
					// integralmente desfeitas, alÈm de prover isolamento entre acessos concorrentes na mesma massa de  ±±
					// dados.                                                                                           ±±
					//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
					Begin Transaction
					
						/*
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±± Descricao ≥ Liberacao dos Itens de Pedido de Venda                      ≥±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±±  Retorno  ≥ ExpN1: Quantidade Liberada                                  ≥±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±± Transacao ≥ Nao possui controle de Transacao a rotina chamadora deve    ≥±±
						±±           ≥ controlar a Transacao e os Locks                            ≥±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±± Parametros ≥ExpN1: Registro do SC6                                      ≥±±
						±±            ≥ExpN2: Quantidade a Liberar                                 ≥±±
						±±            ≥ExpL3: Bloqueio de Credito                                  ≥±±
						±±            ≥ExpL4: Bloqueio de Estoque                                  ≥±±
						±±            ≥ExpL5: Avaliacao de Credito                                 ≥±±
						±±            ≥ExpL6: Avaliacao de Estoque                                 ≥±±
						±±            ≥ExpL7: Permite Liberacao Parcial                            ≥±±
						±±            ≥ExpL8: Tranfere Locais automaticamente                      ≥±±
						±±            ≥ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ≥±±
						±±            ≥       apenas avalia ).                                     ≥±±
						±±            ≥ExpbA: CodBlock a ser avaliado na gravacao do SC9           ≥±±
						±±            ≥ExpAB: Array com Empenhos previamente escolhidos            ≥±±
						±±            ≥       (impede selecao dos empenhos pelas rotinas)          ≥±±
						±±            ≥ExpLC: Indica se apenas esta trocando lotes do SC9          ≥±±
						±±            ≥ExpND: Valor a ser adicionado ao limite de credito          ≥±±
						±±            ≥ExpNE: Quantidade a Liberar - segunda UM                    ≥±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						*/
						MaLibDoFat(SC6->(RecNo()),@nQtdLib)
					End Transaction
				
				EndIf
				
				SC6->(MsUnLock())
				
				//*************************************
				// Atualiza o Flag do Pedido de Venda |
				//*************************************
				Begin Transaction
					SC6->(MaLiberOk({_cNumPed},.F.))
				End Transaction
				
				dbSelectArea("SC6")
				SC6->(dbSkip())
			EndDo
			
			SC5->(MsUnLock())
		EndIf        
	EndIf
		
Return

User Function xCalcula(cCampo,nLinha,lTudo)

Return