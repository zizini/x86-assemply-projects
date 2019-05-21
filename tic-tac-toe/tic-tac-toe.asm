Title TicTacToe
Data Segment
     space db "	",10,13,"$"
     msg1 db 10,13,"			--	TIC- TAC- TOE	--",10,13,"$"  
     win db "		",09,"    WINNERS!!! $"
     msg2 db 10,13,"For one player press 1. For two players press 2.$"  
     num_of_players db 0  
     name1 db 10,13,"1st player's name: $"
     player1 db 20 dup(0) 
     name2 db 10,13,"2nd player's name: $"
     player2 db 20 dup(0)  
     msgx db 10,13,"Give position x: $"  
     msgy db 10,13,"Give position y: $"
     x db 0
     y db 0     
     winner_temp db 0
     temp db 9 dup(0)  
     x_y db 9 dup(0)             
     wrong db "	Wrong position! $"
     file1 db "c:\test1\file1.txt"
     handle dw ?
     array  100 dup(0) 
     drawmsg db 10,13,"DRAW!!! $" 
     winmsg db 10,13,"WINNER IS: $"
     computer db 10,13,"Computer $"
     endx db 13
Data Ends   
Code Segment
Start:
    MOV AX, Data
    MOV DS, AX
       
       LEA DX,msg1
       MOV AH,9
       INT 21H  
       
       LEA DX,space
       MOV AH,9
       INT 21H 
       
       LEA DX,win
       MOV AH,9
       INT 21H         
               
       LEA DX,space
       MOV AH,9
       INT 21H
               
       call read_file
       
       LEA DX,space
       MOV AH,9
       INT 21H
            
       wrong1 : 
       LEA DX,msg2
       MOV AH,9
       INT 21H    
       
       MOV AH,08
       INT 21H
       SUB AL,30h            
       
       MOV num_of_players, AL
       
       CMP AL,2
       JE  players2    
       
       CMP AL,1      
       JE  players1
       
       JMP wrong1 

       players1:
       call readname1  
       call play 
       jmp end_game
       
       players2:         
        call readname1 
        call readname2 
        call play2
        
        end_game:
          
    MOV AH, 4CH
    INT 21H  
    winner PROC 
    	MOV AL,1 
    	find_winner:
    	cmp x_y[0],AL
    	je A1  
    	jne B
    	
    	A1:
    	cmp x_y[1],AL 
    	je A11
    	jne A2
    	
    	A11: 
    	cmp x_y[2],AL
    	je winner_is 
    	jne A2
    	
    	A2: 
    	cmp x_y[3],AL
    	je A22
    	jne A3  
    	
    	A22:
    	cmp x_y[6],Al
    	je winner_is
    	jne B
    	
    	A3: 
    	cmp x_y[4],AL
    	je A33
    	jne B
	
	A33:
	cmp x_y[8],AL
    	je winner_is 
    	jne B
    	
    	B:
    	cmp x_y[1],AL
    	je B1 
    	jne C
    	
    	B1:
    	cmp x_y[4],AL
    	je B11
    	jne C 
    	
    	B11:
    	cmp x_y[7],AL
    	je winner_is 
    	jne C 
    	
    	C: 
    	cmp x_y[2],AL
    	je C1 
    	jne D
    	
    	C1:
    	cmp x_y[4],AL
    	je C11
    	jne C2 
    	
    	C11:
    	cmp x_y[6],AL
    	je winner_is 
    	jne C2
    	
    	C2:
    	cmp x_y[5],AL
    	je C22
    	jne D 
    	
    	C22:
    	cmp x_y[8],AL
    	je winner_is
    	
    	D:   
    	cmp x_y[3],AL
    	je D1
    	jne E
    	
    	D1:
    	cmp x_y[4],AL
    	je D11
    	jne E 
    	
    	D11:
    	cmp x_y[5],AL
    	je winner_is
    	
    	E:
    	cmp x_y[6],AL
    	je E1 
    	jne end_winner
    	
    	E1:
    	cmp x_y[7],AL
    	je E11
    	jne end_winner 
    	
    	E11:
    	cmp x_y[8],AL
    	je winner_is
    	jne end_winner    	
    	
    	winner_is:
    	MOV winner_temp, AL
    	
    	end_winner:
    	ADD Al,1
    	cmp Al,3
    	jne find_winner 
    	
    	ret
    winner ENDP
    
    play PROC
       call setgraphicsmode 
       call createtable
       call position00 
       MOV x_y[0],1
       
       MOV SI,0  
       
       start_loop_play:
         cmp SI,1
         je player_ask 
         cmp SI,2
         je auto_player
         cmp SI,3
         je player_ask
         cmp SI,4
         je auto_player
         cmp SI,5
         je player_ask
         cmp SI,6
         je auto_player
         cmp SI,7
         je player_ask
         cmp SI,8
         je auto_player
         jmp end_start_loop_play       
       
       player_ask:
         call find_position 
         MOV DI,0
         player_play:
         cmp x_y[di],2
         je callposp
         jne end_player_p
         callposp:     
           cmp di,1 
           je tempp1
           cmp di,2 
       	 je tempp2   
       	 cmp di,3
       	 je tempp3   
       	 cmp di,4
           je tempp4
       	 cmp di,5
       	 je tempp5          
       	 cmp di,6
       	 je tempp6           
       	 cmp di,7
       	 je tempp7           
       cmp di,8
       je tempp8   
           
       tempp1:
       cmp temp[di],0
       je dip1
       jne end_player_p  
           
       tempp2:
       cmp temp[di],0
       je dip2
       jne end_player_p  
           
       tempp3:
       cmp temp[di],0
       je dip3
       jne end_player_p
                  
       tempp4:
       cmp temp[di],0
       je dip4
       jne end_player_p 
           
       tempp5:
       cmp temp[di],0
       je dip5
       jne end_player_p 
           
       tempp6:
       cmp temp[di],0
       je dip6
       jne end_player_p 
           
       tempp7:
       cmp temp[di],0
       je dip7
       jne end_player_p
           
       tempp8:
       cmp temp[di],0
       je dip8
       jne end_player_p 
       
       dip1: 
       MOV temp[di],1           
       call cross01
       jmp end_start_loop_play
       dip2:  
       MOV temp[di],1 
       call cross02
       jmp end_start_loop_play
       dip3:
       MOV temp[di],1  
       call cross10 
       jmp end_start_loop_play
       dip4:  
       MOV temp[di],1          
       call cross11
       jmp end_start_loop_play
       dip5: 
       MOV temp[di],1           
       call cross12
       jmp end_start_loop_play
       dip6: 
       MOV temp[di],1        
       call cross20 
       jmp end_start_loop_play          
       dip7:  
       MOV temp[di],1          
       call cross21 
       jmp end_start_loop_play
       dip8: 
       MOV temp[di],1           
       call cross22
       jmp end_start_loop_play
           
       end_player_p:
       INC DI
       cmp DI,9  
       je  end_start_loop_play
       jne player_play   
       
       auto_player: 
       MOV DI,1
       loop_auto:
       cmp x_y[di],0
       je callposa
       jne end_player
       callposa: 
           
       cmp di,1 
       je tempa1
           
       cmp di,2 
       je tempa2
           
       cmp di,3
       je tempa3 
           
       cmp di,4
       je tempa4
           
       cmp di,5
       je tempa5
           
       cmp di,6
       je tempa6
           
       cmp di,7
       je tempa7
           
       cmp di,8
       je tempa8  
           
       tempa1: 
       cmp temp[di],0
       je dia1
       jne end_player  
           
       tempa2:
       cmp temp[di],0
       je dia2
       jne end_player  
           
       tempa3:
       cmp temp[di],0
       je dia3
       jne end_player
       
       tempa4:
       cmp temp[di],0
       je dia4
       jne end_player
          
       tempa5:
       cmp temp[di],0
       je dia5
       jne end_player 
           
       tempa6:
       cmp temp[di],0
       je dia6
       jne end_player 
           
       tempa7:
       cmp temp[di],0
       je dia7
       jne end_player
           
       tempa8:
       cmp temp[di],0
       je dia8
       jne end_player 
       
       dia1: 
       MOV temp[di],1 
       MOV x_y[di],1         
       call position01
       jmp end_start_loop_play
       dia2:  
       MOV temp[di],1 
       MOV x_y[di],1
       call position02
       jmp end_start_loop_play
       dia3: 
       MOV temp[di],1
       MOV x_y[di],1
       call position10 
       jmp end_start_loop_play
       dia4:  
       MOV temp[di],1 
       MOV x_y[di],1        
       call position11
       jmp end_start_loop_play
       dia5:  
       MOV temp[di],1 
       MOV x_y[di],1        
       call position12
       jmp end_start_loop_play
       dia6:  
       MOV temp[di],1 
       MOV x_y[di],1     
       call position20 
       jmp end_start_loop_play          
       dia7: 
       MOV temp[di],1 
       MOV x_y[di],1         
       call position21 
       jmp end_start_loop_play
       dia8:  
       MOV temp[di],1 
       MOV x_y[di],1        
       call position22
       jmp end_start_loop_play
       end_player:
       INC DI
       cmp DI,9
       jne loop_auto
       
       end_start_loop_play:
       INC SI
       call winner
           cmp winner_temp,1
           je endplay11 
           
           cmp winner_temp,2
           je endplay21
         
       	 cmp SI,9 
       	 call winner
	 
	 cmp winner_temp,1
           je endplay11
	
	 cmp winner_temp,2
        	 je endplay12
	
           cmp SI,9          
           je end_loop_play
       	 jne start_loop_play
          
	 endplay11:
           call setgraphicsmode
           LEA DX,winmsg
       	 MOV AH,9
       	 INT 21H 
       	 LEA DX,computer
       	 MOV AH,9
       	 INT 21H            
       	 call write_file_computer
       	 jmp end_loop_play_end  
       	 
	 endplay12:
           call setgraphicsmode
           LEA DX,winmsg
       	 MOV AH,9
       	 INT 21H  
       	 call print_player_1 
       	 call write_file_player1
       	 jmp end_loop_play_end
      
       end_loop_play:
       	 call setgraphicsmode 
	 LEA DX,drawmsg
       	 MOV AH,9
       	 INT 21H 
       	 
       end_loop_play_end:
       
    ret   
    play ENDP
    
    play2 PROC
        MOV SI,0 
        call setgraphicsmode 
        call createtable   
        
        gameplayers: 

           call find_position 
           
           MOV DI,0 
           loopn:                   
           cmp x_y[di],0
           je endloopn
           
           cmp x_y[di],1 
           je callposx
           
           cmp x_y[di],2
           je callposy
           
           jmp endloopn 
           
           callposx:
           cmp di,0 
           je tempx0
                     
           cmp di,1 
           je tempx1
           
           cmp di,2 
           je tempx2
           
           cmp di,3
           je tempx3 
           
           cmp di,4
           je tempx4
           
           cmp di,5
           je tempx5
           
           cmp di,6
           je tempx6
           
           cmp di,7
           je tempx7
           
           cmp di,8
           je tempx8 
           
           tempx0:
           cmp temp[di],0
           je dix0
           jne endloopn 
           
           tempx1:
           cmp temp[di],0
           je dix1
           jne endloopn  
           
           tempx2:
           cmp temp[di],0
           je dix2
           jne endloopn  
           
           tempx3:
           cmp temp[di],0
           je dix3
           jne endloopn
                  
           tempx4:
           cmp temp[di],0
           je dix4
           jne endloopn 
           
           tempx5:
           cmp temp[di],0
           je dix5
           jne endloopn 
           
           tempx6:
           cmp temp[di],0
           je dix6
           jne endloopn 
           
           tempx7:
           cmp temp[di],0
           je dix7
           jne endloopn
           
           tempx8:
           cmp temp[di],0
           je dix8
           jne endloopn
           
           dix0:  
           MOV temp[di],1
           call position00 
           jmp endloopn
           dix1: 
           MOV temp[di],1          
           call position01
           jmp endloopn
           dix2:  
           MOV temp[di],1
           call position02
           jmp endloopn
           dix3: 
           MOV temp[di],1
           call position10 
           jmp endloopn
           dix4:  
           MOV temp[di],1         
           call position11
           jmp endloopn
           dix5:  
           MOV temp[di],1         
           call position12
           jmp endloopn
           dix6:  
           MOV temp[di],1      
           call position20 
           jmp endloopn          
           dix7: 
           MOV temp[di],1          
           call position21 
           jmp endloopn
           dix8:  
           MOV temp[di],1         
           call position22
           jmp endloopn
           
           callposy:
           cmp di,0
           je tempy0
           
           cmp di,1 
           je tempy1
           
           cmp di,2 
           je tempy2
           
           cmp di,3
           je tempy3 
           
           cmp di,4
           je tempy4
           
           cmp di,5
           je tempy5
           
           cmp di,6
           je tempy6
           
           cmp di,7
           je tempy7
           
           cmp di,8
           je tempy8   
           
           tempy0:
           cmp temp[di],0
           je diy0
           jne endloopn 
           
           tempy1:
           cmp temp[di],0
           je diy1
           jne endloopn  
           
           tempy2:
           cmp temp[di],0
           je diy2
           jne endloopn  
           
           tempy3:
           cmp temp[di],0
           je diy3
           jne endloopn
                  
           tempy4:
           cmp temp[di],0
           je diy4
           jne endloopn 
           
           tempy5:
           cmp temp[di],0
           je diy5
           jne endloopn 
           
           tempy6:
           cmp temp[di],0
           je diy6
           jne endloopn 
           
           tempy7:
           cmp temp[di],0
           je diy7
           jne endloopn
           
           tempy8:
           cmp temp[di],0
           je diy8
           jne endloopn
           
           diy0: 
           MOV temp[di],1 
           call cross00 
           jmp endloopn
           diy1: 
           MOV temp[di],1           
           call cross01
           jmp endloopn
           diy2:  
           MOV temp[di],1 
           call cross02
           jmp endloopn
           diy3:
           MOV temp[di],1  
           call cross10 
           jmp endloopn
           diy4:  
           MOV temp[di],1          
           call cross11
           jmp endloopn
           diy5: 
           MOV temp[di],1           
           call cross12
           jmp endloopn
           diy6: 
           MOV temp[di],1        
           call cross20 
           jmp endloopn          
           diy7:  
           MOV temp[di],1          
           call cross21 
           jmp endloopn
           diy8: 
           MOV temp[di],1           
           call cross22
           jmp endloopn 
           
           endloopn:
           INC DI
           cmp DI,9
           jne loopn
            
           INC SI 
           
           call winner
	 
	 cmp winner_temp,1
           je endplay21
	
	 cmp winner_temp,2
        	 je endplay22
	
           cmp SI,9          
           je endplay
           jne gameplayers
          
	 endplay21:
           call setgraphicsmode
           LEA DX,winmsg
       	 MOV AH,9
       	 INT 21H 
       	 call print_player_1  
       	 call write_file_player1
       	 jmp endplay_end
	 endplay22:
           call setgraphicsmode
           LEA DX,winmsg
       	 MOV AH,9
       	 INT 21H 
       	 call  print_player_2 
       	 ;,call write_file_player2
       	 jmp endplay_end
           endplay: 
	 call setgraphicsmode 
	 LEA DX,drawmsg
       	 MOV AH,9
       	 INT 21H      

	 endplay_end: 
     ret	        
    play2 ENDP 
    
    print_player_1 PROC  
        mov di,0	
    	startloop1b:
 	mov al,player1[di]    ;pare ton xarakthra apo th 8esh mnhmhs buffer[di]
 	inc di     
	
 	mov dl,al
 	mov ah,2h
 	int 21h
 	cmp di,si     
          jb startloop1b
     ret
    print_player_1 ENDP
    
    print_player_2 PROC  
        mov di,0	
    	startloop2b:
 	mov al,player2[di]    ;pare ton xarakthra apo th 8esh mnhmhs buffer[di]
 	inc di     
	
 	mov dl,al
 	mov ah,2h
 	int 21h
 	cmp di,si     
          jb startloop2b
     ret
    print_player_2 ENDP
    
    find_position PROC  
    	start_find:
    	call xpos
    	call ypos
    	
    	cmp x,30h   
          je yposcmp0  
          
          cmp x,31h   
          je yposcmp1
          
          cmp x,32h   
          je yposcmp2
          
          yposcmp0:
          cmp y,30h
          je call00  
          
          cmp y,31h
          je call01
          
          cmp y,32h 
          je call02  
          
          yposcmp1:
          cmp y,30h
          je call10
          
          cmp y,31h
          je call11
          
          cmp y,32h 
          je call12  
          
          yposcmp2:
          cmp y,30h
          je call20
          
          cmp y,31h
          je call21
          
          cmp y,32h 
          je call22
            
          call00: 
          cmp x_y[0],0
          jne position  
          cmp Si,0 
          je xpos00
          cmp si,2  
          je xpos00
          cmp si,4  
          je xpos00
          cmp si,6 
          je xpos00
          cmp si,8 
          je xpos00
          jne ypos00 
          xpos00:
          MOV x_y[0],1
          jmp endl   
          ypos00:  
          MOV x_y[0],2
          jmp endl
          
          call01:
          cmp x_y[1],0
          jne position 
          cmp Si,0 
          je xpos01
          cmp si,2  
          je xpos01
          cmp si,4  
          je xpos01
          cmp si,6 
          je xpos01
          cmp si,8
          je xpos01
          jne ypos01 
          xpos01:
          MOV x_y[1],1 
          jmp endl
          ypos01:  
          MOV x_y[1],2
          jmp endl
          
          call02: 
          cmp x_y[2],0
          jne position
          cmp Si,0 
          je xpos02
          cmp si,2  
          je xpos02
          cmp si,4  
          je xpos02
          cmp si,6 
          je xpos02
          cmp si,8
          je xpos02
          jne ypos02 
          xpos02:
          MOV x_y[2],1  
          jmp endl
          ypos02:     
          MOV x_y[2],2
          jmp endl
          
          call10:     
          cmp x_y[3],0
          jne position
          cmp Si,0 
          je xpos10
          cmp si,2  
          je xpos10
          cmp si,4  
          je xpos10
          cmp si,6 
          je xpos10
          cmp si,8
          je xpos10
          jne ypos10 
          xpos10:
          MOV x_y[3],1 
          jmp endl
          ypos10:   
          MOV x_y[3],2
          jmp endl
          
          call11:
          cmp x_y[4],0
          jne position
          cmp Si,0 
          je xpos11
          cmp si,2  
          je xpos11
          cmp si,4  
          je xpos11
          cmp si,6 
          je xpos11
          cmp si,8
          je xpos11
          jne ypos11 
          xpos11:
          MOV x_y[4],1
          jmp endl  
          ypos11:    
          MOV x_y[4],2
          jmp endl
          
          call12:  
          cmp x_y[5],0
          jne position
          cmp Si,0 
          je xpos12
          cmp si,2  
          je xpos12
          cmp si,4  
          je xpos12
          cmp si,6 
          je xpos12
          cmp si,8
          je xpos12
          jne ypos12 
          xpos12:
          MOV x_y[5],1
          jmp endl  
          ypos12:  
          MOV x_y[5],2
          jmp endl
          
          call20:
          cmp x_y[6],0
          jne position
          cmp Si,0 
          je xpos20
          cmp si,2  
          je xpos20
          cmp si,4  
          je xpos20
          cmp si,6 
          je xpos20
          cmp si,8
          je xpos20
          jne ypos20 
          xpos20:
          MOV x_y[6],1 
          jmp endl
          ypos20:  
          MOV x_y[6],2
          jmp endl
          
          call21:  
          cmp x_y[7],0
          jne position
          cmp Si,0 
          je xpos21
          cmp si,2  
          je xpos21
          cmp si,4  
          je xpos21
          cmp si,6 
          je xpos21
          cmp si,8
          je xpos21
          jne ypos21 
          xpos21:
          MOV x_y[7],1 
          jmp endl
          ypos21:      
          MOV x_y[7],2
          jmp endl
          
          call22: 
          cmp x_y[8],0
          jne  position
          cmp Si,0 
          je xpos22
          cmp si,2  
          je xpos22
          cmp si,4 
          je xpos22
          cmp si,6 
          je xpos22
          cmp si,8
          je xpos22
          jne ypos22 
          xpos22:
          MOV x_y[8],1
          jmp endl  
          ypos22:  
          MOV x_y[8],2
          jmp endl
          
          position:
          LEA DX,space
          MOV AH,9
          INT 21H
          
          LEA DX,wrong
          MOV AH,9
          INT 21H
          
          jmp start_find
           
          endl:   
       	RET	 
    find_position ENDP  
    
 ;===============================
    xpos PROC  
       againx:
       LEA DX,msgx
       MOV AH,9
       INT 21H 
       
       MOV AH,01H
       INT 21H
       
       MOV x,al
       
       cmp x,30h 
       jb againx 
       
       cmp x,32h 
       ja againx       
      RET 
    xpos ENDP 
    
    ypos PROC  
       againy:
       LEA DX,msgy
       MOV AH,9
       INT 21H 
       
       MOV AH,01H
       INT 21H
       
       MOV y,al
       
       cmp y,30h 
       jb againy 
       
       cmp y,32h 
       ja againy  
            
      RET 
    ypos ENDP
;============================================    
    readname1 PROC
       LEA DX,name1
       MOV AH,9
       INT 21H
       
       MOV SI,0
       
       Startloop1:
       MOV AH,01H
       INT 21H  
       
       cmp al,13       
       je endloop1
       
       mov player1[si],al   
       inc si   
       cmp si,20
       jb startloop1
       
       endloop1:  
       
    RET	
    readname1 ENDP
    
    readname2 PROC
       LEA DX,name2
       MOV AH,9
       INT 21H
       
       MOV SI,0
       
       Startloop2:
       MOV AH,01H
       INT 21H  
       
       cmp al,13       
       je endloop2
       
       mov player2[si],al   
       inc si   
       cmp si,20
       jb startloop2
       
       endloop2:  
    RET	
    readname2 ENDP                                  
;===================================================
    write_file_player1 PROC
       mov es, ax 
       
       mov ah, 3ch  ;open file
       lea dx, file1
       int 21h       
       
       mov handle, ax 
       
       mov di,0	
       startloop_write1:
       mov ah, 40h
       mov dl,player1[di]    ;pare ton xarakthra apo th 8esh mnhmhs buffer[di]  
       mov bx, handle
       mov cx, 20
       int 21h  
       inc di
       cmp di,si     
       jb startloop_write1 
          
       lea dx, endx
       mov bx, handle
       mov cx, 1 
       mov ah, 40h
       int 21h  
       
       
    ret 
    write_file_player1 ENDP
  ;  write_file_player2 PROC
   ;    mov es, ax 
       
    ;   mov ah, 3ch  ;open file
     ;  mov dl, file1
      ; int 21h       
       
      ; mov handle, ax 
       
      ; mov di,0	
      ; startloop_write2:
      ; mov ah, 40h
      ; mov dl,player2[di]    ;pare ton xarakthra apo th 8esh mnhmhs buffer[di] 
      ; mov bx, handle
      ; mov cx, 20
      ; int 21h   
      ; inc di 
      ; cmp di,si     
      ; jb startloop_write2 
          
      ; lea dx, endx
      ; mov bx, handle
      ; mov cx, 1 
      ; mov ah, 40h
      ; int 21h  
       
       
    ;ret 
    ;write_file_player2 ENDP
    write_file_computer PROC
       mov es, ax 
       
       mov ah, 3ch  ;open file
       lea dx, file1
       int 21h       
       
       mov handle, ax 
       
       lea dx, computer
       mov bx, handle
       mov cx, 20
       mov ah, 40h
       int 21h   
       
       lea dx, endx
       mov bx, handle
       mov cx, 1 
       mov ah, 40h
       int 21h  
       
       
    ret 
    write_file_computer ENDP

    read_file PROC
        PUSH ES
        PUSH DX
        PUSH AX
        PUSH CX
        PUSH BX
        PUSH SI
        PUSH DI
        
          ;open file
          MOV AH,3DH ;3DH -->opens file
          MOV AL,0 ;0-->reading (1-->writing, 2-->both)
          MOV DX, offset file1 ;create pointer
          INT 21H  ;call the interupt
          MOV handle,AX  ;returns the file handle in AX
          
          MOV AH,3FH
          MOV CX,1000;auto analoga m t txt
          MOV SI,0
          MOV DX, offset array   
          MOV BX, handle
          INT 21H
          
          MOV DX, offset array
          ADD DX, AX
          
          MOV BX,DX
          MOV byte[bx],"$"   
          
          MOV CL,10H
          MOV BL,4
         
          MOV SI,0
                    
          startloop1c:
  	MOV AL,array[SI]    ;pare ton xarakthra apo th 8esh mnhmhs buffer[di]   
  	INC SI
  	
  	mov dl,al
  	mov ah,2h
  	int 21h
           
          cmp al," "
          je printspace 
                    
          cmp al,"$"
          je closeFile
                       
          jmp startloop1c
                       
          printspace:
          LEA DX,space
       	MOV AH,9
       	INT 21H  
       	
       	jmp startloop1c
       	
           
          closeFile:        
            
            MOV AH,3eh
            MOV BX,handle
            INT 21h 
          
          err:

        POP DI
        POP SI
        POP BX
        POP CX
        POP AX
        POP DX
        POP ES
        RET
      read_file ENDP
;==========================================================================    
    setgraphicsmode PROC
     PUSH AX 
     
     MOV Al,13H
     MOV AH,0H
     INT 10H
     
     POP AX 
     RET
    setgraphicsmode ENDP  
    
    putpixel PROC
     PUSH AX
     PUSH BX
     PUSH DX
     PUSH SI
     PUSH ES
     
     MOV DX, 140H
     MUL DX
     ADD AX,BX
     MOV SI,AX
     MOV BX,0A000H
     MOV ES,BX
     MOV ES:[SI],09H
     
     POP ES
     POP SI
     POP DX
     POP BX   
     POP AX
     RET
    putpixel ENDP  
    
    drawline_horizontal_right PROC
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX 
     PUSH SI
     PUSH ES
    
     MOV DX,140H
     MUL DX
     ADD AX,BX
     MOV SI,AX
     MOV BX,0A000H
     MOV ES,BX
     MOV ES,BX
          
     drawline_horizontal_right_again: 
      MOV ES:[SI],09H
      INC SI
     Loop drawline_horizontal_right_again
     
     POP ES
     POP SI
     POP DX
     POP CX
     POP BX
     POP AX
     RET
    drawline_horizontal_right ENDP   
    
    drawline_vertical_bottom PROC
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX 
     PUSH SI
     PUSH ES
    
     MOV DX,140H
     MUL DX
     ADD AX,BX
     MOV SI,AX
     MOV BX,0A000H
     MOV ES,BX
     MOV ES,BX
          
     drawline_vertical_bottom_again: 
      MOV ES:[SI],09H
      ADD SI,140H
     Loop drawline_vertical_bottom_again
     
     POP ES
     POP SI
     POP DX
     POP CX
     POP BX
     POP AX
     RET   
    drawline_vertical_bottom ENDP
         
    createtable PROC
       CALL setgraphicsmode
       
       MOV AX,30
       MOV BX,180
       MOV CX,90
       ;CALL drawline_horizontal_right 
       
       MOV AX,60
       MOV BX,180
       MOV CX,90
       CALL drawline_horizontal_right 
       
       MOV AX,90
       MOV BX,180
       MOV CX,90
       CALL drawline_horizontal_right
       
       MOV AX,120
       MOV BX,180
       MOV CX,90
       ;CALL drawline_horizontal_right  
       
       MOV AX,30
       MOV BX,180
       MOV CX,90
       ;CALL drawline_vertical_bottom 
       
       MOV AX,30
       MOV BX,210
       MOV CX,90
       CALL drawline_vertical_bottom 
       
       MOV AX,30
       MOV BX,240
       MOV CX,90
       CALL drawline_vertical_bottom
       
       MOV AX,30
       MOV BX,270
       MOV CX,90
       ;CALL drawline_vertical_bottom 
       
       RET
    createtable ENDP  
    cross00 PROC
      MOV AX,45
      MOV BX,180
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,30
      MOV BX,195
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross00 ENDP  
    cross01 PROC
      MOV AX,45
      MOV BX,210
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,30
      MOV BX,225
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross01 ENDP
    cross02 PROC
      MOV AX,45
      MOV BX,240
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,30
      MOV BX,255
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross02 ENDP 
    cross10 PROC
      MOV AX,75
      MOV BX,180
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,60
      MOV BX,195
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross10 ENDP 
    cross11 PROC
      MOV AX,75
      MOV BX,210
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,60
      MOV BX,225
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross11 ENDP
    cross12 PROC
      MOV AX,75
      MOV BX,240
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,60
      MOV BX,255
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross12 ENDP
    cross20 PROC
      MOV AX,105
      MOV BX,180
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,90
      MOV BX,195
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross20 ENDP 
    cross21 PROC
      MOV AX,105
      MOV BX,210
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,90
      MOV BX,225
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross21 ENDP
    cross22 PROC
      MOV AX,105
      MOV BX,240
      MOV CX,30
      CALL drawline_horizontal_right
      
      MOV AX,90
      MOV BX,255
      MOV CX,30
      CALL drawline_vertical_bottom
      	           
      RET          
    cross22 ENDP
    position00 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,180
            MOV DX,30 
    	           
            Right2Right00:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,210
            CMP DX,60
            JNZ Right2right00

            MOV CX,180
            MOV DX,60
            
            Left2Right00:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,210
            CMP DX,30 
            JNZ Left2Right00     
        
        POP CX
        POP DX
        POP AX
        RET
    position00 ENDP
    
    position01 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,210
            MOV DX,30 
    	           
            Right2Right01:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,240
            CMP DX,60
            JNZ Right2right01

            MOV CX,210
            MOV DX,60
            
            Left2Right01:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,240
            CMP DX,30 
            JNZ Left2Right01     
        
        POP CX
        POP DX
        POP AX
        RET
    position01 ENDP 
    
    position02 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,240
            MOV DX,30 
    	           
            Right2Right02:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            INC DX
            CMP CX,270
            CMP DX,60
            JNZ Right2right02

            MOV CX,240
            MOV DX,60
            
            Left2Right02:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,270
            CMP DX,30 
            JNZ Left2Right02     
        
        POP CX
        POP DX
        POP AX
        RET
    position02 ENDP
    
    position10 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,180
            MOV DX,60 
    	           
            Right2Right10:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,210
            CMP DX,90
            JNZ Right2right10

            MOV CX,180
            MOV DX,90
            
            Left2Right10:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,150
            CMP DX,60 
            JNZ Left2Right10     
        
        POP CX
        POP DX
        POP AX
        RET
    position10 ENDP
    
    position11 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,210
            MOV DX,60 
    	           
            Right2Right11:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,240
            CMP DX,90
            JNZ Right2right11

            MOV CX,210
            MOV DX,90
            
            Left2Right11:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,180
            CMP DX,60 
            JNZ Left2Right11    
        
        POP CX
        POP DX
        POP AX
        RET
    position11 ENDP
    
    position12 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,240
            MOV DX,60 
    	           
            Right2Right12:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,270
            CMP DX,90
            JNZ Right2right12

            MOV CX,240
            MOV DX,90
            
            Left2Right12:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,210
            CMP DX,60 
            JNZ Left2Right12    
        
        POP CX
        POP DX
        POP AX
        RET
    position12 ENDP
    
    position20 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,180
            MOV DX,90 
    	           
            Right2Right20:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,210
            CMP DX,120
            JNZ Right2right20

            MOV CX,180
            MOV DX,120
            
            Left2Right20:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,150
            CMP DX,90 
            JNZ Left2Right20    
        
        POP CX
        POP DX
        POP AX
        RET
    position20 ENDP 
    
    position21 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,210
            MOV DX,90 
    	           
            Right2Right21:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,240
            CMP DX,120
            JNZ Right2right21

            MOV CX,210
            MOV DX,120
            
            Left2Right21:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,180
            CMP DX,90 
            JNZ Left2Right21    
        
        POP CX
        POP DX
        POP AX
        RET
    position21 ENDP
    
    position22 PROC
        PUSH AX
        PUSH DX
        PUSH CX	          
    	  
    	  MOV CX,240
            MOV DX,90 
    	           
            Right2Right22:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,290
            CMP DX,120
            JNZ Right2right22

            MOV CX,240
            MOV DX,120
            
            Left2Right22:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,210
            CMP DX,90 
            JNZ Left2Right22    
        
        POP CX
        POP DX
        POP AX
        RET
    position22 ENDP      
    Code Ends
 Soros Segment Stack
    db 256 dup(0)
 Soros Ends
End Start
