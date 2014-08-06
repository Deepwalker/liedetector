module LieDetector
  class Request
    def initialize(suite)
      @suite = suite
    end

    def method(method)
      @method = method
    end

    def path(path)
      @path = path
    end

    def data(data)
      @data = data
    end

    def query(query)
      @query = query
    end

    def headers(headers)
      @headers = headers
    end

    def await(trafaret)
      @trafaret = T.construct(trafaret)
    end

    def description(description)
      @description = description
    end

    def describe
      "#{@description}\nExecute #{@method.to_s.upcase} #{@path}\n"
    end

    def status(status)
      @status = status
    end

    def store(name)
      @store_key = name
    end

    def call
      res = @suite.session.send(
        @method,
        @suite.build_uri(@path, query: @query),
        {
          data: @data,
          header: @suite.headers_defaults.merge(@headers || {})
        }
      )
      unless res.status == @status
        raise "Bad status(#{@status} != #{res.status}): #{res.inspect}"
      end
      res = @trafaret.call(Oj.load(res.content))
      if res.is_a? Trafaret::Error
        raise "Unmatched data #{res.dump}"
      end
      @suite.store_key(@store_key, res) if @store_key
    end
  end
end