def convert_between_temperature_units(degree, input, output)
  if input == output
    degree
  elsif input == 'C' && output == 'F'
    degree * 1.8 + 32
  elsif input == 'C' && output == 'K'
    degree + 273.15
  elsif input == 'K' && output == 'F'
    degree * 9 / 5 - 459.67
  elsif input == 'K' && output == 'C'
    degree - 273.15 
  elsif input == 'F' && output == 'C'
    (degree - 32) / 1.8
  elsif input == 'F' && output == 'K'
    (degree + 459.67) * 5 / 9
  end
end

def melting_point_of_substance(element, measure)
  elements_melt = {'water' => 0, 'ethanol' => -114, 'gold' => 1064, 'silver' => 961.8, 'copper' => 1085}
  convert_between_temperature_units(elements_melt[element], 'C', measure)
end

def boiling_point_of_substance(element, measure)
  elements_boil = {'water' => 100, 'ethanol' => 78.37, 'gold' => 2700, 'silver' => 2162, 'copper' => 2567}
  convert_between_temperature_units(elements_boil[element], 'C', measure)
end