bits 16
org 0x7C00
jmp short start
BootDrive db 0

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [BootDrive], dl

    mov ah, 0x02      ; leitura CHS
    mov al, 1        ; quantidade de setores (começa pequeno pra testar)
    mov ch, 0         ; cilindro 0
    mov cl, 2         ; setor 2 (setor 1 é o próprio boot)
    mov dh, 0         ; cabeça 0
    mov dl, [BootDrive]
    mov bx, 0x8000    ; destino

    int 0x13
    jc disk_error

    jmp 0x0000:0x8000  ; salta pro kernel carregado

disk_error:
    mov si, msg_erro        ; Coloca o endereço da mensagem em SI
    mov ah, 0x0E            ; Função Teletype da BIOS (imprimir caractere)

.loop_print:
    lodsb                   ; Carrega o byte de [SI] em AL e avança SI em +1
    cmp al, 0               ; Verifica se chegou ao fim da string (caractere 0)
    je hang                 ; Se for 0, para o código no loop infinito
    int 0x10                ; Se não for 0, imprime o caractere que está em AL
    jmp .loop_print         ; Avança para o próximo caractere

hang:
    jmp hang

; =====================================================================
; SEÇÃO DE DADOS (Abaixo do código, mas ANTES da assinatura de boot)
; =====================================================================
; 13, 10 serve para pular linha (CRLF). O 0 indica o fim do texto.
msg_erro: db "nukVM : disk_error, try again", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55