#include "protheus.ch"
#DEFINE COMP_DATE  "20200114"

/*/{Protheus.doc} PE01NFESEFAZ
Ponto de Entrada para Manipulação em dados do produto.

@author Maurício O. Aureliano
@since 07/08/2019

@obs	Ponto de entrada localizado na função XmlNfeSef do rdmake NFESEFAZ. 
Através deste ponto é possível realizar manipulações nos dados do produto, 
mensagens adicionais, destinatário, dados da nota, pedido de venda ou compra, 
antes da montagem do XML, no momento da transmissão da NFe.

//O retorno deve ser exatamente nesta ordem e passando o conteúdo completo dos arrays
//pois no rdmake nfesefaz é atribuido o retorno completo para as respectivas variáveis
//Ordem:
//      aRetorno[01] -> aProd
//      aRetorno[02] -> cMensCli
//      aRetorno[03] -> cMensFis
//      aRetorno[04] -> aDest
//      aRetorno[05] -> aNota
//      aRetorno[06] -> aInfoItem
//      aRetorno[07] -> aDupl
//      aRetorno[08] -> aTransp
//      aRetorno[09] -> aEntrega
//      aRetorno[10] -> aRetirada
//      aRetorno[11] -> aVeiculo
//      aRetorno[12] -> aReboque
//      aRetorno[13] -> aNfVincRur
//      aRetorno[14] -> aEspVol
//      aRetorno[15] -> aNfVinc
//      aRetorno[16] -> AdetPag
//      aRetorno[17] -> ObsCont

@return	aRetorno		Array dados NF-e.
/*/

USER FUNCTION PE01NFESEFAZ()

	Local aProd     	:= PARAMIXB[1]
	Local cMensCli  	:= PARAMIXB[2]
	Local cMensFis  	:= PARAMIXB[3]
	Local aDest     	:= PARAMIXB[4]
	Local aNota     	:= PARAMIXB[5]
	Local aInfoItem 	:= PARAMIXB[6]
	Local aDupl     	:= PARAMIXB[7]
	Local aTransp   	:= PARAMIXB[8]
	Local aEntrega  	:= PARAMIXB[9]
	Local aRetirada 	:= PARAMIXB[10]
	Local aVeiculo  	:= PARAMIXB[11]
	Local aReboque  	:= PARAMIXB[12]
	Local aNfVincRur	:= PARAMIXB[13]
	Local aEspVol   	:= PARAMIXB[14]
	Local aNfVinc   	:= PARAMIXB[15]
	Local AdetPag   	:= PARAMIXB[16]
	Local aObsCont   	:= PARAMIXB[17]
	Local aRetorno  	:= {}
	Local cNfeMail		:= Trim(SuperGetMV("FS_NFEMAIL",,""))
	Local cPedMsg		:= ""
	Local cCodMsg		:= ""
	Local cEntSai       := aNota[4]

	Local aObs 			:= {} 								// Customizado
	Local cObs			:= "" 								// Customizado
	Local nCont			:= 0  								// Customizado
	Local cUAObs  		:= "" 								// Customizado
	Local cC5Obs  		:= "" 								// Customizado
	Local cEndEnt   	:= "Local da entrega: "	// Customizado
	
	// Local aAreaTmp	:= SF2->(GetArea())
	
	// Adição de e-mail para recebimento de arquivo XML
	If !Empty(cNfeMail)
		AFill( aDest, Trim(aDest[16]) + ";" + cNfeMail, 16, 1 )
	EndIf

	//--------------------------------------------------------------------
	// Retirada de customizações do fonte NFESEFAZ.PRW 
	// MOA - 18/09/2019 - 10:37h
	//--------------------------------------------------------------------
	// Mensagens customizadas Ourolux. (Inicio)
	//--------------------------------------------------------------------


	//---------------
	// BLOCO 01
	//---------------
	If cEntSai == "1"
		If SF2->F2_TIPO <> "D"
				SA3->(dbSeek(xFilial("SA3")+SF2->F2_VEND1,.F.))
				cObs := "Vend: "
				cObs += SF2->F2_VEND1 + " "
				cObs += AllTrim(SA3->A3_NREDUZ)
				cObs += " Pedido: "
				SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ,.F.))
				cPedMsg := SD2->D2_PEDIDO
				cObs += SD2->D2_PEDIDO + " "
				SE4->(dbSeek(xFilial("SE4") + SF2->F2_COND ,.F.))
				cObs += " Cond. Pagto: "
				cObs += SF2->F2_COND + " "
				cObs += AllTrim(SE4->E4_DESCRI)
				cObs += ". "                                                     //
				cObs += "Favor enviar NF-e de devoluçao para nfe@ourolux.com.br" //
			EndIf
		
			aAdd(aObs,cObs)
		
		
			//---------------
			// BLOCO 02
			//---------------
			If SF2->F2_ICMSRET <> 0 .And. SF2->F2_TIPO == 'N' .And. cFilAnt <> "02"
				aAdd(aObs, "RECOLHIMENTO DO ICMS CONF. PROTOCOLO No 17 DE 25.07.85 DOU 29.07.85" )  // 67 Chars
			EndIf
		
			// Chamado I1906-091 Fórmula - Clientes Paraná // MOA - 05/06/2019 - 10:07hs
			If SF2->F2_EST == 'PR' .And. SF2->F2_VALICM <> 0 .And. cFilAnt == "06"
				aAdd(aObs, FORMULA("205"))
			EndIf					
		
			// Chamado I1906-1848 Fórmula - Clientes Rio Grande do Sul // MOA - 27/06/2019 - 18:00hs
			If SF2->F2_EST == 'RS' .And. SF2->F2_VALICM <> 0 .And. cFilAnt == "06"
				aAdd(aObs, FORMULA("209"))
			EndIf		
		
		
		
			//---------------
			// BLOCO 03
			//---------------
			If !Empty(SA1->A1_MENSAGE)
				aadd(aObs,AllTrim(FORMULA(SA1->A1_MENSAGE))) // LEROY
			EndIf
		
		
		
			//---------------
			// BLOCO 04
			//---------------
		
			//--------------------------------------------------
			// Retorno de Campo Customizado TMK. 
			//--------------------------------------------------
			If SF2->F2_TIPO <> "D"
				Dbselectarea("SUA")
				dbSetOrder(2)
				If Dbseek(xFilial("SUA")+SF2->F2_SERIE+SF2->F2_DOC)
		
					//-----------------------------------
					// Local da entrega TMK.
					//-----------------------------------
					cEndEnt += Alltrim (SUA->UA_ENDENT)
					cEndEnt += ' - '
					cEndEnt += AllTrim (SUA->UA_BAIRROE)
					cEndEnt += ' - '
					cEndEnt += AllTrim (SUA->UA_MUNE)
					cEndEnt += ' - '
					cEndEnt += AllTrim (SUA->UA_ESTE)
					cEndEnt += ' - '
					cEndEnt += Transform (SUA->UA_CEPE, "@R 99999-999")
		
					aadd(aObs,cEndEnt)
		
					//---------------
					// Obs TMK                           
					//---------------  
					If !Empty (SUA->UA_CODOBS)
						cUAObs := MSMM(SUA->UA_CODOBS)
						aadd(aObs,cUAObs)
					EndIf
		
				EndIf						
			EndIf
		
			//---------------
			// BLOCO 05
			//---------------
		
			//-----------------------------------------------------------------------
			// Obs Faturamento
			//-----------------------------------------------------------------------
			//cUAObs := SC5->C5_MSGNOTA 
			// Marcelo Ethosx - Substituido por campo memo virtual
			//-----------------------------------------------------------------------
			// MOA - 02/10/2019 - Variaveis para consulta de codigo
			//                                 da mensagem do portal de venda.
			//-----------------------------------------------------------------------
			cCodMsg := Posicione("SC5",1,xFilial("SC5")+cPedMsg,"C5_XCODMNF")
			If !Empty (cCodMsg)
				cC5Obs := MSMM(cCodMsg)
				aadd(aObs,cC5Obs)
			EndIf
	EndIf

	//---------------
	// BLOCO 06
	//---------------

	//--------------------------------------------------------------------
	//³ Tratamento de mensagens de Nota de Entrada ³
	//³ Customizado Eletromega. (Inicio)           ³
	//--------------------------------------------------------------------
	If cEntSai == "0"
		If !Empty(SF1->F1_HAWB) // Nota Fiscal de Importaçao ---> SIGAEIC
	
			cObs := "DI : "
			cObs += Transform(GetAdvFVal("SW6","W6_DI_NUM",xFilial("SW6")+SF1->F1_HAWB,1,""),;
			PesqPict("SW6","W6_DI_NUM"))
			aAdd(aObs,cObs)
	
			cObs := "PIS: " + Alltrim(STR(SF1->F1_VALIMP6,,2))
			aAdd(aObs,cObs)
			cObs := "COFINS: " + Alltrim(STR(SF1->F1_VALIMP5,,2))
			aAdd(aObs,cObs)
			cObs := "II: " + Alltrim(STR(SF1->F1_II,,2))
			aAdd(aObs,cObs)
	
			If !Empty( SF1->F1_OBSNFE )  // importacao : Dados Adicionais Nota Fiscal de Entrada c/ Nosso Formulario
				cObs := SF1->F1_OBSNFE
				aAdd(aObs,cObs)
			EndIf
		EndIf
	
	
		// Preenchimento da variável de Mensagem do Cliente com o array de observação
		
		//Retirado o trecho abaixo, pois a variável cMensCli é prenchida tanto para docs. de saida e entrada fora das condições anteriores
		/*For nCont:=1 To Len(aObs)
			cMensCli += aObs[nCont]+" "
		Next nCont*/
	EndIf

	//--------------------------------------------------------------------
	// Mensagens customizadas Ourolux. (Fim)
	//--------------------------------------------------------------------

	//----------------------------------------------------------------------------
	//Adicição de dados para tag ObsCont necessárias para integração TranspoFrete
	//----------------------------------------------------------------------------
	
	//[1] = xcampo [2] = xTexto
	If cEntSai == "1"
		AADD(aObsCont, {"CATEGORIA"			, "Nota Fiscal saida"} )
		AADD(aObsCont, {"TF_NUM_PNF_REF"	, SD2->D2_PEDIDO} )
		AADD(aObsCont, {"TF_SER_PNF_REF"	, "2"} )
	EndIf
	
	// Preenchimento da variável de Mensagem do Cliente com o array de observação
	For nCont:=1 To Len(aObs)
		cMensCli += aObs[nCont]+" "
	Next nCont
	//----------------------------------------------------------------------------
	//Fim da trativa Transpofrete
	//----------------------------------------------------------------------------


	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)


	// Habilitar linhas abaixo para testes!
	/*
	if alltrim(!upper(GetEnvServer()))  == "UN08F1_PRD"  // Exibe somente se não for ambiente de produção

	cMsg := '[ PE01NFESEFAZ ] '					+ CRLF
	cMsg += 'Numero da nota: '	+ aNota[2] 		+ CRLF
	cMsg += 'Destinatario: '	+ aDest[2] 		+ CRLF
	cMsg += 'Email: '			+ aDest[16] 	+ CRLF
	cMsg += 'Mensagem da nota: '+ cMensCli 		+ CRLF
	cMsg += 'Mensagem padrao: '	+ cMensFis 		+ CRLF

	Alert(cMsg)
	endif
	*/

RETURN aRetorno