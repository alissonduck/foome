Abaixo está um guia detalhado para desenvolver as funcionalidades do MVP para restaurantes no sistema **Foome**, utilizando **Supabase** como backend. O guia inclui histórias de usuário, tabelas de banco de dados, fluxos, critérios de aceite, regras de negócio e outras informações necessárias.

Esta aplicação está sendo criada com **Supabase**, **Supabase Auth**, **Supabase Functions** e **Supabase Storage** como backend para a criação deste MVP.

---

## **1. Fluxo de Cadastro, Login e Onboarding de Restaurantes**

### **História de Usuário**
- **Título:** "Como restaurante, quero me cadastrar na plataforma para acessar os recursos da Foome."
- **Descrição:** O restaurante deve poder se cadastrar usando o Supabase Auth e preencher informações básicas durante o onboarding.
- **Critérios de Aceite:**
  - O cadastro deve ser realizado via email e senha ou autenticação social (Google).
  - Após o login, o restaurante deve ser redirecionado para o onboarding.
  - Durante o onboarding, o restaurante deve preencher informações básicas (nome, endereço, etc.) que serão salvos nas tabelas `PartnerUsers` e `Partner`.

### **Tabelas de Banco de Dados**
```sql
-- Tabela PartnerUsers
CREATE TABLE "PartnerUsers" (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    partner_id INT REFERENCES "Partner"(id),
    role VARCHAR(50) DEFAULT 'admin',
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Partner
CREATE TABLE "Partner" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    google_infos JSONB,
    city_id INT REFERENCES "City"(id),
    employee_count_range VARCHAR(50),
    category VARCHAR(50),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Fluxo**
1. O restaurante acessa a página de cadastro/login.
2. O Supabase Auth gerencia o cadastro/login.
3. Após o login, o restaurante é redirecionado para o onboarding.
4. Durante o onboarding:
   - O restaurante insere o nome e endereço.
   - A API do Google Maps (via RapidAPI) busca e preenche automaticamente informações como horários de funcionamento, avaliações, etc.
5. As informações são salvas nas tabelas `PartnerUsers` e `Partner`.

---

## **2. Fluxo de Configurações do Restaurante**

### **História de Usuário**
- **Título:** "Como restaurante, quero configurar minhas informações para que os clientes tenham acesso a dados atualizados."
- **Descrição:** O restaurante deve poder editar informações como horários de funcionamento, endereço, categoria e outros detalhes.
- **Critérios de Aceite:**
  - O restaurante pode editar suas informações na tabela `Partner`.
  - As alterações devem ser refletidas imediatamente no perfil do restaurante.

### **Regras de Negócio**
- Somente usuários com perfil `admin` podem editar as configurações.
- Os dados do Google Maps devem ser usados como sugestão inicial, mas o restaurante pode sobrescrever.

### **Fluxo**
1. O restaurante acessa a página de configurações.
2. Visualiza e edita informações como:
   - Nome
   - Endereço
   - Horários de funcionamento
   - Categoria
3. As alterações são salvas na tabela `Partner`.

---

## **3. Fluxo de Criação e Gestão de Vouchers**

### **História de Usuário**
- **Título:** "Como restaurante, quero criar e gerenciar vouchers para atrair mais clientes."
- **Descrição:** O restaurante deve poder criar vouchers com diferentes tipos (`discount`, `fixed_value`, `item`) e definir condições de uso (`valid_from`, `valid_to`, `days_of_week`, `time_range`, `min_purchase`).
- **Critérios de Aceite:**
  - O restaurante pode criar vouchers com os tipos `discount`, `fixed_value` e `item`.
  - O restaurante pode definir condições como `valid_from`, `valid_to`, `days_of_week`, `time_range` e `min_purchase`.
  - Os vouchers devem ser salvos na tabela `Voucher` e estar disponíveis para visualização e edição.

---

### **Regras de Negócio**

#### **Tipos de Vouchers**
1. **Discount (Desconto Percentual):**
   - **Fórmula:** `discount_amount = original_price * (value / 100)`
   - **Exemplo:** Um voucher de "10% de desconto" aplicado em uma compra de R$ 100 resulta em um desconto de R$ 10.
   - **Restrições:**
     - O valor percentual (`value`) deve estar entre 1% e 100%.
     - Não pode ser combinado com outros vouchers do tipo `discount`.

2. **Fixed Value (Desconto Fixo):**
   - **Fórmula:** `final_price = original_price - value`
   - **Exemplo:** Um voucher de "R$ 20 de desconto" aplicado em uma compra de R$ 100 resulta em um preço final de R$ 80.
   - **Restrições:**
     - O valor fixo (`value`) não pode exceder o valor total da compra.
     - Não pode ser combinado com outros vouchers do tipo `fixed_value`.

3. **Item (Item Gratuito):**
   - **Funcionamento:** O cliente recebe um item gratuito ao realizar a compra.
   - **Exemplo:** Um voucher de "Um refrigerante grátis" permite que o cliente escolha um refrigerante específico sem custo adicional.
   - **Restrições:**
     - O item gratuito deve ser selecionado pelo restaurante durante a criação do voucher.
     - O item gratuito não pode ser trocado por outro produto ou dinheiro.

---

### **Tabelas de Banco de Dados**
```sql
CREATE TABLE "Voucher" (
    id SERIAL PRIMARY KEY,
    partner_id INT REFERENCES "Partner"(id),
    subsidiary_partner_id INT REFERENCES "SubsidiaryPartners"(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    value DECIMAL(10, 2),
    min_purchase DECIMAL(10, 2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    days_of_week JSONB,
    time_range JSONB,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

#### **Condições de Uso**
1. **Validade (`valid_from` e `valid_to`):**
   - O voucher só pode ser utilizado dentro do intervalo de datas especificado.
   - **Regra:** Se a data atual estiver fora do intervalo, o voucher é considerado inválido.

2. **Dias da Semana (`days_of_week`):**
   - O voucher só pode ser usado em dias específicos da semana.
   - **Formato:** Array JSON com os dias permitidos (e.g., `["Monday", "Wednesday", "Friday"]`).
   - **Regra:** O sistema verifica se o dia atual está incluído no array.

3. **Horário de Uso (`time_range`):**
   - O voucher só pode ser usado em horários específicos.
   - **Formato:** Objeto JSON com início e fim do intervalo (e.g., `{"start": "12:00", "end": "15:00"}`).
   - **Regra:** O sistema verifica se o horário atual está dentro do intervalo.

4. **Valor Mínimo de Compra (`min_purchase`):**
   - O voucher só pode ser usado se o valor total da compra atender ao mínimo especificado.
   - **Regra:** Se o valor da compra for menor que `min_purchase`, o voucher é considerado inválido.

---

### **Fluxo Detalhado**

#### **1. Acesso à Página de Criação de Vouchers**
- O restaurante acessa a página de criação de vouchers através do painel administrativo.
- A página apresenta um formulário com campos para preencher as informações do voucher.

#### **2. Seleção do Tipo de Voucher**
- O restaurante seleciona o tipo de voucher:
  - **Discount:** Informa o valor percentual (`value`).
  - **Fixed Value:** Informa o valor fixo (`value`).
  - **Item:** Seleciona o item gratuito (e.g., "Refrigerante", "Sobremesa").
- O sistema valida o tipo de voucher selecionado e ajusta os campos do formulário conforme necessário.

#### **3. Definição das Condições de Uso**
- O restaurante define as condições de uso:
  - **Validade (`valid_from` e `valid_to`):** Seleciona as datas de início e término.
  - **Dias da Semana (`days_of_week`):** Seleciona os dias permitidos.
  - **Horário de Uso (`time_range`):** Define o intervalo de horário.
  - **Valor Mínimo de Compra (`min_purchase`):** Informa o valor mínimo (opcional).

#### **4. Salvamento do Voucher**
- O sistema valida todas as informações inseridas:
  - Verifica se o tipo de voucher e as condições de uso estão corretamente preenchidos.
  - Salva o voucher na tabela `Voucher` com os seguintes campos:
    ```sql
    INSERT INTO "Voucher" (
        partner_id,
        subsidiary_partner_id,
        name,
        description,
        type,
        value,
        min_purchase,
        valid_from,
        valid_to,
        days_of_week,
        time_range,
        active
    ) VALUES (...);
    ```

---

## **4. Fluxo de Criação e Gestão de Programas de Fidelidade**

### **História de Usuário**
- **Título:** "Como restaurante, quero criar programas de fidelidade para engajar clientes."
- **Descrição:** O restaurante deve poder criar programas de fidelidade com diferentes objetivos (`purchase_count`, `total_spent`, `cus) e definir recompensas para incentivar o engajamento dos clientes.
- **Critérios de Aceite:**
  - O restaurante pode criar programas com objetivos como `purchase_count`, `total_spent`.
  - O programa deve ter uma data de início (`valid_from`) e término (`valid_to`).
  - As recompensas devem ser configuráveis e registradas na tabela `LoyaltyRewards`.
  - O sistema deve calcular automaticamente o progresso dos clientes em relação aos objetivos do programa.

---

### **Regras de Negócio**

#### **Tipos de Objetivos**
1. **Purchase Count (Número de Compras):**
   - **Funcionamento:** O cliente deve realizar um número específico de compras para ganhar a recompensa.
   - **Exemplo:** "Ganhe uma recompensa após 10 compras."
   - **Fórmula:**  
     ```sql
     current_progress = COUNT(transactions) WHERE user_id = X AND transaction_date BETWEEN valid_from AND valid_to;
     ```
   - **Restrições:**
     - O número mínimo de compras (`goal_value`) deve ser maior que zero.
     - Apenas transações válidas dentro do período do programa são contabilizadas.

2. **Total Spent (Valor Total Gasto):**
   - **Funcionamento:** O cliente deve gastar um valor total acumulado para ganhar a recompensa.
   - **Exemplo:** "Ganhe uma recompensa após gastar R$ 500."
   - **Fórmula:**  
     ```sql
     current_progress = SUM(final_price) FROM transactions WHERE user_id = X AND transaction_date BETWEEN valid_from AND valid_to;
     ```
   - **Restrições:**
     - O valor acumulado (`goal_value`) deve ser maior que zero.
     - Apenas transações válidas dentro do período do programa são contabilizadas.

---

#### **Recompensas**
- **Tipos de Recompensas:**
  1. **Desconto Fixo:** Um desconto fixo em reais para a próxima compra.
  2. **Item Gratuito:** Um item gratuito oferecido pelo estabelecimento.
  3. **Cashback:** Um percentual do valor gasto retornado ao cliente.
  4. **Experiência Exclusiva:** Uma experiência especial, como um jantar exclusivo ou acesso VIP.

- **Regras de Recompensas:**
  - Cada recompensa deve estar vinculada a um programa de fidelidade específico.
  - O valor da recompensa (`reward_value`) deve ser positivo.
  - O custo da recompensa (`investment`) deve ser calculado para o restaurante.

---

#### **Validade do Programa**
- **Datas de Início e Término (`valid_from` e `valid_to`):**
  - O programa só é válido dentro do intervalo de datas especificado.
  - Após a data de término (`valid_to`), o programa é automaticamente desativado.
  - **Regra:** Se a data atual estiver fora do intervalo, o programa não estará disponível para novos progressos.

---

### **Fluxo Detalhado**

#### **1. Acesso à Página de Criação de Programas de Fidelidade**
- O restaurante acessa a página de criação de programas de fidelidade através do painel administrativo.
- A página apresenta um formulário com campos para preencher as informações do programa.

#### **2. Definição do Objetivo**
- O restaurante seleciona o tipo de objetivo:
  - **Purchase Count:** Informa o número de compras necessário (`goal_value`).
  - **Total Spent:** Informa o valor total acumulado necessário (`goal_value`).
- O sistema valida o tipo de objetivo selecionado e ajusta os campos do formulário conforme necessário.

#### **3. Configuração das Recompensas**
- O restaurante define as recompensas que serão concedidas ao cliente ao alcançar o objetivo.
  - **Tipo de Recompensa:** Desconto fixo, item gratuito, cashback, etc.
  - **Valor da Recompensa:** Valor ou percentual associado à recompensa.
  - **Descrição da Recompensa:** Texto explicativo para o cliente.
- O sistema registra as recompensas na tabela `LoyaltyRewards`.

#### **4. Salvamento do Programa**
- O sistema valida todas as informações inseridas:
  - Verifica se o tipo de objetivo e as recompensas estão corretamente preenchidos.
  - Salva o programa na tabela `LoyaltyProgram` com os seguintes campos:
    ```sql
    INSERT INTO "LoyaltyProgram" (
        partner_id,
        subsidiary_partner_id,
        name,
        description,
        goal_type,
        goal_value,
        valid_from,
        valid_to,
        active
    ) VALUES (...);
    ```

#### **5. Visualização e Edição dos Programas**
- Após salvar, o programa aparece em uma lista de programas criados.
- O restaurante pode:
  - Visualizar os detalhes do programa.
  - Editar as informações do programa.
  - Ativar/Desativar o programa.

---

### **Critérios de Validação**

1. **Validação de Dados:**
   - O tipo de objetivo (`goal_type`) deve ser um dos valores permitidos: `purchase_count`, `total_spent`.
   - O valor do objetivo (`goal_value`) deve ser positivo e respeitar as restrições específicas de cada tipo.
   - As datas (`valid_from` e `valid_to`) devem ser válidas e `valid_from` deve ser anterior a `valid_to`.

2. **Validação de Progresso:**
   - O sistema calcula automaticamente o progresso dos clientes em relação ao objetivo.
   - Exibe mensagens claras sobre o status do progresso (e.g., "Você está a 3 compras de ganhar sua recompensa").

---

### **Exemplo Prático**

#### **Criação de um Programa de Fidelidade**
- **Nome:** "Fidelidade 10x"
- **Objetivo:** `purchase_count`
- **Valor do Objetivo:** 10 compras
- **Validade:** De 01/11/2023 a 30/11/2023
- **Recompensa:** Desconto de R$ 20 na próxima compra

#### **Progresso do Cliente**
- Um cliente realiza 8 compras durante o período do programa.
- O sistema calcula o progresso:
  ```sql
  current_progress = COUNT(transactions) WHERE user_id = X AND transaction_date BETWEEN '2023-11-01' AND '2023-11-30';
  ```
- O cliente recebe uma notificação: "Você está a 2 compras de ganhar seu desconto de R$ 20!"

---


#### **5. Visualização e Edição dos Vouchers**
- Após salvar, o voucher aparece em uma lista de vouchers criados.
- O restaurante pode:
  - Visualizar os detalhes do voucher.
  - Editar as informações do voucher.
  - Ativar/Desativar o voucher.

---

### **Critérios de Validação**

1. **Validação de Dados:**
   - O tipo de voucher (`type`) deve ser um dos valores permitidos: `discount`, `fixed_value`, `item`.
   - O valor (`value`) deve ser positivo e respeitar as restrições específicas de cada tipo.
   - As datas (`valid_from` e `valid_to`) devem ser válidas e `valid_from` deve ser anterior a `valid_to`.
   - O array `days_of_week` deve conter apenas dias válidos.
   - O intervalo `time_range` deve ter um horário de início anterior ao horário de término.

2. **Validação de Uso:**
   - O sistema verifica automaticamente se o voucher atende às condições de uso antes de permitir seu uso.
   - Exibe mensagens de erro claras caso o voucher seja inválido (e.g., "Este voucher não pode ser usado hoje").

---

### **Exemplo Prático**

#### **Criação de um Voucher**
- **Nome:** "Desconto de 10%"
- **Tipo:** `discount`
- **Valor:** 10%
- **Validade:** De 01/11/2023 a 30/11/2023
- **Dias da Semana:** Segunda, Quarta, Sexta
- **Horário de Uso:** Das 12:00 às 15:00
- **Valor Mínimo de Compra:** R$ 50

#### **Uso do Voucher**
- Um cliente realiza uma compra de R$ 100 às 13:00 de uma quarta-feira.
- O sistema verifica:
  - Data: Dentro do intervalo de validade.
  - Dia da semana: Permitido.
  - Horário: Dentro do intervalo.
  - Valor mínimo: Atendido.
- O desconto é aplicado: `discount_amount = 100 * (10 / 100) = R$ 10`.

---

## **5. Fluxo de Criação de Subsidiary Partners**

### **História de Usuário**
- **Título:** "Como administrador de um restaurante, quero criar filiais para gerenciar múltiplos estabelecimentos."
- **Descrição:** O restaurante principal deve poder criar e gerenciar filiais (`SubsidiaryPartners`).
- **Critérios de Aceite:**
  - Somente usuários com perfil `admin` podem criar filiais.
  - Cada filial pode ter múltiplos usuários associados.

### **Tabelas de Banco de Dados**
```sql
CREATE TABLE "SubsidiaryPartners" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    partner_id INT REFERENCES "Partner"(id),
    google_infos JSONB,
    city_id INT REFERENCES "City"(id),
    employee_count_range VARCHAR(50),
    category VARCHAR(50),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **Fluxo**
1. O administrador acessa a página de criação de filiais.
2. Insere informações básicas da filial.
3. Salva a filial na tabela `SubsidiaryPartners`.

---

## **6. Dashboard com Dados do Parceiro**

### **História de Usuário**
- **Título:** "Como restaurante, quero visualizar métricas para medir o ROI da plataforma."
- **Descrição:** O restaurante deve ter acesso a um dashboard com métricas como número de vouchers utilizados, receita gerada, descontos concedidos, etc.
- **Critérios de Aceite:**
  - O dashboard exibe gráficos e tabelas com métricas relevantes.
  - As métricas incluem: número de vouchers utilizados, receita gerada, descontos concedidos, volume de uso mensal, etc.

### **Fluxo**
1. O restaurante acessa o dashboard.
2. Visualiza métricas em tempo real, como:
   - Número de vouchers utilizados.
   - Receita gerada.
   - Descontos concedidos.
   - Gráficos de uso mensal.
3. Os dados são obtidos das tabelas `VoucherUsed`, `LoyaltyProgress` e outras.

---