module LieDetector
  class MarkdownRunner < Redcarpet::Render::Base
    def initialize(suite)
      @suite = suite
      super()
    end

    def block_code(code, language)
      @suite.code_block(code)
      nil
    end

    [# block-level calls
      :block_quote,
      :block_html, :list, :list_item,

      # span-level calls
      :autolink, :codespan, :double_emphasis,
      :emphasis, :underline, :raw_html,
      :triple_emphasis, :strikethrough,
      :superscript,

      # footnotes
      :footnotes, :footnote_def, :footnote_ref,

      # low level rendering
      # :entity, :normal_text
    ].each do |method|
      define_method method do |*args|
        @suite.push_descriptions args.first
        nil
      end
    end

    def normal_text(text)
      text
    end


    # Other methods where we don't return only a specific argument
    def link(link, title, content)
      @suite.push_descriptions "#{content} (#{link})"
      nil
    end

    def image(link, title, content)
      content &&= content + " "
      @suite.push_descriptions "#{content}#{link}"
      nil
    end

    def paragraph(text)
      @suite.push_descriptions("\n#{text}\n")
      nil
    end

    LEVEL_DOTS = {1 => '=', 2 => '-', 3 => '.'}
    def header(text, header_level)
      @suite.push_descriptions("\n#{text}\n#{LEVEL_DOTS[header_level] * text.size}\n")
      nil
    end
  end
end