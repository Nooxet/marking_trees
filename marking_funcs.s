section .data

printfmt db "%d", 0Ah, 0
ctr dd 0
N dd 8

; TEXT SEGMENT
section .text

global mark
global check
global getctr
global clrctr
global get_left
global get_right
global get_parent
global getn		; debug
global setn
global test		; debug

extern tree		; *tree defined in c file

test:
	push ebp
	mov ebp, esp
	mov ebx, [ebp+8]	; get val
	mov edi, [tree]		; get *tree
	mov DWORD [edi+ebx*8+4], 1	; tree[val].marked = 1
endtest:
	leave
	ret

; void mark(int val);
; marks the node with index = val
mark:
	push ebp
	mov ebp, esp
	push eax
	push ebx
	push ecx
	mov eax, [tree]				; get *tree
	mov ebx, [ebp+8]			; get val
	; eax + ebx*8 = tree[i].val
	mov ecx, [eax+ebx*8+4]		; get tree[val].marked
	cmp ecx, 1					; if marked = 1: return
	je endmark					;
	mov DWORD [eax+ebx*8+4], 1	; tree[val].marked = 1
	mov ecx, [ctr]				; else set marked = 1 and ctr++
	inc ecx
	mov [ctr], ecx

	push ebx
	call check					; check(val)
	add esp, 4

endmark:
	pop ecx
	pop ebx
	pop eax
	leave
	ret

; void check(int val);
; check other nodes to mark, recursively
check:
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	push edi
	push esi
	mov ebx, [ebp+8]		; get val
	mov edi, [tree]			; get *tree
	
	; get left child
	push ebx
	call get_left			; l = get_left(val)
	add esp, 4				; housekeeping
	
	cmp eax, 0				;
	je checkparent			; if l == 0, skip
	mov ecx, eax			; ecx = left child val (l)

	; get right child
	push ebx
	call get_right			; r = get_right(val)
	add esp, 4				; housekeeping

	; no need to check if r == 0
	mov edx, eax			; edx = right child val (r)

	; if (val marked AND left marked AND (NOT right marked))
	mov esi, [edi+ebx*8+4]	; get tree[val].marked
	cmp esi, 1
	jne if2
	mov esi, [edi+ecx*8+4]	; get tree[l].marked
	cmp esi, 1
	jne if2
	mov esi, [edi+edx*8+4]	; get tree[r].marked
	cmp esi, 0
	jne if2
	mov DWORD [edi+edx*8+4], 1	; set tree[r].marked = 1
	mov esi, [ctr]
	inc esi
	mov [ctr], esi			; ctr++
	
	push edx
	call check				; check(r)
	add esp, 4
	jmp checkparent

if2:
	mov esi, [edi+ebx*8+4]	; get tree[val].marked
	cmp esi, 1
	jne if3
	mov esi, [edi+ecx*8+4]	; get tree[l].marked
	cmp esi, 0
	jne if3
	mov esi, [edi+edx*8+4]	; get tree[r].marked
	cmp esi, 1
	jne if3
	mov DWORD [edi+ecx*8+4], 1	; set tree[l].marked = 1
	mov esi, [ctr]
	inc esi
	mov [ctr], esi			; ctr++
	
	push ecx
	call check				; check(l)
	add esp, 4
	jmp checkparent

if3:
	mov esi, [edi+ebx*8+4]	; get tree[val].marked
	cmp esi, 0
	jne checkparent
	mov esi, [edi+ecx*8+4]	; get tree[l].marked
	cmp esi, 1
	jne checkparent
	mov esi, [edi+edx*8+4]	; get tree[r].marked
	cmp esi, 1
	jne checkparent
	mov DWORD [edi+ebx*8+4], 1	; set tree[val].marked = 1
	mov esi, [ctr]
	inc esi
	mov [ctr], esi			; ctr++

	push ebx
	call check				; check(val)
	add esp, 4
	jmp checkparent

checkparent:

	mov esi, [edi+ebx*8+4]	; get tree[val].marked
	cmp esi, 0
	je endcheck				; return if not marked

	push ebx
	call get_parent			; get_parent(val)
	add esp, 4				; housekeeping
	
	cmp eax, 0				; if parent = 0, return
	je endcheck

	push eax
	call check				; check(p)
	add esp, 4


endcheck:
	pop esi
	pop edi
	pop edx
	pop ecx
	pop ebx
	leave
	ret

; int get_parent(int v);
; returns the parent idx, if such exist else 0
get_parent:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]	; get node val
	shr eax, 1			; val / 2 = parent index
	leave
	ret

; int get_left(int val);
; returns the left child, if such exists
get_left:
	push ebp
	mov ebp, esp
	push edi
	mov eax, [ebp+8]	; get node val
	shl eax, 1			; val = 1 * val
	mov edi, [N]		; get N
	cmp eax, edi		;
	jl endleft			; if val < N, return val
	mov eax, 0			; else return 0
endleft:
	pop edi
	leave
	ret

; int get_right(int val);
; returns the right child, if such exists
get_right:
	push ebp
	mov ebp, esp
	push edi
	mov eax, [ebp+8]	; get node val
	shl eax, 1			;
	inc eax				; val = 2 * val + 1
	mov edi, [N]		; get N
	cmp eax, edi		;
	jl endright			; if val <N, return val
	mov eax, 0			; else return 0
endright:
	pop edi
	leave
	ret

; int getctr();
; return the ctr value
getctr:
	push ebp
	mov ebp, esp
	mov eax, [ctr]
	leave
	ret

clrctr:
	push ebp
	mov ebp, esp
	mov DWORD [ctr], 0	; ctr = 0
	leave
	ret

; void setn(int n);
; set N to n
setn:
	push ebp
	mov ebp, esp
	mov eax, [ebp+8]
	mov [N], eax
	leave
	ret

getn:
	push ebp
	mov ebp, esp
	mov eax, [N]
	leave
	ret
