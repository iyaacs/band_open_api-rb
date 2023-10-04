require 'net/http'
require 'uri'
require 'json'

Encoding.default_external = Encoding::UTF_8

def validate?(hash, properties)
    messages = []
    ret = true
    properties.each do |property|
        unless hash.has_key?(property)
            messages.append("FAIL TO READ #{property}") 
            ret = false
        end
    end
    unless ret
        messages.each do |message|
            puts message
        end
    end
    ret
end

def get_access_token
    access_token_path = './access_token.txt'
    access_token = File.read(access_token_path).strip
end

def get_request(url, query_params = {})
    query_params['access_token'] = get_access_token
    url = URI.parse(url)
    url.query = URI.encode_www_form(query_params)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true 
    http.ssl_version = :TLSv1_2

    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    ret = JSON.parse(response.body.force_encoding('UTF-8'))
    properties = ['result_code', 'result_data']
    raise 'REQUEST IS FAIL' unless validate?(ret, properties)
    raise 'REQUEST IS FAIL' unless ret['result_code'] == 1
    ret
end

def post_request(url, params = {})
    params['access_token'] = get_access_token
    url = URI.parse(url)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true 
    http.ssl_version = :TLSv1_2

    request = Net::HTTP::Post.new(url.request_uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = URI.encode_www_form(params)
    response = http.request(request)
    ret = JSON.parse(response.body.force_encoding('UTF-8'))
    properties = ['result_code', 'result_data']
    raise 'REQUEST IS FAIL' unless validate?(ret, properties)
    raise 'REQUEST IS FAIL' unless ret['result_code'] == 1
    ret
end