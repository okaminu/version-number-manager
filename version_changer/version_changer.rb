require_relative '../occurrences_in_files_factory/occurrences_in_files_factory'

VersionNumberReplacement = Struct.new(:current_version, :new_version)

def replace_in_files(config_path, version_replacement, base_path)
  occurrences = OccurrencesInFilesFactory.from_csv(config_path)
  occurrences.each { |occ| replace_in_file(occ, version_replacement, base_path) }
end

def replace_in_file(occurrence_in_file, version_replacement, base_path)
  file_content = File.read(base_path + '/' + occurrence_in_file.relative_path)

  counted_version_occurrences = file_content.scan(version_replacement.current_version).count
  unless occurrence_in_file.occurrences == counted_version_occurrences
    warn("#{occurrence_in_file.relative_path} contains unexpected count of version numbers, " \
                    "expected #{occurrence_in_file.occurrences}, got #{counted_version_occurrences}")
    return
  end

  File.open(base_path + '/' + occurrence_in_file.relative_path, 'w') do |f|
    f.write(file_content.gsub(version_replacement.current_version, version_replacement.new_version))
  end
end
