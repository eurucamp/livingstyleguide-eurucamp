require 'fileutils'
require 'json'
require 'open-uri'
require_relative 'build_changelog_helper'

class BuildChangelog < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
    changelog_helper = BuildChangelogHelper.new

    app.after_build do |builder|
      latest = 'build/latest'
      builder.remove_dir latest
      info = JSON.parse(File.read("#{build_dir}/info.json"))
      begin
        builds = JSON.parse(open("http://style-guide.eurucamp.org/builds.json").read)
      rescue OpenURI::HTTPError
        builds = []
      end
      builds << info
      FileUtils.cp_r(build_dir, "build/#{info["branch"]}")
      changelog_helper.build_index_for builds
    end

    app.after_configuration do
      app.set :build_dir, File.join('build', changelog_helper.head)
    end
  end
end

::Middleman::Extensions.register(:build_changelog, BuildChangelog)
