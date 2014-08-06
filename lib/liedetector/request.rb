module LieDetector
  class Request
    def initialize(suite)
      @suite = suite
    end

    %w{method path data query headers status description}.each do |name|
      define_method name do |arg|
        self.instance_variable_set("@#{name}", arg)
      end

      define_method "get_#{name}" do
        data = self.instance_variable_get("@#{name}")
        if data.is_a? Proc
          @suite.instance_eval &data
        else
          data
        end
      end
    end

    def await(trafaret)
      @trafaret = T.construct(trafaret)
    end

    def describe
      "#{@description}\nExecute #{@method.to_s.upcase} #{get_path}\n"
    end

    def store(name)
      @store_key = name
    end

    def call
      res = @suite.session.send(
        get_method,
        @suite.build_uri(get_path, query: get_query),
        {
          data: get_data,
          header: @suite.headers_defaults.merge(get_headers || {})
        }
      )
      unless res.status == get_status
        raise "Bad status(#{get_status} != #{res.status}): #{res.inspect}"
      end
      check = @trafaret.call(Oj.load(res.content))
      if check.is_a? Trafaret::Error
        raise "Unmatched data #{check.dump} #{res.content}"
      end
      @suite.store_key(@store_key, check) if @store_key
    end
  end
end