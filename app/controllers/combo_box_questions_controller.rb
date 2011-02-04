class ComboBoxQuestionsController < ApplicationController
  # GET /combo_box_questions
  # GET /combo_box_questions.xml
  def index
    @combo_box_questions = ComboBoxQuestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @combo_box_questions }
    end
  end

  # GET /combo_box_questions/1
  # GET /combo_box_questions/1.xml
  def show
    @combo_box_question = ComboBoxQuestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @combo_box_question }
    end
  end

  # GET /combo_box_questions/new
  # GET /combo_box_questions/new.xml
  def new
    @combo_box_question = ComboBoxQuestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @combo_box_question }
    end
  end

  # GET /combo_box_questions/1/edit
  def edit
    @combo_box_question = ComboBoxQuestion.find(params[:id])
  end

  # POST /combo_box_questions
  # POST /combo_box_questions.xml
  def create
    @combo_box_question = ComboBoxQuestion.new(params[:combo_box_question])

    respond_to do |format|
      if @combo_box_question.save
        format.html { redirect_to(@combo_box_question, :notice => 'Combo box question was successfully created.') }
        format.xml  { render :xml => @combo_box_question, :status => :created, :location => @combo_box_question }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @combo_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /combo_box_questions/1
  # PUT /combo_box_questions/1.xml
  def update
    @combo_box_question = ComboBoxQuestion.find(params[:id])

    respond_to do |format|
      if @combo_box_question.update_attributes(params[:combo_box_question])
        format.html { redirect_to(@combo_box_question, :notice => 'Combo box question was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @combo_box_question.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /combo_box_questions/1
  # DELETE /combo_box_questions/1.xml
  def destroy
    @combo_box_question = ComboBoxQuestion.find(params[:id])
    @combo_box_question.destroy

    respond_to do |format|
      format.html { redirect_to(combo_box_questions_url) }
      format.xml  { head :ok }
    end
  end
end
