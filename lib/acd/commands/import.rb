
require 'acd/command'

module ACD
  module Commands

    class Import < Command

      def origin
        args.first
      end

      def name
        origin.sub(/\.git$/, "").sub(/^.*\//, "")
      end

      def invoke
        abort "Unable to add git submodule" unless system(*["git", "submodule", "add", origin, "submodules/#{name}"])
      end
      
    end

  end
end
