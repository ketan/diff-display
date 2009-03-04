# encoding: utf-8

require File.dirname(__FILE__) + "/test_helper"

class TestGenerator < Test::Unit::TestCase
  include DiffFixtureHelper
  
  def setup
    @generator = Diff::Display::Unified::Generator.new
  end
  
  def test_generator_run_raises_if_doesnt_get_a_enumerable_object
    assert_raises(ArgumentError) do
      Diff::Display::Unified::Generator.run(nil)
    end
  end
  
  def test_Generator_run_processes_each_line_in_the_diff
    Diff::Display::Unified::Generator.expects(:new).returns(@generator)
    @generator.expects(:process).with("foo")
    @generator.expects(:process).with("bar")
    Diff::Display::Unified::Generator.run("foo\nbar")
  end
  
  def test_Generator_run_returns_the_data
    Diff::Display::Unified::Generator.expects(:new).returns(@generator)
    generated = Diff::Display::Unified::Generator.run("foo\nbar")
    assert_instance_of Diff::Display::Data, generated
  end
  
  def test_the_returned_that_object_is_in_parity_with_the_diff
    %w[simple only_add  only_rem multiple_adds_after_rem].each do |diff|
      data = Diff::Display::Unified::Generator.run(load_diff(diff))
      assert_equal load_diff(diff).chomp, data.to_diff
    end
  end
  
  def test_multiple_rems_and_an_add_is_in_parity
    diff_data = load_diff("multiple_rems_then_add")
    data = Diff::Display::Unified::Generator.run(diff_data)
    assert_equal diff_data.chomp, data.to_diff
  end
  
  def test_doesnt_parse_linenumbers_that_isnt_part_if_the_diff
    assert_equal (1..14).map{|l| [nil, l] }.to_a, line_numbers_for(:pseudo_recursive).compact
  end

  # line numbering
  def test_numbers_correctly_for_multiple_adds_after_rem
    expected = [
      [193, 193],
      [194, nil],
      [nil, 194],
      [nil, 195],
      [nil, 196],
      [nil, 197],
      [nil, 198],
      [195, 199]
    ]
    assert_equal expected, line_numbers_for(:multiple_adds_after_rem)
  end

  def test_numbers_correctly_for_simple
    expected = [
      [1, 1],
      [2, 2],
      [3, nil],
      [4, nil],
      [nil, 3],
      [nil, 4],
      [nil, 5],
    ]
    assert_equal expected, line_numbers_for(:simple)
  end

  def line_numbers_for(diff)
    diff_data = load_diff(diff)
    data = Diff::Display::Unified::Generator.run(diff_data)
    linenos = []
    data.each do |blk| 
      blk.each do |line|
        next if line.class == Diff::Display::HeaderLine
        linenos << [line.old_number, line.new_number]
      end
    end
    linenos
  end
end
