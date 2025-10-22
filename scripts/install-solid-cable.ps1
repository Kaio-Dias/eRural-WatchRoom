# Script para instalar Solid Cable no Heroku
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Instalando Solid Cable no $AppName" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    Write-Host "1. Rodando migrations do Solid Cable..." -ForegroundColor Yellow
    
    $url = "https://api.heroku.com/apps/$AppName/dynos"
    $body = @{
        "command" = "bin/rails solid_cable:install:migrations && bin/rails db:migrate"
        "attach" = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
    
    Write-Host "   ✅ Migrations iniciadas!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Aguarde 30 segundos para completar..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    Write-Host ""
    Write-Host "2. Reiniciando app para aplicar mudanças..." -ForegroundColor Yellow
    $restartUrl = "https://api.heroku.com/apps/$AppName/dynos"
    Invoke-RestMethod -Uri $restartUrl -Method Delete -Headers $headers | Out-Null
    
    Write-Host "   ✅ App reiniciado!" -ForegroundColor Green
    Write-Host ""
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "  Solid Cable instalado com sucesso!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Agora teste novamente com múltiplos usuários!" -ForegroundColor Yellow
    Write-Host "URL: https://$AppName.herokuapp.com" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
}

