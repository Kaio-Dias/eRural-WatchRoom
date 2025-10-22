# Script para adicionar PostgreSQL ao Heroku via API
param(
    [Parameter(Mandatory=$true)]
    [string]$HerokuApiToken,
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Adicionando PostgreSQL ao Heroku" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$headers = @{
    "Authorization" = "Bearer $HerokuApiToken"
    "Accept" = "application/vnd.heroku+json; version=3"
    "Content-Type" = "application/json"
}

try {
    Write-Host "Adicionando Heroku Postgres (essential-0)..." -ForegroundColor Yellow
    
    $url = "https://api.heroku.com/apps/$AppName/addons"
    $body = @{
        "plan" = "heroku-postgresql:essential-0"
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
    
    Write-Host "✅ PostgreSQL adicionado com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detalhes:" -ForegroundColor Cyan
    Write-Host "  Nome: $($response.name)" -ForegroundColor White
    Write-Host "  Plano: $($response.plan.name)" -ForegroundColor White
    Write-Host "  Estado: $($response.state)" -ForegroundColor White
    Write-Host ""
    Write-Host "O banco de dados estará disponível em alguns instantes." -ForegroundColor Yellow
    Write-Host "Aguarde 1-2 minutos e tente o deploy novamente." -ForegroundColor Yellow
    
} catch {
    $errorMessage = $_.Exception.Message
    Write-Host "❌ Erro ao adicionar PostgreSQL!" -ForegroundColor Red
    Write-Host "Detalhes: $errorMessage" -ForegroundColor Red
    Write-Host ""
    
    if ($errorMessage -like "*payment*" -or $errorMessage -like "*billing*") {
        Write-Host "⚠️  É necessário adicionar um método de pagamento no Heroku." -ForegroundColor Yellow
        Write-Host "   Mesmo para o plano gratuito, o Heroku requer cartão cadastrado." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Acesse: https://dashboard.heroku.com/account/billing" -ForegroundColor Cyan
    }
}

