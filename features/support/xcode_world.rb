
module XcodeWorld

  def xcode_targets
    xcodebuild_list_output.gsub(/\n/, "/").gsub(/^.*Targets:/, "").gsub(/Build Configurations:.*$/, "").lines.map(&:strip)
  end

  def xcodebuild_list_output
    in_current_dir do
      IO.popen("xcodebuild -list 2>/dev/null", "r") {|f| f.read}
    end
  end
  private :xcodebuild_list_output

end
