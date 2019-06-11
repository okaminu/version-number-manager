require_relative '../csv_converter/csv_converter'

class VersionChanger

  def change(config_path, version_replacement, base_path)
    base_path ||= '..'
    locations = CsvConverter.new.convert(config_path)
    for loc in locations do
      replace_in_file(loc, version_replacement, base_path)
    end
  end

  private

  def replace_in_file(location, version_replacement, base_path)
    file_content = File.read(base_path + '/' + location.relative_path)

    counted_old_version_numbers = file_content.scan(version_replacement.old_version).count
    unless location.occurrences == counted_old_version_numbers
      STDERR.puts("#{location.relative_path} contains unexpected count of version numbers, " +
                      "expected #{location.occurrences}, got #{counted_old_version_numbers}")
      return
    end

    File.open(base_path + '/' + location.relative_path, "w") do |f|
      f.write(file_content.gsub(version_replacement.old_version, version_replacement.new_version))
    end
  end

end
