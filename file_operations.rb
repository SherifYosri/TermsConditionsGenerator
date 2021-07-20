module FileOperations
  def read_file(location)
    begin
      File.read(location)
    rescue Errno::ENOENT
      puts 'File not found'
      ""
    end
  end

  def write_file(target_location, file_content)
    begin
      File.write(target_location, file_content)
    rescue Errno::ENOENT
      puts 'Target location is invalid'
      ""
    end
  end
end