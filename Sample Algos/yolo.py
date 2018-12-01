#whiteboard finder
#finds whiteboards and performs homography to display its contents
#bengigameur

import numpy as np
import cv2

def PolyArea2D(pts): #http://stackoverflow.com/questions/19873596/convex-hull-area-in-python
    lines = np.hstack([pts,np.roll(pts,-1,axis=0)])
    area = 0.5*abs(sum(x1*y2-x2*y1 for x1,y1,x2,y2 in lines))
    return area

orig= cv2.imread('whiteboard.jpg')
o2=orig.copy()
img= cv2.imread('whiteboard.jpg',0)
ret3,th3 = cv2.threshold(img,250,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
im2, contours, hierarchy = cv2.findContours(th3,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
alist=[]
biggestcontour=[]
for contour in contours:
    #print contour[:,0]
    area=PolyArea2D(contour[:,0])
    alist.append(area)
    mx=max(alist) #largest contour
    if mx==area:
        biggestcontour=contour
    #print area

#cv2.drawContours(o2, [biggestcontour], -1, (0,255,0), 5)

#print biggestcontour

#finds bounding box of contour
#http://docs.opencv.org/master/dd/d49/tutorial_py_contour_features.html#gsc.tab=0
rect = cv2.minAreaRect(np.array(biggestcontour))
box = cv2.boxPoints(rect)
box = np.int0(box)
cv2.drawContours(o2,[box],0,(0,0,255),5)


cv2.imshow('',o2)
cv2.waitKey()

cv2.imwrite('whiteboarddetected.jpg',o2)