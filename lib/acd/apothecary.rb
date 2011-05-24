require 'acd/remedy'

module ACD

  class Apothecary

    def self.directory
      ENV['ACD_APOTHECARY'] or File.join(File.dirname(__FILE__),'apothecary')
    end

    def self.potentize formula_name
      if formula_name =~ /[\/:@\.]/
        return Remedy.new do |r|
          r.name = formula_name.sub(/\.git$/, "").sub(/^.*\//, "")
          r.repository = formula_name
        end
      end

      begin
        load File.join(self.directory, "#{formula_name}.rb")
        remedy = ACD::Remedy.last_created
        remedy.name = formula_name
        remedy
      rescue LoadError => e
        nil 
      end
    end
    
  end

end
