# Script de deploy automatizado para Heroku (PowerShell)
# Uso: .\scripts\deploy-heroku.ps1 -AppName "seu-app-name"

param(
    [Parameter(Mandatory=$false)]
    [string]$AppName
)

Write-Host "🚀 eRural WatchRoom - Deploy no Heroku" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Solicitar nome do app se não foi fornecido
if (-not $AppName) {
    $AppName = Read-Host "Digite o nome do seu app Heroku"
}

Write-Host "📱 App: $AppName" -ForegroundColor Green

# Verificar Heroku CLI
if (-not (Get-Command heroku -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Heroku CLI não encontrado" -ForegroundColor Red
    Write-Host "Instale em: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
}

# Login
Write-Host "🔐 Verificando autenticação Heroku..." -ForegroundColor Yellow
heroku auth:whoami
if ($LASTEXITCODE -ne 0) {
    heroku login
}

# Verificar se app existe
Write-Host "📦 Verificando app..." -ForegroundColor Yellow
heroku apps:info -a $AppName 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Criando app $AppName..." -ForegroundColor Yellow
    heroku create $AppName
}

# Configurar stack
Write-Host "🐳 Configurando Docker stack..." -ForegroundColor Yellow
heroku stack:set container -a $AppName

# Adicionar PostgreSQL
Write-Host "📊 Verificando PostgreSQL..." -ForegroundColor Yellow
$addons = heroku addons -a $AppName | Out-String
if ($addons -notmatch "heroku-postgresql") {
    Write-Host "Adicionando PostgreSQL..." -ForegroundColor Yellow
    heroku addons:create heroku-postgresql:essential-0 -a $AppName
}

# Adicionar Redis
Write-Host "📮 Verificando Redis..." -ForegroundColor Yellow
if ($addons -notmatch "heroku-redis") {
    Write-Host "Adicionando Redis..." -ForegroundColor Yellow
    heroku addons:create heroku-redis:mini -a $AppName
}

# Configurar variáveis
Write-Host "⚙️  Configurando variáveis de ambiente..." -ForegroundColor Yellow

# Gerar SECRET_KEY_BASE
$secretKey = heroku config:get SECRET_KEY_BASE -a $AppName
if (-not $secretKey) {
    $bytes = New-Object byte[] 64
    [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
    $secretKey = [BitConverter]::ToString($bytes) -replace '-'
    heroku config:set SECRET_KEY_BASE=$secretKey -a $AppName
}

# Configurar outras variáveis
heroku config:set `
    RAILS_ENV=production `
    RAILS_LOG_TO_STDOUT=true `
    RAILS_SERVE_STATIC_FILES=true `
    WEB_CONCURRENCY=2 `
    RAILS_MAX_THREADS=5 `
    HEROKU_APP_NAME=$AppName `
    ACTION_CABLE_URL="wss://$AppName.herokuapp.com/cable" `
    ACTION_CABLE_FRONTEND_URL="https://$AppName.herokuapp.com" `
    -a $AppName

# Configurar remote Git
Write-Host "🔗 Configurando remote Git..." -ForegroundColor Yellow
$remotes = git remote
if ($remotes -notcontains "heroku") {
    heroku git:remote -a $AppName
} else {
    git remote set-url heroku "https://git.heroku.com/$AppName.git"
}

# Deploy
Write-Host "🚀 Iniciando deploy..." -ForegroundColor Green
git push heroku main --force

# Verificar deploy
Write-Host "🔍 Verificando deploy..." -ForegroundColor Yellow
heroku ps -a $AppName

# Sucesso
Write-Host "`n✅ Deploy concluído!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host "🌐 URL: https://$AppName.herokuapp.com" -ForegroundColor Green
Write-Host ""

$open = Read-Host "Abrir app no navegador? (s/N)"
if ($open -eq "s" -or $open -eq "S") {
    heroku open -a $AppName
}

Write-Host "`n📋 Comandos úteis:" -ForegroundColor Yellow
Write-Host "  heroku logs --tail -a $AppName"
Write-Host "  heroku ps -a $AppName"
Write-Host "  heroku config -a $AppName"
Write-Host "  heroku open -a $AppName"
Write-Host "`n🎉 Tudo pronto!" -ForegroundColor Green
