#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"

#DEFINE COMP_DATE	"20191128"

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} M460FIM
Este P.E. e' chamado apos a Gravacao da NF de Saida, e fora da transação.
Gera arquivo para integraçao para o sistema de cobranca BRADESCO - BOLETO

@type 		Function
@author 	TOTVS
@since 		03/05/2017
@version 	P12
/*/    
//-------------------------------------------------------------------------------------
User Function M460FIM()

	Local cDirBol 		:= GetMV("FS_ELE007")
	Local nVlrDesc 		:= 0
	Local cMensagem1	:= ""
	Local cData     	:= ""
	Local aArea     	:= ""
	Local cQuery        := ""
	Local _nNro			:= 0
	Local _nHnd			:= 0
	Local _nVlr			:= 0
	Local nBanco        := 0
	Local _cReg			:= ""
	Local _cAge			:= ""
	Local _cCNPJ		:= ""
	Local _cDta			:= ""
	Local nRecSE1       := 0
	Local lGeraBol      := !(SC5->C5_BANCO $ 'LIC.CAR') // BANCO LIC/CAR : Nao Gera arquivo texto para a impressao do boleto

	Local cBolCart      := GetMv("FS_BOLCART")	//"02"
	Local cBolBco       := GetMv("FS_BOLBCO" )	//"237"
	Local cBolAge       := GetMv("FS_BOLAGEN")	//"3381"
		
	PesoBru() // Grava o peso bruto no F2_PBRUTO
	PesoLiq() // Grava o peso LIQUIDO no F2_PLIQUI
	
	// Campo especifico para a digit. da base de ICMS RET para a NF complementar de ICMS ST
	If !Empty(SC5->C5_BICMST)
		SF2->(RecLock('SF2', .F.))
		SF2->F2_BICMST := SC5->C5_BICMST // 08-04-2009 BASE DE ICMS ST PARA NF COMPLEMENTAR DE ICMS ST
		SF2->(MSUnLock())
	EndIf
	
	// NF-e XML
	If !Empty(SC5->C5_TPFRETE)
		SF2->( RecLock('SF2', .F.))
		SF2->F2_TPFRETE := SC5->C5_TPFRETE // NF-e XML
		SF2->( MSUnLock() )
	EndIf
	
	// Especie/Volumes
	If Empty(SC5->C5_ESPECI1) .And. (SC5->C5_VOLUME1 == 0) .And. SC5->C5_TIPO == 'N'
		EspVol()
	EndIf
	
	// Para bonificaço nao geramos boletos
	If U_IsBonif(SF2->F2_DOC,SF2->F2_SERIE)
		Return (NIL)
	EndIf
	
	If SF2->F2_TIPO    <> 'D' .And.;
			SF2->F2_SERIE <> 'TRC'
		
		/* GERA Boleto NO FORMATO WSISLASER P/ BRADESCO */
		SA1->( RecLock( 'SA1', .F. ) )
		SA1->A1_ULTCOM := dDataBase
		SA1->( MSUnLock() )
		
		nRecSE1 := SE1->( RecNo() )
		
		While SF2->F2_DOC = SE1->E1_NUM .And.;
			SF2->F2_SERIE == SE1->E1_PREFIXO
			
			RecLock( "SE1", .F. )
			SA3->( dbSeek( xFilial( "SA3" ) + SE1->E1_VEND1, .F.  ) )
			SE1->E1_SUPERVI := SA3->A3_SUPER
			SE1->( MSUnLock() )
			SE1->( dbSkip( -1 ) )
		EndDo
		SE1->( dbGoTo( nRecSE1 ) )
	EndIf
	
	If !Empty( SC5->C5_DATA1  )
		SE1->( RecLock( 'SE1', .F. ) )
		SE1->E1_VENCTO  := SC5->C5_DATA1
		SE1->E1_VENCREA := Datavalida(SC5->C5_DATA1)
		SE1->E1_VENCORI := SC5->C5_DATA1
		SE1->( MSUnLock() )
	EndIf
	
	aArea := GetArea()

	If lGeraBol

		While SF2->F2_DOC == SE1->E1_NUM .And.;
			SF2->F2_SERIE == SE1->E1_PREFIXO
		                      
			RecLock( "SE1", .F. )
			SE1->E1_SUPERVI := SA3->A3_SUPER
			SE1->E1_XCATCOB := "5" 
			If SE1->(FieldPos("E1_XBOLETO")) > 0
				SE1->E1_XBOLETO := "1"
			EndIf
			SE1->( MSUnLock() )
	                   
			SE1->( dbSkip( -1 ) )
		EndDo

		// Apenas imprime neste momento se for Itau
		If cBolBco == "341"
			u_BLTITAU(SF2->F2_DOC,SF2->F2_PREFIXO,SF2->F2_CLIENTE,SF2->F2_LOJA)
		EndIf
	EndIf

	// Maurício Aureliano - Chamado: I1805-1114 - Comissão - Complemento de ST
	If SF2->F2_TIPO == "I"
	
		SE1->(dbSetOrder(2))
		SE1->(dbSeek(xFilial("SE1")+E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))

		While !Eof() .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_CLIENTE == SF2->F2_CLIENTE .and. SE1->E1_PREFIXO == SF2->F2_SERIE .and. SE1->E1_NUM == SF2->F2_DOC
			SE1->(RecLock("SE1", .F. ))
			SE1->E1_VEND1 := ""
			SE1->E1_VEND2 := ""
			SE1->E1_VEND3 := ""
			SE1->E1_VEND4 := ""
			SE1->E1_VEND5 := ""
			SE1->(MsUnLock())
		EndDo

	EndIf

Return( Nil )

//
//
/* Nosso Numero: 11 digits (pos 157 - 167) + 1 digit verif (Pos. 168) 

Static Function NossoNum(cPrefixo,cNumero,cParcela,nBanco)
	Local nNNum		:= 0
	Local _nParc	:= 0
	Local _nDig		:= 0
	Local _nRst     := 0
	Local _nMlt     := { 2, 7, 6, 5, 4, 3, 2, 7, 6, 5, 4, 3, 2 }


	If MV_PAR26 == 1                // Carteira 02 
		nNNum := '02'  	    // --- Conta sem o DV  ---
	ElseIf MV_PAR26 == 2            // Carteira 09 
		nNNum := '09'
	EndIf


// Carteira
	nNNum += StrZero( Val( cPrefixo ), 3 )   // Converter um numérico em uma string com zeros a esquerda.
	nNNum += cNumero

	cParcela := IIf(Empty(cParcela),"A",cParcela)

	If cParcela <> ' '
		_nParc := Asc( cParcela )
		_nParc -= 64
		_nParc := StrZero( _nParc, 2 )
		nNNum  += _nParc
	Else
		nNNum += '00'   // Parcela Unica 
	EndIf

	nBanco := Substr( nNNum,  3, 9 )
	nBanco += Substr( nNNum, 13, 1 )

	_nDig := 0

	For n := 1 To 13
		_nRst := Val( Substr( nNNum, n, 1 ) )
		_nRst *= _nMlt[ n ]
		_nDig += _nRst
	Next

	_nRst := Mod( _nDig, 11 )

	If _nRst <> 0
		_nDig := 11
		_nDig -= _nRst
	
		If _nDig <> 10
			_nDig := StrZero( _nDig, 1 )
		Else
			_nDig := 'P'
		EndIf
	
	Else
		_nDig := '0'
	End

	nNNum += _nDig
	nNNum := Substr( nNNum, 3 )

Return (nNNum)

*/

// Check to see if Bonificaçao
User Function IsBonif(cDoc,cSer)
Local lRet 		:= .F.
Local cQuery 	:= ""
Local _aArea    := GetArea()

cQuery := 	" SELECT D2_DOC, D2_SERIE, D2_CF ,D2_TES " +;
        	" FROM " + RetSqlName("SD2") + " SD2" +;
		    " WHERE	SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND" +;
		    " SD2.D2_DOC   = '" + cDoc + "' AND" +;
		    " SD2.D2_SERIE = '" + cSer + "' AND" +;
		    " SD2.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)

DbSelectArea("TMP")
DbGoTop()

While !TMP->(Eof())
	
	If Substr( TMP->D2_CF, 2, 3 ) == "910"  // Codigo fiscal para Bonificaçao
		lRet := .T.
		Exit
	EndIf
	
	TMP->(DbSkip())
	
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalize ambiente temporario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TMP->(DbCloseArea())
RestArea(_aArea)

Return (lRet)


Static Function EspVol()
	Local cQuery    := ''
	Local nQtdVol 	:= 0
	Local cAliasQry := "TMP"
	Local _aArea1   := GetArea()

	If Select(cAliasQry) != 0
		(cAliasQry)->(DbCloseArea())
	EndIf

	cQuery := "SELECT SD2.D2_COD AS Produto,SUM (SD2.D2_QUANT) as Quant,  "
	cQuery += "SB1.B1_QE As QE "
	cQuery += "FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "SD2.D2_COD = SB1.B1_COD "
	cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "SD2.D2_TES = SF4.F4_CODIGO "
	cQuery += "WHERE "
	cQuery += "SD2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' AND "
	cQuery += "SF4.D_E_L_E_T_ = ' ' AND "
	cQuery += "SD2.D2_FILIAL  = '" + SF2->F2_FILIAL  + "' AND "
	cQuery += "SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND "
	cQuery += "SD2.D2_LOJA    = '" + SF2->F2_LOJA    + "' AND "
	cQuery += "SD2.D2_SERIE   = '" + SF2->F2_SERIE   + "' AND "
	cQuery += "SD2.D2_DOC     = '" + SF2->F2_DOC     + "' AND "
	cQuery += "SD2.D2_TIPO    = '" + SF2->F2_TIPO    + "' AND "
	cQuery += "SF4.F4_ESTOQUE = 'S' "
	cQuery += "GROUP BY SD2.D2_COD, SB1.B1_QE "
	cQuery += "ORDER BY SD2.D2_COD "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), cAliasQry)

	While (cAliasQry)->(!Eof())
		If !Empty((cAliasQry)->QE)
			nQtdVol	+= Int((cAliasQry)->Quant / (cAliasQry)->QE)
			If Mod((cAliasQry)->Quant, (cAliasQry)->QE) > 0
				nQtdVol++
			EndIf
		EndIf
		(cAliasQry)->(dbSkip())
	EndDo

	If nQtdVol > 0
		SF2->(RecLock('SF2', .F.))
		Replace SF2->F2_ESPECI1 With 'Caixa(s)'
		Replace SF2->F2_VOLUME1 With nQtdVol
		SF2->(MSUnLock())
	EndIf

	(cAliasQry)->(DbCloseArea())
	RestArea(_aArea1)

Return()

Static Function PesoLiq()

	Local _cQuery    := ''
	Local _aArea1   := GetArea()

	If Select("PESO") > 0
		DbSelectArea("PESO")
		PESO->(DbCloseArea())
	EndIf

	_cQuery := " SELECT SUM(SB1.B1_PESO * D2_QUANT) As PESOL "
	_cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON SD2.D2_COD = SB1.B1_COD "
	_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SD2.D2_FILIAL  = '" + SF2->F2_FILIAL  + "' AND "
	_cQuery += " SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND "
	_cQuery += " SD2.D2_LOJA    = '" + SF2->F2_LOJA    + "' AND "
	_cQuery += " SD2.D2_SERIE   = '" + SF2->F2_SERIE   + "' AND "
	_cQuery += " SD2.D2_DOC     = '" + SF2->F2_DOC     + "' AND "
	_cQuery += " SD2.D2_TIPO    = '" + SF2->F2_TIPO    + "' AND "
	_cQuery += " SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	_cQuery += " GROUP BY SD2.D2_DOC "

//MEMOWRITE("E:\TESTESQL3.SQL",_cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), 'PESO' )

	_nPesoL := PESO->PESOL

	If SF2->( RecLock( 'SF2', .F. ) ) .And. PESO->(!Eof())
	
		SF2->F2_PLIQUI := PESO->PESOL
		SF2->( MSUnLock() )
	
	EndIf

	RestArea(_aArea1)
	PESO->(DbCloseArea())

Return()

Static Function PesoBru()

	Local _cQuery    := ''
	Local _aArea1   := GetArea()

	If Select("PESO") > 0
		DbSelectArea("PESO")
		PESO->(DbCloseArea())
	EndIf

	_cQuery := " SELECT SUM(SB1.B1_PESBRU * D2_QUANT) As PESOB "
	_cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += " ON SD2.D2_COD = SB1.B1_COD "
	_cQuery += " WHERE SD2.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SB1.D_E_L_E_T_ <> '*' AND "
	_cQuery += " SD2.D2_FILIAL  = '" + SF2->F2_FILIAL  + "' AND "
	_cQuery += " SD2.D2_CLIENTE = '" + SF2->F2_CLIENTE + "' AND "
	_cQuery += " SD2.D2_LOJA    = '" + SF2->F2_LOJA    + "' AND "
	_cQuery += " SD2.D2_SERIE   = '" + SF2->F2_SERIE   + "' AND "
	_cQuery += " SD2.D2_DOC     = '" + SF2->F2_DOC     + "' AND "
	_cQuery += " SD2.D2_TIPO    = '" + SF2->F2_TIPO    + "' AND "
	_cQuery += " SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
	_cQuery += " GROUP BY SD2.D2_DOC "

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), 'PESO' )

	If SF2->( RecLock( 'SF2', .F. ) ) .And. PESO->(!Eof())
	
		SF2->F2_PBRUTO := PESO->PESOB
		SF2->( MSUnLock() )
	
	EndIf

	RestArea(_aArea1)
	PESO->(DbCloseArea())

Return()
