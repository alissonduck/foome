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
- **Autorização**: Pundit
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

### Métricas e Ferramentas

- **CI/CD**: GitHub Actions para execução automática
- **Linting**: RuboCop para qualidade de código
- **Segurança**: Brakeman para análise estática

## Estratégia de Deploy e Ambientes

### Ambientes

1. **Desenvolvimento**
   - Uso local pelos desenvolvedores
   - Banco de dados: PostgreSQL local
   - Serviços: Redis local, S3 mock

2. **Homologação (Staging)**
   - Ambiente para testes de QA e validação
   - Infraestrutura: Docker
   - Banco de dados: PostgreSQL gerenciado
   - Integração com serviços reais, mas em modo sandbox

3. **Produção**
   - Ambiente para usuários finais
   - Infraestrutura: Hetzner Kubernetes
   - Banco de dados: PostgreSQL
   - Cache: SolidCache
   - Storage: Backblaze B2

### Pipeline de Deploy

1. **Build**
   - Construção da imagem Docker
   - Execução de testes automatizados
   - Análise estática de código

2. **Deploy**
   - Deploy automático para homologação após merge na branch `develop`
   - Deploy manual para produção após aprovação (branch `main`)
   - Estratégia de zero-downtime com blue/green deployment

3. **Monitoramento**
   - Verificações de saúde pós-deploy
   - Rollback automático em caso de falha

## Monitoramento e Observabilidade

### Ferramentas

1. **APM (Application Performance Monitoring)**
   - New Relic ou Datadog para monitoramento de performance
   - Rastreamento de transações e identificação de gargalos
   - Alertas para degradação de performance

2. **Logging**
   - Centralização de logs com ELK Stack ou CloudWatch Logs
   - Estruturação de logs para facilitar busca e análise
   - Retenção de logs por 30 dias

3. **Métricas**
   - Prometheus + Grafana para visualização de métricas
   - Dashboards para KPIs técnicos e de negócio
   - Métricas de RED (Rate, Errors, Duration)

4. **Alertas**
   - Configuração de alertas para incidentes críticos
   - Integração com PagerDuty ou similar
   - Escalonamento automático de incidentes

### Métricas Monitoradas

1. **Infraestrutura**
   - CPU, memória, disco, rede
   - Saúde de containers e instâncias

2. **Aplicação**
   - Tempo de resposta de endpoints
   - Taxa de erros
   - Throughput de requisições

3. **Banco de Dados**
   - Tempo de execução de queries
   - Conexões ativas
   - Uso de índices

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

## Estratégia de Escalabilidade

- **Cache**: SolidCache para cache de aplicação
- **Background Jobs**: SolidQueue para processamento assíncrono
- **Database**: Índices e queries otimizadas
- **Monitoramento**: Integração com New Relic ou similar
- **Horizontal Scaling**: Arquitetura stateless para permitir múltiplas instâncias
