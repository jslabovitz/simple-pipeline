require 'minitest/autorun'
require 'minitest/power_assert'

require 'simple-pipeline'

require 'tempfile'

class Test < MiniTest::Test

  def test_number
    pipeline = Simple::Pipeline.new([MultiplyFilter, MultiplyFilter, MultiplyFilter])
    result = pipeline.process(1)
    assert { result == 8 }
  end

  def test_file
    file = Tempfile.new('foo')
    file.write('1')
    file.rewind
    pipeline = Simple::Pipeline.new
    pipeline << FileReadFilter
    pipeline << ParseFilter
    pipeline << MultiplyFilter
    pipeline << FormatFilter
    pipeline << DecorateFilter
    result = pipeline.process(file)
    assert { result == "Value: 2" }
  end

end

class FileReadFilter < Simple::Pipeline::Filter

  def process(value)
    value.read
  end

end

class ParseFilter < Simple::Pipeline::Filter

  def process(value)
    value.to_i
  end

end

class MultiplyFilter < Simple::Pipeline::Filter

  def process(value)
    value * 2
  end

end

class FormatFilter < Simple::Pipeline::Filter

  def process(value)
    value.to_s
  end

end

class DecorateFilter < Simple::Pipeline::Filter

  def process(value)
    "Value: #{value}"
  end

end