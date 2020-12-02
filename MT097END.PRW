#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
��  MT097END � Autor: Claudino Pereira Domingues           � Data 15/12/14 ��
�����������������������������������������������������������������������������
�� Descricao � Ponto de entrada localizado no fim das fun��es A097LIBERA,  ��
��           � A097SUPERI e A097TRANSF, passa como parametros o Numero do  ��
��           � Documento, Tipo, Op��o executada (nOpc) e a Filial do       ��
��           � Documento e n�o envia retorno, usado conforme necessidades  ��
��           � do usuario para diversos fins.                              ��
�����������������������������������������������������������������������������
�� Obs  � ParamIXB = {_cDocto,_cTipDoc,_nOpcao,_cFilDoc}                   ��
��      � _cDocto == Numero do Documento                                   ��
��      � _cTipDoc == Tipo do Documento "PC" "AE" "CP"                     ��
��      � Quando o ponto � acionado pela rotina de Libera��o e Superior:   ��
��      � _nOpcao == 1 --> Cancela                                         ��
��      � _nOpcao == 2 --> Libera                                          ��
��      � _nOpcao == 3 --> Bloqueia                                        ��
��      � Quando o ponto � acionado pela rotina de Transf. Superior        ��
��      � _nOpcao == 1 --> Transfere                                       ��
��      � _nOpcao == 2 --> Cancela                                         ��
��      � Para esta rotina, caso n�o exista o superior cadastrado,         ��
��      � a vari�vel ser� enviada como Nil. Deve ser tratado no ponto      ��
��      � de entrada.                                                      ��
��      � _cFilDoc == Filial do Documento                                  ��
�����������������������������������������������������������������������������
*/

User Function MT097END() 

Return
