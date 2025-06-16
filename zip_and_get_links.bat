chcp 65001
@echo off
setlocal enabledelayedexpansion

:: ===== 配置 GitHub 参数 =====
:: 仓库信息请手动填写
set GITHUB_USER=Goojoe
set GITHUB_REPO=FileShare
set GITHUB_BRANCH=master

:: 当前路径
set CURDIR=%cd%

:: 创建输出目录
mkdir zipped 2>nul

echo 正在使用 7-Zip 压缩文件夹...

:: 遍历所有子目录进行压缩
for /d %%F in (*) do (
    if /i not "%%F"=="zipped" if /i not "%%F"=="7zip" (
        echo 正在压缩 %%F ...
        7zip\7z a -tzip "zipped\%%F.zip" "%%F\*" >nul
    )
)

echo.
echo 所有文件夹已压缩，GitHub Raw 链接如下：
echo.

:: 创建临时链接文本
set TMP_LINKS_FILE=%TEMP%\links.txt
break > "%TMP_LINKS_FILE%"

for %%Z in (zipped\*.zip) do (
    set ZIPNAME=%%~nxZ
    echo https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/%GITHUB_BRANCH%/zipped/!ZIPNAME!>> "%TMP_LINKS_FILE%"
    echo https://raw.githubusercontent.com/%GITHUB_USER%/%GITHUB_REPO%/%GITHUB_BRANCH%/zipped/!ZIPNAME!
)

:: 复制到剪贴板
type "%TMP_LINKS_FILE%" | clip

echo.
echo 🔗 所有链接已复制到剪贴板！
pause