require 'json'
require 'net/http'
require 'active_support/core_ext/hash/conversions'

# Extensions to standard HTTPResponse
class Net::HTTPResponse
  # Find out the content type of the response and convert it the proper object
  def deserialize
    case content_type
    when "application/xml"
      Hash.from_xml(body).deep_symbolize_keys
    when "application/json"
      JSON.parse body, symbolize_names: true
    else
      body
    end
  end

  # True if response is HTTP OK
  def ok?
    Net::HTTPSuccess === self || Net::HTTPRedirection === self
  end
end

class ARestException < Exception; end

class ARest
  # Input:
  # * base_url - the base URL for REST API
  #
  # Options:
  # * headers (Hash) to set up headers
  #   c = ARest.new "http://localhost:3000/_api/v1", headers: {"Authentication" => "Token token=AHDIUHSBC...."}
  #
  # * username and password for basic http authentication
  #   c = ARest.new "http://localhost:3000/_api/v1", username: "user1", password: "password.8"
  # 
  # * Authentication token
  #   c = ARest.new "http://localhost:3000/_api/v1", token: 'AdbsuUDhwb3hqhj...'
  def initialize(base_url, **options)
    @base_url = base_url
    @headers = options[:headers]
    @auth_user = options[:username]
    @auth_password = options[:password]
    @auth_token = options[:token]
  end

  # Perform a HTTP GET request. Requires a path to current operation
  # If given, headers and http authentication can be override
  #
  # Input
  # * path - relative to URI given in constructor
  # Options Hash
  # * headers - overrides the header given in constructor
  # * username, password - overrides the http authentication
  # * token - overrides authorization token
  # * form_data - hash with HTML form data
  def get(path, **options)
    execute :get, path, options
  end

  # Perform a HTTP POST request. Requires a path to current operation
  # If given, headers and http authentication can be override
  #
  # Input
  # * path - relative to URI given in constructor
  # Options Hash
  # * headers - overrides the header given in constructor
  # * username, password - overrides the http authentication
  # * token - overrides authorization token
  # * form_data - hash with HTML form data
  def post(path, **options)
    execute :post, path, options
  end

  # Perform a HTTP PUT request. Requires a path to current operation
  # If given, headers and http authentication can be override
  #
  # Input
  # * path - relative to URI given in constructor
  # Options Hash
  # * headers - overrides the header given in constructor
  # * username, password - overrides the http authentication
  # * token - overrides authorization token
  # * form_data - hash with HTML form data
  def put(path, **options)
    execute :put, path, options
  end

  # Perform a HTTP DELETE request. Requires a path to current operation
  # If given, headers and http authentication can be override
  #
  # Input
  # * path - relative to URI given in constructor
  # Options Hash
  # * headers - overrides the header given in constructor
  # * username, password - overrides the http authentication
  # * token - overrides authorization token
  # * form_data - hash with HTML form data
  def delete(path, **options)
    execute :delete, path, options
  end

  def inspect
    "<ARest #{@base_url}#{if @headers then ', with headers' else '' end}#{if @auth_user && @auth_password then ', authenticating as '+@auth_user else '' end}>"
  end

  private
  # Perform a HTTP request. Requires method name a path to current operation. 
  # If given, headers and http authentication can be override
  #
  # Input
  # * method - HTTP method, :get, :post, :delete, :header, :update
  # * path - relative to URI given in constructor
  # Options Hash
  # * headers - overrides the header given in constructor
  # * username, password - overrides the http authentication
  # * token - overrides authorization token
  # * form_data - hash with HTML form data
  def execute(method, path, **options)
    uri = URI("#{@base_url}/#{path}")

    case method.to_sym
    when :get
      req = Net::HTTP::Get.new(uri)
    when :post
      req = Net::HTTP::Post.new(uri)
    when :put
      req = Net::HTTP::Put.new(uri)
    when :delete
      req = Net::HTTP::Delete.new(uri)
    else
      raise ARestException, "Unknown method: #{method}"
    end

    req.form_data = options[:form_data] if options[:form_data]

    headers = options[:headers] || @headers 
    headers.each { |k,v| req[k] = v } if headers

    auth_user = options[:auth_user] || @auth_user
    auth_password = options[:auth_password] || @auth_password
    req.basic_auth auth_user, auth_password if auth_user && auth_password

    token = options[:token] || @auth_token
    if token
      req["Authorization"] = "Token token=#{token}"
    end

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end
    res
  end
end
