#!/bin/bash

# Script de deploy automatizado para Heroku
# Uso: ./scripts/deploy-heroku.sh [app-name]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 eRural WatchRoom - Deploy no Heroku${NC}"
echo "================================================"

# Verificar se app name foi fornecido
if [ -z "$1" ]; then
    echo -e "${YELLOW}⚠️  Nome do app não fornecido${NC}"
    echo "Uso: ./scripts/deploy-heroku.sh <app-name>"
    echo ""
    read -p "Digite o nome do seu app Heroku: " APP_NAME
else
    APP_NAME=$1
fi

echo -e "${GREEN}📱 App: $APP_NAME${NC}"

# Verificar se Heroku CLI está instalado
if ! command -v heroku &> /dev/null; then
    echo -e "${RED}❌ Heroku CLI não encontrado${NC}"
    echo "Instale em: https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Login
echo -e "${YELLOW}🔐 Fazendo login no Heroku...${NC}"
heroku auth:whoami || heroku login

# Verificar se app existe
if heroku apps:info -a $APP_NAME &> /dev/null; then
    echo -e "${GREEN}✅ App $APP_NAME encontrado${NC}"
else
    echo -e "${YELLOW}📦 Criando app $APP_NAME...${NC}"
    heroku create $APP_NAME
fi

# Configurar stack
echo -e "${YELLOW}🐳 Configurando Docker stack...${NC}"
heroku stack:set container -a $APP_NAME

# Adicionar add-ons se não existirem
echo -e "${YELLOW}🔌 Verificando add-ons...${NC}"

if ! heroku addons -a $APP_NAME | grep -q "heroku-postgresql"; then
    echo -e "${YELLOW}📊 Adicionando PostgreSQL...${NC}"
    heroku addons:create heroku-postgresql:essential-0 -a $APP_NAME
fi

if ! heroku addons -a $APP_NAME | grep -q "heroku-redis"; then
    echo -e "${YELLOW}📮 Adicionando Redis...${NC}"
    heroku addons:create heroku-redis:mini -a $APP_NAME
fi

# Configurar variáveis de ambiente
echo -e "${YELLOW}⚙️  Configurando variáveis de ambiente...${NC}"

# Gerar SECRET_KEY_BASE se não existir
if ! heroku config:get SECRET_KEY_BASE -a $APP_NAME &> /dev/null || [ -z "$(heroku config:get SECRET_KEY_BASE -a $APP_NAME)" ]; then
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    heroku config:set SECRET_KEY_BASE=$SECRET_KEY_BASE -a $APP_NAME
fi

# Configurar outras variáveis
heroku config:set \
  RAILS_ENV=production \
  RAILS_LOG_TO_STDOUT=true \
  RAILS_SERVE_STATIC_FILES=true \
  WEB_CONCURRENCY=2 \
  RAILS_MAX_THREADS=5 \
  HEROKU_APP_NAME=$APP_NAME \
  ACTION_CABLE_URL=wss://$APP_NAME.herokuapp.com/cable \
  ACTION_CABLE_FRONTEND_URL=https://$APP_NAME.herokuapp.com \
  -a $APP_NAME

# Adicionar remote do Heroku
echo -e "${YELLOW}🔗 Configurando remote Git...${NC}"
if ! git remote | grep -q "heroku"; then
    heroku git:remote -a $APP_NAME
else
    git remote set-url heroku https://git.heroku.com/$APP_NAME.git
fi

# Deploy
echo -e "${GREEN}🚀 Iniciando deploy...${NC}"
git push heroku main --force

# Verificar deploy
echo -e "${YELLOW}🔍 Verificando deploy...${NC}"
heroku ps -a $APP_NAME

# Abrir app
echo ""
echo -e "${GREEN}✅ Deploy concluído!${NC}"
echo "================================================"
echo -e "🌐 URL: ${GREEN}https://$APP_NAME.herokuapp.com${NC}"
echo ""
read -p "Abrir app no navegador? (s/N): " OPEN_BROWSER

if [[ $OPEN_BROWSER =~ ^[Ss]$ ]]; then
    heroku open -a $APP_NAME
fi

echo ""
echo -e "${YELLOW}📋 Comandos úteis:${NC}"
echo "  heroku logs --tail -a $APP_NAME"
echo "  heroku ps -a $APP_NAME"
echo "  heroku config -a $APP_NAME"
echo "  heroku open -a $APP_NAME"
echo ""
echo -e "${GREEN}🎉 Tudo pronto!${NC}"
