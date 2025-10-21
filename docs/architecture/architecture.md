# Arquitetura do Projeto WatchTogether

## Visão Geral

Este documento descreve a arquitetura do projeto WatchTogether, um sistema de salas de vídeo colaborativas. A arquitetura foi projetada para ser modular, escalável e fácil de manter, seguindo as melhores práticas de desenvolvimento de software.

## Componentes Principais

O sistema é dividido em dois componentes principais:

1.  **Backend (API RESTful):** Desenvolvido em Ruby on Rails, responsável pela lógica de negócios, gerenciamento de salas, usuários e vídeos.
2.  **Frontend (Single Page Application):** Desenvolvido em Vue.js, responsável pela interface do usuário e interação em tempo real.

## Arquitetura do Backend

O backend segue o padrão **Model-View-Controller (MVC)**, com os seguintes componentes:

*   **Models:** Representam as entidades do sistema, como `Room`, `User` e `Video`.
*   **Views:** São responsáveis por renderizar as respostas da API em formato JSON.
*   **Controllers:** Gerenciam as requisições HTTP, aplicam a lógica de negócios e interagem com os models.

## Arquitetura do Frontend

O frontend é uma **Single Page Application (SPA)** construída com Vue.js. A arquitetura é baseada em componentes, com os seguintes elementos:

*   **Componentes:** Pequenos e reutilizáveis, responsáveis por renderizar partes específicas da interface.
*   **Views:** Combinam componentes para formar as diferentes páginas da aplicação.
*   **Router:** Gerencia a navegação entre as views.
*   **Store:** Centraliza o estado da aplicação, utilizando Pinia.

## Comunicação

A comunicação entre o frontend e o backend é feita através de uma **API RESTful**. Para a comunicação em tempo real, como o chat e a sincronização de vídeo, são utilizados **WebSockets** através do Action Cable do Rails.

## Implantação

A aplicação é projetada para ser implantada no **Heroku** utilizando **Docker**. O banco de dados utilizado é o **PostgreSQL** e o **Redis** é utilizado para o Action Cable.
