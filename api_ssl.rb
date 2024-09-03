require 'uri'
require 'net/http'
require 'json'

def request(url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    return JSON.parse(response.body)
end

data = request("https://jsonplaceholder.typicode.com/photos")[0..5]
photos = data.map{|x| x['url']}
html = ""
photos.each do |photo|
    html += "<img src=\"#{photo}\">\n"
end
File.write("output.html", html)