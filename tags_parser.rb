class TagsParser
  require_relative 'file_operations'
  include FileOperations

  def initialize(file_location)
    @file_location = file_location
  end

  def parse
    file_content = read_file_content
    json_content = parse_json file_content
    convert_content_to_hash json_content
  end

  private
    def read_file_content
      file_content = read_file(@file_location)
      file_content.gsub("\'", "\"") # Required processing to make file content compliant with JSON
    end

    def parse_json(content)
      require 'json'
      begin
        JSON.parse content
      rescue JSON::ParserError
        puts 'File content can\'t be parsed'
      end
    end

    def convert_content_to_hash(content)
      tags = {}
      content = Array(content)
      content.each{ |tag|
        id = tag["id"].to_s
        
        tag_content = if tag["text"]
          tag["text"]
        elsif tag["clauses_ids"]
          tag["clauses_ids"]
        end

        tags[id] = tag_content
      }

      tags
    end
end