# Arquitetura da Aplicação - Foome

## Visão Geral

foome é uma aplicação Ruby on Rails 8.0.3 que implementa um SaaS Enabled Marketplace B2B que é um benefício para funcionários de empresas.

## Boas práticas

O objetivo é criar uma aplicação escalável, modular e fácil de manter, seguindo princípios como DRY (Don't Repeat Yourself), Clean Code e design limpo.

- Documente todos os arquivos criados com comentários em cada função, método, classe, componente e input e output de dados. Precisamos que cada arquivo seja auto explicativo com seus respectivos comentários.
- Desenvolva o frontend de forma componentizada utilizando TailwindCSS V4, ERB e ViewComponent, com componentes pequenos e com responsabilidade única.
- Obrigatoriamente utilize SRP (Single Responsability Principle) em todos os arquivos criados.
- Obrigatoriamente utilize DRY (Dont Repeat Yourself) em todos os arquivos criados.
- Obrigatoriamente utilize Clean Code e Design Limpo.
- Construa a aplicação pensando na escala futura, seguindo boas práticas de performance.

## Stack Tecnológica

- **Backend**: Ruby on Rails 8.0.3 com Ruby 3.4.2 (Estas versões já estão disponíveis neste momento - Qualquer dúvida pesquise na @Web).
- **Banco de Dados**: PostgreSQL
- **Frontend**: HTML/ERB, TailwindCSS V4, ViewComponent, Hotwire com Turbo e Stimulus.
- **Autenticação**: Devise
- **Autorização**: Pundit
- **Processamento em Background**: SolidQueue
- **Armazenamento de Arquivos**: Active Storage + Backblaze (Driver AWS S3)
- **Gráficos**: Chart.js