# Documentação: Gestão de Promoções para Estabelecimentos Parceiros

## Visão Geral
A página de Gestão de Promoções permite que estabelecimentos parceiros da Foome criem, visualizem, editem e gerenciem promo promocionais. Esta funcionalidade é essencial para que restaurantes e outros estabelecimentos possam oferecer promoções e descontos aos usuários da plataforma, aumentando sua visibilidade e atraindo novos clientes.

## Histórias de Usuário

1. Como parceiro da Foome, quero criar diferentes tipos de promoções promocionais para atrair clientes ao meu estabelecimento.

2. Como gerente de restaurante, quero definir condições específicas para meus promoções (valor mínimo de compra, dias da semana, horários válidos) para otimizar meu fluxo de clientes.

3. Como parceiro, quero visualizar todos os meus promoções em um só lugar para gerenciar minhas estratégias promocionais.

4. Como administrador de estabelecimento, quero ativar/desativar promoções conforme necessário para controlar quais promoções estão ativas.

5. Como parceiro da plataforma, quero duplicar promoções existentes para criar rapidamente promoções similares sem reconfigurar tudo novamente.

6. Como gerente de marketing, quero filtrar meus promoções por tipo ou status para encontrar rapidamente promoções específicas.

## Design & Frontend

### Estrutura da Página
A página de promoções é estruturada em seções claramente definidas:

1. **Cabeçalho Superior**:
   - Título "Promoções" e subtítulo descritivo
   - Botão de ação para criar novo promotion (canto superior direito)

2. **Área de Filtros**:
   - Campo de busca por texto
   - Seletores de filtro por status (ativos/inativos/todos)
   - Seletores de filtro por tipo de promotion

3. **Grade de Cards de Promoções**:
   - Layout em grid responsivo (3 colunas em desktop, 2 em tablet, 1 em mobile)
   - Cards individuais representando cada promotion

4. **Estado Vazio**:
   - Exibido quando o parceiro não possui promoções cadastrados
   - Call-to-action para criar o primeiro promotion

5. **Modal de Formulário**:
   - Formulário modal para criação/edição de promoções
   - Multi-step ou organizado em seções lógicas

### Componentes

#### Cabeçalho da Página
- Título "Promoções" em fonte grande e negrito
- Subtítulo explicativo em tamanho menor e cor mais clara
- Botão de ação "Criar promotion" em destaque com ícone de adição (+)

#### Filtros
- Campo de busca com ícone de lupa
- Select dropdown para filtragem por status (Todos/Ativos/Inativos)
- Select dropdown para filtragem por tipo (Todos/Desconto percentual/Valor fixo/Item grátis/etc.)
- Layout responsivo que se adapta a diferentes tamanhos de tela

#### Cards de Promotion
- Cartões com sombra suave e bordas arredondadas
- Cabeçalho com:
  - Nome do promotion
  - Badge de status (Ativo/Inativo/Desativando)
  - Descrição opcional
- Corpo com:
  - Tipo e valor do desconto com ícone correspondente
  - Valor mínimo de compra (se aplicável)
  - Período de validade com ícone de calendário
  - Horários válidos com ícone de relógio (se aplicável)
  - Tags para dias da semana válidos
- Rodapé com:
  - Botões de ação (Editar, Duplicar, Ativar/Desativar)
  - Tooltips explicativos para cada ação

#### Estado Vazio
- Ilustração central representando conceito de promoções
- Título informativo "Crie seu primeiro promotion"
- Texto explicativo sobre benefícios
- Botão de call-to-action em destaque

#### Modal de Formulário
- Título dinâmico (Criar/Editar/Duplicar promotion)
- Campos organizados em seções lógicas:
  - Informações básicas (nome, descrição)
  - Tipo e valor do desconto
  - Condições de uso (valor mínimo, período de validade)
  - Restrições (dias da semana, horários)
- Botões de ação no rodapé (Cancelar, Salvar)
- Validação visual de campos com feedback imediato

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Secundária/botões escuros: #000000 (preto)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e componentes: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Status ativo: #10B981 (verde)
  - Status inativo: #6B7280 (cinza)
  - Status desativando: #F59E0B (amarelo)
  - Bordas e separadores: #E5E7EB (cinza claro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 18px (font-semibold)
    - Descrição de card: 14px (text-gray-500)
    - Informações: 14px (normal)
    - Tags e badges: 12px (font-medium)
    - Botões: 14px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave, hover com efeito de elevação
  - Botões: Altura consistente, padding adequado, cantos arredondados
  - Badges: Oval/pill-shaped com cor de fundo suave
  - Ícones: Consistentes em tamanho (16px-20px), alinhados com texto
  - Tooltips: Aparecem ao hover, com informações contextuais

### Responsividade
- **Desktop**: Grid de 3 colunas, filtros em linha horizontal
- **Tablet**: Grid de 2 colunas, filtros adaptados ao espaço
- **Mobile**: 
  - Grid de 1 coluna
  - Filtros em layout vertical ou dropdown compacto
  - Simplificação de alguns elementos visuais
  - Modal de formulário em tela cheia

## Backend (Rails)

### Estrutura e Fluxo de Dados

O sistema de promoções segue o seguinte fluxo de dados:

1. **Listagem de Promoções**:
   - Carregamento inicial de todos os promoções do parceiro
   - Aplicação de filtros (status, tipo, busca)
   - Exibição em cards organizados

2. **Criação/Edição de Promotion**:
   - Preenchimento do formulário
   - Validação dos dados
   - Persistência no banco de dados
   - Feedback de sucesso/erro
   - Atualização da lista via Turbo

3. **Ativação/Desativação de Promotion**:
   - Verificação de restrições (se o promotion pode ser desativado imediatamente)
   - Agendamento de desativação quando necessário
   - Atualização de status
   - Feedback com toast/notificação

4. **Duplicação de Promotion**:
   - Cópia de todos os atributos, exceto ID
   - Atualização do nome (prefixo "Cópia de")
   - Abertura do formulário pré-preenchido para edição

### Controllers

#### `Partner::PromotionsController`
Controlador principal para gerenciar promoções do parceiro.

**Ações:**
- `index`: Lista todos os promoções do parceiro atual
- `new`: Exibe formulário para novo promotion
- `create`: Processa criação de um novo promotion
- `edit`: Exibe formulário para edição
- `update`: Processa atualização de um promotion
- `destroy`: Remove um promotion (se permitido)
- `toggle_status`: Ativa/desativa um promotion
- `duplicate`: Cria uma cópia de um promotion existente

### Models

#### `Promotion`
Representa um promotion/cupom de desconto criado pelo parceiro.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro que criou o promotion
- `name`: Nome do promotion
- `description`: Descrição detalhada (opcional)
- `type`: Tipo de promotion (discount, fixed_value, item, item_discount)
- `value`: Valor do desconto (percentual ou fixo)
- `min_purchase`: Valor mínimo para uso (opcional)
- `valid_from`: Data de início da validade
- `valid_to`: Data de fim da validade
- `days_of_week`: Dias da semana válidos (array/JSON)
- `time_range`: Horários válidos (JSON com start e end)
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `item_sale_price`: Preço de venda do item (para promoções de item)
- `item_cost`: Custo do item (para promoções de item)
- `scheduled_deactivation`: Data de desativação programada

**Associações:**
- `belongs_to :partner`: Estabelecimento que oferece o promotion
- `has_many :vouchers`: Registros de uso deste promotion

**Validações:**
- Presença de campos obrigatórios (nome, tipo, valor, datas de validade)
- Validade das datas (data final maior que inicial)
- Formato correto para time_range e days_of_week
- Valor apropriado ao tipo de promotion

#### `Partner`
Representa um estabelecimento parceiro da plataforma.

**Atributos relevantes para promoções:**
- `id`: Identificador único
- `active`: Status de ativação

**Associações relacionadas:**
- `has_many :promotions`: Promoções oferecidos pelo parceiro

#### `Promotion`
Representa o uso de um promotion por um cliente.

**Atributos relevantes:**
- `id`: Identificador único 
- `voucher_id`: Referência ao promotion
- `customer_id`: Referência ao cliente
- `used_at`: Data e hora de uso
- `value`: Valor do desconto aplicado

**Associações:**
- `belongs_to :promotion`: Promotion utilizado

### Services

#### `Partner::PromotionService`
Serviço para operações complexas relacionadas a promoções.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro
- `create_voucher(params)`: Cria um novo promotion com parâmetros validados
- `update_voucher(promotion, params)`: Atualiza um promotion existente
- `toggle_status(promotion)`: Gerencia a ativação/desativação
- `duplicate_voucher(promotion)`: Cria uma cópia de um promotion existente
- `check_editability(promotion)`: Verifica se o promotion pode ser editado
- `schedule_deactivation(promotion)`: Agenda a desativação de um promotion

#### `Partner::PromotionFilterService`
Serviço para filtrar promoções por diferentes critérios.

**Métodos:**
- `initialize(partner, filters)`: Inicializa o serviço com o parceiro e filtros
- `filter`: Retorna promoções filtrados por status, tipo e termo de busca

### Jobs

#### `ScheduledVoucherDeactivationJob`
Job para desativar promoções conforme agendamento.

**Métodos:**
- `perform(voucher_id)`: Desativa o promotion com o ID especificado

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Promoções
- `app/views/partner/promotions/index.html.erb`: View principal da listagem de promotions

#### Partials
- `app/views/partner/promotions/_filter_bar.html.erb`: Barra de filtros
- `app/views/partner/promotions/_voucher_card.html.erb`: Card individual de promotion
- `app/views/partner/promotions/_empty_state.html.erb`: Estado vazio para quando não há promotions
- `app/views/partner/promotions/_form.html.erb`: Formulário de criação/edição de promotion
- `app/views/partner/promotions/_status_badge.html.erb`: Badge de status do promotion
- `app/views/partner/promotions/_day_tags.html.erb`: Tags para dias da semana

#### Modais
- `app/views/partner/promotions/_voucher_modal.html.erb`: Modal para formulário de criação/edição

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :partner do
    resources :promotions do
      member do
        patch :toggle_status
        post :duplicate
      end
      collection do
        get :check_editability
      end
    end
  end
end
```

### Helpers e Formatters

#### `PromotionsHelper`

**Métodos:**
- `format_promotion_type(type, value)`: Formata o tipo do promotion para exibição
- `translate_day_of_week(day)`: Traduz o dia da semana para português
- `promotion_status_class(promotion)`: Retorna classes CSS para o status
- `format_time_range(time_range)`: Formata o intervalo de tempo para exibição
- `format_date_range(valid_from, valid_to)`: Formata o intervalo de datas

### Stimulus Controllers

#### `promotion-form-controller`
Controller para gerenciar o formulário de promotion.

**Ações:**
- `connect()`: Inicializa o formulário
- `toggleFields()`: Mostra/esconde campos conforme o tipo de promotion
- `validateFields()`: Valida campos antes do envio
- `submitForm(event)`: Intercepta o envio do formulário
- `resetForm()`: Limpa o formulário

#### `promotion-card-controller`
Controller para gerenciar interações com os cards de promotion.

**Ações:**
- `connect()`: Inicializa o card
- `edit(event)`: Abre modal de edição
- `duplicate(event)`: Inicia processo de duplicação
- `toggleStatus(event)`: Ativa/desativa o promotion

#### `promotion-filter-controller`
Controller para gerenciar filtros da listagem.

**Ações:**
- `connect()`: Inicializa os filtros
- `filter()`: Aplica filtros à listagem
- `resetFilters()`: Limpa todos os filtros
- `debounceSearch()`: Aplica debounce à busca por texto

#### `tooltip-controller`
Controller para gerenciar tooltips informativos.

**Ações:**
- `connect()`: Inicializa tooltips
- `showTooltip(event)`: Exibe tooltip ao hover
- `hideTooltip(event)`: Esconde tooltip

### Turbo Frames e Streams

A página de promotions utiliza Turbo para atualizações dinâmicas:

1. **Frame para Listagem de Promoções**:
   ```erb
   <%= turbo_frame_tag "promotions-list" do %>
     <!-- Cards de promotions -->
   <% end %>
   ```

2. **Frame para Cada Promotion**:
   ```erb
   <%= turbo_frame_tag dom_id(promotion) do %>
     <!-- Conteúdo do card de promotion -->
   <% end %>
   ```

3. **Frame para Formulário**:
   ```erb
   <%= turbo_frame_tag "promotion-form" do %>
     <!-- Formulário de promotion -->
   <% end %>
   ```

4. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "partner_#{current_partner.id}_promotions" %>
   ```

### Regras de Negócio

1. **Criação de Promoções**
   - Apenas parceiros ativos podem criar promotions
   - O período de validade deve ser coerente (data final após a inicial)
   - É possível definir restrições de dias e horários

2. **Tipos de Promoções**
   - **Desconto percentual**: Redução percentual no valor total
   - **Valor fixo**: Desconto de um valor monetário específico
   - **Item grátis**: Oferece um item gratuito
   - **Desconto no segundo item**: Desconto percentual em um segundo item

3. **Edição de Promoções**
   - Promoções que já foram utilizados por clientes não podem ser editados diretamente
   - Para promotions já utilizados, é possível apenas desativá-los

4. **Ativação/Desativação**
   - Promoções podem ser ativados imediatamente
   - Promoções que não foram utilizados podem ser desativados imediatamente
   - Promoções já utilizados por clientes são desativados com período de carência (24h)
   - É possível cancelar uma desativação agendada

5. **Duplicação**
   - Qualquer promotion pode ser duplicado, independente de seu status
   - O promotion duplicado recebe um prefixo no nome ("Cópia de...")
   - O promotion duplicado é criado como rascunho não salvo

6. **Filtragem**
   - Promoções podem ser filtrados por status (ativos/inativos)
   - Promoções podem ser filtrados por tipo
   - Promoções podem ser buscados por nome ou descrição

### Permissões e Autorização

1. **Acesso aos Promoções**:
   - Somente parceiros ativos podem visualizar e gerenciar promotions
   - Cada parceiro visualiza apenas seus próprios promotions
   - Administradores da plataforma podem acessar promotions de qualquer parceiro

2. **Limitações por Plano/Conta**:
   - Pode haver limite máximo de promotions ativos simultaneamente
   - Restrições específicas podem ser aplicadas conforme o tipo de conta

### Integrações

1. **Serviço de Notificações**:
   - Notificação de promotions prestes a expirar
   - Alerta sobre desativação programada

2. **Exportação de Dados**:
   - Permitir exportação da lista de promotions para CSV/Excel

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autorizado/não autorizado
   - CRUD completo de promotions
   - Ativação/desativação
   - Duplicação

2. **Testes de Model**:
   - Validações de campos
   - Relacionamentos
   - Callbacks

3. **Testes de Sistema**:
   - Fluxo completo de criação/edição
   - Filtragem de promotions
   - Interação com cards e botões

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo ao navegar entre páginas
- Preservação de estado de filtros na URL

#### Turbo Frames
- Atualização parcial de promotions individuais ao alterar status
- Modal de formulário carregado via frame
- Preservação de contexto ao editar/duplicar

#### Turbo Streams
- Adição/remoção de promotions da lista sem refresh
- Atualização de contadores e estatísticas
- Notificações sobre alterações de status

#### Stimulus
- Interatividade do formulário com campos dinâmicos
- Validação do lado do cliente
- Feedback visual durante operações
- Gerenciamento de tooltips e modais

## Considerações de Performance

1. **Otimização de Consultas**:
   - Índices adequados para filtros frequentes (partner_id, status, type)
   - Paginação para grandes volumes de promotions
   - Ordenação eficiente (recentes primeiro)

2. **Carregamento Otimizado**:
   - Lazy loading para promotions fora da viewport
   - Turbo frames para carregamento parcial
   - Uso de fragment caching para cards

3. **Renderização Eficiente**:
   - Minimizar reflow/repaint ao manipular cards
   - Otimizar animações e transições
   - Colocar filtros em um frame separado para evitar re-renderização completa

## Acessibilidade

1. **Navegação e Interação**:
   - Todos os elementos interativos acessíveis via teclado
   - Ordem de tabulação lógica
   - Rótulos descritivos para campos e botões
   - ARIA labels para elementos sem texto visível

2. **Conteúdo Visual**:
   - Contraste adequado para texto e elementos interativos
   - Uso de texto alternativo para ícones funcionais
   - Feedbacks não dependentes apenas de cor

3. **Formulários**:
   - Validação com mensagens de erro claras
   - Agrupamento lógico de campos relacionados
   - Labels explícitos para todos os campos

4. **Estados e Notificações**:
   - Mensagens de toast/alerta compatíveis com leitores de tela
   - Indicação clara de mudanças de estado
   - Foco apropriado após interações importantes
