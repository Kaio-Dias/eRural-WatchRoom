# Script para reiniciar o app Heroku via API
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "Reiniciando app $AppName..." -ForegroundColor Yellow

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
}

try {
    $url = "https://api.heroku.com/apps/$AppName/dynos"
    Invoke-RestMethod -Uri $url -Method Delete -Headers $headers | Out-Null
    
    Write-Host "✅ App reiniciado com sucesso!" -ForegroundColor Green
    Write-Host "Aguarde alguns segundos e tente um novo deploy." -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
}

