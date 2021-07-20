require_relative 'tags_replacer'

class ClausesReplacer < TagsReplacer
  def initializer(template)
    super(template)
  end

  def replace(clauses)
    ids = get_tag_ids(tag: "CLAUSE-")
    representations = clauses_representations(ids, clauses)
    replace_tags(representations)

    @template
  end

  private
    def clauses_representations(ids, clauses)
      representations = {}
      ids.each{ |id|
        unless clauses[id].nil?
          representations["[CLAUSE-#{id}]"] = clauses[id]
        end
      }

      representations
    end
end