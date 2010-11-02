#/usr/bin/env ruby

# The Amanzi:SLD module contains classes for a DSL for specifying
# StyleLayerDescriptor XML documents in a much simpler syntax than
# the usual XML syntax. It is based on the Amanzi::XML DSL which
# by itself already makes the syntax much simpler. You can access
# the underlying Amanzi::XML syntax as well, should you wish, but
# The SLD syntax makes common things much easier.
#
# For example, specify a PolygonSymbolizer like this:
# require 'amanzi/sld'
# sld = Amanzi::SLD::Document.new "Example"
# sld.add_polygon_symbolizer :stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4

require 'amanzi/xml'

module Amanzi
  module SLD
    class Config
      attr_accessor :settings
      def self.config(options={})
        @@instance ||= Config.new(options)
      end
      def initialize(options={})
        @settings = options
      end
      def []=(key,value)
        settings[key] = value
      end
      def [](key)
        settings[key]
      end
    end
    module Logger
      def puts *args
        STDOUT.puts(*args) if(Config.config[:verbose])
      end
    end
    class Document < XML::Document
      include Logger
      attr_reader :sld_name, :style_name, :name, :geometry_property
      def initialize(name,options={})
        super 'StyledLayerDescriptor'
        self['version'] = '1.0.0'
        self['xmlns'] = "http://www.opengis.net/sld"
        self['xmlns:ogc'] ="http://www.opengis.net/ogc"
        self['xmlns:xlink'] = "http://www.w3.org/1999/xlink"
        self['xmlns:xsi'] = "http://www.w3.org/2001/XMLSchema-instance"
        self['xsi:schemaLocation'] = "http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
        add_singleton_elements ['named_layer','user_style']
        singleton_method(:named_layer).insert_child(0,'Name') << name
        singleton_method(:user_style).insert_child(0,'Name') << name
      end
      # Pass any unknown methods down to user_style
      def method_missing(symbol,*args,&block)
        puts "Looking for SLD document method: #{symbol}"
        singleton_method(symbol,*args,&block) ||
        singleton_method(:user_style).send(symbol, *args, &block)
      end
      def add_line_symbolizer(options={},*args,&block)
        RuleBuilder.new(self.feature_type_style.rule).add_line_symbolizer(options,*args,&block)
      end
      def add_polygon_symbolizer(options={},*args,&block)
        RuleBuilder.new(self.feature_type_style.rule).add_polygon_symbolizer(options,*args,&block)
      end
      def add_text_symbolizer(options={},*args,&block)
        RuleBuilder.new(self.feature_type_style.rule).add_text_symbolizer(options,*args,&block)
      end
      def add_rule(options={})
        puts "Adding a generic rule: #{options.inspect}"
        self.feature_type_style do |fs|
          rule_builder = RuleBuilder.new(rule)
          yield rule_builder if(block_given?)
          rule_builder
        end
      end
    end
    class ElementWrapper
      include Logger
      attr_reader :element
      def initialize(element)
        @element = element
      end
      def method_missing(symbol,*args,&block)
        puts "Method '#{symbol}' missing on Element Wrapper: #{self.inspect}"
        element.send(symbol,*args,&block)
      end
    end
    class RuleBuilder < ElementWrapper
      alias_method :rule, :element
      def initialize(rule)
        super rule
      end
      def style_it(it,prefix,options={})
        options.each do |k,v|
          if k.to_s =~ /^#{prefix}/
            it.css_parameter(:name => k.to_s.gsub(/_/,'-')) << v
          end
        end
      end
      def style_stroke(stroke,options={})
        style_it(stroke,:stroke,options)
      end
      def style_fill(fill,options={})
        style_it(fill,:fill,options)
      end
      def style_font(font,options={})
        style_it(font,:font,options)
      end
      def update_filter_block(options,&block)
        new_block = block
        self.max_scale_denominator << options[:max_scale].to_f if(options[:max_scale])
        self.min_scale_denominator << options[:min_scale].to_f if(options[:min_scale])
        if(options[:geometry])
          if(block)
            new_block = Proc.new do |f|
              f.op(:and) do |f|
                f.geometry = options[:geometry]
                block.call f
              end
            end
          else
            new_block = Proc.new {|f| f.geometry = options[:geometry]}
          end
        end
        new_block
      end
      def add_line_symbolizer(options={},*args,&block)
        options[:stroke] ||= '#000000'
        options[:stroke_width] ||= 1
        puts "RuleBuilder:Adding line symbolizer with options: #{options.inspect}"
        block = update_filter_block(options,&block)
        block.call FilterBuilder.new(rule.insert_child(0,'Filter').ns(:ogc)) if(block)
        style_stroke(rule.line_symbolizer.stroke,options)
        self
      end
      def add_polygon_symbolizer(options={},*args,&block)
        options[:fill] ||= '#b0b0b0'
        puts "Adding polygon symbolizer with options: #{options.inspect}"
        block = update_filter_block(options,&block)
        block.call FilterBuilder.new(rule.insert_child(0,'Filter').ns(:ogc)) if(block)
        rule.polygon_symbolizer do |p|
          style_fill(p.fill,options)
          style_stroke(p.stroke,options)
        end
        self
      end
      def add_text_symbolizer(options={},*args,&block)
        return self unless options[:text] || options[:property]
        options[:font_family] ||= 'Times New Roman'
        options[:font_style] ||= 'Normal'
        options[:font_size] ||= 14
        options[:font_weight] ||= 'bold'
        options[:font_color] ||= '#101010'
        options[:fill] ||= '#101010'
        options[:halo_style] ||= {:fill => '#ffffbb', :fill_opacity => 0.85}
        puts "Adding text symbolizer with options: #{options.inspect}"
        block = update_filter_block(options,&block)
        block.call FilterBuilder.new(rule.insert_child(0,'Filter').ns(:ogc)) if(block)
        rule.text_symbolizer do |p|
          if options[:property]
            p.label.ogc__property_name << options[:property]
          else
            p.label.ogc__literal << options[:text]
          end
          style_font(p.font,options)
          if options[:halo].to_i > 0
            p.halo do |h|
              h.radius.ogc__literal << options[:halo].to_i
              style_fill(h.fill,options[:halo_style])
            end
          end
          style_fill(p.fill,options)
        end
        self
      end
    end
    class FilterBuilder < ElementWrapper
      def initialize(filter)
        super filter
        puts "Created filter builder: #{element}"
      end
      def geometry=(type)
        element.property_is_equal_to do |f|
          f.function(:name => 'geometryType').property_name << (Config.config[:geometry_property] || 'geom')
          f.literal << type
        end
      end
      def property
        @property ||= PropertyFilterBuilder.new(element)
      end
      def op(op_type)
        op_type = op_type.to_s.intern
        @op ||= {}
        yield(@op[op_type] ||= BooleanFilterBuilder.new(element,op_type)) if(block_given?)
        @op[op_type]
      end
    end
    class PropertyFilterBuilder < ElementWrapper
      def initialize(filter)
        super filter
      end
      def []=(key,value)
        element.property_is_equal_to do |f|
          f.property_name << key.to_s
          f.literal << value.to_s
        end
      end
      def exists? name
        element.send(:not).property_is_null.property_name << name
      end
      def not_exists? name
        element.property_is_null.property_name << name
      end
    end
    class BooleanFilterBuilder < FilterBuilder
      def initialize(filter,op)
        super(filter.send(op))
      end
    end
  end
end
