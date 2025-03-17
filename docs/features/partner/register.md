# Documentação: Página de Cadastro de Estabelecimentos Parceiros

## Visão Geral
A página de Cadastro de Estabelecimentos Parceiros permite que restaurantes e outros estabelecimentos interessados possam se registrar na plataforma Foome. O processo é estruturado em múltiplas etapas (multi-step), guiando o usuário através da coleta de informações necessárias de forma progressiva e intuitiva, reduzindo a sobrecarga cognitiva e aumentando a taxa de conclusão do cadastro.

## Histórias de Usuário

1. Como proprietário de um estabelecimento, quero poder me cadastrar na plataforma Foome para oferecer benefícios aos funcionários das empresas cadastradas.

2. Como gerente de restaurante, quero informar gradualmente os dados do meu estabelecimento em etapas organizadas para facilitar o processo de cadastro.

3. Como novo parceiro, quero visualizar claramente em qual etapa do cadastro estou para entender o progresso do meu registro.

4. Como estabelecimento interessado, quero poder criar uma conta com minhas credenciais para ter acesso personalizado à plataforma.

5. Como parceiro potencial, quero poder aceitar os termos de uso da plataforma de forma clara e informada antes de finalizar meu cadastro.

6. Como estabelecimento, quero fornecer informações sobre meu local (horários, tipo de culinária, localização) para que os clientes possam me encontrar adequadamente.

## Design & Frontend

### Estrutura da Página
A página de cadastro possui um layout centralizado e focado, priorizando o formulário:

1. **Cabeçalho Superior**:
   - Logo Foome centralizado/alinhado ao topo
   - Espaçamento adequado entre logo e formulário

2. **Área de Formulário**:
   - Container centralizado com largura máxima definida
   - Formulário multi-step com indicador de progresso
   - Botões de navegação entre etapas (Anterior/Próximo)
   - Formulário com campos agrupados logicamente por etapa

### Componentes

#### Cabeçalho
- Logo Foome (ícone de talheres cruzados + texto "foome")
- Tamanho destacado para reforçar identidade da marca
- Cor primária da marca (#FF4D4D)
- Link para voltar à página inicial

#### Indicador de Progresso
- Barra ou círculos de progresso mostrando as etapas do cadastro
- Etapa atual destacada visualmente
- Etapas futuras em estilo visual mais suave
- Etapas concluídas com indicador de conclusão (check)

#### Formulário Multi-step
O formulário é dividido em várias etapas lógicas, cada uma focada em um aspecto específico do cadastro:

**Etapa 1: Informações Básicas**
- Campos para:
  - Nome do estabelecimento
  - Email comercial
  - Senha (com confirmação)
  - Telefone de contato

**Etapa 2: Localização**
- Campos para:
  - Estado (select)
  - Cidade (select dependente do estado)
  - CEP 
  - Endereço completo
  - Bairro
  - Número
  - Complemento (opcional)

**Etapa 3: Detalhes do Estabelecimento**
- Campos para:
  - Tipo de culinária (múltipla escolha)
  - Características do local (checkboxes)
  - Capacidade (número de lugares)
  - Horário de funcionamento (por dia da semana)
  - Redes sociais (opcional)

**Etapa 4: Termos e Finalização**
- Checkbox para aceite dos termos de uso
- Link para visualizar os termos completos
- Resumo das informações fornecidas
- Botão de conclusão do cadastro

#### Navegação entre Etapas
- Botão "Anterior" (quando aplicável)
- Botão "Próximo" ou "Continuar"
- Botão "Concluir Cadastro" (última etapa)
- Validação dos campos antes de avançar para próxima etapa

#### Feedback Visual
- Indicadores de campos obrigatórios
- Mensagens de erro específicas por campo
- Feedback de sucesso após conclusão
- Animações suaves de transição entre etapas

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Inputs: Borda #E5E7EB (cinza claro), foco #FF4D4D
  - Botão primário: #FF4D4D com texto branco
  - Botão secundário/voltar: #F3F4F6 (cinza claro) com texto #374151
  - Indicador de progresso ativo: #FF4D4D
  - Indicador de progresso inativo: #E5E7EB
  - Mensagens de erro: #EF4444 (vermelho)
  - Mensagens de sucesso: #10B981 (verde)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Logo: 24px (font-bold)
    - Títulos de etapa: 20px (font-semibold)
    - Subtítulos/instruções: 14px (text-gray-600)
    - Labels: 14px (font-medium)
    - Inputs: 16px
    - Botões: 14px (font-medium)
    - Mensagens de erro: 12px
    - Textos de ajuda: 12px (text-gray-500)

- **Elementos de UI**:
  - Inputs: Altura de 42px, cantos arredondados (rounded-md), padding interno adequado
  - Selects: Estilo consistente com inputs, com ícone de seta para baixo
  - Checkboxes/Radio: Estilo personalizado com cores da marca quando selecionados
  - Botões: Altura de 42px, cantos arredondados (rounded-md), width adequado ao contexto
  - Cards de etapa: Fundo branco, sombra suave, padding generoso, cantos arredondados
  - Transições: Animações suaves entre etapas (fade/slide)

### Responsividade
- **Desktop**: Formulário centralizado com largura máxima definida (max-w-md ~ 28rem)
- **Tablet**: Layout mantido com ajustes proporcionais de tamanho
- **Mobile**:
  - Padding reduzido para maximizar espaço útil
  - Campos empilhados ocupando largura total
  - Botões de navegação maiores para facilitar toque
  - Indicador de progresso simplificado ou adaptado
  - Possível reorganização de campos complexos (horários, múltipla escolha)

## Backend (Rails)

### Estrutura e Fluxo de Dados

O processo de cadastro de parceiros segue o seguinte fluxo:

1. **Coleta progressiva de dados**:
   - Usuário preenche informações em etapas sequenciais
   - Dados são armazenados temporariamente entre etapas (sessão)

2. **Validação em cada etapa**:
   - Validação dos dados inseridos antes de avançar
   - Feedback imediato sobre erros ou problemas

3. **Persistência final**:
   - Criação de registros nas tabelas Partner e PartnerUser
   - Vinculação de entidades relacionadas (City, etc.)

4. **Pós-registro**:
   - Envio de email de confirmação/boas-vindas
   - Redirecionamento para primeira etapa de onboarding

### Controllers

#### `Partner::RegistrationsController`
Responsável por gerenciar o processo de cadastro de parceiros.

**Ações:**
- `new`: Renderiza o formulário de cadastro (primeira etapa)
- `create`: Processa o cadastro completo final
- `step`: Gerencia a navegação e validação entre etapas (1 a 4)
- `save_step`: Armazena temporariamente os dados de cada etapa
- `previous_step`: Retorna para etapa anterior mantendo dados

#### `Partner::LocationsController`
Auxilia no gerenciamento de dados de localização.

**Ações:**
- `cities`: Retorna cidades filtradas por estado selecionado
- `address_lookup`: Busca endereço a partir do CEP informado

### Models Relevantes

#### `Partner`
Representa um estabelecimento parceiro da plataforma.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do estabelecimento (derivado do PartnerUser)
- `google_infos`: Informações da conta Google (JSON) se aplicável
- `city_id`: Referência à cidade
- `address`: Endereço completo
- `neighborhood`: Bairro
- `zip_code`: CEP
- `number`: Número
- `complement`: Complemento (opcional)
- `active`: Status de ativação (default: false até aprovação)
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `terms_accepted`: Aceitação dos termos (boolean)
- `chairs`: Número de cadeiras/capacidade
- `days_of_week`: Dias de funcionamento (JSON)
- `instagram_infos`: Informações da conta Instagram (JSON)
- `onboarding_completed`: Status de conclusão do onboarding
- `activated_at`: Data de ativação (preenchido após aprovação)

**Associações:**
- `has_many :partner_users`: Usuários associados a este parceiro
- `belongs_to :city`: Cidade onde o parceiro está localizado
- `has_many :partner_cuisines`: Tipos de culinária (associação)
- `has_many :cuisine_types, through: :partner_cuisines`: Tipos de culinária
- `has_many :partner_characteristics`: Características do estabelecimento (associação)
- `has_many :characteristics, through: :partner_characteristics`: Características

**Validações:**
- Presença: `name`, `city_id`, `address`, `neighborhood`, `zip_code`, `number`
- Termos: `terms_accepted` deve ser verdadeiro
- Funcionamento: `days_of_week` deve ter ao menos um dia definido
- Capacidade: `chairs` deve ser um número positivo

#### `PartnerUser`
Representa um usuário administrador de um estabelecimento parceiro.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome completo do usuário
- `email`: Email do usuário
- `phone`: Telefone de contato
- `partner_id`: Referência ao parceiro
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `active`: Status de ativação (default: true)
- `encrypted_password`: Senha criptografada
- `reset_password_token`: Token para redefinição de senha
- `reset_password_sent_at`: Data de envio do token

**Associações:**
- `belongs_to :partner`: Estabelecimento que este usuário administra

**Validações:**
- Presença: `name`, `email`, `phone`, `partner_id` (após criação)
- Unicidade: `email`
- Formato: `email` e `phone` devem ser válidos
- Segurança: senha deve atender requisitos mínimos (8 caracteres, combinação de letras/números)

#### `City`
Representa uma cidade no sistema.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da cidade
- `state_id`: Referência ao estado

**Associações:**
- `belongs_to :state`: Estado ao qual a cidade pertence
- `has_many :partners`: Parceiros nesta cidade

#### `CuisineType`
Representa um tipo de culinária que um estabelecimento pode oferecer.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome do tipo de culinária
- `created_at`: Data de criação

**Associações:**
- `has_many :partner_cuisines`: Associação com parceiros
- `has_many :partners, through: :partner_cuisines`: Parceiros com este tipo de culinária

#### `Characteristic`
Representa uma característica que um estabelecimento pode ter.

**Atributos relevantes:**
- `id`: Identificador único
- `name`: Nome da característica
- `created_at`: Data de criação

**Associações:**
- `has_many :partner_characteristics`: Associação com parceiros
- `has_many :partners, through: :partner_characteristics`: Parceiros com esta característica

### Services

#### `Partner::RegistrationService`
Serviço para gerenciar o processo de cadastro de parceiros.

**Métodos:**
- `initialize(params)`: Inicializa o serviço com parâmetros de cadastro
- `register`: Processa o registro completo do parceiro
- `validate_step(step_number, params)`: Valida dados de uma etapa específica
- `build_partner_from_session`: Constrói objeto Partner a partir dos dados armazenados
- `build_partner_user`: Cria o usuário principal associado ao parceiro
- `save_associate_entities`: Salva entidades relacionadas (culinária, características)
- `send_welcome_email`: Envia email de boas-vindas após registro

#### `Partner::LocationService`
Serviço para gerenciar operações relacionadas à localização.

**Métodos:**
- `cities_by_state(state_id)`: Retorna cidades filtradas por estado
- `fetch_address_by_zipcode(zipcode)`: Busca endereço usando API externa baseado no CEP

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Registro
- `app/views/partner/registrations/new.html.erb`: View principal com o wizard de cadastro

#### Partials por Etapa
- `app/views/partner/registrations/_step_indicator.html.erb`: Indicador de progresso
- `app/views/partner/registrations/_step_1.html.erb`: Informações básicas
- `app/views/partner/registrations/_step_2.html.erb`: Localização
- `app/views/partner/registrations/_step_3.html.erb`: Detalhes do estabelecimento
- `app/views/partner/registrations/_step_4.html.erb`: Termos e finalização
- `app/views/partner/registrations/_navigation_buttons.html.erb`: Botões de navegação entre etapas
- `app/views/shared/_flash_messages.html.erb`: Mensagens de feedback

### Rotas

As rotas para cadastro de parceiros seriam configuradas da seguinte forma (formato conceitual):

```ruby
# Exemplo conceitual - não é código para implementação
Rails.application.routes.draw do
  namespace :partner do
    resource :registration, only: [:new, :create] do
      get 'step/:step', to: 'registrations#step', as: 'step'
      post 'step/:step', to: 'registrations#save_step', as: 'save_step'
      get 'previous_step/:step', to: 'registrations#previous_step', as: 'previous_step'
      get 'success', to: 'registrations#success', as: 'success'
    end
    
    resources :locations, only: [] do
      collection do
        get 'cities/:state_id', to: 'locations#cities', as: 'cities'
        get 'address_lookup/:zipcode', to: 'locations#address_lookup', as: 'address_lookup'
      end
    end
  end
end
```

### Integrações Externas

#### API de CEP
Integração com serviço de busca de endereço por CEP.

**Funcionalidades:**
- Preenchimento automático de endereço a partir do CEP
- Validação de CEP existente
- Consistência de dados de endereço

**Implementação:**
- Uso da gem `correios-cep` ou similar
- Cache de resultados para reduzir chamadas à API
- Fallback para preenchimento manual em caso de falha

### Stimulus Controllers

#### `registration-wizard-controller`
Controller principal para gerenciar o fluxo do formulário multi-step.

**Ações:**
- `connect()`: Inicializa o controller
- `nextStep(event)`: Avança para a próxima etapa após validação
- `previousStep(event)`: Retorna para a etapa anterior
- `validateCurrentStep()`: Valida os campos da etapa atual
- `updateProgressIndicator(step)`: Atualiza o indicador visual de progresso
- `showErrors(errors)`: Exibe erros de validação nos campos correspondentes

#### `location-form-controller`
Controller para gerenciar os campos de localização.

**Ações:**
- `connect()`: Inicializa o controller
- `fetchCities(event)`: Atualiza o select de cidades quando o estado muda
- `lookupAddress(event)`: Busca endereço quando CEP é informado
- `fillAddressFields(address)`: Preenche os campos de endereço com os dados obtidos

#### `operating-hours-controller`
Controller para gerenciar os campos de horário de funcionamento.

**Ações:**
- `connect()`: Inicializa o controller
- `toggleDay(event)`: Ativa/desativa um dia da semana
- `updateHours(event)`: Atualiza os horários para um dia específico
- `copyToAllDays(event)`: Copia configuração de um dia para todos os outros

#### `multi-select-controller`
Controller para gerenciar seleções múltiplas (culinária, características).

**Ações:**
- `connect()`: Inicializa o controller
- `toggle(event)`: Adiciona/remove item da seleção
- `isSelected(id)`: Verifica se um item está selecionado
- `getSelectedValues()`: Retorna os valores selecionados

### Turbo Frames e Streams

O formulário de cadastro utiliza Turbo para melhorar a experiência:

1. **Frame do Formulário**:
   ```erb
   <%= turbo_frame_tag "registration-form" do %>
     <!-- Formulário de cadastro -->
   <% end %>
   ```

2. **Frame da Etapa Atual**:
   ```erb
   <%= turbo_frame_tag "registration-step-#{@current_step}" do %>
     <!-- Campos da etapa atual -->
   <% end %>
   ```

3. **Frame de Mensagens**:
   ```erb
   <%= turbo_frame_tag "registration-messages" do %>
     <!-- Mensagens de erro/sucesso -->
   <% end %>
   ```

4. **Frame para Cidades**:
   ```erb
   <%= turbo_frame_tag "cities-select" do %>
     <!-- Select de cidades atualizado via AJAX -->
   <% end %>
   ```

### Regras de Negócio

1. **Processo de Cadastro**
   - Cadastro deve ser realizado em etapas sequenciais
   - Dados de cada etapa devem ser validados antes de avançar
   - Usuário pode voltar a etapas anteriores sem perder dados já preenchidos
   - Todas as etapas devem ser concluídas para finalizar o cadastro

2. **Validação de Dados**
   - Email deve ser único no sistema
   - Senha deve seguir requisitos mínimos de segurança
   - Termos de uso devem ser obrigatoriamente aceitos
   - Ao menos um dia de funcionamento deve ser configurado
   - Dados de localização devem ser consistentes (cidade pertence ao estado selecionado)

3. **Pós-cadastro**
   - Conta criada inicialmente com status inativo (pendente de aprovação)
   - Email de confirmação enviado após cadastro bem-sucedido
   - Administrador é notificado sobre novo estabelecimento cadastrado
   - Usuário é redirecionado para tela de sucesso com próximos passos

4. **Restrições e Limitações**
   - Apenas um usuário administrador criado inicialmente por estabelecimento
   - Tipos de culinária e características são pré-definidos no sistema
   - CEP deve ser válido e corresponder à cidade selecionada
   - Campos obrigatórios variam conforme a etapa do cadastro

### Permissões e Autorização

1. **Acesso ao Cadastro**:
   - Página de cadastro é pública, mas com proteções contra bots
   - Usuários já autenticados são redirecionados ao dashboard
   - Tentativas de acesso direto a etapas específicas são validadas

2. **Segurança de Dados**:
   - Senhas são armazenadas com criptografia segura (via Devise)
   - Dados sensíveis trafegam apenas por conexão segura (HTTPS)
   - Validações server-side implementadas mesmo com validação client-side

3. **Proteção contra Abusos**:
   - Limitação de tentativas de cadastro por IP
   - Validação de email via confirmação
   - CAPTCHA para proteção contra bots (se necessário)

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Fluxo entre etapas (avançar, voltar)
   - Validação de dados por etapa
   - Persistência de dados temporários entre etapas
   - Criação final do parceiro

2. **Testes de Modelo**:
   - Validações de Partner e PartnerUser
   - Relacionamentos entre entidades
   - Estados iniciais após criação

3. **Testes de Integração**:
   - Fluxo completo de cadastro end-to-end
   - Integração com API de CEP
   - Seleção encadeada de estado e cidade

4. **Testes de Sistema**:
   - Comportamento responsivo em diferentes tamanhos de tela
   - Interação do usuário com o wizard de etapas
   - Feedback visual durante validações

### Implementação com Hotwire

#### Turbo Drive
- Navegação entre etapas sem refresh completo da página
- Submissão de formulários sem recarregamento

#### Turbo Frames
- Atualização isolada da etapa atual do cadastro
- Atualizações dinâmicas do select de cidades
- Exibição contextual de erros

#### Turbo Streams
- Atualização do indicador de progresso
- Adição/remoção dinâmica de opções selecionadas

#### Stimulus
- Validação client-side dos campos
- Gerenciamento de estado dos multi-selects
- Interações complexas como o configurador de horário

## Considerações de Performance

1. **Otimização de Formulário**:
   - Carregar dados de etapas apenas quando necessário
   - Armazenar temporariamente dados entre etapas
   - Validação progressiva para feedback rápido

2. **Otimização de Assets**:
   - Lazy loading de recursos não essenciais
   - Imagens e ícones otimizados
   - CSS e JS específicos para a funcionalidade

3. **Eficiência de Consultas**:
   - Cache de dados frequentes (estados, cidades)
   - Consultas otimizadas ao buscar dados relacionados
   - Transações para garantir integridade dos dados

## Acessibilidade

1. **Navegação por Teclado**:
   - Foco sequencial lógico entre campos
   - Botões de navegação acessíveis por teclado
   - Trap focus dentro de modais quando abertos

2. **Estrutura Semântica**:
   - Agrupamento lógico de campos com fieldsets e legends
   - Labels explícitos para todos os campos
   - Textos alternativos para elementos visuais

3. **Mensagens e Instruções**:
   - Mensagens de erro claras e associadas aos campos
   - Instruções explícitas para campos complexos
   - Feedback de progresso acessível

4. **Suporte a Leitores de Tela**:
   - Anúncios de mudança de etapa
   - Descrições para campos obrigatórios
   - ARIA roles e attributes quando necessário
