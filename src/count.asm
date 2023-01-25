.model huge
assume cs:code, ds:data, ss:stack

data segment

data ends

stack segment
    db 0ffh dup(0)
stack ends

code segment
start:
code ends
end start
