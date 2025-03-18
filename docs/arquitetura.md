# Arquitetura da Aplicação - BehavAI

## Visão Geral

foome é uma aplicação Ruby on Rails 8.0.3 que implementa um SaaS Enabled Marketplace B2B que é um benefício para funcionários de empresas.

## Boas práticas

O objetivo é criar uma aplicação escalável, modular e fácil de manter, seguindo princípios como DRY (Don't Repeat Yourself), Clean Code e design limpo.

- Documente todos os arquivos criados com comentários em cada função, método, classe, componente e input e output de dados. Precisamos que cada arquivo seja auto explicativo com seus respectivos comentários.
- Desenvolva o frontend de forma componentizada utilizando TailwindCSS e ERB, com componentes pequenos e com responsabilidade única.
- Obrigatoriamente utilize SRP (Single Responsability Principle) em todos os arquivos criados.
- Obrigatoriamente utilize DRY (Dont Repeat Yourself) em todos os arquivos criados.
- Obrigatoriamente utilize Clean Code e Design Limpo.
- Construa a aplicação pensando na escala futura, seguindo boas práticas de performance.

## Stack Tecnológica

- **Backend**: Ruby on Rails 8.0.3 com Ruby 3.4.2
- **Banco de Dados**: PostgreSQL
- **Frontend**: HTML/ERB, TailwindCSS, Hotwire com Turbo e Stimulus.
- **Autenticação**: Devise
- **Processamento em Background**: SolidQueue
- **Armazenamento de Arquivos**: Active Storage + Backblaze (Driver AWS S3)
- **Gráficos**: Chart.js

## Estrutura de Camadas

### 1. Camada de Apresentação
- **Controllers**: Lógica de controle para todas as entidades principais
- **Views**: Templates ERB com TailwindCSS e Hotwire com Stimulus e Turbo
- **Components**: Para componentes reutilizáveis em toda aplicação
- **API**: Endpoints JSON para integração com front-end

### 2. Camada de Domínio
- **Models**: Entidades de negócio com validações e regras de domínio
- **Services**: Classes para encapsular lógica de negócio complexa
- **Value Objects**: Para objetos imutáveis como configurações DISC
- **Policy Objects**: Para regras de autorização com Pundit

### 3. Camada de Infraestrutura
- **IA Adapters**: Classes para comunicação com serviços de IA
- **PDF Generators**: Serviços para geração de relatórios
- **Exporters**: Classes para exportação de dados em diferentes formatos

## Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                        Camada de Apresentação                    │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │ Controllers │    │    Views    │    │   View Components   │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Camada de Domínio                        │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │   Models    │    │  Services   │    │    Policy Objects   │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Camada de Infraestrutura                    │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │ IA Adapters │    │PDF Generators│    │      Exporters     │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Serviços Externos                           │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │  OpenAI API │    │   Storage   │    │        Redis        │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Considerações de Segurança

- **Authentication**: Devise com configuração robusta
- **Authorization**: Pundit policies para controle granular
- **Strong Parameters**: Em todos os controllers
- **CSRF Protection**: Token CSRF ativo
- **Content Security Policy**: Headers CSP configurados
- **Sanitização de Input**: Antes de enviar para IA
- **Rate Limiting**: Para APIs externas e endpoints sensíveis
- **Auditoria**: Logging de ações críticas
- **Proteção contra XSS**: Escape automático de HTML
- **Proteção contra SQL Injection**: Uso de ORM e prepared statements
- **Proteção contra CSRF**: Tokens em formulários
- **Proteção contra Clickjacking**: Headers X-Frame-Options
