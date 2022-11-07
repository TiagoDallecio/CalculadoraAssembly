; TITLE Tiago Dallecio 22001336 Renan Rohers

.model small

.stack 100h

.data
    barra db"===============================================================================",'$'
    hello db "                                Bem vindo!",'$'
    num1 db "Insira o primeiro numero da operacao:",'$'
    num2 db "Insira o segundo numero da operacao:",'$'
    op db "Insira a operacao desejada(+, -, *, /):",'$'
    repmulti db "Resultado igual a: ",'$'
    reset db "Deseja fazer outra conta? (y/n)",'$'
    thanks db "                            Obrigado, tenha um bom dia!                                                Made by Tiago Dallecio & Renan Rohers",'$'
    espaco db "                   ",'$'
    next db "Este tipo de operacao nao existe",'$'
    resto db "Resto:",'$'

.code 
    main proc

        mov ax,@data        ;inicializa data
        mov ds,ax

        mov ah,06h
        xor al,al
        xor cx,cx
        mov dx,184fh
        mov bh,0eh
        int 10h

        lea dx,barra
        mov ah,09h      ;imprime string
        int 21h

        call pulalinha

        call pulalinha


        lea dx,hello
        mov ah,09h      ;imprime string
        int 21h

        call pulalinha

        call pulalinha

        lea dx,barra
        mov ah,09h      ;imprime string
        int 21h

        call pulalinha

        mov ah,06h
        mov al,1
        xor cx,cx
        mov dx,184fh
        mov bh,03h
        int 10h

        inicio:

        call pulalinha

        lea dx,num1
        mov ah,09h      ;imprime string
        int 21h
        mov ah,01h
        int 21h         ;ler caracter do buffer
        mov bl,al

        call pulalinha

        lea dx,num2
        mov ah,09h      ;imprime string
        int 21h
        mov ah,01h
        int 21h         ;ler caracter do buffer
        mov bh,al

        call pulalinha
        
        lea dx,op
        mov ah,09h      ;imprime string
        int 21h
        mov ah,01h      ;ler caracter do buffer
        int 21h
        
        mov dh,al


        call pulalinha

        
        mov cl,bl ;Salvando o valor armazenado em bl em cl para, futuramente, executar a operacao
        mov ch,bh ;O mesmo do de cima 

        
        cmp dh,'+' ;Comparando o valor retornado em al com o caracter '+'
        je soma ;Caso o valor digitado seja igual a '+', pula para 'soma'
        
        cmp dh,'-' ;Comparando o valor retornado em al com o caracter '-'
        je subtracao ;Caso o valor digitado seja igual a '-', pula para 'subtracao'

        
        cmp dh,'*' ;Comparando o valor retornado em al com o caracter '*'
        je multiplicacao ;Caso o valor digitado seja igual a '*', pula para 'multiplicacao' 

        cmp dh,'/' ;Comparando o valor retornado em al com o caracter '/'
        je divisao ;Caso o valor digitado seja igual a '/', pula para 'divisao'

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

        call pulalinha

        mov ah,09h
        lea dx,reset ;Mensagem da pergunta
        int 21h

        mov ah,01h ;Leitura da resposta do usuario, 'y/n'
        int 21h

        cmp al,'y' 
        je inicio ;Caso a resposta do usuario seja sim, retorna ao inicio

        call pulalinha

        mov ah,06h               ;mudando a cor e dando scroll
        xor al,al               
        xor cx,cx              
        mov dx,184fh            
        mov bh,0dh              
        int 10h                 

        mov ah,09h
        lea dx,thanks ;Mensagem de creditos
        int 21h

        mov ah,4ch ;Encerramento do programa
        int 21h

    main endp;FIM DA MAIN

    somap proc ;Soma dois numeros (0 a 9)
        ;o primeiro numero digitado chega em dois registradores, cl e bl
        ;o segundo numero digitado chega em dois registradores, ch e bh
        ;o codigo faz a soma dos dois valores e se a soma for menor que 10, 
        ;o resultado estara presente no registrador ch
        ;caso maior que 10, as dezenas estarão alocadas no registrador al e as unidades em bh

        call pulalinha

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero 
        mov dl,'+'
        int 21h ;Sinal de soma
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade
        
        
        add ch,cl ;Soma dos valores numericos guardados anteriormente
        
        cmp ch,10
        jae maiorqdez



        or ch,30h ;Conversao para caracter para a impressao
        mov ah,02h
        mov dl,ch
        int 21h ;Impressao do resultado

        mov ah,4ch ;Finalizacao do programa
        int 21h


        maiorqdez:
        and bl,0fh     ;alterando valores para executar operaçoes logicas
        and bh,0fh

        add bh,bl ;Soma dos valores numericos guardados anteriormente
        mov ax,bx ;salvando valores de bx em ax
        mov bl,10 ;passando 10 que sera utilizado para dividir, pois div so funcioa com registrador
        
        mov al,ah; passando valor a ser dividido para al 
        xor ah,ah ;zera ah para receber instruçoes
        div bl  ;divide
        mov bh,ah 
        mov ah,02h 
        or al,30h ;prepaando e imprimindo quociente
        mov dl,al
        int 21h

        or bh,30h;preparando e imprimindo o resto
        mov dl,bh
        int 21h

        call pulalinha

        ret
    somap endp ;Fim do prodcedimento de soma

        mov ah,4ch ;Finalizacao do programa
        int 21h


    subtracaop proc ;Subtrai dois numeros (0 a 9)
        ;o primeiro numero digitado chega em dois registradores, cl e bl
        ;o segundo numero digitado chega em dois registradores, ch e bh
        ;o codigo faz a subtração do primeiro numero pelo o segundo,
        ;armazenando o resultado no registrador bh
        call pulalinha

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
        ;o primeiro numero digitado chega em dois registradores, cl e bl
        ;o segundo numero digitado chega em dois registradores, ch e bh  
        ;o codigo faz a multiplicação atraves de deslocamentos e somas
        ;o resultado final esta em ax caso menor que 10, caso contrario
        ;as dezenas estarão em dh, e as unidades em dl
        call pulalinha

        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero
        mov dl,'*'
        int 21h ;Sinal de divisao
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade


    and cl,0fh
    and bl,0fh
    and ch,0fh          ;conversao para executar operaçoes algebricas
    and bh,0fh
    mov dh,cl

        mov bl,ch
        xor ch,ch
        xor dx,dx
        

        xor ax,ax
        mov dh,4

    volta5:    
            shr bl, 1
            jnc volta6
    
            add ax,cx

        volta6:
            shl cx, 1
            
            dec dh
            jnz volta5


     
    
    cmp ax,10           ;compaa se maior q dez
    jae maiordez1 

    or ax,30h
    mov ah,02h
    mov dx,ax         ;imprime numeros menores que 10
    
    int 21h
    jmp fimmult

    maiordez1:             ;imprimido numeros maiores que 10

        mov bl,10
        div bl
        mov dl,al
        mov dh,ah

        mov ah,02h
        or dl,30h
        int 21h
        mov dl,dh
        or dl,30h
        int 21h

    fimmult:
    call pulalinha

    ret
    multiplicacaop endp ;Fim do procedimento de multiplicacao

    divisaop proc ;Divide dois numeros (0 a 9)
        ;o primeiro numero digitado chega em dois registradores, cl e bl
        ;o segundo numero digitado chega em dois registradores, ch e bh  
        ;o codigo divide o primeiro numero pelo segundo, atraves de deslocamentos, somas e subtraçoes
        ;o resto tambem é informado, e descoberto por meio de uma equação


        and ch,0fh
        cmp ch,0
        je caso0
        or ch,30h

        call pulalinha
        
        mov dl,bl ;Impressao da operacao ('numero' 'sinal' 'numero' 'igual' 'resultado')
        int 21h ;Primeiro numero
        mov dl,'/'
        int 21h ;Sinal de divisao
        mov dl,bh
        int 21h ;Segundo numero
        mov dl,'='
        int 21h ;Sinal de igualdade

        and cl,0fh
        and bl,0fh
        and ch,0fh          ;conversao para executar operaçoes algebricas
        and bh,0fh

        mov dh,5
        xor cl,cl
        shl ch,4
    back:
        shl cl,1
        sub bl,ch
        
        js negativo2
        or cl,1

        jmp positivo
    negativo2:
        
        add bl,ch
    positivo:
        shr ch,1

        dec dh
        cmp dh,0            ;controlando contador
        jnz back

        mov ah,02h
        or cl,30h           ;prepara e imprime o resultado
        mov dl,cl
        int 21h

        ret
    jmp fimdiv

    caso0:

        lea dx,next
        mov ah,09h      ;imprime string
        int 21h

        jmp fimdiv

    fimdiv:

        call pulalinha
        call pulalinha

        ret
    divisaop endp ;Fim do procedimento de divisao


    pulalinha proc

    mov ah,02h
    mov dl,10
    int 21h

    ret
    
    pulalinha endp

 end main ;FIM