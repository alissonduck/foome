# Documentação: Dashboard para Estabelecimentos Parceiros

## Visão Geral
O Dashboard para Estabelecimentos Parceiros é a página central da plataforma Foome para restaurantes e estabelecimentos cadastrados. Esta interface fornece uma visão abrangente do desempenho do estabelecimento na plataforma, apresentando métricas, gráficos e relatórios consolidados que permitem ao parceiro acompanhar o uso de vouchers, comportamento de clientes e performance de descontos.

## Histórias de Usuário

1. Como parceiro da Foome, quero visualizar métricas consolidadas sobre o uso de vouchers para entender o impacto das promoções no meu estabelecimento.

2. Como gerente de restaurante, quero analisar dados sobre os clientes que frequentam meu estabelecimento através da Foome para melhor atendê-los.

3. Como parceiro, quero visualizar estatísticas sobre descontos concedidos e receita gerada para avaliar o retorno sobre investimento das promoções.

4. Como administrador de estabelecimento, quero filtrar dados por período específico para analisar tendências sazonais ou campanhas específicas.

5. Como parceiro da plataforma, quero exportar dados para análises mais detalhadas em ferramentas externas.

6. Como gestor de estabelecimento, quero visualizar o uso de vouchers por dia da semana para otimizar promoções em períodos de menor movimento.

## Design & Frontend

### Estrutura da Página
A página de dashboard é estruturada em seções claramente definidas:

1. **Cabeçalho Superior**:
   - Título "Dashboard" e subtítulo descritivo
   - Controles de ação (botão de atualizar, seletor de período)

2. **Sistema de Abas (Tabs)**:
   - Três abas principais: "Vouchers", "Clientes" e "Descontos"
   - Cada aba possui conteúdo específico relacionado ao tema

3. **Cards de Métricas**:
   - Linha de cards no topo de cada aba com métricas-chave
   - Visualização rápida de KPIs importantes

4. **Gráficos e Visualizações**:
   - Seção principal com gráficos variados
   - Layout responsivo em grid para diferentes tamanhos de tela

### Componentes

#### Cabeçalho da Página
- Título "Dashboard" em fonte grande e negrito
- Subtítulo explicativo em tamanho menor e cor mais clara
- Botão de atualização com ícone de refresh
- Seletor de período com datepicker

#### Seletor de Período
- Botão com ícone de calendário
- Exibe o intervalo de datas selecionado (quando aplicável)
- Abre um popover com calendário duplo para seleção de intervalo
- Permite limpar a seleção e retornar a visualização padrão

#### Abas (Tabs)
- Sistema de três abas para organizar diferentes conjuntos de dados
- Aba ativa destacada visualmente
- Transição suave entre conteúdos ao alternar abas

#### Cards de Métricas
- Pequenos cards informativos no topo de cada aba
- Cada card contém:
  - Título da métrica
  - Ícone representativo
  - Valor principal em destaque
  - Texto secundário com variação percentual ou informação adicional
- Layout em grid, adaptando-se a diferentes tamanhos de tela (4 cards em desktop, 2 em tablet, 1 em mobile)

#### Gráficos
- Múltiplos tipos de visualizações de dados:
  - Gráficos de barras para comparações
  - Gráficos de linhas para tendências temporais
  - Gráficos de pizza/donut para distribuições
- Altura fixa para consistência visual
- Tooltips interativos ao passar o mouse sobre os dados
- Estados de carregamento e estados vazios para cada gráfico

#### Estado Vazio
- Exibido quando não há dados disponíveis
- Ícone representativo centralizado
- Mensagem principal explicativa
- Mensagem secundária com orientação

#### Estado de Carregamento
- Indicador de carregamento (spinner)
- Skeleton loaders para manter o layout durante o carregamento
- Feedback visual durante atualizações de dados

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e componentes: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Cores de gráficos:
    - Azul principal: rgba(54, 162, 235, 0.6)
    - Vermelho: rgba(255, 99, 132, 0.6)
    - Verde: rgba(75, 192, 192, 0.6)
    - Roxo: rgba(153, 102, 255, 0.6)
    - Amarelo: rgba(255, 206, 86, 0.6)
  - Indicadores de aumento: #10B981 (verde)
  - Indicadores de queda: #EF4444 (vermelho)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 14px (font-medium)
    - Valor de métrica: 24px (font-bold)
    - Texto secundário: 12px (text-muted-foreground)
    - Título de gráfico: 18px (font-semibold)
    - Descrição de gráfico: 14px (text-gray-500)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Botões: Altura consistente, padding adequado, cantos arredondados
  - Tabs: Sublinhado ou background para indicar tab ativa
  - Gráficos: Grid auxiliar, tooltips ao hover, animações suaves
  - Calendário: Seleção de intervalo com visual claro para datas selecionadas

### Responsividade
- **Desktop**: Layout completo com múltiplas colunas de cards e gráficos
- **Tablet**: Grid adaptado para menos colunas, mantendo a mesma estrutura
- **Mobile**: 
  - Empilhamento vertical de cards e gráficos
  - Simplificação do seletor de período
  - Ajuste de tamanho e scroll para gráficos
  - Controles adaptados para interação por toque

## Backend (Rails)

### Estrutura e Fluxo de Dados

O dashboard segue o seguinte fluxo de dados:

1. **Carregamento inicial**:
   - Obtenção dos dados de identificação do parceiro logado
   - Carregamento das métricas iniciais com período padrão (último mês)

2. **Mudança de período**:
   - Atualização de todos os dados conforme o período selecionado
   - Recálculo de métricas e regeneração de gráficos

3. **Mudança de aba**:
   - Carregamento sob demanda dos dados específicos da aba selecionada
   - Otimização para carregar apenas o necessário

4. **Atualização manual**:
   - Refresh explícito de dados a pedido do usuário
   - Feedback visual durante o processo de atualização

### Controllers

#### `Partner::DashboardController`
Responsável por gerenciar a exibição do dashboard e seus dados.

**Ações:**
- `index`: Renderiza o dashboard com dados iniciais
- `voucher_metrics`: Retorna métricas de vouchers para o período
- `customer_metrics`: Retorna métricas de clientes para o período
- `discount_metrics`: Retorna métricas de descontos para o período
- `export_data`: Gera exportação de dados em formato CSV/Excel

### Models Relevantes

#### `Partner`
Representa um estabelecimento parceiro da plataforma.

**Atributos relevantes:**
- `id`: Identificador único
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `has_many :vouchers`: Vouchers oferecidos pelo parceiro
- `has_many :voucher_usages`: Registros de uso de vouchers
- `has_many :customers, through: :voucher_usages`: Clientes que usaram vouchers

#### `Voucher`
Representa um voucher/cupom de desconto criado pelo parceiro.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro
- `value`: Valor do desconto
- `min_purchase`: Valor mínimo para uso
- `valid_from`: Data de início da validade
- `valid_to`: Data de fim da validade
- `days_of_week`: Dias da semana válidos (JSON)
- `time_range`: Horários válidos (JSON)
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `item_sale_price`: Preço de venda do item
- `item_cost`: Custo do item

**Associações:**
- `belongs_to :partner`: Estabelecimento que oferece o voucher
- `has_many :voucher_usages`: Registros de uso deste voucher

#### `VoucherUsage`
Representa o uso de um voucher por um cliente.

**Atributos relevantes:**
- `id`: Identificador único
- `voucher_id`: Referência ao voucher
- `customer_id`: Referência ao cliente
- `partner_id`: Referência ao parceiro
- `used_at`: Data e hora de uso
- `value`: Valor do desconto aplicado
- `purchase_total`: Valor total da compra
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :voucher`: Voucher utilizado
- `belongs_to :customer`: Cliente que utilizou
- `belongs_to :partner`: Estabelecimento onde foi utilizado

#### `Customer`
Representa um cliente/usuário final que utiliza vouchers.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do cliente
- `email`: Email do cliente
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `has_many :voucher_usages`: Registros de vouchers utilizados
- `has_many :partners, through: :voucher_usages`: Estabelecimentos visitados

### Services

#### `Partner::VoucherReportService`
Serviço para gerar relatórios e métricas sobre vouchers.

**Métodos:**
- `initialize(partner, date_range)`: Inicializa o serviço com o parceiro e intervalo de datas
- `metrics`: Calcula métricas principais (vouchers ativos, utilizados, receita, etc.)
- `percent_change`: Calcula variações percentuais em relação ao período anterior
- `usage_by_period`: Agrupa uso de vouchers por período (dias, semanas ou meses)
- `usage_by_type`: Agrupa uso de vouchers por tipo
- `usage_by_weekday`: Agrupa uso de vouchers por dia da semana
- `conversion_rate`: Calcula taxa de conversão de vouchers vistos/utilizados

#### `Partner::CustomerReportService`
Serviço para gerar relatórios e métricas sobre clientes.

**Métodos:**
- `initialize(partner, date_range)`: Inicializa o serviço com o parceiro e intervalo de datas
- `customer_list`: Lista de clientes com dados de uso
- `total_customers`: Conta total de clientes únicos
- `active_customers`: Conta clientes que usaram vouchers no período
- `average_ticket`: Calcula ticket médio por cliente
- `top_spenders`: Lista clientes que mais gastaram
- `frequency_distribution`: Distribui clientes por frequência de visitas

#### `Partner::DiscountReportService`
Serviço para analisar o impacto dos descontos.

**Métodos:**
- `initialize(partner, date_range)`: Inicializa o serviço com o parceiro e intervalo de datas
- `total_discount`: Calcula desconto total concedido
- `average_discount`: Calcula desconto médio por transação
- `discount_by_weekday`: Analisa descontos por dia da semana
- `discount_efficiency`: Calcula eficiência dos descontos (receita gerada/desconto)
- `roi`: Calcula retorno sobre investimento dos descontos

#### `Partner::ExportService`
Serviço para exportação de dados em diferentes formatos.

**Métodos:**
- `initialize(partner, date_range, type)`: Inicializa o serviço
- `to_csv`: Exporta dados para CSV
- `to_excel`: Exporta dados para Excel
- `voucher_export_data`: Prepara dados de vouchers para exportação
- `customer_export_data`: Prepara dados de clientes para exportação

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Dashboard
- `app/views/partner/dashboard/index.html.erb`: View principal do dashboard

#### Partials por Seção
- `app/views/partner/dashboard/_page_header.html.erb`: Cabeçalho com título e controles
- `app/views/partner/dashboard/_period_selector.html.erb`: Seletor de período
- `app/views/partner/dashboard/_metrics_row.html.erb`: Linha de cards de métricas
- `app/views/partner/dashboard/_metrics_card.html.erb`: Card individual de métrica
- `app/views/partner/dashboard/_chart_card.html.erb`: Card para gráfico com título e descrição
- `app/views/partner/dashboard/_empty_state.html.erb`: Estado vazio para quando não há dados

#### Partials por Aba
- `app/views/partner/dashboard/_vouchers_tab.html.erb`: Conteúdo da aba de vouchers
- `app/views/partner/dashboard/_customers_tab.html.erb`: Conteúdo da aba de clientes
- `app/views/partner/dashboard/_discounts_tab.html.erb`: Conteúdo da aba de descontos

#### Partials de Gráficos
- `app/views/partner/dashboard/charts/_bar_chart.html.erb`: Gráfico de barras
- `app/views/partner/dashboard/charts/_line_chart.html.erb`: Gráfico de linhas
- `app/views/partner/dashboard/charts/_pie_chart.html.erb`: Gráfico de pizza/donut

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :partner do
    get 'dashboard', to: 'dashboard#index'
    
    # Endpoints para dados do dashboard
    namespace :dashboard do
      get 'voucher_metrics', to: 'dashboard#voucher_metrics'
      get 'customer_metrics', to: 'dashboard#customer_metrics'
      get 'discount_metrics', to: 'dashboard#discount_metrics'
      get 'export/:type', to: 'dashboard#export_data', as: 'export_data'
    end
  end
end
```

### Bibliotecas Externas

#### Biblioteca de Gráficos (Chart.js)
Utilizada para renderizar os gráficos interativos do dashboard.

**Funcionalidades usadas:**
- Gráficos de barra para comparações
- Gráficos de linha para séries temporais
- Gráficos de pizza/donut para distribuições
- Tooltips interativos
- Animações e transições

**Implementação:**
- Integrada via yarn/npm
- Importada como dependência
- Configurada com estilos consistentes com a UI
- Adaptada para o tema claro/escuro

### Stimulus Controllers

#### `dashboard-controller`
Controller principal para gerenciar o dashboard.

**Ações:**
- `connect()`: Inicializa o dashboard e carrega dados iniciais
- `refreshData()`: Atualiza todos os dados do dashboard
- `changePeriod(event)`: Atualiza período e recarrega dados
- `changeTab(event)`: Gerencia mudança entre abas
- `exportData(event)`: Inicia processo de exportação de dados

#### `date-range-controller`
Controller para gerenciar o seletor de intervalo de datas.

**Ações:**
- `connect()`: Inicializa o calendário
- `open()`: Abre o popover do calendário
- `close()`: Fecha o popover do calendário
- `selectRange(event)`: Processa seleção de intervalo
- `clear()`: Limpa a seleção atual
- `applyRange()`: Aplica o intervalo selecionado

#### `chart-controller`
Controller para gerenciar os gráficos individuais.

**Ações:**
- `connect()`: Inicializa o gráfico no elemento
- `update(data)`: Atualiza os dados do gráfico
- `resize()`: Redimensiona o gráfico ao mudar o tamanho da janela
- `destroy()`: Limpa recursos ao remover o elemento

#### `metrics-card-controller`
Controller para gerenciar os cards de métricas.

**Ações:**
- `connect()`: Inicializa o card
- `update(data)`: Atualiza os dados exibidos
- `showLoading()`: Exibe estado de carregamento
- `hideLoading()`: Remove estado de carregamento

### Turbo Frames e Streams

O dashboard utiliza Turbo para atualizações dinâmicas:

1. **Frame para Métricas de Vouchers**:
   ```erb
   <%= turbo_frame_tag "voucher-metrics" do %>
     <!-- Cards de métricas de vouchers -->
   <% end %>
   ```

2. **Frame para Gráficos de Vouchers**:
   ```erb
   <%= turbo_frame_tag "voucher-charts" do %>
     <!-- Gráficos de vouchers -->
   <% end %>
   ```

3. **Frame para Seletor de Período**:
   ```erb
   <%= turbo_frame_tag "period-selector" do %>
     <!-- Seletor de período -->
   <% end %>
   ```

4. **Frame para Cada Aba**:
   ```erb
   <%= turbo_frame_tag "dashboard-tab-content" do %>
     <!-- Conteúdo da aba atual -->
   <% end %>
   ```

5. **Stream para Atualizações em Tempo Real**:
   ```erb
   <%= turbo_stream_from "partner_#{current_partner.id}_dashboard" %>
   ```

### Regras de Negócio

1. **Acesso ao Dashboard**
   - Apenas parceiros ativos podem acessar o dashboard
   - Dados exibidos são específicos do parceiro autenticado
   - Período padrão é o mês corrente (do dia 1 até hoje)

2. **Cálculo de Métricas**
   - Vouchers ativos: vouchers com `valid_to` >= hoje e `active` = true
   - Vouchers utilizados: contagem de `VoucherUsage` no período
   - Receita total: soma de `purchase_total` em `VoucherUsage` no período
   - Taxa de conversão: (vouchers usados / vouchers ativos) * 100
   - Comparações percentuais: calculadas em relação ao período anterior de igual duração

3. **Filtragem por Período**
   - Período máximo permitido: 1 ano
   - Se nenhum período for selecionado, usa-se o mês corrente
   - Todos os gráficos e métricas devem respeitar o filtro de período
   - Agrupamento por período varia conforme a duração:
     - Até 14 dias: agrupamento diário
     - De 15 a 90 dias: agrupamento semanal
     - Acima de 90 dias: agrupamento mensal

4. **Exportação de Dados**
   - Limitar exportação a 10.000 registros por vez
   - Formatar datas conforme localização (pt-BR)
   - Incluir metadados de filtros aplicados e data de geração

### Permissões e Autorização

1. **Acesso ao Dashboard**:
   - Somente parceiros ativos podem visualizar o dashboard
   - Cada parceiro visualiza apenas seus próprios dados
   - Administradores da plataforma podem acessar dashboards de qualquer parceiro

2. **Exportação de Dados**:
   - Parceiros podem exportar apenas seus próprios dados
   - Exportação limitada em volume e frequência para evitar sobrecarga

3. **Alteração de Configurações**:
   - Parceiros podem personalizar exibição de métricas e gráficos
   - Configurações são salvas por usuário/sessão

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autorizado/não autorizado
   - Carregamento correto de dados por período
   - Resposta a diferentes formatos (HTML, JSON)
   - Exportação de dados

2. **Testes de Serviço**:
   - Cálculo correto de métricas
   - Agrupamento de dados por diferentes períodos
   - Cálculo de variações percentuais
   - Formatação de dados para exportação

3. **Testes de Sistema**:
   - Fluxo completo de navegação no dashboard
   - Interação com calendário e filtros
   - Mudança entre abas
   - Visualização em diferentes tamanhos de tela

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo ao alternar abas
- Atualização de URL com params de filtro sem recarregar a página

#### Turbo Frames
- Atualização parcial de cada seção do dashboard
- Carregamento sob demanda de dados por aba
- Manutenção do estado do filtro de período entre atualizações

#### Turbo Streams
- Atualização em tempo real de métricas (se aplicável)
- Notificações sobre dados novos disponíveis
- Streaming de atualizações para múltiplos usuários do mesmo parceiro

#### Stimulus
- Interatividade dos gráficos com Chart.js
- Validação de seleção de períodos
- Feedback visual durante operações assíncronas
- Gerenciamento de estado dos componentes

## Considerações de Performance

1. **Otimização de Consultas**:
   - Índices adequados para filtros frequentes (partner_id, date_range)
   - Consultas agregadas para evitar múltiplas chamadas ao banco
   - Cache de dados que mudam pouco frequentemente

2. **Carregamento Preguiçoso**:
   - Carregar apenas dados da aba ativa inicialmente
   - Carregar dados de outras abas sob demanda
   - Usar Turbo Frames para isolamento de requisições

3. **Renderização Eficiente**:
   - Evitar recálculo desnecessário de gráficos
   - Reutilizar instâncias de gráficos ao atualizar dados
   - Considerar streaming parcial para conjuntos muito grandes

4. **Armazenamento em Cache**:
   - Cache de métricas por período/parceiro
   - Invalidação seletiva ao receber novos dados
   - Uso de fragment caching para partes estáticas

## Acessibilidade

1. **Navegação por Teclado**:
   - Tabs e controles acessíveis via teclado
   - Ordem de tabulação lógica
   - Teclas de atalho para ações comuns

2. **Dados Tabulares**:
   - Alternativa textual para gráficos
   - Possibilidade de visualizar dados em formato tabular
   - Possibilidade de aumentar contraste dos gráficos

3. **Feedback Sensorial**:
   - Não depender apenas de cor para transmitir informação
   - Feedback visual, textual e de foco para interações
   - Evitar elementos piscantes ou com movimento excessivo

4. **Dados em Gráficos**:
   - Títulos e legendas descritivas
   - Alternativas textuais para tendências importantes
   - Uso de padrões além de cores para diferenciar séries de dados
