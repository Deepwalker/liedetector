module LieDetector
  class Suite
    HEADERS_DEFAULTS = {'Accept' => 'application/json'}
    HTTP_DEFAULTS = {host: '127.0.0.1', port: 3000}

    attr_accessor :http_defaults

    def headers_defaults
      HEADERS_DEFAULTS
    end

    def initialize(filepath)
      @filepath = filepath
    end

    def build_uri(path, query: nil, fragment: nil)
      query = URI.encode_www_form(query) if query.is_a? Hash
      URI::HTTP.build(HTTP_DEFAULTS.merge(path: path, query: query, fragment: fragment)).to_s
    end

    def session
      @session ||= begin
        session = HTTPClient.new
        session.set_cookie_store("cookie.dat")
        # session.debug_dev = STDOUT
        session
      end
    end

    def push_descriptions(text)
      @text ||= ''
      @text += text
    end

    def register(cls, name)
      @ordered ||= []
      @registry ||= {}
      @ordered << cls
      @registry[name] = cls if name
      cls.description(@text || '')
      @text = ''
    end

    def store_key(key, data)
      @store ||= {}
      @store[key] = data
    end

    def store_data
      @store
    end

    attr_reader :store

    def run
      markdown = Redcarpet::Markdown.new(LieDetector::MarkdownRunner.new(self), fenced_code_blocks: true)
      markdown.render(File.new(@filepath).read)

      @ordered.each do |test|
        puts test.describe
        test.call
        puts 'passed'
        puts
      end
    end

    def code_block(code)
      self.instance_eval(code, @filepath)
    end

    # Sugar to not define classes in the doc
    def request(name, method, path, &blk)
      req = LieDetector::Request.new self
      req.method method
      req.path path
      req.instance_exec &blk
      register(req, name)
    end
  end
end