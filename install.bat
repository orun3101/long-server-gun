@echo off
setlocal enabledelayedexpansion
title Long Server Gun - Minecraft Mod Installer
color 0A

echo ============================================
echo   Long Server Gun - Minecraft 1.20.1 Forge
echo   Auto Installer
echo ============================================
echo.

set "PACKURL=https://raw.githubusercontent.com/orun3101/long-server-gun/main/pack.toml"
set "FORGEVER=1.20.1-47.4.10"
set "FORGEURL=https://maven.minecraftforge.net/net/minecraftforge/forge/%FORGEVER%/forge-%FORGEVER%-installer.jar"
set "BOOTSTRAPURL=https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar"
set "MCDIR=%APPDATA%\.minecraft"
set "WORKDIR=%~dp0_lsg_tools"

if not exist "%WORKDIR%" mkdir "%WORKDIR%"
if not exist "%MCDIR%" mkdir "%MCDIR%"

echo [1/5] Java 17 확인 중...
java -version 2>"%WORKDIR%\java_check.txt"
findstr /C:"17." "%WORKDIR%\java_check.txt" >nul
if errorlevel 1 (
    echo   Java 17이 없어서 설치할게요. 잠시만요...
    powershell -Command "Invoke-WebRequest -Uri 'https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse' -OutFile '%WORKDIR%\jdk17.msi'"
    msiexec /i "%WORKDIR%\jdk17.msi" /quiet /norestart ADDLOCAL=FeatureMain,FeatureEnvironment,FeatureJarFileRunWith
    echo   Java 17 설치 완료. (창이 안 뜨면 정상입니다)
    set "PATH=%ProgramFiles%\Eclipse Adoptium\jdk-17*\bin;%PATH%"
) else (
    echo   Java 17 이미 설치되어 있음. OK
)
echo.

echo [2/5] Forge %FORGEVER% 다운로드 중...
powershell -Command "Invoke-WebRequest -Uri '%FORGEURL%' -OutFile '%WORKDIR%\forge-installer.jar'"
if not exist "%WORKDIR%\forge-installer.jar" (
    echo   [오류] Forge 설치 파일 다운로드 실패. 인터넷 연결을 확인해주세요.
    pause
    exit /b 1
)
echo   완료.
echo.

echo [3/5] Forge 클라이언트 설치 중... (시간이 조금 걸려요)
java -jar "%WORKDIR%\forge-installer.jar" --installClient
echo   완료.
echo.

echo [4/5] 모드팩 설치 도구 다운로드 중...
powershell -Command "Invoke-WebRequest -Uri '%BOOTSTRAPURL%' -OutFile '%WORKDIR%\packwiz-installer-bootstrap.jar'"
echo   완료.
echo.

echo [5/5] 모드 다운로드 및 설치 중... (모드 용량이 커서 시간이 걸릴 수 있어요)
pushd "%MCDIR%"
java -jar "%WORKDIR%\packwiz-installer-bootstrap.jar" -g "%PACKURL%"
popd
echo.

echo ============================================
echo   설치 완료!
echo ============================================
echo.
echo 이제 마인크래프트 런처를 열고,
echo 버전 목록에서 "forge 1.20.1" 프로필을 선택한 뒤 Play 누르세요.
echo.
echo 서버 접속 주소: 192.168.219.108:25567
echo (멀티플레이 - 서버 추가 에서 위 주소를 입력하시면 됩니다)
echo.
pause
