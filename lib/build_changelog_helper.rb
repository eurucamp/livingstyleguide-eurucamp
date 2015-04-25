class BuildChangelogHelper

  ROBOTS_TXT = <<-EOT
User-agent: *
Allow: /latest
Allow: /index.html
Disallow: /
EOT

  TEMPLATE = <<-EOT
<!DOCTYPE html>
<html lang="en">
  <head><meta charset="utf-8"><title>eurucamp living style guide</title></head>
  <body>
    <h2><a href="https://github.com/eurucamp/livingstyleguide-eurucamp/">eurucamp/livingstyleguide-eurucamp</a></h2>
    <ul>
      <% for year in builds.map { |b| b["branch"] }.uniq.sort.reverse %>
        <li><a href="<%= year %>/">Latest version for <%= year %></a></li>
      <% end %>
    </ul>
    <dl>
      <% for build in builds.reverse %>
        <dt><a href="<%= build["commit"] %>/"><strong><%= build["branch"] %>:</strong> <%= build["commit"] %></a></dt>
        <dd><strong><%= build["message"] %></strong><br><%= build["author"] %> (<%= build["time"] %>)</dd>
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

  def build_index_for(builds)
    output = ERB.new(TEMPLATE).result(binding)
    File.write('build/index.html', output)
    File.write('build/robots.txt', ROBOTS_TXT)
  end
end
