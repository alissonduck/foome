# Documentação: Dashboard de Empresas

## Visão Geral
O Dashboard de Empresas é a página principal após autenticação para representantes de empresas no sistema Foome. Esta página centraliza informações importantes sobre o uso de benefícios alimentares pelos funcionários, estatísticas gerais e atividades recentes, permitindo uma visão rápida do status da empresa na plataforma.

## Histórias de Usuário

1. Como administrador de empresa, quero ver um resumo dos principais indicadores para monitorar o uso de benefícios alimentares.
2. Como gerente, quero acompanhar quais funcionários estão utilizando os vouchers e onde estão gastando.
3. Como administrador, quero ter acesso rápido às principais funcionalidades do sistema a partir de um ponto central.
4. Como gestor financeiro, quero visualizar o valor economizado com o programa de benefícios.
5. Como RH, quero monitorar a quantidade de funcionários ativos no sistema.

## Design & Frontend

### Estrutura da Página
A página é estruturada em três áreas principais:

1. **Barra Lateral (Sidebar)**:
   - Menu de navegação principal
   - Logo e identificação do sistema
   - Perfil do usuário logado

2. **Área Principal**:
   - Cabeçalho com breadcrumbs e ações principais
   - Cards de estatísticas (KPIs)
   - Seção de atividade recente
   - Botões de ação contextual

3. **Cabeçalho Superior**:
   - Controles de navegação
   - Ícone de notificações
   - Botões de ação principal

### Componentes

#### Barra Lateral
- Logo Foome com subtítulo "Empresas"
- Menu principal com ícones e texto:
  - Dashboard (ativo)
  - Vouchers
  - Parceiros
  - Configurações (com submenu)
  - Suporte
  - Feedback
- Seção de perfil do usuário na parte inferior com nome e email

#### Cabeçalho
- Breadcrumb (Empresa > Dashboard)
- Botão de ação "Indicar parceiro" no canto direito
- Ícone de notificações

#### Seção de Boas-vindas
- Título personalizado com o nome do usuário ("Olá, Alisson! 👋🏻")
- Subtítulo explicativo sobre o propósito da página

#### Cards de Estatísticas
Quatro cards em formato grid exibindo:
1. **Parceiros disponíveis**:
   - Valor numérico (11)
   - Ícone representativo

2. **Funcionários ativos**:
   - Valor numérico (2)
   - Ícone representativo

3. **Vouchers utilizados**:
   - Valor numérico (3)
   - Ícone representativo

4. **Economia total**:
   - Valor monetário (R$ 70,00)
   - Ícone representativo

#### Seção de Atividade Recente
- Título "Atividade recente"
- Card com título "Vouchers utilizados"
- Subtítulo explicativo
- Lista de transações recentes com:
  - Nome do estabelecimento
  - Nome do funcionário que utilizou
  - Valor do voucher/desconto
  - Tempo decorrido desde a utilização
- Botão "Ver todos os vouchers" no rodapé do card

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (tom laranja/vermelho)
  - Fundo da página: #FFFFFF (branco)
  - Fundo da barra lateral: #FFFFFF (branco)
  - Cards: #FFFFFF com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Ícones de menu: #6B7280 (cinza médio)
  - Item ativo no menu: #FF4D4D (laranja)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título principal: 24px (font-bold)
    - Subtítulo: 14-16px (text-gray-600)
    - Valores de estatísticas: 20-24px (font-bold)
    - Títulos de cards: 16-18px (font-semibold)
    - Texto regular: 14px

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave, padding interno generoso
  - Botões: Cantos arredondados, padding horizontal e vertical adequados
  - Botão primário: Fundo colorido (#FF4D4D), texto branco
  - Botão secundário: Borda, sem preenchimento, texto colorido
  - Ícones: Estilo outline, tamanho médio para boa visibilidade
  - Separadores: Linhas sutis para delimitar seções e itens de lista

### Responsividade
- Barra lateral colapsa em dispositivos móveis (possivelmente com menu hambúrguer)
- Cards de estatísticas empilham verticalmente em telas pequenas
- Espaçamento e padding reduzidos em telas menores
- Grid adaptável conforme tamanho da tela (1 coluna em mobile, 2 em tablet, 4 em desktop)

## Backend (Rails)

### Estrutura e Fluxo de Dados

O Dashboard centraliza informações de diferentes entidades do sistema:

1. **Dados do Funcionário Logado**:
   - Nome e informações básicas para personalização
   - Permissões para determinar o que pode ser visualizado

2. **Estatísticas Gerais**:
   - Contagem de parceiros disponíveis
   - Contagem de funcionários ativos
   - Quantidade de vouchers utilizados
   - Valor total economizado

3. **Histórico de Vouchers**:
   - Lista das transações mais recentes
   - Detalhes sobre cada uso de voucher

### Controllers

#### `Company::DashboardController`
Responsável por reunir e apresentar os dados do dashboard.

**Ações:**
- `index`: Centraliza a coleta de dados e renderiza a página principal do dashboard

### Models Relevantes

#### `Company`
Representa a empresa do usuário logado.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa
- `active`: Status de ativação

**Métodos relevantes:**
- `total_vouchers_used`: Retorna o total de vouchers utilizados
- `total_savings`: Calcula a economia total gerada pelos vouchers
- `active_employees_count`: Retorna o número de funcionários ativos

#### `Employee` 
Representa os funcionários da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome completo do funcionário
- `email`: Email corporativo
- `company_id`: Referência à empresa
- `active`: Status de ativação

**Métodos relevantes:**
- `first_name`: Retorna o primeiro nome do funcionário
- `used_vouchers`: Retorna os vouchers utilizados pelo funcionário

#### `Partner`
Representa estabelecimentos parceiros disponíveis.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estabelecimento
- `active`: Status de ativação

**Associações:**
- `has_many :vouchers`: Relação com os vouchers oferecidos

#### `Voucher`
Representa os vouchers e descontos utilizados.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro
- `value`: Valor do voucher
- `discount_amount`: Valor do desconto aplicado
- `used_at`: Data/hora de utilização
- `employee_id`: Funcionário que utilizou

**Associações:**
- `belongs_to :partner`: Relação com o estabelecimento
- `belongs_to :employee`: Relação com o funcionário que utilizou

### Services

#### `DashboardStatsService`
Serviço para centralizar e calcular estatísticas para o dashboard.

**Métodos:**
- `initialize(company)`: Inicializa o serviço com a empresa atual
- `total_active_partners`: Calcula total de parceiros ativos
- `total_active_employees`: Calcula total de funcionários ativos
- `total_vouchers_used`: Calcula total de vouchers utilizados
- `total_savings`: Calcula economia total da empresa
- `recent_voucher_usage(limit: 5)`: Retorna uso recente de vouchers

#### `VoucherUsageService`
Gerencia dados de utilização de vouchers.

**Métodos:**
- `recent_for_company(company, limit: 5)`: Busca vouchers recentes para uma empresa
- `format_for_display(vouchers)`: Formata dados para exibição

### Queries e Scopes

#### Company Queries
```ruby
# Exemplo conceitual dos scopes e queries
class Company < ApplicationRecord
  scope :active, -> { where(active: true) }
  
  def active_employees
    employees.where(active: true)
  end
  
  def recent_vouchers(limit = 5)
    Voucher.joins(:employee)
           .where(employees: { company_id: id })
           .order(used_at: :desc)
           .limit(limit)
  end
  
  def total_savings
    Voucher.joins(:employee)
           .where(employees: { company_id: id })
           .sum(:discount_amount)
  end
end
```

#### Employee Queries
```ruby
# Exemplo conceitual dos scopes e queries
class Employee < ApplicationRecord
  scope :active, -> { where(active: true) }
  
  def first_name
    name.split(' ').first
  end
  
  def used_vouchers
    Voucher.where(employee_id: id).order(used_at: :desc)
  end
end
```

### Views e Partials

#### Layout Principal
- `app/views/layouts/company_dashboard.html.erb`: Layout específico para área da empresa

#### Dashboard
- `app/views/company/dashboard/index.html.erb`: View principal do dashboard

#### Partials
- `app/views/company/shared/_sidebar.html.erb`: Barra lateral de navegação
- `app/views/company/dashboard/_stats_cards.html.erb`: Cards de estatísticas
- `app/views/company/dashboard/_recent_activities.html.erb`: Atividades recentes
- `app/views/company/dashboard/_voucher_list_item.html.erb`: Item individual da lista de vouchers

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    get 'dashboard', to: 'dashboard#index'
    resources :vouchers, only: [:index]
    resources :partners, only: [:index]
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `ApplicationHelper`
```ruby
# Exemplo conceitual de helpers
module ApplicationHelper
  def format_currency(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".")
  end
  
  def time_ago_in_words_pt(datetime)
    # Implementação em português do time_ago_in_words
  end
end
```

### Stimulus Controllers

#### `stats-refresh-controller`
Controller para atualização periódica de estatísticas.

**Ações:**
- `connect()`: Inicializa o controller
- `refresh()`: Atualiza os dados estatísticos via fetch
- `disconnect()`: Limpa temporizadores

#### `voucher-list-controller`
Controller para gerenciar a lista de vouchers.

**Ações:**
- `connect()`: Inicializa o controller
- `loadMore()`: Carrega mais vouchers via fetch
- `filter(event)`: Filtra a lista de vouchers

### Turbo Frames

O dashboard utiliza Turbo Frames para atualização parcial de conteúdo:

1. **Frame de Estatísticas**:
   ```erb
   <%= turbo_frame_tag "dashboard-stats" do %>
     <!-- Cards de estatísticas aqui -->
   <% end %>
   ```

2. **Frame de Atividades Recentes**:
   ```erb
   <%= turbo_frame_tag "recent-activities" do %>
     <!-- Lista de vouchers recentes aqui -->
   <% end %>
   ```

### Regras de Negócio

1. **Acesso ao Dashboard**
   - Apenas funcionários autenticados com conta ativa podem acessar
   - Funcionários de empresas inativas são redirecionados para uma página de aviso

2. **Cálculo de Economia**
   - A economia é calculada somando os valores de desconto de todos os vouchers utilizados
   - Para vouchers sem valor de desconto, utiliza-se o valor nominal do voucher

3. **Listagem de Atividades**
   - Por padrão, exibe os 5 últimos vouchers utilizados
   - Ordenados do mais recente para o mais antigo
   - Pode ser expandido para visualizar mais registros

4. **Contagem de Parceiros**
   - Apenas parceiros ativos são contabilizados
   - Um parceiro com múltiplas filiais conta como um único parceiro

5. **Contagem de Funcionários**
   - Apenas funcionários com status ativo são contabilizados
   - Independente do papel (admin, gerente, membro)

### Permissões e Autorização

O dashboard utiliza controle de permissões para exibir funcionalidades diferentes conforme o papel do usuário:

1. **Administrador**:
   - Visualização completa de todas as estatísticas
   - Acesso a todos os vouchers utilizados por qualquer funcionário
   - Botões de ação para gerenciamento de funcionários e parceiros

2. **Gerente**:
   - Visualização de estatísticas da sua equipe
   - Acesso apenas aos vouchers utilizados pelos funcionários da sua equipe
   - Funcionalidades limitadas de gerenciamento

3. **Funcionário Regular**:
   - Visualização apenas dos seus próprios vouchers
   - Estatísticas pessoais de uso
   - Dashboard simplificado

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autenticado ao dashboard
   - Redirecionamento de usuários não autorizados
   - Carregamento correto de dados

2. **Testes de Sistema/Integração**:
   - Visualização correta do dashboard com diferentes perfis de usuário
   - Exibição de estatísticas atualizadas
   - Funcionalidade dos botões e links

3. **Testes de Modelo**:
   - Cálculos de estatísticas
   - Relacionamentos entre modelos
   - Scopes e queries personalizadas

4. **Testes de Helper**:
   - Formatação correta de valores monetários
   - Exibição de datas no formato correto

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas do dashboard sem recarregamento completo
- Submissão de formulários de filtro com atualizações parciais

#### Turbo Frames
- Atualização independente de cada seção do dashboard
- Carregamento assíncrono de mais vouchers na lista de atividades

#### Turbo Streams
- Atualizações em tempo real de estatísticas (se implementado)
- Notificações push de novos vouchers utilizados

#### Stimulus
- Controle de interações do usuário
- Atualizações periódicas de dados
- Comportamentos dinâmicos da interface

## Considerações de Performance

1. **Caching**:
   - Cache de estatísticas para evitar cálculos repetidos
   - Invalidação de cache quando novos vouchers são utilizados

2. **Paginação e Carregamento Lazy**:
   - Lista de vouchers com paginação para grandes volumes
   - Carregamento sob demanda para histórico mais antigo

3. **Agregações Eficientes**:
   - Uso de queries otimizadas para estatísticas
   - Utilização de counters de banco de dados para contagens frequentes

4. **Consultas N+1**:
   - Eager loading de relacionamentos (partner, employee) na listagem de vouchers

## Acessibilidade

1. **Contraste e Legibilidade**:
   - Garantir contraste adequado nas cores
   - Tamanho de fonte legível em todos os dispositivos

2. **Navegação por Teclado**:
   - Todos os elementos interativos acessíveis via teclado
   - Ordem de tabulação lógica

3. **ARIA**:
   - Labels apropriados para elementos não-textuais
   - Roles e estados para componentes dinâmicos
