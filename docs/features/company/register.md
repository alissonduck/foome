# Documentação: Fluxo de Cadastro de Empresas

## Visão Geral
O fluxo de cadastro de empresas permite que novas organizações se registrem na plataforma Foome para oferecer benefícios alimentares a seus funcionários. O cadastro é dividido em etapas sequenciais (wizard) para melhorar a experiência do usuário e facilitar a coleta de informações.

## Histórias de Usuário

1. Como representante de uma empresa, quero me cadastrar na plataforma para oferecer benefícios alimentares aos funcionários.
2. Como representante de uma empresa, quero registrar informações básicas sobre minha organização para iniciar o processo de cadastro.
3. Como representante de uma empresa, quero ter um processo de cadastro intuitivo e dividido em etapas para facilitar o preenchimento das informações.
4. Como representante de uma empresa, quero poder interromper o cadastro e continuá-lo posteriormente, sem perder os dados já inseridos.

## Design & Frontend

### Estrutura da Página

A página de cadastro é estruturada como um wizard (assistente) de 4 etapas, com a seguinte organização:

- **Cabeçalho**: Contém logo Foome centralizado com ícone de talheres cruzados
- **Indicador de Progresso**: Mostra as 4 etapas do cadastro, com destaque para a etapa atual
- **Conteúdo Principal**: Container branco centralizado com formulário da etapa atual
- **Rodapé**: Link para página de login caso já possua conta

### Componentes

#### Cabeçalho
- Logo Foome com ícone UtensilsCrossed
- Link para retornar à página inicial

#### Indicador de Progresso
- Círculos numerados de 1 a 4
- Círculo da etapa atual destacado em vermelho
- Círculos futuros em cinza claro
- Linhas conectoras entre os círculos

#### Formulário (Etapa 1)
- Título "Cadastre sua empresa"
- Subtítulo "Comece agora mesmo a gerenciar seus benefícios corporativos"
- Campos:
  - Email corporativo (input de email com validação)
  - CNPJ (input com máscara 00.000.000/0000-00)
  - Cidade (select com busca)
- Botão "Continuar" em destaque
- Link "Já possui uma conta? Faça login"

### Cores e Estilos

- **Cores principais**:
  - Primária (foome-primary): #FF4D4D (tom laranja/vermelho)
  - Fundo da página: #F9FAFB (cinza muito claro)
  - Fundo do container: #FFFFFF (branco)
  - Texto principal: #111827 (quase preto)
  - Texto secundário: #6B7280 (cinza médio)
  - Destaque de etapa ativa: #FF4D4D (laranja)
  - Etapas inativas: #E5E7EB (cinza claro)

- **Tipografia**:
  - Fonte principal: Inter (sans-serif)
  - Tamanhos:
    - Título: 24px (font-bold)
    - Subtítulo: 16px (text-gray-600)
    - Labels: 14px (font-medium)
    - Texto de entrada: 16px

- **Elementos de UI**:
  - Botão primário: Fundo #FF6B35, texto branco, cantos arredondados, padding vertical e horizontal generoso
  - Inputs: Borda leve (#E5E7EB), cantos arredondados, padding interno suficiente
  - Select: Estilo similar aos inputs, com ícone de seta para baixo no lado direito
  - Etapas do wizard: Círculos de 32px, numerados, conectados por linhas

### Responsividade
- Design responsivo adaptado para diferentes tamanhos de tela
- Em dispositivos móveis: padding reduzido, largura total do container
- Em tablets e desktop: container centralizado com largura máxima

## Backend (Rails)

### Fluxo do Processo

O cadastro de empresa segue o seguinte fluxo:

1. **Etapa 1 (Informações Básicas)**
   - Coleta de email corporativo, CNPJ e cidade
   - Validação inicial dos dados
   - Criação temporária dos registros

2. **Etapa 2 (Informações Detalhadas da Empresa)**
   - Nome da empresa
   - Telefone de contato
   - Setor de atuação
   - Quantidade de funcionários

3. **Etapa 3 (Dados do Escritório)**
   - Endereço completo
   - CEP
   - Número
   - Complemento
   - Bairro

4. **Etapa 4 (Dados do Administrador)**
   - Nome do administrador
   - Email (já preenchido da etapa 1)
   - Senha
   - Confirmação de senha
   - Termos de uso (checkbox)

### Modelos e Banco de Dados

#### Modelo `Company`
Representa a empresa que está se cadastrando.

**Atributos:**
- `id`: Identificador único
- `name`: Nome da empresa
- `email`: Email corporativo principal
- `cnpj`: CNPJ da empresa (formato: 00.000.000/0000-00)
- `phone`: Telefone de contato
- `sector`: Setor de atuação
- `employee_count`: Quantidade aproximada de funcionários
- `max_users`: Limite de usuários permitidos
- `active`: Status de ativação da empresa
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- `onboarding_completed`: Status de conclusão do onboarding
- `terms_accepted`: Status de aceitação dos termos

**Associações:**
- `has_many :offices`: Uma empresa pode ter vários escritórios
- `has_many :employees`: Uma empresa pode ter vários funcionários
- `has_many :teams`: Uma empresa pode ter várias equipes

#### Modelo `Office`
Representa um escritório/filial da empresa.

**Atributos:**
- `id`: Identificador único
- `company_id`: Referência à empresa
- `city_id`: Referência à cidade
- `address`: Endereço
- `zip_code`: CEP
- `number`: Número
- `complement`: Complemento
- `neighborhood`: Bairro
- `google_infos`: Informações adicionais do Google (formato JSON)
- `active`: Status de ativação do escritório
- `created_at`: Data de criação
- `updated_at`: Data de atualização

**Associações:**
- `belongs_to :company`: Pertence a uma empresa
- `belongs_to :city`: Pertence a uma cidade
- `has_many :employees`: Tem vários funcionários vinculados

#### Modelo `Employee` (com Devise)
Representa um funcionário de uma empresa, com suporte a autenticação.

**Atributos:**
- `id`: Identificador único
- `email`: Email do funcionário (usado para login)
- `encrypted_password`: Senha criptografada (gerenciada pelo Devise)
- `company_id`: Referência à empresa
- `office_id`: Referência ao escritório
- `team_id`: Referência à equipe
- `name`: Nome completo
- `birth_date`: Data de nascimento
- `internal_id`: ID interno da empresa para o funcionário
- `role`: Função/cargo (admin, manager, member)
- `active`: Status de ativação do funcionário
- `created_at`: Data de criação
- `updated_at`: Data de atualização
- Campos padrão do Devise (reset_password_token, reset_password_sent_at, etc.)

**Associações:**
- `belongs_to :company`: Pertence a uma empresa
- `belongs_to :office, optional: true`: Pode estar vinculado a um escritório
- `belongs_to :team, optional: true`: Pode estar vinculado a uma equipe

#### Modelo `City`
Representa uma cidade.

**Atributos:**
- `id`: Identificador único
- `name`: Nome da cidade
- `state_id`: Referência ao estado
- Campos de timestamps padrão

**Associações:**
- `belongs_to :state`: Pertence a um estado
- `has_many :offices`: Tem vários escritórios

#### Modelo `State`
Representa um estado.

**Atributos:**
- `id`: Identificador único
- `name`: Nome do estado
- `acronym`: Sigla do estado (ex: SP, RJ)
- Campos de timestamps padrão

**Associações:**
- `has_many :cities`: Tem várias cidades

### Controllers

#### `Companies::RegistrationsController`
Responsável por gerenciar o fluxo de cadastro de empresas.

**Ações:**
- `new`: Renderiza o formulário inicial (etapa 1)
- `create`: Processa os dados da etapa 1 e redireciona para etapa 2
- `step_2`: Renderiza o formulário da etapa 2
- `save_step_2`: Processa os dados da etapa 2 e redireciona para etapa 3
- `step_3`: Renderiza o formulário da etapa 3
- `save_step_3`: Processa os dados da etapa 3 e redireciona para etapa 4
- `step_4`: Renderiza o formulário da etapa 4
- `complete`: Processa os dados finais, cria o administrador e finaliza o cadastro

### Services

#### `CompanyRegistrationService`
Serviço para gerenciar o processo de cadastro de empresas.

**Métodos:**
- `initialize_registration(params)`: Inicia o processo de registro com dados básicos
- `update_company_details(company_id, params)`: Atualiza os detalhes da empresa (etapa 2)
- `create_office(company_id, params)`: Cria um escritório para a empresa (etapa 3)
- `complete_registration(company_id, admin_params)`: Finaliza o cadastro e cria o administrador

#### `CnpjValidationService`
Serviço para validar CNPJs, possivelmente integrando com APIs externas.

**Métodos:**
- `validate(cnpj)`: Valida o formato e dígitos verificadores do CNPJ
- `fetch_company_info(cnpj)`: Busca informações da empresa através do CNPJ (integração com API externa)

### Regras de Negócio

1. **Validação de Email Corporativo**
   - O email deve ser válido (formato correto)
   - Não pode ser um email de domínio público (gmail.com, hotmail.com, etc.)
   - Não pode estar associado a uma empresa já cadastrada

2. **Validação de CNPJ**
   - O CNPJ deve ser válido (formato e dígitos verificadores)
   - Não pode estar associado a uma empresa já cadastrada
   - Opcionalmente, pode verificar se o CNPJ existe na Receita Federal

3. **Progresso do Cadastro**
   - O usuário pode interromper o cadastro a qualquer momento
   - Os dados parciais são salvos para permitir continuação posterior
   - Um token único é gerado para identificar o cadastro parcial

4. **Senhas**
   - Deve ter pelo menos 8 caracteres
   - Deve incluir letras e números
   - Confirmação de senha deve corresponder à senha original

5. **Administrador Inicial**
   - Toda empresa deve ter pelo menos um administrador
   - O administrador inicial é criado durante o cadastro (etapa 4)
   - O administrador tem permissões para gerenciar a empresa e adicionar outros funcionários

6. **Limitações**
   - Inicialmente, define-se um limite padrão de usuários (max_users)
   - Este limite pode ser ajustado posteriormente pelo time comercial do Foome

### Integrações

1. **API de Validação de CNPJ**
   - Integração opcional com APIs como ReceitaWS ou Serpro para validação de CNPJ

2. **API de CEP**
   - Integração com serviços como ViaCEP para preenchimento automático de endereços

3. **E-mail**
   - Envio de email de boas-vindas após cadastro completo
   - Envio de email para continuação de cadastro interrompido

### Fluxo de Dados na Aplicação Rails

1. **Iniciando o Cadastro**
   - O usuário acessa /companies/sign_up
   - O sistema renderiza o formulário da etapa 1
   - O usuário preenche email, CNPJ e cidade
   - O sistema valida os dados e cria registros temporários

2. **Etapas Sequenciais**
   - Os dados são salvos em sessions ou cookies entre etapas
   - Alternativamente, os registros no banco são marcados como "pendentes"
   - Cada etapa possui validações específicas

3. **Finalização**
   - Na etapa final, cria-se o usuário administrador com Devise
   - A empresa é marcada como "cadastrada" (onboarding_completed)
   - O usuário é autenticado automaticamente
   - Redirecionamento para o painel da empresa

### Testes

Os seguintes tipos de testes devem ser implementados:

1. **Testes de Modelo**
   - Validações de Company, Office e Employee
   - Associações entre os modelos
   - Callbacks e métodos personalizados

2. **Testes de Controller**
   - Fluxo completo de cadastro
   - Validações em cada etapa
   - Redirecionamentos
   - Manipulação de sessões

3. **Testes de Integração/Sistema**
   - Fluxo de cadastro completo com Capybara
   - Validações de formulário no lado do cliente
   - Comportamento responsivo

4. **Testes de Serviço**
   - Validação de CNPJ
   - Integração com APIs externas
   - Criação de registros relacionados

## Considerações de Implementação

### Gerenciamento de Estado

Para o fluxo de wizard multi-etapas, considere as seguintes abordagens:

1. **Armazenamento em Sessão**
   - Salvar dados temporários na sessão do usuário entre etapas
   - Limpar a sessão após conclusão ou abandono

2. **Registros Temporários**
   - Criar registros no banco com flag de "incompleto"
   - Gerar token único para recuperação do cadastro

3. **Turbo Frames**
   - Utilizar Turbo Frames para transições suaves entre etapas
   - Manter o estado do formulário com Stimulus

### Validação em Tempo Real

- Implementar validações instantâneas com Stimulus para feedback imediato
- Validar CNPJ e email no lado do cliente antes do envio
- Buscar CEP e preencher campos de endereço automaticamente

### Segurança

- Implementar proteção contra ataques CSRF (built-in no Rails)
- Limitar tentativas de cadastro por IP para evitar abusos
- Validar permissões e tokens em cada etapa do processo
- Certificar-se de que dados sensíveis são transmitidos com segurança
