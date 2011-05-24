
module ACD

  class Apothecary

    def self.directory
      ENV['ACD_APOTHECARY'] or File.join(File.dirname(__FILE__),'apothecary')
    end
    
  end

end
