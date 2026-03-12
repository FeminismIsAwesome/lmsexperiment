class QuestionResponsesController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @page = @question.page
    @lesson = @page.lesson
    
    if @question.free_text?
      @response = @question.question_responses.find_or_initialize_by(session_hash: session_hash)
      @response.answer_text = params[:answer_text]

      if @response.save
        redirect_back_or_to lesson_path(@lesson, page_id: @page.id), notice: "Thank you for your response!"
      else
        redirect_back_or_to lesson_path(@lesson, page_id: @page.id), alert: "Unable to save your response."
      end
    elsif @question.multiple_answers
      option_ids = params[:question_option_ids] || []
      # Remove old responses for this question and session
      @question.question_responses.where(session_hash: session_hash).destroy_all
      
      # Create new responses
      option_ids.each do |option_id|
        @question.question_responses.create(session_hash: session_hash, question_option_id: option_id)
      end
      
      redirect_back_or_to lesson_path(@lesson, page_id: @page.id), notice: "Thank you for your responses!"
    else
      @response = @question.question_responses.find_or_initialize_by(session_hash: session_hash)
      @response.question_option_id = params[:question_option_id]

      if @response.save
        redirect_back_or_to lesson_path(@lesson, page_id: @page.id), notice: "Thank you for your response!"
      else
        redirect_back_or_to lesson_path(@lesson, page_id: @page.id), alert: "Unable to save your response."
      end
    end
  end
end
