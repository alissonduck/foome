# Documentação de Billing para SaaS B2B

Este documento descreve as **regras de negócio** e **fluxo de implementação** da funcionalidade de billing (cobrança) para nosso SaaS B2B.  
Abaixo, você encontrará:

1. [Visão Geral](#visao-geral)
2. [Estrutura de Dados (Banco de Dados)](#estrutura-de-dados)
3. [Regras de Negócio](#regras-de-negocio)
4. [Fluxo de Funcionamento](#fluxo-de-funcionamento)
5. [Casos Específicos](#casos-especificos)
6. [Exemplo de Pró-rata](#exemplo-de-pro-rata)
7. [Eventos de Assinatura e Métricas de Receita](#eventos-de-assinatura-e-metricas-de-receita)
8. [FAQ / Dúvidas Frequentes](#faq--duvidas-frequentes)

---

## 1. Visão Geral

Nosso SaaS B2B utiliza **faixas de usuários** (planos) para determinar o valor a ser cobrado de cada empresa. Cada empresa (tabela `company`) possui uma **assinatura** (`subscriptions`), que determina:

- **Quantidade de usuários** contratados.
- **Faixa de plano** em que se enquadra (mínimo de usuários, máximo, valor por usuário e possível ticket mínimo).
- **Tipo de pagamento** (mensal, anual à vista ou anual em 12x).
- **Dia de cobrança** (normalmente dia 1, mas flexível para grandes empresas).

A cada ciclo (mensal ou anual), geramos uma **fatura** (`invoices`) para a empresa. Cada fatura pode ter itens detalhados em `invoice_items`. Os pagamentos são controlados em `payments`, integrados com o gateway brasileiro **Asaas**.

---

## 2. Estrutura de Dados

### 2.1. Tabela `plan_tiers`

| Coluna           | Tipo              | Descrição                                                                                                      |
|------------------|-------------------|-----------------------------------------------------------------------------------------------------------------|
| `id`             | `UUID`           | Identificador único da faixa de plano (chave primária).                                                         |
| `name`           | `VARCHAR(255)`   | Nome da faixa/plano (e.g. "Faixa 1 a 50 usuários").                                                             |
| `min_users`      | `INT`            | Quantidade mínima de usuários nessa faixa.                                                                      |
| `max_users`      | `INT`            | Quantidade máxima de usuários nessa faixa.                                                                      |
| `price_per_user` | `NUMERIC(10,2)`  | Preço unitário por usuário para esta faixa.                                                                     |
| `min_monthly_fee`| `NUMERIC(10,2)`  | Ticket mínimo mensal. Caso `(user_count * price_per_user) < min_monthly_fee`, cobra-se `min_monthly_fee`.       |
| `active`         | `BOOLEAN`        | Indica se a faixa de plano está ativa para novas assinaturas.                                                  |
| `created_at`     | `TIMESTAMP TZ`   | Data/hora de criação do registro.                                                                               |
| `updated_at`     | `TIMESTAMP TZ`   | Data/hora de última atualização do registro.                                                                    |

**Observações**:
- As faixas de usuários podem ser cadastradas, por exemplo:
  - Faixa 1: de 1 a 50 usuários = R\$ 14,90 por user, com `min_monthly_fee = 299`.
  - Faixa 2: de 51 a 100 usuários = R\$ 13,90 por user, etc.
- A coluna `active` ajuda a manter histórico (caso alguma faixa seja descontinuada).

---

### 2.2. Tabela `subscriptions`

| Coluna              | Tipo            | Descrição                                                                                                     |
|---------------------|-----------------|---------------------------------------------------------------------------------------------------------------|
| `id`                | `UUID`         | Identificador único da assinatura (chave primária).                                                           |
| `company_id`        | `UUID`         | Referência à tabela `company` (empresa). Identifica qual empresa possui esta assinatura.                      |
| `plan_tier_id`      | `UUID`         | Referência à tabela `plan_tiers`. Indica qual faixa de plano está sendo usada para esta assinatura.           |
| `user_count`        | `INT`          | Quantidade de usuários contratados pela empresa nessa assinatura.                                            |
| `subscription_type` | `VARCHAR(50)`  | Pode ser: `'monthly'`, `'annual'` ou `'annual_12x'`.                                                          |
| `billing_day`       | `INT`          | Dia do mês para cobrança. Padrão = 1, mas pode ser outro valor para grandes empresas.                         |
| `start_date`        | `DATE`         | Data de início da assinatura.                                                                                 |
| `end_date`          | `DATE`         | Data de término da assinatura (pode ser NULL se for renovável automaticamente).                               |
| `active`            | `BOOLEAN`      | Se `TRUE`, a assinatura está ativa; se `FALSE`, foi cancelada ou não está mais em vigor.                      |
| `created_at`        | `TIMESTAMP TZ` | Data/hora de criação do registro.                                                                             |
| `updated_at`        | `TIMESTAMP TZ` | Data/hora de última atualização do registro.                                                                  |

**Observações**:
- O campo `end_date` pode ser **opcional** em assinaturas mensais contínuas.  
- No **cancelamento**, a assinatura deve continuar ativa até o fim do período já pago. Após essa data, definimos `active = FALSE` ou atualizamos `end_date`.

---

### 2.3. Tabela `invoices`

| Coluna             | Tipo            | Descrição                                                                                                                  |
|--------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------|
| `id`               | `UUID`         | Identificador único da fatura (chave primária).                                                                            |
| `subscription_id`  | `UUID`         | Referência opcional à tabela `subscriptions`. Geralmente associada à assinatura que gerou esta fatura.                    |
| `company_id`       | `UUID`         | Referência à tabela `company`. Indica diretamente qual empresa está recebendo esta fatura.                                |
| `period_start`     | `DATE`         | Data inicial do período que a fatura cobre (e.g. `2025-03-01`).                                                           |
| `period_end`       | `DATE`         | Data final do período que a fatura cobre (e.g. `2025-03-31`).                                                             |
| `user_count`       | `INT`          | Quantidade de usuários cobrados neste invoice (snapshot no momento da geração).                                           |
| `unit_price`       | `NUMERIC(10,2)`| Valor unitário por usuário para esta fatura (snapshot do momento da geração).                                             |
| `total_amount`     | `NUMERIC(10,2)`| Valor total da fatura (aplicando ticket mínimo se necessário).                                                            |
| `status`           | `VARCHAR(50)`  | Status da fatura: `'pending'`, `'paid'`, `'canceled'`, etc.                                                               |
| `payment_method`   | `VARCHAR(50)`  | Método de pagamento selecionado para esta fatura: `'pix'`, `'credit_card'`, etc.                                          |
| `due_date`         | `DATE`         | Data de vencimento da fatura.                                                                                             |
| `paid_at`          | `TIMESTAMP TZ` | Data/hora em que o pagamento foi efetivado, se houver.                                                                    |
| `nf_number`        | `VARCHAR(50)`  | Número da Nota Fiscal emitida após confirmação de pagamento.                                                              |
| `created_at`       | `TIMESTAMP TZ` | Data/hora de criação do registro.                                                                                         |
| `updated_at`       | `TIMESTAMP TZ` | Data/hora de última atualização do registro.                                                                              |

**Observações**:
- É **possível** que uma fatura anual tenha `period_start` e `period_end` com 12 meses de diferença.  
- Em caso de pagamento anual parcelado em 12x (cartão), podemos gerar:
  - **1 invoice anual** com 12 pagamentos associados na tabela `payments` **ou**
  - **12 invoices** mensais (depende da estratégia contábil escolhida).  

---

### 2.4. Tabela `invoice_items`

| Coluna        | Tipo            | Descrição                                                                                       |
|---------------|-----------------|-------------------------------------------------------------------------------------------------|
| `id`          | `UUID`         | Identificador único do item de fatura (chave primária).                                         |
| `invoice_id`  | `UUID`         | Referência à fatura (`invoices`).                                                               |
| `description` | `TEXT`         | Texto livre descrevendo o item (ex.: "Cobrança de 50 usuários", "Pró-rata de 10 dias", etc.).    |
| `quantity`    | `INT`          | Quantidade (ex.: 50 usuários, 10 dias, etc.).                                                   |
| `unit_price`  | `NUMERIC(10,2)`| Preço unitário para este item.                                                                  |
| `total_value` | `NUMERIC(10,2)`| Valor total do item (geralmente `quantity * unit_price`).                                       |
| `created_at`  | `TIMESTAMP TZ` | Data/hora de criação do registro.                                                               |
| `updated_at`  | `TIMESTAMP TZ` | Data/hora de última atualização do registro.                                                    |

**Observações**:
- `invoice_items` é **opcional** para quem deseja discriminar cada componente.  
- Você pode inserir **um item** para a cobrança de usuários, **outro item** para pró-rata, etc.

---

### 2.5. Tabela `payments`

| Coluna            | Tipo            | Descrição                                                                                              |
|-------------------|-----------------|--------------------------------------------------------------------------------------------------------|
| `id`              | `UUID`         | Identificador único do pagamento (chave primária).                                                     |
| `invoice_id`      | `UUID`         | Referência à fatura (`invoices`) à qual este pagamento se refere.                                      |
| `amount`          | `NUMERIC(10,2)`| Valor pago neste registro (pode ser parcial, total, etc.).                                             |
| `payment_method`  | `VARCHAR(50)`  | Ex.: `'pix'`, `'credit_card'`.                                                                         |
| `asaas_payment_id`| `VARCHAR(255)` | Identificador da transação no Asaas (gateway de pagamento).                                            |
| `status`          | `VARCHAR(50)`  | Status do pagamento: `'authorized'`, `'confirmed'`, `'failed'`, etc.                                   |
| `paid_at`         | `TIMESTAMP TZ` | Data/hora em que o pagamento foi concluído com sucesso.                                                |
| `created_at`      | `TIMESTAMP TZ` | Data/hora de criação do registro.                                                                      |
| `updated_at`      | `TIMESTAMP TZ` | Data/hora de última atualização do registro.                                                           |

**Observações**:
- Aqui **não** armazenamos dados sensíveis de cartão (PCI-DSS). Quem o faz é o Asaas.  
- Para pagamentos anuais parcelados, podemos ter:
  - 12 registros em `payments` associados a 1 `invoice`, ou  
  - 12 `invoices` diferentes, cada qual com um `payment` individual.

---

### 2.6. Tabela `subscription_events`

| Coluna            | Tipo            | Descrição                                                                                                        |
|-------------------|-----------------|------------------------------------------------------------------------------------------------------------------|
| `id`              | `UUID`         | Identificador único do evento (chave primária).                                                                  |
| `subscription_id` | `UUID`         | Referência à assinatura (`subscriptions`) onde o evento ocorreu.                                                 |
| `event_type`      | `VARCHAR(50)`  | Tipo de evento: `'new'`, `'upgrade'`, `'downgrade'`, `'churn'`, `'reactivation'`, etc.                           |
| `old_user_count`  | `INT`          | Quantidade de usuários antes da mudança (se aplicável para upgrade/downgrade).                                   |
| `new_user_count`  | `INT`          | Quantidade de usuários após a mudança (se aplicável).                                                            |
| `created_at`      | `TIMESTAMP TZ` | Data/hora em que o evento foi registrado.                                                                        |

**Observações**:
- `event_type = 'churn'` indica cancelamento da assinatura. Neste caso, lembramos que a assinatura fica ativa até o final do período pago.  
- `event_type = 'upgrade'` quando o cliente aumenta o número de usuários.  
- `event_type = 'downgrade'` quando o cliente reduz o número de usuários.  
- `event_type = 'reactivation'` se a assinatura foi inativa (após não pagamento, por exemplo) e o cliente volta a pagar.

---

## 3. Regras de Negócio

1. **Planos/Faixas de Usuários**:
   - Exemplo: Faixa de 1 a 50 usuários = R\$ 14,90 por usuário, com ticket mínimo de R\$ 299.
   - Se a multiplicação `(user_count * price_per_user)` for menor que `min_monthly_fee`, então o **valor a cobrar** é pelo menos `min_monthly_fee`.

2. **Modalidades de Pagamento**:
   - **Mensal** (`subscription_type = 'monthly'`): Gera uma fatura a cada mês.
   - **Anual à Vista** (`subscription_type = 'annual'`): Gera uma fatura com período de 12 meses.
   - **Anual Parcelado em 12x** (`subscription_type = 'annual_12x'`): Pode gerar 1 fatura anual com 12 pagamentos ou 12 faturas mensais, conforme definido na implementação.

3. **Status das Faturas (`invoices.status`)**:
   - `'pending'`: aguarda pagamento.
   - `'paid'`: pagamento recebido (ver `paid_at`).
   - `'canceled'`: fatura foi cancelada (possível reemissão ou outro arranjo).

4. **Nota Fiscal**:
   - Assim que a fatura for paga, o sistema deve emitir a NF (manualmente ou automaticamente) e gravar o número no campo `nf_number`.

5. **Pro-rata**:
   - Se o cliente entra no meio do mês (dia X) mas queremos cobrar somente até o dia 30/31, geramos um **valor pró-rata**.  
   - Pode ser inserido como um item separado em `invoice_items` (ex.: “Pró-rata de 10 dias”).

6. **Período Ativo após Cancelamento**:
   - Quando o cliente cancela, a assinatura deve **permanecer ativa até o final do período pago**. Depois disso, `active = FALSE`.  
   - No `subscription_events`, registramos um evento `event_type = 'churn'`.

7. **Upgrades & Downgrades**:
   - O cliente pode alterar o número de usuários a qualquer momento.  
   - Se for no meio do período, podemos cobrar um pró-rata adicional (upgrade) ou simplesmente ajustar na próxima fatura (downgrade).  
   - Sempre registrar o evento em `subscription_events`.

---

## 4. Fluxo de Funcionamento

1. **Criação da Assinatura**:
   - Usuário escolhe o número de usuários e o tipo de pagamento (mensal, anual, anual 12x).
   - Identificamos a **faixa de plano** (`plan_tier_id`) em que ele se enquadra (conforme `min_users` e `max_users`).
   - Criamos um registro em `subscriptions` com as informações (`user_count`, `plan_tier_id`, `subscription_type`, etc.).
   - Registramos um evento em `subscription_events` com `event_type = 'new'`.

2. **Geração de Fatura (Invoice)**:
   - **Mensal**: A cada início de mês (ou `billing_day`), geramos uma nova fatura (`invoices`) com:
     - `period_start = dia de início`
     - `period_end = dia de término` (geralmente 30/31, ou +1 mês, etc.)
     - `user_count` (snapshot do momento)
     - `unit_price` (do plan_tier atual)
     - `total_amount` (aplicando ticket mínimo se necessário)
     - `status = 'pending'`
     - `due_date` (ex.: 5 dias após emissão)
   - **Anual**: Similar, mas o `period_end` pode ser +12 meses a partir do `period_start`.

3. **Pagamento**:
   - O cliente realiza o pagamento via Pix ou cartão (integração com Asaas).
   - Recebemos do Asaas um callback (webhook) com `asaas_payment_id` e status do pagamento.
   - Gravamos o pagamento em `payments`:
     - `payment_method = 'pix'` ou `'credit_card'`
     - `status = 'confirmed'` (ou `'failed'`, etc.)
     - `paid_at = agora` se confirmado
   - Atualizamos `invoices.status = 'paid'` e `invoices.paid_at = agora`.

4. **Emissão de Nota Fiscal**:
   - Assim que o invoice for **pago**:
     - Emitimos a NF (via sistema interno ou API de NF).
     - Atualizamos `nf_number` em `invoices`.

5. **Renovação Automática**:
   - No próximo ciclo, repetimos a geração de fatura. Se for anual, após 12 meses; se mensal, a cada mês.

6. **Cancelamento**:
   - Se o cliente solicita cancelamento:
     - Registramos um evento `subscription_events` (`event_type = 'churn'`).
     - A assinatura permanece **ativa** até o final do período pago (por exemplo, até o fim do mês corrente).  
     - Após esse período, definimos `subscriptions.active = FALSE`.

---

## 5. Casos Específicos

1. **Mínimo Mensal de R\$ 299**:  
   Se `(user_count * price_per_user) < min_monthly_fee`, o `total_amount` da fatura deve ser `min_monthly_fee`.

2. **Anual Parcelado (12x)**:
   - Pode-se criar **1 fatura** com `period_start` e `period_end` de 12 meses e inserir 12 registros em `payments` (um por parcela).  
   - Ou gerar **12 faturas** mensais subsequentes, cada qual com 1 pagamento.

3. **Grandes Empresas (dia de faturamento personalizado)**:
   - Usar `billing_day` em `subscriptions`. Ex.: se `billing_day = 15`, a fatura é gerada no dia 15 de cada mês ou do período anual.

4. **Pró-rata**:
   - Calcular a fração de dias para o restante do mês.  
   - Ex.: Entrou no dia 10, até o dia 30 são 20 dias de uso. Pode gerar uma fatura parcial.  
   - Inserir esse pró-rata em `invoice_items`.

---

## 6. Exemplo de Pró-rata

**Cenário**:  
- Assinatura mensal com `price_per_user = 14,90`.  
- Empresa contratou 10 usuários, mas entrou no dia 15 do mês, e vamos cobrar apenas até dia 30 (16 dias).  
- Valor mensal inteiro seria `10 * 14,90 = R\$ 149,00`.  
- Mas, pró-rata de 16 dias de um total de 30 dias (exemplo) = `(16/30) * 149,00 ≈ R\$ 79,47`.  
- Podemos criar a fatura de pró-rata com:
  - `invoice_items.description = "Pró-rata (16 dias)"`
  - `invoice_items.quantity = 16`
  - `invoice_items.unit_price = 149,00 / 30 ≈ 4,9667`
  - `invoice_items.total_value = 16 * 4,9667 ≈ 79,47`

No próximo mês (dia 1 a dia 30), gera-se o **valor cheio** (`R\$ 149,00`).

---

## 7. Eventos de Assinatura e Métricas de Receita

Para controlar **MRR**, **novas vendas (nMRR)**, **upsell (expansion)**, **downgrade (contraction)** e **churn**:

- **`subscription_events`** registra:
  - `new` → nova venda (entra no MRR inicial).
  - `upgrade` → aumento de usuários. Pode gerar receita adicional (expansion).
  - `downgrade` → redução de usuários. (contraction).
  - `churn` → cancelamento (cliente sai do MRR).
  - `reactivation` → cliente que havia churnado, mas voltou a pagar.

Usando estes eventos, é possível levantar relatórios de MRR e churn.

---

## 8. FAQ / Dúvidas Frequentes

1. **Como lidar com o ticket mínimo?**  
   - Ao gerar a fatura, calcule `user_count * price_per_user`. Se for menor que `min_monthly_fee`, use `min_monthly_fee` como `total_amount`.

2. **Se o cliente remover usuários no meio do mês, devolvemos dinheiro?**  
   - Em geral, não. Se faz o ajuste na **próxima fatura** (downgrade).

3. **O que acontece quando o cliente não paga até o vencimento?**
   - `invoices.status` permanece `'pending'` após a `due_date`.
   - O `subscription_events` pode registrar `churn` se o cliente ficar inadimplente por X dias.

4. **Como gerenciar o pagamento anual?**  
   - `subscription_type = 'annual'` → fatura com `period_end` = `period_start + 12 meses`.  
   - Se for parcelado (`annual_12x`), decidir se serão 12 `payments` ou 12 `invoices`.

5. **Como controlar a emissão da NF?**  
   - Em `invoices.nf_number`. Após `invoices.status` = `'paid'`, integre com seu sistema de NF, gere a nota e salve o número.

---

## Conclusão

Este documento cobre todas as **regras de negócio** e a **modelagem de dados** para o sistema de billing do nosso SaaS B2B. Seguindo estes passos, os desenvolvedores terão um guia claro de como **criar**, **manter** e **evoluir** a lógica de faturamento, garantindo suporte a:

- **Planos baseados em faixas de usuários** (com ticket mínimo).  
- **Cobrança Mensal/Anual**, com possibilidade de **parcelamento**.  
- **Integração de Pagamento** via Asaas, sem armazenar dados sensíveis.  
- **Registros de Invoices e Pagamentos** para conciliação.  
- **Eventos de Assinatura** para métricas de MRR, churn, upgrades, etc.  
- **Emissão de Nota Fiscal** atrelada a cada invoice paga.  
- **Pró-rata** e datas de cobrança flexíveis.  
- **Cancelamento** com permanência ativa até o final do período pago.

Se houver qualquer dúvida adicional ou demanda de novas funcionalidades (como cupons de desconto, períodos de trial, etc.), podemos estender esta modelagem. 