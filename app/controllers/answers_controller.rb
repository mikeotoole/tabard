=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for answers.
=end
class AnswersController < ApplicationController
  respond_to :html

  def index
    @answers = Answer.all
    respond_with(@answers)
  end

  def show
    @answer = Answer.find(params[:id])

    respond_with(@answer)
  end

  def new
    @answer = Answer.new
    respond_with(@answer)
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def create
    @answer = Answer.new(params[:answer])
    if @answer.save
      add_new_flash_message('Answer was successfully created.')
    end
    grab_all_errors_from_model(@answer)
    respond_with(@answer)
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      add_new_flash_message('Answer was successfully updated.')
    end
    grab_all_errors_from_model(@answer)
    respond_with(@answer)
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    grab_all_errors_from_model(@answer)
    respond_with(@answer)
  end
end
