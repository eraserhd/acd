require 'acd/remedy'

module ACD

  class Apothecary

    def self.directory
      ENV['ACD_APOTHECARY'] or File.join(File.dirname(__FILE__),'apothecary')
    end

    def self.potentize formula_name
      if formula_name =~ /[\/:@\.]/
        return Remedy.new do |r|
          r.repository = formula_name
        end
      end

      begin
        load File.join(self.directory, "#{formula_name}.rb")
        return ACD::Remedy.last_created
      rescue LoadError => e
        return nil 
      end
    end
    
  end

end
