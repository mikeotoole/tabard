class CustomFormsController < ApplicationController
  # GET /custom_forms
  # GET /custom_forms.json
  def index
    @custom_forms = CustomForm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_forms }
    end
  end

  # GET /custom_forms/1
  # GET /custom_forms/1.json
  def show
    @custom_form = CustomForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_form }
    end
  end

  # GET /custom_forms/new
  # GET /custom_forms/new.json
  def new
    @custom_form = CustomForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_form }
    end
  end

  # GET /custom_forms/1/edit
  def edit
    @custom_form = CustomForm.find(params[:id])
  end

  # POST /custom_forms
  # POST /custom_forms.json
  def create
    @custom_form = CustomForm.new(params[:custom_form])

    respond_to do |format|
      if @custom_form.save
        format.html { redirect_to @custom_form, notice: 'Custom form was successfully created.' }
        format.json { render json: @custom_form, status: :created, location: @custom_form }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /custom_forms/1
  # PUT /custom_forms/1.json
  def update
    @custom_form = CustomForm.find(params[:id])

    respond_to do |format|
      if @custom_form.update_attributes(params[:custom_form])
        format.html { redirect_to @custom_form, notice: 'Custom form was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @custom_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /custom_forms/1
  # DELETE /custom_forms/1.json
  def destroy
    @custom_form = CustomForm.find(params[:id])
    @custom_form.destroy

    respond_to do |format|
      format.html { redirect_to custom_forms_url }
      format.json { head :ok }
    end
  end
end
