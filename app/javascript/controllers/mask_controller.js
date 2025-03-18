import { Controller } from "@hotwired/stimulus"
import IMask from "imask"

// Controller Stimulus para aplicação de máscaras em campos de formulário
export default class extends Controller {
  static targets = ["cnpj", "cpf", "phone", "cep"]
  
  connect() {
    this.initMasks()
  }
  
  initMasks() {
    this.initCnpjMasks()
    this.initCpfMasks()
    this.initPhoneMasks()
    this.initCepMasks()
  }
  
  initCnpjMasks() {
    if (this.hasCnpjTarget) {
      this.cnpjTargets.forEach(element => {
        IMask(element, {
          mask: '00.000.000/0000-00'
        })
      })
    }
  }
  
  initCpfMasks() {
    if (this.hasCpfTarget) {
      this.cpfTargets.forEach(element => {
        IMask(element, {
          mask: '000.000.000-00'
        })
      })
    }
  }
  
  initPhoneMasks() {
    if (this.hasPhoneTarget) {
      this.phoneTargets.forEach(element => {
        IMask(element, {
          mask: '(00) 00000-0000'
        })
      })
    }
  }
  
  initCepMasks() {
    if (this.hasCepTarget) {
      this.cepTargets.forEach(element => {
        IMask(element, {
          mask: '00000-000'
        })
      })
    }
  }
} 