@echo off

SET FORMATTER_DIR=%~dp0

%JULIA_167% --project=%FORMATTER_DIR% %FORMATTER_DIR%\format.jl