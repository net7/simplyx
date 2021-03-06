require 'helper'

class TestSimplyx < Test::Unit::TestCase
  
  def setup
    @test_dir = File.join(File.dirname(__FILE__))
  end
  
  def test_transform
    Simplyx::XsltProcessor.perform_transformation(tf('xslt_test.xsl'), tf('xslt_test.xml')) 
  end
  
  private
  
  # Returns the full file name of the file in the test directory
  def tf(file)
    File.join(@test_dir, file)
  end
  
end
