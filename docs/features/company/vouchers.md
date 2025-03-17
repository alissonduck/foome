# Documentação: Página de Vouchers Empresariais

## Visão Geral
A página de Vouchers Empresariais permite que administradores e gestores de empresas visualizem, monitorem e analisem o uso de vouchers alimentares pelos funcionários. A página fornece estatísticas sobre economia gerada, filtros avançados para segmentação de dados e uma listagem detalhada das transações de vouchers realizadas.

## Histórias de Usuário

1. Como administrador de empresa, quero visualizar todos os vouchers utilizados pelos funcionários para acompanhar o uso do benefício.
2. Como gestor financeiro, quero filtrar vouchers por período para analisar o impacto financeiro em diferentes momentos.
3. Como gerente de equipe, quero filtrar vouchers por funcionário e equipe para monitorar o uso do benefício em minha área.
4. Como administrador, quero exportar dados de vouchers para integração com sistemas contábeis e relatórios externos.
5. Como gestor de RH, quero visualizar estatísticas consolidadas de uso de vouchers para avaliar a efetividade do programa de benefícios.

## Design & Frontend

### Estrutura da Página
A página é estruturada em três seções principais:

1. **Cabeçalho**:
   - Título e subtítulo da página
   - Botão de ação para filtros

2. **Cards de Estatísticas**:
   - Métricas principais sobre uso de vouchers
   - Layout em grid responsivo

3. **Área de Conteúdo Principal**:
   - Filtros e pesquisa
   - Tabela de vouchers (desktop)
   - Lista de acordeões (mobile)
   - Paginação

### Componentes

#### Cabeçalho da Página
- Título "Vouchers"
- Subtítulo "Acompanhe o uso de vouchers pelos funcionários da empresa"
- Botão "Filtrar" com contador de filtros ativos
- Ícone de filtro

#### Cards de Estatísticas
Três cards em formato grid exibindo:
1. **Vouchers utilizados**:
   - Valor numérico total de vouchers
   - Ícone de ticket
   - Subtexto "No período"

2. **Valor economizado**:
   - Valor monetário total (R$)
   - Ícone de cartão de crédito
   - Subtexto "Em descontos aplicados"

3. **Valor médio economizado**:
   - Valor monetário médio (R$)
   - Ícone de cartão de crédito
   - Subtexto "Por funcionário no período"

#### Área de Filtros
- **Filtro Rápido**:
  - Campo de busca com ícone de lupa
  - Placeholder "Filtrar por funcionário ou parceiro..."

- **Filtros Avançados** (em drawer/modal):
  - Filtro por funcionário (select)
  - Filtro por período (calendário com seleção de intervalo)
  - Filtro por equipe (select)
  - Filtro por escritório (select)
  - Botões para aplicar ou limpar filtros

#### Tabela de Vouchers (Desktop)
- Cabeçalho da tabela com colunas:
  - Funcionário
  - Equipe
  - Escritório
  - Parceiro
  - Economia
  - Desconto
  - Data
  - Status
- Linhas com dados dos vouchers
- Status visual com badges coloridas
- Botão de exportação no cabeçalho

#### Acordeão de Vouchers (Mobile)
- Itens colapsáveis para cada voucher
- Cabeçalho mostrando funcionário e parceiro
- Conteúdo expandido com detalhes do voucher
- Formatação responsiva para telas pequenas

#### Paginação
- Controles de navegação entre páginas
- Indicador de página atual e total
- Seletor de itens por página (apenas em desktop)
- Contador de itens totais

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Status "Utilizado": #10B981 (verde) com fundo #ECFDF5
  - Bordas e separadores: #E5E7EB (cinza claro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Valores de estatísticas: 24px (font-bold)
    - Títulos de cards: 14px (font-medium)
    - Texto de tabela: 14px
    - Labels de filtros: 14px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Botões primários: Fundo #FF4D4D, texto branco, cantos arredondados
  - Botões secundários: Borda cinza, sem preenchimento
  - Badge de status: Cantos totalmente arredondados (rounded-full)
  - Inputs: Borda leve, cantos arredondados
  - Tabela: Linhas com separadores sutis, hover com fundo mais claro

### Responsividade
- Layout fluido que se adapta a diferentes tamanhos de tela
- Em dispositivos móveis:
  - Cards de estatísticas empilham verticalmente
  - Tabela é substituída por acordeão
  - Filtros avançados em drawer de tela cheia
  - Paginação simplificada
- Em tablets:
  - Layout adaptado para 2 colunas no grid
- Em desktop:
  - Layout completo com visualização em tabela
  - Filtros avançados em modal/drawer lateral

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Vouchers centraliza informações de diferentes entidades do sistema:

1. **Vouchers Utilizados**:
   - Dados completos dos vouchers
   - Detalhes do funcionário que utilizou
   - Informações do parceiro/estabelecimento
   - Data e valor da transação

2. **Estatísticas Agregadas**:
   - Contagem total de vouchers utilizados
   - Soma dos valores economizados
   - Média de economia por funcionário

3. **Dados para Filtros**:
   - Lista de funcionários da empresa
   - Lista de equipes
   - Lista de escritórios
   - Períodos de tempo

### Controllers

#### `Company::VouchersController`
Responsável por gerenciar a página de vouchers e os filtros associados.

**Ações:**
- `index`: Renderiza a página principal de vouchers com filtros e paginação
- `export`: Gera arquivo CSV/Excel para exportação dos dados filtrados

### Models Relevantes

#### `Voucher`
Representa os vouchers utilizados pelos funcionários.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro
- `employee_id`: Referência ao funcionário
- `value`: Valor do voucher
- `discount_amount`: Valor do desconto obtido
- `discount_percentage`: Percentual de desconto
- `used_at`: Data/hora de utilização
- `status`: Status do voucher (utilizado, cancelado, etc.)

**Associações:**
- `belongs_to :partner`: Relação com o estabelecimento
- `belongs_to :employee`: Relação com o funcionário

**Scopes:**
- `used`: Retorna apenas vouchers utilizados
- `by_date_range(start_date, end_date)`: Filtra por período
- `by_employee(employee_id)`: Filtra por funcionário
- `by_team(team_id)`: Filtra por equipe
- `by_office(office_id)`: Filtra por escritório
- `search(term)`: Busca por termo em funcionário ou parceiro

#### `Employee`
Representa os funcionários da empresa que utilizam vouchers.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome completo do funcionário
- `company_id`: Referência à empresa
- `team_id`: Referência à equipe
- `office_id`: Referência ao escritório
- `active`: Status de ativação

**Associações:**
- `belongs_to :company`: Pertence a uma empresa
- `belongs_to :team, optional: true`: Pode pertencer a uma equipe
- `belongs_to :office, optional: true`: Pode estar associado a um escritório
- `has_many :vouchers`: Possui vários vouchers utilizados

#### `Team`
Representa as equipes da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da equipe
- `company_id`: Referência à empresa

**Associações:**
- `belongs_to :company`: Pertence a uma empresa
- `has_many :employees`: Possui vários funcionários

#### `Office`
Representa os escritórios/filiais da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do escritório
- `company_id`: Referência à empresa
- `city_id`: Cidade do escritório

**Associações:**
- `belongs_to :company`: Pertence a uma empresa
- `belongs_to :city`: Localizado em uma cidade
- `has_many :employees`: Possui vários funcionários

#### `Partner`
Representa os estabelecimentos parceiros onde os vouchers são utilizados.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estabelecimento
- `active`: Status de ativação

**Associações:**
- `has_many :vouchers`: Possui vários vouchers utilizados

### Services

#### `VoucherFilterService`
Serviço para gerenciar os filtros de vouchers.

**Métodos:**
- `initialize(company, params)`: Inicializa o serviço com a empresa e parâmetros de filtro
- `filter`: Aplica os filtros e retorna os vouchers correspondentes
- `total_count`: Retorna a contagem total de vouchers após filtragem
- `export_data`: Formata os dados para exportação

#### `VoucherStatisticsService`
Serviço para calcular estatísticas sobre o uso de vouchers.

**Métodos:**
- `initialize(vouchers)`: Inicializa o serviço com os vouchers filtrados
- `total_count`: Calcula o total de vouchers utilizados
- `total_savings`: Calcula o valor total economizado
- `average_savings`: Calcula a economia média por funcionário
- `top_partners`: Retorna os parceiros mais utilizados
- `savings_by_period`: Calcula economia agrupada por período

### Queries e Scopes

```ruby
# Exemplo conceitual dos scopes e queries
class Voucher < ApplicationRecord
  scope :used, -> { where.not(used_at: nil) }
  scope :by_company, ->(company_id) { joins(:employee).where(employees: { company_id: company_id }) }
  scope :by_date_range, ->(start_date, end_date) { where(used_at: start_date..end_date) if start_date.present? && end_date.present? }
  scope :by_employee, ->(employee_id) { where(employee_id: employee_id) if employee_id.present? }
  scope :by_team, ->(team_id) { joins(:employee).where(employees: { team_id: team_id }) if team_id.present? }
  scope :by_office, ->(office_id) { joins(:employee).where(employees: { office_id: office_id }) if office_id.present? }
  
  scope :search, ->(term) {
    if term.present?
      joins(:employee, :partner)
        .where("employees.name ILIKE ? OR partners.name ILIKE ?", "%#{term}%", "%#{term}%")
    end
  }
  
  def self.total_savings
    sum(:discount_amount)
  end
  
  def self.average_savings_per_employee
    joins(:employee)
      .group("employees.id")
      .sum(:discount_amount)
      .values
      .then { |values| values.sum.to_f / values.size }
  end
end
```

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Vouchers
- `app/views/company/vouchers/index.html.erb`: View principal da página de vouchers

#### Partials
- `app/views/company/vouchers/_stats_cards.html.erb`: Cards de estatísticas
- `app/views/company/vouchers/_filters.html.erb`: Formulário de filtros
- `app/views/company/vouchers/_table.html.erb`: Tabela de vouchers (desktop)
- `app/views/company/vouchers/_accordion.html.erb`: Acordeão de vouchers (mobile)
- `app/views/company/vouchers/_drawer.html.erb`: Drawer de filtros avançados
- `app/views/company/vouchers/_pagination.html.erb`: Controles de paginação

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resources :vouchers, only: [:index] do
      collection do
        get :export
      end
    end
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `VouchersHelper`
```ruby
# Exemplo conceitual de helpers
module VouchersHelper
  def format_discount(voucher)
    if voucher.discount_percentage.present?
      "#{voucher.discount_percentage}%"
    else
      "-"
    end
  end
  
  def format_date(datetime)
    return "-" unless datetime
    l(datetime, format: :long) # Localização em português
  end
  
  def format_currency(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".")
  end
  
  def status_badge_class(status)
    case status
    when "utilizado"
      "bg-green-50 text-green-700 border-green-200"
    when "cancelado"
      "bg-red-50 text-red-700 border-red-200"
    else
      "bg-gray-50 text-gray-700 border-gray-200"
    end
  end
end
```

### Stimulus Controllers

#### `filters-controller`
Controller para gerenciar os filtros de vouchers.

**Ações:**
- `connect()`: Inicializa o controller e estado dos filtros
- `toggle()`: Abre/fecha o drawer de filtros avançados
- `apply(event)`: Aplica filtros selecionados
- `clear()`: Limpa todos os filtros
- `search()`: Realiza busca por texto

#### `date-range-controller`
Controller para gerenciar seleção de intervalo de datas.

**Ações:**
- `connect()`: Inicializa o componente de calendário
- `select(event)`: Processa seleção de intervalo
- `clear()`: Limpa o intervalo selecionado

#### `export-controller`
Controller para gerenciar exportação de dados.

**Ações:**
- `connect()`: Inicializa o controller
- `export(event)`: Inicia o processo de exportação com filtros atuais

### Turbo Frames e Streams

A página de vouchers utiliza Turbo para atualização dinâmica:

1. **Frame de Estatísticas**:
   ```erb
   <%= turbo_frame_tag "voucher-stats" do %>
     <!-- Cards de estatísticas aqui -->
   <% end %>
   ```

2. **Frame de Tabela de Vouchers**:
   ```erb
   <%= turbo_frame_tag "voucher-list" do %>
     <!-- Tabela ou acordeão aqui -->
   <% end %>
   ```

3. **Frame de Paginação**:
   ```erb
   <%= turbo_frame_tag "voucher-pagination" do %>
     <!-- Controles de paginação aqui -->
   <% end %>
   ```

### Regras de Negócio

1. **Acesso a Vouchers**
   - Apenas funcionários autenticados com papel de admin ou gerente podem acessar a página completa
   - Gerentes só visualizam vouchers de funcionários em suas equipes
   - Administradores visualizam todos os vouchers da empresa

2. **Filtros e Pesquisa**
   - A pesquisa textual busca correspondências no nome do funcionário ou do parceiro
   - Os filtros são cumulativos (combinados com AND)
   - Filtros vazios são ignorados na query
   - O período padrão, quando não especificado, é o mês atual

3. **Cálculo de Economia**
   - A economia é calculada pela soma do campo `discount_amount` dos vouchers
   - Para vouchers sem `discount_amount`, usa-se o valor nominal do voucher
   - A média por funcionário é calculada dividindo o total economizado pelo número de funcionários únicos que utilizaram vouchers

4. **Exportação**
   - A exportação mantém os mesmos filtros aplicados na visualização atual
   - Formatos disponíveis: CSV e Excel
   - Todos os registros são exportados, independente da paginação

5. **Paginação**
   - Tamanho padrão de página: 10 itens
   - Opções de tamanho: 10, 25, 50, 100
   - A paginação é feita no servidor para otimizar performance

### Permissões e Autorização

A página de vouchers implementa controle de acesso baseado em papéis:

1. **Administrador da Empresa**:
   - Acesso completo a todos os vouchers
   - Pode visualizar e filtrar por qualquer equipe/escritório
   - Acesso à funcionalidade de exportação

2. **Gerente de Equipe**:
   - Visualiza apenas vouchers dos funcionários em suas equipes
   - Filtros de equipe limitados às suas equipes
   - Acesso à funcionalidade de exportação (limitada à sua visibilidade)

3. **Funcionário Regular**:
   - Não tem acesso à página de vouchers empresariais
   - Redirecionado para uma página de acesso negado ou dashboard pessoal

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Verificação de permissões de acesso
   - Aplicação correta de filtros
   - Paginação funcional
   - Exportação de dados

2. **Testes de Modelo**:
   - Validação dos scopes e relações
   - Cálculos estatísticos
   - Filtros combinados

3. **Testes de Sistema**:
   - Fluxo completo de filtragem
   - Visualização responsiva (desktop vs. mobile)
   - Interatividade da UI (filtros, paginação)
   - Exportação de dados

4. **Testes de Desempenho**:
   - Carga com grandes volumes de vouchers
   - Eficiência das queries com filtros combinados

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas sem recarregamento completo
- Formulário de filtro com submissão via Turbo

#### Turbo Frames
- Atualização independente das estatísticas quando filtros são alterados
- Atualização da tabela de vouchers sem recarregar toda a página
- Controle de paginação dentro de um frame

#### Turbo Streams
- Atualização em tempo real quando novos vouchers são utilizados (opcional)
- Notificações quando filtros são aplicados

#### Stimulus
- Gestão do estado de UI dos filtros
- Controle do calendário de seleção de período
- Toggles de visibilidade (drawer de filtros)
- Gestão da exportação de dados

## Considerações de Performance

1. **Indexação de Banco de Dados**:
   - Índices para `employee_id`, `partner_id`, `used_at`
   - Índices compostos para consultas frequentes

2. **Paginação Eficiente**:
   - Uso de `keyset pagination` para grandes conjuntos de dados
   - Contagem aproximada para evitar `COUNT(*)` em tabelas grandes

3. **Otimização de Queries**:
   - Eager loading de associações para evitar problemas N+1
   - Uso de views materializadas para cálculos complexos frequentes

4. **Caching**:
   - Cache de resultados de filtros comuns
   - Cache de contagens e estatísticas
   - Cache de dados para exportação

## Acessibilidade

1. **Semântica Adequada**:
   - Uso de elementos apropriados (tabelas para dados tabulares)
   - Cabeçalhos hierárquicos para estruturar o conteúdo

2. **Navegação por Teclado**:
   - Foco visível em elementos interativos
   - Ordem lógica de tabulação
   - Atalhos de teclado para ações frequentes

3. **Suporte a Leitores de Tela**:
   - Labels descritivos para todos os controles
   - Textos alternativos para ícones e elementos visuais
   - Anúncios para atualizações dinâmicas (ARIA live regions)

4. **Responsividade**:
   - Layout adaptável para diferentes tamanhos de tela
   - Elementos touch-friendly em dispositivos móveis
   - Texto legível sem necessidade de zoom
