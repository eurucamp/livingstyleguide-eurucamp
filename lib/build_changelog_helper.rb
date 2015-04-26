class BuildChangelogHelper

  def head
    %x{git rev-parse --short HEAD}.strip
  end

  def build_index_for(builds)
    years = builds.map { |b| b["branch"] }.uniq
    Dir.glob("index/*").each do |file|
      output = Tilt.new(file).render(nil, builds: builds, years: years)
      File.write(file.sub(/^index(.+)\.[a-z]+$/, 'build/\\1'), output)
    end
  end

end
