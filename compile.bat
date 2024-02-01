@echo off
odin build . 
IF NOT ERRORLEVEL 1 (
    fr.exe .\test cpp "idk " "sure " -y
    copy fr.exe c:\software\fr.exe /Y
)