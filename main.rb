require "set"
require "pcbr"
Dir.glob("*.txt").map do |filename|
  title, description, _, directions, *s = File.read(filename).split(?\n)
  puts "## #{title}\n(#{description})\n|score||\n|-|-"
  pcbr = PCBR.new
  s.map{ |_| _.ljust s.map(&:size).max, ?\s }.map(&:chars).transpose.chunk{ |_| _.uniq == [" "] }.reject(&:first).map{ |_| _.last.transpose.map &:join }.transpose.each do |item, *vector|
    pcbr.store item.strip, vector.zip(directions.split).map{ |value, direction| direction == ?- ? -Rational(value) : Rational(value) unless value.strip.empty? }
  end
  pcbr.table.sort_by(&:last).reverse.chunk(&:last).each_with_index do |(score, g), i|
    puts "|#{score}|#{g.map(&:first).join(", ")}"
  end
  puts "---"
end

