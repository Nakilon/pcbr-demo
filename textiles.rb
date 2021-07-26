require "oga"
html = Oga.parse_html File.read "textiles.html"
all = html.css("tr").map do |tr|
  (
    tr.css("th").map(&:text).map do |td|
      case td
      when /\A[A-Z][a-z]+( -)?( [A-Z][a-z]+)*( \(°C\))?\z/ ; td.downcase.scan(/[a-z]+/).join("_")
      else ; fail td
      end
    end
  ) + (
    tr.css("td").map(&:text).map do |td|
      case td
      when /\A[A-Z][a-z]+( [a-z]+){0,2}\z/ ; td
      when /\A\d+(\.\d+)?\z/ ; (td.to_r * 100).round
      else ; fail td
      end
    end
  )
end

[
  ["winter", %w{ + + - - }],
  ["summer", %w{ + - + - }],
  ["decor",  %w{ - - - + }],
].each do |purpose, signs|
  array = all.map{ |row| row.values_at 0, 1, 4, 5, 8 }
  array[0][0] = ""
  array.insert 1, ["", *signs]
  File.open("textiles_#{purpose}.txt", "w") do |file|
    file.puts "Rimworld: best textiles for #{purpose.upcase} (https://rimworldwiki.com/wiki/Textiles)"
    file.puts "not wasting good armor on furniture and vice versa"
    sizes = array.transpose.map{ |col| col.map(&:size).max }
    array.each{ |row| file.puts row.zip(sizes).map{ |str, size| str.to_s.ljust size, " " }.join(" ") }
  end
end
