# 🚀 Deploy no Heroku - eRural WatchRoom

Guia completo para fazer deploy da aplicação no Heroku usando Docker.

## 📋 Pré-requisitos

- Conta no Heroku (https://heroku.com)
- Heroku CLI instalado (https://devcenter.heroku.com/articles/heroku-cli)
- Docker instalado localmente
- Git configurado

## 🔧 Instalação da Heroku CLI

### Windows
```powershell
# Via Chocolatey
choco install heroku-cli

# Ou baixe o instalador em:
# https://devcenter.heroku.com/articles/heroku-cli
```

### macOS
```bash
brew tap heroku/brew && brew install heroku
```

### Linux
```bash
curl https://cli-assets.heroku.com/install.sh | sh
```

## 🎯 Passo a Passo do Deploy

### 1. Login no Heroku

```bash
heroku login
heroku container:login
```

### 2. Criar Aplicação no Heroku

```bash
# Criar app (nome único)
heroku create seu-app-erural-watchroom

# Ou deixar o Heroku gerar um nome
heroku create

# Salvar o nome do app
export HEROKU_APP_NAME=seu-app-erural-watchroom
```

### 3. Adicionar Add-ons Necessários

```bash
# PostgreSQL (banco de dados)
heroku addons:create heroku-postgresql:essential-0

# Redis (para ActionCable e cache)
heroku addons:create heroku-redis:mini

# Verificar add-ons
heroku addons
```

### 4. Configurar Variáveis de Ambiente

```bash
# Gerar SECRET_KEY_BASE
export SECRET_KEY_BASE=$(openssl rand -hex 64)

# Configurar variáveis
heroku config:set \
  RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  SECRET_KEY_BASE=$SECRET_KEY_BASE \
  WEB_CONCURRENCY=2 \
  RAILS_MAX_THREADS=5 \
  HEROKU_APP_NAME=$HEROKU_APP_NAME

# ActionCable URLs (substitua pelo seu app name)
heroku config:set \
  ACTION_CABLE_URL=wss://$HEROKU_APP_NAME.herokuapp.com/cable \
  ACTION_CABLE_FRONTEND_URL=https://$HEROKU_APP_NAME.herokuapp.com

# Verificar configurações
heroku config
```

### 5. Configurar Stack para Docker

```bash
# Definir stack como container
heroku stack:set container

# Verificar
heroku stack
```

### 6. Build e Deploy

#### Opção A: Deploy via Git (Recomendado)

```bash
# Adicionar remote do Heroku (se não foi criado automaticamente)
heroku git:remote -a $HEROKU_APP_NAME

# Commit das mudanças
git add .
git commit -m "chore: configurações para deploy Heroku"

# Push para Heroku
git push heroku main
```

#### Opção B: Deploy via Container Registry

```bash
# Build da imagem
docker build -f Dockerfile.heroku -t registry.heroku.com/$HEROKU_APP_NAME/web .

# Push da imagem
docker push registry.heroku.com/$HEROKU_APP_NAME/web

# Release
heroku container:release web
```

### 7. Executar Migrações

```bash
# Se não foi executado automaticamente
heroku run rails db:migrate

# (Opcional) Seed do banco
heroku run rails db:seed
```

### 8. Verificar Deploy

```bash
# Abrir app no navegador
heroku open

# Ver logs em tempo real
heroku logs --tail

# Verificar processos rodando
heroku ps

# Verificar health check
curl https://$HEROKU_APP_NAME.herokuapp.com/up
```

## 🔍 Troubleshooting

### Logs e Debug

```bash
# Ver últimos logs
heroku logs --tail

# Ver logs específicos
heroku logs --source app --tail

# Ver informações do app
heroku apps:info

# Verificar configurações
heroku config
```

### Problemas Comuns

#### 1. **Erro de Migração**
```bash
# Executar manualmente
heroku run rails db:migrate

# Resetar banco (CUIDADO: apaga dados!)
heroku pg:reset DATABASE_URL
heroku run rails db:migrate db:seed
```

#### 2. **WebSocket não conecta**
```bash
# Verificar variáveis ActionCable
heroku config:get ACTION_CABLE_URL
heroku config:get ACTION_CABLE_FRONTEND_URL

# Reconfigurar se necessário
heroku config:set ACTION_CABLE_URL=wss://$HEROKU_APP_NAME.herokuapp.com/cable
```

#### 3. **App não inicia**
```bash
# Verificar build logs
heroku builds

# Verificar processo web
heroku ps:scale web=1

# Restart
heroku restart
```

#### 4. **Assets não carregam**
```bash
# Verificar se RAILS_SERVE_STATIC_FILES está setado
heroku config:get RAILS_SERVE_STATIC_FILES

# Setar se necessário
heroku config:set RAILS_SERVE_STATIC_FILES=true
```

## 🔄 Atualizações e Manutenção

### Deploy de Nova Versão

```bash
# Commit mudanças
git add .
git commit -m "feat: nova funcionalidade"

# Push
git push heroku main

# Verificar
heroku logs --tail
```

### Rollback

```bash
# Ver releases
heroku releases

# Fazer rollback
heroku rollback v123
```

### Escalar Aplicação

```bash
# Mais dynos web
heroku ps:scale web=2

# Mais workers (se tiver)
heroku ps:scale worker=1
```

### Backup do Banco

```bash
# Criar backup manual
heroku pg:backups:capture

# Listar backups
heroku pg:backups

# Download backup
heroku pg:backups:download
```

## 💰 Custos Estimados

### Plano Básico (Desenvolvimento)
- **Dyno Eco**: $5/mês (substitui o free tier)
- **PostgreSQL Essential-0**: $5/mês
- **Redis Mini**: $3/mês
- **Total**: ~$13/mês

### Plano Produção
- **Dyno Standard-1X**: $25/mês
- **PostgreSQL Standard-0**: $50/mês
- **Redis Premium-0**: $15/mês
- **Total**: ~$90/mês

## 🔐 Segurança

### Variáveis Sensíveis

```bash
# Nunca commitar:
# - SECRET_KEY_BASE
# - DATABASE_URL
# - REDIS_URL
# - Credentials de API

# Sempre usar heroku config:set
```

### SSL/TLS

```bash
# Heroku fornece SSL automaticamente
# Mas você pode adicionar certificado custom:
heroku certs:add
```

## 📊 Monitoramento

### Métricas

```bash
# Ver métricas
heroku metrics

# Dashboard web
heroku addons:open heroku-redis
heroku addons:open heroku-postgresql
```

### Alertas

```bash
# Configurar via dashboard Heroku
# Settings → Alerts
```

## 🚀 Próximos Passos

1. **Domínio Customizado**
```bash
heroku domains:add www.seu-dominio.com
```

2. **CDN para Assets**
```bash
# Configurar CloudFront ou similar
```

3. **Monitoring**
```bash
# Adicionar New Relic ou similar
heroku addons:create newrelic
```

4. **CI/CD**
```bash
# Integrar com GitHub Actions
# Ver: .github/workflows/deploy.yml
```

## 📚 Recursos Adicionais

- [Heroku Dev Center](https://devcenter.heroku.com/)
- [Heroku Postgres](https://devcenter.heroku.com/articles/heroku-postgresql)
- [Heroku Redis](https://devcenter.heroku.com/articles/heroku-redis)
- [Container Registry](https://devcenter.heroku.com/articles/container-registry-and-runtime)

---

**Deploy realizado com sucesso! 🎉**

Acesse: https://$HEROKU_APP_NAME.herokuapp.com
