# Script para limpar o cache do Heroku via API
# Execute: .\scripts\clear-heroku-cache.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Limpando Cache do Heroku" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Headers da API
$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    Write-Host "Limpando cache de build..." -ForegroundColor Yellow
    
    # Endpoint para limpar cache
    $url = "https://api.heroku.com/apps/$AppName/build-cache"
    
    $response = Invoke-RestMethod -Uri $url -Method Delete -Headers $headers
    
    Write-Host "✅ Cache limpo com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Agora você pode fazer o deploy novamente." -ForegroundColor Green
    Write-Host "O Heroku vai fazer um build limpo sem usar cache." -ForegroundColor Yellow
    
} catch {
    $errorMessage = $_.Exception.Message
    
    if ($errorMessage -like "*404*" -or $errorMessage -like "*Not Found*") {
        Write-Host "⚠️  Endpoint de cache não disponível ou já estava limpo." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Alternativa: Force um rebuild fazendo uma mudança no Dockerfile" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Erro ao limpar cache!" -ForegroundColor Red
        Write-Host "Detalhes: $errorMessage" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "Você também pode tentar:" -ForegroundColor Yellow
    Write-Host "1. Adicionar um comentário no Dockerfile.heroku" -ForegroundColor White
    Write-Host "2. Fazer commit e push" -ForegroundColor White
    Write-Host "3. Fazer deploy novamente" -ForegroundColor White
}

