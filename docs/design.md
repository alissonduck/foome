# Guia de Design da Foome

Este documento serve como referência principal para o design da plataforma Foome, implementada em Ruby on Rails com ERB, ViewComponent e TailwindCSS.

## Índice

1. [Princípios de Design](#princípios-de-design)
2. [Cores](#cores)
3. [Tipografia](#tipografia)
4. [Layouts Padrão](#layouts-padrão)
5. [Sistema de Componentes](#sistema-de-componentes)
6. [Formulários](#formulários)
7. [Estados e Feedback](#estados-e-feedback)
8. [Responsividade](#responsividade)
9. [Implementação com ViewComponent](#implementação-com-viewcomponent)
10. [Acessibilidade](#acessibilidade)

## Princípios de Design

Nossa plataforma segue estes princípios fundamentais:

- **Simplicidade**: Interfaces limpas e focadas na tarefa principal
- **Consistência**: Padrões visuais e interativos uniformes em toda a plataforma
- **Acessibilidade**: Design inclusivo para todos os usuários
- **Feedback Imediato**: Respostas claras e rápidas para ações do usuário
- **Usabilidade**: Priorizar a experiência do usuário em cada decisão de design

## Cores

### Cores Primárias

- **Foome Vermelho** - `#FF4B4B` - Cor principal da marca, usada em elementos principais, CTAs e destacados
- **Foome Cinza Escuro** - `#1F2937` - Utilizada para textos e elementos importantes

### Cores Secundárias

- **Foome Amarelo** - `#FFC107` - Usada para alertas e destaque secundário
- **Foome Verde** - `#10B981` - Usada para sucesso, confirmações e progresso

### Cores Neutras

- **Branco** - `#FFFFFF` - Fundos de cards e conteúdo principal
- **Cinza Claro** - `#F9FAFB` - Fundo de página, áreas secundárias
- **Cinza Médio** - `#6B7280` - Textos secundários, bordas, separadores
- **Cinza Escuro** - `#374151` - Textos principais

### Cores de Feedback

- **Sucesso** - `#10B981` - Notificações e indicadores de sucesso
- **Erro** - `#EF4444` - Mensagens de erro e alertas críticos
- **Alerta** - `#F59E0B` - Avisos e alertas não críticos
- **Informação** - `#3B82F6` - Mensagens informativas e dicas

### Implementação no TailwindCSS

```ruby
# tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'foome-primary': '#FF4B4B',
        'foome-dark': '#1F2937',
        'foome-yellow': '#FFC107',
        'foome-green': '#10B981',
        'foome-gray-light': '#F9FAFB',
        'foome-gray': '#6B7280',
        'foome-gray-dark': '#374151',
        'success': '#10B981',
        'error': '#EF4444',
        'warning': '#F59E0B',
        'info': '#3B82F6',
      }
    }
  }
}
```

## Tipografia

### Família de Fontes

- **Principal**: Inter - Sans-serif moderna e legível
- **Alternativa**: System UI stack - Para garantir performance

### Tamanhos

- **Título Principal (h1)**: 24px (desktop) / 20px (mobile)
- **Título Secundário (h2)**: 20px (desktop) / 18px (mobile)
- **Título Terciário (h3)**: 18px (desktop) / 16px (mobile)
- **Texto Normal**: 16px (desktop) / 14px (mobile)
- **Texto Pequeno**: 14px (desktop) / 12px (mobile)
- **Rótulos**: 14px

### Pesos

- **Regular**: 400 - Textos normais
- **Medium**: 500 - Ênfase, subtítulos
- **Semi-bold**: 600 - Títulos secundários
- **Bold**: 700 - Títulos principais, CTAs

### Classes TailwindCSS

```html
<!-- Exemplo de uso -->
<h1 class="text-2xl md:text-3xl font-bold text-foome-dark">Título Principal</h1>
<h2 class="text-xl md:text-2xl font-semibold text-foome-dark">Título Secundário</h2>
<p class="text-base text-foome-gray-dark">Texto normal para leitura.</p>
<span class="text-sm text-foome-gray">Texto secundário ou descritivo.</span>
```

## Layouts Padrão

### Estrutura Básica

Todas as páginas seguem esta estrutura básica:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <%= render "shared/head" %>
  </head>
  <body class="min-h-screen bg-foome-gray-light flex flex-col">
    <%= render "shared/navbar" %>
    
    <div class="flex flex-grow">
      <% if show_sidebar? %>
        <%= render "shared/sidebar" %>
      <% end %>
      
      <main class="flex-grow p-4 md:p-6 lg:p-8">
        <%= render "shared/header" %>
        <%= yield %>
      </main>
    </div>
    
    <%= render "shared/footer" %>
    <%= render "shared/flash" %>
  </body>
</html>
```

### Navbar

A barra de navegação superior é fixa e contém:

- Logo da Foome (esquerda)
- Menu de navegação principal (centro ou direita)
- Acesso rápido à conta e notificações (direita)

```erb
<!-- app/views/shared/_navbar.html.erb -->
<nav class="bg-white shadow-sm border-b border-gray-200">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex justify-between h-16">
      <!-- Logo -->
      <div class="flex-shrink-0 flex items-center">
        <%= link_to root_path do %>
          <%= image_tag "logo.svg", class: "h-8 w-auto", alt: "Foome" %>
        <% end %>
      </div>
      
      <!-- Links de navegação (visíveis em desktop) -->
      <div class="hidden md:ml-6 md:flex md:items-center md:space-x-4">
        <%= render "shared/nav_links" %>
      </div>
      
      <!-- Menu do usuário -->
      <div class="flex items-center">
        <%= render "shared/user_menu" %>
      </div>
    </div>
  </div>
  
  <!-- Menu mobile (expandível) -->
  <div class="md:hidden" id="mobile-menu" data-controller="mobile-menu">
    <!-- Conteúdo do menu mobile... -->
  </div>
</nav>
```

### Sidebar

O menu lateral é mostrado apenas em páginas específicas, como área do parceiro ou administração:

```erb
<!-- app/views/shared/_sidebar.html.erb -->
<aside class="w-64 bg-white shadow-sm border-r border-gray-200 hidden md:block" 
       data-controller="sidebar">
  <div class="h-full flex flex-col">
    <!-- Cabeçalho do sidebar -->
    <div class="p-4 border-b border-gray-200">
      <h2 class="text-lg font-medium text-foome-dark">Menu principal</h2>
    </div>
    
    <!-- Links de navegação -->
    <nav class="flex-1 overflow-y-auto p-4">
      <ul class="space-y-1">
        <%= render "shared/sidebar_links" %>
      </ul>
    </nav>
    
    <!-- Rodapé do sidebar (opcional) -->
    <div class="p-4 border-t border-gray-200">
      <!-- Conteúdo do rodapé... -->
    </div>
  </div>
</aside>
```

### Page Header

Cada página tem um cabeçalho consistente:

```erb
<!-- app/views/shared/_header.html.erb -->
<div class="mb-6">
  <div class="flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-bold text-foome-dark"><%= @page_title %></h1>
      <% if @page_description.present? %>
        <p class="mt-1 text-sm text-foome-gray"><%= @page_description %></p>
      <% end %>
    </div>
    
    <% if content_for?(:page_actions) %>
      <div class="flex space-x-3">
        <%= yield :page_actions %>
      </div>
    <% end %>
  </div>
</div>
```

### Footer

Rodapé simples com informações de copyright e links importantes:

```erb
<!-- app/views/shared/_footer.html.erb -->
<footer class="bg-white border-t border-gray-200 py-4">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between flex-wrap">
      <div class="flex-shrink-0">
        <p class="text-sm text-foome-gray">
          &copy; <%= Date.current.year %> Foome. Todos os direitos reservados.
        </p>
      </div>
      
      <div class="flex space-x-6">
        <%= link_to "Termos", terms_path, class: "text-sm text-foome-gray hover:text-foome-primary" %>
        <%= link_to "Privacidade", privacy_path, class: "text-sm text-foome-gray hover:text-foome-primary" %>
        <%= link_to "Contato", contact_path, class: "text-sm text-foome-gray hover:text-foome-primary" %>
      </div>
    </div>
  </div>
</footer>
```

### Flash Messages

Sistema de notificações para feedback ao usuário:

```erb
<!-- app/views/shared/_flash.html.erb -->
<div class="fixed top-4 right-4 z-50 w-full max-w-sm"
     data-controller="flash">
  <% flash.each do |type, message| %>
    <% flash_class = {
         notice: "bg-info text-white",
         success: "bg-success text-white",
         error: "bg-error text-white",
         alert: "bg-warning text-white"
       }[type.to_sym] || "bg-info text-white" %>
    
    <div class="mb-3 pointer-events-auto rounded-lg p-4 shadow-md <%= flash_class %>"
         data-flash-target="message"
         data-action="click->flash#dismiss">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <!-- Ícone conforme o tipo de mensagem -->
          <p class="ml-3"><%= message %></p>
        </div>
        <button type="button" class="text-white">
          <!-- Ícone de fechar -->
        </button>
      </div>
    </div>
  <% end %>
</div>
```

## Sistema de Componentes

### Cards

```erb
<div class="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden">
  <% if defined?(header) %>
    <div class="px-4 py-5 border-b border-gray-200 sm:px-6">
      <%= header %>
    </div>
  <% end %>
  
  <div class="px-4 py-5 sm:p-6">
    <%= content %>
  </div>
  
  <% if defined?(footer) %>
    <div class="px-4 py-4 border-t border-gray-200 sm:px-6">
      <%= footer %>
    </div>
  <% end %>
</div>
```

### Botões

```erb
<!-- Botão primário -->
<button type="button" class="bg-foome-primary hover:bg-foome-primary/90 text-white font-medium py-2 px-4 rounded-md shadow-sm">
  Botão Primário
</button>

<!-- Botão secundário -->
<button type="button" class="bg-white hover:bg-gray-50 text-foome-gray-dark font-medium py-2 px-4 border border-gray-300 rounded-md shadow-sm">
  Botão Secundário
</button>

<!-- Botão terciário -->
<button type="button" class="text-foome-primary hover:text-foome-primary/90 font-medium">
  Botão Link
</button>
```

### Badges

```erb
<!-- Badge padrão -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-foome-gray-light text-foome-gray-dark">
  Badge
</span>

<!-- Badge colorido -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-foome-primary/10 text-foome-primary">
  Badge Primário
</span>
```

### Tabs

```erb
<div class="border-b border-gray-200">
  <nav class="-mb-px flex space-x-8" aria-label="Tabs">
    <a href="#" class="border-foome-primary text-foome-primary py-4 px-1 border-b-2 font-medium text-sm">
      Tab Ativo
    </a>
    <a href="#" class="border-transparent text-foome-gray hover:text-foome-gray-dark hover:border-foome-gray py-4 px-1 border-b-2 font-medium text-sm">
      Tab Inativo
    </a>
  </nav>
</div>
```

## Formulários

### Estrutura Básica

```erb
<%= form_with model: @resource, class: "space-y-6", data: { controller: "form-validation" } do |form| %>
  <!-- Campos de formulário -->
  
  <div class="flex justify-end">
    <%= form.submit "Salvar", class: "bg-foome-primary hover:bg-foome-primary/90 text-white font-medium py-2 px-4 rounded-md shadow-sm" %>
  </div>
<% end %>
```

### Campos de Texto

```erb
<div class="space-y-1">
  <%= form.label :nome, class: "block text-sm font-medium text-foome-gray-dark" %>
  <%= form.text_field :nome, class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-foome-primary focus:border-foome-primary sm:text-sm" %>
  <% if @resource.errors[:nome].any? %>
    <p class="mt-1 text-sm text-error"><%= @resource.errors[:nome].join(", ") %></p>
  <% end %>
</div>
```

### Select

```erb
<div class="space-y-1">
  <%= form.label :categoria, class: "block text-sm font-medium text-foome-gray-dark" %>
  <%= form.select :categoria, 
                 options_for_select(categorias, @resource.categoria),
                 { include_blank: "Selecione uma categoria" },
                 { class: "mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-foome-primary focus:border-foome-primary sm:text-sm" } %>
</div>
```

### Checkboxes

```erb
<div class="relative flex items-start">
  <div class="flex items-center h-5">
    <%= form.check_box :aceito_termos, class: "h-4 w-4 text-foome-primary focus:ring-foome-primary border-gray-300 rounded" %>
  </div>
  <div class="ml-3 text-sm">
    <%= form.label :aceito_termos, class: "font-medium text-foome-gray-dark" %>
    <p class="text-foome-gray">Ao marcar esta caixa, você concorda com nossos termos de serviço.</p>
  </div>
</div>
```

## Estados e Feedback

### Loading States

```erb
<button type="button" class="bg-foome-primary text-white font-medium py-2 px-4 rounded-md shadow-sm flex items-center" disabled>
  <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
  </svg>
  Processando...
</button>
```

### Empty States

```erb
<div class="text-center py-12 px-4">
  <!-- Ícone ilustrativo -->
  <svg class="mx-auto h-12 w-12 text-foome-gray" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
  </svg>
  
  <h3 class="mt-2 text-lg font-medium text-foome-gray-dark">Nenhum resultado encontrado</h3>
  <p class="mt-1 text-sm text-foome-gray">Tente ajustar os filtros ou adicionar um novo item.</p>
  
  <div class="mt-6">
    <button type="button" class="bg-foome-primary hover:bg-foome-primary/90 text-white font-medium py-2 px-4 rounded-md shadow-sm">
      Adicionar novo
    </button>
  </div>
</div>
```

## Responsividade

### Breakpoints

Seguimos os breakpoints padrão do TailwindCSS:

- **sm**: 640px
- **md**: 768px
- **lg**: 1024px
- **xl**: 1280px
- **2xl**: 1536px

### Princípios Responsivos

1. **Mobile-First**: Construir primeiro para mobile e expandir para desktop
2. **Simplificar em Mobile**: Reduzir elementos não essenciais em telas pequenas
3. **Layout Adaptativo**: Usar grid/flex para reorganizar elementos conforme o tamanho da tela
4. **Toques vs. Cliques**: Garantir que áreas clicáveis sejam adequadas para interação por toque

### Exemplo de Grid Responsivo

```erb
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <% @items.each do |item| %>
    <div class="bg-white rounded-lg shadow p-4">
      <!-- Conteúdo do card -->
    </div>
  <% end %>
</div>
```

## Implementação com ViewComponent

### Estrutura de Componentes

Os componentes devem ser organizados em namespaces lógicos:

```
app/components/
├── base/ (componentes básicos)
│   ├── button_component.rb
│   ├── card_component.rb
│   └── ...
├── form/ (componentes de formulário)
│   ├── input_component.rb
│   ├── select_component.rb
│   └── ...
├── layout/ (componentes de layout)
│   ├── sidebar_component.rb
│   ├── header_component.rb
│   └── ...
└── ... (outros namespaces)
```

### Exemplo de Componente

```ruby
# app/components/base/card_component.rb
class Base::CardComponent < ViewComponent::Base
  renders_one :header
  renders_one :body
  renders_one :footer
  
  def initialize(classes: nil)
    @classes = classes
  end
  
  private
  
  def classes
    "bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden #{@classes}"
  end
end
```

```erb
<!-- app/components/base/card_component.html.erb -->
<div class="<%= classes %>">
  <% if header.present? %>
    <div class="px-4 py-5 border-b border-gray-200 sm:px-6">
      <%= header %>
    </div>
  <% end %>
  
  <div class="px-4 py-5 sm:p-6">
    <%= body %>
  </div>
  
  <% if footer.present? %>
    <div class="px-4 py-4 border-t border-gray-200 sm:px-6">
      <%= footer %>
    </div>
  <% end %>
</div>
```

### Uso do Componente

```erb
<%= render Base::CardComponent.new do |card| %>
  <% card.with_header do %>
    <h3 class="text-lg font-medium text-foome-gray-dark">Título do Card</h3>
  <% end %>
  
  <% card.with_body do %>
    <p>Conteúdo do card aqui.</p>
  <% end %>
  
  <% card.with_footer do %>
    <div class="flex justify-end">
      <button type="button" class="bg-foome-primary text-white rounded-md px-4 py-2">
        Ação
      </button>
    </div>
  <% end %>
<% end %>
```

## Acessibilidade

### Princípios Gerais

- Seguir diretrizes WCAG 2.1 nível AA
- Garantir navegação completa por teclado
- Fornecer textos alternativos para elementos visuais
- Manter contraste adequado para textos
- Usar estrutura semântica HTML5
- Implementar ARIA quando necessário

### Checklist de Acessibilidade

- [ ] Todos os elementos interativos são acessíveis por teclado
- [ ] Imagens têm textos alternativos descritivos
- [ ] Formulários têm labels associados corretamente
- [ ] Contraste de cores atende às diretrizes WCAG
- [ ] Mensagens de erro são claras e acessíveis
- [ ] Estrutura de página usa elementos semânticos (header, nav, main, etc.)
- [ ] Componentes complexos implementam padrões ARIA apropriados
- [ ] Ordem de tabulação segue fluxo lógico da página

### Exemplo de Implementação Acessível

```erb
<!-- Botão acessível -->
<button type="button" 
        class="bg-foome-primary text-white font-medium py-2 px-4 rounded-md shadow-sm"
        aria-label="<%= defined?(aria_label) ? aria_label : 'Botão' %>"
        <%= "aria-disabled='true'" if defined?(disabled) && disabled %>
        <%= "disabled" if defined?(disabled) && disabled %>>
  <% if defined?(icon) && icon.present? %>
    <span class="sr-only"><%= text %></span>
    <!-- Ícone -->
  <% else %>
    <%= text %>
  <% end %>
</button>
```
