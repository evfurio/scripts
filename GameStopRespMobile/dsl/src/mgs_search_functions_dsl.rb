module MGSSearchFunctionsDSL

  def convert_special_characters_to_space(value_searched)
    $tracer.trace("MGSSearchFunctionsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}")
    special = "?<>',?[]}{=-)(*&^%$#`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    converted_text = value_searched =~ regex ? value_searched.gsub!(/[^0-9A-Za-z]/, ' ') : value_searched
    return converted_text
  end

end