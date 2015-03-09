pro write_reg_file_simplexy,x,y,outname

; -- WRITE Reg File --
 outregfile = outname+'.xy_reg'
  get_lun,lun0
  openw,lun0,outregfile
  printf,lun0,'image'
   out1 = 'circle('
   cm = ','
   rad = '3.)'
  for i = 0, n_elements(x)-1 do begin
    outra = string(x[i],format='(f15.8)')
    outdec = string(y[i],format='(f15.8)')
   printf,lun0,out1+outra+cm+outdec+cm+rad
  endfor

 close,lun0
  free_lun,lun0
 ; -- 

end

pro write_reg_file_simplesky,cat,outname

; -- WRITE Reg File --
 outregfile = outname+'.fk5_reg'
 get_lun,lun0
 openw,lun0,outregfile
 printf,lun0,'fk5'
   out1 = 'circle('
 cm = ','
 rad = '3.)'
 for i = 0, n_elements(cat.ra)-1 do begin
   outra = string(cat[i].ra,format='(f15.8)')
   outdec = string(cat[i].dec,format='(f15.8)')
  printf,lun0,out1+outra+cm+outdec+cm+rad
  endfor

 close,lun0
 free_lun,lun0
 ; -- 

end

