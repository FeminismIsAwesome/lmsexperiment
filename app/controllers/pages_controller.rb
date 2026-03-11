class PagesController < ApplicationController
  before_action :set_page, only: %i[ show edit update destroy ]

  # GET /pages or /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1 or /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new(lesson_id: params[:lesson_id])
    build_empty_survey
  end

  # GET /pages/1/edit
  def edit
    build_empty_survey
  end

  # POST /pages or /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to lesson_path(@page.lesson, page_id: @page.id), notice: "Page was successfully created." }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1 or /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to lesson_path(@page.lesson, page_id: @page.id), notice: "Page was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1 or /pages/1.json
  def destroy
    @page.destroy!

    respond_to do |format|
      format.html { redirect_to pages_path, notice: "Page was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params.expect(:id))
    end

    def build_empty_survey
      if @page.questions.empty?
        question = @page.questions.build
        3.times { question.question_options.build }
      end
    end

    def page_params
      params.require(:page).permit(:lesson_id, :title, :content, :position,
        questions_attributes: [:id, :text, :multiple_answers, :_destroy,
          question_options_attributes: [:id, :text, :_destroy]]
      )
    end
end
