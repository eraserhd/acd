
module ACD

  class Apothecary

    def self.directory
      ENV['ACD_APOTHECARY'] or File.join(File.dirname(__FILE__),'apothecary')
    end

    def self.potentize formula_name
      nil    
    end
    
  end

end
