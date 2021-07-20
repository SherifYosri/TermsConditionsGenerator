require_relative '../tags_parser'

describe TagsParser do
  describe "parse" do
    
    def write_tags_file(type)
      target_location = "tags.txt"
      file_content = if type == :clause
        "[{ \"id\": 1, \"text\": 'The quick brown fox' }, { \"id\": 2, \"text\": 'jumps over the lazy dog' }]"
      elsif type == :section
        "[{ \"id\": 4, \"clauses_ids\": [1, 2]} ]"
      end
      File.write(target_location, file_content)

      target_location
    end

    context "happy path scenario" do
      it "returns hash if tags type is clauses" do
        clauses_file_location = write_tags_file(:clause)
        parsed_clauses_tags = TagsParser.new(clauses_file_location).parse
        expect(parsed_clauses_tags.class).to eq(Hash)

        File.delete(clauses_file_location)
      end

      it "returns hash if tags type is sections" do
        sections_file_location = write_tags_file(:section)
        parsed_sections_tags = TagsParser.new(sections_file_location).parse
        expect(parsed_sections_tags.class).to eq(Hash)

        File.delete(sections_file_location)
      end

      it "returns hash with one entry representing clauses tags file" do
        clauses_file_location = write_tags_file(:clause)
        parsed_clauses_tags = TagsParser.new(clauses_file_location).parse
        
        expect(parsed_clauses_tags.keys.count).to eq(2)
        expect(parsed_clauses_tags.keys.include? "2").to eq(true)
        expect(parsed_clauses_tags["2"]).to eq("jumps over the lazy dog")

        File.delete(clauses_file_location)
      end

      it "returns hash with one entry representing sections tags file" do
        sections_file_location = write_tags_file(:section)
        parsed_sections_tags = TagsParser.new(sections_file_location).parse
        
        expect(parsed_sections_tags.keys.count).to eq(1)
        expect(parsed_sections_tags.keys.include? "4").to eq(true)
        expect(parsed_sections_tags["4"]).to eq([1, 2])

        File.delete(sections_file_location)
      end
    end

    context "failures" do
      it "returns empty hash if file location is invalid" do
        parsed_clauses_tags = TagsParser.new("").parse
        
        expect(parsed_clauses_tags.empty?).to eq(true)
      end

      it "returns empty hash if file content is invalid" do
        target_location = "tags.txt"
        File.write(target_location, "invalid content" )
        parsed_clauses_tags = TagsParser.new(target_location).parse
        
        expect(parsed_clauses_tags.empty?).to eq(true)

        File.delete(target_location)
      end
    end
  end
end