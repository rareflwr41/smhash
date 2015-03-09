pro image_cutouts,imname,imdata,imhdr,cat0

   ; -- figure things out about the input image 
  impix = n_elements(imdata)
  imdim = size(imdata)
   ;print,imdim

   ; -- convert the RA/Dec coordinates to image x,y 
  adxy,imhdr,cat0.ra,cat0.dec,x,y
   ; -- determine if the object is in the image footprint
   inimg = where(x gt 0 and x lt imdim[1] and y gt 0 and y lt imdim[2])
   ; -- restrict the arrays to those objects in the image footprint
   x = x(inimg)
   y = y(inimg)
  cat = cat0[inimg]

  ; -- go through the objects in the images
 for j = 0, n_elements(x)-1 do begin
 
   ctload,0,/reverse,/silent
   ; -- position the image
  pos = [0.15,0.15,0.95,0.95]

    ; -- set a window of 30x30 pixels
   win = 15
    ; -- determine the corners of the image, test that in the image
   x0 = long(x[j]-win)
    if x0 le 0 then x0=0
   x1 = long(x[j]+win)
    if x1 ge imdim[1] then x1=imdim[1]-1
   y0 = long(y[j]-win)
    if y0 le 0 then y0=0
   y1 = long(y[j]+win)
    if y1 ge imdim[2] then y1=imdim[2]-1

   ;print,x0,x1,y0,y1
   ; -- extract sub-image using the corners
  hextract,imdata,imhdr,cut,cuthdr,x0,x1,y0,y1,/silent
  
  ; -- set min & max intensity for the image
   mins = 0
   maxs = 1
  ; -- make sure the sub-image isn't blank ...
 if mean(cut) ne  21 then begin
   ctload,0,/silent
   ; -- display the sub-image
  cgimage,cut,cra,cdec,minvalue=mins,maxvalue=maxs,xr=xr,yr=yr,/keep_aspect,position=pos
   ctload,0,/silent
   ; -- overlay the coordinate axes & RA/Dec labels
  imcontour,cut,cuthdr,/nodata,position=pos,/noerase,$
    charthick=3,xthick=5,ythick=5,charsize=0.9

   loadct,39,/silent
   ; -- determine the x,y position of the object in the sub-image
   xyxy,imhdr,cuthdr,x[j],y[j],x2,y2
   rad0 = 1./0.6
   ; -- make ellipse 1" in diameter
  tvellipse,rad0,rad0,x2,y2,0,/data,col=150,noclip=0,thick=3
   rad = 2./0.6
   ; -- 2nd ellipse 2" in diameter
  tvellipse,rad,rad,x2,y2,0,/data,col=210,noclip=0,thick=3,linestyle=2
   ;xyouts,x2+rad-0.7,y2+rad-0.7,'APOGEE Fiber',/data,col=220,charthick=3

   ; -- Label the Star
   ; -- identification
  xyouts,1,1,strtrim(cat[j].id,1),col=150,alignment=0,/data,charsize=1.5,charthick=5
   ; -- B Magnitude
  xyouts,10,1,'B_mag= '+string(cat[j].b,format='(f6.2)'),charsize=1.5,col=150,charthick=5
   ; -- RRL Type
  xyouts,1,2.*win-2,cat[j].type,col=150,charsize=1.5,charthick=5
   ; -- Period
  xyouts,5,2.*win-2,'P = '+string(cat[j].p,format='(f4.2)')+' dy',charsize=1.5,charthick=5,col=150
   ; -- Field Name
  xyouts,1,2.*win+0.5,imname,/data,charthick=5,charsize=1.5,col=80

   ctload,0,/silent
   ; -- Make the scale bar
  colorbars,min=mins,max=maxs,position=[0.09,0.15,0.12,0.95],/vertical,title='MJy/sr'

 endif
  endfor

end
