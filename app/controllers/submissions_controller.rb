class SubmissionsController < ApplicationController
  before_filter :authenticate  
  respond_to :html

  def index
    if !current_user.can_show("SiteForm") 
      render_insufficient_privileges
    else
      @site_form = SiteForm.find_by_id(params[:site_form_id])
      @submissions = @site_form.submissions
      respond_with(@submissions)
    end
  end

  def show
    @submission = Submission.find(params[:id])
    if !current_user.can_show(@submission) 
      render_insufficient_privileges
    else
      respond_with @submission
    end
  end

  def new
    @submission = Submission.new
    if !current_user.can_create(@submission) 
      render_insufficient_privileges
    else
      @site_form = SiteForm.find_by_id(params[:site_form_id])
  
      @submission.site_form = @site_form
      @submission.answers.build
      #Setup predefined answers
      respond_with(@submission)
    end
  end

  def create
    @submission = Submission.new(params[:submission])
    if !current_user.can_create(@submission) 
      render_insufficient_privileges
    else
      @submission.user_profile = current_user.user_profile

      if @submission.save
        # TODO This needs moved to an observer.
        # Send massages to users of notify list.
        if !@submission.site_form.notifications.empty?
          Message.create(:author => UserProfile.system_profile, :to => @submission.site_form.profile_notifications, 
                          :subject => "New Submission for Form " + @submission.site_form.name, 
                          :body => "You have a new submission to view. \n<a href=" + site_form_submission_url(@submission.site_form, @submission) + ">Submission</a>\n\nThis is an automatically generated message sent because you are on the notification list for this form.\nReplies will not be seen.")
        end
        add_new_flash_message('Submission was successfully created.')
      end
      grab_all_errors_from_model(@submission)
      respond_with(@submisson)
    end
  end
  
  # # GET /submissions/1/edit
  # def edit
  #   @submission = Submission.find(params[:id])
  # end

  # # PUT /submissions/1
  # # PUT /submissions/1.xml
  # def update
  #   @submission = Submission.find(params[:id])
  #   @site_form = @submission.site_form
  # 
  #   respond_to do |format|
  #     if @submission.update_attributes(params[:submission])
  #       format.html { redirect_to(@submission, :notice => 'Submission was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /submissions/1
  # # DELETE /submissions/1.xml
  # def destroy
  #   @submission = Submission.find(params[:id])
  #   @submission.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(submissions_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
