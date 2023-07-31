require "oga"
require_relative "common"

all = TableStructured.new Oga.parse_html File.read "textiles.html"
[
  ["winter", %w{ + + - - }],
  ["summer", %w{ + - + - }],
  ["decor",  %w{ - - - + }],
].each do |purpose, signs|
  write_txt all,
    :Textile, signs,
    "Rimworld: best textiles for #{purpose.upcase} (https://rimworldwiki.com/wiki/Textiles)",
    "don't waste good armor material on furniture and vice versa",
    purpose,
    "textiles_%s",
    :"Armor - Sharp Factor" => ->_{ (_.text.to_r * 100).round },
    :"Insulation - Cold (°C)" => ->_{ (_.text.to_r * 100).round },
    :"Insulation - Heat (°C)" => ->_{ (_.text.to_r * 100).round },
    :"Beauty Factor" => ->_{ (_.text.to_r * 100).round }
end
