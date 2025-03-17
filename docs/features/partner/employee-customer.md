# Documentação: Gestão de Clientes

## Visão Geral
A página de Gestão de Clientes permite que estabelecimentos parceiros da Foome visualizem, filtrem e gerenciem informações sobre seus clientes. Esta funcionalidade oferece insights valiosos sobre o comportamento de consumo dos clientes, incluindo vouchers utilizados e valores gastos, facilitando estratégias de relacionamento e fidelização.

## Histórias de Usuário

1. Como parceiro da Foome, quero visualizar todos os clientes que utilizaram vouchers no meu estabelecimento para entender melhor meu público.

2. Como gerente de marketing, quero acessar dados sobre o comportamento de consumo dos clientes para criar promoções personalizadas.

3. Como administrador do estabelecimento, quero exportar a lista de clientes para uso em outras ferramentas de marketing e CRM.

4. Como gerente de relacionamento, quero buscar clientes específicos por nome, empresa ou email para oferecer atendimento personalizado.

5. Como parceiro, quero ver métricas consolidadas sobre meus clientes para avaliar o alcance de minhas promoções.

6. Como gerente financeiro, quero visualizar o total gasto pelos clientes para analisar o retorno sobre investimento das minhas promoções.

## Design & Frontend

### Estrutura da Página
A página de gestão de clientes é estruturada em seções claramente definidas:

1. **Cabeçalho Superior**:
   - Título "Clientes" e subtítulo descritivo
   - Botão de ação para exportar dados (canto superior direito)

2. **Cards de Métricas**:
   - Três cards horizontais com informações estatísticas
   - Visualização rápida de KPIs importantes

3. **Área de Filtros**:
   - Campo de busca para filtragem textual

4. **Tabela de Clientes**:
   - Listagem detalhada com múltiplas colunas
   - Paginação integrada
   - Ações contextuais por cliente

5. **Visualização Mobile**:
   - Cards individuais substituindo a tabela
   - Exibição condensada com todas as informações essenciais

6. **Estado Vazio**:
   - Exibido quando nenhum cliente é encontrado
   - Mensagem informativa e sugestões para ajustar filtros

### Componentes

#### Cabeçalho da Página
- Título "Clientes" em fonte grande e negrito
- Subtítulo explicativo em tamanho menor e cor mais clara
- Botão de exportação no canto direito com ícone de download

#### Cards de Métricas
- Três cards horizontais com informações estatísticas:
  - Total de clientes cadastrados
  - Total de vouchers utilizados
  - Valor total gasto pelos clientes
- Cada card contém:
  - Ícone representativo (Users, Users, CreditCard)
  - Título descritivo
  - Valor numérico em destaque
  - Texto explicativo secundário
- Layout responsivo que se adapta a diferentes tamanhos de tela

#### Área de Filtros
- Campo de busca com ícone de lupa
- Placeholder informativo sobre opções de busca (nome, email, telefone)
- Layout flexível que se adapta a diferentes tamanhos de tela

#### Tabela de Clientes
- Cabeçalhos fixos com títulos descritivos
- Colunas:
  - Nome do cliente
  - Empresa
  - Telefone
  - Email
  - Vouchers utilizados (quantidade)
  - Valor total gasto
  - Ações
- Formatação específica por tipo de dado:
  - Valores monetários alinhados à direita e formatados em reais
  - Quantidades numéricas centralizadas
- Linhas com hover state para melhor interatividade
- Menu de ações por registro (três pontos)

#### Cards Mobile
- Versão simplificada da tabela para telas pequenas
- Cards individuais por cliente
- Informações organizadas em grid de duas colunas
- Nome do cliente em destaque no topo
- Menu de ações acessível

#### Paginação
- Controle de navegação entre páginas
- Exibição de total de itens e páginas
- Seletor de itens por página
- Adaptado para mobile (versão simplificada)

#### Menu de Ações
- Dropdown contextual por cliente
- Opções disponíveis:
  - Ver detalhes
  - Enviar mensagem
- Design consistente com padrões da plataforma

#### Estado Vazio
- Ícone representativo (UserIcon)
- Mensagem principal informativa
- Sugestão para ajuste de filtros
- Espaçamento adequado para evitar sensação de erro

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e componentes: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Bordas e separadores: #E5E7EB (cinza claro)
  - Hover de linha: rgba(0, 0, 0, 0.05)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 14px (font-medium)
    - Valor de métricas: 24px (font-bold)
    - Cabeçalhos de tabela: 12px (font-medium)
    - Conteúdo da tabela: 14px (normal)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Tabela: Bordas leves, linhas zebradas opcional
  - Botões: Altura consistente, padding adequado
  - Inputs: Estilo consistente, estados de foco claros
  - Dropdowns: Alinhados e padronizados

### Responsividade
- **Desktop**: Tabela completa, métricas em linha, filtros horizontais
- **Tablet**: Adaptação para espaço reduzido, possível scrolling horizontal na tabela
- **Mobile**: 
  - Cards substituem tabela
  - Layout vertical para filtros e métricas
  - Conteúdo priorizado e reorganizado
  - Paginação simplificada

## Backend (Rails)

### Estrutura e Fluxo de Dados

O sistema de gestão de clientes segue o seguinte fluxo de dados:

1. **Carregamento da Página**:
   - Obtenção dos clientes do parceiro atual
   - Cálculo das métricas consolidadas
   - Renderização inicial com paginação

2. **Filtragem e Busca**:
   - Aplicação de filtros por texto
   - Atualização parcial da tabela/cards via Turbo

3. **Exportação de Dados**:
   - Geração de arquivo CSV/Excel com dados filtrados
   - Download pelo usuário

4. **Visualização de Detalhes** (a ser implementado):
   - Carregamento de informações detalhadas do cliente
   - Exibição de histórico de vouchers utilizados

### Controllers

#### `Partner::EmployeeController`
Controlador principal para gerenciar visualização de clientes.

**Ações:**
- `index`: Lista todos os clientes com filtros e paginação
- `export`: Gera e fornece arquivo de exportação (CSV/Excel)
- `metrics`: Retorna dados para os cards de métricas (via Turbo Stream ou JSON)
- `show`: Exibe detalhes de um cliente específico (a ser implementado)

### Models

#### `Employee`
Representa um cliente que utilizou vouchers no estabelecimento.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do cliente
- `email`: Email de contato
- `phone`: Telefone de contato
- `company_id`: Referência à empresa (quando aplicável)
- `created_at`: Data de criação do registro
- `updated_at`: Data de última atualização

**Associações:**
- `belongs_to :company, optional: true`: Empresa do funcionário
- `has_many :voucher`: Registros de vouchers utilizados por este cliente
- `has_many :vouchers, through: :voucher`: Vouchers que este cliente utilizou

**Métodos derivados:**
- `total_spent`: Valor total gasto em vouchers
- `voucher_count`: Número de vouchers utilizados

#### `Company`
Representa a empresa associada a um cliente.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa

**Associações:**
- `has_many :employees`: Funcionários da empresa (caso relevante)

#### `Voucher`
Modelo já existente, utilizado em associação.

**Atributos relevantes:**
- `id`: Identificador único
- `employee_id`: Referência ao cliente
- `voucher_id`: Referência ao voucher
- `used_at`: Data e hora de utilização
- `original_price`: Valor original gasto
- `final_price`: Valor final após desconto

**Associações:**
- `belongs_to :employee`: Cliente que utilizou o voucher
- `belongs_to :voucher`: Voucher utilizado

#### `Partner`
Representa o estabelecimento parceiro da Foome.

**Associações relacionadas:**
- `has_many :vouchers`: Vouchers oferecidos pelo parceiro
- `has_many :employees, through: :voucher`: Clientes que visitaram o estabelecimento

### Services

#### `Partner::EmployeeService`
Serviço para operações relacionadas a clientes.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro atual
- `list_emoployees(filters, page, per_page)`: Lista clientes com filtros e paginação
- `calculate_metrics`: Calcula métricas para os cards (total clientes, vouchers, valores)
- `export_employees(format = :csv)`: Gera arquivo de exportação no formato especificado

#### `Partner::EmployeeFilterService`
Serviço específico para filtrar registros de clientes.

**Métodos:**
- `initialize(partner, params)`: Inicializa com parceiro e parâmetros de filtro
- `filter`: Aplica os filtros e retorna registros
- `filter_by_text(scope, text)`: Filtra por texto em diversos campos (nome, email, telefone, empresa)

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Páginas
- `app/views/partner//index.html.erb`: View principal da listagem
- `app/views/partner/employees/show.html.erb`: View de detalhes do cliente (a implementar)

#### Partials
- `app/views/partner/employees/_metrics.html.erb`: Cards de métricas
- `app/views/partner/employees/_filters.html.erb`: Barra de filtros
- `app/views/partner/employees/_table.html.erb`: Tabela de clientes
- `app/views/partner/employees/_row.html.erb`: Linha individual na tabela
- `app/views/partner/employees/_mobile_card.html.erb`: Card para visualização mobile
- `app/views/partner/employees/_empty_state.html.erb`: Estado vazio

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :partner do
    resources :employees, only: [:index, :show] do
      collection do
        get :export
        get :metrics
      end
    end
  end
end
```

### Helpers e Formatters

#### `EmployeesHelper`

**Métodos:**
- `format_currency(value)`: Formata valores monetários no padrão brasileiro
- `format_phone(phone)`: Formata número de telefone de forma padronizada
- `filter_placeholder(columns)`: Gera placeholder dinâmico para o campo de busca

### ViewComponents

#### `MetricsCardComponent`
Component para renderizar cards de métricas com estado de carregamento.

**Props:**
- `title`: Título do card
- `value`: Valor principal a ser exibido
- `description`: Texto descritivo adicional
- `icon`: Ícone a ser exibido
- `loading`: Estado de carregamento

#### `EmployeeRowComponent`
Component para renderizar uma linha da tabela de clientes.

**Props:**
- `employee`: Dados do cliente
- `actions`: Array de ações disponíveis

#### `EmployeeCardComponent`
Component para renderizar um card de cliente na visualização mobile.

**Props:**
- `employee`: Dados do cliente
- `actions`: Array de ações disponíveis

### Stimulus Controllers

#### `employee-filter-controller`
Controller para gerenciar filtros da listagem.

**Targets:**
- `searchInput`: Campo de busca
- `table`: Tabela a ser atualizada

**Ações:**
- `connect()`: Inicializa o controller
- `filter()`: Aplica os filtros e atualiza a tabela
- `debounce()`: Aplica debounce à busca por texto
- `reset()`: Limpa os filtros aplicados

#### `export-controller`
Controller para gerenciar exportação de dados.

**Targets:**
- `exportButton`: Botão de exportação

**Ações:**
- `connect()`: Inicializa o controller
- `export(event)`: Inicia processo de exportação
- `disableButton()`: Desabilita botão durante exportação
- `enableButton()`: Reabilita botão após exportação

#### `pagination-controller`
Controller para gerenciar a paginação.

**Targets:**
- `prevButton`: Botão de página anterior
- `nextButton`: Botão de próxima página
- `pageSelect`: Seletor de página
- `pageSizeSelect`: Seletor de itens por página

**Ações:**
- `connect()`: Inicializa o controller
- `changePage(event)`: Navega para a página selecionada
- `changePageSize(event)`: Altera o número de itens por página
- `updateButtons()`: Atualiza estado dos botões de navegação

### Turbo Frames e Streams

A página de clientes utiliza Turbo para atualizações dinâmicas:

1. **Frame para Filtros**:
   ```erb
   <%= turbo_frame_tag "employee-filters" do %>
     <!-- Conteúdo dos filtros -->
   <% end %>
   ```

2. **Frame para Tabela/Cards**:
   ```erb
   <%= turbo_frame_tag "employees-table" do %>
     <!-- Conteúdo da tabela ou cards -->
   <% end %>
   ```

3. **Frame para Métricas**:
   ```erb
   <%= turbo_frame_tag "employee-metrics" do %>
     <!-- Cards de métricas -->
   <% end %>
   ```

4. **Frame para Paginação**:
   ```erb
   <%= turbo_frame_tag "employee-pagination" do %>
     <!-- Controles de paginação -->
   <% end %>
   ```

5. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "partner_#{current_partner.id}_employees" %>
   ```

### Regras de Negócio

1. **Visualização de Clientes**
   - Apenas clientes que usaram vouchers do parceiro atual são exibidos
   - Clientes são considerados do estabelecimento após primeira utilização de voucher
   - Ordenação padrão por número de vouchers utilizados (decrescente)

2. **Filtragem**
   - Busca textual em múltiplos campos: nome, email, telefone, empresa
   - Busca deve ser case-insensitive e considerar termos parciais
   - Filtros são aplicados em tempo real com debounce para melhor performance

3. **Métricas**
   - Total de clientes: contagem de clientes únicos que utilizaram vouchers
   - Total de vouchers: soma de todos os vouchers utilizados por clientes
   - Valor total gasto: soma dos valores originais gastos em todos os vouchers

4. **Exportação de Dados**
   - Deve respeitar os filtros aplicados no momento da exportação
   - Formato padrão é CSV, com opção para Excel
   - Inclui cabeçalhos claros e todos os campos visíveis na tabela
   - Adição de metadados como data de exportação e filtros aplicados

### Permissões e Autorização

1. **Acesso aos Clientes**:
   - Somente parceiros ativos podem visualizar e gerenciar seus clientes
   - Cada parceiro visualiza apenas os clientes que utilizaram seus vouchers
   - Administradores da plataforma podem acessar clientes de qualquer parceiro

2. **Limitações de Dados**:
   - Informações sensíveis de clientes são exibidas conforme legislação de proteção de dados
   - Certos campos podem ser mascarados ou omitidos conforme configurações de privacidade

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autorizado/não autorizado
   - Filtragem correta de registros
   - Geração de exportação

2. **Testes de Model**:
   - Associações entre clientes, empresas e vouchers
   - Cálculos de métricas e agregações

3. **Testes de Sistema**:
   - Fluxo completo de filtragem
   - Paginação e navegação
   - Exportação de dados
   - Visualização em diferentes tamanhos de tela

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo ao navegar entre páginas
- Preservação de estado de filtros na URL

#### Turbo Frames
- Atualização parcial da tabela/cards ao aplicar filtros
- Paginação sem reload da página completa

#### Turbo Streams
- Atualização de métricas ao aplicar filtros
- Notificações sobre sucesso/erro de exportação

#### Stimulus
- Interatividade dos filtros com atualização da tabela
- Gerenciamento do processo de exportação
- Gerenciamento da navegação por páginas

## Considerações de Performance

1. **Otimização de Consultas**:
   - Índices adequados para `employee_id`, `voucher_id`, `partner_id`
   - Eager loading de associações (company, voucher)
   - Paginação para limitar volume de registros por requisição

2. **Carregamento Eficiente**:
   - Utilizar fragment caching para elementos que mudam pouco
   - Carregar dados via Turbo Frames apenas quando necessário

3. **Exportação Otimizada**:
   - Processo em background para grandes volumes de dados
   - Limitação de número de registros por exportação
   - Compressão de arquivos para exportações grandes

## Acessibilidade

1. **Navegação e Interação**:
   - Navegação completa via teclado
   - Ordem de tabulação lógica
   - Focus styles visíveis e consistentes
   - ARIA labels para elementos sem texto visível

2. **Conteúdo e Legibilidade**:
   - Contraste adequado para texto e elementos interativos
   - Nomes descritivos para botões e controles
   - Tabela com cabeçalhos adequados para leitores de tela

3. **Formulários**:
   - Campo de busca com label adequado
   - Feedback claro após ações como exportação
   - Mensagens de erro descritivas
