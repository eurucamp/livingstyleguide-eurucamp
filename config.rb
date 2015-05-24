###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page "index.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

activate :autoprefixer, inline: true

# Methods defined in the helpers block are available in templates
helpers do
  def commit
    `git log -1 --pretty=%h`.strip
  end

  def builds
    begin
      history = JSON.parse(open("http://style-guide.eurucamp.org/builds.json").read)
    rescue OpenURI::HTTPError
      history = []
    end
    history << {
      "commit"  => commit,
      "message" => `git log -1 --pretty=%B`.split("\n").first.strip,
      "author"  => `git log -1 --pretty=%an`.strip,
      "time"    => `git log -1 --pretty=%ad`.strip
    }
    history
  end

  def years
    Dir.glob("source/*").map do |file|
      File.basename(file)
    end.reject do |file|
      not file =~ /^20\d\d$/
    end
  end
end

StyleGuideAPI.initialize
years.sort.reverse.each do |year|
  StyleGuideAPI.add_templates "source/#{year}/components/*.haml", theme: year
  if build?
    StyleGuideAPI.add_stylesheet "http://style-guide.eurucamp.org/#{commit}/#{year}/eurucamp.css"
  else
    StyleGuideAPI.add_stylesheet "http://localhost:4567/#{year}/eurucamp.css"
  end
end
activate :styleguide_api

activate :relative_assets

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

after_build do |builder|
  commit = `git log -1 --pretty=%h`.strip
  FileUtils.rm_r "#{build_dir}/#{commit}", force: true
  files = Dir.glob("#{build_dir}/*")
  FileUtils.mkdir "#{build_dir}/#{commit}"
  files.each do |file|
    file = File.basename(file)
    FileUtils.cp_r("#{build_dir}/#{file}", "#{build_dir}/#{commit}/#{file}")
  end
end

module InlineSVG

  def inline_svg(path, mime_type = nil)
    path = path.value
    root = File.dirname(environment.options[:original_filename])
    real_path = root + "/images/" + path
    svg = File.read(real_path)
    colors = File.readlines(root + "/base/_colors.sass").compact
    colors.each do |line|
      if m = line.match(%r(^(?<variable>.+):\s*(?<color>.+)$))
        svg.gsub! m[:variable], m[:color]
      end
    end
    inline_image_string(svg, 'image/svg+xml')
  end

  protected
  def inline_image_string(data, mime_type)
    data = [data].flatten.pack('m').gsub("\n","")
    url = "url('data:#{mime_type};base64,#{data}')"
    unquoted_string(url)
  end

  private
  def data(real_path)
    if File.readable?(real_path)
      File.open(real_path, "rb") {|io| io.read}
    else
      raise ::Compass::Error, "File not found or cannot be read: #{real_path}"
    end
  end

end

module ::Sass::Script::Functions
  include InlineSVG
end

activate :s3_sync do |s3_sync|
  s3_sync.bucket = 'style-guide.eurucamp.org'
  s3_sync.region = 'eu-west-1'
end

helpers do
  def md2html(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text)
  end
end
