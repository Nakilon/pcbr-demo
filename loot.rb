require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"

def authorize
  user_id = "default"
  authorizer = Google::Auth::UserAuthorizer.new \
    Google::Auth::ClientId.from_file("googleauth_credentials.json"),
    Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
    Google::Auth::Stores::FileTokenStore.new(file: "token.yaml")
  return authorizer.get_credentials user_id if authorizer.get_credentials user_id

  redirect_uri = "http://localhost:8080"

  puts "Open this URL in your browser: #{authorizer.get_authorization_url base_url: redirect_uri}"
  puts "After granting permission, your browser will try to load localhost and fail (this is normal)."
  puts "Copy the ENTIRE URL from your browser's address bar and paste it below:"

  fail unless code = URI.decode_www_form(URI.parse(gets.strip).query).to_h["code"]
  authorizer.get_and_store_credentials_from_code user_id: user_id, code: code, base_url: redirect_uri
end

service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = "MyApp"
service.authorization = authorize

fill_for_transpose = lambda do |array, x|
  max = array.map(&:size).max
  array.map{ |row| row.fill x, row.size...max }
end

buttom_row = 27
left_col = "O"
right_col = "BB"
spreadsheet_id = "1M9RLV79rnU_YXa4ealRdFDLqI0SNCn8E8UWgsto1nUk"
array = [["", ""], *service.get_spreadsheet_values(spreadsheet_id, "Sheet1!A2:A#{buttom_row}").values.map{ |_,| [_.tr(" ", "_"), "+"] }].transpose +
  service.get_spreadsheet_values(spreadsheet_id, "Sheet1!#{left_col}1:#{right_col}1").values[0].zip(
    fill_for_transpose.call(
      service.get_spreadsheet(spreadsheet_id, include_grid_data: true, ranges: ["Sheet1!#{left_col}2:#{right_col}#{buttom_row}"]).
        sheets[0].data[0].row_data.map.with_index{ |row, i| row.values.map.with_index{ |cell, j|
          # STDERR.puts [i,j].inspect
          next "" unless cell.effective_format
          {
            {:blue=>0.8, :green=>0.8, :red=>0.95686275} => "0",
            {:blue=>0.827451, :green=>0.91764706, :red=>0.8509804} => "1",
          }.fetch cell.effective_format.background_color.to_h
        } }, ""
    ).transpose
  ).map(&:flatten).reject{ |_| _.count("") > 4 }

puts "The most developed loot management in video games"
puts "source: https://docs.google.com/spreadsheets/d/1M9RLV79rnU_YXa4ealRdFDLqI0SNCn8E8UWgsto1nUk/edit?usp=sharing"
sizes = array.transpose.map{ |col| col.map(&:size).max }
array.each{ |row| puts row.zip(sizes).map{ |str, size| str.ljust size, " " }.join(" ") }
