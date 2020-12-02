#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±  MT097END ³ Autor: Claudino Pereira Domingues           ³ Data 15/12/14 ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Descricao ³ Ponto de entrada localizado no fim das funções A097LIBERA,  ±±
±±           ³ A097SUPERI e A097TRANSF, passa como parametros o Numero do  ±±
±±           ³ Documento, Tipo, Opção executada (nOpc) e a Filial do       ±±
±±           ³ Documento e não envia retorno, usado conforme necessidades  ±±
±±           ³ do usuario para diversos fins.                              ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Obs  ³ ParamIXB = {_cDocto,_cTipDoc,_nOpcao,_cFilDoc}                   ±±
±±      ³ _cDocto == Numero do Documento                                   ±±
±±      ³ _cTipDoc == Tipo do Documento "PC" "AE" "CP"                     ±±
±±      ³ Quando o ponto é acionado pela rotina de Liberação e Superior:   ±±
±±      ³ _nOpcao == 1 --> Cancela                                         ±±
±±      ³ _nOpcao == 2 --> Libera                                          ±±
±±      ³ _nOpcao == 3 --> Bloqueia                                        ±±
±±      ³ Quando o ponto é acionado pela rotina de Transf. Superior        ±±
±±      ³ _nOpcao == 1 --> Transfere                                       ±±
±±      ³ _nOpcao == 2 --> Cancela                                         ±±
±±      ³ Para esta rotina, caso não exista o superior cadastrado,         ±±
±±      ³ a variável será enviada como Nil. Deve ser tratado no ponto      ±±
±±      ³ de entrada.                                                      ±±
±±      ³ _cFilDoc == Filial do Documento                                  ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT097END() 

Return

