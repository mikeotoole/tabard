ActiveAdmin.register SupportComment do
  belongs_to :support_ticket
  menu false
  controller.authorize_resource
  form do |f|
    f.inputs "Support Comment Details" do
      f.input :body
      f.buttons
    end
  end

  actions :new, :create

  controller do
    def create
      @support_ticket = current_admin_user.support_tickets.find_by_id(params[:support_ticket_id])
      @support_comment = (@support_ticket.blank? ? nil : @support_ticket.support_comments.new(params[:support_comment]))
      @support_comment.admin_user = current_admin_user
      if @support_comment.save
        redirect_to [:admin, @support_ticket]
      else
        render :new
      end
    end
  end

end