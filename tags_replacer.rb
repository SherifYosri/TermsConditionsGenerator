class TagsReplacer
  def initialize(template)
    @template = template
  end

  def get_tag_ids(tag:)
    ids = []
    indices = find_tag_occurrences(tag)
    indices.each{ |element| ids << @template[element + tag.size] }

    ids
  end

  def replace_tags(tags_dictionary)
    tags_dictionary.each{ |tag, representation|
      @template.gsub!(tag, representation)
    }

    @template
  end

  def replace(tags)
    raise NotImplementedError
  end

  private
    def find_tag_occurrences(tag)
      tag_regex = /(?=#{tag})/
      @template.enum_for(:scan, tag_regex).map do
        Regexp.last_match.offset(0).first
      end
    end
end