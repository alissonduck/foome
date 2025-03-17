# Guia completo das funcionalidades do MVP - Empresas

Este documento descreve todas as funcionalidades, user stories, regras de negócio, fluxos de dados, serviços, CRUDs e métricas da plataforma Foome para Empresas e Estabelecimentos.

Ele serve como um guia para os desenvolvedores implementarem o código necessário para que o produto funcione corretamente para o fluxo de Empresas e Estabelecimentos (Partners).

---

## **1. Autenticação e Autorização**

### **1.1 Login de Usuários (Funcionários e Estabelecimentos)**

- **User Story:**
    
    Como usuário (funcionário de empresa ou responsável por estabelecimento), quero fazer login no sistema para acessar as funcionalidades específicas para meu perfil.
    
- **Regras de Negócio:**
    - O sistema utiliza Supabase Auth como backend para login, através do schema "auth".
    - O sistema autentica o usuário com base no `email` e `password` ou via autenticação social (Google).
    - Após a autenticação, o sistema gera um token JWT (`access_token`) válido por 24 horas.
    - O sistema identifica o tipo de usuário (funcionário ou estabelecimento) através do campo `type` nos metadados do usuário.
    - Baseado no tipo, o usuário é redirecionado para o dashboard apropriado.
- **Modelos Utilizados:**
    - `Employee` (para funcionários)
    - `PartnerUsers` (para usuários de estabelecimentos)
- **Serviços:**
    - `AuthService.signInWithPassword(email, password)`
    - `AuthService.signInWithGoogle()`
- **CRUDs:**
    - `EmployeeCRUD.getByUserId(userId)`
    - `PartnerUserCRUD.getByUserId(userId)`

---

### **1.2 Registro de Novos Usuários**

#### **1.2.1 Registro de Funcionários**

- **User Story:**
    
    Como administrador de uma empresa, quero registrar novos usuários (funcionários) no sistema para que eles possam acessar suas respectivas áreas.
    
- **Regras de Negócio:**
    - O sistema valida se o `email` já está registrado no schema "auth" e tabela "users" e se o usuário pertence à "Company" correta.
    - O sistema criptografa a senha antes de armazená-la no banco de dados.
    - Os funcionários são associados à empresa através da tabela `Employee`.
- **Modelos Utilizados:**
    - `Employee` (para funcionários)
- **Serviços:**
    - `AuthService.register_user(user_data)`
- **CRUDs:**
    - `EmployeeCRUD.create(data)`

#### **1.2.2 Registro de Estabelecimentos (Partners)**

- **User Story:**
    
    Como proprietário de um estabelecimento, quero me cadastrar na plataforma para oferecer vouchers e promoções aos clientes.
    
- **Regras de Negócio:**
    - O registro é realizado em múltiplas etapas (multi-step form).
    - O sistema verifica se o email já está cadastrado e, caso esteja, direciona para o login.
    - O sistema cria um registro na tabela `Partner` e associa o usuário a este parceiro na tabela `PartnerUsers`.
    - O usuário recebe o papel (role) de "owner" por padrão.
    - O parceiro começa como inativo (`active: false`) até completar o onboarding.
    - As informações de perfil do WhatsApp são armazenadas no cadastro do usuário, e não mais no cadastro do estabelecimento.
- **Fluxo de Registro:**
    1. **Step 0**: Dados pessoais (nome, email, senha, WhatsApp, aceite de termos)
    2. **Step 1**: Dados do estabelecimento (nome, CNPJ, cidade, bairro, Instagram)
    3. **Step 2**: Informações adicionais (categorias, características, tipos de culinária, capacidade)
    4. **Step 3**: Integração com Google Maps (busca e seleção do estabelecimento)
    5. **Step 4**: Horários de funcionamento (configuração de dias e horários)
    6. **Step 5**: Integração com Instagram (perfil e informações complementares)
- **Modelos Utilizados:**
    - `Partner` (estabelecimento)
    - `PartnerUsers` (relação usuário-estabelecimento)
    - `PartnerCategory` (categorias do estabelecimento)
    - `PartnerCharacteristic` (características do estabelecimento)
    - `PartnerCuisine` (tipos de culinária)
- **Serviços:**
    - `AuthService.signUp(email, password, userData)`
    - `PartnerService.createPartner(partnerData)`
    - `PartnerService.updatePartner(id, partnerData)`
    - `CategoryService.savePartnerCategories(partnerId, categoryIds)`
    - `CharacteristicService.savePartnerCharacteristics(partnerId, characteristicIds)`
    - `CuisineTypeService.savePartnerCuisineTypes(partnerId, cuisineTypeIds)`

---



---

## **2. Gestão de Empresas e Estabelecimentos**

### **2.1 Cadastro de Funcionários**

- **User Story:**
    
    Como administrador de uma empresa, quero cadastrar funcionários para que eles possam utilizar os benefícios da plataforma.
    
- **Regras de Negócio:**
    - O sistema valida se o `cpf` e email já estão registrados.
    - Cada funcionário está associado a uma empresa (`company_id`).
    - Opcionalmente, um funcionário pode estar associado a um escritório (`office_id`) e a um time (`team_id`).
- **Modelos Utilizados:**
    - `Employee`
- **Serviços:**
    - `EmployeeService.createEmployee(employeeData)`
- **CRUDs:**
    - `EmployeeCRUD.create(data)`

### **2.2 Gestão de Estabelecimentos**

- **User Story:**
    
    Como administrador de um estabelecimento, quero gerenciar minhas informações, horários e serviços para oferecer aos clientes.
    
- **Regras de Negócio:**
    - Um estabelecimento pode ter múltiplos usuários administradores (owner, admin, etc.)
    - As informações do Google Places são armazenadas em `google_infos` como JSON.
    - Os horários de funcionamento são armazenados em `days_of_week` como um objeto JSON estruturado.
    - As informações do Instagram são armazenadas em `instagram_infos`.
    - O estabelecimento só fica ativo após completar o onboarding (`onboarding_completed: true`).
- **Modelos Utilizados:**
    - `Partner`
    - `PartnerUsers`
    - `PartnerCategory`
    - `PartnerCharacteristic`
    - `PartnerCuisine`
- **Serviços:**
    - `PartnerService.getPartnerDetails(partnerId)`
    - `PartnerService.updatePartner(partnerId, data)`
    - `PartnerService.activatePartner(partnerId)`
    - `PartnerService.deactivatePartner(partnerId)`

### **2.3 Gestão de Escritórios (Sedes)**

- **User Story:**
    
    Como administrador de uma empresa, quero cadastrar escritórios (sedes) para organizar os endereços das empresas.
    
- **Regras de Negócio:**
    - Um escritório pertence a uma empresa (`company_id`).
    - O campo `google_infos` armazena informações geográficas (ex.: latitude, longitude, endereço formatado).
    - O campo `city_id` vincula o escritório a uma cidade específica.
- **Funcionalidade:**
    - Rota: `/offices`
        - Método: `POST`
        - Descrição: Cria um novo escritório no sistema.
        - Entrada:
            
            ```json
            {
              "name": "string",
              "google_infos": "JSON",
              "city_id": "int",
              "company_id": "int"
            }
            
            ```
            
        - Saída: `{ "message": "Escritório criado com sucesso.", "office_id": int }`
- **Modelos Utilizados:**
    - `Office`
- **Serviços:**
    - `OfficeService.createOffice(officeData)`
- **CRUDs:**
    - `OfficeCRUD.create(data)`
    - `OfficeCRUD.create(data)`

---

### **3.2 Listagem de Escritórios**

- **User Story:**
    
    Como administrador de uma empresa, quero listar todos os escritórios cadastrados para visualizar suas informações.
    
- **Funcionalidade:**
    - Rota: `/offices`
        - Método: `GET`
        - Descrição: Lista todos os escritórios cadastrados no sistema.
        - Saída: `[ { "id": int, "name": string, "city_id": int, ... } ]`
- **Modelos Utilizados:**
    - `Office`
- **Serviços:**
    - `OfficeService.list_offices()`
- **CRUDs:**
    - `OfficeCRUD.get_all()`

---

## **4. Vouchers para Funcionários**

### **4.1 Validação de Vouchers**

- **User Story:**
    
    Como funcionário, quero visualizar os vouchers disponíveis e validar se posso utilizá-los no momento atual.
    
- **Regras de Negócio:**
    - O voucher deve estar ativo (`active = TRUE`).
    - A data atual deve estar dentro do período de validade (`valid_from <= today <= valid_to`).
    - O dia da semana e o horário devem corresponder às configurações (`days_of_week` e `time_range`).
    - Se houver um valor mínimo de compra (`min_purchase`), o sistema deve garantir que o valor da compra atenda ao requisito.
- **Funcionalidade:**
    - Rota: `/vouchers/{voucher_id}/validate`
        - Método: `GET`
        - Descrição: Valida se um voucher pode ser utilizado com base nas condições configuradas.
        - Entrada: `{ "voucher_id": int }`
        - Saída:
            
            ```json
            {
              "valid": bool,
              "reason": string // Motivo caso inválido (ex.: "Fora do período de validade")
            }
            
            ```
            
- **Modelos Utilizados:**
    - `Voucher`
- **Serviços:**
    - `VoucherService.validate_voucher(voucher_id, employee_id)`
- **CRUDs:**
    - `VoucherCRUD.get_by_id(voucher_id)`

---

### **4.2 Uso de Voucher**

- **User Story:**
    
    Como funcionário, quero utilizar um voucher em um estabelecimento parceiro para obter descontos ou benefícios.
    
- **Regras de Negócio:**
    - **Validação do Voucher:**
        - O sistema deve verificar se o voucher existe e está ativo antes de permitir o uso.
        - O voucher já está ativado por padrão, não precisando de código de ativação.
    - **Cálculo de Desconto:**
        - Para vouchers do tipo `discount`:
            - O desconto é calculado como uma porcentagem do valor total da compra.
            - Fórmula: `discount_amount = original_price * (voucher.discount_percent / 100)`.
            - Fórmula final: `final_price = original_price - discount_amount`.
        - Para vouchers do tipo `fixed_value`:
            - O desconto é um valor fixo subtraído do total.
            - Fórmula: `final_price = original_price - voucher.discount_value`.
        - Para vouchers do tipo `item`:
            - O item gratuito é registrado como parte da transação.
            - O valor final da compra permanece inalterado.
    - **Registro do Uso:**
        - O sistema deve registrar o uso do voucher, incluindo o valor original, o desconto aplicado e o valor final.
- **Funcionalidade:**
    - Rota: `/vouchers/use`
        - Método: `POST`
        - Descrição: Registra o uso de um voucher.
        - Entrada:
            
            ```json
            {
              "voucher_id": "int",
              "employee_id": "int",
              "partner_id": "int", // Estabelecimento onde foi usado
              "purchase_value": "decimal" // Valor total da compra
            }
            
            ```
            
        - Saída: 
        
            ```json
            {
              "success": true,
              "data": {
                "id": "int",
                "voucher_id": "int",
                "employee_id": "int",
                "partner_id": "int",
                "purchase_value": "decimal",
                "discount_value": "decimal",
                "used_at": "timestamp"
              },
              "message": "Voucher utilizado com sucesso"
            }
            ```
- **Modelos Utilizados:**
    - `Voucher`
    - `VoucherUsed`
    - `Employee`
    - `Partner`
- **Serviços:**
    - `VoucherService.use_voucher(voucher_id, employee_id, partner_id, value)`
- **CRUDs:**
    - `VoucherUsedCRUD.create(data)`

---

## **5. Programas de Fidelidade para Funcionários**

### **5.1 Progresso nos Programas de Fidelidade**

- **User Story:**
    
    Como funcionário, quero acompanhar meu progresso em programas de fidelidade para saber quando receberei minha recompensa.
    
- **Regras de Negócio:**
    - **Rastreamento de Progresso:**
        - Para `purchase_count`, o sistema incrementa o contador a cada compra válida.
        - Para `total_spent`, o sistema soma o valor final das compras (`final_price`).
    - **Conclusão do Programa:**
        - Quando o usuário atinge o objetivo (`current_progress >= goal_value`), o campo `completed` é atualizado para `TRUE`.
        - O sistema deve notificar o usuário sobre a conclusão do programa.
- **Funcionalidade:**
    - Rota: `/loyalty-progress/{employee_id}`
        - Método: `GET`
        - Descrição: Exibe o progresso do funcionário em programas de fidelidade.
        - Entrada: `{ "employee_id": int }`
        - Saída:
            
            ```json
            [
              {
                "loyalty_program_id": int,
                "program_name": string,
                "goal_type": string,
                "goal_value": int,
                "current_progress": int,
                "completed": bool,
                "reward_claimed": bool
              }
            ]
            
            ```
            
- **Modelos Utilizados:**
    - `LoyaltyProgress`
    - `LoyaltyProgram`
- **Serviços:**
    - `LoyaltyProgramService.get_progress(employee_id)`
- **CRUDs:**
    - `LoyaltyProgressCRUD.get_by_employee(employee_id)`

---

### **5.2 Resgate de Recompensas**

- **User Story:**
    
    Como funcionário, quero resgatar minha recompensa após completar um programa de fidelidade.
    
- **Regras de Negócio:**
    - **Verificação de Elegibilidade:**
        - O sistema deve verificar se o usuário concluiu o programa (`completed = TRUE`).
        - O sistema deve verificar se a recompensa já foi resgatada (`reward_claimed = FALSE`).
    - **Registro do Resgate:**
        - Após o resgate, o campo `reward_claimed` deve ser atualizado para `TRUE`.
        - O sistema deve registrar o resgate na tabela `LoyaltyRewards`.
- **Funcionalidade:**
    - Rota: `/loyalty-rewards/{loyalty_program_id}/claim`
        - Método: `POST`
        - Descrição: Registra o resgate de uma recompensa.
        - Entrada: `{ "employee_id": int, "loyalty_program_id": int }`
        - Saída: `{ "message": "Recompensa resgatada com sucesso." }`
- **Modelos Utilizados:**
    - `LoyaltyProgress`
    - `LoyaltyRewards`
- **Serviços:**
    - `LoyaltyProgramService.claim_reward(employee_id, loyalty_program_id)`
- **CRUDs:**
    - `LoyaltyProgressCRUD.update_reward_status(employee_id, loyalty_program_id)`
    - `LoyaltyRewardsCRUD.create(data)`

---

## **6. Avaliações**

### **6.1 Envio de Avaliações**

- **User Story:**
    
    Como funcionário, quero avaliar um estabelecimento após usar um voucher.
    
- **Regras de Negócio:**
    - A avaliação deve incluir uma nota (`score`) entre 1 e 5.
    - O feedback (`feedback`) é opcional, mas recomendado.
- **Funcionalidade:**
    - Rota: `/reviews`
        - Método: `POST`
        - Descrição: Envia uma avaliação para um estabelecimento.
        - Entrada: `{ "employee_id": int, "partner_id": int, "score": int, "feedback": string }`
        - Saída: `{ "message": string }`
- **Modelos Utilizados:**
    - `Reviews`
- **Serviços:**
    - `ReviewService.submit_review(review_data)`
- **CRUDs:**
    - `ReviewCRUD.create(data)`

---

## **7. Notificações para Funcionários**

### **7.1 Preferências de Comunicação dos Usuários**

- **User Story:**
    
    Como funcionário, quero configurar minhas preferências de comunicação para decidir se desejo receber e-mails e/ou push notifications.
    
- **Regras de Negócio:**
    - O sistema deve permitir que os usuários escolham se desejam receber e-mails (`receive_emails`) e/ou push notifications (`receive_push`).
    - O campo `preferred_time` permite que o usuário defina um horário preferido para receber notificações (opcional).
- **Funcionalidade:**
    - Rota: `/communication/preferences`
        - Método: `PUT`
        - Descrição: Atualiza as preferências de comunicação de um usuário.
        - Entrada:
            
            ```json
            {
              "user_id": "int",
              "receive_emails": "boolean", // TRUE/FALSE
              "receive_push": "boolean", // TRUE/FALSE
              "preferred_time": "time" // Horário preferido (opcional)
            }
            
            ```
            
        - Saída: `{ "message": "Preferências de comunicação atualizadas com sucesso." }`
- **Modelos Utilizados:**
    - `UserCommunicationPreferences`
- **Serviços:**
    - `CommunicationService.update_preferences(user_id, preferences_data)`
- **CRUDs:**
    - `UserCommunicationPreferencesCRUD.update(data)`

---

## **8. Estrutura de Implementação**

### **8.1 Tabelas e Colunas do Banco de Dados**

```sql
-- Tabela Company (Empresa)
CREATE TABLE "Company" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    google_infos JSONB,
    city_id INT REFERENCES "City"(id),
    vr_va_value NUMERIC,
    max_users INTEGER,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Employee (Funcionário)
CREATE TABLE "Employee" (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    company_id INT REFERENCES "Company"(id),
    birth_date DATE,
    internal_id INTEGER,
    salary NUMERIC,
    team_id INT REFERENCES "Team"(id),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Team (Equipe)
CREATE TABLE "Team" (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES "Company"(id),
    manager_id INT REFERENCES "Employee"(id),
    name VARCHAR(255) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Office (Escritório)
CREATE TABLE "Office" (
    id SERIAL PRIMARY KEY,
    company_id INT REFERENCES "Company"(id),
    subsidiary_companies_id INT,
    city_id INT REFERENCES "City"(id),
    google_infos JSONB,
    name VARCHAR(255) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Voucher
CREATE TABLE "Voucher" (
    id SERIAL PRIMARY KEY,
    partner_id INT REFERENCES "Partner"(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(20) NOT NULL,
    value NUMERIC,
    min_purchase NUMERIC,
    valid_from DATE,
    valid_to DATE,
    days_of_week JSONB,
    time_range JSONB,
    item_sale_price NUMERIC,
    item_cost NUMERIC,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela VoucherUsed
CREATE TABLE "VoucherUsed" (
    id SERIAL PRIMARY KEY,
    voucher_id INT REFERENCES "Voucher"(id),
    partner_id INT REFERENCES "Partner"(id),
    employee_id INT REFERENCES "Employee"(id),
    original_price DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    final_price DECIMAL(10, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela LoyaltyProgram
CREATE TABLE "LoyaltyProgram" (
    id SERIAL PRIMARY KEY,
    partner_id INT REFERENCES "Partner"(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    goal_type VARCHAR(20) NOT NULL,
    goal_value INTEGER,
    valid_from DATE,
    valid_to DATE,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela LoyaltyProgress
CREATE TABLE "LoyaltyProgress" (
    id SERIAL PRIMARY KEY,
    loyalty_program_id INT REFERENCES "LoyaltyProgram"(id),
    employee_id INT REFERENCES "Employee"(id),
    current_progress INTEGER DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    reward_claimed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela LoyaltyRewards
CREATE TABLE "LoyaltyRewards" (
    id SERIAL PRIMARY KEY,
    loyalty_program_id INT REFERENCES "LoyaltyProgram"(id),
    reward_type VARCHAR(20),
    reward_value NUMERIC,
    investment NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Reviews
CREATE TABLE "Reviews" (
    id SERIAL PRIMARY KEY,
    partner_id INT REFERENCES "Partner"(id),
    employee_id INT REFERENCES "Employee"(id),
    voucher_used_id INT REFERENCES "VoucherUsed"(id),
    score SMALLINT NOT NULL CHECK (score BETWEEN 1 AND 5),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Partner
CREATE TABLE "Partner" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    google_infos JSONB,
    city_id INT REFERENCES "City"(id),
    reservations BOOLEAN,
    terms_accepted BOOLEAN,
    chairs INTEGER,
    days_of_week JSONB,
    instagram_infos JSONB,
    onboarding_completed BOOLEAN,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela City
CREATE TABLE "City" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    state_id INT REFERENCES "State"(id)
);

-- Tabela State
CREATE TABLE "State" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    acronym CHAR(2) NOT NULL
);
```

### **8.2 Estrutura de Arquivos e Pastas**

```
src/
├── components/
│   ├── company/
│   │   ├── auth/
│   │   │   ├── LoginForm.tsx
│   │   │   └── RegisterForm.tsx
│   │   ├── employees/
│   │   │   ├── EmployeeForm.tsx
│   │   │   ├── EmployeeList.tsx
│   │   │   └── EmployeeCard.tsx
│   │   ├── offices/
│   │   │   ├── OfficeForm.tsx
│   │   │   ├── OfficeList.tsx
│   │   │   └── OfficeCard.tsx
│   │   ├── vouchers/
│   │   │   ├── VoucherList.tsx
│   │   │   ├── VoucherCard.tsx
│   │   │   └── VoucherUsageForm.tsx
│   │   ├── loyalty/
│   │   │   ├── LoyaltyProgressList.tsx
│   │   │   ├── LoyaltyProgramCard.tsx
│   │   │   └── RewardClaimModal.tsx
│   │   ├── reviews/
│   │   │   ├── ReviewForm.tsx
│   │   │   └── ReviewsList.tsx
│   │   └── communication/
│   │       └── CommunicationPreferencesForm.tsx
│   └── partner/
│       └── ... // Componentes para parceiros
├── context/
│   ├── company/
│   │   ├── AuthContext.tsx
│   │   ├── EmployeeContext.tsx
│   │   └── NotificationContext.tsx
│   └── partner/
│       └── ... // Contextos para parceiros
├── hooks/
│   ├── company/
│   │   ├── useAuth.ts
│   │   ├── useEmployee.ts
│   │   ├── useVoucher.ts
│   │   ├── useLoyalty.ts
│   │   └── useReviews.ts
│   └── partner/
│       └── ... // Hooks para parceiros
├── integrations/
│   └── supabase/
│       ├── supabaseClient.ts
│       └── supabaseAuth.ts
├── lib/
│   ├── utils.ts
│   └── constants.ts
├── pages/
│   ├── company/
│   │   ├── auth/
│   │   │   ├── Login.tsx
│   │   │   ├── Register.tsx
│   │   │   └── ForgotPassword.tsx
│   │   ├── admin/
│   │   │   ├── Dashboard.tsx
│   │   │   ├── Employees.tsx
│   │   │   └── Offices.tsx
│   │   └── employee/
│   │       ├── Dashboard.tsx
│   │       ├── Reviews.tsx
│   │       └── Profile.tsx
│   └── partner/
│       └── ... // Páginas para parceiros
├── services/
│   ├── company/
│   │   ├── AuthService.ts
│   │   ├── EmployeeService.ts
│   │   ├── OfficeService.ts
│   │   ├── VoucherService.ts
│   │   ├── LoyaltyProgramService.ts
│   │   ├── ReviewService.ts
│   │   └── CommunicationService.ts
│   └── partner/
│       └── ... // Serviços para parceiros
├── crud/
│   ├── company/
│   │   ├── EmployeeCRUD.ts
│   │   ├── OfficeCRUD.ts
│   │   ├── VoucherCRUD.ts
│   │   ├── VoucherUsedCRUD.ts
│   │   ├── LoyaltyProgressCRUD.ts
│   │   ├── LoyaltyRewardsCRUD.ts
│   │   └── ReviewCRUD.ts
│   └── partner/
│       └── ... // CRUD para parceiros
└── types/
    ├── company/
    │   ├── employee.ts
    │   ├── office.ts
    │   ├── voucher.ts
    │   ├── loyalty.ts
    │   └── review.ts
    └── partner/
        └── ... // Tipos para parceiros
```

### **8.3 Implementação de Serviços Principais**

#### **8.3.1 AuthService.ts**

```typescript
import { supabase } from '../../../integrations/supabase/supabaseClient';

export interface RegisterUserData {
  email: string;
  password: string;
  company_id: number;
  name: string;
  role: string;
  office_id: number;
}

export interface LoginResponse {
  success: boolean;
  data?: {
    user: any;
    employee: any;
  };
  message?: string;
  error?: string;
}

export const AuthService = {
  /**
   * Registra um novo funcionário no sistema
   * @param {RegisterUserData} userData - Dados do funcionário para registro
   * @returns {Promise} - Promessa com resultado da operação
   */
  async register(userData: RegisterUserData) {
    try {
      // Primeiro cria o usuário com autenticação
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: userData.email,
        password: userData.password
      });

      if (authError) throw authError;
      
      // Agora cria o registro do funcionário
      const { data: employeeData, error: employeeError } = await supabase
        .from('Employee')
        .insert({
          user_id: authData.user.id,
          company_id: userData.company_id,
          name: userData.name,
          email: userData.email,
          role: userData.role,
          office_id: userData.office_id
        });
      
      if (employeeError) throw employeeError;
      
      return {
        success: true,
        data: employeeData,
        message: 'Registro realizado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao registrar usuário:', error);
      return {
        success: false,
        error: error.message || 'Erro ao registrar usuário'
      };
    }
  },

  /**
   * Realiza o login do funcionário
   * @param {string} email - Email do funcionário
   * @param {string} password - Senha do funcionário
   * @returns {Promise<LoginResponse>} - Promessa com resultado da operação
   */
  async login(email: string, password: string): Promise<LoginResponse> {
    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password
      });
      
      if (error) throw error;
      
      // Busca informações adicionais do funcionário
      const { data: employeeData, error: employeeError } = await supabase
        .from('Employee')
        .select('*, Company(*), Office(*)')
        .eq('user_id', data.user.id)
        .single();
      
      if (employeeError) throw employeeError;
      
      return {
        success: true,
        data: {
          user: data.user,
          employee: employeeData
        },
        message: 'Login realizado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao fazer login:', error);
      return {
        success: false,
        error: error.message || 'Erro ao fazer login'
      };
    }
  },

  /**
   * Encerra a sessão do funcionário
   * @returns {Promise} - Promessa com resultado da operação
   */
  async logout() {
    try {
      const { error } = await supabase.auth.signOut();
      
      if (error) throw error;
      
      return {
        success: true,
        message: 'Logout realizado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao fazer logout:', error);
      return {
        success: false,
        error: error.message || 'Erro ao fazer logout'
      };
    }
  }
};
```

#### **8.3.2 EmployeeService.ts**

```typescript
import { supabase } from '../../../integrations/supabase/supabaseClient';

export interface EmployeeUpdateData {
  name?: string;
  role?: string;
  office_id?: number;
  active?: boolean;
}

export const EmployeeService = {
  /**
   * Busca todos os funcionários de uma empresa
   * @param {number} company_id - ID da empresa
   * @returns {Promise} - Promessa com resultado da operação
   */
  async getAllByCompany(company_id: number) {
    try {
      const { data, error } = await supabase
        .from('Employee')
        .select('*, Office(*)')
        .eq('company_id', company_id);
      
      if (error) throw error;
      
      return {
        success: true,
        data: data,
        message: 'Funcionários recuperados com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao buscar funcionários:', error);
      return {
        success: false,
        error: error.message || 'Erro ao buscar funcionários'
      };
    }
  },

  /**
   * Busca um funcionário pelo ID
   * @param {number} id - ID do funcionário
   * @returns {Promise} - Promessa com resultado da operação
   */
  async getById(id: number) {
    try {
      const { data, error } = await supabase
        .from('Employee')
        .select('*, Company(*), Office(*)')
        .eq('id', id)
        .single();
      
      if (error) throw error;
      
      return {
        success: true,
        data: data,
        message: 'Funcionário recuperado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao buscar funcionário:', error);
      return {
        success: false,
        error: error.message || 'Erro ao buscar funcionário'
      };
    }
  },

  /**
   * Atualiza os dados de um funcionário
   * @param {number} id - ID do funcionário
   * @param {EmployeeUpdateData} userData - Novos dados do funcionário
   * @returns {Promise} - Promessa com resultado da operação
   */
  async update(id: number, userData: EmployeeUpdateData) {
    try {
      const { data, error } = await supabase
        .from('Employee')
        .update({
          name: userData.name,
          role: userData.role,
          office_id: userData.office_id,
          active: userData.active
        })
        .eq('id', id)
        .select()
        .single();
      
      if (error) throw error;
      
      return {
        success: true,
        data: data,
        message: 'Funcionário atualizado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao atualizar funcionário:', error);
      return {
        success: false,
        error: error.message || 'Erro ao atualizar funcionário'
      };
    }
  },

  /**
   * Remove um funcionário
   * @param {number} id - ID do funcionário
   * @returns {Promise} - Promessa com resultado da operação
   */
  async delete(id: number) {
    try {
      // Desativa o funcionário em vez de excluir
      const { data, error } = await supabase
        .from('Employee')
        .update({ active: false })
        .eq('id', id);
      
      if (error) throw error;
      
      return {
        success: true,
        message: 'Funcionário desativado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao desativar funcionário:', error);
      return {
        success: false,
        error: error.message || 'Erro ao desativar funcionário'
      };
    }
  }
};
```

#### **8.3.3 VoucherService.ts**

```typescript
import { supabase } from '../../../integrations/supabase/supabaseClient';

interface VoucherValidationResult {
  valid: boolean;
  reason?: string;
}

export const VoucherService = {
  /**
   * Busca todos os vouchers disponíveis para um funcionário
   * @param {number} employee_id - ID do funcionário
   * @returns {Promise} - Promessa com resultado da operação
   */
  async getAvailableForEmployee(employee_id: number) {
    try {
      // Primeiro obtém a empresa do funcionário
      const { data: employee, error: employeeError } = await supabase
        .from('Employee')
        .select('company_id')
        .eq('id', employee_id)
        .single();
      
      if (employeeError) throw employeeError;
      
      // Agora busca os vouchers disponíveis para a empresa do funcionário
      const { data: vouchers, error: vouchersError } = await supabase
        .from('Voucher')
        .select('*, Partner(*)')
        .eq('company_id', employee.company_id)
        .eq('active', true)
        .gte('valid_until', new Date().toISOString().split('T')[0]);
      
      if (vouchersError) throw vouchersError;
      
      // Filtra os vouchers já utilizados pelo funcionário
      const { data: usedVouchers, error: usedError } = await supabase
        .from('VoucherUsed')
        .select('voucher_id')
        .eq('employee_id', employee_id);
      
      if (usedError) throw usedError;
      
      const usedVoucherIds = usedVouchers.map(v => v.voucher_id);
      const availableVouchers = vouchers.filter(v => !usedVoucherIds.includes(v.id));
      
      return {
        success: true,
        data: availableVouchers,
        message: 'Vouchers disponíveis recuperados com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao buscar vouchers disponíveis:', error);
      return {
        success: false,
        error: error.message || 'Erro ao buscar vouchers disponíveis'
      };
    }
  },

  /**
   * Registra o uso de um voucher
   * @param {number} voucher_id - ID do voucher
   * @param {number} employee_id - ID do funcionário
   * @param {number} partner_id - ID do parceiro onde o voucher foi usado
   * @param {number} value - Valor da compra
   * @returns {Promise} - Promessa com resultado da operação
   */
  async use_voucher(voucher_id: number, employee_id: number, partner_id: number, value: number) {
    try {
      // Verifica se o voucher existe e está ativo
      const { data: voucher, error: voucherError } = await supabase
        .from('Voucher')
        .select('*')
        .eq('id', voucher_id)
        .eq('active', true)
        .single();
      
      if (voucherError) throw new Error('Voucher não encontrado ou inativo');
      
      // Verifica se o voucher está no período de validade
      const today = new Date().toISOString().split('T')[0];
      if (voucher.valid_from && voucher.valid_from > today) {
        throw new Error('Voucher ainda não está válido');
      }
      
      if (voucher.valid_until && voucher.valid_until < today) {
        throw new Error('Voucher já expirou');
      }
      
      // Verifica se o funcionário já utilizou este voucher
      const { data: usedVoucher, error: usedError } = await supabase
        .from('VoucherUsed')
        .select('*')
        .eq('voucher_id', voucher_id)
        .eq('employee_id', employee_id);
      
      if (usedError) throw usedError;
      
      if (usedVoucher && usedVoucher.length > 0) {
        throw new Error('Este voucher já foi utilizado por você');
      }
      
      // Calcula o desconto com base no tipo de voucher
      let discount_value = 0;
      
      switch (voucher.type) {
        case 'discount':
          discount_value = value * (voucher.discount_percent / 100);
          break;
        case 'fixed_value':
          discount_value = Math.min(voucher.discount_value, value);
          break;
        case 'item':
          discount_value = voucher.item_price || 0;
          break;
        default:
          discount_value = 0;
      }
      
      // Registra o uso do voucher
      const { data, error } = await supabase
        .from('VoucherUsed')
        .insert({
          voucher_id,
          employee_id,
          partner_id,
          used_at: new Date().toISOString(),
          purchase_value: value,
          discount_value
        })
        .select();
      
      if (error) throw error;
      
      return {
        success: true,
        data: {
          ...data[0],
          discount_value
        },
        message: 'Voucher utilizado com sucesso'
      };
    } catch (error: any) {
      console.error('Erro ao utilizar voucher:', error);
      return {
        success: false,
        error: error.message || 'Erro ao utilizar voucher'
      };
    }
  },

  /**
   * Valida se um voucher pode ser usado
   * @param {number} voucher_id - ID do voucher
   * @param {number} employee_id - ID do funcionário
   * @returns {Promise<VoucherValidationResult>} - Promessa com resultado da validação
   */
  async validate_voucher(voucher_id: number, employee_id: number): Promise<VoucherValidationResult> {
    try {
      // Verifica se o voucher existe e está ativo
      const { data: voucher, error: voucherError } = await supabase
        .from('Voucher')
        .select('*')
        .eq('id', voucher_id)
        .eq('active', true)
        .single();
      
      if (voucherError) return { valid: false, reason: 'Voucher não encontrado ou inativo' };
      
      // Verifica se está no período de validade
      const today = new Date();
      const todayStr = today.toISOString().split('T')[0];
      
      if (voucher.valid_from && voucher.valid_from > todayStr) {
        return { valid: false, reason: 'Voucher ainda não está válido' };
      }
      
      if (voucher.valid_until && voucher.valid_until < todayStr) {
        return { valid: false, reason: 'Voucher já expirou' };
      }
      
      // Verifica se é um dia da semana permitido
      if (voucher.allowed_days) {
        const weekday = today.getDay(); // 0 = Domingo, 1 = Segunda, ..., 6 = Sábado
        const allowedDays = voucher.allowed_days.split(',').map(d => parseInt(d));
        
        if (!allowedDays.includes(weekday)) {
          return { valid: false, reason: 'Voucher não é válido para este dia da semana' };
        }
      }
      
      // Verifica se está dentro do intervalo de horas permitido
      if (voucher.start_time && voucher.end_time) {
        const currentHour = today.getHours();
        const currentMinute = today.getMinutes();
        const currentTimeInMinutes = (currentHour * 60) + currentMinute;
        
        const [startHour, startMinute] = voucher.start_time.split(':').map(n => parseInt(n));
        const [endHour, endMinute] = voucher.end_time.split(':').map(n => parseInt(n));
        
        const startTimeInMinutes = (startHour * 60) + startMinute;
        const endTimeInMinutes = (endHour * 60) + endMinute;
        
        if (currentTimeInMinutes < startTimeInMinutes || currentTimeInMinutes > endTimeInMinutes) {
          return { valid: false, reason: 'Voucher não é válido para este horário' };
        }
      }
      
      // Verifica se o funcionário já utilizou este voucher
      const { data: usedVoucher, error: usedError } = await supabase
        .from('VoucherUsed')
        .select('*')
        .eq('voucher_id', voucher_id)
        .eq('employee_id', employee_id);
      
      if (usedError) throw usedError;
      
      if (usedVoucher && usedVoucher.length > 0) {
        return { valid: false, reason: 'Este voucher já foi utilizado por você' };
      }
      
      return { valid: true };
    } catch (error: any) {
      console.error('Erro ao validar voucher:', error);
      return { valid: false, reason: 'Erro ao validar voucher: ' + error.message };
    }
  }
};
```

## **9. Integração com Serviços Externos**

### **9.1 Google Places API**

- **User Story:**
    
    Como estabelecimento, quero integrar meu negócio com o Google Places para importar informações precisas como endereço, avaliações e horários.
    
- **Regras de Negócio:**
    - A integração é feita durante o cadastro no Step 3.
    - As informações do Google Places são armazenadas no formato JSON no campo `google_infos`.
    - O ID do lugar no Google (place_id) é armazenado separadamente para referência futura.
- **Fluxo de Integração:**
    1. O usuário pesquisa o nome do estabelecimento.
    2. A API retorna os estabelecimentos correspondentes.
    3. O usuário seleciona o estabelecimento correto.
    4. Os dados são importados e salvos no banco de dados.
- **Dados Importados:**
    - Nome do estabelecimento
    - Endereço completo
    - Coordenadas geográficas
    - Número de telefone
    - Website
    - Avaliações (rating)
    - Horários de funcionamento
    - Tipo de estabelecimento

### **9.2 Instagram API**

- **User Story:**
    
    Como estabelecimento, quero integrar meu perfil do Instagram para exibir minhas publicações e informações na plataforma.
    
- **Regras de Negócio:**
    - A integração é feita durante o cadastro no Step 5.
    - As informações do Instagram são armazenadas no formato JSON no campo `instagram_infos`.
    - O usuário fornece seu nome de usuário do Instagram para a integração.
- **Dados Importados:**
    - Nome do perfil
    - Biografia
    - Número de seguidores
    - Número de seguidos
    - Foto do perfil
    - Publicações recentes
    - Categoria do perfil

## **10. Considerações Finais e Diretrizes de Desenvolvimento**

### **9.1 Prioridades de Implementação**

Para o desenvolvimento eficiente do MVP, recomenda-se seguir a seguinte ordem de prioridade:

1. **Autenticação e Cadastro**: Implementar o sistema de autenticação e cadastro de empresas e funcionários.
2. **Gestão de Empresas e Escritórios**: Configurar o gerenciamento de empresas e seus escritórios.
3. **Vouchers**: Implementar o sistema de vouchers, incluindo listagem e uso direto nos estabelecimentos.
4. **Programas de Fidelidade**: Desenvolver o sistema de programas de fidelidade e resgate de recompensas.
5. **Avaliações**: Configurar o sistema de avaliações.
6. **Notificações**: Implementar o sistema de notificações e preferências de comunicação.

### **9.2 Práticas Recomendadas**

#### **9.2.1 Padrões de Código**
- Seguir os princípios DRY (Don't Repeat Yourself) e KISS (Keep It Simple, Stupid).
- Utilizar comentários descritivos para documentar o código.
- Implementar validações consistentes em todas as entradas de dados.
- Utilizar um sistema de log para registrar erros e eventos importantes.

#### **9.2.2 Segurança**
- Implementar autenticação segura utilizando as funcionalidades nativas do Supabase.
- Validar todas as entradas de dados no frontend e backend.
- Utilizar Row Level Security (RLS) do PostgreSQL/Supabase para proteger os dados.
- Implementar um sistema de permissões baseado em função para diferentes níveis de acesso.

#### **9.2.3 Integração com Supabase**
- Utilizar a biblioteca cliente oficial do Supabase para React que já está instalada no projeto.
- Aproveitar as funcionalidades integradas do Supabase:
  - Autenticação e gerenciamento de usuários
  - Armazenamento de arquivos
  - Consultas em tempo real
  - Funções Edge para lógica específica do servidor

#### **9.2.4 Performance**
- Implementar paginação para listagens com muitos itens.
- Otimizar consultas ao banco de dados utilizando índices apropriados.
- Utilizar Supabase para consultas em tempo real apenas quando necessário.
- Implementar cache de dados quando apropriado para reduzir o número de requisições.

### **9.3 Testes**

Recomenda-se implementar os seguintes tipos de testes:

- **Testes unitários**: Para componentes e funções individuais.
- **Testes de integração**: Para verificar a interação entre diferentes partes do sistema.
- **Testes de usuário**: Para validar fluxos completos de usuário.

### **9.4 Documentação**

Manter a documentação atualizada é essencial para o desenvolvimento contínuo:

- Documentar APIs utilizando padrões como Swagger/OpenAPI.
- Manter diagramas de entidade-relacionamento (ER) atualizados.
- Documentar fluxos de usuário para cada funcionalidade.
- Criar e manter um guia de estilo para componentes visuais.

### **9.5 Escalabilidade**

O MVP foi projetado pensando em escalabilidade futura:

- A estrutura modular permite adicionar novas funcionalidades sem grandes impactos.
- O modelo de dados é flexível para acomodar novos requisitos.
- A arquitetura baseada em Supabase permite escalar verticalmente (aumentando recursos) e horizontalmente (distribuindo carga).

### **9.6 Próximos Passos após o MVP**

Depois da implementação do MVP, considerar:

- Implementação de dashboards e análises avançadas.
- Expansão das integrações com outros serviços.
- Personalização avançada das comunicações.
- Implementação de funcionalidades adicionais de gamificação.
- Desenvolvimento de aplicativos móveis nativos.

---

Este guia serve como referência para o desenvolvimento do MVP do módulo Empresas do Foome. Seguindo estas diretrizes e implementando as funcionalidades descritas, será possível criar uma solução robusta e escalável que atenda às necessidades das empresas parceiras e seus funcionários.
