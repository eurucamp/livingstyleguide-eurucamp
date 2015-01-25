class BuildChangelogHelper
  # Format of each commit line (see `git help log`)
  GIT_FORMAT = '<dt><a href="%h">%h</a></dt><dd><strong>%s</strong><br/>by %an, <em>%ai</em></dd>'

  GIT_CMD = "git log -30 --no-merges --pretty=format:'#{GIT_FORMAT}'"

  TEMPLATE = <<-EOT
<!DOCTYPE html>
<html lang="en">
  <head><meta charset="utf-8"><title>eurucamp living style guide</title></head>
  <body>
    <h2><a href="https://github.com/eurucamp/livingstyleguide-eurucamp/">eurucamp/livingstyleguide-eurucamp</a></h2>
    <p>
    <a href="latest">Latest deploy (<%= head %>)</a>:
    <pre><%= latest_commit %></pre>
    </p>
    <dl>
      <% for @log_line in @log_lines %>
      <%= @log_line.strip %>
      <% end %>
    </dl>
  </body>
</html>
EOT

  def head
    %x{git rev-parse --short HEAD}.strip
  end

  def latest_commit
    %x{git show --pretty=full --name-status HEAD}.strip
  end

  def build_index
    @log_lines = %x{#{GIT_CMD}}.lines
    output = ERB.new(TEMPLATE).result(binding)
    File.write('build/index.html', output)
  end
end
