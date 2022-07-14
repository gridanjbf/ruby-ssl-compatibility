require 'ethon'
require 'net/http'
require 'openssl'


def print_response(cli)
  puts "Response Headers : #{cli.response_headers}"
end

def print_certificate(certificate)
  puts "certificate #{certificate.inspect}"
end

url = ARGV[0]
ssl_verifypeer = ARGV[1] == "true"
host = URI.parse(url).host
puts "Fetching #{host}"
puts "ssl_verifypeer #{ssl_verifypeer} "
cli = Ethon::Easy.new(url: url, ssl_verifypeer: ssl_verifypeer, sslversion: "tlsv1_2")
cli.perform
print_response(cli)
https = Net::HTTP.new(host, 443)
https.use_ssl = true

https.verify_mode = OpenSSL::SSL::VERIFY_NONE unless ssl_verifypeer

certificate = https.start do |http| 
 http.peer_cert 
end
print_certificate(certificate)
