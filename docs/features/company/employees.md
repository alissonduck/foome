# Documentação: Página de Gerenciamento de Funcionários

## Visão Geral
A página de Gerenciamento de Funcionários permite que administradores e gestores de RH visualizem, criem, editem e gerenciem os funcionários da empresa. Esta funcionalidade é essencial para o controle organizacional, oferecendo uma visão centralizada de todos os colaboradores, suas equipes, escritórios e status.

## Histórias de Usuário

1. Como administrador da empresa, quero visualizar todos os funcionários cadastrados para ter uma visão geral do quadro de pessoal.
2. Como gestor de RH, quero adicionar novos funcionários ao sistema para registrar contratações.
3. Como gerente, quero filtrar funcionários por equipe e status para visualizar apenas os colaboradores relevantes para minha análise.
4. Como administrador, quero editar os dados de um funcionário para manter suas informações atualizadas.
5. Como gestor de RH, quero ativar ou desativar funcionários para refletir seu status atual na empresa.
6. Como administrador, quero pesquisar funcionários pelo nome para encontrá-los rapidamente.
7. Como gerente, quero visualizar a distribuição de funcionários por escritório para compreender a alocação física da equipe.
8. Como administrador, quero visualizar os gerentes e suas equipes para entender a estrutura hierárquica da empresa.

## Design & Frontend

### Estrutura da Página
A página é estruturada em quatro áreas principais:

1. **Cabeçalho**:
   - Título da página ("Funcionários")
   - Subtítulo descritivo ("Gerencie os funcionários da sua empresa")
   - Botões de ação (Filtrar, Criar funcionário)

2. **Cards de Estatísticas**:
   - Card de total de funcionários
   - Card de funcionários ativos
   - Card de escritórios

3. **Área de Busca e Filtros**:
   - Campo de busca por nome
   - Drawer de filtros avançados

4. **Tabela de Funcionários**:
   - Listagem com colunas ordenáveis
   - Paginação
   - Versão responsiva para dispositivos móveis

### Componentes

#### Cabeçalho da Página
- Título principal em fonte grande e negrito
- Subtítulo em tamanho menor e cor mais clara
- Botões de ação alinhados à direita (Filtrar, Criar funcionário)
- Contador de filtros ativos no botão de filtros

#### Cards de Estatísticas
- Três cards em layout de grade
- Cada card contém:
  - Ícone representativo
  - Título descritivo
  - Valor numérico em destaque
  - Texto explicativo secundário
- Layout responsivo (3 colunas em desktop, empilhados em mobile)

#### Área de Busca
- Campo de busca com ícone de lupa
- Feedback visual durante a digitação
- Busca com debounce para evitar requisições excessivas

#### Tabela de Funcionários
- Cabeçalho com colunas fixas:
  - Nome
  - Matrícula
  - Cargo
  - Equipe
  - Gestor
  - Escritório
  - Status
  - Ações
- Linhas com dados dos funcionários
- Estado de carregamento (spinner centralizado)
- Estado vazio (mensagem informativa)
- Menu de ações por funcionário (Editar, Ativar/Desativar)

#### Versão Mobile (Cards)
- Cards individuais para cada funcionário
- Layout em accordion para economizar espaço
- Exibição compacta das informações essenciais
- Mesmas ações disponíveis na versão desktop

#### Paginação
- Controles para navegar entre páginas
- Indicação de página atual
- Seletor de itens por página
- Contagem de itens e páginas
- Versão simplificada para mobile

#### Drawer de Filtros
- Painel lateral deslizante
- Filtros por:
  - Status (Ativos/Inativos)
  - Equipe
  - Gerente
  - Escritório
- Botões para aplicar filtros ou limpar todos

#### Modal de Criação/Edição
- Título dinâmico (Novo Funcionário/Editar Funcionário)
- Formulário com campos para:
  - Nome
  - Matrícula
  - Email
  - Cargo
  - Equipe
  - Gestor
  - Escritório
  - Data de nascimento
  - Status (ativo/inativo)
- Validação de campos
- Botões de ação (Cancelar, Salvar)
- Estado de carregamento durante submissão

#### Diálogo de Confirmação de Exclusão
- Mensagem de confirmação
- Nome do funcionário a ser excluído
- Aviso sobre irreversibilidade da ação
- Botões de ação (Cancelar, Excluir)

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e tabela: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Badges de status: 
    - Ativo: #FF4D4D (vermelho primário) com texto branco
    - Inativo: Transparente com borda cinza e texto cinza
  - Botão primário: #FF4D4D (vermelho) com texto branco
  - Botão secundário/cancelar: #F3F4F6 (cinza claro) com texto #374151 (cinza escuro)
  - Botão destrutivo: #EF4444 (vermelho) com texto branco

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Título de card: 14px (font-medium)
    - Valor de estatística: 24px (font-bold)
    - Cabeçalho de tabela: 12px (font-medium text-muted-foreground)
    - Conteúdo de tabela: 14px
    - Botões: 14px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Tabela: Cabeçalho com fundo mais claro, linhas zebradas opcional
  - Badges: Cantos totalmente arredondados (rounded-full)
  - Botões primários: Cantos arredondados, com ícone à esquerda
  - Inputs: Borda leve, cantos arredondados, foco destacado
  - Modais: Cantos arredondados, overlay escurecido
  - Paginação: Botões para página anterior/próxima, página atual destacada

### Responsividade
- **Layout**:
  - Desktop: Tabela completa, 3 cards de estatísticas em linha
  - Tablet: Tabela completa ou reduzida, cards de estatísticas podem reajustar para 2 colunas
  - Mobile: Cards em vez de tabela, estatísticas empilhadas
- **Filtros**: Drawer de tela cheia em mobile
- **Paginação**: Simplificada em mobile (apenas anterior/próximo)
- **Ações**: Consolidadas em menu dropdown em viewport menor

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Gerenciamento de Funcionários interage com várias entidades do sistema:

1. **Listagem de Funcionários**:
   - Obtenção de funcionários com paginação e filtragem
   - Relacionamentos com equipe, gestor e escritório
   
2. **Operações CRUD**:
   - Criação de novos funcionários
   - Edição de funcionários existentes
   - Ativação/desativação de funcionários
   - Exclusão de funcionários

3. **Estatísticas**:
   - Contagem de funcionários total
   - Contagem de funcionários ativos
   - Contagem de escritórios

### Controllers

#### `Company::EmployeesController`
Responsável por gerenciar operações relacionadas aos funcionários da empresa.

**Ações:**
- `index`: Renderiza a página com a lista de funcionários, aplicando filtros e paginação
- `new`: Renderiza formulário para criação de novo funcionário
- `create`: Processa a criação de um novo funcionário
- `edit`: Renderiza formulário para edição de funcionário existente
- `update`: Processa a atualização de um funcionário
- `destroy`: Processa a exclusão de um funcionário
- `toggle_status`: Alterna o status do funcionário entre ativo e inativo

### Models Relevantes

#### `Employee`
Representa um funcionário da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `user_id`: Referência ao usuário do sistema (para login)
- `company_id`: Referência à empresa
- `name`: Nome do funcionário
- `email`: Email do funcionário
- `internal_id`: Matrícula/ID interno da empresa
- `role_name`: Cargo/função
- `birth_date`: Data de nascimento
- `team_id`: Referência à equipe
- `office_id`: Referência ao escritório
- `manager_id`: Referência ao gestor (outro funcionário)
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Empresa à qual o funcionário pertence
- `belongs_to :user, optional: true`: Usuário do sistema (para login)
- `belongs_to :team, optional: true`: Equipe do funcionário
- `belongs_to :office, optional: true`: Escritório onde o funcionário trabalha
- `belongs_to :manager, class_name: 'Employee', optional: true`: Gestor do funcionário
- `has_many :subordinates, class_name: 'Employee', foreign_key: 'manager_id'`: Funcionários subordinados

**Validações:**
- Presença: `name`, `company_id`
- Unicidade: `internal_id` (escopo da empresa), `email` (escopo da empresa)
- Formato: `email` (padrão de email)

#### `Team`
Representa uma equipe/departamento da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `company_id`: Referência à empresa
- `name`: Nome da equipe
- `manager_id`: Referência ao gestor da equipe
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Empresa à qual a equipe pertence
- `belongs_to :manager, class_name: 'Employee', optional: true`: Gestor da equipe
- `has_many :employees`: Funcionários da equipe

#### `Office`
Representa um escritório/filial da empresa.

**Atributos relevantes:**
- `id`: Identificador único
- `company_id`: Referência à empresa
- `name`: Nome do escritório
- `address`: Endereço
- `city_id`: Referência à cidade
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Empresa à qual o escritório pertence
- `belongs_to :city`: Cidade onde o escritório está localizado
- `has_many :employees`: Funcionários que trabalham neste escritório

#### `Company`
Representa uma empresa cadastrada no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa
- `max_users`: Número máximo de usuários permitidos
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `has_many :employees`: Funcionários da empresa
- `has_many :teams`: Equipes da empresa
- `has_many :offices`: Escritórios da empresa

### Services

#### `EmployeeService`
Serviço para gerenciar operações relacionadas aos funcionários.

**Métodos:**
- `initialize(company)`: Inicializa o serviço com uma empresa específica
- `list(params)`: Retorna funcionários paginados e filtrados
- `find(id)`: Encontra um funcionário específico
- `create(params)`: Cria um novo funcionário
- `update(id, params)`: Atualiza um funcionário existente
- `toggle_status(id)`: Alterna o status de um funcionário
- `destroy(id)`: Exclui um funcionário
- `available_managers`: Retorna lista de funcionários que podem ser gerentes
- `statistics`: Retorna estatísticas sobre funcionários da empresa

#### `UserCreationService`
Serviço para gerenciar a criação de usuários associados aos funcionários.

**Métodos:**
- `initialize(employee_params)`: Inicializa o serviço com os parâmetros do funcionário
- `create_associated_user`: Cria um usuário do sistema para o funcionário
- `send_welcome_email`: Envia email de boas-vindas com instruções de acesso

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Funcionários
- `app/views/company/employees/index.html.erb`: View principal da página de funcionários

#### Partials
- `app/views/company/employees/_statistics_cards.html.erb`: Cards de estatísticas
- `app/views/company/employees/_search_bar.html.erb`: Barra de busca
- `app/views/company/employees/_employees_table.html.erb`: Tabela de funcionários
- `app/views/company/employees/_employees_mobile_cards.html.erb`: Cards para visualização mobile
- `app/views/company/employees/_filter_drawer.html.erb`: Drawer de filtros avançados
- `app/views/company/employees/_form.html.erb`: Formulário para criação/edição
- `app/views/company/employees/_pagination.html.erb`: Controles de paginação

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resources :employees do
      member do
        patch :toggle_status
      end
      collection do
        get :filter_options
      end
    end
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `EmployeesHelper`
```ruby
# Exemplo conceitual de helpers
module EmployeesHelper
  def employee_status_badge(active)
    if active
      tag.span("Ativo", class: "badge badge-active")
    else
      tag.span("Inativo", class: "badge badge-inactive")
    end
  end
  
  def format_birth_date(date)
    return "Não informada" if date.blank?
    l(date, format: :long)
  end
  
  def manager_name(employee)
    employee.manager&.name || "—"
  end
  
  def team_name(employee)
    employee.team&.name || "Sem equipe"
  end
  
  def office_name(employee)
    employee.office&.name || "Sem escritório"
  end
  
  def active_filters_count(filters)
    count = 0
    count += 1 if filters[:active].present?
    count += 1 if filters[:team_id].present?
    count += 1 if filters[:manager_id].present?
    count += 1 if filters[:office_id].present?
    count
  end
end
```

### Stimulus Controllers

#### `employee-form-controller`
Controller para gerenciar o formulário de criação/edição de funcionário.

**Ações:**
- `connect()`: Inicializa o controller
- `submit(event)`: Gerencia a submissão do formulário
- `toggleLoading(isLoading)`: Controla o estado de carregamento
- `validateForm()`: Valida o formulário antes da submissão

#### `employee-filter-controller`
Controller para gerenciar os filtros de funcionários.

**Ações:**
- `connect()`: Inicializa o controller e carrega estado dos filtros
- `toggleDrawer()`: Abre/fecha o drawer de filtros
- `applyFilters(event)`: Aplica filtros selecionados
- `clearFilters()`: Limpa todos os filtros
- `updateActiveFiltersCount()`: Atualiza contador de filtros ativos

#### `employee-search-controller`
Controller para gerenciar a busca por nome de funcionário.

**Ações:**
- `connect()`: Inicializa o controller
- `search(event)`: Realiza a busca com debounce
- `debounce(callback, wait)`: Implementa debounce para evitar buscas excessivas

#### `employee-table-controller`
Controller para gerenciar interações na tabela de funcionários.

**Ações:**
- `connect()`: Inicializa o controller
- `edit(event)`: Abre o modal de edição para o funcionário clicado
- `toggleStatus(event)`: Alterna o status do funcionário
- `confirmDelete(event)`: Abre o diálogo de confirmação para exclusão

#### `deletion-confirmation-controller`
Controller para gerenciar o diálogo de confirmação de exclusão.

**Ações:**
- `connect()`: Inicializa o controller
- `confirm()`: Confirma a exclusão
- `cancel()`: Cancela a operação
- `toggleLoading(isLoading)`: Controla o estado de carregamento durante a exclusão

### Turbo Frames e Streams

A página de funcionários utiliza Turbo para atualizações dinâmicas:

1. **Frame da Tabela de Funcionários**:
   ```erb
   <%= turbo_frame_tag "employees-list" do %>
     <!-- Tabela ou cards de funcionários -->
   <% end %>
   ```

2. **Frame de Estatísticas**:
   ```erb
   <%= turbo_frame_tag "employee-statistics" do %>
     <!-- Cards de estatísticas -->
   <% end %>
   ```

3. **Frame de Formulário**:
   ```erb
   <%= turbo_frame_tag "employee-form" do %>
     <!-- Formulário de criação/edição -->
   <% end %>
   ```

4. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "company_employees_#{current_company.id}" %>
   ```

### Regras de Negócio

1. **Permissões de Acesso**
   - Administradores da empresa têm acesso total a todos os funcionários
   - Gerentes podem visualizar e gerenciar apenas seus subordinados diretos
   - Funcionários regulares podem ver a lista geral, mas com informações limitadas

2. **Limitações de Usuários**
   - O número de funcionários ativos não pode exceder o limite `max_users` da empresa
   - Tentativas de exceder esse limite devem resultar em erro claro

3. **Hierarquia**
   - Um funcionário não pode ser gerente de si mesmo
   - Um funcionário não pode ser gerente de seu próprio gerente (evitar ciclos)
   - Apenas funcionários ativos podem ser designados como gerentes

4. **Validação de Dados**
   - Email deve ser único dentro da empresa
   - Matrícula (internal_id) deve ser única dentro da empresa
   - Data de nascimento deve ser válida e não pode ser uma data futura

5. **Integração com Usuários**
   - Um funcionário pode ter um usuário associado para acesso ao sistema
   - A desativação de um funcionário deve bloquear o acesso de seu usuário, mas não excluí-lo
   - A exclusão de um funcionário desativa seu usuário associado

6. **Exclusão e Desativação**
   - Funcionários com subordinados não podem ser excluídos, apenas desativados
   - Funcionários que são gerentes de equipes não podem ser excluídos, apenas desativados
   - A desativação é preferível à exclusão para manter histórico

### Permissões e Autorização

1. **Visualização de Funcionários**:
   - Administradores podem ver todos os funcionários e todas as informações
   - Gerentes podem ver seus subordinados diretos com detalhes completos
   - Funcionários regulares podem ver lista limitada de informações

2. **Gerenciamento de Funcionários**:
   - Apenas administradores e RH autorizado podem criar novos funcionários
   - Apenas administradores e RH autorizado podem editar dados críticos (cargo, salário)
   - Gerentes podem atualizar informações básicas de seus subordinados

3. **Ativação/Desativação**:
   - Apenas administradores podem ativar/desativar funcionários
   - Gerentes podem solicitar desativação, mas não executá-la diretamente

4. **Exclusão**:
   - Exclusão restrita a administradores com permissões especiais
   - Confirmação obrigatória com digitação do nome do funcionário para exclusões

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Listagem de funcionários com diferentes filtros
   - Criação, edição e exclusão de funcionários
   - Tentativas de ações não autorizadas

2. **Testes de Modelo**:
   - Validações do modelo Employee
   - Restrições de hierarquia
   - Comportamento com usuários associados

3. **Testes de Sistema**:
   - Fluxo completo de criação de funcionário
   - Filtragem e paginação
   - Responsividade em diferentes tamanhos de tela
   - Interações de usuário com AJAX e Turbo

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas sem recarregamento completo
- Formulários com submissão sem refresh

#### Turbo Frames
- Atualizações parciais da tabela ao aplicar filtros
- Formulário de criação/edição em modal sem recarregar a página
- Estatísticas atualizadas automaticamente após operações

#### Turbo Streams
- Atualização em tempo real quando funcionários são adicionados, editados ou removidos
- Atualizações incrementais de contadores e estatísticas
- Notificações para múltiplos usuários acessando a mesma página

#### Stimulus
- Gerenciamento interativo de filtros
- Busca com debounce
- Validação de formulário do lado do cliente
- Interações de UI como confirmações e feedbacks visuais

## Considerações de Performance

1. **Paginação Eficiente**:
   - Implementar paginação no banco de dados, não apenas na UI
   - Utilizar técnicas como Keyset Pagination para grandes conjuntos de dados

2. **Carregamento Seletivo**:
   - Carregar apenas dados necessários para a visualização atual
   - Utilizar includes para evitar N+1 queries

3. **Caching**:
   - Cache de contagens e estatísticas
   - Cache de opções de filtro (equipes, escritórios)
   - Invalidação seletiva de cache quando necessário

4. **Indexação de Banco de Dados**:
   - Índices para campos frequentemente filtrados (team_id, office_id, active)
   - Índices compostos para consultas comuns

## Acessibilidade

1. **Navegação por Teclado**:
   - Tabela e controles navegáveis por teclado
   - Focus trap em modais
   - Skip links para áreas principais

2. **Leitores de Tela**:
   - Tabela com cabeçalhos adequados
   - Descrições para ícones e elementos visuais
   - Textos alternativos para estados e ações

3. **Contraste e Legibilidade**:
   - Texto com contraste adequado
   - Tamanhos de fonte legíveis
   - Cores de estado (ativo/inativo) distinguíveis por cor e formato

4. **Mensagens de Status**:
   - Feedback não apenas visual, mas também via ARIA
   - Indicação clara de erros em formulários
   - Confirmações de ação bem-sucedida
