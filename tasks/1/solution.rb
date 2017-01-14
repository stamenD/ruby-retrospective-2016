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

SUBSTANCES = {
  'water'   => {melting_point: 0,     boiling_point: 100  },
  'ethanol' => {melting_point: -114,  boiling_point: 78.37},
  'gold'    => {melting_point: 1_064, boiling_point: 2_700},
  'silver'  => {melting_point: 961.8, boiling_point: 2_162},
  'copper'  => {melting_point: 1_085, boiling_point: 2_567}
}

def melting_point_of_substance(element, measure)
  convert_between_temperature_units(SUBSTANCES[element][:melting_point], 'C', measure)
end

def boiling_point_of_substance(element, measure)
  convert_between_temperature_units(SUBSTANCES[element][:boiling_point], 'C', measure)
end