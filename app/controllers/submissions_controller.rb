class SubmissionsController < ApplicationController
  before_filter :authenticate  
  respond_to :html, :xml
  
  # GET /submissions
  # GET /submissions.xml
  def index
    if !current_user.can_show("SiteForm") 
      render :nothing => true, :status => :forbidden
    else
      @site_form = SiteForm.find_by_id(params[:site_form_id])
      @submissions = @site_form.submissions
  
      respond_with @submissions
    end
  end

  # GET /submissions/1
  # GET /submissions/1.xml
  def show
    @submission = Submission.find(params[:id])

    respond_with @submission
  end

  # GET /submissions/new
  # GET /submissions/new.xml
  def new
    @submission = Submission.new
    
    @site_form = SiteForm.find_by_id(params[:site_form_id])
  
    @submission.site_form = @site_form
    @submission.answers.build
    #Setup predefined answers
    respond_with @submission
  end

  # POST /submissions
  # POST /submissions.xml
  def create
    @submission = Submission.new(params[:submission])
    
    @submission.user_profile = current_user.user_profile

    respond_to do |format|
      if @submission.save

        # Send massages to users of notify list.
        if !@submission.site_form.notifications.empty?
          Message.create(:author => UserProfile.system_profile, :to => @submission.site_form.profile_notifications, 
                          :subject => "New Submission for Form " + @submission.site_form.name, 
                          :body => "You have a new submission to view. \n<a href=" + site_form_submission_url(@submission.site_form, @submission) + ">Submission</a>\n\nThis is an automatically generated message sent because you are on the notification list for this form.\nReplies will not be seen.")
        end
        
        format.html { redirect_to([@submission.site_form, @submission], :notice => 'Submission was successfully created.') }
        format.xml  { render :xml => @submission, :status => :created, :location => @submission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @submission.errors, :status => :unprocessable_entity }
      end
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
