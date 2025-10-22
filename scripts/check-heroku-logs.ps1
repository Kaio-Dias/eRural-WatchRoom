# Script para ver logs do Heroku via API
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName,
    [int]$Lines = 100
)

Write-Host "Buscando logs do Heroku..." -ForegroundColor Yellow
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
}

try {
    # Endpoint para criar sessão de logs
    $url = "https://api.heroku.com/apps/$AppName/log-sessions"
    $body = @{
        "lines" = $Lines
        "tail" = $false
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ContentType "application/json"
    
    Write-Host "Logs disponíveis em:" -ForegroundColor Green
    Write-Host $response.logplex_url -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Abrindo navegador com logs..." -ForegroundColor Yellow
    Start-Process $response.logplex_url
    
} catch {
    Write-Host "Erro ao buscar logs: $($_.Exception.Message)" -ForegroundColor Red
}

