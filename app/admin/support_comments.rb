ActiveAdmin.register SupportComment do
  menu false
  controller.authorize_resource

  actions :new, :create

  # Override default controller actions.
  controller do
    # This overrides the default create
    def create
      @support_ticket = SupportTicket.find_by_id(params[:support_ticket_id])
      @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new(params[:support_comment]))
      @support_comment.admin_user = current_admin_user unless @support_comment.blank?
      if @support_comment.save
        redirect_to [:admin, @support_ticket]
      else
        render :new
      end
    end
  end

  form do |f|
    f.inputs "Support Comment Details" do
      f.input :body
      f.actions
    end
  end
end