# 🎬 eRural WatchRoom

> **Plataforma de assistir vídeos em sincronia com amigos** - Watch Together com YouTube, chat em tempo real e emojis flutuantes

[![Rails](https://img.shields.io/badge/Rails-8.0.3-red.svg)](https://rubyonrails.org/)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.5.22-green.svg)](https://vuejs.org/)
[![ActionCable](https://img.shields.io/badge/ActionCable-WebSocket-blue.svg)](https://guides.rubyonrails.org/action_cable_overview.html)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)

## ✨ Funcionalidades

### 🎥 **Sincronização de Vídeo**
- **YouTube Integration**: Suporte completo ao YouTube
- **Troca de Vídeo**: O usuário pode trocar o vídeo

### 🎭 **Emojis Flutuantes**
- **Reações Visuais**: Emojis que aparecem na tela durante o vídeo
- **Diversos Emojis**: 🔥 😂 ❤️ 👏 👍

### 👥 **Sistema de Salas**
- **Sem Login**: Não é necessário cadastro para participar

## 🏗️ Arquitetura

### **Backend (Rails 8.0)**
- **API RESTful**: Endpoints para gerenciar salas e vídeos
- **ActionCable**: WebSockets para sincronização em tempo real
- **PostgreSQL**: Banco de dados para persistência
- **Redis**: Cache e sessões

### **Frontend (Vue.js 3)**
- **SPA**: Single Page Application
- **YouTube Player API**: Integração com player do YouTube
- **WebSocket Client**: Conexão com ActionCable
- **Responsive Design**: Interface adaptável

## 🚀 Instalação e Execução

### **Pré-requisitos**
- Docker e Docker Compose
- Node.js 22+ (para desenvolvimento local)
- Ruby 3.4.7+ (para desenvolvimento local)

### **Execução com Docker (Recomendado)**

1. **Clone o repositório**
```bash
git clone https://github.com/Kaio-Dias/eRural-WatchRoom.git
cd eRural-WatchRoom
```

2. **Suba os serviços**
```bash
# Subir banco, databaseAdmin, cache
docker compose --build no-cache
docker compose up -d

# Migrar banco
docker compose run --rm web bin/rails db:create db:migrate
```

4. **Acesse a aplicação**
- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:3000
- **PgAdmin**: http://localhost:5050

## 📡 API Endpoints

### **Salas**
- `POST /rooms` - Criar nova sala
- `GET /rooms/:slug` - Obter dados da sala
- `GET /room/:id` - Página da sala (compatibilidade)

### **WebSocket (ActionCable)**
- `ws://localhost:3000/cable` - Conexão WebSocket

## 🎯 Como Usar

1. **Acesse** http://localhost:8080
2. **Crie uma sala** com seu apelido
3. **Cole uma URL do YouTube** e clique em "TROCAR"
4. **Use os emojis** para reagir durante o vídeo
5. **Chat** com outros participantes

## 🛠️ Tecnologias

### **Backend**
- **Ruby on Rails 8.0** - Framework web
- **ActionCable** - WebSockets
- **PostgreSQL** - Banco de dados
- **Redis** - Cache e sessões
- **Docker** - Containerização

### **Frontend**
- **Vue.js 3** - Framework JavaScript
- **YouTube Player API** - Player de vídeo
- **Bootstrap 5** - UI Framework
- **Font Awesome** - Ícones
- **Tailwind CSS** - Estilização

## 📊 Estrutura do Projeto

```
eRural-WatchRoom/
├── backend/                 # API Rails
│   ├── app/
│   │   ├── channels/        # ActionCable channels
│   │   ├── controllers/     # API controllers
│   │   ├── models/          # ActiveRecord models
│   │   └── services/        # Business logic
│   ├── config/
│   │   ├── cable.yml        # ActionCable config
│   │   └── routes.rb         # API routes
│   └── db/                  # Database migrations
├── frontend/                # Vue.js SPA
│   ├── src/
│   │   ├── components/      # Vue components
│   │   ├── services/        # API services
│   │   ├── views/           # Pages
│   │   └── store/           # Vuex store
│   └── public/              # Static assets
├── docker-compose.yml       # Docker services
└── README.md               # This file
```

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Kaio Dias**
- GitHub: [@Kaio-Dias](https://github.com/Kaio-Dias)
- LinkedIn: [Kaio Dias](https://www.linkedin.com/in/kaio-dias-0a84a1219)
