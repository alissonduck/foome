# app/services/error_handler_service.rb
class ErrorHandlerService
  # Serviço responsável por padronizar o tratamento de erros na aplicação
  # Utiliza um formato consistente para apresentação de erros ao usuário

  # Formata erros de validação de modelo para exibição
  # @param [ActiveModel::Errors] errors Erros de validação de um modelo
  # @return [String] Mensagem de erro formatada
  def self.format_model_errors(errors)
    errors.full_messages.join(", ")
  end

  # Formata um array de erros para exibição
  # @param [Array<String>] errors Array de mensagens de erro
  # @return [String] Mensagem de erro formatada
  def self.format_error_array(errors)
    errors.join(", ")
  end

  # Formata erro de operação para exibição
  # @param [Hash] result Resultado de uma operação
  # @return [String] Mensagem de erro formatada
  def self.format_operation_errors(result)
    return "" unless result[:errors]

    if result[:errors].is_a?(Array)
      format_error_array(result[:errors])
    else
      result[:errors].to_s
    end
  end

  # Registra erros no log com informações de contexto
  # @param [String] context Contexto do erro (ex: "Cadastro de empresa - Etapa 1")
  # @param [Hash, Array, String] errors Erros a serem registrados
  # @param [Hash] additional_info Informações adicionais para o log
  def self.log_errors(context, errors, additional_info = {})
    error_message = if errors.is_a?(Hash) && errors[:errors]
                      errors[:errors]
    elsif errors.is_a?(Array)
                      errors
    else
                      errors.to_s
    end

    Rails.logger.error("#{context}: #{error_message}")
    Rails.logger.error("Informações adicionais: #{additional_info.inspect}") if additional_info.present?
  end

  # Formata os erros de validação de sessão
  # @param [Hash] result Resultado da validação da sessão
  # @return [String] Mensagem de erro formatada
  def self.format_session_validation_errors(result)
    if result[:missing_keys].present?
      "Dados incompletos. Por favor, inicie o cadastro novamente."
    else
      "Sessão expirada. Por favor, inicie o cadastro novamente."
    end
  end
end
