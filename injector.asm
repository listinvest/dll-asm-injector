format PE console

entry start

include 'win32a.inc'


section '.data' data readable writable
        fmt_str db '%s', 0
        fmt_int db '%d', 0

        str_pid db 'PID: ', 0
        str_dll db 'DLL: ', 0
        str_injected db 'Injected!', 0xA, 0

        str_load_lib db 'LoadLibraryA', 0
        str_kernel32 db 'kernel32.dll', 0

        dll_name rb 256
        dll_len rd 1

        alloc_right rd 1

        pid rd 1
        hProc rd 1
        hAsdc rd 1
        hKernel rd 1
        last_err rd 1
        load_lib_addr rd 1
        dereercomp rd 1





section '.code' code readable executable
        start:
                push str_pid
                call [printf]

                push pid
                push fmt_int
                call [scanf]

                push [pid]
                push 0
                push PROCESS_ALL_ACCESS
                call [OpenProcess]

                mov [hProc], eax

                cmp [hProc], 0
                je .end

                        push str_dll
                        call [printf]

                        push dll_name
                        push fmt_str
                        call [scanf]

                        push dll_name
                        call [strlen]

                        mov [dll_len], eax

                        push str_kernel32
                        call [GetModuleHandleA]

                        mov [hKernel], eax

                        push str_load_lib
                        push [hKernel]
                        call [GetProcAddress]

                        mov [load_lib_addr], eax

                        mov [alloc_right], MEM_RESERVE
                        or [alloc_right], MEM_COMMIT

                        push PAGE_READWRITE
                        push [alloc_right]
                        push [dll_len]
                        push 0
                        push [hProc]
                        call [VirtualAllocEx]

                        mov [dereercomp], eax

                        push 0
                        push [dll_len]
                        push dll_name
                        push [dereercomp]
                        push [hProc]
                        call [WriteProcessMemory]

                        push 0
                        push 0
                        push [dereercomp]
                        push [load_lib_addr]
                        push 0
                        push 0
                        push [hProc]
                        call [CreateRemoteThread]

                        mov [hAsdc], eax

                        cmp [hAsdc], 0
                        je .clear

                                push 0xffffffff
                                push [hAsdc]
                                call [WaitForSingleObject]


                                push MEM_RELEASE
                                push [dll_len]
                                push dereercomp
                                push [hProc]
                                call [VirtualFreeEx]

                                push [hAsdc]
                                call [CloseHandle]

                                push str_injected
                                call [printf]


                .clear:

                        push [hProc]
                        call [CloseHandle]


        .end:

                call [getch]

                push 0
                call [ExitProcess]

section '.idata' import data readable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               OpenProcess, 'OpenProcess',\
               CloseHandle, 'CloseHandle',\
               GetLastError, 'GetLastError',\
               GetModuleHandleA, 'GetModuleHandleA',\
               GetProcAddress, 'GetProcAddress',\
               VirtualAllocEx, 'VirtualAllocEx',\
               VirtualFreeEx, 'VirtualFreeEx',\
               WriteProcessMemory, 'WriteProcessMemory',\
               CreateRemoteThread, 'CreateRemoteThread',\
               WaitForSingleObject, 'WaitForSingleObject'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf',\
               strlen, 'strlen'