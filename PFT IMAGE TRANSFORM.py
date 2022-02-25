#%%
import cv2
import numpy as np
import pytesseract
from matplotlib import pyplot as plt
from glob import glob
from pytesseract import Output
import re
import os
import pandas as pd
import math

import os.path
import time
import datetime
from win32_setfiletime import setctime, setmtime, setatime

#%%
# 환자번호가 숫자로 되어져 있는지 여부 확인
reg = re.compile(r'[0-9]')

# # 10진수를 2,8,16진수로 변경하는 함수
# def conv(number,base):
#   T="0123456789ABCDEF"
#   i,j=divmod(number,base)
 
#   if i==0:
#     return T[j]
#   else:
#     return conv(i,base)+T[j]

def trns_ptno(ptno):
    temp_1 = int(str(ptno[:4]))
    temp_2 = int(str(ptno[4:]))
    CDW_ID = C1 + C2 + C3 + C4 + C5 + C6
    
    return CDW_ID

#%%
def print_files_in_dir(root_dir, prefix):
    files = os.listdir(root_dir)
    for file in files:
        path = os.path.join(root_dir, file)
        if os.path.isdir(path):
            print_files_in_dir(path, prefix + "    ")
        filedir.append(path)

#%%
for year in range(2018,2019):
    year = year
    filedir = []

    if __name__ == "__main__":
        root_dir = "K:/PFT_IMAGE_DATA/{}".format(year)
        print_files_in_dir(root_dir, "",filedir)

    filelist = [filedir for filedir in filedir if '.JPG' in filedir.upper()]

    savepath = "W:/PFT DATA/PFT IMAGE/{}/".format(year)
    
    for file in filelist:
        
        # 원본 이미지가 손상된 경우는 pass
        try:
            img = cv2.imread(file)
            y, x, l = img.shape

            ptno = file[len(root_dir)+6:len(root_dir)+6+8]

            CDW_NO = trns_ptno(ptno)

            remain = file[len(root_dir)+6+8:]

            saveinfo = savepath + CDW_NO + remain
            
            x_start = 0
            x_end = x
            y_start = 0 # 상단의 병원과 센터 명칭 삭제
            y_end = 270
            
            if y != 1500:
                # logical poly ratio apply
                y_start = round(y/1500*y_start)
                y_end = round(y/1500*y_end)
                pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
                img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
                cv2.imwrite(saveinfo,img)

            else:
                pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
                img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
                cv2.imwrite(saveinfo,img)

        except AttributeError:
            pass

        # file properties time information modify, 1990-01-01 00:00:00 apply
        try:
            setctime(saveinfo, 631119600.000)
            setmtime(saveinfo, 631119600.000)
            setatime(saveinfo, 631119600.000)
        except FileNotFoundError:
            pass

    year += 1
#%%
#변환 완료된 파일
filedir = []

if __name__ == "__main__":
    root_dir = "W:/PFT DATA/PFT IMAGE/{}".format('2018')
    print_files_in_dir(root_dir, "")


trnsfile = [filedir for filedir in filedir if '.JPG' in filedir.upper()]
trnsfile
#%%
for year in range(2018,2019):
    year = year
    filedir = []

    if __name__ == "__main__":
        root_dir = "K:/PFT_IMAGE_DATA/{}".format(year)
        print_files_in_dir(root_dir, "")

    filelist = [filedir for filedir in filedir if '.JPG' in filedir.upper()]

    savepath = "W:/PFT DATA/PFT IMAGE/{}/".format(year)
    
    for file in filelist:
        
        # 원본 이미지가 손상된 경우는 pass
        try:
            ptno = file[len(root_dir)+6:len(root_dir)+6+8]

            CDW_NO = trns_ptno(ptno)

            remain = file[len(root_dir)+6+8:]

            saveinfo = savepath + CDW_NO + remain
            
            if saveinfo in trnsfile:
                pass
            else:
                img = cv2.imread(file)
                y, x, l = img.shape
                
                x_start = 0
                x_end = x
                y_start = 0 # 상단의 병원과 센터 명칭 삭제
                y_end = 270
                
                if y != 1500:
                    # logical poly ratio apply
                    y_start = round(y/1500*y_start)
                    y_end = round(y/1500*y_end)
                    pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
                    img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
                    cv2.imwrite(saveinfo,img)

                else:
                    pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
                    img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
                    cv2.imwrite(saveinfo,img)

        except AttributeError:
            pass

        # file properties time information modify, 1990-01-01 00:00:00 apply
        try:
            setctime(saveinfo, 631119600.000)
            setmtime(saveinfo, 631119600.000)
            setatime(saveinfo, 631119600.000)
        except FileNotFoundError:
            pass

    year += 1
#%%
filedir = []
if __name__ == "__main__":
    root_dir = "W:/PFT DATA/PFT IMAGE/TEST IMG"
    print_files_in_dir(root_dir, "")

filelist = [filedir for filedir in filedir if '.JPG' in filedir.upper()]
# filelist

#%%
savepath = "W:/PFT DATA/PFT IMAGE/TEST IMG/result"

for file in filelist:

    # 원본 이미지가 손상된 경우는 pass
    try:
        img = cv2.imread(file)
        y, x, l = img.shape

        fileinfo = file[len(root_dir)+1:]
        saveinfo = savepath + "/Mod_"+ fileinfo

        x_start = 0
        x_end = x
        y_start = 100
        y_end = 270
        
        if y != 1500:
            # logical poly ratio accept
            y_start = round(y/1500*y_start)
            y_end = round(y/1500*y_end)
            pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
            img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
            cv2.imwrite(saveinfo,img)
            # pop-up window check
            # cv2.namedWindow(file[22:31],cv2.WINDOW_NORMAL)
            # cv2.imshow(file[22:31],img)
            # cv2.resizeWindow(file[22:31],795,995)
            # cv2.moveWindow(file[22:31],0,0)
            # cv2.waitKey()
            # cv2.destroyAllWindows()
        else:
            pts = np.array([[x_start,y_start], [x_end,y_start],[x_end,y_end],[x_start,y_end]])
            img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
            cv2.imwrite(saveinfo,img)
            # pop-up window check
            # cv2.namedWindow(file[22:31],cv2.WINDOW_NORMAL)
            # cv2.imshow(file[22:31],img)
            # cv2.resizeWindow(file[22:31],795,995)
            # cv2.moveWindow(file[22:31],0,0)
            # cv2.waitKey()
            # cv2.destroyAllWindows()

    except AttributeError:
        pass

    # file properties time information modify, 1990-01-01 00:00:00
    try:
        setctime(saveinfo, 631119600.000)
        setmtime(saveinfo, 631119600.000)
        setatime(saveinfo, 631119600.000)
    except FileNotFoundError:
        pass

# %%
file = "W:/PFT DATA/PFT IMAGE/TEST IMG/1500X1060.jpg"
img = cv2.imread(file)
y, x, l = img.shape

pts = np.array([[0,100], [x,100],[x,270],[0,270]])
img = cv2.fillPoly(img,[pts],(50,100,50),cv2.LINE_AA)
cv2.namedWindow(file[22:31])
cv2.imshow(file[22:31],img)
cv2.waitKey()
cv2.destroyAllWindows()

#%%

file = "W:/PFT DATA/PFT IMAGE/TEST IMG/1500X1060.jpg"
img = cv2.imread(file)
y, x, l = img.shape

pts = np.array([[0,100], [x,100],[x,270],[0,270]])
img = cv2.fillPoly(img,[pts],(255,255,255),cv2.LINE_AA)
# cv2.namedWindow(file[22:31])
# cv2.imshow(file[22:31],img)
# cv2.waitKey()
# cv2.destroyAllWindows()

savepath = "W:/PFT DATA/PFT IMAGE/TEST IMG/result"
fileinfo = file[len(root_dir):]
saveinfo = savepath + fileinfo

cv2.imwrite(saveinfo,img)

setctime(saveinfo, 631119600.000)
setmtime(saveinfo, 631119600.000)
setatime(saveinfo, 631119600.000)

#%%
# from win32_setfiletime import setctime, setmtime, setatime
setctime(saveinfo, 631119600.000)
setmtime(saveinfo, 631119600.000)
setatime(saveinfo, 631119600.000)

# setctime(saveinfo, 1000000000.000)
# setmtime(saveinfo, 1000000000.000)
# setatime(saveinfo, 1000000000.000)

#%%
# year = 1991
# mths = 1
# date = 1
# hour = 0
# mins = 0
# secs = 0

# date = datetime.datetime(year=year, month=mths, day=date, hour=hour,minute=mins, second=secs)
# modTime = time.mktime(date.timetuple())
# os.utime(saveinfo,(modTime, modTime))
print(saveinfo)
# # extract old date:
date = datetime.datetime.fromtimestamp(os.path.getctime(saveinfo))
date
# create a new date with the same time, but on 2015 - 08 - 22
new_date = datetime.datetime(1901, 1, 1, 0, 0, 0)
new_date.strftime('%m/%d/%Y %H:%M:%S')
# # set the file creation date with the "-d" switch, which presumably stands for "dodification"
# os.system('SetFile -d "{}" {}'.format(new_date.strftime('%m/%d/%Y %H:%M:%S'), saveinfo))
# # set the file modification date with the "-m" switch
# os.system('SetFile -m "{}" {}'.format(new_date.strftime('%m/%d/%Y %H:%M:%S'), saveinfo))

#%%
import os
import os.path
import time
import datetime

file = 'W:/PFT IMAGE/TEST IMG/result/1500X1060.jpg'

year = 1991
mths = 1
date = 1
hour = 0
mins = 0
secs = 0

date = datetime.datetime(year=year, month=mths, day=date, hour=hour,minute=mins, second=secs)
modTime = time.mktime(date.timetuple())

os.utime(file, (modTime, modTime))

# date = datetime.datetime.fromtimestamp(os.path.getctime(file))
# new_date = datetime.datetime(1901, 1, 1, 0, 0, 0)
# # set the file creation date with the "-d" switch, which presumably stands for "dodification"
# os.system('SetFile -d "{}" {}'.format(new_date.strftime('%m/%d/%Y %H:%M:%S'), file))
# # set the file modification date with the "-m" switch
# os.system('SetFile -m "{}" {}'.format(new_date.strftime('%m/%d/%Y %H:%M:%S'), file))

# %%
