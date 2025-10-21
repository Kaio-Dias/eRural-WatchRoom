# 🤝 Guia de Contribuição

Obrigado por considerar contribuir com o eRural WatchRoom! Este documento fornece diretrizes para contribuir com o projeto.

## 📋 Como Contribuir

### 1. **Fork e Clone**
```bash
# Fork o repositório no GitHub
# Depois clone seu fork
git clone https://github.com/SEU-USUARIO/eRural-WatchRoom.git
cd eRural-WatchRoom
```

### 2. **Configurar Ambiente**
```bash
# Instalar dependências
docker compose up -d db redis
docker compose run --rm web bin/rails db:create db:migrate
```

### 3. **Criar Branch**
```bash
git checkout -b feature/nome-da-feature
# ou
git checkout -b fix/descricao-do-bug
```

### 4. **Desenvolver**
- Faça suas alterações
- Teste localmente
- Siga as convenções de código

### 5. **Commit e Push**
```bash
git add .
git commit -m "feat: adiciona nova funcionalidade"
git push origin feature/nome-da-feature
```

### 6. **Pull Request**
- Abra um PR no GitHub
- Descreva as mudanças
- Aguarde revisão

## 🎯 Tipos de Contribuição

### 🐛 **Bug Fixes**
- Corrija bugs existentes
- Adicione testes para evitar regressões
- Documente a correção

### ✨ **Novas Funcionalidades**
- Implemente features solicitadas
- Mantenha compatibilidade
- Adicione documentação

### 📚 **Documentação**
- Melhore README
- Adicione exemplos
- Corrija typos

### 🧪 **Testes**
- Adicione testes unitários
- Melhore cobertura
- Testes de integração

## 📝 Convenções de Código

### **Backend (Ruby/Rails)**
```ruby
# Use snake_case para métodos e variáveis
def create_room
  @room = Room.create!(room_params)
end

# Use PascalCase para classes
class RoomChannel < ApplicationCable::Channel
end

# Comentários em português
# [AI Generated] Data: 21/10/2025
# Descrição: Cria nova sala de vídeo
```

### **Frontend (Vue.js)**
```javascript
// Use camelCase para métodos e variáveis
const createRoom = () => {
  // implementação
}

// Use PascalCase para componentes
export default {
  name: 'RoomPage'
}

// Comentários em português
// Conecta ao ActionCable para sincronização
```

### **Commits**
Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: adiciona sistema de emojis flutuantes
fix: corrige sincronização de vídeo
docs: atualiza README com novas funcionalidades
style: melhora layout do chat
refactor: otimiza conexão WebSocket
test: adiciona testes para RoomChannel
```

## 🧪 Testes

### **Backend**
```bash
# Executar testes Rails
docker compose run --rm web bin/rails test

# Testes específicos
docker compose run --rm web bin/rails test test/channels/room_channel_test.rb
```

### **Frontend**
```bash
# Executar testes Vue
cd frontend
npm run test:unit
```

## 📋 Checklist para PR

- [ ] Código segue convenções do projeto
- [ ] Testes passam localmente
- [ ] Documentação atualizada
- [ ] Commits seguem padrão
- [ ] Não há conflitos
- [ ] Descrição clara do PR

## 🐛 Reportando Bugs

Use o template de issue:

```markdown
## 🐛 Descrição do Bug
Descrição clara do problema.

## 🔄 Passos para Reproduzir
1. Vá para '...'
2. Clique em '...'
3. Veja o erro

## ✅ Comportamento Esperado
O que deveria acontecer.

## 📱 Ambiente
- OS: [ex: Windows 10]
- Browser: [ex: Chrome 120]
- Versão: [ex: 1.0.0]

## 📸 Screenshots
Se aplicável, adicione screenshots.
```

## ✨ Sugerindo Features

Use o template de feature request:

```markdown
## 🚀 Feature Request
Descrição da funcionalidade desejada.

## 💡 Solução Proposta
Como você imagina que deveria funcionar.

## 🔄 Alternativas Consideradas
Outras soluções que você considerou.

## 📋 Contexto Adicional
Qualquer contexto adicional sobre a feature.
```

## 📞 Suporte

- **Issues**: Use o sistema de issues do GitHub
- **Discussions**: Use GitHub Discussions para dúvidas
- **Email**: [seu-email@exemplo.com]

## 🏆 Reconhecimento

Contribuidores serão listados no README e receberão créditos apropriados.

---

**Obrigado por contribuir com o eRural WatchRoom! 🎬✨**
