=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for registration answers.
=end
class RegistrationAnswersController < ApplicationController
  respond_to :html

  def index
    @registration_answers = RegistrationAnswer.all
    respond_with(@registration_answers)
  end

  def show
    @registration_answer = RegistrationAnswer.find(params[:id])
    respond_with(@registration_answer)
  end

  def new
    @registration_answer = RegistrationAnswer.new
    respond_with(@registration_answer)
  end

  def edit
    @registration_answer = RegistrationAnswer.find(params[:id])
    respond_with(@registration_answer)
  end

  def create
    @registration_answer = RegistrationAnswer.new(params[:registration_answer])
    if @registration_answer.save
      add_new_flash_message('Registration answer was successfully created.')
    end
    grab_all_errors_from_model(@registration_answer)
    repsond_with(@registration_answer)
  end

  def update
    @registration_answer = RegistrationAnswer.find(params[:id])
    if @registration_answer.update_attributes(params[:registration_answer])
      add_new_flash_message('Registration answer was successfully updated.')
    end
    grab_all_errors_from_model(@registration_answer)
    respond_with(@registration_answer)
  end

  def destroy
    @registration_answer = RegistrationAnswer.find(params[:id])
    if @registration_answer.destroy
      add_new_flash_message('Registration answer was successfully deleted.')
    end
    grab_all_errors_from_model(@registration_answer)
    respond_with(@registration_answer)
  end
end
