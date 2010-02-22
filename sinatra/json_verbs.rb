require 'sinatra/base'

module Sinatra
  module JsonVerbs
    def json_get(route, options={}, &block)
      get(route, options) do
        instance_eval(&block).to_json
      end
    end

    def json_post(route, options={}, &block)
      post(route, options) do
        instance_eval(&block).to_json
      end
    end

    def json_put(route, options={}, &block)
      put(route, options) do
        instance_eval(&block).to_json
      end
    end

    def json_delete(route, options={}, &block)
      delete(route, options) do
        instance_eval(&block).to_json
      end
    end
  end
  
  register JsonVerbs
end