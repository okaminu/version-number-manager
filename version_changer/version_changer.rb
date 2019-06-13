require_relative '../occurrences_in_files_factory/occurrences_in_files_factory'

VersionNumberReplacement = Struct.new(:current_version, :new_version)

class VersionChanger
  def replace_in_files(config_path, version_replacement, base_path)
    occurrences = OccurrencesInFilesFactory.from_csv(config_path)
    occurrences.each { |occ| replace_in_file(occ, version_replacement, base_path) }
  end

  private

  def replace_in_file(occurrence_in_file, replacement, base_path)
    file_path = base_path + '/' + occurrence_in_file.relative_path
    file_content = File.read(file_path)

    occurrence_count = file_content.scan(replacement.current_version).count
    unless occurrence_in_file.occurrences == occurrence_count
      warn(get_wrong_count_message(occurrence_in_file, occurrence_count))
      return
    end

    write_to_file(file_path, file_content.gsub(replacement.current_version, replacement.new_version))
  end

  def write_to_file(file_path, content)
    File.open(file_path, 'w') do |f|
      f.write(content)
    end
  end

  def get_wrong_count_message(occurrence_in_file, actual_count)
    "#{occurrence_in_file.relative_path} contains unexpected count of version numbers, " \
      "expected #{occurrence_in_file.occurrences}, got #{actual_count}"
  end
end
