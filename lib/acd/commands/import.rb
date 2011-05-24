
require 'acd/command'

module ACD
  module Commands

    class Import < Command

      SUMMARY = 'import a third party repository as a submodule'

      def origin
        args.first
      end

      def name
        origin.sub(/\.git$/, "").sub(/^.*\//, "")
      end

      def invoke
        abort "Unable to add git submodule" unless system "git", "submodule", "add", origin, "submodules/#{name}"
        abort "Unable to add files" unless system "git", "add", ".gitmodules", "submodules/#{name}"
        abort "Unable to commit" unless system "git", "commit", "-m", "Import #{name}"
      end
      
    end

  end
end
