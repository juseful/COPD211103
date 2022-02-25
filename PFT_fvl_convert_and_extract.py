# %%
import pandas as pd
import os
import time
import re
import math

# %%
workdir2 = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\2007\\"
savedir = "H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\FVL FILE\\"
match_key_st = len(workdir2)
match_key_length = 17
match_key_st

#%% 전체 file 정보추출
workdir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\"

filelist = []
for (root, dir, files) in os.walk(workdir):
    for file in files:
        if '.fvl' in file:
            file_path = os.path.join(root, file)
            filelist.append(file_path)

# filelist
# filelist[0][match_key_st:match_key_st+match_key_length]

len(filelist)

#%% 해당 정보 DataFrame, 기준값 생성
org_file = pd.DataFrame(filelist,columns=['FILE_PATH'])
org_file['FIND_FILE'] = org_file['FILE_PATH'].str[match_key_st:match_key_st+match_key_length]
org_file

#%% 추출대상
extract_data = pd.read_stata("H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\DATA_04_FVL_EXPORT.dta")
extract_data
#%% 추출 대상만 찾아내기
org_extract = pd.merge(org_file,extract_data,how='inner',on='FIND_FILE')
org_extract

#%%
org_extract_file = org_extract['FILE_PATH'].tolist()
org_extract_file

#%%
i=0
for file in org_extract_file:
    data = pd.read_fwf(file,header=None)
    convert_data = data.drop([0,1,2,3])
    save_info = savedir + org_extract.loc[i,]['NEW_NM'] + '.txt'
    convert_data.to_csv(save_info, index=False, header=False)
    i += 1

#%%
org_extract.to_excel(savedir+"fvl_extract.xlsx",index=False)

#%%
# mismatch file add
workdir2 = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\2007\\"
savedir = "H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\FVL FILE\\"
match_key_st = len(workdir2)
match_key_length = 17
match_key_st

#%%
workdir = "H:\\업무\\자료요청\\2021년\\DATA클리닝\\PFT_210900\\EXPORT_DATA\\01_ORGDATA\\"

filelist = []
for (root, dir, files) in os.walk(workdir):
    for file in files:
        if '.fvl' in file:
            file_path = os.path.join(root, file)
            filelist.append(file_path)

# filelist
# filelist[0][match_key_st:match_key_st+match_key_length]

len(filelist)

#%% 해당 정보 DataFrame, 기준값 생성
org_file = pd.DataFrame(filelist,columns=['FILE_PATH'])
org_file['FIND_FILE'] = org_file['FILE_PATH'].str[match_key_st:match_key_st+match_key_length-2]
org_file

#%% 추출대상
extract_data = pd.read_stata("H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\DATA_04_FVL_EXPORT_ADD.dta")
extract_data
#%% 추출 대상만 찾아내기
org_extract = pd.merge(org_file,extract_data,how='inner',on='FIND_FILE')
org_extract

#%%
org_extract_file = org_extract['FILE_PATH'].tolist()
org_extract_file

#%%
i=0
for file in org_extract_file:
    data = pd.read_fwf(file,header=None)
    convert_data = data.drop([0,1,2,3])
    save_info = savedir + org_extract.loc[i,]['NEW_NM'] + '.txt'
    convert_data.to_csv(save_info, index=False, header=False)
    i += 1

#%%
org_extract.to_excel(savedir+"fvl_extract_add.xlsx",index=False)

#%%
workdir = "H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\FVL FILE\\PFT FVL file\\"
match_key_st = len(workdir)
match_key_length = 21

filelist = []
for (root, dir, files) in os.walk(workdir):
    for file in files:
        if '.txt' in file:
            file_path = os.path.join(root, file)
            filelist.append(file_path)

len(filelist)

org_file = pd.DataFrame(filelist,columns=['FILE_PATH'])
org_file['FIND_FILE'] = org_file['FILE_PATH'].str[match_key_st:match_key_st+match_key_length]
org_file

org_file.to_excel("H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\FVL FILE\\fvl_extract_fin.xlsx",index=False)

#%%
# 이전 작업물. file을 하나씩 fully list check 하므로 시간이 오래걸리고 비효율적이었음.
# # file_seq = 0
# for i in range(len(extract_data)):
#     for file in filelist:
#         if extract_data.loc[i,]['FIND_FILE'] == file[match_key_st:match_key_st+match_key_length]:
#             data = pd.read_fwf(file,header=None)
#             convert_data = data.drop([0,1,2,3])
#             save_info = savedir + extract_data.loc[i,]['NEW_NM'] + '.txt'
#             convert_data.to_csv(save_info, index=False, header=False)
#         else:
#             pass

# #%%
# ext_file = []
# for (root, dir, files) in os.walk(savedir):
#     for file in files:
#         if '.txt' in file:
#             file_path = os.path.join(root, file)
#             ext_file.append(file_path)

# ext_file_data = pd.DataFrame(ext_file, columns=['fileinfo'])            
# ext_file_data.to_excel("H:\\업무\\자료요청\\2022년\\연구용\\황정혜_211103\\data\\FVL FILE\\sample.xlsx",index=False)
