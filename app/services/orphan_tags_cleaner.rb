# Removes tags that have been orphaned
class OrphanTagsCleaner
  def clean
    question_tags = Arel::Table.new(:questions_tags)
    tags = Tag.arel_table

    Tag.where(question_tags.where(question_tags[:tag_id].eq(tags[:id])).exists.not).destroy_all
  end
end
