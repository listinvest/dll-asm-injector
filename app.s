format PE console

entry start

include 'win32a.inc'


section '.data' data readable writable
        msg db 'Print from app', 0xA, 0


section '.code' code readable executable
        start:
                push msg
                call [printf]

                call [getch]

                push 0
                call [ExitProcess]



section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'