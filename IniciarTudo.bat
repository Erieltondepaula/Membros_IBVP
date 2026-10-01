@echo off
title Inicializador do Sistema IBVP
color 0B
cls
echo ==========================================
echo    INICIALIZANDO OS SERVICOS DO SISTEMA
echo ==========================================
echo.

echo [1/4] Limpando travas de portas e memoria...
taskkill /F /IM node.exe >nul 2>&1
taskkill /F /IM cmd.exe /FI "WINDOWTITLE eq http-server*" >nul 2>&1

echo [2/4] Garantindo que o Banco PostgreSQL esteja rodando...
net start postgresql-x64-17 >nul 2>&1

echo [3/4] Iniciando o Servidor Backend (API)...
cd backend
start "Node-Backend" /b node server.js
cd ..

echo [4/4] Iniciando o Frontend na porta CORRETA (8080)...
cd dist
:: O comando força o http-server a rodar estritamente na porta 8080 voltado para a pasta dist
:: Usa proxy de fallback para servir index.html em rotas SPA como /importacao
start "http-server" /b http-server -p 8080 -a 127.0.0.1 -c-1 -P http://127.0.0.1:8080?
cd ..

echo.
echo ==========================================
echo    SERVICOS ALINHADOS! ABRINDO O PAINEL...
echo ==========================================
timeout /t 3 >nul

start "" "interface.hta"
exit