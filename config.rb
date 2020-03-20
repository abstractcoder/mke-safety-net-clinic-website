# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

require "csv"
require "ostruct"

helpers do
  def clinic_data
    @clinic_data ||= CSV.parse(File.read("data/clinic_data.csv"), headers: true)
  end

  def services
    @services ||= create_hash_for_key(clinic_data, ["Clinical Services", "Routine Services"])
  end

  def languages
    @languages ||= create_hash_for_key(clinic_data, "Language")
  end

  def bus_routes
    @bus_routes ||= create_hash_for_key(clinic_data, "Bus Route")
  end

  def populations_served
    @populations_served ||= create_hash_for_key(clinic_data, ["Payer Population Served", "Special Populations Served"])
  end

  def sort_hash(hash)
    hash.sort_by{|service, ids| -ids.count}
  end

  def p(str)
    (str || "").split(",").map(&:strip).join(", ")
  end

  def pp(str)
    str.split(",").map(&:strip).join("<br>").html_safe
  end

  def create_hash_for_key(data, keys)
    hash = Hash.new{|h,k| h[k] = []}

    data.each_with_index do |row, index|
      [keys].flatten.each do |key|
        (row[key] || "").split(",").map(&:strip).compact.each do |service|
          hash[service].push(index)
        end
      end
    end

    hash
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
