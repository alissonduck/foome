import { Controller } from "@hotwired/stimulus"

// Gerencia o formulário de escritório, incluindo a busca de CEP e carregamento de cidades
export default class extends Controller {
  // Conecta o controller
  connect() {
    console.log("Office form controller connected")
  }

  // Busca o CEP e preenche os campos de endereço
  async searchZipCode(event) {
    const zipCode = event.target.value.replace(/\D/g, "")
    if (zipCode.length !== 8) return

    try {
      const response = await fetch(`https://viacep.com.br/ws/${zipCode}/json/`)
      const data = await response.json()

      if (data.erro) {
        this.showError("CEP não encontrado")
        return
      }

      this.fillAddressFields(data)
    } catch (error) {
      console.error("Erro ao buscar CEP:", error)
      this.showError("Erro ao buscar CEP")
    }
  }

  // Carrega as cidades do estado selecionado
  async loadCities(event) {
    const stateId = event.target.value
    if (!stateId) return

    try {
      const response = await fetch(`/states/${stateId}/cities`)
      const cities = await response.json()

      this.updateCitySelect(cities)
    } catch (error) {
      console.error("Erro ao carregar cidades:", error)
      this.showError("Erro ao carregar cidades")
    }
  }

  // Preenche os campos de endereço com os dados do CEP
  fillAddressFields(data) {
    const fields = {
      "office_address": data.logradouro,
      "office_neighborhood": data.bairro,
      "office_complement": data.complemento
    }

    Object.entries(fields).forEach(([id, value]) => {
      const field = document.getElementById(id)
      if (field && value) field.value = value
    })

    // Busca e seleciona o estado
    this.selectState(data.uf)
  }

  // Seleciona o estado e carrega suas cidades
  async selectState(uf) {
    try {
      const response = await fetch(`/states/by_abbreviation/${uf}`)
      const state = await response.json()

      const stateSelect = document.getElementById("office_state_id")
      if (stateSelect) {
        stateSelect.value = state.id
        stateSelect.dispatchEvent(new Event("change"))
      }
    } catch (error) {
      console.error("Erro ao buscar estado:", error)
    }
  }

  // Atualiza o select de cidades
  updateCitySelect(cities) {
    const citySelect = document.getElementById("office_city_id")
    if (!citySelect) return

    citySelect.innerHTML = '<option value="">Selecione uma cidade</option>'
    cities.forEach(city => {
      const option = document.createElement("option")
      option.value = city.id
      option.textContent = city.name
      citySelect.appendChild(option)
    })
  }

  // Exibe mensagem de erro
  showError(message) {
    // Aqui você pode implementar a lógica para exibir o erro
    // Por exemplo, usando um toast ou uma mensagem na tela
    console.error(message)
  }
} 