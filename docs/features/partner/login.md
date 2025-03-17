# Documentação: Página de Login para Estabelecimentos Parceiros

## Visão Geral
A página de Login para Estabelecimentos Parceiros permite que restaurantes e outros estabelecimentos cadastrados no sistema Foome possam acessar sua área exclusiva na plataforma. A interface oferece um design minimalista e direto, com foco na experiência do usuário, apresentando um formulário de login tradicional combinado com opções alternativas de autenticação.

## Histórias de Usuário

1. Como parceiro cadastrado no Foome, quero fazer login usando meu email e senha para acessar o painel de gerenciamento do meu estabelecimento.

2. Como novo estabelecimento, quero visualizar a opção de cadastro para iniciar meu processo de parceria com a plataforma Foome.

3. Como parceiro que esqueceu sua senha, quero ter acesso a uma funcionalidade de recuperação de senha para restaurar meu acesso ao sistema.

4. Como parceiro, quero ter a opção de fazer login usando minha conta Google para acessar o sistema de forma mais rápida e sem precisar memorizar credenciais adicionais.

5. Como gerente de estabelecimento, quero experimentar um processo de login seguro para proteger os dados do meu negócio.

## Design & Frontend

### Estrutura da Página
A página de login é dividida em duas seções principais:

1. **Área de Formulário (Lado Esquerdo)**:
   - Cabeçalho com logo Foome
   - Título principal indicando propósito da página
   - Subtítulo com orientação simples
   - Formulário de login com campos email e senha
   - Opções alternativas de autenticação
   - Link para recuperação de senha
   - Link para cadastro de nova conta

2. **Área Visual (Lado Direito)**:
   - Imagem de fundo relacionada a ambiente de restaurante/estabelecimento
   - Depoimento/testemunho de um parceiro sobre os benefícios da plataforma
   - Gradiente suave para garantir legibilidade do texto sobre a imagem

### Componentes

#### Cabeçalho
- Logo Foome (ícone de talheres cruzados + texto "foome")
- Posicionado no canto superior esquerdo
- Design minimalista que reforça a identidade da marca

#### Título e Subtítulo
- Título "Entrar como estabelecimento" em fonte grande e negrito
- Subtítulo em tamanho menor "Digite seu e-mail abaixo para acessar"
- Alinhamento à esquerda, consistente com o formulário

#### Formulário de Login
- Campo para E-mail:
  - Label claro "E-mail"
  - Placeholder informativo "estabelecimento@exemplo.com.br"
  - Validação visual em tempo real
  
- Campo para Senha:
  - Label "Senha"
  - Input com propriedades de segurança para mascarar caracteres
  - Link de "Esqueceu sua senha?" alinhado à direita

- Botão de Ação:
  - Label "Entrar"
  - Largura total do formulário
  - Background na cor primária (#FF4D4D)
  - Texto em branco
  - Cantos arredondados
  - Feedback visual ao hover/focus

#### Separador
- Texto "OU" centralizado
- Linhas horizontais sutis em ambos os lados

#### Opções Alternativas de Login
- Botão de Login com Google:
  - Ícone do Google
  - Texto "Entrar com sua conta Google"
  - Estilo outline com borda sutil
  - Background branco
  - Largura total

#### Área de Cadastro
- Texto "Não tem uma conta?"
- Link destacado "Cadastre-se" em cor primária ou sublinhado

#### Área de Depoimento
- Citação destacada em texto branco sobre imagem
- Atribuição ao autor do depoimento (nome e estabelecimento)
- Gradiente sutil para garantir legibilidade

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (vermelho)
  - Fundo da página: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Inputs: Borda #E5E7EB (cinza claro), foco #FF4D4D
  - Botão primário: #FF4D4D com texto branco
  - Botão secundário: Contorno #E5E7EB, texto #374151
  - Links: #FF4D4D (primária da marca)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Logo: 24px (font-bold)
    - Título principal: 24px (font-semibold)
    - Subtítulo: 14px (text-gray-600)
    - Labels: 14px (font-medium)
    - Inputs: 16px
    - Botões: 14px (font-medium)
    - Links: 14px
    - Depoimento: 18px (font-medium)
    - Atribuição: 14px (text-gray-300)

- **Elementos de UI**:
  - Inputs: Altura de 42px, cantos arredondados (rounded-md), padding interno adequado
  - Botões: Altura de 42px, cantos arredondados (rounded-md), padding horizontal generoso
  - Transições suaves em interações (hover, focus)
  - Espaçamento vertical consistente entre elementos (16-24px)
  - Margens laterais que mantêm o conteúdo centralizado

### Responsividade
- **Desktop**: Layout de duas colunas (formulário à esquerda, imagem à direita)
- **Tablet**: Layout de duas colunas mantido, com possível redução na largura da coluna de imagem
- **Mobile**: 
  - Apenas a coluna de formulário é exibida
  - Imagem e depoimento são ocultados
  - Formulário ocupa largura total
  - Espaçamento vertical ajustado para melhor encaixe na tela
  - Elementos mantêm proporções adequadas para interação via toque

## Backend (Rails)

### Estrutura e Fluxo de Dados

O processo de login de parceiros segue o seguinte fluxo:

1. **Entrada de credenciais**:
   - Usuário fornece email e senha ou escolhe autenticação social

2. **Validação e autenticação**:
   - Verificação das credenciais fornecidas
   - Validação do status da conta (ativa/inativa)

3. **Gerenciamento de sessão**:
   - Criação de sessão autenticada
   - Armazenamento de tokens/cookies seguros

4. **Redirecionamento**:
   - Encaminhamento para o dashboard do parceiro ou página adequada
   - Tratamento de casos especiais (primeiro login, etc.)

### Controllers

#### `Partner::SessionsController`
Responsável por gerenciar o processo de autenticação de parceiros.

**Ações:**
- `new`: Renderiza a página de login
- `create`: Processa o login por email/senha
- `destroy`: Realiza o logout
- `failure`: Trata falhas de autenticação

#### `Partner::OmniauthCallbacksController`
Gerencia autenticação via provedores externos (Google).

**Ações:**
- `google_oauth2`: Processa callbacks de autenticação Google
- `failure`: Trata falhas de autenticação social

#### `Partner::PasswordsController`
Gerencia funcionalidades de recuperação de senha.

**Ações:**
- `new`: Renderiza formulário de recuperação
- `create`: Processa solicitação de recuperação
- `edit`: Renderiza formulário para nova senha
- `update`: Salva nova senha

### Models Relevantes

#### `Partner`
Representa um estabelecimento parceiro da plataforma.

**Atributos relevantes:**
- `id`: Identificador único
- `google_infos`: Informações da conta Google (JSON)
- `city_id`: Referência à cidade
- `active`: Status de ativação
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `terms_accepted`: Aceitação dos termos
- `chairs`: Número de cadeiras/capacidade
- `days_of_week`: Dias de funcionamento (JSON)
- `instagram_infos`: Informações da conta Instagram (JSON)
- `onboarding_completed`: Status de conclusão do onboarding
- `activated_at`: Data de ativação
- `disabled_at`: Data de desativação

**Associações:**
- `has_many :partner_users`: Usuários associados a este parceiro
- `belongs_to :city`: Cidade onde o parceiro está localizado
- `has_many :vouchers`: Vouchers oferecidos pelo parceiro

**Validações:**
- Presença: `name` (implícito via dados do usuário)
- Status: `active` deve ser verdadeiro para permitir login

#### `PartnerUser`
Representa um usuário administrador de um estabelecimento parceiro.

**Atributos relevantes:**
- `id`: Identificador único
- `partner_id`: Referência ao parceiro
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `active`: Status de ativação
- `name`: Nome completo do usuário do parceiro
- `phone`: Telefone do usuário do parceiro
- `email`: Email do usuário
- `password`: Senha criptografada
- `reset_password_token`: Token para redefinição de senha
- `reset_password_sent_at`: Data de envio do token

**Associações:**
- `belongs_to :partner`: Estabelecimento que este usuário administra

**Validações:**
- Presença: `partner_id`
- Status: `active` deve ser verdadeiro para permitir login

**Associações:**
- `has_one :partner_user`: Associação com usuário de parceiro

**Validações:**
- Unicidade: `email`
- Formato: `email` deve ser válido
- Segurança: requisitos de senha definidos pelo Devise

### Services

#### `Partner::AuthenticationService`
Serviço para centralizar lógica de autenticação de parceiros.

**Métodos:**
- `authenticate(email, password)`: Autentica por credenciais tradicionais
- `authenticate_with_google(auth_data)`: Autentica via Google
- `validate_partner_status(partner)`: Verifica se parceiro está ativo
- `find_or_create_from_google(auth_data)`: Cria ou recupera usuário via Google

#### `Partner::SessionService`
Gerencia sessões de parceiros.

**Métodos:**
- `create_session(partner_user)`: Cria nova sessão autenticada
- `destroy_session(partner_user)`: Encerra sessão existente
- `generate_token(partner_user)`: Gera token seguro para API
- `record_login_activity(partner_user)`: Registra atividade de login

### Views e Partials

#### Layout Principal
- `app/views/layouts/partner.html.erb`: Layout específico para área de parceiros

#### Login
- `app/views/partner/sessions/new.html.erb`: View principal de login

#### Partials
- `app/views/partner/sessions/_form.html.erb`: Formulário de login
- `app/views/partner/sessions/_social_login.html.erb`: Botões de login social
- `app/views/partner/sessions/_testimonial.html.erb`: Área de depoimento
- `app/views/shared/_flash_messages.html.erb`: Mensagens de feedback

### Rotas

As rotas para autenticação de parceiros seriam configuradas da seguinte forma (formato conceitual):

```ruby
# Exemplo conceitual - não é código para implementação
Rails.application.routes.draw do
  namespace :partner do
    devise_for :users, controllers: {
      sessions: 'partner/sessions',
      passwords: 'partner/passwords',
      omniauth_callbacks: 'partner/omniauth_callbacks'
    }, path: '', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'senha',
      confirmation: 'confirmar'
    }
    
    # Outras rotas para parceiros
    get 'dashboard', to: 'dashboard#index'
  end
end
```

### Integrações Externas

#### Google OAuth
Integração com OAuth do Google para login social.

**Funcionalidades:**
- Autenticação com conta Google
- Obtenção de dados de perfil (nome, email, foto)
- Criação automática de conta quando necessário

**Implementação:**
- Uso da gem `omniauth-google-oauth2`
- Configuração no Devise
- Gerenciamento seguro de chaves de API via credentials do Rails

### Stimulus Controllers

#### `login-form-controller`
Controller para gerenciar o formulário de login.

**Ações:**
- `connect()`: Inicializa o controller
- `validateEmail(event)`: Valida formato de email em tempo real
- `togglePasswordVisibility(event)`: Alterna visibilidade da senha
- `handleSubmit(event)`: Processa submissão do formulário

#### `social-login-controller`
Controller para gerenciar login social.

**Ações:**
- `connect()`: Inicializa o controller
- `startGoogleAuth(event)`: Inicia o fluxo de autenticação do Google
- `handleCallback(event)`: Processa retorno da autenticação

### Turbo Frames e Streams

A página de login utiliza Turbo para melhorar a experiência:

1. **Frame do Formulário**:
   ```erb
   <%= turbo_frame_tag "login-form" do %>
     <!-- Formulário de login -->
   <% end %>
   ```

2. **Frame de Mensagens**:
   ```erb
   <%= turbo_frame_tag "flash-messages" do %>
     <!-- Mensagens de erro/sucesso -->
   <% end %>
   ```

3. **Stream para Notificações**:
   ```erb
   <%= turbo_stream_from "partner_notifications" %>
   ```

### Regras de Negócio

1. **Acesso de Parceiros**
   - Apenas parceiros com status `active` podem fazer login
   - Parceiros com `disabled_at` preenchido devem ser impedidos de logar
   - Redirecionamento pós-login depende do status de `onboarding_completed`

2. **Autenticação Social**
   - Se um usuário já existe com o mesmo email, as contas são vinculadas
   - Novo registro via Google deve criar automaticamente um `PartnerUser`
   - Dados de perfil do Google devem ser armazenados para uso posterior

3. **Segurança**
   - Tentativas de login mal-sucedidas devem ser limitadas (proteção contra brute force)
   - Tokens de recuperação de senha devem expirar após 24 horas
   - Senhas devem seguir requisitos mínimos de segurança

4. **Experiência do Usuário**
   - Mensagens de erro devem ser claras e específicas
   - Login bem-sucedido deve manter sessão ativa por 2 semanas, se "lembrar-me" for selecionado
   - Primeiro login deve direcionar para completar perfil, se necessário

### Permissões e Autorização

1. **Acesso à Área de Parceiros**:
   - Apenas usuários com vínculo ativo em `PartnerUser` podem acessar
   - Parceiros desativados não têm permissão para entrar, mesmo com credenciais válidas

2. **Login Social**:
   - Autenticação social deve verificar se o domínio de email é comercial (não pessoal)
   - Vinculação de contas sociais requer confirmação quando os emails diferem

3. **Recuperação de Senha**:
   - Apenas o próprio usuário pode solicitar recuperação
   - Links de redefinição são de uso único e expiram automaticamente

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**:
   - Login bem-sucedido com redirecionamento correto
   - Login mal-sucedido com mensagens adequadas
   - Redirecionamento apropriado para usuários já autenticados
   - Autenticação social via Google

2. **Testes de Modelo**:
   - Validações do modelo User/PartnerUser
   - Associações entre Partner e PartnerUser
   - Verificação de estado (ativo/inativo)

3. **Testes de Integração**:
   - Fluxo completo de login-logout
   - Recuperação de senha end-to-end
   - Autenticação social com mock adequado

4. **Testes de Sistema**:
   - Comportamento responsivo em diferentes tamanhos de tela
   - Acessibilidade dos componentes de formulário
   - Interações de usuário com JavaScript

### Implementação com Hotwire

#### Turbo Drive
- Navegação sem refresh completo para tentativas de login
- Manutenção do estado visual durante transições

#### Turbo Frames
- Atualização isolada de mensagens de erro
- Preservação do conteúdo do formulário em caso de erro
- Transição suave entre formulários (login/recuperação)

#### Turbo Streams
- Notificações em tempo real sobre status da conta
- Atualização dinâmica de componentes após ações

#### Stimulus
- Validação em tempo real dos campos do formulário
- Interações para mostrar/esconder senha
- Gerenciamento do estado de loading durante submissões

## Considerações de Performance

1. **Carregamento Otimizado**:
   - Imagem de fundo com lazy loading e tamanhos responsivos
   - Priorização de CSS crítico no head
   - Carregamento assíncrono de recursos não essenciais

2. **Validação Cliente/Servidor**:
   - Validação básica no cliente para feedback imediato
   - Validação completa no servidor para segurança

3. **Caching Adequado**:
   - Recursos estáticos com cache de longa duração
   - Estratégia de cache para assets (imagens, CSS, JS)

## Acessibilidade

1. **Navegação por Teclado**:
   - Todos os elementos interativos acessíveis via teclado
   - Ordem de tabulação lógica
   - Indicadores visuais de foco claros

2. **Suporte a Leitores de Tela**:
   - Labels adequados para todos os campos
   - Texto alternativo para imagens
   - Mensagens de erro vinculadas aos campos correspondentes

3. **Contraste e Legibilidade**:
   - Contraste de texto conforme WCAG 2.1 AA
   - Tamanho de fonte adequado para leitura
   - Espaçamento generoso entre elementos interativos para dispositivos touch
