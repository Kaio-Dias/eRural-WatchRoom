# Script para configurar stack do Heroku como container via API
# Execute: .\scripts\configure-heroku-stack.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Configurando Stack via API do Heroku" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Endpoint da API do Heroku
$apiUrl = "https://api.heroku.com/apps/$AppName"

# Headers
$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    Write-Host "Atualizando stack para 'container'..." -ForegroundColor Yellow
    
    $body = @{
        "build_stack" = "container"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $apiUrl -Method Patch -Headers $headers -Body $body
    
    Write-Host "✅ Stack configurado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detalhes do app:" -ForegroundColor Cyan
    Write-Host "  Nome: $($response.name)" -ForegroundColor White
    Write-Host "  Stack: $($response.build_stack.name)" -ForegroundColor White
    Write-Host "  Region: $($response.region.name)" -ForegroundColor White
    Write-Host ""
    Write-Host "Agora você pode fazer deploy via GitHub!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Erro ao configurar stack!" -ForegroundColor Red
    Write-Host "Detalhes: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique:" -ForegroundColor Yellow
    Write-Host "  1. Token de API está correto" -ForegroundColor White
    Write-Host "  2. Nome do app está correto: $AppName" -ForegroundColor White
    Write-Host "  3. Você tem permissão para modificar o app" -ForegroundColor White
    exit 1
}

