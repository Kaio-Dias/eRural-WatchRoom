# Deploy via GitHub para Heroku (Docker)

Este guia mostra como fazer deploy da aplicação eRural no Heroku usando integração com GitHub e Docker.

## Pré-requisitos

1. Conta no Heroku: https://signup.heroku.com/
2. Heroku CLI instalado: https://devcenter.heroku.com/articles/heroku-cli
3. Repositório GitHub configurado

## Passo 1: Criar App no Heroku

```powershell
# Login no Heroku
heroku login

# Criar app (substitua 'erural' pelo nome desejado)
heroku create erural

# OU se o app já existe, conecte-o:
heroku git:remote -a nome-do-seu-app
```

## Passo 2: Configurar Stack para Container

O Heroku precisa saber que você está usando Docker:

```powershell
# Configure o stack para container
heroku stack:set container -a nome-do-seu-app
```

## Passo 3: Configurar Variáveis de Ambiente

```powershell
# Configurar variáveis necessárias
heroku config:set RAILS_ENV=production -a nome-do-seu-app
heroku config:set RAILS_SERVE_STATIC_FILES=true -a nome-do-seu-app
heroku config:set RAILS_LOG_TO_STDOUT=true -a nome-do-seu-app

# Gerar e configurar SECRET_KEY_BASE
heroku config:set SECRET_KEY_BASE=$(openssl rand -hex 64) -a nome-do-seu-app

# Configurar URLs do ActionCable (substitua 'nome-do-seu-app' pelo nome real)
heroku config:set HEROKU_APP_NAME=nome-do-seu-app -a nome-do-seu-app
heroku config:set ACTION_CABLE_URL=wss://nome-do-seu-app.herokuapp.com/cable -a nome-do-seu-app
heroku config:set ACTION_CABLE_FRONTEND_URL=https://nome-do-seu-app.herokuapp.com -a nome-do-seu-app
```

## Passo 4: Adicionar PostgreSQL

```powershell
# Adicionar PostgreSQL (gratuito)
heroku addons:create heroku-postgresql:essential-0 -a nome-do-seu-app

# Verificar se foi criado
heroku config -a nome-do-seu-app | grep DATABASE_URL
```

## Passo 5: Adicionar Redis

```powershell
# Adicionar Redis (gratuito)
heroku addons:create heroku-redis:mini -a nome-do-seu-app

# Verificar se foi criado
heroku config -a nome-do-seu-app | grep REDIS_URL
```

## Passo 6: Conectar GitHub ao Heroku

### Via Dashboard (Recomendado)

1. Acesse: https://dashboard.heroku.com/apps/nome-do-seu-app/deploy/github
2. Clique em "Connect to GitHub"
3. Autorize o Heroku a acessar sua conta GitHub
4. Busque pelo repositório "eRural" ou "Kaio-Dias/eRural"
5. Clique em "Connect"

### Configurar Deploy Automático

1. Na mesma página, na seção "Automatic deploys":
2. Selecione a branch `development` (ou `main`)
3. (Opcional) Marque "Wait for CI to pass before deploy" se tiver CI configurado
4. Clique em "Enable Automatic Deploys"

## Passo 7: Fazer o Primeiro Deploy

Você tem duas opções:

### Opção A: Deploy Manual via Dashboard

1. Na página de deploy, vá para "Manual deploy"
2. Selecione a branch `development`
3. Clique em "Deploy Branch"

### Opção B: Push para o GitHub (se deploy automático estiver ativado)

```powershell
git add -A
git commit -m "Configure for Heroku deployment"
git push origin development
```

O Heroku detectará automaticamente o push e iniciará o deploy.

## Passo 8: Verificar o Deploy

```powershell
# Ver logs em tempo real
heroku logs --tail -a nome-do-seu-app

# Verificar status do app
heroku ps -a nome-do-seu-app

# Abrir app no navegador
heroku open -a nome-do-seu-app
```

## Passo 9: Executar Migrations (se necessário)

```powershell
# Rodar migrations manualmente se necessário
heroku run bin/rails db:migrate -a nome-do-seu-app

# Verificar o banco de dados
heroku run bin/rails db:version -a nome-do-seu-app
```

## Estrutura de Arquivos Importante

O deploy via GitHub com Docker requer:

- ✅ `heroku.yml` - Configuração do Heroku para Docker
- ✅ `Dockerfile.heroku` - Dockerfile otimizado para Heroku
- ✅ `Procfile` - Define o comando para iniciar a aplicação

## Troubleshooting

### Erro: "No default language could be detected"

**Causa**: O stack não está configurado como `container`.

**Solução**:
```powershell
heroku stack:set container -a nome-do-seu-app
```

### Erro: Build falha no Docker

**Verificar**:
1. O `Dockerfile.heroku` existe na raiz do projeto
2. O `heroku.yml` aponta para `Dockerfile.heroku`
3. O build local funciona: `docker build -f Dockerfile.heroku -t erural .`

### Erro: ActionCable não conecta

**Verificar variáveis**:
```powershell
heroku config -a nome-do-seu-app | grep ACTION_CABLE
heroku config -a nome-do-seu-app | grep HEROKU_APP_NAME
```

### Erro: Database não existe

```powershell
heroku run bin/rails db:create db:migrate -a nome-do-seu-app
```

## Monitoramento

```powershell
# Ver logs
heroku logs --tail -a nome-do-seu-app

# Ver métricas
heroku ps -a nome-do-seu-app

# Acessar console Rails
heroku run bin/rails console -a nome-do-seu-app

# Acessar bash
heroku run bash -a nome-do-seu-app
```

## Deploy de Novas Alterações

Depois da configuração inicial, para fazer deploy de novas alterações:

1. Faça suas alterações no código
2. Commit:
   ```powershell
   git add -A
   git commit -m "Descrição das alterações"
   ```
3. Push para GitHub:
   ```powershell
   git push origin development
   ```
4. O Heroku detectará automaticamente e fará o deploy

## Comandos Úteis

```powershell
# Ver configurações
heroku config -a nome-do-seu-app

# Adicionar variável de ambiente
heroku config:set VARIAVEL=valor -a nome-do-seu-app

# Remover variável de ambiente
heroku config:unset VARIAVEL -a nome-do-seu-app

# Escalar dynos
heroku ps:scale web=1 -a nome-do-seu-app

# Reiniciar app
heroku restart -a nome-do-seu-app

# Ver informações do app
heroku info -a nome-do-seu-app
```

## Custos Estimados

### Plano Gratuito/Eco
- **Web Dyno (Eco)**: $5/mês (ou gratuito com créditos)
- **PostgreSQL (Essential-0)**: $5/mês
- **Redis (Mini)**: $3/mês
- **Total**: ~$13/mês (ou menos com créditos gratuitos)

### Notas
- Heroku oferece créditos gratuitos para estudantes
- Apps eco "dormem" após 30min de inatividade
- Primeiro deploy pode levar 5-10 minutos

