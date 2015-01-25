require 'lib/build_changelog'
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

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :relative_assets

activate :build_changelog

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

LivingStyleGuide::Example.add_filter :markdown do
  begin
    @syntax = :markdown

    pre_processor do |markdown|
      renderer = LivingStyleGuide::RedcarpetHTML.new(prefix: 'text--')
      redcarpet = ::Redcarpet::Markdown.new(renderer, LivingStyleGuide::REDCARPET_RENDER_OPTIONS)
      %Q(<article class="text">\n#{redcarpet.render(markdown)}\n</article>)
    end

  end
end


module InlineSVG

  def inline_svg(path, mime_type = nil)
    path = path.value
    real_path = File.join(::Compass.configuration.images_path, path)
    svg = data(real_path)
    colors = File.readlines(File.join(%w(source stylesheets base _colors.sass))).compact
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
