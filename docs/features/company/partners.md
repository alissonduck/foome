# Documentação: Página de Parceiros Empresariais

## Visão Geral
A página de Parceiros Empresariais permite que empresas visualizem, filtrem e gerenciem os estabelecimentos parceiros disponíveis no sistema Foome. Os usuários podem consultar informações sobre os parceiros, visualizar seus vouchers disponíveis e sugerir novos estabelecimentos para parcerias.

## Histórias de Usuário

1. Como administrador de empresa, quero visualizar todos os estabelecimentos parceiros disponíveis para minha empresa.
2. Como gestor de benefícios, quero filtrar parceiros por categorias, localização e características específicas.
3. Como usuário, quero pesquisar parceiros pelo nome para encontrá-los rapidamente.
4. Como responsável por compras, quero visualizar os vouchers disponíveis em cada estabelecimento parceiro.
5. Como administrador, quero sugerir novos estabelecimentos para que sejam incluídos como parceiros na plataforma.
6. Como gestor, quero ordenar a lista de parceiros por diferentes critérios (mais novos, mais antigos, proximidade).

## Design & Frontend

### Estrutura da Página
A página é estruturada em três áreas principais:

1. **Cabeçalho**:
   - Título e subtítulo da página
   - Informações contextuais

2. **Área de Filtros e Busca**:
   - Campo de busca
   - Dropdown de ordenação
   - Botão de filtros avançados

3. **Grid de Parceiros**:
   - Cards de parceiros organizados em grade responsiva
   - Exibição de informações essenciais sobre cada parceiro

### Componentes

#### Cabeçalho da Página
- Título "Parceiros"
- Subtítulo "Gerencie os parceiros disponíveis para sua empresa"

#### Área de Filtros e Busca
- **Campo de Busca**: 
  - Input com ícone de lupa
  - Placeholder "Buscar parceiros..."
  - Busca em tempo real

- **Controle de Ordenação**:
  - Dropdown com opções de ordenação
  - Opções: "Mais novos", "Mais antigos", "Mais próximos"
  - Ícones indicativos para cada opção de ordenação

- **Botão de Filtros Avançados**:
  - Botão "Filtrar" com ícone de filtro
  - Contador de filtros ativos
  - Aciona drawer lateral de filtros

#### Drawer de Filtros Avançados
- **Filtro por Estado**:
  - Dropdown de seleção de estado
  - Lista de estados disponíveis

- **Filtro por Cidade**:
  - Dropdown de seleção de cidade
  - Lista filtrada conforme estado selecionado

- **Filtro por Categoria**:
  - Dropdown de seleção de categoria
  - Categorias como: Restaurante, Café, Lanchonete, etc.

- **Filtro por Tipo de Cozinha**:
  - Dropdown de seleção de tipos culinários
  - Opções como: Italiana, Japonesa, Brasileira, etc.

- **Filtro por Características**:
  - Dropdown de seleção de características
  - Opções como: Estacionamento, Acessibilidade, Pet-friendly, etc.

- **Botões de Ação**:
  - Botão "Aplicar Filtros"
  - Botão "Limpar Filtros"

#### Card de Parceiro
- **Imagem de Capa**: Foto do estabelecimento ou imagem padrão
- **Logo**: Logo do parceiro em destaque sobre a imagem
- **Nome do Estabelecimento**: Em destaque
- **Endereço**: Cidade/UF
- **Categoria(s)**: Tags de categorias
- **Indicador de Preço**: Símbolos "$" indicando faixa de preço
- **Badge de Vouchers**: Número de vouchers disponíveis
- **Botões de Ação**:
  - "Ver vouchers": Abre modal de vouchers do parceiro

#### Modal de Vouchers
- **Cabeçalho**: Nome e logo do parceiro
- **Lista de Vouchers Disponíveis**:
  - Valor do voucher
  - Desconto aplicado
  - Condições de uso (valor mínimo)
  - Período de validade
  - Dias da semana válidos
- **Estado de Carregamento**: Indicador visual durante o carregamento
- **Estado Vazio**: Mensagem quando não há vouchers disponíveis

#### Modal de Sugerir Parceiro
- **Formulário de Sugestão**:
  - Nome do estabelecimento
  - Endereço/localização
  - Categoria
  - Informações de contato
  - Campo para observações

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Filtro ativo: #FF4D4D (vermelho) com fundo #FEE2E2 (vermelho claro)
  - Botão de filtro: Fundo #000000 (preto) com texto branco
  - Badge de vouchers: #FF4D4D (vermelho) com texto branco

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Nome do parceiro: 18px (font-semibold)
    - Texto regular: 14px
    - Texto pequeno: 12px (text-gray-500)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave, hover com elevação aumentada
  - Botões primários: Fundo #FF4D4D, texto branco, cantos arredondados
  - Botões secundários: Borda cinza, sem preenchimento
  - Inputs: Borda leve, cantos arredondados, ícones à esquerda
  - Dropdowns: Estilo similar aos inputs, com ícones indicativos
  - Badges: Cantos totalmente arredondados (rounded-full), cores contrastantes

### Responsividade
- **Layout Grid**:
  - Desktop: 3 cards por linha
  - Tablet: 2 cards por linha
  - Mobile: 1 card por linha
- **Cards**: Altura responsiva, mantendo proporções
- **Filtros**: Em telas pequenas, ocupam largura total
- **Drawer de Filtros**: Ocupa tela cheia em dispositivos móveis
- **Modais**: Responsivos, adaptando layout conforme tamanho da tela

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Parceiros centraliza informações de diferentes entidades do sistema:

1. **Parceiros Disponíveis**:
   - Dados básicos dos estabelecimentos parceiros
   - Relacionamentos com categorias, tipos de cozinha e características
   - Informações de localização
   
2. **Vouchers por Parceiro**:
   - Vouchers disponíveis para cada parceiro
   - Contagem de vouchers ativos

3. **Dados para Filtros**:
   - Estados e cidades
   - Categorias de estabelecimentos
   - Tipos de cozinha
   - Características especiais

### Controllers

#### `Company::PartnersController`
Responsável por gerenciar a página de parceiros e os filtros associados.

**Ações:**
- `index`: Renderiza a página principal de parceiros com filtros
- `show`: Renderiza detalhes de um parceiro específico
- `vouchers`: Retorna os vouchers disponíveis para um parceiro específico
- `suggest`: Processa a sugestão de novos parceiros

### Models Relevantes

#### `Partner`
Representa os estabelecimentos parceiros disponíveis no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estabelecimento
- `logo_url`: URL da logo do parceiro
- `cover_image`: Imagem de capa/banner
- `google_infos`: Informações do Google (endereço, coordenadas, etc.)
- `neighborhood`: Bairro
- `city_id`: Referência à cidade
- `active`: Status de ativação
- `created_at`: Data de criação
- `days_of_week`: Dias de funcionamento (JSON)
- `instagram_infos`: Informações do Instagram
- `chairs`: Quantidade de lugares disponíveis
- `terms_accepted`: Status de aceitação dos termos

**Associações:**
- `belongs_to :city`: Relação com a cidade
- `has_many :partner_categories`: Relação com categorias (join table)
- `has_many :categories, through: :partner_categories`: Categorias do parceiro
- `has_many :partner_cuisine_types`: Relação com tipos de cozinha (join table)
- `has_many :cuisine_types, through: :partner_cuisine_types`: Tipos de cozinha do parceiro
- `has_many :partner_characteristics`: Relação com características (join table)
- `has_many :characteristics, through: :partner_characteristics`: Características do parceiro
- `has_many :vouchers`: Vouchers oferecidos pelo parceiro

**Métodos relevantes:**
- `active_vouchers_count`: Retorna a contagem de vouchers ativos
- `format_address`: Formata o endereço completo
- `calculate_average_price`: Calcula o preço médio (representado por símbolos "$")
- `format_operating_hours`: Formata horários de funcionamento
- `logo_image_url`: Retorna URL da logo ou imagem padrão

#### `City`
Representa as cidades onde os parceiros estão localizados.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da cidade
- `state_id`: Referência ao estado

**Associações:**
- `belongs_to :state`: Relação com o estado
- `has_many :partners`: Possui vários parceiros

#### `State`
Representa os estados brasileiros.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estado
- `abbreviation`: Sigla do estado (ex: SP, RJ)

**Associações:**
- `has_many :cities`: Possui várias cidades
- `has_many :partners, through: :cities`: Parceiros no estado (através das cidades)

#### `Category`
Representa categorias de estabelecimentos (Restaurante, Café, etc).

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da categoria

**Associações:**
- `has_many :partner_categories`: Relação com parceiros (join table)
- `has_many :partners, through: :partner_categories`: Parceiros nesta categoria

#### `CuisineType`
Representa tipos de cozinha (Italiana, Japonesa, etc).

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do tipo de cozinha

**Associações:**
- `has_many :partner_cuisine_types`: Relação com parceiros (join table)
- `has_many :partners, through: :partner_cuisine_types`: Parceiros com este tipo de cozinha

#### `Characteristic`
Representa características especiais dos parceiros (Estacionamento, Wi-Fi, etc).

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da característica

**Associações:**
- `has_many :partner_characteristics`: Relação com parceiros (join table)
- `has_many :partners, through: :partner_characteristics`: Parceiros com esta característica

#### `Voucher`
Representa os vouchers oferecidos pelos parceiros.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro
- `name`: Nome/descrição do voucher
- `value`: Valor do voucher
- `min_purchase`: Valor mínimo de compra
- `valid_from`: Data de início da validade
- `valid_to`: Data de término da validade
- `days_of_week`: Dias da semana válidos (JSON)
- `time_range`: Faixa de horário válida (JSON)
- `active`: Status de ativação
- `type`: Tipo de voucher (percentual, valor fixo)

**Associações:**
- `belongs_to :partner`: Relação com o parceiro que oferece o voucher

### Services

#### `PartnerFilterService`
Serviço para gerenciar os filtros de parceiros.

**Métodos:**
- `initialize(params)`: Inicializa o serviço com parâmetros de filtro
- `filter`: Aplica os filtros e retorna os parceiros correspondentes
- `available_states`: Retorna estados disponíveis para filtro
- `available_cities(state_id)`: Retorna cidades disponíveis para um estado
- `available_categories`: Retorna categorias disponíveis
- `available_cuisine_types`: Retorna tipos de cozinha disponíveis
- `available_characteristics`: Retorna características disponíveis

#### `PartnerVoucherService`
Serviço para gerenciar vouchers dos parceiros.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com um parceiro específico
- `active_vouchers`: Retorna vouchers ativos do parceiro
- `active_vouchers_count`: Retorna a contagem de vouchers ativos
- `format_voucher_details(voucher)`: Formata detalhes de um voucher para exibição

#### `PartnerSuggestionService`
Serviço para gerenciar sugestões de novos parceiros.

**Métodos:**
- `initialize(company, params)`: Inicializa o serviço com a empresa e parâmetros da sugestão
- `suggest`: Registra a sugestão de parceiro
- `notify_admin`: Notifica administradores sobre a nova sugestão

### Queries e Scopes

```ruby
# Exemplo conceitual dos scopes e queries
class Partner < ApplicationRecord
  scope :active, -> { where(active: true) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") if name.present? }
  scope :by_state, ->(state_id) { joins(city: :state).where(cities: { states: { id: state_id } }) if state_id.present? }
  scope :by_city, ->(city_id) { where(city_id: city_id) if city_id.present? }
  
  scope :by_category, ->(category_id) {
    joins(:partner_categories).where(partner_categories: { category_id: category_id }) if category_id.present?
  }
  
  scope :by_cuisine_type, ->(cuisine_type_id) {
    joins(:partner_cuisine_types).where(partner_cuisine_types: { cuisine_type_id: cuisine_type_id }) if cuisine_type_id.present?
  }
  
  scope :by_characteristic, ->(characteristic_id) {
    joins(:partner_characteristics).where(partner_characteristics: { characteristic_id: characteristic_id }) if characteristic_id.present?
  }
  
  scope :with_active_vouchers, -> {
    joins(:vouchers)
      .where(vouchers: { active: true })
      .where("vouchers.valid_to >= ?", Date.current)
      .distinct
  }
  
  def active_vouchers
    vouchers.where(active: true).where("valid_to >= ?", Date.current)
  end
  
  def active_vouchers_count
    active_vouchers.count
  end
end
```

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Parceiros
- `app/views/company/partners/index.html.erb`: View principal da página de parceiros

#### Partials
- `app/views/company/partners/_search_filters.html.erb`: Área de busca e filtros
- `app/views/company/partners/_partner_card.html.erb`: Card individual de parceiro
- `app/views/company/partners/_filter_drawer.html.erb`: Drawer lateral de filtros avançados
- `app/views/company/partners/_vouchers_modal.html.erb`: Modal de vouchers do parceiro
- `app/views/company/partners/_suggest_partner_modal.html.erb`: Modal para sugerir novo parceiro

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resources :partners, only: [:index, :show] do
      member do
        get :vouchers
      end
      collection do
        post :suggest
        get :filter_options
      end
    end
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `PartnersHelper`
```ruby
# Exemplo conceitual de helpers
module PartnersHelper
  def format_partner_address(partner)
    return "Localização não informada" unless partner.city
    
    if partner.neighborhood.present?
      "#{partner.neighborhood}, #{partner.city.name}/#{partner.city.state.abbreviation}"
    else
      "#{partner.city.name}/#{partner.city.state.abbreviation}"
    end
  end
  
  def format_price_range(price_level)
    case price_level.to_i
    when 1 then "$"
    when 2 then "$$"
    when 3 then "$$$"
    when 4 then "$$$$"
    else "$$"  # valor padrão
    end
  end
  
  def partner_logo_url(partner)
    if partner.logo_url.present?
      partner.logo_url
    else
      "default-partner-logo.png"
    end
  end
  
  def partner_cover_url(partner)
    if partner.cover_image.present?
      partner.cover_image
    else
      "default-partner-cover.jpg"
    end
  end
  
  def format_voucher_validity(voucher)
    start_date = l(voucher.valid_from.to_date, format: :short)
    end_date = l(voucher.valid_to.to_date, format: :short)
    "#{start_date} até #{end_date}"
  end
end
```

### Stimulus Controllers

#### `filters-controller`
Controller para gerenciar os filtros de parceiros.

**Ações:**
- `connect()`: Inicializa o controller e estado dos filtros
- `toggle()`: Abre/fecha o drawer de filtros
- `updateCities()`: Atualiza lista de cidades baseado no estado selecionado
- `applyFilters(event)`: Aplica filtros selecionados
- `clearFilters()`: Limpa todos os filtros
- `updateActiveFiltersCount()`: Atualiza contador de filtros ativos

#### `search-controller`
Controller para gerenciar a busca por nome.

**Ações:**
- `connect()`: Inicializa o controller
- `search()`: Executa a busca por nome de parceiro
- `debounce()`: Aplica debounce para evitar múltiplas requisições

#### `sort-controller`
Controller para gerenciar a ordenação de parceiros.

**Ações:**
- `connect()`: Inicializa o controller
- `sort(event)`: Aplica ordenação selecionada

#### `vouchers-modal-controller`
Controller para gerenciar o modal de vouchers.

**Ações:**
- `connect()`: Inicializa o controller
- `open(event)`: Abre o modal e carrega vouchers
- `close()`: Fecha o modal

### Turbo Frames e Streams

A página de parceiros utiliza Turbo para atualização dinâmica:

1. **Frame de Lista de Parceiros**:
   ```erb
   <%= turbo_frame_tag "partners-list" do %>
     <!-- Grid de cards de parceiros -->
   <% end %>
   ```

2. **Frame de Opções de Filtro**:
   ```erb
   <%= turbo_frame_tag "filter-options" do %>
     <!-- Opções de filtro dinâmicas (cidades baseadas no estado) -->
   <% end %>
   ```

3. **Stream para Notificações**:
   ```erb
   <%= turbo_stream_from "company_partners_notifications" %>
   ```

### Regras de Negócio

1. **Acesso a Parceiros**
   - Apenas usuários autenticados de empresas ativas podem acessar a página
   - Todos os funcionários da empresa têm acesso à visualização de parceiros
   - Apenas parceiros ativos são exibidos por padrão

2. **Vouchers e Disponibilidade**
   - São exibidos apenas vouchers ativos e dentro do período de validade
   - A contagem de vouchers considera apenas os vouchers ativos e válidos
   - Parceiros sem vouchers ativos são exibidos, mas sem o badge de vouchers

3. **Filtros e Ordenação**
   - Filtros são aplicados de forma cumulativa (combinados com AND)
   - A busca por nome é case-insensitive e parcial (contém)
   - Ordenação "Mais próximos" usa a cidade do escritório da empresa como referência

4. **Sugestão de Parceiros**
   - Qualquer funcionário pode sugerir um novo parceiro
   - Sugestões são revisadas pelos administradores do sistema
   - A empresa recebe notificação quando um parceiro sugerido é aprovado
   - Não há limites de sugestões por empresa

### Permissões e Autorização

1. **Visualização de Parceiros**:
   - Todos os funcionários da empresa podem visualizar parceiros
   - Administradores da empresa podem ver métricas adicionais

2. **Sugestão de Parceiros**:
   - Todos os funcionários podem sugerir parceiros
   - Apenas administradores podem ver histórico completo de sugestões

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso à página de parceiros
   - Aplicação de filtros
   - Carregamento de vouchers
   - Sugestão de parceiros

2. **Testes de Modelo**:
   - Validação das relações entre modelos
   - Funcionamento dos scopes
   - Regras de negócio específicas (ex: contagem de vouchers ativos)

3. **Testes de Sistema**:
   - Fluxo completo de navegação
   - Aplicação de filtros e busca
   - Visualização de vouchers
   - Sugestão de parceiros

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas sem recarregamento completo
- Formulário de filtros e busca com submissão via Turbo

#### Turbo Frames
- Atualização parcial da lista de parceiros quando filtros são aplicados
- Carregamento dinâmico de opções de filtro (ex: cidades baseadas no estado)
- Atualização independente do contador de filtros ativos

#### Turbo Streams
- Atualização em tempo real quando novos parceiros são adicionados (para administradores)
- Notificações quando uma sugestão de parceiro é processada

#### Stimulus
- Gerenciamento interativo de filtros
- Controle dos modais de vouchers e sugestão
- Implementação da busca com debounce
- Toggles de visibilidade (drawer de filtros)

## Considerações de Performance

1. **Carregamento Paginado**:
   - Implementar paginação infinita ou tradicional
   - Carregar inicialmente apenas a primeira página de resultados

2. **Lazy Loading**:
   - Carregar imagens de capa e logos com lazy loading
   - Carregar vouchers apenas quando o modal é aberto

3. **Indexação de Banco de Dados**:
   - Índices para colunas frequentemente usadas em filtros
   - Índices compostos para consultas comuns

4. **Caching**:
   - Cache dos resultados de consultas frequentes
   - Cache de opções de filtro (categorias, tipos de cozinha, etc.)
   - Cache de parceiros por região

## Acessibilidade

1. **Navegação por Teclado**:
   - Todos os elementos interativos navegáveis por teclado
   - Foco visível em elementos interativos
   - Ordem lógica de tabulação

2. **Texto Alternativo**:
   - Alt text para todas as imagens (logos e capas)
   - Descrições para ícones e elementos visuais

3. **Contraste e Legibilidade**:
   - Texto com contraste adequado
   - Tamanhos de fonte legíveis
   - Cores acessíveis para pessoas com daltonismo

4. **Labels e Descrições**:
   - Labels descritivos para todos os controles
   - Instruções claras para interações complexas
   - Feedback visual e textual para ações do usuário
