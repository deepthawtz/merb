require 'ostruct'
require 'cgi'

module Merb
  module Test
    # FakeRequest sets up a default enviroment which can be overridden either
    # by passing and env into initialize or using request['HTTP_VAR'] = 'foo' 
    class FakeRequest < Request
      def initialize(env = {}, req = StringIO.new)
        env.environmentize_keys!
        
        fake_request = Struct.new(:params, :body).new(DEFAULT_ENV.merge(env), req)
        super(fake_request)
      end
      
      private    
      DEFAULT_ENV = Mash.new({
        'SERVER_NAME' => 'localhost',
        'PATH_INFO' => '/',
        'HTTP_ACCEPT_ENCODING' => 'gzip,deflate',
        'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.1) Gecko/20060214 Camino/1.0',
        'SCRIPT_NAME' => '/',
        'SERVER_PROTOCOL' => 'HTTP/1.1',
        'HTTP_CACHE_CONTROL' => 'max-age=0',
        'HTTP_ACCEPT_LANGUAGE' => 'en,ja;q=0.9,fr;q=0.9,de;q=0.8,es;q=0.7,it;q=0.7,nl;q=0.6,sv;q=0.5,nb;q=0.5,da;q=0.4,fi;q=0.3,pt;q=0.3,zh-Hans;q=0.2,zh-Hant;q=0.1,ko;q=0.1',
        'HTTP_HOST' => 'localhost',
        'REMOTE_ADDR' => '127.0.0.1',
        'SERVER_SOFTWARE' => 'Mongrel 1.1',
        'HTTP_KEEP_ALIVE' => '300',
        'HTTP_REFERER' => 'http://localhost/',
        'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
        'HTTP_VERSION' => 'HTTP/1.1',
        'REQUEST_URI' => '/',
        'SERVER_PORT' => '80',
        'GATEWAY_INTERFACE' => 'CGI/1.2',
        'HTTP_ACCEPT' => 'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
        'HTTP_CONNECTION' => 'keep-alive',
        'REQUEST_METHOD' => 'GET'      
      }) unless defined?(DEFAULT_ENV)
    end

    module RequestHelper
    
      # ==== Parameters
      # env<Hash>:: A hash of environment keys to be merged into the default list
      #
      # ==== Options (choose one)
      # :post_body<String>:: The post body for the request
      # :body<String>:: The body for the request
      # 
      # ==== Returns
      # FakeRequest:: A Request object that is built based on the parameters
      #
      # ==== Note
      # If you pass a post_body, the content-type will be set as URL-encoded
      def fake_request(env = {}, opt = {})
        if opt[:post_body]
          req = opt[:post_body]
          env.merge!(:content_type => "application/x-www-form-urlencoded")
        else
          req = opt[:req] || ""
        end
        FakeRequest.new(env, StringIO.new(req))
      end
    end
  end

end