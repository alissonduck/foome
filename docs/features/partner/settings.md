# Documentação: Configurações do Estabelecimento

## Visão Geral
A página de Configurações do Estabelecimento permite que parceiros da Foome gerenciem todas as informações relacionadas ao seu restaurante ou estabelecimento. Esta é uma página central de gestão onde o parceiro pode configurar desde dados básicos como nome e endereço, até informações mais específicas como categorias, características, tipos de culinária e horários de funcionamento. A página também exibe métricas importantes do Google e Instagram, e permite o upload de imagens do estabelecimento.

## Histórias de Usuário

1. Como parceiro da Foome, quero atualizar dados básicos do meu estabelecimento (nome, CNPJ, endereço) para manter meu perfil atualizado.

2. Como gerente do restaurante, quero configurar categorias e características do estabelecimento para que os clientes encontrem corretamente meu restaurante nas buscas.

3. Como proprietário do estabelecimento, quero definir os tipos de culinária oferecidos para melhorar a precisão das recomendações aos clientes.

4. Como gerente operacional, quero configurar os horários de funcionamento, incluindo tipo de atendimento e preços, para informar corretamente os clientes sobre disponibilidade.

5. Como responsável por marketing, quero conectar o perfil do estabelecimento com Google e Instagram para aproveitar a visibilidade e avaliações nesses canais.

6. Como gestor do estabelecimento, quero fazer upload de logotipo e imagens do local para melhorar a apresentação visual na plataforma.

7. Como parceiro da Foome, quero visualizar métricas de avaliações e engajamento para entender minha reputação online.

## Design & Frontend

### Estrutura da Página
A página de configurações do estabelecimento é estruturada em várias seções lógicas:

1. **Cabeçalho da Página**:
   - Título "Configurações do estabelecimento"
   - Subtítulo explicativo
   - Botões de ação para atualizar informações do Google e Instagram

2. **Layout de Duas Colunas**:
   - Coluna principal (⅔ da largura): Formulários de configuração
   - Coluna lateral (⅓ da largura): Métricas e upload de imagens

3. **Cards de Configuração** (na coluna principal):
   - Dados do estabelecimento
   - Informações do estabelecimento (categorias, características)
   - Operação (horários de funcionamento)

4. **Cards de Métricas e Imagens** (na coluna lateral):
   - Métricas do Google
   - Métricas do Instagram
   - Upload de imagens

### Componentes

#### Cabeçalho da Página
- Título principal "Configurações do estabelecimento" em destaque
- Subtítulo descritivo em tamanho menor e cor mais clara
- Botões de ação para atualizar informações:
  - Botão "Atualizar infos do Google" com ícone
  - Botão "Atualizar infos do Instagram" com ícone

#### Card: Dados do Estabelecimento
- Cabeçalho com ícone de prédio e título
- Campos em layout de grade com 2 colunas:
  - Nome do estabelecimento (campo de texto)
  - CNPJ (campo de texto)
  - Cidade (seletor dropdown)
  - Bairro (campo de texto)
  - Instagram (campo de texto com prefixo "instagram.com/")

#### Card: Informações do Estabelecimento
- Cabeçalho com ícone de loja e título
- Campos organizados verticalmente:
  - Categorias (seletor múltiplo com badges removíveis)
  - Número de lugares (campo numérico)
  - Características (seletor múltiplo com badges removíveis)
  - Tipo de cozinha (seletor múltiplo com badges removíveis)

#### Card: Operação
- Cabeçalho com ícone de relógio e título
- Blocos de horário com:
  - Lista de horários existentes quando não está editando
  - Formulário detalhado quando está editando ou criando
- Para cada horário, exibe:
  - Tipo de atendimento (almoço, jantar, etc.)
  - Dias da semana
  - Horário de início e fim
  - Tipo de serviço (à la carte, rodízio, buffet)
  - Informações de preço
- Botão de adicionar horário no rodapé

#### Card: Métricas do Google
- Exibe duas métricas principais:
  - Nota (rating) em destaque
  - Número de avaliações em destaque
- Valores em formato numérico de fácil leitura

#### Card: Métricas do Instagram
- Exibe duas métricas principais:
  - Número de seguidores
  - Número de posts
- Valores em formato numérico de fácil leitura
- Estado vazio informativo quando não conectado

#### Card: Imagens do Estabelecimento
- Áreas para upload e gerenciamento:
  - Logotipo do estabelecimento
  - Imagem de capa/fachada
- Botões para alterar as imagens
- Pré-visualização das imagens atuais

#### Formulário de Adição/Edição de Horário
- Interface completa para configuração de horário:
  - Tipo de atendimento (dropdown)
  - Horários de início e fim (campos de hora)
  - Seleção de dias da semana (botões de alternância)
  - Tipo de serviço (dropdown)
  - Campos de preço variáveis conforme o tipo de serviço:
    - Preço fixo para buffet livre
    - Preço por quilo para buffet a quilo
    - Preço mínimo e máximo para à la carte
  - Média de refeições servidas (campo numérico)
  - Botões de ação (salvar/cancelar)

#### Botões de Ação Principal
- Botão "Salvar alterações" com ícone de salvar
- Estados de carregamento visíveis durante operações

#### Diálogo de Seleção de Local no Google
- Interface para buscar estabelecimento no Google Places
- Campo de busca com sugestões automáticas
- Listagem de resultados com detalhes
- Botões de confirmação e cancelamento

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e componentes: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Bordas e separadores: #E5E7EB (cinza claro)
  - Fundo destacado: #F3F4F6 (cinza claro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 18px (font-medium)
    - Rótulos de campo: 14px (font-medium)
    - Texto de entrada: 14px (normal)
    - Valores de métricas: 24px (font-semibold)
    - Descrições: 14px (text-muted-foreground)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Inputs: Altura consistente, bordas leves, estados de foco destacados
  - Botões:
    - Primário: Fundo #FF4D4D, texto branco
    - Secundário/Outline: Borda fina, texto da cor primária
  - Badges: Fundo #FF4D4D, texto branco, ícone de remoção
  - Ícones: Tamanho consistente (16-20px), integrados com texto

- **Espaçamento**:
  - Padding interno de cards: 24px
  - Espaçamento entre campos: 16-24px
  - Margens entre cards: 24-32px
  - Padding de botões: horizontal 16px, vertical 8-10px

### Responsividade
- **Desktop**: Layout de duas colunas, formulários em grade
- **Tablet**: Layout de duas colunas com ajustes de tamanho
- **Mobile**:
  - Layout de coluna única (formulários acima, métricas abaixo)
  - Campos de formulário em coluna única
  - Ajustes em tamanhos de fonte e espaçamento

## Backend (Rails)

### Estrutura e Fluxo de Dados

O sistema de configurações do parceiro segue o seguinte fluxo:

1. **Carregamento da Página**:
   - Obtenção dos dados do parceiro atual
   - Carregamento de relacionamentos (categorias, características, tipos de culinária)
   - Obtenção de cidades para seleção
   - Estruturação dos horários de funcionamento
   - Carregamento de métricas e imagens

2. **Salvamento de Dados Básicos**:
   - Validação de entradas
   - Persistência no banco de dados
   - Atualização de relacionamentos

3. **Gerenciamento de Horários**:
   - Adição/edição/exclusão de blocos de horário
   - Formatação para persistência
   - Salvamento em estrutura adequada

4. **Integração com APIs Externas**:
   - Google Places para informações e avaliações
   - Instagram para métricas sociais

5. **Upload de Imagens**:
   - Upload de logo e imagem de capa
   - Processamento de imagens (redimensionamento)
   - Armazenamento com active storage

### Controllers

#### `Partner::SettingsController`
Controlador principal para gerenciar configurações do parceiro.

**Ações:**
- `edit`: Carrega dados para o formulário de configurações
- `update`: Atualiza informações básicas do parceiro
- `update_google_infos`: Atualiza informações obtidas do Google
- `update_instagram_infos`: Atualiza informações do Instagram
- `update_schedules`: Gerencia os horários de funcionamento
- `upload_logo`: Gerencia upload da logo
- `upload_cover`: Gerencia upload da imagem de capa

### Models

#### `Partner`
Modelo central que armazena informações do estabelecimento parceiro.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estabelecimento
- `cnpj`: CNPJ do estabelecimento
- `description`: Descrição geral
- `neighborhood`: Bairro
- `city_id`: Referência à cidade
- `chairs`: Número de lugares
- `google_infos`: JSON com informações do Google
- `instagram_infos`: JSON com informações do Instagram
- `instagram`: Nome de usuário do Instagram
- `days_of_week`: JSON com horários de funcionamento
- `active`: Status de ativação
- `terms_accepted`: Aceitação dos termos
- `onboarding_completed`: Status de conclusão do onboarding

**Associações:**
- `belongs_to :city`: Cidade do estabelecimento
- `has_many :partner_categories`: Relacionamento intermediário com categorias
- `has_many :categories, through: :partner_categories`: Categorias do estabelecimento
- `has_many :partner_characteristics`: Relacionamento intermediário com características
- `has_many :characteristics, through: :partner_characteristics`: Características do estabelecimento
- `has_many :partner_cuisine_types`: Relacionamento intermediário com tipos de culinária
- `has_many :cuisine_types, through: :partner_cuisine_types`: Tipos de culinária do estabelecimento
- `has_many_attached :images`: Imagens do estabelecimento via Active Storage
- `has_one_attached :logo`: Logo do estabelecimento
- `has_one_attached :cover_image`: Imagem de capa do estabelecimento

**Métodos relevantes:**
- `format_schedules`: Formata os horários para exibição
- `google_rating`: Retorna a avaliação do Google
- `google_reviews_count`: Retorna o número de avaliações do Google
- `instagram_followers_count`: Retorna o número de seguidores do Instagram
- `instagram_media_count`: Retorna o número de posts do Instagram

#### `Category`
Modelo que representa categorias de estabelecimentos.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da categoria
- `created_at`: Data de criação

**Associações:**
- `has_many :partner_categories`: Relacionamento intermediário
- `has_many :partners, through: :partner_categories`: Parceiros com esta categoria

#### `Characteristic`
Modelo que representa características de estabelecimentos.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da característica
- `created_at`: Data de criação

**Associações:**
- `has_many :partner_characteristics`: Relacionamento intermediário
- `has_many :partners, through: :partner_characteristics`: Parceiros com esta característica

#### `CuisineType`
Modelo que representa tipos de culinária.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do tipo de culinária
- `created_at`: Data de criação

**Associações:**
- `has_many :partner_cuisine_types`: Relacionamento intermediário
- `has_many :partners, through: :partner_cuisine_types`: Parceiros com este tipo de culinária

#### `City`
Modelo que representa cidades.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da cidade
- `state_id`: Referência ao estado

**Associações:**
- `belongs_to :state`: Estado da cidade
- `has_many :partners`: Parceiros nesta cidade

### Services

#### `Partner::GooglePlacesService`
Serviço para interagir com a API do Google Places.

**Métodos:**
- `search_places(query, location)`: Busca lugares no Google Places
- `fetch_place_details(place_id)`: Obtém detalhes de um lugar específico
- `update_partner_with_google_info(partner, place_info)`: Atualiza o parceiro com informações do Google

#### `Partner::InstagramService`
Serviço para interagir com dados do Instagram.

**Métodos:**
- `fetch_profile(username)`: Busca perfil do Instagram pelo username
- `update_partner_with_instagram_info(partner, instagram_info)`: Atualiza o parceiro com informações do Instagram

#### `Partner::ScheduleService`
Serviço para gerenciar horários de funcionamento.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro
- `format_schedules`: Formata os horários para exibição
- `update_schedules(schedule_params)`: Atualiza os horários do parceiro
- `add_schedule(schedule_params)`: Adiciona um novo horário
- `update_schedule(id, schedule_params)`: Atualiza um horário existente
- `remove_schedule(id)`: Remove um horário
- `format_for_storage(schedules)`: Formata os horários para armazenamento

#### `Partner::CategoryService`
Serviço para gerenciar categorias do parceiro.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro
- `update_categories(category_ids)`: Atualiza as categorias do parceiro

#### `Partner::CharacteristicService`
Serviço para gerenciar características do parceiro.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro
- `update_characteristics(characteristic_ids)`: Atualiza as características do parceiro

#### `Partner::CuisineTypeService`
Serviço para gerenciar tipos de culinária do parceiro.

**Métodos:**
- `initialize(partner)`: Inicializa o serviço com o parceiro
- `update_cuisine_types(cuisine_type_ids)`: Atualiza os tipos de culinária do parceiro

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Páginas
- `app/views/partner/settings/edit.html.erb`: View principal do formulário de configurações

#### Partials
- `app/views/partner/settings/_basic_info.html.erb`: Formulário de informações básicas
- `app/views/partner/settings/_details.html.erb`: Formulário de detalhes (categorias, características)
- `app/views/partner/settings/_schedules.html.erb`: Gerenciamento de horários
- `app/views/partner/settings/_schedule_form.html.erb`: Formulário de criação/edição de horário
- `app/views/partner/settings/_schedule_item.html.erb`: Item individual de horário
- `app/views/partner/settings/_google_metrics.html.erb`: Exibição de métricas do Google
- `app/views/partner/settings/_instagram_metrics.html.erb`: Exibição de métricas do Instagram
- `app/views/partner/settings/_image_uploads.html.erb`: Upload de imagens do estabelecimento
- `app/views/partner/settings/_google_place_dialog.html.erb`: Diálogo de busca no Google Places

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :partner do
    resource :settings, only: [:edit, :update] do
      member do
        patch :update_google_infos
        patch :update_instagram_infos
        patch :update_schedules
        post :upload_logo
        post :upload_cover
        delete :remove_schedule
      end
    end
  end
end
```

### ViewComponents

#### `InfoCardComponent`
Component para renderizar cards de informação com cabeçalho padronizado.

**Props:**
- `title`: Título do card
- `description`: Descrição opcional
- `icon`: Ícone a ser exibido
- `form`: Se o conteúdo é um formulário

#### `MetricsCardComponent`
Component para renderizar cards de métricas.

**Props:**
- `title`: Título do card
- `metrics`: Array de métricas a serem exibidas
- `icon`: Ícone do card

#### `ScheduleBlockComponent`
Component para renderizar um bloco de horário.

**Props:**
- `schedule`: Dados do horário
- `onEdit`: Callback para edição
- `onDelete`: Callback para exclusão

#### `MultiSelectWithBadgesComponent`
Component para seleção múltipla com badges.

**Props:**
- `items`: Itens disponíveis para seleção
- `selectedItems`: Itens selecionados
- `onSelect`: Callback para seleção
- `onRemove`: Callback para remoção

#### `ImageUploadComponent`
Component para upload e visualização de imagens.

**Props:**
- `imageUrl`: URL da imagem atual
- `uploadPath`: Path para upload
- `title`: Título do componente
- `aspectRatio`: Proporção da imagem

### Stimulus Controllers

#### `schedule-form-controller`
Controller para gerenciar o formulário de horários.

**Targets:**
- `form`: Formulário de horário
- `daysButtons`: Botões de dias da semana
- `serviceTypeSelect`: Seletor de tipo de serviço
- `fixedPriceFields`: Campos para preço fixo
- `kiloPriceFields`: Campos para preço por quilo
- `rangePriceFields`: Campos para preço por faixa

**Ações:**
- `connect()`: Inicializa o controller
- `toggleDay(event)`: Alterna seleção de um dia
- `serviceTypeChanged()`: Atualiza campos conforme tipo de serviço
- `submit(event)`: Processa envio do formulário

#### `google-places-controller`
Controller para interação com o modal de Google Places.

**Targets:**
- `input`: Campo de busca
- `results`: Container de resultados
- `modal`: Modal de busca

**Ações:**
- `connect()`: Inicializa o controller
- `search()`: Executa busca
- `selectPlace(event)`: Seleciona um lugar
- `close()`: Fecha o modal

#### `instagram-sync-controller`
Controller para sincronização com Instagram.

**Targets:**
- `usernameInput`: Campo de usuário do Instagram
- `syncButton`: Botão de sincronização

**Ações:**
- `connect()`: Inicializa o controller
- `sync()`: Sincroniza dados do Instagram

#### `image-upload-controller`
Controller para upload de imagens.

**Targets:**
- `input`: Input de arquivo
- `preview`: Área de pré-visualização
- `progress`: Indicador de progresso

**Ações:**
- `connect()`: Inicializa o controller
- `selectFile()`: Abre diálogo de seleção de arquivo
- `fileSelected()`: Processa arquivo selecionado
- `upload()`: Envia arquivo para o servidor

### Turbo Frames e Streams

A página de configurações utiliza Turbo para atualizações dinâmicas:

1. **Frame para Informações Básicas**:
   ```erb
   <%= turbo_frame_tag "partner-basic-info" do %>
     <!-- Conteúdo do formulário de informações básicas -->
   <% end %>
   ```

2. **Frame para Detalhes**:
   ```erb
   <%= turbo_frame_tag "partner-details" do %>
     <!-- Conteúdo do formulário de detalhes -->
   <% end %>
   ```

3. **Frame para Lista de Horários**:
   ```erb
   <%= turbo_frame_tag "partner-schedules" do %>
     <!-- Lista de horários -->
   <% end %>
   ```

4. **Frame para Métricas do Google**:
   ```erb
   <%= turbo_frame_tag "partner-google-metrics" do %>
     <!-- Métricas do Google -->
   <% end %>
   ```

5. **Frame para Métricas do Instagram**:
   ```erb
   <%= turbo_frame_tag "partner-instagram-metrics" do %>
     <!-- Métricas do Instagram -->
   <% end %>
   ```

6. **Frame para Imagens**:
   ```erb
   <%= turbo_frame_tag "partner-images" do %>
     <!-- Upload de imagens -->
   <% end %>
   ```

7. **Stream para Notificações**:
   ```erb
   <%= turbo_stream_from "partner_#{current_partner.id}_notifications" %>
   ```

### Regras de Negócio

1. **Dados do Estabelecimento**
   - Nome e CNPJ são obrigatórios
   - CNPJ deve estar em formato válido
   - Cidade é obrigatória para localização correta
   - Username do Instagram deve ser válido para sincronização

2. **Categorização**
   - Parceiro deve selecionar pelo menos uma categoria
   - Número de lugares deve ser maior que zero
   - Características são opcionais mas recomendadas
   - Tipos de culinária ajudam na descoberta do estabelecimento

3. **Horários de Funcionamento**
   - Cada bloco de horário deve ter pelo menos um dia da semana selecionado
   - Horário de início deve ser anterior ao horário de fim
   - Preços devem ser fornecidos de acordo com o tipo de serviço:
     - Buffet a quilo: valor por quilo
     - Buffet livre: valor fixo
     - À la carte/Rodízio: faixa de preço (min/max)
   - Tipos de atendimento (almoço, jantar, etc.) não podem se sobrepor no mesmo dia

4. **Integração com Google Places**
   - Dados obtidos do Google Places são somente leitura
   - Avaliações são sincronizadas periodicamente
   - Estabelecimento deve existir no Google Maps para sincronização

5. **Integração com Instagram**
   - Nome de usuário do Instagram deve existir para sincronização
   - Métricas são atualizadas sob demanda
   - Conteúdo do Instagram não é importado automaticamente

6. **Upload de Imagens**
   - Logo deve ter proporção quadrada (1:1)
   - Imagem de capa deve ter proporção retangular (16:9 ou similar)
   - Tamanho máximo de arquivo: 5MB
   - Formatos aceitos: JPG, PNG, WebP

### Permissões e Autorização

1. **Acesso às Configurações**:
   - Somente usuários autenticados com papel de parceiro podem acessar
   - Cada parceiro pode editar apenas seu próprio estabelecimento
   - Administradores da plataforma podem editar qualquer estabelecimento

2. **Limitações por Status**:
   - Parceiros inativos podem visualizar mas não editar configurações
   - Certas funcionalidades podem ser limitadas para parceiros em período de teste

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso autorizado/não autorizado
   - Atualização correta de dados
   - Manipulação de uploads

2. **Testes de Model**:
   - Validações corretas
   - Associações entre modelos
   - Formatação de dados complexos (JSON)

3. **Testes de System/Integração**:
   - Fluxo completo de edição de configurações
   - Integração com APIs externas (Google, Instagram)
   - Upload e gerenciamento de imagens

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo ao navegar entre seções
- Envio de formulários com validação client-side e server-side

#### Turbo Frames
- Atualização parcial de seções específicas da página
- Recarregamento isolado de métricas e listas

#### Turbo Streams
- Notificações em tempo real sobre sucesso/erro de operações
- Atualização de listas de horários sem recarregar toda a página

#### Stimulus
- Interatividade dos formulários (dias da semana, tipos de serviço)
- Gerenciamento de uploads de imagens
- Interação com APIs externas

## Considerações de Performance

1. **Otimização de Consultas**:
   - Eager loading de associações (categorias, características, tipos de culinária)
   - Índices adequados para `partner_id` em tabelas de relacionamento
   - Caching de dados externos (Google, Instagram)

2. **Otimização de Assets**:
   - Processamento de imagens no servidor para reduzir tamanho
   - Múltiplas versões de imagens para diferentes usos
   - Lazy loading de imagens na página

3. **Gerenciamento de Estado**:
   - Armazenar estado temporário no cliente para evitar requisições desnecessárias
   - Validações client-side antes de enviar ao servidor
   - Rate limiting para chamadas às APIs externas

## Acessibilidade

1. **Navegação e Interação**:
   - Todos os formulários acessíveis via teclado
   - Ordem de tabulação lógica
   - ARIA labels para componentes complexos

2. **Conteúdo e Legibilidade**:
   - Alto contraste entre texto e fundos
   - Tamanhos de fonte adequados
   - Mensagens de erro claras e acessíveis

3. **Formulários**:
   - Labels explícitos para todos os campos
   - Mensagens de erro associadas aos campos correspondentes
   - Agrupamento lógico de campos relacionados

4. **Imagens**:
   - Textos alternativos para todas as imagens
   - Instruções claras para upload de imagens
   - Feedback não-visual para operações de upload
