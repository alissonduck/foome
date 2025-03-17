# Documentação: Página de Configurações da Empresa

## Visão Geral
A página de Configurações da Empresa permite que administradores visualizem e atualizem as informações básicas da empresa e consultem os dados do escritório principal. Esta é uma funcionalidade essencial para manter os dados cadastrais atualizados e garantir a correta operação do sistema.

## Histórias de Usuário

1. Como administrador da empresa, quero visualizar as informações básicas da minha empresa para confirmar que estão corretas.
2. Como administrador da empresa, quero atualizar os dados cadastrais da empresa para mantê-los precisos e atualizados.
3. Como administrador da empresa, quero visualizar as informações do escritório principal para ter acesso rápido a esses dados.
4. Como usuário autorizado, quero receber feedback claro quando ocorrerem erros durante o processo de atualização dos dados.
5. Como gestor de RH, quero atualizar o número máximo de funcionários permitidos para a empresa para adequar às mudanças organizacionais.

## Design & Frontend

### Estrutura da Página
A página é estruturada em três áreas principais:

1. **Cabeçalho**:
   - Título da página ("Configurações da empresa")
   - Subtítulo descritivo ("Gerencie as informações e configurações da sua empresa")

2. **Área de Alerta** (condicional):
   - Mensagem de erro quando aplicável
   - Visual destacado para chamar atenção do usuário

3. **Cartões de Conteúdo**:
   - Cartão de "Dados da empresa" com formulário de edição
   - Cartão de "Informações do escritório" com dados somente leitura

### Componentes

#### Cabeçalho da Página
- Título principal em fonte grande e negrito
- Subtítulo em tamanho menor e cor mais clara
- Espaçamento adequado para separar do conteúdo

#### Alerta de Erro
- Fundo vermelho com ícone de alerta
- Título "Erro" em negrito
- Descrição detalhada do erro
- Posicionado no topo da área de conteúdo para visibilidade imediata

#### Cartão de Dados da Empresa
- **Cabeçalho do Cartão**:
  - Título "Dados da empresa"
  - Descrição "Atualize as informações básicas da sua empresa"

- **Formulário de Edição**:
  - Campos para informações da empresa (nome, CNPJ, setor, etc.)
  - Botão de submissão para salvar alterações
  - Estado de carregamento durante a submissão
  - Validação de campos

- **Estado de Carregamento**:
  - Esqueletos de carregamento (skeletons) durante a obtenção dos dados
  - Animação sutil para indicar processamento

#### Cartão de Informações do Escritório
- **Cabeçalho do Cartão**:
  - Título "Informações do escritório"
  - Descrição "Dados do escritório principal da empresa"

- **Exibição de Informações**:
  - Dados do escritório apresentados em formato somente leitura
  - Organização clara e de fácil leitura
  - Estado de carregamento enquanto os dados são obtidos

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Cards: #FFFFFF (branco) com sombra suave
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Alerta de erro: #FEE2E2 (vermelho claro) com ícone #991B1B (vermelho escuro)
  - Botão primário: #FF4D4D (vermelho) com texto branco
  - Botão secundário/cancelar: #F3F4F6 (cinza claro) com texto #374151 (cinza escuro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título da página: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Títulos dos cartões: 18px (font-semibold)
    - Descrição dos cartões: 14px (text-gray-500)
    - Labels de formulário: 14px (font-medium)
    - Campos de formulário: 16px
    - Botões: 14px (font-medium)

- **Elementos de UI**:
  - Cards: Cantos arredondados (rounded-lg), sombra suave
  - Inputs: Borda leve, cantos arredondados, padding adequado
  - Botão primário: Cantos arredondados, hover com tom mais escuro
  - Alerta: Cantos arredondados, ícone à esquerda

### Responsividade
- **Layout**:
  - Desktop: Formulário em duas colunas, largura contida
  - Tablet: Adaptação para uma coluna, mantendo a largura contida
  - Mobile: Coluna única, largura total disponível
- **Cartões**: Espaçamento vertical aumentado em telas menores
- **Formulário**: Campos empilhados em telas menores
- **Botões**: Tamanho aumentado em telas touch para facilitar o toque

## Backend (Rails)

### Estrutura e Fluxo de Dados

A página de Configurações da Empresa interage com várias entidades do sistema:

1. **Dados da Empresa**:
   - Informações básicas da empresa cadastrada
   - Permissões e limites (número máximo de usuários)
   
2. **Dados do Escritório**:
   - Informações do escritório principal
   - Endereço e informações de contato
   - Localização geográfica

### Controllers

#### `Company::SettingsController`
Responsável por gerenciar a visualização e atualização das configurações da empresa.

**Ações:**
- `index`: Renderiza a página principal de configurações com os dados da empresa e escritório
- `update`: Processa a atualização dos dados da empresa
- `update_logo`: Processa o upload e atualização do logo da empresa

### Models Relevantes

#### `Company`
Representa uma empresa cadastrada no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da empresa
- `corporate_name`: Razão social da empresa
- `cnpj`: CNPJ da empresa
- `industry`: Setor de atuação
- `size`: Tamanho da empresa (pequena, média, grande)
- `foundation_year`: Ano de fundação
- `website`: Site da empresa
- `logo`: Logo da empresa (Active Storage)
- `max_users`: Número máximo de usuários permitidos
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `has_many :offices`: Escritórios da empresa
- `has_many :employees`: Funcionários da empresa
- `has_many :teams`: Times/departamentos da empresa

**Validações:**
- Presença: `name`, `cnpj`
- Unicidade: `cnpj`
- Formato: `cnpj` (padrão brasileiro)
- Numérico: `max_users` (maior que zero)

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
- `phone`: Telefone de contato
- `email`: Email de contato
- `is_headquarters`: Indica se é o escritório principal/matriz
- `google_infos`: Informações adicionais do Google (JSON)
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Empresa à qual o escritório pertence
- `belongs_to :city`: Cidade onde o escritório está localizado
- `has_many :employees`: Funcionários alocados neste escritório

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

#### `CompanySettingsService`
Serviço para gerenciar operações relacionadas às configurações da empresa.

**Métodos:**
- `initialize(company)`: Inicializa o serviço com uma empresa específica
- `update(params)`: Atualiza os dados da empresa
- `update_logo(logo_file)`: Processa e atualiza o logo da empresa
- `headquarters`: Retorna o escritório principal da empresa

#### `LogoProcessingService`
Serviço para processar imagens de logo da empresa.

**Métodos:**
- `initialize(file)`: Inicializa o serviço com o arquivo de imagem
- `process`: Processa a imagem (redimensiona, otimiza, etc.)
- `validate`: Valida o arquivo de imagem (tipo, tamanho, dimensões)

### Views e Partials

#### Layout Principal
- `app/views/layouts/company.html.erb`: Layout específico para área da empresa

#### Configurações
- `app/views/company/settings/index.html.erb`: View principal da página de configurações

#### Partials
- `app/views/company/settings/_company_form.html.erb`: Formulário de edição de dados da empresa
- `app/views/company/settings/_office_info.html.erb`: Exibição de informações do escritório
- `app/views/company/settings/_error_alert.html.erb`: Alerta de erro

### Rotas

```ruby
# Exemplo conceitual das rotas
Rails.application.routes.draw do
  namespace :company do
    resource :settings, only: [:show, :update] do
      patch :update_logo
    end
    
    # outras rotas relevantes
  end
end
```

### Helpers e Formatters

#### `CompanySettingsHelper`
```ruby
# Exemplo conceitual de helpers
module CompanySettingsHelper
  def company_size_options
    [
      ["Pequena (1-49 funcionários)", "small"],
      ["Média (50-249 funcionários)", "medium"],
      ["Grande (250+ funcionários)", "large"]
    ]
  end
  
  def format_cnpj(cnpj)
    return "" if cnpj.blank?
    cnpj.gsub(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, "\\1.\\2.\\3/\\4-\\5")
  end
  
  def format_address(office)
    return "Endereço não cadastrado" if office.nil? || office.address.blank?
    
    parts = []
    parts << office.address
    parts << "#{office.number}" if office.number.present?
    parts << office.complement if office.complement.present?
    parts << "#{office.city.name}/#{office.city.state.abbreviation}" if office.city&.state
    parts << "CEP: #{format_zip_code(office.zip_code)}" if office.zip_code.present?
    
    parts.join(", ")
  end
  
  def format_zip_code(zip_code)
    return "" if zip_code.blank?
    zip_code.to_s.gsub(/^(\d{5})(\d{3})$/, "\\1-\\2")
  end
end
```

### Stimulus Controllers

#### `company-form-controller`
Controller para gerenciar o formulário de edição da empresa.

**Ações:**
- `connect()`: Inicializa o controller
- `submit(event)`: Gerencia a submissão do formulário
- `toggleLoading(isLoading)`: Controla o estado de carregamento
- `displayError(message)`: Exibe mensagens de erro
- `clearError()`: Limpa mensagens de erro
- `validateForm()`: Valida o formulário antes da submissão

#### `logo-upload-controller`
Controller para gerenciar o upload de logo da empresa.

**Ações:**
- `connect()`: Inicializa o controller
- `preview(event)`: Gera uma prévia da imagem selecionada
- `upload(event)`: Envia a imagem para processamento
- `reset()`: Limpa a seleção de imagem
- `toggleLoading(isLoading)`: Controla o estado de carregamento
- `displayError(message)`: Exibe mensagens de erro específicas do upload

### Turbo Frames e Streams

A página de configurações utiliza Turbo para atualizações dinâmicas:

1. **Frame de Formulário da Empresa**:
   ```erb
   <%= turbo_frame_tag "company-form" do %>
     <!-- Formulário de edição da empresa -->
   <% end %>
   ```

2. **Frame de Informações do Escritório**:
   ```erb
   <%= turbo_frame_tag "office-info" do %>
     <!-- Informações do escritório -->
   <% end %>
   ```

3. **Stream para Atualizações**:
   ```erb
   <%= turbo_stream_from "company_settings_#{current_company.id}" %>
   ```

### Regras de Negócio

1. **Permissões de Acesso**
   - Apenas administradores da empresa podem acessar e editar as configurações
   - Outros funcionários podem visualizar, mas não editar

2. **Validação de Dados**
   - CNPJ deve ser válido segundo as regras brasileiras
   - Nome da empresa não pode estar em branco
   - Número máximo de usuários deve ser positivo e respeitar limites do plano contratado
   - Validação de formato de e-mail e telefone para dados de contato

3. **Upload de Logo**
   - Aceitação apenas de formatos de imagem (JPEG, PNG, GIF)
   - Tamanho máximo de arquivo: 5 MB
   - Redimensionamento automático para dimensões padrão
   - Mínimo de qualidade para garantir boa aparência no sistema

4. **Atualização de Dados Sensíveis**
   - Mudanças em dados sensíveis (CNPJ, razão social) podem requerer aprovação adicional
   - Auditoria de mudanças em dados importantes

5. **Restrições Operacionais**
   - Número máximo de usuários não pode ser menor que o número atual de funcionários ativos
   - Uma empresa não pode ser desativada se tiver funcionários ativos

### Permissões e Autorização

1. **Visualização de Configurações**:
   - Todos os funcionários podem visualizar informações básicas
   - Dados sensíveis ou financeiros são restritos a administradores

2. **Edição de Configurações**:
   - Apenas administradores da empresa podem editar informações
   - Alterações no escritório principal podem ser restritas a super-administradores

3. **Upload de Logo**:
   - Administradores podem atualizar o logo da empresa
   - O sistema mantém versões anteriores para auditoria

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Acesso à página de configurações (autenticação e autorização)
   - Atualização bem-sucedida de dados
   - Tratamento adequado de erros de validação
   - Upload de logo com diferentes tipos de arquivo

2. **Testes de Modelo**:
   - Validações do modelo Company
   - Relacionamentos com outras entidades
   - Callbacks e métodos específicos

3. **Testes de Sistema**:
   - Fluxo completo de edição de dados
   - Visualização correta de erros
   - Upload e visualização de logo
   - Responsividade em diferentes tamanhos de tela

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre páginas sem recarregamento completo
- Submissão de formulário com atualizações parciais da página

#### Turbo Frames
- Atualização independente do formulário de empresa e informações do escritório
- Feedback instantâneo após submissão bem-sucedida

#### Turbo Streams
- Notificações em tempo real de alterações (para administradores conectados simultaneamente)
- Atualização dinâmica de componentes após modificações

#### Stimulus
- Gerenciamento interativo do formulário
- Preview de imagem antes do upload
- Validação de formulário do lado do cliente
- Feedback visual durante submissões

## Considerações de Performance

1. **Otimização de Imagens**:
   - Processamento de logo no backend para otimizar tamanho
   - Uso de diferentes tamanhos de imagem para diferentes contextos

2. **Caching**:
   - Cache de dados da empresa para reduzir consultas ao banco
   - Cache de escritório principal para acesso rápido

3. **Validação Eficiente**:
   - Validações no lado do cliente antes de enviar ao servidor
   - Feedback imediato de erros de validação

## Acessibilidade

1. **Formulários Acessíveis**:
   - Labels claramente associados a inputs
   - Mensagens de erro informativas
   - Ordem lógica de tabulação

2. **Contraste e Legibilidade**:
   - Texto com contraste adequado com o fundo
   - Tamanhos de fonte legíveis
   - Estrutura visual clara

3. **Estados e Feedback**:
   - Indicação clara de estados (carregando, erro, sucesso)
   - Feedback para ações realizadas
   - Confirmação de alterações salvas
