# Guia de Design da Foome

Este documento serve como referência principal para o design da plataforma Foome, implementada em Ruby on Rails com ERB, Hotwire com Stimulus, Turbo e TailwindCSS.

## Índice

1. [Princípios de Design](#princípios-de-design)
2. [Cores](#cores)
3. [Tipografia](#tipografia)

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