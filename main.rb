toc = {"title"=>"PCBR rankings", "href"=>"index.yaml", "items"=>[]}
index = {"links"=>[]}

require "set"
require "pcbr"
File.write "index.md", ""
Dir.glob("*.txt").sort.map do |filename|
  fail unless /\A(?<title>.+)\n(?<description>.+)\n(\S.*\n)*( .+)\n(?<directions> .+)\n/ =~ File.read(filename)
  s = $'.split "\n"
  href = "#{File.basename filename, ".txt"}.md"
  File.open("yfm/#{href}", "w") do |current|
    current.puts "## #{title}\n(#{description})\n|score||\n|-|-"
    toc["items"].push({"name"=>title, "href"=>href})
    index["links"].push({"title"=>title, "href"=>href})
  pcbr = PCBR.new
  s.map{ |_| _.ljust s.map(&:size).max, ?\s }.map(&:chars).transpose.chunk{ |_| _.uniq == [" "] }.reject(&:first).map{ |_| _.last.transpose.map &:join }.transpose.each do |item, *vector|
    pcbr.store item.strip, vector.zip(directions.split).map{ |value, direction| direction == ?- ? -Rational(value) : Rational(value) unless value.strip.empty? }
  end
  pcbr.table.sort_by(&:last).chunk(&:last).reverse_each do |score, g|
      current.puts "|#{score}|#{g.map(&:first).sort.join(", ")}"
  end
    current.puts "---"
  end
  `cat yfm/#{href} >> index.md`
end

require "yaml"
File.write "yfm/toc.yaml", YAML.dump(toc)
File.write "yfm/index.yaml", YAML.dump(index)
