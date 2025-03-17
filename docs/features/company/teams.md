# Documentação: Página de Gerenciamento de Equipes

## Visão Geral
A página de Gerenciamento de Equipes permite que administradores e gestores visualizem, criem, editem e excluam as equipes da empresa. Esta funcionalidade oferece uma visão centralizada da estrutura organizacional, permitindo acompanhar a hierarquia de gestão e a distribuição de funcionários em diferentes equipes.

## Histórias de Usuário

1. Como administrador da empresa, quero visualizar todas as equipes cadastradas para ter uma visão geral da estrutura organizacional.
2. Como gestor de RH, quero criar novas equipes para organizar os funcionários de acordo com a estrutura da empresa.
3. Como gestor, quero filtrar equipes por nome, gestor ou status para encontrar facilmente as informações que preciso.
4. Como administrador, quero editar os dados de uma equipe para mantê-la atualizada conforme as mudanças organizacionais.
5. Como gestor de RH, quero ativar ou desativar equipes de acordo com reestruturações na empresa.
6. Como administrador, quero ver estatísticas sobre minhas equipes para compreender a distribuição de funcionários.
7. Como gestor, quero ver quais funcionários pertencem a cada equipe para gerenciar recursos humanos.
8. Como usuário, quero visualizar as equipes em formato adaptado quando estiver usando um dispositivo móvel.

## Design & Frontend

### Estrutura da Página
A página é estruturada em quatro áreas principais:

1. **Cabeçalho**:
   - Título da página ("Equipes")
   - Subtítulo descritivo ("Gerencie as equipes da sua empresa")
   - Botões de ação (Filtrar, Criar equipe)

2. **Cards de Estatísticas**:
   - Card de total de equipes
   - Card de equipes ativas
   - Card de gestores

3. **Área de Busca e Filtros**:
   - Campo de busca por nome da equipe
   - Drawer de filtros avançados

4. **Tabela de Equipes**:
   - Listagem com colunas informativas
   - Paginação
   - Versão responsiva para dispositivos móveis (accordion)

### Componentes

#### Cabeçalho da Página
- Título principal em fonte grande e negrito
- Subtítulo em tamanho menor e cor mais clara
- Botões de ação alinhados à direita (Filtrar, Criar equipe)
- Contador de filtros ativos no botão de filtros (badge numérico)

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
- Busca em tempo real pelo nome da equipe

#### Tabela de Equipes
- Cabeçalho com colunas fixas:
  - Nome
  - Gestor
  - Funcionários (contagem)
  - Status
  - Data de criação
  - Última atualização
  - Ações
- Linhas com dados das equipes
- Estado de carregamento (spinner centralizado)
- Estado vazio (mensagem informativa)
- Menu de ações por equipe (Editar, Excluir)
- Badges para indicar status (Ativa/Inativa)

#### Versão Mobile (Accordion)
- Items de accordion para cada equipe
- Cabeçalho do item mostra nome e gestor
- Conteúdo expandido mostra detalhes adicionais
- Botões de ação (Editar, Excluir) no rodapé de cada item

#### Paginação
- Controles para navegar entre páginas
- Indicação de página atual
- Seletor de itens por página
- Contagem de itens e páginas
- Versão simplificada para mobile

#### Drawer de Filtros
- Painel lateral deslizante
- Filtros por:
  - Gestor (select com todos os gestores)
  - Status (Ativas/Inativas)
- Botões para aplicar filtros ou limpar todos

#### Modal de Criação/Edição
- Título dinâmico (Nova Equipe/Editar Equipe)
- Formulário com campos para:
  - Nome da equipe
  - Gestor (select com funcionários elegíveis)
  - Status (ativo/inativo)
- Validação de campos
- Botões de ação (Cancelar, Salvar)
- Estado de carregamento durante submissão

#### Diálogo de Confirmação de Exclusão
- Título destacado em vermelho
- Mensagem de confirmação com nome da equipe
- Aviso sobre irreversibilidade da ação
- Botões de ação (Cancelar, Excluir)
- Estado de carregamento durante exclusão

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards e tabela: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Badges de status: 
    - Ativa: Badge verde claro (#ECFDF5) com texto verde (#047857)
    - Inativa: Badge vermelho claro (#FEF2F2) com texto vermelho (#B91C1C)
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
  - Badges: Cantos arredondados (rounded-md)
  - Botões primários: Cantos arredondados, com ícone à esquerda
  - Inputs e selects: Borda leve, cantos arredondados, foco destacado
  - Modais: Cantos arredondados, overlay escurecido
  - Accordion (mobile): Transição suave para expansão/contração

### Responsividade
- **Layout**:
  - Desktop: Tabela completa, 3 cards de estatísticas em linha
  - Tablet: Adaptação para largura reduzida
  - Mobile: Accordion em vez de tabela, estatísticas empilhadas
- **Filtros**: Drawer de tela cheia em mobile
- **Paginação**: Simplificada em mobile (apenas anterior/próximo)
- **Ações**: Botões maiores em mobile para facilitar o toque

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Gerenciamento de Equipes interage com várias entidades do sistema:

1. **Listagem de Equipes**:
   - Obtenção de equipes com paginação e filtragem
   - Relacionamentos com gestor e funcionários
   
2. **Operações CRUD**:
   - Criação de novas equipes
   - Edição de equipes existentes
   - Ativação/desativação de equipes
   - Exclusão de equipes

3. **Estatísticas**:
   - Contagem de equipes total
   - Contagem de equipes ativas
   - Contagem de gestores

### Controllers

#### `Company::TeamsController`
Responsável por gerenciar operações relacionadas às equipes da empresa.

**Ações:**
- `index`: Renderiza a página com a lista de equipes, aplicando filtros e paginação
- `new`: Renderiza formulário para criação de nova equipe
- `create`: Processa a criação de uma nova equipe
- `edit`: Renderiza formulário para edição de equipe existente
- `update`: Processa a atualização de uma equipe
- `destroy`: Processa a exclusão de uma equipe
- `filter_options`: Retorna opções para os filtros (gestores, etc.)

### Models Relevantes

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

**Validações:**
- Presença: `name`, `company_id`
- Unicidade: `name` (escopo da empresa)

#### `Employee`
Representa um funcionário da empresa, que pode ser gestor de uma equipe.

**Atributos relevantes:**
- `id`: Identificador único
- `company_id`: Referência à empresa
- `name`: Nome do funcionário
- `team_id`: Referência à equipe
- `active`: Status de ativação

**Associações:**
- `belongs_to :company`: Empresa à qual o funcionário pertence
- `belongs_to :team, optional: true`: Equipe do funcionário
- `has_one :managed_team, class_name: 'Team', foreign_key: 'manager_id'`: Equipe gerenciada pelo funcionário

#### `Company`
Representa uma empresa cadastrada no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa
- `active`: Status de ativação

**Associações:**
- `has_many :teams`: Equipes da empresa
- `has_many :employees`: Funcionários da empresa

### Services

#### `TeamService`
Serviço para gerenciar operações relacionadas às equipes.

**Métodos:**
- `initialize(company)`: Inicializa o serviço com uma empresa específica
- `list(params)`: Retorna equipes paginadas e filtradas
- `find(id)`: Encontra uma equipe específica
- `create(params)`: Cria uma nova equipe
- `update(id, params)`: Atualiza uma equipe existente
- `destroy(id)`: Exclui uma equipe
- `available_managers`: Retorna lista de funcionários que podem ser gestores
- `statistics`: Retorna estatísticas sobre equipes da empresa
- `employees_count(team_id)`: Retorna o número de funcionários em uma equipe

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Equipes
- `app/views/company/teams/index.html.erb`: View principal da página de equipes

#### Partials
- `app/views/company/teams/_statistics_cards.html.erb`: Cards de estatísticas
- `app/views/company/teams/_search_bar.html.erb`: Barra de busca
- `app/views/company/teams/_teams_table.html.erb`: Tabela de equipes
- `app/views/company/teams/_teams_mobile_accordion.html.erb`: Accordion para visualização mobile
- `app/views/company/teams/_filter_drawer.html.erb`: Drawer de filtros avançados
- `app/views/company/teams/_form.html.erb`: Formulário para criação/edição
- `app/views/company/teams/_delete_confirmation.html.erb`: Modal de confirmação para exclusão
- `app/views/company/teams/_pagination.html.erb`: Controles de paginação

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resources :teams do
      collection do
        get :filter_options
      end
    end
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `TeamsHelper`
```ruby
# Exemplo conceitual de helpers
module TeamsHelper
  def team_status_badge(active)
    if active
      tag.span("Ativa", class: "badge badge-active bg-green-50 text-green-700 border-green-200")
    else
      tag.span("Inativa", class: "badge badge-inactive bg-red-50 text-red-700 border-red-200")
    end
  end
  
  def format_date(date)
    return "-" if date.blank?
    l(date, format: :short)
  end
  
  def manager_name(team)
    team.manager&.name || "-"
  end
  
  def employees_count(team)
    team.employees.count
  end
  
  def active_filters_count(filters)
    count = 0
    count += 1 if filters[:manager_id].present? && filters[:manager_id] != "all"
    count += 1 if filters[:active].present? && filters[:active] != "all"
    count
  end
end
```

### Stimulus Controllers

#### `team-form-controller`
Controller para gerenciar o formulário de criação/edição de equipe.

**Ações:**
- `connect()`: Inicializa o controller
- `submit(event)`: Gerencia a submissão do formulário
- `toggleLoading(isLoading)`: Controla o estado de carregamento
- `validateForm()`: Valida o formulário antes da submissão

#### `team-filter-controller`
Controller para gerenciar os filtros de equipes.

**Ações:**
- `connect()`: Inicializa o controller e carrega estado dos filtros
- `toggleDrawer()`: Abre/fecha o drawer de filtros
- `applyFilters(event)`: Aplica filtros selecionados
- `clearFilters()`: Limpa todos os filtros
- `updateActiveFiltersCount()`: Atualiza contador de filtros ativos

#### `team-search-controller`
Controller para gerenciar a busca por nome de equipe.

**Ações:**
- `connect()`: Inicializa o controller
- `search(event)`: Realiza a busca em tempo real
- `debounce(callback, wait)`: Implementa debounce para evitar buscas excessivas

#### `team-table-controller`
Controller para gerenciar interações na tabela de equipes.

**Ações:**
- `connect()`: Inicializa o controller
- `edit(event)`: Abre o modal de edição para a equipe clicada
- `confirmDelete(event)`: Abre o diálogo de confirmação para exclusão

#### `delete-confirmation-controller`
Controller para gerenciar o diálogo de confirmação de exclusão.

**Ações:**
- `connect()`: Inicializa o controller
- `confirm()`: Confirma a exclusão
- `cancel()`: Cancela a operação
- `toggleLoading(isLoading)`: Controla o estado de carregamento durante a exclusão

### Turbo Frames e Streams

A página de equipes utiliza Turbo para atualizações dinâmicas:

1. **Frame da Tabela de Equipes**:
   ```erb
   <%= turbo_frame_tag "teams-list" do %>
     <!-- Tabela ou accordion de equipes -->
   <% end %>
   ```

2. **Frame de Estatísticas**:
   ```erb
   <%= turbo_frame_tag "team-statistics" do %>
     <!-- Cards de estatísticas -->
   <% end %>
   ```

3. **Frame de Formulário**:
   ```erb
   <%= turbo_frame_tag "team-form" do %>
     <!-- Formulário de criação/edição -->
   <% end %>
   ```

4. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "company_teams_#{current_company.id}" %>
   ```

### Regras de Negócio

1. **Permissões de Acesso**
   - Administradores da empresa têm acesso total a todas as equipes
   - Gestores podem visualizar detalhes das equipes que gerenciam
   - Funcionários regulares podem visualizar a lista geral das equipes, mas com informações limitadas

2. **Hierarquia de Gestão**
   - Um funcionário só pode ser gestor de uma única equipe
   - O gestor de uma equipe deve ser um funcionário ativo da empresa
   - Um funcionário não precisa necessariamente pertencer à equipe que gerencia

3. **Validação de Dados**
   - Nome da equipe não pode estar em branco
   - Nome da equipe deve ser único dentro da empresa
   - Gestor deve ser um funcionário válido e ativo

4. **Dependências e Exclusão**
   - Equipes com funcionários associados não devem ser excluídas, apenas desativadas
   - Ao desativar uma equipe, deve-se considerar o impacto nos funcionários associados
   - Ao excluir uma equipe, os funcionários devem permanecer no sistema, mas sem equipe

5. **Relatórios e Contagens**
   - A contagem de funcionários deve refletir apenas funcionários ativos
   - Estatísticas devem ser atualizadas em tempo real após operações CRUD
   - Histórico de alterações deve ser mantido para auditoria

### Permissões e Autorização

1. **Visualização de Equipes**:
   - Todos os funcionários podem ver a lista básica de equipes
   - Informações detalhadas são restritas a administradores e gestores

2. **Criação e Edição**:
   - Apenas administradores da empresa podem criar novas equipes
   - Administradores podem editar qualquer equipe
   - Gestores podem editar apenas as equipes que gerenciam

3. **Exclusão**:
   - Apenas administradores podem excluir equipes
   - Tentativas de exclusão de equipes com funcionários devem gerar alertas

4. **Designação de Gestores**:
   - Apenas administradores podem designar gestores para equipes
   - Um funcionário já designado como gestor de uma equipe não deve poder ser designado como gestor de outra

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Listagem de equipes com diferentes filtros
   - Criação, edição e exclusão de equipes
   - Tentativas de ações não autorizadas

2. **Testes de Modelo**:
   - Validações do modelo Team
   - Relacionamentos com outras entidades (Company, Employee)
   - Comportamento ao tentar excluir equipes com funcionários

3. **Testes de Sistema**:
   - Fluxo completo de criação de equipe
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
- Atualização em tempo real quando equipes são adicionadas, editadas ou removidas
- Atualizações incrementais de contadores e estatísticas
- Notificações para múltiplos usuários acessando a mesma página

#### Stimulus
- Gerenciamento interativo de filtros
- Busca em tempo real
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
   - Cache de opções de filtro (lista de gestores)
   - Invalidação seletiva de cache quando necessário

4. **Consultas Otimizadas**:
   - Índices para campos frequentemente consultados
   - Utilizar counter_cache para contagens frequentes

## Acessibilidade

1. **Navegação por Teclado**:
   - Tabela e controles navegáveis por teclado
   - Focus trap em modais
   - Skip links para áreas principais

2. **Leitores de Tela**:
   - Tabela com cabeçalhos adequados
   - Texto alternativo para ícones e badges
   - Anúncios de status para ações como criar, editar ou excluir

3. **Contraste e Legibilidade**:
   - Texto com contraste adequado
   - Tamanhos de fonte legíveis
   - Cores de estado (ativo/inativo) distinguíveis por cor e formato

4. **Mensagens de Status**:
   - Feedback não apenas visual, mas também via ARIA
   - Indicação clara de erros em formulários
   - Confirmações de ação bem-sucedida
