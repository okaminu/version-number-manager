require_relative '../csv_converter/csv_converter'

class VersionChanger

  def change(config_path, old_version, new_version, base_path)
    base_path ||= '..'
    locations = CsvConverter.new.convert(config_path)
    for loc in locations do
      replace_in_file(loc, old_version, new_version, base_path)
    end
  end

  private

  def replace_in_file(location, old_version, new_version, base_path)
    file_content = File.read(base_path + '/' + location.relative_path)

    counted_old_version_numbers = file_content.scan(old_version).count
    unless location.occurances == counted_old_version_numbers
      STDERR.puts("#{location.relative_path} contains unexpected count of version numbers, " +
                      "expected #{location.occurances}, got #{counted_old_version_numbers}")
      return
    end

    File.open(base_path + '/' + location.relative_path, "w") do |f|
      f.write(file_content.gsub(old_version, new_version))
    end
  end

end
