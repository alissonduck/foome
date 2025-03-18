module OfficesHelper
  def format_address(office)
    return "Endereço não disponível" if office.nil? || office.address.blank?

    parts = []
    parts << office.address
    parts << "#{office.number}" if office.number.present?
    parts << office.complement if office.complement.present?
    parts << office.neighborhood if office.neighborhood.present?
    parts << "#{office.city.name}/#{office.city.state.abbreviation}" if office.city&.state

    parts.join(", ")
  end

  def format_zip_code(zip_code)
    return "" if zip_code.blank?
    zip_code.to_s.gsub(/^(\d{5})(\d{3})$/, "\\1-\\2")
  end

  def office_badge(icon_name, text)
    tag.div class: "inline-flex items-center px-2.5 py-1 rounded-md bg-muted text-xs" do
      concat(inline_svg_tag("icons/#{icon_name}.svg", class: "h-3 w-3 mr-1 text-muted-foreground"))
      concat(tag.span(text))
    end
  end
end
