@echo off

SET BASEPATH=%~dp0
SET REVISE_PATH="%BASEPATH%\revise"

DEL "%REVISE_PATH%\Manifest.toml"

%JULIA_184% --color=yes --project=%REVISE_PATH% --load=%REVISE_PATH%\revise.jl
