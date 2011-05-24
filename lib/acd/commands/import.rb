
require 'acd/command'
require 'acd/apothecary'

module ACD
  module Commands

    class Import < Command

      SUMMARY = 'import a third party repository as a submodule'

      def remedy_name
        args.first
      end

      def name
        remedy_name.sub(/\.git$/, "").sub(/^.*\//, "")
      end

      def invoke
        remedy = Apothecary.potentize(remedy_name)
        
        abort "Unable to add git submodule" unless system "git", "submodule", "add", remedy.repository, "submodules/#{name}"
        abort "Unable to add files" unless system "git", "add", ".gitmodules", "submodules/#{name}"
        abort "Unable to commit" unless system "git", "commit", "-m", "Import #{name}"
      end
      
    end

  end
end
