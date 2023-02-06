; Autor reseni: Nikita Pasynkov xpasyn00

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; r10-r6-r23-r7-r0-r4
; p:+16, a:-1

; DATA SEGMENT
                .data
login:          .asciiz "xpasyn00"  ; sem doplnte vas login
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:
    daddi   r4, r0, login   ; vozrovy vypis: adresa login: do r4

    init:
        daddi r6, r0, 0
        daddi r7, r0, 1

    while:
        lb r10,login(r6)

        slti r23, r10, 97
        bnez r23, finish

        beqz r7, minus

    plus:
        daddi r7, r7, -1

        daddi r10, r10, 16
        slti r23, r10, 121
        beqz r23, if_too_big

        j char_out

    if_too_big:
        daddi r10, r10, -26

        j char_out

    minus:
        daddi r7, r7, 1

        daddi r10, r10, -1
        slti r23, r10, 97
        bnez r23, if_too_small

        j char_out

    if_too_small:
        daddi r10, r10, 26

        j char_out

    char_out:
        sb r10, cipher(r6)
        addi r6, r6, 1

        j while

    finish:
        daddi   r4, r0, cipher   ; vozrovy vypis: adresa login: do r4                    jal     print_string    ; vypis pomoci print_string - viz nize
        jal     print_string    ; vypis pomoci print_string - viz nize
        syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
