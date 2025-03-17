# Documentação: Vouchers Utilizados

## Visão Geral
A página de Vouchers Utilizados permite que estabelecimentos parceiros da Foome visualizem, gerenciem e acompanhem todos os vouchers que foram utilizados pelos clientes em seu estabelecimento. Esta funcionalidade oferece um histórico detalhado de uso, com informações sobre clientes, valores, descontos aplicados e possibilita ações como validação, invalidação e edição de valores.

## Histórias de Usuário

1. Como parceiro da Foome, quero visualizar o histórico de todos os vouchers utilizados no meu estabelecimento para acompanhar o desempenho das minhas promoções.

2. Como gerente de restaurante, quero filtrar os vouchers utilizados por status (validados, invalidados, pendentes) para gerenciar melhor meu fluxo de trabalho.

3. Como administrador de estabelecimento, quero validar ou invalidar vouchers para controlar possíveis fraudes ou usos indevidos.

4. Como parceiro, quero editar o valor total gasto pelo cliente quando necessário para corrigir eventuais erros de registro.

5. Como gerente financeiro, quero visualizar métricas consolidadas (total de vouchers, valor em descontos, ticket médio) para avaliar o impacto financeiro das promoções.

6. Como administrador, quero buscar vouchers específicos por nome de cliente, voucher ou telefone para resolver questões específicas rapidamente.

## Design & Frontend

### Estrutura da Página
A página de vouchers utilizados é estruturada em seções claramente definidas:

1. **Cabeçalho Superior**:
   - Título "Vouchers utilizados" e subtítulo descritivo
   - Navegação e contexto

2. **Cards de Métricas**:
   - Resumo estatístico em 3 cards principais
   - Visualização rápida de KPIs importantes

3. **Área de Filtros**:
   - Campo de busca textual
   - Seletor de filtro por status (Todos/Validados/Invalidados/Pendentes)

4. **Tabela de Vouchers Utilizados**:
   - Listagem detalhada com múltiplas colunas
   - Paginação integrada
   - Ações contextuais por registro

5. **Visualização Mobile**:
   - Cards individuais substituindo a tabela
   - Exibição condensada com todas as informações essenciais

6. **Modais de Ação**:
   - Modal para edição de valor
   - Diálogos de confirmação para validação/invalidação

7. **Estado Vazio**:
   - Exibido quando o parceiro não possui vouchers ou nenhum voucher foi utilizado
   - Call-to-action para criar o primeiro voucher

### Componentes

#### Cabeçalho da Página
- Título "Vouchers utilizados" em fonte grande e negrito
- Subtítulo explicativo em tamanho menor e cor mais clara
- Espaçamento adequado para separar do conteúdo principal

#### Cards de Métricas
- Três cards horizontais com informações estatísticas:
  - Total de vouchers utilizados
  - Valor total em descontos concedidos
  - Valor médio de compra (ticket médio)
- Cada card contém:
  - Ícone representativo (Ticket, DollarSign, BarChart)
  - Título descritivo
  - Valor numérico em destaque
  - Texto explicativo secundário
- Layout responsivo que se adapta a diferentes tamanhos de tela

#### Área de Filtros
- Campo de busca com ícone de lupa
- Placeholder informativo sobre opções de busca
- Select dropdown para filtragem por status
- Layout flexível que se adapta a diferentes tamanhos de tela

#### Tabela de Vouchers
- Cabeçalhos fixos com títulos descritivos
- Colunas:
  - ID do voucher
  - Data/hora de uso
  - Nome do voucher
  - Cliente
  - Telefone
  - Empresa
  - Valor gasto (original)
  - Desconto aplicado
  - Valor final
  - Status (com badge visual)
  - Ações
- Formatação específica por tipo de dado:
  - Valores monetários alinhados à direita
  - Datas formatadas no padrão brasileiro
  - Status com badges coloridos
- Linhas com hover state para melhor interatividade
- Menu de ações por registro (três pontos)

#### Cards Mobile
- Versão simplificada da tabela para telas pequenas
- Cards individuais por voucher utilizado
- Informações organizadas em grid de duas colunas
- Badge de status em destaque
- Menu de ações acessível

#### Paginação
- Controle de navegação entre páginas
- Exibição de total de itens e páginas
- Seletor de itens por página
- Adaptado para mobile (versão simplificada)

#### Modal de Edição de Valor
- Título claro "Editar valor gasto"
- Descrição explicativa das consequências da edição
- Campo numérico para input do novo valor
- Botões de ação (Cancelar, Salvar)
- Validação de entrada (valor positivo)

#### Diálogo de Confirmação
- Título informativo sobre a ação (Validar/Invalidar)
- Descrição das consequências da ação
- Botões de ação com cores contextuais
- Design consistente com alertas do sistema

#### Estado Vazio
- Mensagem clara sobre a ausência de dados
- Redirecionamento para criar vouchers se necessário

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e componentes: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Bordas e separadores: #E5E7EB (cinza claro)
  - Status validado: #10B981 (verde)
  - Status invalidado: #EF4444 (vermelho)
  - Status pendente: #6B7280 (cinza)
  - Hover de linha: rgba(0, 0, 0, 0.05)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 14px (font-medium)
    - Valor de métricas: 24px (font-bold)
    - Cabeçalhos de tabela: 12px (font-medium, uppercase)
    - Conteúdo da tabela: 14px (normal)
    - Badges: 12px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Tabela: Bordas leves, linhas zebradas opcional
  - Badges: Pill-shaped com cores contextuais
  - Botões: Altura consistente, padding adequado
  - Inputs: Estilo consistente, estados de foco claros
  - Modais: Overlay escuro, card central com sombra

### Responsividade
- **Desktop**: Tabela completa, métricas em linha, filtros horizontais
- **Tablet**: Adaptação para espaço reduzido, possível scrolling horizontal na tabela
- **Mobile**: 
  - Cards substituem tabela
  - Layout vertical para filtros e métricas
  - Conteúdo priorizado e reorganizado
  - Modais adaptados para tela cheia ou parcial

## Backend (Rails)

### Estrutura e Fluxo de Dados

O sistema de vouchers utilizados segue o seguinte fluxo de dados:

1. **Carregamento da Página**:
   - Obtenção dos vouchers utilizados do parceiro atual
   - Cálculo das métricas consolidadas
   - Renderização inicial com possível paginação

2. **Filtragem e Busca**:
   - Aplicação de filtros por status, texto de busca
   - Atualização parcial da tabela/cards via Turbo

3. **Edição de Valor**:
   - Captura do valor atual
   - Modificação pelo usuário
   - Recálculo do valor final (mantendo o desconto original)
   - Persistência e atualização na interface

4. **Validação/Invalidação**:
   - Confirmação da ação pelo usuário
   - Mudança de status no banco de dados
   - Atualização do registro na tabela/card

### Controllers

#### `Partner::VoucherController`
Controlador principal para gerenciar vouchers utilizados.

**Ações:**
- `index`: Lista todos os vouchers utilizados com filtros e paginação
- `update`: Atualiza informações de um uso de voucher (como valor)
- `validate`: Marca um voucher como validado
- `invalidate`: Marca um voucher como invalidado
- `metrics`: Retorna dados para os cards de métricas (via Turbo Stream ou JSON)

### Models

#### `Voucher`
Representa o registro de um voucher que foi utilizado.

**Atributos relevantes:**
- `id`: Identificador único
- `promotion_id`: Referência ao voucher original
- `employee_id`: Referência ao funcionário/cliente que utilizou
- `used_at`: Data e hora de utilização
- `original_price`: Valor original gasto pelo cliente
- `discount_amount`: Valor do desconto aplicado
- `final_price`: Valor final após desconto
- `status`: Status do uso ('validated', 'invalidated', 'pending')
- `created_at`: Data de criação do registro
- `updated_at`: Data de última atualização

**Associações:**
- `belongs_to :promotion`: O voucher que foi utilizado
- `belongs_to :employee`: O funcionário/cliente que utilizou o voucher
- `has_one :company, through: :employee`: A empresa do funcionário

**Validações:**
- Presença de campos obrigatórios (voucher_id, used_at, etc.)
- Valores numéricos positivos
- Status dentro das opções permitidas

#### `Promotion`
Modelo já existente, utilizado em associação.

**Associações relacionadas:**
- `has_many :voucher`: Registros de uso deste voucher

#### `Employee`
Representa um funcionário/usuário que utilizou o voucher.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do funcionário
- `phone`: Telefone de contato
- `company_id`: Referência à empresa do funcionário

**Associações:**
- `belongs_to :company`: Empresa do funcionário
- `has_many :voucher`: Registros de vouchers utilizados

#### `Company`
Representa a empresa do funcionário.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa

**Associações:**
- `has_many :employees`: Funcionários da empresa

### Services

#### `Partner::VoucherService`
Serviço para operações relacionadas a vouchers utilizados.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro atual
- `list_usages(filters, page, per_page)`: Lista usos de voucher com filtros e paginação
- `update_value(voucher_id, new_value)`: Atualiza o valor de um voucher utilizado
- `change_status(voucher_id, new_status)`: Altera o status de um voucher utilizado
- `calculate_metrics(date_range = nil)`: Calcula métricas para o dashboard

#### `Partner::VoucherFilterService`
Serviço específico para filtrar registros de uso.

**Métodos:**
- `initialize(partner, params)`: Inicializa com parceiro e parâmetros de filtro
- `filter`: Aplica os filtros e retorna registros
- `filter_by_text(scope, text)`: Filtra por texto em diversos campos
- `filter_by_status(scope, status)`: Filtra por status específico

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Páginas
- `app/views/partner/voucher/index.html.erb`: View principal da listagem

#### Partials
- `app/views/partner/voucher/_metrics.html.erb`: Cards de métricas
- `app/views/partner/voucher/_filters.html.erb`: Barra de filtros
- `app/views/partner/voucher/_table.html.erb`: Tabela de vouchers utilizados
- `app/views/partner/voucher/_row.html.erb`: Linha individual na tabela
- `app/views/partner/voucher/_mobile_card.html.erb`: Card para visualização mobile
- `app/views/partner/voucher/_empty_state.html.erb`: Estado vazio
- `app/views/partner/voucher/_status_badge.html.erb`: Badge de status

#### Modais
- `app/views/partner/voucher/_edit_value_modal.html.erb`: Modal para edição de valor
- `app/views/partner/voucher/_confirm_status_modal.html.erb`: Modal de confirmação

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :partner do
    resources :voucher, only: [:index, :update] do
      member do
        patch :validate
        patch :invalidate
      end
      collection do
        get :metrics
      end
    end
  end
end
```

### Helpers e Formatters

#### `VoucherHelper`

**Métodos:**
- `format_currency(value)`: Formata valores monetários no padrão brasileiro
- `format_date_time(datetime)`: Formata data e hora no padrão brasileiro
- `voucher_status_badge(status)`: Retorna classes e texto para o badge de status
- `discount_percentage(original, discount)`: Calcula percentual de desconto

### ViewComponents

#### `MetricsCardComponent`
Component para renderizar cards de métricas com estado de carregamento.

**Props:**
- `title`: Título do card
- `value`: Valor principal a ser exibido
- `description`: Texto descritivo adicional
- `icon`: Ícone a ser exibido
- `loading`: Estado de carregamento

#### `StatusBadgeComponent`
Component para renderizar badge de status.

**Props:**
- `status`: Status a ser exibido ('validated', 'invalidated', 'pending')
- `size`: Tamanho do badge ('sm', 'md', 'lg')

### Stimulus Controllers

#### `voucher-filter-controller`
Controller para gerenciar filtros da listagem.

**Targets:**
- `searchInput`: Campo de busca
- `statusSelect`: Seletor de status
- `table`: Tabela a ser atualizada

**Ações:**
- `connect()`: Inicializa o controller
- `filter()`: Aplica os filtros e atualiza a tabela
- `debounce()`: Aplica debounce à busca por texto
- `reset()`: Limpa os filtros aplicados

#### `edit-value-controller`
Controller para gerenciar o modal de edição de valor.

**Targets:**
- `form`: Formulário de edição
- `input`: Campo de entrada do valor
- `originalValue`: Elemento que mostra valor original
- `discountValue`: Elemento que mostra valor de desconto
- `finalValue`: Elemento que mostra valor final calculado

**Ações:**
- `connect()`: Inicializa o controller
- `open(event)`: Abre o modal com os valores corretos
- `calculate()`: Recalcula o valor final com base no novo valor e desconto
- `validate()`: Valida o valor inserido
- `save(event)`: Salva o novo valor

#### `status-change-controller`
Controller para gerenciar validação/invalidação de vouchers.

**Targets:**
- `confirmDialog`: Diálogo de confirmação
- `confirmButton`: Botão de confirmação da ação
- `cancelButton`: Botão de cancelamento

**Ações:**
- `connect()`: Inicializa o controller
- `showConfirmation(event)`: Exibe diálogo de confirmação com contexto correto
- `cancel()`: Cancela a operação
- `confirm()`: Confirma a alteração de status

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

A página de vouchers utilizados utiliza Turbo para atualizações dinâmicas:

1. **Frame para Filtros**:
   ```erb
   <%= turbo_frame_tag "voucher-filters" do %>
     <!-- Conteúdo dos filtros -->
   <% end %>
   ```

2. **Frame para Tabela/Cards**:
   ```erb
   <%= turbo_frame_tag "voucher-table" do %>
     <!-- Conteúdo da tabela ou cards -->
   <% end %>
   ```

3. **Frame para Métricas**:
   ```erb
   <%= turbo_frame_tag "voucher-metrics" do %>
     <!-- Cards de métricas -->
   <% end %>
   ```

4. **Frame para Paginação**:
   ```erb
   <%= turbo_frame_tag "voucher-pagination" do %>
     <!-- Controles de paginação -->
   <% end %>
   ```

5. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "partner_#{current_partner.id}_voucher" %>
   ```

### Regras de Negócio

1. **Visualização de Vouchers Utilizados**
   - Apenas vouchers do parceiro atual são exibidos
   - Registros são ordenados por data de uso (mais recentes primeiro)
   - Paginação padrão de 10 itens por página

2. **Estados de Vouchers**
   - **Pendente**: Estado inicial, aguardando confirmação do estabelecimento
   - **Validado**: Voucher confirmado como utilizado corretamente
   - **Invalidado**: Voucher marcado como inválido ou fraudulento

3. **Edição de Valores**
   - Somente o valor original pode ser editado
   - O valor do desconto permanece fixo
   - O valor final é recalculado automaticamente (original - desconto)
   - Não é permitido valor original menor que o desconto

4. **Filtragem**
   - Busca textual em múltiplos campos: nome do voucher, cliente, telefone, empresa
   - Filtro por status: todos, validados, invalidados, pendentes
   - Filtros são aplicados em tempo real ou com debounce para melhor performance

5. **Métricas**
   - Total de vouchers: contagem de registros filtrados
   - Valor em descontos: soma dos descontos de todos os registros filtrados
   - Valor médio: média dos valores originais de todos os registros filtrados

### Permissões e Autorização

1. **Acesso aos Vouchers Utilizados**:
   - Somente parceiros ativos podem visualizar e gerenciar seus vouchers utilizados
   - Cada parceiro visualiza apenas os vouchers utilizados em seu estabelecimento
   - Administradores da plataforma podem acessar vouchers de qualquer parceiro

2. **Operações Permitidas**:
   - Validação/Invalidação: disponível para qualquer status, mas com confirmação
   - Edição de valor: disponível para qualquer status, mas afeta apenas o valor original e final

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autorizado/não autorizado
   - Filtragem correta de registros
   - Atualização de valores
   - Mudança de status

2. **Testes de Model**:
   - Validações de campos
   - Relacionamentos
   - Cálculos derivados

3. **Testes de Sistema**:
   - Fluxo completo de filtragem
   - Edição de valores
   - Validação/invalidação de vouchers
   - Navegação por páginas
   - Visualização em diferentes tamanhos de tela

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo ao navegar entre páginas
- Preservação de estado de filtros na URL

#### Turbo Frames
- Atualização parcial da tabela/cards ao aplicar filtros
- Modal de edição carregado via frame
- Paginação sem reload da página completa

#### Turbo Streams
- Atualização de status após validação/invalidação
- Atualização de valor após edição
- Atualização de métricas ao aplicar filtros

#### Stimulus
- Interatividade dos filtros com atualização da tabela
- Cálculo em tempo real no modal de edição de valor
- Confirmação antes de alterações de status
- Gerenciamento da navegação por páginas

## Considerações de Performance

1. **Otimização de Consultas**:
   - Índices adequados para voucher_id, partner_id, status
   - Eager loading de associações (voucher, employee, company)
   - Paginação para limitar volume de registros por requisição

2. **Carregamento Eficiente**:
   - Utilizar fragment caching para elementos que mudam pouco
   - Aplicar lazy loading para imagens (se houver)
   - Carregar dados via Turbo Frames apenas quando necessário

3. **Responsividade e Renderização**:
   - Minimizar reflow e repaint ao atualizar a tabela
   - Priorizar dados essenciais em telas menores
   - Substituir tabela por cards em telas pequenas para melhor experiência

## Acessibilidade

1. **Navegação e Interação**:
   - Navegação completa via teclado
   - Ordem de tabulação lógica
   - Focus style visíveis e consistentes
   - ARIA labels para elementos sem texto visível

2. **Conteúdo e Legibilidade**:
   - Contraste adequado para texto e elementos interativos
   - Nomes descritivos para botões e controles
   - Mensagens de erro e feedback claras
   - Badges com texto alternativo além da cor

3. **Formulários e Modais**:
   - Etiquetas explícitas para todos os campos
   - Mensagens de erro associadas aos campos específicos
   - Foco gerenciado adequadamente ao abrir/fechar modais
   - Submissão possível via teclado
