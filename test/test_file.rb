require 'helper'
require 'differ'

class TestFile < Test::Unit::TestCase
#  should "probably rename this file and start testing for real" do
#    flunk "hey buddy, you should probably rename this file and start testing for real"
#  end
  def show_diff(results,expected)
    puts "Results: #{results.class.to_s}"
    puts "Expected: #{expected.class.to_s}"
    puts "Results: #{results.inspect[0..100]}"
    puts "Expected: #{expected.inspect[0..100]}"
    diff = Differ.diff_by_line(results,expected)
    puts diff.methods.join(', ')
#    puts diff.inspect
    puts diff.format_as :color
  end
  def test_file(file,expect)
    @results = `ruby -I lib #{file}`

    if File.exist? expect
      expected = File.open(expect).read
      if expected.length != @results.length
        puts "Got different results: #{expected.length} != #{@results.length}"
        show_diff(@results,expected)
        false
      else
        true
      end
    else
      File.open(@expect,'w') do |file|
        file.puts @results
      end
      puts "Wrote first time run results to #{@expect}"
    end
  end

  context "Test file" do
    setup do
      @file = 'examples/test.rb'
      @expect = 'examples/test.sld'
    end
    should "produce expected output" do
      assert test_file @file, @expect
    end
  end
end
