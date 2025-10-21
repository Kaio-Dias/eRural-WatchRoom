# 🎬 eRural WatchRoom

> **Plataforma de assistir vídeos em sincronia com amigos** - Watch Together com YouTube, chat em tempo real e emojis flutuantes

[![Rails](https://img.shields.io/badge/Rails-8.0.3-red.svg)](https://rubyonrails.org/)
[![Vue.js](https://img.shields.io/badge/Vue.js-3.5.22-green.svg)](https://vuejs.org/)
[![ActionCable](https://img.shields.io/badge/ActionCable-WebSocket-blue.svg)](https://guides.rubyonrails.org/action_cable_overview.html)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://docs.docker.com/compose/)

## ✨ Funcionalidades

### 🎥 **Sincronização de Vídeo**
- **YouTube Integration**: Suporte completo ao YouTube
- **Sincronização em Tempo Real**: Play, pause e seek sincronizados entre todos os usuários
- **Troca de Vídeo**: Qualquer usuário pode trocar o vídeo para todos

### 💬 **Chat Interativo**
- **Mensagens em Tempo Real**: Chat instantâneo via ActionCable
- **Histórico de Mensagens**: Persistência das conversas
- **Emojis Rápidos**: Botões de emoji para reações instantâneas

### 🎭 **Emojis Flutuantes**
- **Reações Visuais**: Emojis que aparecem na tela durante o vídeo
- **Sincronização**: Todos veem as reações ao mesmo tempo
- **Diversos Emojis**: 🔥 😂 ❤️ 👏 👍

### 👥 **Sistema de Salas**
- **Salas Únicas**: Cada sala tem um ID único
- **Múltiplos Participantes**: Suporte a vários usuários simultâneos
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
- Node.js 18+ (para desenvolvimento local)
- Ruby 3.4+ (para desenvolvimento local)

### **Execução com Docker (Recomendado)**

1. **Clone o repositório**
```bash
git clone https://github.com/Kaio-Dias/eRural-WatchRoom.git
cd eRural-WatchRoom
```

2. **Configure as variáveis de ambiente**
```bash
# Backend
cp backend/.env.example backend/.env

# Frontend
cp frontend/.env.example frontend/.env
```

3. **Suba os serviços**
```bash
# Subir banco e cache
docker compose up -d db redis

# Criar e migrar banco
docker compose run --rm web bin/rails db:create db:migrate

# Subir aplicação
docker compose up -d web
```

4. **Acesse a aplicação**
- **Frontend**: http://localhost:8080
- **Backend API**: http://localhost:3000
- **PgAdmin**: http://localhost:5050

### **Desenvolvimento Local**

#### **Backend**
```bash
cd backend
bundle install
bin/rails db:create db:migrate
bin/rails server
```

#### **Frontend**
```bash
cd frontend
npm install
npm run serve
```

## 📡 API Endpoints

### **Salas**
- `POST /rooms` - Criar nova sala
- `GET /rooms/:slug` - Obter dados da sala
- `GET /room/:id` - Página da sala (compatibilidade)

### **Vídeos**
- `POST /rooms/:slug/videos` - Carregar novo vídeo
- `PATCH /rooms/:slug/videos/:id` - Atualizar estado do vídeo

### **WebSocket (ActionCable)**
- `ws://localhost:3000/cable` - Conexão WebSocket

## 🔧 Configuração

### **Variáveis de Ambiente**

#### **Backend (.env)**
```env
DATABASE_URL=postgres://postgres:postgres@db/backend_development
REDIS_URL=redis://redis:6379/0
RAILS_ENV=development
```

#### **Frontend (.env.development)**
```env
VUE_APP_API_URL=http://localhost:3000
VUE_APP_CABLE_URL=ws://localhost:3000/cable
```

## 🎯 Como Usar

1. **Acesse** http://localhost:8080
2. **Crie uma sala** com seu apelido
3. **Compartilhe o link** com seus amigos
4. **Cole uma URL do YouTube** e clique em "TROCAR"
5. **Use os emojis** para reagir durante o vídeo
6. **Chat** com outros participantes

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

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Kaio Dias**
- GitHub: [@Kaio-Dias](https://github.com/Kaio-Dias)
- LinkedIn: [Kaio Dias](https://www.linkedin.com/in/kaio-dias-0a84a1219)

## 🙏 Agradecimentos

- YouTube API pela integração de vídeos
- Rails ActionCable pela sincronização em tempo real
- Vue.js pela interface reativa
- Comunidade open source

---

⭐ **Se este projeto te ajudou, considere dar uma estrela!**