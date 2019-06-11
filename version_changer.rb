class VersionChanger

  def change(config_path, old_version, new_version, base_path)
    base_path ||= '../'
    locations = CsvConverter.new.convert(config_path)
    for loc in locations do
      replace_in_file(loc, old_version, new_version, base_path)
    end
  end

  private

  def replace_in_file(location, old_version, new_version, base_path)
    file = File.read(base_path + '/' + location.relative_path)
    actual_count = file.scan(old_version).count

    unless actual_count == location.occurances
      abort("#{location.relative_path} contains unexpected count of version number, " +
                "expected #{location.occurances}, got #{actual_count}")
    end

    file_with_changed_versions = file.gsub(old_version, new_version)

    File.open(base_path + '/' + location.relative_path, "w") do |f|
      f.write(file_with_changed_versions)
    end
  end

end