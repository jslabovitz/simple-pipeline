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
    pipeline = Simple::Pipeline.new
    pipeline << FileReadFilter
    pipeline << ParseFilter
    pipeline << MultiplyFilter
    pipeline << FormatFilter
    pipeline << DecorateFilter
    file = Tempfile.new('foo')
    file.write('1')
    file.rewind
    result = pipeline.process(file)
    assert { result == "Value: 2" }
  end

  def test_chained
    pipeline1 = Simple::Pipeline.new([MultiplyFilter])
    pipeline2 = Simple::Pipeline.new([pipeline1, MultiplyFilter])
    pipeline1.input = 1
    result = pipeline1.output
    assert { result == 2 }
    result = pipeline2.output
    assert { result == 4 }
  end

  def test_multiple
    pipeline1 = Simple::Pipeline.new([MultiplyFilter])
    pipeline2 = Simple::Pipeline.new([pipeline1, FormatFilter, DecorateFilter])
    pipeline3 = Simple::Pipeline.new([pipeline1, Decorate2Filter])
    pipeline1.input = 1
    result = pipeline2.output
    assert { result == "Value: 2" }
    result = pipeline3.output
    assert { result == "VALUE=2" }
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

class Decorate2Filter < Simple::Pipeline::Filter

  def process(value)
    "VALUE=%d" % value
  end

end