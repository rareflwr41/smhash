pro plot_on_img,imname,imdata,imhdr,cat0

   ; -- figure out the input image dimensions
  impix = n_elements(imdata)
  imdim = size(imdata)

   ; -- position ithe plot with enough white space on edges;
   ;    the plot will be in square pizels
  pos = [0.15,0.15,0.95,0.95]
 
   loadct,0,/silent
   ; -- display the image
  cgimage,imdata,minvalue=-1,maxvalue=3,/keep_aspect,position=pos
   ctload,0,/silent
   ; -- make the plot borders and RA/Dec labels
  imcontour,imdata,imhdr,/nodata,position=pos,/noerase,$
    charthick=3,xthick=5,ythick=5,charsize=1.5
 
   ; -- convert RA/Dec coordinate to image X,Y
  adxy,imhdr,cat0.ra,cat0.dec,x,y
   ; -- determine which objects are actually in the image footprint
   inimg = where(x gt 0 and x lt imdim[1] and y gt 0 and y lt imdim[2])
   ; -- cut the x,y coordinates and catalog down to those objects in the image
  x = x(inimg)
  y = y(inimg)
  cat = cat0[inimg]

  loadct,39,/silent
  ; -- plot for each object in the image 
 for j = 0, n_elements(x)-1 do begin
   ; -- circle on the object
  tvellipse,5,5,x[j],y[j],0,/data,col=150,noclip=0,thick=5
   ; -- label each object with its RR type
  xyouts,x[j]+7,y[j]+7,cat[j].type,col=150,charsize=1.2,charthick=2. 
 endfor

  ; -- label the image with its field designation
 xyouts,10,imdim[2]+12,imname,charthick=5,charsize=1.5,col=80

end
