Title MyProjectVisaCard

Data Segment
  ask   db "If you want to tap a Card's number, please press 1.",10,13,"$"
  ask1  db "If you want to read Cards' number from a file, please press 2.",10,13,"$"
  ask2  db "Otherwise press any key to exit.",10,13,"$"
  
  msg  db 10,13,10,13,10,13,"$"
  msg1 db "Please enter your card's number.",10,13,"$" 
  msg2 db "If you coplete the process, please tap space:",10,13,"$"
  msg3 db 10,10,10,13,"Card is accepted.",10,13,"$"
  msg4 db 10,10,10,13,"Incorect card's number input.",10,13,"$"
  msg5 db 10,13,10,13,10,13,"The result after Luhn algorithm is: $"
 
  Mastercard db "Your card is Mastercard"  ,10,13,"$"
  Visa       db "Your card is Visa"        ,10,13,"$"
  Amex       db "Your card is Amex"        ,10,13,"$"
  DinersClub db "Your card is Diners Club" ,10,13,"$"
  Discover   db "Your card is Discover"    ,10,13,"$"
  
  buffer 16 dup(0)
  array  16 dup(0)
  
  binary db 2
  decate db 10 
  temp   db 0
  
  dekada     db 0
  monada     db 0
  ekatontada db 0
  
  file1 db "c:\test1\file1.txt"
  handle dw ?
Data Ends

Code segment
    Start:
      MOV AX, Data
      MOV DS,AX 
      
      LEA DX,ask
      MOV AH,09
      INT 21H  
      
      LEA DX,ask1
      MOV AH,09
      INT 21H 
      
      LEA DX,ask2
      MOV AH,09
      INT 21H 
      
      MOV AH,01H
      INT 21H 
      
      CMP AL,31H
      JE  your_input
      
      CMP AL,32H      
      JE  read_from_file
      
      JMP end_of_process
      
      your_input:
      MOV temp,01H
      
      LEA DX,msg
      MOV AH,09
      INT 21H
           
      LEA DX,msg1
      MOV AH,09
      INT 21H  
      
      LEA DX,msg2
      MOV AH,09
      INT 21H 

      Call insert
      JMP end_of_process 
      
      read_from_file:
      Call files
      
      end_of_process:
      
    MOV AH, 4CH
    INT 21H
;=========================================================================     
;sunarthsh eisagwghs arithmou karthas kai elegxou kata tn eisagwgh
;epitrepetai h eisagwgh mono arithmwn (0-9)
            
      insert PROC
        PUSH AX
        PUSH SI
        
          loop_digits:
  
            MOV AH,01H
            INT 21H 
            
            MOV buffer[SI],AL
            INC SI   
            
            CMP AL,20H
            JE  end_loop_digits
            
            CMP AL,30H
            JB  wrong_insert
            
            CMP AL,39H
            JA  wrong_insert
            
            CMP SI,10H
            JE  end_loop_digits2 
          
          LOOP loop_digits
         
          wrong_insert:
            
            CALL not_accepted_card
            JMP  end_insert 
          
          end_loop_digits:
            
            CMP SI,0EH
            JE V   
            
            CMP SI,10H
            JE Am
            
            CMP SI,0FH
            JE DC      
            
            JMP wrong_insert
            
          end_loop_digits2:  
            CMP SI,0FH
            JE Other
          
          Other:
            CMP buffer[0],'5'
            JE M
            
            CMP buffer[0],'6'
            JE D
          
            CMP buffer[0],'4'
            JE V
          
            JMP wrong_insert
                   
          M: 
            CMP buffer[1],'1'
            JB  wrong_insert  
                        
            CMP buffer[1],'5'
            JA  wrong_insert
          
            CALL CardMastercard
            JMP  end_insert
         
          V:
            CMP buffer[0],'4'
            JNE wrong_insert
            CALL CardVisa
            JMP  end_insert
         
          Am:
            CMP buffer[0],'3'
            JNE wrong_insert
           
            CMP buffer[1],'4'
            JE  partAm 
          
            CMP buffer[1],'7'
            JNE wrong_insert
          
          partAm: 
           CALL CardAmex
           JMP  end_insert
          
            
          DC: 
            CMP buffer[0],'3'
            JNE wrong_insert
           
            CMP buffer[1],'0'
            JE  partDC2  
          
            CMP buffer[1],'6'
            JNE partDC1 
            JMP partDC
          
          partDC1:
            CMP buffer[1],'8'
            JNE wrong_insert
            JMP partDC
                    
          partDC2:
            CMP buffer[2],'0'
            JB  wrong_insert 
          
            CMP buffer[2],'5'
            JA  wrong_insert
          
          partDC:
           CALL CardDinersClub
           JMP  end_insert
                     
        
         D:  
            CMP buffer[1],'0'
            JNE  wrong_insert  
          
            CMP buffer[2],'1'
            JNE  wrong_insert
          
            CMP buffer[3],'1'
            JNE  wrong_insert
            
            CALL CardDiscover 
         end_insert:
          
        POP SI
        POP AX 
        RET
      insert ENDP    

;==================================================================================
;eisagwgh apo arxeio

        files PROC
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
          MOV CX,10H
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
         
          LEA SI,array
                    
          MOV DL,msg
          MOV AH,02H
          INT 21H
                       
          loop_again: 
          MOV AL,[SI]
                            
          CMP CL,10H
          JE f0 
          JMP fn0
          f0:
          MOV AL,[SI]
          MOV buffer[0],AL
          JMP fn
          
          fn0:
          CMP CL,0FH
          JE f1 
          JMP fn1
          f1:
          MOV AL,[SI]
          MOV buffer[1],AL 
          JMP fn
          
          fn1:          
          CMP CL,0EH
          JE f2 
          JMP fn2
          f2:
          MOV AL,[SI]
          MOV buffer[2],AL
          JMP fn
          
          fn2:
          CMP CL,0DH
          JE f3 
          JMP fn3
          f3:
          MOV AL,[SI]
          MOV buffer[3],AL 
          JMP fn
          
          fn3:
          CMP CL,0CH
          JE f4 
          JMP fn4
          f4:
          MOV AL,[SI]
          MOV buffer[4],AL
          JMP fn
          
          fn4:
          CMP CL,0BH
          JE f5 
          JMP fn5
          f5:
          MOV AL,[SI]
          MOV buffer[5],AL
          JMP fn
          
          fn5:
          CMP CL,0AH
          JE f6 
          JMP fn6
          f6:
          MOV AL,[SI]
          MOV buffer[6],AL
          JMP fn
          
          fn6:
          CMP CL,09H
          JE f7 
          JMP fn7
          f7:
          MOV AL,[SI]
          MOV buffer[7],AL
          JMP fn
          
          fn7:
          CMP CL,08H
          JE f8 
          JMP fn8
          f8:
          MOV AL,[SI]
          MOV buffer[8],AL
          JMP fn
          
          fn8:
          CMP CL,07H
          JE f9 
          JMP fn9
          f9:
          MOV AL,[SI]
          MOV buffer[9],AL
          JMP fn
          
          fn9:
          CMP CL,06H
          JE f10 
          JMP fn10
          f10:
          MOV AL,[SI]
          MOV buffer[0AH],AL
          JMP fn
          
          fn10:
          CMP CL,05H
          JE f11 
          JMP fn11
          f11:
          MOV AL,[SI]
          MOV buffer[0BH],AL
          JMP fn
          
          fn11:
          CMP CL,04H
          JE f12 
          JMP fn12
          f12:
          MOV AL,[SI]
          MOV buffer[0CH],AL
          JMP fn
          
          fn12:
          CMP CL,03H
          JE f13 
          JMP fn13
          f13:
          MOV AL,[SI]
          MOV buffer[0DH],AL
          JMP fn
           
          fn13: 
          CMP CL,02H
          JE f14 
          JMP fn14
          f14:
          MOV AL,[SI]
          MOV buffer[0EH],AL
          JMP fn                  
                            
          fn14:
          CMP CL,01H
          JE f15 
          f15:
          MOV AL,[SI]
          MOV buffer[0FH],AL
          
          fn:
          MOV DL,AL
          MOV AH,02H
          INT 21H     
          
          INC SI          
          loop loop_again  
          
          MOV SI,0
          MOV DX,0
          
          my_buffer:
          MOV AL,buffer[SI]
          
          INC SI
          
          CMP AL,24H
          JE  end_loop_digits_file
          
          CMP AL,30H
          JB  wrong_input
            
          CMP AL,39H
          JA  wrong_input

          CMP SI,10H
          JE  end_loop_digits_file2

          CMP SI,10H
          JNE my_buffer
          
          
          wrong_input: 
            CALL not_accepted_card
            JMP  err 
          
          end_loop_digits_file: 
            CMP SI,0EH
            JE VF   
            
            CMP SI,10H
            JE AmF
            
            CMP SI,0FH
            JE DCF            
            
          JMP wrong_input
          
          end_loop_digits_file2:
            CMP SI,0FH
            JE OtherF
          
          OtherF:
            CMP buffer[0],'5'
            JE MF
            
            CMP buffer[0],'6'
            JE DF
          
            CMP buffer[0],'4'
            JE VF
          
            JMP wrong_input
                   
          MF: 
            CMP buffer[1],'1'
            JB  wrong_input  
                        
            CMP buffer[1],'5'
            JA  wrong_input
          
            CALL CardMastercard
            JMP  err
         
          VF:
            CMP buffer[0],'4'
            JNE wrong_input
            CALL CardVisa
            JMP  err
         
          AmF:
            CMP buffer[0],'3'
            JNE wrong_input
           
            CMP buffer[1],'4'
            JE  partAmF 
          
            CMP buffer[1],'7'
            JNE wrong_input
          
          partAmF: 
           CALL CardAmex
           JMP  err
          
            
          DCF: 
            CMP buffer[0],'3'
            JNE wrong_input
           
            CMP buffer[1],'0'
            JE  partDCF2  
          
            CMP buffer[1],'6'
            JNE partDCF1 
            JMP partDCF
          
          partDCF1:
            CMP buffer[1],'8'
            JNE wrong_input
            JMP partDCF
                    
          partDCF2:
            CMP buffer[2],'0'
            JB  wrong_input 
          
            CMP buffer[2],'5'
            JA  wrong_input
          
          partDCF:
           CALL CardDinersClub
           JMP  err
                     
        
         DF:  
            CMP buffer[1],'0'
            JNE wrong_input  
          
            CMP buffer[2],'1'
            JNE wrong_input
          
            CMP buffer[3],'1'
            JNE wrong_input
            
            CALL CardDiscover
           
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
      files ENDP 
      
;=================================================================================
      
      CardMastercard PROC
        PUSH AX 
        PUSH DX
        PUSH CX
       
          DEC SI     
          MOV CX,16
 
          CALL non_ascii
 
          MOV SI,0FH 
          MOV CX,10H    
          
          CMP temp,01H
          JE simpleM
          JMP filepartM
           
          simpleM:          
          CALL EvenSI
          JMP eitherM
          
          filepartM: 
          CALL EvenSIFile
          JMP eitherM
          
          
          eitherM:
          CALL print
          CMP monada,'0' 
          JE  Mas
          JMP NotAcceptedMastercard
          
          Mas:
            MOV DI,1
            MOV SI,0  
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            LEA DX,msg
            MOV AH,09
            INT 21H 
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
          MastercardLoop:
            MOV DL,buffer[SI]
            ADD DL,30H 
            
            MOV AH,02H
            INT 21H
  
            INC SI
            CMP SI,16
          JNE MastercardLoop   
  
          CMP DI,1
          JE  AcceptedMastercard
          JMP NotAcceptedMastercard
        
          AcceptedMastercard: 
            LEA DX,Mastercard
            MOV AH,09
            INT 21H 
            
            CALL setgraphicsmode
            CALL true      
            
            JMP  Mastercard_End 
            
          NotAcceptedMastercard:
            CALL not_accepted_card
            
          Mastercard_End:
          
        POP CX
        POP DX
        POP AX
        RET 
      CardMastercard ENDP
      
      CardDiscover PROC
        PUSH AX 
        PUSH DX
        PUSH CX
 
          DEC SI       
          MOV CX,10h
 
          CALL non_ascii
 
          MOV SI,0FH
          MOV CX,10H 
          
           CMP temp,01H
          JE simpleM
          JMP filepartM
           
          simpleD:          
          CALL EvenSI
          JMP eitherD
          
          filepartD: 
          CALL EvenSIFile
          JMP eitherD
          
          
          eitherD:   
          CALL print    

          CMP monada,"0" 
          JE  Disc
          JMP incorrectDisc
          
          Disc:
            MOV DI,1
            MOV SI,0
            
            LEA DX,msg
            MOV AH,09
            INT 21H
      
          DiscLoop:
            MOV DL,buffer[SI]
            ADD DL,30H 
            MOV AH,2
            INT 21H
  
            INC SI
            CMP SI,16
          JNE DiscLoop   
  
          CMP DI,1
          JE  correctDisc
          JMP incorrectDisc
  
          correctDisc: 
            LEA DX,msg
            MOV AH,09
            INT 21H
          
            LEA DX,Discover
            MOV AH,09
            INT 21H 
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            CALL setgraphicsmode
            CALL true      
            JMP  incorrectDisc
 
          incorrectDisc:
            CALL not_accepted_card            
                  
          EndDiscover:         
        
        POP CX
        POP DX
        POP AX
        RET 
      CardDiscover ENDP
      
      CardVisa PROC
        PUSH AX 
        PUSH DX
        PUSH CX  
 
          DEC SI
          CMP SI,0FH
          JNE IfDigits13
      
          IfDigits16:
            MOV CX,16
  
            CALL non_ascii
 
            MOV SI,0FH 
            MOV CX,10H
            MOV DH,0H    
            
            CMP temp,01H
            JE simpleV16
            JMP filepartV16
           
            simpleV16:          
            CALL EvenSI
            JMP eitherV16
          
            filepartV16: 
            CALL EvenSIFile
            JMP eitherV16
          
          
          eitherV16:
             
            CALL Print
            CALL setgraphicsmode     
  
            CMP monada,"0" 
            JE  Vis
            JMP IncorrectVisa:
   
          Vis:
            MOV DI,1
            MOV SI,0
            
            LEA DX,msg
            MOV AH,09
            INT 21H
          
          VisaLoop:
            MOV DL,buffer[SI]
            ADD DL,30H 
      
            MOV AH,02H
            INT 21H
  
            INC SI
            CMP SI,16
           JNE VisaLoop   
  
          CMP DI,1
          JE  CorrectVisa
          JMP IncorrectVisa
  
          CorrectVisa:
            LEA DX,msg
            MOV AH,09
            INT 21H 
            
            LEA DX,Visa
            MOV AH,09
            INT 21H 
            
            LEA DX,msg5
            MOV AH,09
            INT 21H
            
            CALL setgraphicsmode
            CALL true           
            JMP  EndVisa
 
          IncorrectVisa: 
            CALL not_accepted_card 
            JMP  EndVisa
          
          IfDigits13:
            MOV CX,0DH
  
            CALL non_ascii
 
            MOV SI,0CH 
            MOV CX,0DH 
            
            CMP temp,01H
            JE simpleV13
            JMP filepartV13
           
          simpleV13:          
          CALL OddSI
          JMP eitherV13
          
          filepartV13: 
          CALL OddSIFile
          JMP eitherV13
          
          
          eitherv13:     
            CALL print     
  
            CMP monada,"0" 
            JE Vis13
            JMP IncorrectVisa13
            
          Vis13:
            MOV DI,1
            MOV SI,0
            
            LEA DX,msg
            MOV AH,09
            INT 21H
      
          VisaLoop13:
            MOV DL,buffer[SI]
            ADD DL,30H 
            MOV AH,2
            INT 21H
  
            INC SI
            CMP SI,0DH
          JNE VisaLoop13   
  
          CMP DI,1
          JE  CorrectVisa13
          JMP IncorrectVisa13
          
          CorrectVisa13: 
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            LEA DX,Visa
            MOV AH,09
            INT 21H   
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            CALL setgraphicsmode
            CALL true             
            JMP  EndVisa
 
          IncorrectVisa13: 
            CALL not_accepted_card 
            JMP  EndVisa
          
          EndVisa:        
   
        POP CX
        POP DX
        POP AX
        RET
      CardVisa ENDP 
      
      CardDinersClub PROC
        PUSH AX 
        PUSH DX
        PUSH CX
 
          DEC SI       
          MOV CX,0EH
 
          CALL non_ascii
 
          MOV SI,0DH 
          MOV CX,0EH    
          CMP temp,01H
          JE  simpleDC
          JMP filepartDC
           
          simpleDC:          
          CALL EvenSI
          JMP eitherDC
          
          filepartDC: 
          CALL EvenSIFile
          JMP eitherDC
          
          
          eitherDC:           
          CALL print 
          CALL setgraphicsmode     

          CMP monada,"0" 
          JE  DinsClub
          JMP IncorrectDinsclub
        
          DinsClub:
            MOV DI,1
            MOV SI,0 
            
            LEA DX,msg
            MOV AH,09
            INT 21H
       
          DinsClubLoop:
            MOV DL,buffer[SI]
            ADD DL,30H 
            MOV AH,2
            INT 21H
  
            INC SI
            CMP SI,14
          JNE DinsClubLoop   
  
          CMP DI,1
          JE  CorrectDinsclub
          JMP IncorrectDinsclub
  
          CorrectDinsclub:
            LEA DX,msg
            MOV AH,09
            INT 21H
           
            LEA DX,DinersClub
            MOV AH,09
            INT 21H  
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            CALL setgraphicsmode
            CALL true            
            JMP EndDinersClub
         
          IncorrectDinsclub:
            CALL not_accepted_card
       
          EndDinersClub:
     
        POP CX
        POP DX
        POP AX
        RET 
      CardDinersClub ENDP
      
      CardAmex PROC
        PUSH AX 
        PUSH DX
        PUSH CX
 
          MOV SI,0FH     
          MOV CX,0FH
 
          CALL non_ascii
 
          MOV SI,0EH 
          MOV CX,0FH    
          
          CMP temp,01H
          JE simpleA
          JMP filepartA
           
          simpleA:          
          CALL OddSI
          JMP eitherA
          
          filepartA: 
          CALL OddSIFile
          JMP eitherA
          
          
          eitherA:
          CALL print
          CALL setgraphicsmode     

          CMP monada,"0" 
          JE  Amx
          JMP IncorrectAmx
     
          Amx:
            MOV DI,1
            MOV SI,0
            
            LEA DX,msg
            MOV AH,09
            INT 21H
         
          AmxLoop:
            MOV DL,buffer[SI]
            ADD DL,30H 
            MOV AH,2
            INT 21H
  
            INC SI
            CMP SI,15
          JNE AmxLoop   
  
          CMP DI,1
          JE  CorrectAmx
          JMP IncorrectAmx
     
          CorrectAmx:
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            LEA DX,Amex
            MOV AH,09
            INT 21H 
            
            LEA DX,msg
            MOV AH,09
            INT 21H
            
            CALL setgraphicsmode
            CALL true      
            JMP EndAmex
     
          IncorrectAmx:
            CALL not_accepted_card
     
          EndAmex:
    
        POP CX
        POP DX
        POP AX
        RET 
      CardAmex ENDP   
    

;=================================================================================

;H synarthsh auth metatreph thn ascii timh tou kathe arithou se katharo arithmo.
      
      non_ascii PROC
        PUSH SI 
        
        loop1:   
          SUB buffer[SI],30H
          DEC SI
          
          CMP SI,0
          JNE loop1
 
        POP SI
        RET
      non_ascii ENDP

;Ean to SI einai monos arithmos 
      EvenSI PROC
        SUB buffer[0],30H
        
        loopEven:
        
        MOV BL,0
        MOV BH,0
        
        MOV BX,SI  ;metaferoume to SI ston Bx.
        
        MOV AX,BX
        DIV binary ;diairoume me to 2 .
 
        CMP AH,0   ;ean o SI einai monos arithmos
        JE  MULE 
        
        MOV BL,buffer[SI];ean o SI einai zugos arithmos  
        JMP endEven
         
        MULE: 
        MOV AL,buffer[SI]      
        MUL binary  ;pollaplasiazw epi 2 
        DIV decate ;krataw ksexwrista th dekada apo th monada
        
        MOV BL,AL   
        MOV BH,AH 
        
        endEven: 
        
        DEC SI 
        
        ;prosthetw th dekada kai th monada sto aqpotelesma
        
        ADD DH,BL   
        ADD DH,BH 
        
        LOOP loopEven 
        
        MOV BL,DH
        
        RET 
       EvenSI ENDP
      
       OddSI PROC
        SUB buffer[0],30H 
        
        loopOdd:
        
        MOV BL,0
        MOV BH,0 
        
        MOV BX,SI  ;metaferoume to SI ston Bx.
        
        MOV AX,BX
        DIV binary ;diairoume me to 2  
         
        CMP AH,1   ;ean o SI einai monos arithmos
        JE MULO 
        
        MOV BL,buffer[SI];ean o SI einai zugos arithmos  
        JMP endOdd
         
        MULO: 
        MOV AL,buffer[SI] 
        MUL binary  ;pollaplasiazw epi 2 
        DIV decate ;krataw ksexwrista th dekada apo th monada
        
        MOV BL,AL   
        MOV BH,AH 
        
        endOdd: 
        
        DEC SI 
        
        ;prosthetw th dekada kai th monada sto aqpotelesma
        
        ADD DH,BL   
        ADD DH,BH 

        LOOP loopOdd         
        
        MOV BL,DH
        
        RET 
       
       OddSI ENDP   
       
       EvenSIFile PROC
        SUB buffer[0],30H
        
        loopEvenFile:        
        MOV BL,0
        MOV BH,0
        
        MOV BX,SI  ;metaferoume to SI ston Bx.
        
        MOV binary,2
        
        MOV AX,BX
        DIV binary ;diairoume me to 2 .
 
        CMP AH,0   ;ean o SI einai monos arithmos
        JE  MULEFile 
        
        MOV BL,buffer[SI];ean o SI einai zugos arithmos  
        JMP endEven
         
        MULEFile: 
        MOV AL,buffer[SI]      
        MUL binary  ;pollaplasiazw epi 2 
        DIV decate ;krataw ksexwrista th dekada apo th monada
        
        MOV BL,AL   
        MOV BH,AH 
        
        endEvenFile: 
        
        DEC SI 
        
        ;prosthetw th dekada kai th monada sto aqpotelesma
        
        ADD DH,BL   
        ADD DH,BH 
        
        LOOP loopEvenFile 
        
        MOV BL,DH
        
        RET 
       EvenSIFile ENDP
      
       OddSIFile PROC
        SUB buffer[0],30H 
        
        loopOddFile:
        
        MOV BL,0
        MOV BH,0 
        
        MOV BX,SI  ;metaferoume to SI ston Bx.
        
        MOV binary,2
        
        MOV AX,BX
        DIV binary ;diairoume me to 2  
         
        CMP AH,1   ;ean o SI einai monos arithmos
        JE MULOFile 
        
        MOV BL,buffer[SI];ean o SI einai zugos arithmos  
        JMP endOddFile
         
        MULOFile: 
        MOV AL,buffer[SI] 
        MUL binary  ;pollaplasiazw epi 2 
        DIV decate ;krataw ksexwrista th dekada apo th monada
        
        MOV BL,AL   
        MOV BH,AH 
        
        endOddFile: 
        
        DEC SI 
        
        ;prosthetw th dekada kai th monada sto aqpotelesma
        
        ADD DH,BL   
        ADD DH,BH 

        LOOP loopOdd         
        
        MOV BL,DH
        
        RET 
       
       OddSIFile ENDP
                  
;=================================================================================
;sunarthseis emfanishs apotelesmatos                                                                                  
      not_accepted_card PROC
      PUSH AX
      PUSH DX  
            
            LEA DX,msg
            MOV AH,09
            INT 21H
        
            LEA DX,msg4
            MOV AH,09
            INT 21H  
            
            CALL setgraphicsmode
            CALL false
      POP DX
      POP AX
      not_accepted_card ENDP 
      
      print PROC
        PUSH DX
        PUSH AX
         
         LEA DX,msg
         MOV AH,09
         INT 21H
         
         LEA DX,msg5
         MOV AH,09
         INT 21H
         
         MOV AH,0
         MOV AL,BL
         
         DIV decate
 
         MOV monada,AH  
         MOV AH,0
         DIV decate
  
         MOV ekatontada,AL
         MOV dekada,AH
    
         ADD ekatontada,30H
         ADD dekada,30H
         ADD monada,30H
    
         MOV DL,ekatontada
         MOV AH,02H
         INT 21H    
    
         MOV DL,dekada
         MOV AH,02H
         INT 21H
    
         MOV DL,monada
         MOV AH,02H
         INT 21H
         
         MOV DL,monada

        POP AX
        POP DX
        RET
      print ENDP
          
;=================================================================================      
;sunarthseis grafikwn
      
      setgraphicsmode PROC
        PUSH AX 
     
            MOV Al,13H
            MOV AH,0H
            INT 10H
     
        POP AX 
        RET
      setgraphicsmode ENDP
      
      true PROC
        PUSH AX
        PUSH DX
        PUSH CX
    
            MOV CX,50
            MOV DX,50
            
            R: 
            MOV AH, 0CH
            MOV AL,02H
            INT 10H
            
            INC CX
            INC DX
            
            CMP CX,75
            CMP CX,75
            JNZ R
             
            MOV CX,75
            MOV DX,75
            
            L:
            MOV AH,0CH
            MOV AL,02H
            INT 10H
            
            INC CX
            DEC DX 
            
            CMP CX,135
            CMP DX,25
            JNZ L

        POP CX
        POP DX
        POP AX
        RET    
      true ENDP
      
      false PROC
        PUSH AX
        PUSH DX
        PUSH CX
    
            MOV CX,50
            MOV DX,50 
            
            Left2Right:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
            
            INC CX
            DEC DX
            
            CMP CX,100
            CMP DX,0 
            JNZ Left2Right
            
            MOV CX,50
            MOV DX,0
            
            Right2Right:
            MOV AH,0CH
            MOV AL,0CH
            INT 10H
   
            INC CX
            INC DX
            CMP CX,0
            CMP DX,50
            JNZ Right2right
   
        POP CX
        POP DX
        POP AX
        RET
      false ENDP
      
Code Ends
Soros Segment Stack
    db256 dup(0)
Soros Ends
    End Start   
      
    