# Script para rodar migrations no Heroku via API
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Rodando Migrations no $AppName" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    Write-Host "Executando: bin/rails db:create db:migrate..." -ForegroundColor Yellow
    Write-Host ""
    
    $url = "https://api.heroku.com/apps/$AppName/dynos"
    $body = @{
        "command" = "bin/rails db:create db:migrate"
        "attach" = $false
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
    
    Write-Host "✅ Comando enviado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detalhes:" -ForegroundColor Cyan
    Write-Host "  Dyno: $($response.name)" -ForegroundColor White
    Write-Host "  Comando: $($response.command)" -ForegroundColor White
    Write-Host "  Estado: $($response.state)" -ForegroundColor White
    Write-Host ""
    Write-Host "Aguarde 10-20 segundos para as migrations completarem." -ForegroundColor Yellow
    Write-Host "Depois acesse: https://$AppName.herokuapp.com" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
}

