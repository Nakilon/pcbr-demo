require "oga"
require "timeout"
require "tablestructured"
all = TableStructured.new Oga.parse_html File.read "textiles.html"

[
  ["winter", %w{ + + - - }],
  ["summer", %w{ + - + - }],
  ["decor",  %w{ - - - + }],
].each do |purpose, signs|
  keys = %i{ Armor\ -\ Sharp\ Factor Insulation\ -\ Cold\ (°C) Insulation\ -\ Heat\ (°C) Beauty\ Factor }
  array = [
    ["", *keys.map{ |_| _.to_s.downcase.scan(/[a-z]+/).join("_") }],
    *all.map{ |row| [row.Textile.text, *row.to_h.values_at(*keys).map{ |_| (_.text.to_r * 100).round }] }
  ]
  array.insert 1, ["", *signs]
  File.open("textiles_#{purpose}.txt", "w") do |file|
    file.puts "Rimworld: best textiles for #{purpose.upcase} (https://rimworldwiki.com/wiki/Textiles)"
    file.puts "not wasting good armor on furniture and vice versa"
    sizes = array.transpose.map{ |col| col.map(&:size).max }
    array.each{ |row| file.puts row.zip(sizes).map{ |str, size| str.to_s.ljust size, " " }.join(" ") }
  end
end
