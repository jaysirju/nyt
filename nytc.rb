#! /usr/bin/env ruby
#################### config section ###################
username = "psorders%40animoto.com"
password = "cr0551m0t0"
output_path = "/tmp/"
#######################################################


loginpage = `curl 'https://myaccount.nytimes.com/auth/login'`

form_inputs = loginpage.scan(/<input type=\"hidden\" name=\"([^\"]*)\" value=\"([^\"]*)\".*$/)

form_inputs += [["userid", username ],["password", password]]

data = form_inputs.inject("") do |str, input|
  str += "&" unless str.empty?
  str += "#{input[0]}=#{input[1]}"
end

cookiefile = "/tmp/coookie"

#login, store cookies
`curl 'https://myaccount.nytimes.com/auth/login' --data '#{data}' -c #{cookiefile}`

date = Time.now.strftime('%b%d%y')
output_pdf = [output_path,'crossword',date,".pdf"].join

#download pdf
`curl http://www.nytimes.com/svc/crosswords/v2/puzzle/print/#{date}.pdf -o #{output_pdf} -b #{cookiefile}`

puts "Crossword downloaded to: #{output_pdf}"
