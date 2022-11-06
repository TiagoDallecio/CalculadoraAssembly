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
        xor cx,cx           ;SCROLL na tela e altera as cores do fundo e da fonte
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
        xor cx,cx                ;Altera as cores do fundo e da fonte
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

        mov ah,06h               
        xor al,al               
        xor cx,cx              
        mov dx,184fh             ;SCROLL na tela e altera as cores do fundo e da fonte
        mov bh,0dh              
        int 10h                 

        mov ah,09h
        lea dx,thanks ;Mensagem de creditos
        int 21h

        mov ah,4ch ;Encerramento do programa
        int 21h

    main endp;FIM DA MAIN

    somap proc ;Soma dois numeros (0 a 9)

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
        call pulalinha

        mov ah,02h
        mov dl,cl ;Impressao do caracter 
        int 21h
        mov ah,4ch ;Finalizacao do programa
        int 21h
        ret
        
        negativo: ;Caso o valor do resultado da subtracao seja negativo:
        and bl,0Fh ;Conversao dos valores de bl e bh em numeros
        int 21h
        mov dl,bh ;Impressao do resultado da subtracao
        int 21h
        mov ah,4ch ;Finalizacao do programa
        ret

    subtracaop endp ;Fim do procedimento de subtracao

    multiplicacaop proc ;Multiplica dois numeros (0 a 9)
                        ;Deslocamento e soma

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


    cmp ch,6
    je caso6
    cmp ch,7
    je caso7            ;jump para casos especificos
    cmp ch,8
    je caso8
    cmp ch,9
    je caso9




    mov al,ch
    xor ah,ah
    mov bl,2            ;divide por 2, quociente igual a numero de rotaçoes e resto igual a numero de somas
    div bl
    mov bl,al
    mov bh,ah
    mov dh,cl
  
    rotacao:

    shl cl,1            ;rotacionando 
    dec bl
    jnz rotacao
    inc bh
    sub cl,dh           ;evitando bug
    somando:
    
    add cl,dh           ;somando
    dec bh
    jnz somando

    jmp resp




    caso6:

    mov bl,2            ;contador

    rotacao1:           ;rotacao
    shl cl,1
    dec bl
    jnz rotacao1

    mov bh,2            ;contador

    somando1:
    add cl,dh           ;soma
    dec bh
    jnz somando1


    jmp resp            ;imprime resp



    caso7:

    mov bl,2            ;contador

    rotacao7:
    shl cl,1            ;rotacao
    dec bl
    jnz rotacao7

    mov bh,3            ;contador
    
    somando7:
    
    add cl,dh           ;soma
    dec bh
    jnz somando7


    jmp resp            ;imprime resposta

    
    
    caso8:

    mov bl,2            ;contador

    rotacao2:
    shl cl,1            ;rotaçao
    dec bl
    jnz rotacao2
    
    mov bh,4            ;contador

    somando2:
    add cl,dh
    dec bh              ;soma
    jnz somando2


    jmp resp            ;imprime resp


    caso9:

    mov bl,3            ;contador

    rotacao3:
    shl cl,1
    dec bl              ;rotacao
    jnz rotacao3

    mov bh,1            ;contador
    
    somando3:
    add cl,dh           ;soma
    dec bh
    jnz somando3


    jmp resp            ;imprime resp

    resp:
    
    cmp cl,10           ;compaa se maior q dez
    jae maiordez1 

    or cl,30h
    mov ah,02h
    mov dl,cl           ;imprime numeros menores que 10
    int 21h
    jmp fimmult

    maiordez1:             ;imprimido numeros maiores que 10

    mov al,cl               ;passa o resultado para al
    xor ah,ah               ;zera AH para deixar apenas o resultado em AX

    mov bl,10               ;prepara divisão por 10
    div bl

    mov bl,al               ;passando resultado da divisão para outros registradores
    mov bh,ah 
                  
    mov ah,02h
    or bl,30h
    mov dl,bl
    int 21h                 ;prepara e imprime os numeros, o quociente sendo as dezenas e o resto sendo as unidades
    mov ah,02h
    or bh,30h
    mov dl,bh
    int 21h

    fimmult:                
    call pulalinha

    ret
    multiplicacaop endp ;Fim do procedimento de multiplicacao

    divisaop proc ;Divide dois numeros (0 a 9)
                  ;Deslocamento e subtracao

        cmp ch,0
        je caso0            ;chama exceção, divisão por zero

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

        mov al,ch           ;salvando numeros para calculo do resto posteriormente
        mov bh,cl

        mov dh,5            ;contador
        xor cl,cl
        shl al,4
    back:
        shl cl,1            
        sub bl,al                  ;subtrai os valores e analisa o resto    
        js negativo2            
        or cl,1
        jmp positivo
    negativo2:
        or cl,0                     ;restaura os valores a subtração e
        add bl,al                   ;transforma o bit menos significativo em 0

    positivo:
        shr al,1                    ;transforma o bit mais a direita em 1

        dec dh                      
        cmp dh,0                    ;controla o sistema de loop
        jnz back

        mov ah,02h
        or cl,30h                    ;imprime resultado
        mov dl,cl
        int 21h

        call pulalinha

        and cl,0fh
        xor ax,ax                   ;executando equação para achar o resto
        mov al,cl
        mul ch
        sub bh,al
        
        lea dx,resto
        mov ah,09h      ;imprime string
        int 21h
        
        mov ah,02h
        or bh,30h                   ;imprime o resto
        mov dl,bh
        int 21h

        call pulalinha
        
        ret
    jmp fimdiv

    caso0:

        lea dx,next
        mov ah,09h      ;imprime string
        int 21h

        jmp fimdiv

    fimdiv:

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