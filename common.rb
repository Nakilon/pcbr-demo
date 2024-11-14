require "tablestructured"
def write_txt all, name, signs, title, desc, factor, txt_name = "%s", **rest
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
