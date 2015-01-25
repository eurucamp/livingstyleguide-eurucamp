require 'fileutils'
require_relative 'build_changelog_helper'

class BuildChangelog < Middleman::Extension
  def initialize(app, options_hash={}, &block)
    super
    changelog_helper = BuildChangelogHelper.new

    app.after_build do |builder|
      latest = 'build/latest'
      builder.remove_dir latest
      FileUtils.cp_r(build_dir, latest)
      changelog_helper.build_index
    end

    app.after_configuration do
      app.set :build_dir, File.join('build', changelog_helper.head)
    end
  end
end

::Middleman::Extensions.register(:build_changelog, BuildChangelog)
