#/usr/bin/env ruby

module Amanzi
  module XML
    class Element
      attr_reader :name, :children, :depth
      attr_accessor :attributes, :namespace
      def initialize(name,depth=0)
        @name = name
        @depth = depth
        @children = []
        @attributes = {}
      end
      # Utility for setting the namepace in a method-chaining DSL
      def ns(ns)
        self.namespace = ns
        self
      end
      def []= (key,value)
        @attributes[key] = value
      end
      def insert index, child
        @children.insert index, child
      end
      def << child
        @children << child
      end
      def make_child(name,options={},&block)
        child = Element.new(name,depth+1)
        namespace && (child.namespace = namespace)
        options.each{|k,v| child[k]=v}
        block && block.call(child)
        child
      end
      def insert_child(index,name,options={},&block)
        insert index, child = make_child(name,options,&block)
        child
      end
      def add_child(name,options={},&block)
        self << child = make_child(name,options,&block)
        child
      end
      def comment(text)
        @children << Comment.new(text)
      end
      def self.camelize(symbol)
        symbol.to_s.gsub(/__/,':_').gsub(/(^|_)(\w)/){"#{$2.upcase}"}.gsub(/^(\w+):/){"#{$1.downcase}:"}
      end
      def method_missing(symbol,*args,&block)
        add_child(Element.camelize(symbol), *args, &block)
      end
      def indent(offset=0)
        @indent ||= []
        @indent[offset] ||= (0...(depth+offset)).inject(''){|a,v|a << (@xml_options[:tab] || "\t")}
      end
      def attribute_text
        attributes.empty? ? "" : " #{attributes.to_a.map{|x|"#{x[0]}=\"#{x[1]}\""}.join(' ')}"
      end
      def contents
        children.length==1 && !children[0].is_a?(Element) && children[0].to_s ||
        "\n#{indent(1)}#{children.map{|x|x.to_xml(@xml_options)}.join("\n#{indent(1)}")}\n#{indent}"
      end
      def tag
        namespace ? "#{namespace}:#{name}" : name
      end
      def to_xml(options={})
        @xml_options = options
        children.empty? ? "<#{tag}#{attribute_text}/>" : "<#{tag}#{attribute_text}>#{contents}</#{tag}>"
      end
      def to_s
        tag
      end
    end
    class Comment < Element
      def to_xml(options={})
        "<!-- #{[name,children].flatten.map{|c| c.to_s}.join(', ')} -->"
      end
    end

    class Document < Element
      def to_xml(options={})
        "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n" + super(options) + "\n"
      end
      def singleton_elements
        @singleton_elements ||= []
      end
      def comment text
        !@singleton_elements.empty? && @singleton_elements.flatten[-1].comment(text)
      end
      def add_singleton_elements(elements=[])
        prev_e = nil
        singleton_elements << elements.map do |e|
          parent = prev_e || self
          element = Element.new(Element.camelize(e), parent.depth + 1)
          parent << element
          prev_e = element
        end
      end
      def singleton_method(symbol,*args,&block)
        name = Element.camelize symbol
        singleton_elements.flatten.each do |element|
          if element.name === name
            #puts "Found singleton: #{name}"
            block && block.call(element)
            return element
          end
        end
        #puts "Found no singletons for #{name}"
        nil
      end
      def method_missing(symbol,*args,&block)
        #puts "Method missing in XML::Document: #{symbol}"
        singleton_method(symbol,*args,&block) || super(symbol,*args,&block)
      end
      def to_s
        to_xml
      end
    end
  end

  module HTML
    class Document < XML::Document
      def initialize(title)
        super 'HTML'
        add_singleton_elements ['head']
        add_singleton_elements ['body']
        head.title << title
      end
      # Pass any unknown methods down to body
      def method_missing(symbol,*args,&block)
        singleton_method(symbol,*args,&block) ||
        singleton_method(:body).send(symbol, *args, &block)
      end
      def self.test
        doc = XML::Document.new "HTML"
        doc.head.title << "Test HTML Document"
        doc.body.h1 << "Header One"

        puts doc.to_s

        doc = HTML::Document.new 'Another test HTML Document'
        doc.body.h1 << 'Header Two'
        doc.table do |t|
          t.tr{|r| r.th << :one;r.th << :two}
          t.tr{|r| r.td << 1;r.td << 2}
        end

        puts doc.to_s
      end
    end
  end
end
