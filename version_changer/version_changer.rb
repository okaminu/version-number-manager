class VersionChanger

  def substitute(file_path, old_version, new_version, change_count)
    file_content = File.read(file_path)

    counted_old_version_numbers = file_content.scan(old_version).count
    unless change_count == counted_old_version_numbers
      STDERR.puts("#{file_path} contains unexpected count of version numbers, " +
                      "expected #{change_count}, got #{counted_old_version_numbers}")
      return
    end

    File.open("/file/path", "w") do |f|
      f.write(file_content.gsub(old_version, new_version))
    end
  end

end
