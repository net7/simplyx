include Java
module Simplyx
  java_dir = File.join(File.dirname(__FILE__), '..', '..', 'java')
  Dir["#{java_dir}/saxon*.jar"].each { |jar| require jar }
  include_class "javax.xml.transform.TransformerFactory"
  include_class "javax.xml.transform.Transformer"
  include_class "javax.xml.transform.stream.StreamSource"
  include_class "javax.xml.transform.stream.StreamResult"
  include_class "java.lang.System"

  class XsltProcessor

    puts $CLASSPATH

    # This is used to perform xsltransformation, you should pass it the xsl and
    # xml file paths, and some parameters (an hash) if you need them
    def self.perform_transformation(xsl_file, xml_file, transformer_parameters=nil)
      file = File.open(xsl_file)
      xsl = file.read
      file.close
      file = File.open(xml_file)
      xml = file.read
      file.close
      saxon = Simplyx::Saxon.new
      output = saxon.transform(xsl, xml, nil, options = {:in => "string", :out => "string", :xsl => "string", :transformer_parameters => transformer_parameters})
    end

    def transform(xslt, infile, outfile, options)
      if options[:in] == "stream"
        in_var = StreamSource.new(infile)
      else
        sr = java.io.StringReader.new(infile)
        in_var =  StreamSource.new(sr)
      end
      if options[:out] == "stream"
        out_var = StreamResult.new(outfile)
      else
        sw = java.io.StringWriter.new()
        out_var = StreamResult.new(sw)
      end
      if options[:xslt] == "stream"
        xslt_var = StreamSource.new(xslt)
      else
        sxs = java.io.StringReader.new(xslt)
        xslt_var = StreamSource.new(sxs)
      end
      transformer = @tf.newTransformer(xslt_var)
      unless options[:transformer_parameters].nil?
        options[:transformer_parameters].each do |key, value|
          transformer.setParameter(key, java.lang.String.new(value))
        end
      end
      transformer.transform(in_var, out_var)
      if options[:out] != "stream"
        outfile = sw.toString()
      end
    end
  end # XsltProcessor

  class Saxon < XsltProcessor
    TRANSFORMER_FACTORY_IMPL = "net.sf.saxon.TransformerFactoryImpl"
    def initialize
      System.setProperty("javax.xml.transform.TransformerFactory", TRANSFORMER_FACTORY_IMPL)
      @tf = TransformerFactory.newInstance
    end
  end
  # This class can be used in order to use Xalan as a XSLTransformer
  # of course xalan jars must be added and included in this file as well
  #  class Xalan < XsltProcessor
  #    TRANSFORMER_FACTORY_IMPL = "org.apache.xalan.processor.TransformerFactoryImpl"
  #    def initialize
  #      System.setProperty("javax.xml.transform.TransformerFactory", TRANSFORMER_FACTORY_IMPL)
  #    @tf = TransformerFactory.newInstance
  #  end
end
