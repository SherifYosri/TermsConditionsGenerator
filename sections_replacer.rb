require_relative 'tags_replacer'

class SectionsReplacer < TagsReplacer
  def initializer(template)
    super(template)
  end

  def replace(clauses, sections)
    @clauses = clauses
    ids = get_tag_ids(tag: "SECTION-")
    representations = sections_representations(ids, sections)
    replace_tags(representations)

    @template
  end

  private
    def sections_representations(ids, sections)
      tags_representations = {}
      ids.each{ |id|
        unless sections[id].nil?
          tags_representations["[SECTION-#{id}]"] = single_section_representation(Array(sections[id]))
        end
      }

      tags_representations
    end

    def single_section_representation(clauses_ids)
      section_representation = ""
      clauses_ids.each{ |id|
        section_representation += "#{@clauses[id.to_s]};" if @clauses[id.to_s]
      }

      section_representation.delete_suffix(";")
    end

end