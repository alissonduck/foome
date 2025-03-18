import { Controller } from "@hotwired/stimulus"

// Controller Stimulus para gerenciar o menu mobile
export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    // Inicialização do controller
    this.isOpen = false
    
    // Adicionar listener para detectar cliques fora do menu
    this.clickOutsideHandler = this.clickOutside.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
  }
  
  disconnect() {
    // Remover listener quando o controller é desconectado
    document.removeEventListener("click", this.clickOutsideHandler)
  }
  
  toggle(event) {
    // Previne o evento de propagar para o listener de documento
    event.stopPropagation()
    
    this.isOpen = !this.isOpen
    this.updateVisibility()
  }
  
  updateVisibility() {
    if (this.isOpen) {
      this.menuTarget.classList.remove("hidden")
    } else {
      this.menuTarget.classList.add("hidden")
    }
  }
  
  // Fecha o menu quando clica fora dele
  clickOutside(event) {
    // Se o clique não foi dentro do controller e o menu está aberto
    if (!this.element.contains(event.target) && this.isOpen) {
      this.isOpen = false
      this.updateVisibility()
    }
  }
} 