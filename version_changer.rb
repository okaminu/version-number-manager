class VersionChanger

  def substitute(file_path, old_version, new_version, expected_count)

    file = File.read(file_path)
    actual_count = file.scan(old_version).count

    unless actual_count == expected_count
      abort("#{file_path} contains unexpected count of version number, " +
                "expected #{expected_count}, got #{actual_count}")
    end

    file_with_changed_versions = file.gsub(old_version, new_version)

    File.open(file_path, "w") do |f|
      f.write(file_with_changed_versions)
    end

  end

end