require "oga"
require "tablestructured"
def write_txt all, name, signs, txt_name, factor, title, desc, rest
  array = [
    ["", *rest.map{ |_,| _.to_s.downcase.scan(/[a-z]+/).join("_") }],
    ["", *signs],
    *all.map{ |row| [row[name].text.strip, *rest.map{ |column, callback = ->_{_}| callback[row[column]] }] }
  ]
  File.open "#{txt_name % factor}.txt", "w" do |file|
    file.puts title % factor
    file.puts desc
    sizes = array.transpose.map{ |col| col.map{ |_| _.to_s.size }.max }
    array.each{ |row| file.puts row.zip(sizes).map{ |str, size| str.to_s.ljust size, " " }.join(" ") }
  end
end

require "nethttputils"
write_txt TableStructured.new(Oga.parse_html(NetHTTPUtils.request_data "https://lolchess.gg/meta/champions"), drop_first: 1),
  :Champion, %w{ - - }, "%s", "lol",
  "League of Legends TFT: best champions (https://lolchess.gg/meta/champions)",
  "lower value but higher avg. rank", [
    [:Champion, ->_{ _.at_css(".tft-champion")[:class][/ cost-(\d) /, 1] }],
    [:"Avg.Rank", ->_{ _.text[/\d\.\d+/].to_f }],
  ]
