require 'erb'

module ACD
  class XcodeBuilder

    PBXPROJ_TEMPLATE = File.join(File.dirname(__FILE__), 'project.pbxproj.erb')

    def initialize project, imported_from
      @project = project
      @imported_from = imported_from
    end

    def template_text
      File.read PBXPROJ_TEMPLATE
    end
    private :template_text

    def project_name
      File.basename(Dir.getwd)
    end
    private :project_name

    def pbxproj_contents
      ERB.new(template_text).result(binding)
    end
    private :pbxproj_contents

    def project_xcodeproj_path
      "#{project_name}.xcodeproj"
    end
    private :project_xcodeproj_path

    def project_pbxproj_path
      "#{project_xcodeproj_path}/project.pbxproj"
    end
    private :project_pbxproj_path

    def build
      Dir.mkdir(project_xcodeproj_path)
      File.open(project_pbxproj_path, "w") {|f| f.write(pbxproj_contents)}
      system "git", "add", project_pbxproj_path
    end
    
  end
end
