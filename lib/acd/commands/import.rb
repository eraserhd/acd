
require 'acd/command'
require 'acd/apothecary'
require 'acd/xcode_builder'

module ACD
  module Commands

    class Import < Command

      SUMMARY = 'import a third party repository as a submodule'

      def remedy_name
        args.first
      end

      def invoke
        remedy = Apothecary.potentize(remedy_name)
        
        abort "Unable to add git submodule" unless system "git", "submodule", "add", remedy.repository, "submodules/#{remedy.name}"
        abort "Unable to add files" unless system "git", "add", ".gitmodules", "submodules/#{remedy.name}"
        XcodeBuilder.new(remedy.xcode_project).build if remedy.xcode_project
        abort "Unable to commit" unless system "git", "commit", "-m", "Import #{remedy.name}"
      end
      
    end

  end
end
