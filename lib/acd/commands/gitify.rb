
require 'acd/command'

module ACD
  module Commands

    class Gitify < Command

      SUMMARY = 'initialize this directory as a project'

      INITIAL_GITIGNORE_CONTENTS = <<-EOF
build
xcuserdata
*.xcworkspace
EOF

      def invoke
        abort "Unable to initialize repository" unless system "git", "init"
        File.open(".gitignore", "w") {|f| f.write(INITIAL_GITIGNORE_CONTENTS)}
        abort "Unable to add files" unless system "git", "add", "-A"
        abort "Unable to commit" unless system "git", "commit", "-m", "Initialize with Apothecary"
      end

    end

  end
end
