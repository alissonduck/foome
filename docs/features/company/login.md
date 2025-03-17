# Documentação: Fluxo de Login para Empresas

## Visão Geral
O fluxo de login para empresas permite que funcionários e administradores de empresas cadastradas acessem o sistema Foome para gerenciar benefícios alimentares. A página oferece múltiplos métodos de autenticação, incluindo email/senha tradicional e opções de login social.

## Histórias de Usuário

1. Como funcionário de uma empresa cadastrada, quero fazer login na plataforma para acessar meus benefícios alimentares.
2. Como administrador de uma empresa, quero acessar o painel administrativo para gerenciar benefícios dos funcionários.
3. Como usuário, quero poder recuperar minha senha caso a tenha esquecido.
4. Como usuário, quero poder utilizar minhas credenciais do Google ou Microsoft para facilitar o acesso.
5. Como novo usuário, quero ser redirecionado para o cadastro caso não tenha uma conta.

## Design & Frontend

### Estrutura da Página
A página de login possui um layout de duas colunas:
- **Coluna Esquerda**: Contém o logo, formulário de login e opções alternativas de autenticação
- **Coluna Direita**: Exibe uma imagem de ambiente de escritório com uma citação de cliente

### Componentes

#### Cabeçalho
- Logo Foome com link para a página inicial (canto superior esquerdo)

#### Formulário de Login
- Título "Entrar como empresa"
- Subtítulo "Digite seu e-mail abaixo para acessar"
- Campo de email (com label "Seu e-mail corporativo")
- Campo de senha (com máscara de caracteres)
- Link "Esqueceu sua senha?" (alinhado à direita)
- Botão de login primário "Entrar"
- Separador visual com texto "OU"
- Botões alternativos de login social:
  - "Entrar com sua conta Google" (com ícone do Google)
  - "Entrar com sua conta Microsoft" (com ícone da Microsoft)
- Link para cadastro "Não tem uma conta? Cadastre-se"

#### Área de Depoimento
- Imagem de fundo mostrando um ambiente de escritório moderno
- Sobreposição escura semitransparente
- Citação de cliente sobre os benefícios do serviço
- Atribuição da citação (nome e cargo)

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (tom laranja/vermelho)
  - Fundo da página: #FFFFFF (branco) para área do formulário
  - Botão primário: #FF4D4D (vermelho)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Links: #FF4D4D (laranja/vermelho)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título principal: 24px (font-bold)
    - Subtítulo: 14px (text-gray-600)
    - Labels: 14px (font-medium)
    - Texto de entrada: 16px
    - Texto da citação: 18px

- **Elementos de UI**:
  - Botão primário: Fundo vermelho (#FF4D4D), texto branco, cantos arredondados
  - Botões secundários (social): Fundo branco, borda cinza, ícones coloridos à esquerda
  - Inputs: Borda leve (#E5E7EB), cantos arredondados, padding interno generoso
  - Separador "OU": Linha horizontal com texto centralizado

### Responsividade
- Em dispositivos móveis: Apenas a coluna do formulário é exibida
- Em tablets e desktop: Layout de duas colunas é mantido
- Imagem e citação só aparecem em telas maiores (lg: 1024px ou mais)

## Backend (Rails)

### Fluxo de Autenticação

O fluxo de login utiliza o Devise para autenticação de funcionários (Employee), com extensões para suportar autenticação social.

1. **Login Tradicional (Email/Senha)**
   - Verificação de credenciais com Devise
   - Redirecionamento baseado no papel do funcionário (admin, gerente, membro)

2. **Login Social (Google/Microsoft)**
   - Autenticação via OmniAuth
   - Verificação se email está associado a um funcionário existente
   - Vinculação de conta social se primeiro acesso com esse método

3. **Recuperação de Senha**
   - Envio de email com instruções para redefinição
   - Verificação de token seguro para redefinição

### Modelos e Banco de Dados

#### Modelo `Employee` (com Devise)
Responsável pela autenticação e dados do funcionário.

**Atributos Relevantes para Autenticação:**
- `email`: Email corporativo usado para login
- `encrypted_password`: Senha criptografada (gerenciada pelo Devise)
- `company_id`: Referência à empresa
- `active`: Status de ativação do funcionário
- `role`: Função/cargo (admin, manager, member)
- `reset_password_token`: Token para redefinição de senha
- `reset_password_sent_at`: Data de envio do token de redefinição
- `remember_created_at`: Data de criação do cookie "lembrar-me"
- `sign_in_count`: Contador de logins
- `current_sign_in_at`: Data do login atual
- `last_sign_in_at`: Data do último login
- `current_sign_in_ip`: IP do login atual
- `last_sign_in_ip`: IP do último login
- `failed_attempts`: Contador de tentativas falhas de login
- `locked_at`: Data de bloqueio da conta (após muitas tentativas falhas)

#### Modelo `Company`
Representa a empresa à qual o funcionário está vinculado.

**Atributos Relevantes para Autenticação:**
- `id`: Identificador único
- `active`: Status de ativação da empresa
- Demais atributos conforme documentação de cadastro

### Controllers

#### `Employees::SessionsController`
Gerencia o processo de login de funcionários, extendendo o Devise.

**Ações:**
- `new`: Renderiza o formulário de login
- `create`: Processa o login tradicional (email/senha)
- `destroy`: Realiza o logout

#### `Employees::OmniauthCallbacksController`
Gerencia autenticações via provedores sociais.

**Ações:**
- `google_oauth2`: Processa callbacks de autenticação do Google
- `microsoft_graph`: Processa callbacks de autenticação da Microsoft
- `failure`: Trata falhas na autenticação social

#### `Employees::PasswordsController`
Gerencia recuperação e redefinição de senhas.

**Ações:**
- `new`: Formulário para solicitar recuperação
- `create`: Envia email de recuperação
- `edit`: Formulário para definir nova senha
- `update`: Salva a nova senha

### Services

#### `EmployeeAuthenticationService`
Serviço para centralizar lógica de autenticação.

**Métodos:**
- `authenticate(email, password)`: Autentica com email/senha
- `find_for_oauth(auth)`: Encontra ou cria funcionário baseado em dados OAuth
- `update_oauth_credentials(employee, auth)`: Atualiza credenciais sociais

#### `LoginAuditService`
Serviço para registrar e auditar logins.

**Métodos:**
- `record_successful_login(employee, ip, user_agent)`: Registra login bem-sucedido
- `record_failed_login(email, ip, user_agent)`: Registra tentativa falha
- `check_suspicious_activity(employee, ip)`: Verifica atividades suspeitas

### Regras de Negócio

1. **Validação de Acesso**
   - Apenas funcionários com conta ativa podem fazer login
   - Funcionários de empresas inativas são impedidos de acessar
   - Bloqueio temporário após 5 tentativas falhas consecutivas

2. **Autenticação Social**
   - O email da conta social deve corresponder a um email corporativo cadastrado
   - Primeira autenticação social vincula a conta automaticamente
   - Tokens de acesso são renovados automaticamente quando expiram

3. **Redirecionamento Pós-Login**
   - Administradores são direcionados para o painel administrativo
   - Gerentes são direcionados para visão de equipe
   - Membros comuns são direcionados para dashboard pessoal

4. **Segurança**
   - Senhas armazenadas com hash bcrypt (padrão Devise)
   - Tokens de autenticação com expiração configurável
   - Registro de IPs e momentos de login para auditoria

### Integrações

1. **Google OAuth**
   - Integração via OmniAuth para login com Google
   - Escopo de acesso limitado ao perfil básico e email

2. **Microsoft OAuth**
   - Integração via OmniAuth para login com Microsoft
   - Suporte para contas corporativas (Azure AD)

3. **ActionMailer**
   - Envio de emails para recuperação de senha
   - Templates responsivos com instruções claras

### Fluxo de Dados na Aplicação Rails

1. **Iniciando o Login**
   - O usuário acessa `/employees/sign_in`
   - O sistema renderiza o formulário de login
   - Alternativas sociais são apresentadas

2. **Processamento do Login**
   - **Login tradicional**:
     - Formulário é submetido via Turbo
     - Devise autentica as credenciais
     - Redirecionamento baseado no papel
   
   - **Login social**:
     - Redirecionamento para o provedor (Google/Microsoft)
     - Callback processa dados OAuth retornados
     - Verificação se email existe no sistema
     - Vinculação de identidade e autenticação

3. **Recuperação de Senha**
   - Usuário solicita recuperação
   - Email com link seguro é enviado
   - Token com expiração de 24h é gerado
   - Formulário de nova senha é acessado via token
   - Nova senha é definida e usuário é autenticado

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Controller**
   - Login com credenciais válidas
   - Login com credenciais inválidas
   - Bloqueio após tentativas falhas
   - Redirecionamentos corretos

2. **Testes de Integração**
   - Fluxo completo de login
   - Recuperação de senha
   - Login social (mockando provedores)

3. **Testes de Segurança**
   - Proteção contra força bruta
   - Validação de tokens
   - Expiração de sessão

## Considerações de Implementação

### Hotwire e Turbo

- Utilizar Turbo para transições suaves sem recarregar a página
- Implementar validações instantâneas com Stimulus
- Feedback visual imediato para erros de formulário

### Dispositivos Móveis

- Garantir que o formulário seja completamente utilizável em dispositivos móveis
- Adaptar layout para remover a coluna direita em telas pequenas
- Otimizar tamanho de botões para toque em dispositivos móveis

### Acessibilidade

- Garantir contraste adequado para legibilidade
- Implementar atributos ARIA para leitores de tela
- Navegação completa por teclado
- Mensagens de erro claras e associadas aos campos

### Segurança Adicional

- Implementar CAPTCHA após múltiplas tentativas falhas
- Considerar autenticação de dois fatores para administradores
- Implementar verificação de dispositivos não reconhecidos
- Alertas por email para logins de novos dispositivos/localizações
