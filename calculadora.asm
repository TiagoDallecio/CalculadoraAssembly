; TITLE Tiago Dallecio 22001336 Renan Rohers

.model small

.stack 100h

.data
    hello db "Bem vindo!",'$'
    num1 db "Insira o primeiro numero da operacao:",'$'
    num2 db "Insira o segundo numero da operacao:",'$'
    op db "Insira a operacao desejada(+, -, *, /):",'$'
    repmulti db "Resultado igual a: ",'$'
    reset db "Deseja fazer outra conta? (y/n)",'$'
    thanks db "Obrigado, tenha um bom dia!   Made by Tiago Dallecio & Renan Rohers",'$'

.code 
    main proc

        mov ax,@data
        mov ds,ax

        

        lea dx,hello
        mov ah,09h
        int 21h

        mov ah,02h
        mov dl,10
        int 21h


        inicio:

        mov ah,02h
        mov dl,10
        int 21h

        lea dx,num1
        mov ah,09h
        int 21h
        mov ah,01h
        int 21h
        mov bl,al

        mov ah,02h
        mov dl,10
        int 21h

        lea dx,num2
        mov ah,09h
        int 21h
        mov ah,01h
        int 21h
        mov bh,al

        mov ah,02h
        mov dl,10
        int 21h
        
        lea dx,op
        mov ah,09h
        int 21h
        mov ah,01h
        int 21h
        
        mov dh,al


        mov ah,02h
        mov dl,10
        int 21h

        
        mov cl,bl ;Salvando o valor armazenado em bl em cl para, futuramente, executar a operacao
        mov ch,bh ;O mesmo do de cima 


        
        cmp dh,'+' ;Comparando o valor retornado em al com o caracter '+'
        je soma ;Caso o valor digitado seja igual a '+', pula para 'soma'
        
        cmp dh,'-' ;Comparando o valor retornado em al com o caracter '-'
        je subtracao ;Caso o valor digitado seja igual a '-', pula para 'subtracao'

        
        cmp dh,'*' ;Comparando o valor retornado em al com o caracter '*'
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

        ret
    somap endp ;Fim do prodcedimento de soma

        mov ah,4ch ;Finalizacao do programa
        int 21h


    subtracaop proc ;Subtrai dois numeros (0 a 9)
        mov ah,02h
        mov dl,10
        int 21h
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




    and cl,0fh
    and bl,0fh
    and ch,0fh
    and bh,0fh
    mov dh,cl
    cmp ch,6
    je caso6
    cmp ch,7
    je caso7
    cmp ch,8
    je caso8
    cmp ch,9
    je caso9




    mov al,ch
    xor ah,ah
    mov bl,2
    div bl
    mov bl,al
    mov bh,ah
    mov dh,cl
  
    rotacao:

    shl cl,1


    dec bl
    jnz rotacao
    inc bh
    sub cl,dh
    somando:
    
    add cl,dh
    dec bh
    jnz somando

    jmp resp




    caso6:

    mov bl,2
    rotacao1:
    shl cl,1


    dec bl
    jnz rotacao1
    mov bh,2
    somando1:
    
    add cl,dh
    dec bh
    jnz somando1


    jmp resp



    caso7:

    mov bl,2
    rotacao7:
    shl cl,1


    dec bl
    jnz rotacao7
    mov bh,3
    somando7:
    
    add cl,dh
    dec bh
    jnz somando7


    jmp resp





    
    
    caso8:

    mov bl,2
    rotacao2:
    shl cl,1


    dec bl
    jnz rotacao2
    mov bh,4
    somando2:
    
    add cl,dh
    dec bh
    jnz somando2


    jmp resp



    caso9:

    mov bl,3
    rotacao3:
    shl cl,1


    dec bl
    jnz rotacao3
    mov bh,1
    somando3:
    
    add cl,dh
    dec bh
    jnz somando3


    jmp resp





    resp:
    
    lea dx,repmulti
    mov ah,09h
    int 21h
    

    cmp cl,10
    jae maiordez1 


    or cl,30h
    mov ah,02h
    mov dl,cl
    int 21h
    jmp fimmult

    maiordez1:

    mov al,cl
    xor ah,ah
    mov bl,10
    div bl
    mov bl,al
    mov bh,ah
    mov ah,02h
    or bl,30h
    mov dl,bl
    int 21h
    mov ah,02h
    or bh,30h
    mov dl,bh
    int 21h


    fimmult:
    ret
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