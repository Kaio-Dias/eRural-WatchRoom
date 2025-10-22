# Script para criar novo app Heroku completo
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Criando novo app: $AppName" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    # 1. Criar app
    Write-Host "1. Criando app..." -ForegroundColor Yellow
    $createUrl = "https://api.heroku.com/apps"
    $createBody = @{
        "name" = $AppName
        "region" = "us"
        "stack" = "container"
    } | ConvertTo-Json
    
    $app = Invoke-RestMethod -Uri $createUrl -Method Post -Headers $headers -Body $createBody
    Write-Host "   ✅ App criado: $($app.web_url)" -ForegroundColor Green
    Write-Host ""
    
    # 2. Adicionar PostgreSQL
    Write-Host "2. Adicionando PostgreSQL..." -ForegroundColor Yellow
    $addonsUrl = "https://api.heroku.com/apps/$AppName/addons"
    $postgresBody = @{
        "plan" = "heroku-postgresql:essential-0"
    } | ConvertTo-Json
    
    Start-Sleep -Seconds 2
    $postgres = Invoke-RestMethod -Uri $addonsUrl -Method Post -Headers $headers -Body $postgresBody
    Write-Host "   ✅ PostgreSQL adicionado" -ForegroundColor Green
    Write-Host ""
    
    # 3. Configurar variáveis de ambiente
    Write-Host "3. Configurando variáveis de ambiente..." -ForegroundColor Yellow
    $configUrl = "https://api.heroku.com/apps/$AppName/config-vars"
    
    $secretKey = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
    
    $configVars = @{
        "RAILS_ENV" = "production"
        "RAILS_SERVE_STATIC_FILES" = "true"
        "RAILS_LOG_TO_STDOUT" = "true"
        "HEROKU_APP_NAME" = $AppName
        "ACTION_CABLE_URL" = "wss://$AppName.herokuapp.com/cable"
        "ACTION_CABLE_FRONTEND_URL" = "https://$AppName.herokuapp.com"
        "SECRET_KEY_BASE" = $secretKey
    } | ConvertTo-Json
    
    Start-Sleep -Seconds 2
    Invoke-RestMethod -Uri $configUrl -Method Patch -Headers $headers -Body $configVars | Out-Null
    Write-Host "   ✅ Variáveis configuradas" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  App criado com sucesso!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Detalhes:" -ForegroundColor Yellow
    Write-Host "  Nome: $AppName" -ForegroundColor White
    Write-Host "  URL: https://$AppName.herokuapp.com" -ForegroundColor Cyan
    Write-Host "  Dashboard: https://dashboard.heroku.com/apps/$AppName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🔗 Próximo passo:" -ForegroundColor Yellow
    Write-Host "  1. Conecte o GitHub em: https://dashboard.heroku.com/apps/$AppName/deploy/github" -ForegroundColor White
    Write-Host "  2. Conecte ao repositório: Kaio-Dias/eRural-WatchRoom" -ForegroundColor White
    Write-Host "  3. Faça deploy manual da branch 'main'" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Message -like "*Name is already taken*") {
        Write-Host ""
        Write-Host "⚠️  O nome '$AppName' já está em uso." -ForegroundColor Yellow
        Write-Host "   Tente outro nome!" -ForegroundColor Yellow
    }
}

