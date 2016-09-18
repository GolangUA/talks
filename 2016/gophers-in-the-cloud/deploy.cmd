@if "%SCM_TRACE_LEVEL%" NEQ "4" @echo off

:: ----------------------
:: KUDU Deployment Script
:: Version: 1.0.8
:: ----------------------

:: Prerequisites
:: -------------

:: Verify node.js installed
where node 2>nul >nul
IF %ERRORLEVEL% NEQ 0 (
  echo Missing node.js executable, please install node.js, if already installed make sure it can be reached from current environment.
  goto error
)

:: Setup
:: -----

setlocal enabledelayedexpansion

SET ARTIFACTS=%~dp0%..\artifacts

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

IF NOT DEFINED DEPLOYMENT_TARGET (
  SET DEPLOYMENT_TARGET=%ARTIFACTS%\wwwroot
)

IF NOT DEFINED NEXT_MANIFEST_PATH (
  SET NEXT_MANIFEST_PATH=%ARTIFACTS%\manifest

  IF NOT DEFINED PREVIOUS_MANIFEST_PATH (
    SET PREVIOUS_MANIFEST_PATH=%ARTIFACTS%\manifest
  )
)

IF NOT DEFINED KUDU_SYNC_CMD (
  :: Install kudu sync
  echo Installing Kudu Sync
  call npm install kudusync -g --silent
  IF !ERRORLEVEL! NEQ 0 goto error

  :: Locally just running "kuduSync" would also work
  SET KUDU_SYNC_CMD=%appdata%\npm\kuduSync.cmd
)
goto Deployment

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Deployment
:: ----------

:Deployment
ECHO Handling Go deployment.
IF /I "%IN_PLACE_DEPLOYMENT%" EQU "1" (
  ECHO Go web app does not support in-place deployment
  goto error
)

ECHO Prepare workspace
IF NOT EXIST "%GOROOT%" (
  IF DEFINED GO_WEB_CONFIG_TEMPLATE (
    :: it is running on Azure
    CALL PowerShell -NoProfile -NoLogo -ExecutionPolicy unrestricted -Command "&('%SELECT_LATEST_VERSION_CMD%') '%ProgramW6432%\Go' '%DEPLOYMENT_TEMP%\___GO_RUNTIME.tmp'"
    IF !ERRORLEVEL! NEQ 0 goto error
    
    PUSHD "%DEPLOYMENT_TEMP%"
    for /f %%i in (___GO_RUNTIME.tmp) do (
      SET GO_RUNTIME_VERSION=%%i
      GOTO :ENDLOOP
    )
    :ENDLOOP
    POPD

    ECHO Detected Go %GO_RUNTIME_VERSION% from Azure
    SET GOROOT=%ProgramW6432%\Go\%GO_RUNTIME_VERSION%
  ) 

  IF NOT DEFINED GO_WEB_CONFIG_TEMPLATE (
    :: Non-Azure environment, GOROOT must be defined
    ECHO Go not found, please defined GOROOT environment variable
    goto error
  )
)
ECHO GOROOT %GOROOT%
:: Create Go workspace in DEPLOYMENT_TEMP
::      DEPLOYMENT_TEMP\bin, DEPLOYMENT_TEMP\pkg, DEPLOYMENT_TEMP\src
SET GOPATH=%DEPLOYMENT_TEMP%\gopath
SET GOEXE="%GOROOT%\bin\go.exe"
SET FOLDERNAME=azureapp
SET GOAZUREAPP=%DEPLOYMENT_TEMP%\gopath\src\%FOLDERNAME%
IF NOT EXIST %GOEXE% (
  ECHO go.exe not found!
  goto error
)

IF EXIST %GOPATH% (
    ECHO GOPATH already exist %GOPATH%
) else (
    ECHO Creating GOPATH\bin %GOPATH%\bin
    MKDIR "%GOPATH%\bin"
    
    ECHO Creating GOPATH\pkg %GOPATH%\pkg
    MKDIR "%GOPATH%\pkg"
    
    ECHO Creating GOPATH\src %GOPATH%\src
    MKDIR "%GOPATH%\src"
    
    ECHO Creating %GOAZUREAPP%
    MKDIR "%GOAZUREAPP%"
)

ECHO Copy source code to Go workspace
ROBOCOPY "%DEPLOYMENT_SOURCE%" "%GOAZUREAPP%" /E /NFL /NDL /NP /XD .git .hg /XF .deployment deploy.cmd

PUSHD "%GOAZUREAPP%"
ECHO Installing glide
%GOEXE% get "github.com/Masterminds/glide"
ECHO Resolving dependencies
SET GLIDEEXE="%GOPATH%\bin\glide.exe"

IF NOT EXIST %GLIDEEXE% (
  ECHO glide.exe not found!
  goto error
)
SET PATH=%PATH%%GOROOT%\bin

%GLIDEEXE% --debug install

ECHO Building Go app to produce exe file
%GOEXE% build -o "%DEPLOYMENT_SOURCE%\%FOLDERNAME%.exe" %FOLDERNAME%
POPD

ECHO Copy files for deployment
call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd;*.go"
IF !ERRORLEVEL! NEQ 0 goto error

:: Clean up
DEL /Q /F "%DEPLOYMENT_SOURCE%\%FOLDERNAME%.exe"

IF DEFINED GO_WEB_CONFIG_TEMPLATE (
    :: web.config copy is specific to Azure, if environment variable not defined, must be run from other environment. Skip this action
    ECHO Copy web.config
    IF NOT EXIST "%DEPLOYMENT_TARGET%\web.config" (
        COPY "%GO_WEB_CONFIG_TEMPLATE%" "%DEPLOYMENT_TARGET%\web.config"
        IF !ERRORLEVEL! NEQ 0 goto error
    ) else (
        ECHO web.config already existed. Skip!
    )
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
goto end

:: Execute command routine that will echo out when error
:ExecuteCmd
setlocal
set _CMD_=%*
call %_CMD_%
if "%ERRORLEVEL%" NEQ "0" echo Failed exitCode=%ERRORLEVEL%, command=%_CMD_%
exit /b %ERRORLEVEL%

:error
endlocal
echo An error has occurred during web site deployment.
call :exitSetErrorLevel
call :exitFromFunction 2>nul

:exitSetErrorLevel
exit /b 1

:exitFromFunction
()

:end
endlocal
echo Finished successfully.
