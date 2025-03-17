# Documentação: Página de Gerenciamento de Escritórios

## Visão Geral
A página de Gerenciamento de Escritórios permite que administradores da empresa visualizem, criem, editem e excluam os escritórios/filiais da organização. Esta funcionalidade é essencial para empresas com múltiplas unidades físicas, permitindo um gerenciamento centralizado de suas localidades.

## Histórias de Usuário

1. Como administrador da empresa, quero visualizar todos os escritórios cadastrados para ter uma visão geral da distribuição geográfica da organização.
2. Como administrador da empresa, quero adicionar um novo escritório ao sistema para registrar uma nova unidade física da organização.
3. Como administrador da empresa, quero editar as informações de um escritório existente para manter os dados atualizados.
4. Como administrador da empresa, quero excluir um escritório que foi desativado para manter o sistema atualizado.
5. Como gestor de RH, quero visualizar as informações de localização dos escritórios para planejar a distribuição de funcionários.
6. Como usuário do sistema, quero receber feedback claro durante operações de criação, edição ou exclusão para entender o resultado das minhas ações.

## Design & Frontend

### Estrutura da Página
A página é estruturada em duas áreas principais:

1. **Cabeçalho**:
   - Título da página ("Escritórios")
   - Subtítulo descritivo ("Gerencie os escritórios da sua empresa")
   - Botão de ação primária ("Criar escritório")

2. **Grade de Escritórios**:
   - Cards para cada escritório cadastrado
   - Estados alternativos para:
     - Carregamento (esqueletos)
     - Erro (mensagem e botão para tentar novamente)
     - Lista vazia (mensagem e call-to-action)

### Componentes

#### Cabeçalho da Página
- Título principal em fonte grande e negrito
- Subtítulo em tamanho menor e cor mais clara
- Botão "Criar escritório" alinhado à direita, com ícone de mais (+)

#### Card de Escritório
- Layout em cartão elevado com cantos arredondados
- Efeito de hover com elevação aumentada e sombra
- Conteúdo estruturado em:
  - **Cabeçalho do Card**:
    - Nome do escritório em destaque
    - Localização (cidade/estado) com ícone de pin
  - **Corpo do Card**:
    - Badges informativos (número do endereço, CEP)
  - **Rodapé do Card**:
    - Botões de ação (Editar, Excluir)
    - Aparência sutil com destaque no hover

#### Estado de Carregamento
- Esqueletos (skeletons) das áreas principais
- Animação de pulso para indicar carregamento
- Layout similar ao conteúdo real para minimizar saltos de layout

#### Estado de Erro
- Card de erro com borda lateral vermelha
- Ícone de alerta e mensagem descritiva
- Botão para tentar novamente

#### Estado de Lista Vazia
- Card com borda tracejada
- Ícone representativo centralizado (prédio/escritório)
- Texto explicativo e botão de ação para criar o primeiro escritório

#### Modal de Criação/Edição
- Título dinâmico (Novo Escritório/Editar Escritório)
- Formulário com campos para:
  - Nome do escritório
  - Endereço
  - Cidade/Estado
  - CEP
  - Número
  - Complemento
- Botões de ação (Cancelar, Salvar)
- Estado de carregamento durante submissão

#### Diálogo de Confirmação de Exclusão
- Título destacado em vermelho com ícone de lixeira
- Mensagem de confirmação com nome do escritório
- Aviso sobre irreversibilidade da ação
- Botões de ação (Cancelar, Excluir)
- Estado de carregamento durante exclusão

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Erro/Excluir: #EF4444 (vermelho)
  - Badges: #F3F4F6 (cinza claro) com texto #6B7280 (cinza médio)
  - Botão primário: #FF4D4D (vermelho) com texto branco
  - Botão secundário/cancelar: #F3F4F6 (cinza claro) com texto #374151 (cinza escuro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Nome do escritório: 18px (font-medium)
    - Localização: 14px (text-muted-foreground)
    - Badges: 12px
    - Botões: 14px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Badges: Cantos totalmente arredondados (rounded-md)
  - Botões primários: Cantos arredondados, com ícone à esquerda
  - Modais: Cantos arredondados, overlay escurecido
  - Animações: Transições suaves para hover e aparecimento de elementos

### Responsividade
- **Layout Grid**:
  - Desktop: 3 cards por linha
  - Tablet: 2 cards por linha
  - Mobile: 1 card por linha
- **Cards**: Altura fixa nos desktops, ajustável em dispositivos móveis
- **Botões**: Tamanho aumentado em telas touch para facilitar o toque
- **Modais**: Ocupam maior percentual da tela em dispositivos móveis

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Gerenciamento de Escritórios interage principalmente com a entidade Office e suas relações:

1. **Listagem de Escritórios**:
   - Obtenção de todos os escritórios associados à empresa do usuário logado
   - Relacionamentos com cidade e estado para exibição da localização
   
2. **Operações CRUD**:
   - Criação de novos escritórios
   - Edição de escritórios existentes
   - Exclusão de escritórios

### Controllers

#### `Company::OfficesController`
Responsável por gerenciar operações relacionadas aos escritórios da empresa.

**Ações:**
- `index`: Renderiza a página com a lista de escritórios
- `new`: Renderiza formulário para criação de novo escritório
- `create`: Processa a criação de um novo escritório
- `edit`: Renderiza formulário para edição de escritório existente
- `update`: Processa a atualização de um escritório
- `destroy`: Processa a exclusão de um escritório

### Models Relevantes

#### `Office`
Representa um escritório/filial da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `company_id`: Referência à empresa
- `name`: Nome do escritório
- `address`: Endereço completo
- `city_id`: Referência à cidade
- `zip_code`: CEP
- `number`: Número do endereço
- `complement`: Complemento do endereço
- `google_infos`: Informações adicionais do Google (JSON)
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Empresa à qual o escritório pertence
- `belongs_to :city`: Cidade onde o escritório está localizado
- `has_many :employees`: Funcionários alocados neste escritório

**Validações:**
- Presença: `name`, `company_id`, `city_id`
- Formato: `zip_code` (padrão brasileiro de CEP)
- Numérico: `number` (quando presente)

#### `Company`
Representa uma empresa cadastrada no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa
- `active`: Status de ativação
- `max_users`: Número máximo de usuários permitidos

**Associações:**
- `has_many :offices`: Escritórios da empresa
- `has_many :employees`: Funcionários da empresa

#### `City`
Representa uma cidade onde o escritório está localizado.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da cidade
- `state_id`: Referência ao estado

**Associações:**
- `belongs_to :state`: Estado ao qual a cidade pertence
- `has_many :offices`: Escritórios localizados na cidade

#### `State`
Representa um estado brasileiro.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estado
- `abbreviation`: Sigla do estado (ex: SP, RJ)

**Associações:**
- `has_many :cities`: Cidades do estado
- `has_many :offices, through: :cities`: Escritórios no estado (através das cidades)

### Services

#### `OfficeService`
Serviço para gerenciar operações relacionadas aos escritórios.

**Métodos:**
- `initialize(company)`: Inicializa o serviço com uma empresa específica
- `list`: Retorna todos os escritórios ativos da empresa
- `find(id)`: Encontra um escritório específico
- `create(params)`: Cria um novo escritório
- `update(id, params)`: Atualiza um escritório existente
- `destroy(id)`: Marca um escritório como inativo ou o remove

#### `GeocodingService`
Serviço opcional para obter coordenadas geográficas e informações adicionais para endereços.

**Métodos:**
- `initialize(address, city, state, zip_code)`: Inicializa o serviço com dados de endereço
- `geocode`: Realiza a geocodificação e retorna coordenadas e informações adicionais

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Escritórios
- `app/views/company/offices/index.html.erb`: View principal da página de escritórios

#### Partials
- `app/views/company/offices/_office_card.html.erb`: Card individual de escritório
- `app/views/company/offices/_form.html.erb`: Formulário para criação/edição de escritório
- `app/views/company/offices/_loading_state.html.erb`: Estado de carregamento
- `app/views/company/offices/_empty_state.html.erb`: Estado para quando não há escritórios
- `app/views/company/offices/_error_state.html.erb`: Estado de erro

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resources :offices
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `OfficesHelper`
```ruby
# Exemplo conceitual de helpers
module OfficesHelper
  def format_address(office)
    return "Endereço não disponível" if office.nil? || office.address.blank?
    
    parts = []
    parts << office.address
    parts << "#{office.number}" if office.number.present?
    parts << office.complement if office.complement.present?
    parts << "#{office.city.name}/#{office.city.state.abbreviation}" if office.city&.state
    
    parts.join(", ")
  end
  
  def format_zip_code(zip_code)
    return "" if zip_code.blank?
    zip_code.to_s.gsub(/^(\d{5})(\d{3})$/, "\\1-\\2")
  end
  
  def office_badge(icon_name, text)
    tag.div class: "inline-flex items-center px-2.5 py-1 rounded-md bg-muted text-xs" do
      concat(inline_svg_tag("icons/#{icon_name}.svg", class: "h-3 w-3 mr-1 text-muted-foreground"))
      concat(tag.span(text))
    end
  end
end
```

### Stimulus Controllers

#### `office-form-controller`
Controller para gerenciar o formulário de criação/edição de escritório.

**Ações:**
- `connect()`: Inicializa o controller
- `submit(event)`: Gerencia a submissão do formulário
- `toggleLoading(isLoading)`: Controla o estado de carregamento
- `setupCitySelect()`: Configura o select dinâmico de cidades baseado no estado selecionado
- `validateForm()`: Valida o formulário antes da submissão

#### `office-card-controller`
Controller para gerenciar as interações nos cards de escritório.

**Ações:**
- `connect()`: Inicializa o controller
- `edit()`: Abre o modal de edição
- `confirmDelete()`: Abre o diálogo de confirmação para exclusão

#### `delete-confirmation-controller`
Controller para gerenciar o diálogo de confirmação de exclusão.

**Ações:**
- `connect()`: Inicializa o controller
- `confirm()`: Confirma e processa a exclusão
- `cancel()`: Cancela a operação de exclusão
- `toggleLoading(isLoading)`: Controla o estado de carregamento durante a exclusão

### Turbo Frames e Streams

A página de escritórios utiliza Turbo para atualizações dinâmicas:

1. **Frame de Lista de Escritórios**:
   ```erb
   <%= turbo_frame_tag "offices-list" do %>
     <!-- Grid de cards de escritórios -->
   <% end %>
   ```

2. **Frame de Formulário**:
   ```erb
   <%= turbo_frame_tag "office-form" do %>
     <!-- Formulário de escritório -->
   <% end %>
   ```

3. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "company_offices_#{current_company.id}" %>
   ```

### Regras de Negócio

1. **Permissões de Acesso**
   - Apenas administradores da empresa podem criar, editar ou excluir escritórios
   - Outros funcionários podem visualizar os escritórios, mas não modificá-los

2. **Validação de Dados**
   - O nome do escritório não pode estar em branco
   - CEP deve estar no formato válido brasileiro
   - A cidade e estado devem ser selecionados a partir de opções válidas

3. **Restrições de Exclusão**
   - Um escritório não pode ser excluído se houver funcionários associados a ele
   - O escritório principal (matriz) pode ter restrições adicionais para exclusão

4. **Geocodificação (opcional)**
   - Ao criar ou atualizar um escritório, o sistema pode obter automaticamente coordenadas geográficas
   - Estas coordenadas podem ser usadas para cálculos de distância ou visualização em mapas

5. **Limitações por Plano**
   - Pode haver um limite máximo de escritórios dependendo do plano da empresa
   - O sistema deve validar esse limite antes de permitir a criação de novos escritórios

### Permissões e Autorização

1. **Visualização de Escritórios**:
   - Todos os funcionários da empresa podem visualizar a lista de escritórios
   - Informações detalhadas podem ser restritas a administradores

2. **Criação e Edição**:
   - Apenas administradores da empresa podem criar e editar escritórios
   - Alguns campos sensíveis podem ser restritos a super-administradores

3. **Exclusão**:
   - Apenas administradores da empresa podem excluir escritórios
   - Verificações adicionais de segurança para prevenir exclusões acidentais

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso à página de escritórios (autenticação e autorização)
   - Criação, edição e exclusão de escritórios
   - Tratamento adequado de erros e validações

2. **Testes de Modelo**:
   - Validações do modelo Office
   - Relacionamentos com outras entidades (Company, City)
   - Callbacks e métodos específicos

3. **Testes de Sistema**:
   - Fluxo completo de criação de escritório
   - Edição de escritório existente
   - Tentativa de exclusão de escritório com funcionários
   - Visualização responsiva em diferentes tamanhos de tela

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas sem recarregamento completo
- Formulários com submissão sem refresh

#### Turbo Frames
- Atualização parcial da lista de escritórios quando um novo escritório é criado
- Formulário de criação/edição em modal sem recarregar a página
- Estado de carregamento durante operações assíncronas

#### Turbo Streams
- Notificações em tempo real quando escritórios são adicionados, editados ou removidos
- Atualização automática para outros administradores visualizando a mesma página

#### Stimulus
- Gerenciamento interativo do formulário
- Validação de dados do lado do cliente
- Interações de UI como tooltips, confirmações e feedbacks visuais

## Considerações de Performance

1. **Carregamento Paginado**:
   - Para empresas com muitos escritórios, implementar paginação ou scroll infinito
   - Exibir inicialmente apenas os escritórios mais recentes ou relevantes

2. **Optimistic UI**:
   - Implementar atualizações otimistas para operações comuns
   - Atualizar a UI antes da confirmação do servidor para feedback imediato

3. **Caching**:
   - Cache de listas de cidades por estado para reduzir consultas
   - Cache de escritórios para carregamento rápido

## Acessibilidade

1. **Navegação por Teclado**:
   - Todos os componentes interativos navegáveis via teclado
   - Ordem lógica de tabulação
   - Atalhos para ações comuns

2. **Leitores de Tela**:
   - Textos alternativos para ícones
   - Descrições adequadas para botões e ações
   - Anúncios para mudanças dinâmicas de conteúdo

3. **Contraste e Legibilidade**:
   - Texto com contraste adequado com o fundo
   - Tamanhos de fonte legíveis
   - Cores acessíveis para pessoas com daltonismo

4. **Mensagens de Status**:
   - Feedback claro para ações realizadas
   - Mensagens de erro descritivas e associadas aos campos correspondentes
   - Notificações de sucesso após operações concluídas

## Integração com Outras Funcionalidades

1. **Funcionários**:
   - Os escritórios são associados a funcionários
   - Ao visualizar um funcionário, seu escritório deve ser exibido
   - Ao transferir um funcionário, ele pode mudar de escritório

2. **Times/Equipes**:
   - Times podem estar associados a escritórios específicos
   - Filtros de equipes podem considerar o escritório

3. **Relatórios**:
   - Relatórios podem ser filtrados por escritório
   - Métricas e indicadores podem ser agregados por localidade
