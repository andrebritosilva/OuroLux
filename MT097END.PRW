#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北  MT097END � Autor: Claudino Pereira Domingues           � Data 15/12/14 北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Descricao � Ponto de entrada localizado no fim das fun珲es A097LIBERA,  北
北           � A097SUPERI e A097TRANSF, passa como parametros o Numero do  北
北           � Documento, Tipo, Op玢o executada (nOpc) e a Filial do       北
北           � Documento e n鉶 envia retorno, usado conforme necessidades  北
北           � do usuario para diversos fins.                              北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北 Obs  � ParamIXB = {_cDocto,_cTipDoc,_nOpcao,_cFilDoc}                   北
北      � _cDocto == Numero do Documento                                   北
北      � _cTipDoc == Tipo do Documento "PC" "AE" "CP"                     北
北      � Quando o ponto � acionado pela rotina de Libera玢o e Superior:   北
北      � _nOpcao == 1 --> Cancela                                         北
北      � _nOpcao == 2 --> Libera                                          北
北      � _nOpcao == 3 --> Bloqueia                                        北
北      � Quando o ponto � acionado pela rotina de Transf. Superior        北
北      � _nOpcao == 1 --> Transfere                                       北
北      � _nOpcao == 2 --> Cancela                                         北
北      � Para esta rotina, caso n鉶 exista o superior cadastrado,         北
北      � a vari醰el ser� enviada como Nil. Deve ser tratado no ponto      北
北      � de entrada.                                                      北
北      � _cFilDoc == Filial do Documento                                  北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

User Function MT097END() 

Return

