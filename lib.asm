format PE dll

entry DllMain

include 'win32a.inc'


section '.data' data readable writable
        msg db 'DLL loaded!', 0xA, 0
        status rd 1


section '.code' code readable executable
        proc DllMain hInst, reason, reserved

                cmp [reason], DLL_PROCESS_ATTACH
                jne .end

                        push msg
                        call [printf]

        .end:

                mov [status], 1

                mov eax, status
                ret
        endp



section '.idata' import data readable
        library msvcrt, 'msvcrt.dll'

        import msvcrt,\
               printf, 'printf'

section '.reloc' fixups data discardable readable