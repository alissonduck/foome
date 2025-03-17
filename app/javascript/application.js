// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Adicionar máscara para campos de CNPJ, CPF e telefone
document.addEventListener("turbo:load", function() {
  // Verificar se o jQuery está disponível
  if (typeof jQuery !== 'undefined') {
    // Aplicar máscara para CNPJ
    $("[data-mask='cnpj']").mask("00.000.000/0000-00");
    
    // Aplicar máscara para CPF
    $("[data-mask='cpf']").mask("000.000.000-00");
    
    // Aplicar máscara para telefone/celular
    $("[data-mask='phone']").mask("(00) 00000-0000");
    
    // Aplicar máscara para CEP
    $("[data-mask='cep']").mask("00000-000");
  } else {
    console.warn("jQuery não está disponível. As máscaras não serão aplicadas.");
  }
});
