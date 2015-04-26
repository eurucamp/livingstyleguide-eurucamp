require 'fileutils'

class BuildChangelogHelper

  def head
    %x{git rev-parse --short HEAD}.strip
  end

  def build_index_for(builds)
    years = builds.map { |b| b["branch"] }.uniq
    Dir.glob("index/*").each do |file|
      if file =~ /(\.[a-z]+){2}$/
        output = Tilt.new(file).render(nil, builds: builds, years: years)
        File.write(file.sub(/^index(.+)\.[a-z]+$/, 'build/\\1'), output)
      else
        FileUtils.cp file, file.sub(/^index/, "build")
      end
    end
  end

end
