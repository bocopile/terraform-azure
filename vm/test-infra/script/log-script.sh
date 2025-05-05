#!/bin/bash
# [1] 기본 패키지 설치
sudo apt-get update
sudo apt-get install -y cifs-utils

# [2] 마운트 포인트 생성
sudo mkdir -p /log

# [3] Azure Storage 계정 이름, 키 설정
STORAGE_ACCOUNT_NAME="${storage_account_name}"
STORAGE_ACCOUNT_KEY="${storage_account_key}"
SHARE_NAME="logshare"

# [4] cifs로 Azure Files 마운트
sudo mount -t cifs //$STORAGE_ACCOUNT_NAME.file.core.windows.net/$SHARE_NAME /log \
  -o vers=3.0,username=$STORAGE_ACCOUNT_NAME,password=$STORAGE_ACCOUNT_KEY,dir_mode=0777,file_mode=0777,serverino

# [5] 자신의 hostname으로 디렉토리 생성
HOSTNAME=$(hostname)
mkdir -p /log/$HOSTNAME