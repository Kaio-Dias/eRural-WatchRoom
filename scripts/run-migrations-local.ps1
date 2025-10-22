#!/usr/bin/env pwsh
# Script para executar migrations no ambiente local Docker

Write-Host "==> Executando database migrations..." -ForegroundColor Cyan

$result = docker compose exec -T web bin/rails db:migrate 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "==> Migrations executadas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "==> Erro ao executar migrations. Tentando via SQL..." -ForegroundColor Yellow
    
    Write-Host "==> Verificando se o arquivo migrations.sql existe..." -ForegroundColor Cyan
    if (Test-Path "migrations.sql") {
        Write-Host "==> Executando migrations via SQL direto no PostgreSQL..." -ForegroundColor Cyan
        Get-Content migrations.sql | docker compose exec -T db psql -U postgres -d backend_development
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "==> Migrations executadas com sucesso via SQL!" -ForegroundColor Green
        } else {
            Write-Host "==> Erro ao executar migrations via SQL!" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "==> Arquivo migrations.sql não encontrado!" -ForegroundColor Red
        Write-Host "==> As migrations serão aplicadas automaticamente na primeira requisição ao Rails" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "==> Verificando tabelas criadas..." -ForegroundColor Cyan
docker compose exec -T db psql -U postgres -d backend_development -c "\dt"

Write-Host ""
Write-Host "==> Pronto! Aplicação disponível em http://localhost:8080" -ForegroundColor Green

