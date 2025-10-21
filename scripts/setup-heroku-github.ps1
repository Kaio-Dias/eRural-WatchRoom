# Script para configurar deploy via GitHub no Heroku
# Execute com: .\scripts\setup-heroku-github.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Configurando Deploy GitHub -> Heroku" -ForegroundColor Cyan
Write-Host "  App: $AppName" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Heroku CLI está instalado
Write-Host "Verificando Heroku CLI..." -ForegroundColor Yellow
$herokuInstalled = Get-Command heroku -ErrorAction SilentlyContinue
if (-not $herokuInstalled) {
    Write-Host "❌ Heroku CLI não encontrado!" -ForegroundColor Red
    Write-Host "   Baixe em: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Heroku CLI encontrado" -ForegroundColor Green
Write-Host ""

# Verificar login
Write-Host "Verificando autenticação..." -ForegroundColor Yellow
$authCheck = heroku auth:whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Não autenticado no Heroku!" -ForegroundColor Red
    Write-Host "   Execute: heroku login" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Autenticado como: $authCheck" -ForegroundColor Green
Write-Host ""

# Verificar se app existe
Write-Host "Verificando se app existe..." -ForegroundColor Yellow
$appExists = heroku apps:info -a $AppName 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  App não existe. Criando..." -ForegroundColor Yellow
    heroku create $AppName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Falha ao criar app!" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ App criado com sucesso" -ForegroundColor Green
} else {
    Write-Host "✅ App já existe" -ForegroundColor Green
}
Write-Host ""

# Adicionar remote do Heroku
Write-Host "Adicionando remote do Heroku..." -ForegroundColor Yellow
$remoteExists = git remote | Select-String "heroku"
if (-not $remoteExists) {
    heroku git:remote -a $AppName
    Write-Host "✅ Remote adicionado" -ForegroundColor Green
} else {
    Write-Host "✅ Remote já existe" -ForegroundColor Green
}
Write-Host ""

# Configurar stack para container
Write-Host "Configurando stack para container..." -ForegroundColor Yellow
heroku stack:set container -a $AppName
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Stack configurado como container" -ForegroundColor Green
} else {
    Write-Host "❌ Falha ao configurar stack" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Configurar variáveis de ambiente
Write-Host "Configurando variáveis de ambiente..." -ForegroundColor Yellow

Write-Host "  - RAILS_ENV=production"
heroku config:set RAILS_ENV=production -a $AppName | Out-Null

Write-Host "  - RAILS_SERVE_STATIC_FILES=true"
heroku config:set RAILS_SERVE_STATIC_FILES=true -a $AppName | Out-Null

Write-Host "  - RAILS_LOG_TO_STDOUT=true"
heroku config:set RAILS_LOG_TO_STDOUT=true -a $AppName | Out-Null

Write-Host "  - HEROKU_APP_NAME=$AppName"
heroku config:set HEROKU_APP_NAME=$AppName -a $AppName | Out-Null

Write-Host "  - ACTION_CABLE_URL=wss://$AppName.herokuapp.com/cable"
heroku config:set ACTION_CABLE_URL="wss://$AppName.herokuapp.com/cable" -a $AppName | Out-Null

Write-Host "  - ACTION_CABLE_FRONTEND_URL=https://$AppName.herokuapp.com"
heroku config:set ACTION_CABLE_FRONTEND_URL="https://$AppName.herokuapp.com" -a $AppName | Out-Null

# Gerar SECRET_KEY_BASE
Write-Host "  - Gerando SECRET_KEY_BASE..."
$secretKey = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
heroku config:set SECRET_KEY_BASE=$secretKey -a $AppName | Out-Null

Write-Host "✅ Variáveis configuradas" -ForegroundColor Green
Write-Host ""

# Adicionar PostgreSQL
Write-Host "Configurando PostgreSQL..." -ForegroundColor Yellow
$postgresExists = heroku addons -a $AppName 2>&1 | Select-String "heroku-postgresql"
if (-not $postgresExists) {
    Write-Host "  Criando banco de dados..."
    heroku addons:create heroku-postgresql:essential-0 -a $AppName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ PostgreSQL adicionado" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Falha ao adicionar PostgreSQL. Pode já existir ou precisar de billing." -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ PostgreSQL já existe" -ForegroundColor Green
}
Write-Host ""

# Adicionar Redis
Write-Host "Configurando Redis..." -ForegroundColor Yellow
$redisExists = heroku addons -a $AppName 2>&1 | Select-String "heroku-redis"
if (-not $redisExists) {
    Write-Host "  Criando Redis..."
    heroku addons:create heroku-redis:mini -a $AppName
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Redis adicionado" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Falha ao adicionar Redis. Pode já existir ou precisar de billing." -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ Redis já existe" -ForegroundColor Green
}
Write-Host ""

# Resumo
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Configuração Concluída!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Conectar GitHub ao Heroku:" -ForegroundColor White
Write-Host "   https://dashboard.heroku.com/apps/$AppName/deploy/github" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Ativar deploy automático na branch 'development'" -ForegroundColor White
Write-Host ""
Write-Host "3. Fazer deploy manual ou push para GitHub:" -ForegroundColor White
Write-Host "   git push origin development" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Ver logs:" -ForegroundColor White
Write-Host "   heroku logs --tail -a $AppName" -ForegroundColor Cyan
Write-Host ""
Write-Host "5. Abrir app:" -ForegroundColor White
Write-Host "   heroku open -a $AppName" -ForegroundColor Cyan
Write-Host ""
Write-Host "URL do app: https://$AppName.herokuapp.com" -ForegroundColor Green
Write-Host ""

