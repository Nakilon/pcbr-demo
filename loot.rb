# https://developers.google.com/sheets/api/quickstart/ruby

require "google/apis/sheets_v4"
require "googleauth"
require "googleauth/stores/file_token_store"

def authorize
  authorizer = Google::Auth::UserAuthorizer.new \
    Google::Auth::ClientId.from_file("credentials.json"),
    Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
    Google::Auth::Stores::FileTokenStore.new(file: "token.yaml")
  user_id = "default"
  credentials = authorizer.get_credentials(user_id) and return credentials
  oob_uri = "urn:ietf:wg:oauth:2.0:oob"
  puts "Open the following URL in the browser and enter the resulting code after authorization:\n" +
    authorizer.get_authorization_url(base_url: oob_uri)
  authorizer.get_and_store_credentials_from_code(user_id: user_id, code: gets, base_url: oob_uri)
end

service = Google::Apis::SheetsV4::SheetsService.new
service.client_options.application_name = ""
service.authorization = authorize

fill_for_transpose = lambda do |array, x|
  max = array.map(&:size).max
  array.map{ |row| row.fill x, row.size...max }
end

spreadsheet_id = "1M9RLV79rnU_YXa4ealRdFDLqI0SNCn8E8UWgsto1nUk"
array = [["", ""], *service.get_spreadsheet_values(spreadsheet_id, "Sheet1!A2:A27").values.map{ |_,| [_.tr(" ", "_"), "+"] }].transpose +
  service.get_spreadsheet_values(spreadsheet_id, "Sheet1!Q1:AT1").values[0].zip(
    fill_for_transpose.call(
      service.get_spreadsheet(spreadsheet_id, include_grid_data: true, ranges: ["Sheet1!Q2:AT27"]).
        sheets[0].data[0].row_data.map{ |row| row.values.map{ |cell|
          next "" unless cell.effective_format
          {
            {:blue=>0.8, :green=>0.8, :red=>0.95686275} => "0",
            {:blue=>0.827451, :green=>0.91764706, :red=>0.8509804} => "1",
          }.fetch cell.effective_format.background_color.to_h
        } }, ""
    ).transpose
  ).map(&:flatten).reject{ |_| _.count("") > 5 }

puts "The most developed loot management in video games"
puts "source: https://docs.google.com/spreadsheets/d/1M9RLV79rnU_YXa4ealRdFDLqI0SNCn8E8UWgsto1nUk/edit?usp=sharing"
sizes = array.transpose.map{ |col| col.map(&:size).max }
array.each{ |row| puts row.zip(sizes).map{ |str, size| str.ljust size, " " }.join(" ") }
