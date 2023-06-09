require "nethttputils"
require "oga"
require_relative "common"
write_txt TableStructured.new( Oga.parse_html(
  NetHTTPUtils.request_data "https://www.ruby-toolbox.com/categories/web_app_frameworks?display=table"
).at_css "table" ),
  :_1, %w{ + - + },
  "Ruby Web App Frameworks (https://www.ruby-toolbox.com/categories/web_app_frameworks)",
  "ranked by stars, forks and latest release date", "ruby-web",
  :Stars => ->_{ _.text.delete ?, },
  :Forks => ->_{ _.text.delete ?, },
  :"Latest release" => ->_{ _.text.delete ?- }
