require_relative '../tc_generator'

describe TCGenerator do
  describe "generate_document" do
    before(:example) do
      def prepare_generator_params
        @template_file_location = write_template_file
        @clauses_file_location = write_tags_file(:clause)
        @sections_file_location = write_tags_file(:section)
      end

      def write_tags_file(type)
        if type == :clause
          file_content = "[{ \"id\": 1, \"text\": 'The quick brown fox' }, { \"id\": 2, \"text\": 'jumps over the lazy dog' }]"
          target_location = "clause_tags.txt"
        elsif type == :section
          file_content = "[{ \"id\": 1, \"clauses_ids\": [1, 2]} ]"
          target_location = "sections_tags.txt"
        end
        File.write(target_location, file_content)

        target_location
      end

      def write_template_file
        target_location = "template.txt"
        file_content = "A T&C Document\n\nThis document is made of plaintext.\nIs made of [CLAUSE-2].\nIs made of [SECTION-1].\n"
        File.write(target_location, file_content)

        target_location
      end

      def clean_created_files
        File.delete(@template_file_location)
        File.delete(@clauses_file_location)
        File.delete(@sections_file_location)
        File.delete(@document_file_location)
      end
    end

    context "happy path scenario" do
      it "creates a file for the evaluated document" do
        prepare_generator_params

        generator = TCGenerator.new(
          template_location: @template_file_location, 
          clauses_file_location: @clauses_file_location, 
          sections_file_location: @sections_file_location
        )

        @document_file_location = "document.txt"
        generator.generate_document(@document_file_location)

        expect(File.file?("document.txt")).to eq(true)

        clean_created_files
      end

      it "replaces clauses and sections in the template with their corresponding values in the dataset" do
        prepare_generator_params
        generator = TCGenerator.new(
          template_location: @template_file_location, 
          clauses_file_location: @clauses_file_location, 
          sections_file_location: @sections_file_location
        )

        @document_file_location = "document.txt"
        generator.generate_document(@document_file_location)

        expected_document_content = "A T&C Document\n\nThis document is made of plaintext.\nIs made of jumps over the lazy dog.\nIs made of The quick brown fox;jumps over the lazy dog.\n"

        expect(File.read("document.txt")).to eq(expected_document_content)

        clean_created_files
      end
    end

    context "failures" do
      it "returns an empty string in case of invalid target location for the generate document" do
        prepare_generator_params
        generator = TCGenerator.new(
          template_location: @template_file_location, 
          clauses_file_location: @clauses_file_location, 
          sections_file_location: @sections_file_location
        )

        doc = generator.generate_document("")

        expect(doc).to eq("")
      end
    end
  end
end