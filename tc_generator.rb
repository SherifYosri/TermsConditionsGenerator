class TCGenerator
  require_relative 'file_operations'
  include FileOperations

  def initialize(template_location:, clauses_file_location: "", sections_file_location: "")
    @template = read_file(template_location)
    @clauses = clauses_file_location.empty?? {} : parse_tags(clauses_file_location)
    @sections = sections_file_location.empty?? {} : parse_tags(sections_file_location)
  end

  def generate_document(target_location)
    @template = populate_clauses unless @clauses.empty?
    @template = populate_sections unless @sections.empty?
    write_file(target_location, @template)
  end

  private
    def parse_tags(tags_file_location)
      require_relative 'tags_parser'
      TagsParser.new(tags_file_location).parse
    end

    def populate_clauses
      require_relative 'clauses_replacer'
      ClausesReplacer.new(@template).replace(@clauses)
    end

    def populate_sections
      require_relative 'sections_replacer'
      SectionsReplacer.new(@template).replace(@clauses, @sections)
    end
end