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

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

require "csv"
require "ostruct"

helpers do
  def clinic_data
    @clinic_data ||= CSV.parse(File.read("data/clinic_data.csv"), headers: true)
  end

  def services(data = clinic_data)
    @services ||= create_hash_for_key(data, ["Clinical Services", "Routine Services"])
  end

  def languages(data = clinic_data)
    @languages ||= create_hash_for_key(data, "Language")
  end

  def bus_routes(data = clinic_data)
    @bus_routes ||= create_hash_for_key(data, "Bus Route")
  end

  def populations_served(data = clinic_data)
    @populations_served ||= create_hash_for_key(data, ["Payer Population Served", "Special Populations Served"])
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

    data.each do |row|
      [keys].flatten.each do |key|
        (row[key] || "").split(",").map(&:strip).compact.each do |service|
          hash[service].push(row["Id"])
        end
      end
    end

    hash
  end
end

def create_hash_for_key(data, keys)
  hash = Hash.new{|h,k| h[k] = []}

  data.each_with_index do |row, index|
    [keys].flatten.each do |key|
      (row[key] || "").split(",").map(&:strip).compact.each do |service|
        hash[service].push(row["Id"])
      end
    end
  end

  hash
end

def clinic_data
  @clinic_data ||= CSV.parse(File.read("data/clinic_data.csv"), headers: true)
end

def services(data = clinic_data)
  @services ||= create_hash_for_key(clinic_data, ["Clinical Services", "Routine Services"])
end

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

services.each do |service, ids|
  proxy(
    "/services/#{service.parameterize}/index.html",
    "/service.html",
    locals: {
      clinic_data: clinic_data.select { |row|
        ids.include? row["Id"]
      }
    },
  )
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
