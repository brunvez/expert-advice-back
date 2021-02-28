# Updates a question and its associated tasks
class QuestionEdition
  InvalidEditor = Class.new(StandardError)

  def initialize(question:, title:, description:, tags:, editor:)
    @question = question
    @quesiton_params = { title: title, description: description }
    @tags = tags
    @editor = editor
  end

  def call
    raise InvalidEditor, 'Only the creator of a question can edit it' unless question.creator == editor

    ActiveRecord::Base.transaction do
      question.update!(@quesiton_params)
      question.tags = tags.uniq.map { |text| Tag.find_or_create_by!(text: text) }
      destroy_orphan_tags

      question
    end
  end

  private

  attr_reader :question, :quesiton_params, :tags, :editor

  def destroy_orphan_tags
    question_tags = Arel::Table.new(:questions_tags)
    tags = Tag.arel_table

    Tag.where(question_tags.where(question_tags[:tag_id].eq(tags[:id])).exists.not).destroy_all
  end
end
