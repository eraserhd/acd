
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

      def remedy
        @remedy = Apothecary.potentize(remedy_name) unless @remedy
        @remedy
      end

      def submodule_path
        "submodules/#{remedy.name}"
      end

      def invoke
        abort "Unable to add git submodule" unless system "git", "submodule", "add", remedy.repository, submodule_path
        abort "Unable to add files" unless system "git", "add", ".gitmodules", submodule_path
        XcodeBuilder.new(remedy.xcode_project, submodule_path).build if remedy.xcode_project
        abort "Unable to commit" unless system "git", "commit", "-m", "Import #{remedy.name}"
      end
      
    end

  end
end
