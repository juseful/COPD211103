# %%
import pandas as pd
import os
import time
import re
import math

# %% CDW 변환함수
reg = re.compile(r'[0-9]')

def trns_ptno(ptno):
    temp_1 = int(str(ptno[:4]))
    temp_2 = int(str(ptno[4:]))
    CDW_ID = C1 + C2 + C3 + C4 + C5 + C6
    
    return CDW_ID

# %%
# file = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\2020\\00016242_20200108_000.fvl"
# test = pd.read_fwf(file,header=None)
# test

# # %%
# file = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\44118980_20200220_000.fvl"
# test = pd.read_fwf(file,header=None)
# test.drop(index=1,inplace=True)
# test.drop(index=2,inplace=True)
# test
# # test.to_csv("H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\test.txt", index=False, header=False)
# # test.to_fwf("H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\test.fvl")

# %%
# year = 2020
# workdir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\{}\\".format(year)
# savedir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\02_CONVERT\\{}\\".format(year)
workdir = "H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\export sample\\"
savedir = "H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\export sample\\"
ptno_st = len(workdir)
ptno_length = 8
etc_info = 6

filelist = []
for (root, dir, files) in os.walk(workdir):
    for file in files:
        if '.fvl' in file:
            file_path = os.path.join(root, file)
            filelist.append(file_path)

# filelist
filelist[0][ptno_st:ptno_st+ptno_length]

# %% 개인정보 중 first, last name만 삭제
# for file in filelist:
#     # file = filelist[0]
#     data = pd.read_fwf(file,header=None)
#     convert_data = data.drop([1,2])
#     ptno = file[ptno_st:ptno_st+ptno_length+1]
#     ptno_cdw = trns_ptno(ptno)
#     save_info = savedir+ptno_cdw+file[ptno_st+ptno_length-1:ptno_st+ptno_length+12]+".txt"
#     data.to_csv(save_info, index=False, header=False)

# %% 개인정보 모두 삭제
for file in filelist:
    # file = filelist[0]
    data = pd.read_fwf(file,header=None)
    convert_data = data.drop([0,1,2,3])
    ptno = file[ptno_st:ptno_st+ptno_length]
    ptno_cdw = trns_ptno(ptno)
    save_info = savedir+ptno_cdw+file[ptno_st+ptno_length:ptno_st+ptno_length+etc_info+1]+".txt"
    convert_data.to_csv(save_info, index=False, header=False)

# %%
st_time = time.time()
# %%
start_year = 2019
end_year = 2020

for year in range(start_year,end_year+1):
    workdir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\{}\\".format(year)
    savedir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\02_CONVERT\\{}\\".format(year)
    ptno_st = len(workdir)
    ptno_length = 8
    etc_info = 13

    filelist = []
    for (root, dir, files) in os.walk(workdir):
        for file in files:
            if '.fvl' in file:
                file_path = os.path.join(root, file)
                filelist.append(file_path)
                
    for file in filelist:
        # file = filelist[0]
        data = pd.read_fwf(file,header=None)
        convert_data = data.drop([0,1,2,3])
        ptno = file[ptno_st:ptno_st+ptno_length]
        ptno_cdw = trns_ptno(ptno)
        save_info = savedir+ptno_cdw+file[ptno_st+ptno_length:ptno_st+ptno_length+etc_info]+".txt"
        convert_data.to_csv(save_info, index=False, header=False)
# %%
start_year = 2008
end_year = 2020

filelist = []
for year in range(start_year,end_year+1):
    savedir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\02_CONVERT\\{}\\".format(year)
    ptno_st = len(workdir)
    # ptno_length = 8
    # etc_info = 13

    for (root, dir, files) in os.walk(savedir):
        for file in files:
            if '.txt' in file:
                file_path = os.path.join(root, file)
                filelist.append(file_path)

# %%
fileinfo = pd.DataFrame(filelist, columns=['fileinfo'])
print(len(fileinfo))

# %%
fileinfo.to_excel("H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\02_CONVERT\\PFT_fvlfile.xlsx",index=False)
# %%
