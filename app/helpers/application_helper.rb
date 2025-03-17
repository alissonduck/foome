module ApplicationHelper
  # Formata um CNPJ para o padrão brasileiro: XX.XXX.XXX/XXXX-XX
  def format_cnpj(cnpj)
    return "" if cnpj.blank?

    # Remove caracteres não numéricos
    cnpj = cnpj.to_s.gsub(/[^\d]/, "")

    # Formata o CNPJ se tiver o tamanho correto
    if cnpj.length == 14
      "#{cnpj[0..1]}.#{cnpj[2..4]}.#{cnpj[5..7]}/#{cnpj[8..11]}-#{cnpj[12..13]}"
    else
      cnpj
    end
  end

  # Formata um CPF para o padrão brasileiro: XXX.XXX.XXX-XX
  def format_cpf(cpf)
    return "" if cpf.blank?

    # Remove caracteres não numéricos
    cpf = cpf.to_s.gsub(/[^\d]/, "")

    # Formata o CPF se tiver o tamanho correto
    if cpf.length == 11
      "#{cpf[0..2]}.#{cpf[3..5]}.#{cpf[6..8]}-#{cpf[9..10]}"
    else
      cpf
    end
  end

  # Formata um valor monetário para o padrão brasileiro: R$ X.XXX,XX
  def format_currency(value)
    return "" if value.blank?

    # Converte para float se não for um número
    value = value.to_f unless value.is_a?(Numeric)

    # Formata o valor com duas casas decimais, separador de milhar e prefixo R$
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".", precision: 2)
  end
end
