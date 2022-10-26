TITLE Tiago Dallecio 22001336 Renan Rohers

.model small

.stack 100h

.data
    hello db "Bem vindo!",'$'
    num1 db "Insira o primeiro numero da operacao:",'$'
    num2 db "Insira o segundo numero da operacao:",'$'
    op db "Insira a operacao desejada(+, -, *, /):",'$'
    reset db "Deseja fazer outra conta? (y/n)",'$'
    thanks db "Obrigado, tenha um bom dia!   Made by Tiago Dallecio & Renan Rohers",'$'

.code 
    main proc
        mov ax,@data ;Inicializando o segmento de dados
        mov ds,ax

        mov ah,09h ;Impressao da mensagem de boas vindas
        lea dx,hello
        int 21h

    inicio:
        mov ah,02h ;Enter
        mov dl,10
        int 21h

        mov ah,09h ;Impressao da mensagem de requerimento do primeiro numero
        lea dx,num1
        int 21h

        mov ah,01h ;Funcao de escrita do primeiro numero da operacao como um caracter
        int 21h
        and al,0Fh ;Conversao do caracter para um valor numerico
        mov bl,al  ;Salvando o valor digitado em bl
        
        mov ah,02h ;Enter
        mov dl,10
        int 21h

        mov ah,09h ;Impressao da mensagem de requerimento do segundo numero
        lea dx,num2
        int 21h

        mov ah,01h ;Funcao de escrita do segundo numero da operacao como um caracter
        int 21h
        and al,0Fh ;Conversao do caracter para um valor numerico
        mov bh,al ;Salvando o valor digitado em bh

        mov ah,02h
        mov dl,10
        int 21h
        
        mov cl,bl ;Salvando o valor armazenado em bl em cl para, futuramente, executar a operacao
        mov ch,bh ;O mesmo do de cima 

        or bl,30h ;Convertendo o valor numerico de bl em um caracter para a impressao 
        or bh,30h ;O mesmo do de cima

        mov ah,09h ;Impressao da mensagem de requerimento do operador
        lea dx,op
        int 21h

        mov ah,01h ;Logica da soma 
        int 21h
        
        cmp al,'+' ;Comparando o valor retornado em al com o caracter '+'
        je soma ;Caso o valor digitado seja igual a '+', pula para 'soma'
        
        cmp al,'-' ;Comparando o valor retornado em al com o caracter '-'
        je subtracao ;Caso o valor digitado seja igual a '-', pula para 'subtracao'

        cmp al,'*' ;Comparando o valor retornado em al com o caracter '*'
        je multiplicacao ;Caso o valor digitado seja igual a '*', pula para 'multiplicacao' 

        soma: ;Label que chama o procedimento da soma, 'somap'
        call somap
        jmp volta 

        subtracao: ;Label que chama o procedimento da subtracao, 'subtracaop'
        call subtracaop
        jmp volta

        multiplicacao: ;Label que chama o procedimento da multiplicacao, 'multiplicacaop'
        call multiplicacaop
        jmp volta

        divisao: ;Label que chama o procedimento da divisao, 'divisaop'
        call divisaop
        jmp volta

        volta: ;Pergunta se o usuario quer realizar outra conta
        mov ah,02h 
        mov dl,10
        int 21h

        mov ah,09h
        lea dx,reset ;Mensagem da pergunta
        int 21h

        mov ah,01h ;Leitura da resposta do usuario, 'y/n'
        int 21h
        
        cmp al,'y' 
        je inicio ;Caso a resposta do usuario seja sim, retorna ao inicio

        mov ah,02h 
        mov dl,10
        int 21h

        mov ah,09h
        lea dx,thanks ;Mensagem de creditos
        int 21h

        mov ah,4ch ;Encerramento do programa
        int 21h
    main endp;FIM DA MAIN

    somap proc ;Soma dois numeros (0 a 9)
        mov ah,02h
        mov dl,10
        int 21h

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero 
        mov dl,'+'
        int 21h ;Sinal de soma
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade
        
        add ch,cl ;Soma dos valores numericos guardados anteriormente
        or ch,30h ;Conversao para caracter para a impressao
        mov ah,02h
        mov dl,ch
        int 21h ;Impressao do resultado
        ret
    somap endp ;Fim do prodcedimento de soma

    subtracaop proc ;Subtrai dois numeros (0 a 9)
        mov ah,02h
        mov dl,10
        int 21h

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero
        mov dl,'-'
        int 21h ;Sinal de subtracao
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade

        sub cl,ch ;Subtracao dos valores numericos guardados anteriormente
        js negativo ;Caso o valor da subtracao seja negativo, pula para 'negativo'
        or cl,30h ;Conversao do resultado da subtracao em um caracter para impressao
        mov ah,02h
        mov dl,cl ;Impressao do caracter 
        int 21h
        ret
        
        negativo: ;Caso o valor do resultado da subtracao seja negativo:
        and bl,0Fh ;Conversao dos valores de bl e bh em numeros
        and bh,0Fh
        sub bh,bl ;Subtracao do maior numero pelo menor 
        or bh,30h ;Conversao do resultado da subtracao em numero 
        mov ah,02h
        mov dl,'-' ;Impressao do sinal de menos
        int 21h
        mov dl,bh ;Impressao do resultado da subtracao
        int 21h
        ret

    subtracaop endp ;Fim do procedimento de subtracao

    multiplicacaop proc ;Multiplica dois numeros (0 a 9)
                        ;Deslocamento e soma
        mov ah,02h
        mov dl,10
        int 21h

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero
        mov dl,'*'
        int 21h ;Sinal de multiplicacao
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade


    multiplicacaop endp ;Fim do procedimento de multiplicacao

    divisaop proc ;Divide dois numeros (0 a 9)
                  ;Deslocamento e subtracao
    
        mov ah,02h
        mov dl,10
        int 21h

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero
        mov dl,'/'
        int 21h ;Sinal de divisao
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade

        ;divisao
    divisaop endp ;Fim do procedimento de divisao

 end main ;FIM