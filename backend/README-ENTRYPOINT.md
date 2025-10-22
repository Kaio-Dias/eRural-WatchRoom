# Docker Entrypoint e Database Migrations

Este projeto usa um script `docker-entrypoint.sh` para garantir que o banco de dados esteja pronto antes de iniciar a aplicação.

## Como funciona

O entrypoint executa as seguintes etapas quando você roda `docker compose up -d`:

1. ✅ **Aguarda PostgreSQL**: Verifica se o PostgreSQL está aceitando conexões na porta 5432
2. ✅ **Cria o banco de dados**: Se não existir, cria `backend_development`
3. ✅ **Inicia a aplicação**: Executa o servidor Puma

## ⚠️ Migrations

**IMPORTANTE**: As migrations **NÃO são executadas automaticamente** pelo entrypoint devido a problemas de timeout do comando `rails db:migrate` durante a inicialização do container.

### Como executar migrations

Você tem 3 opções:

#### Opção 1: Script PowerShell (Recomendado)
```powershell
.\scripts\run-migrations-local.ps1
```

Este script tenta executar `bin/rails db:migrate` e, se falhar, usa o arquivo `migrations.sql` como fallback.

#### Opção 2: Comando Rails manual
```bash
docker compose exec web bin/rails db:migrate
```

#### Opção 3: SQL direto no PostgreSQL
```bash
Get-Content migrations.sql | docker compose exec -T db psql -U postgres -d backend_development
```

## Workflow Completo

```powershell
# 1. Subir os containers
docker compose up -d

# 2. Aguardar inicialização (5-10 segundos)

# 3. Executar migrations
.\scripts\run-migrations-local.ps1

# 4. Acessar a aplicação
# Frontend: http://localhost:8080
# Backend: http://localhost:3000
```

## Logs do Entrypoint

Para ver os logs:

```bash
docker compose logs web
```

Você verá:
```
==> Waiting for PostgreSQL to be ready...
==> PostgreSQL is ready!
==> Ensuring database 'backend_development' exists...
==> Database ready!
==> NOTE: Run 'docker compose exec web bin/rails db:migrate' to apply migrations
==> Starting application...
```

## Troubleshooting

### Problema: "Database does not exist"
**Solução**: O entrypoint cria o banco automaticamente. Se ainda assim o erro persistir:
```bash
docker compose exec web bin/rails db:create
```

### Problema: "PendingMigrationError"
**Solução**: Execute as migrations:
```bash
.\scripts\run-migrations-local.ps1
```

### Problema: Migrations travando
**Solução**: Use SQL direto:
```bash
Get-Content migrations.sql | docker compose exec -T db psql -U postgres -d backend_development
```

## Arquitetura

```
docker compose up -d
       ↓
  [Entrypoint]
       ↓
    Aguarda PostgreSQL (até 30 tentativas, 2s cada)
       ↓
    Cria banco se não existir
       ↓
    Inicia Puma (Rails servidor)
       ↓
  Aplicação rodando (mas sem tabelas ainda!)
       ↓
[VOCÊ EXECUTA]: .\scripts\run-migrations-local.ps1
       ↓
  Migrations aplicadas ✅
       ↓
  Aplicação 100% funcional! 🎉
```

## Por que não executar migrations automaticamente?

O comando `bin/rails db:migrate` trava durante a inicialização do container devido a:
- Carregamento completo do ambiente Rails
- Possível deadlock com o Puma inicializando
- Timeout de comandos Rails em modo de inicialização

A solução adotada é:
1. Entrypoint garante banco pronto ✅
2. Usuário executa migrations quando quiser ✅
3. Migrations persistem no volume do PostgreSQL ✅
4. Próximos `docker compose up -d` não precisam de migrations ✅
