class DefaultObjects
  def self.user
    @user ||= DefaultObjects.user_profile.user
  end

  def self.user_profile
    @user_profile ||= FactoryGirl.create(:user_profile, :user => FactoryGirl.create(:user))
    if not @user_profile.is_member?(DefaultObjects.community)
      app = FactoryGirl.create(:community_application,
        :community => DefaultObjects.community,
        :user_profile => @user_profile,
        :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => @user_profile),
        :characters => []
      )
      app.accept_application(DefaultObjects.community.admin_profile)
      if not @user_profile.is_member?(DefaultObjects.community_two)
      appTwo = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community_two,
          :user_profile => @user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community_two.community_application_form, :user_profile => @user_profile),
          :characters => @user_profile.characters
        )
      appTwo.accept_application(DefaultObjects.community_two.admin_profile)
    end
    end
    unless @user_profile.announcements.size > 0
      announcement1 = DefaultObjects.community.announcements.new(:name => "Announcement 1",
        :body => "Herp Derp")
      announcement1.user_profile = DefaultObjects.community.admin_profile
      announcement2 = DefaultObjects.community.announcements.new(:name => "Announcement 2",
        :body => "Herp Derp!")
      announcement2.user_profile = DefaultObjects.community.admin_profile
      announcement1.save
      announcement2.save
    end
    @user_profile
  end

  def self.additional_community_user_profile
    @additional_community_user_profile ||= FactoryGirl.create(:user_profile_with_characters, :user => FactoryGirl.create(:user))
    if not @additional_community_user_profile.is_member?(DefaultObjects.community)
      app = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community,
          :user_profile => @additional_community_user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community.community_application_form, :user_profile => @additional_community_user_profile),
          :characters => @additional_community_user_profile.characters
        )
      app.accept_application(DefaultObjects.community.admin_profile)
    end
    if not @additional_community_user_profile.is_member?(DefaultObjects.community_two)
      appTwo = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community_two,
          :user_profile => @additional_community_user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community_two.community_application_form, :user_profile => @additional_community_user_profile),
          :characters => @additional_community_user_profile.characters.reject{|cp| cp.game_name != "Star Wars: The Old Republic" }
        )
      appTwo.accept_application(DefaultObjects.community_two.admin_profile)
    end
    @additional_community_user_profile
  end

  def self.fresh_user_profile
    @fresh_user_profile ||= FactoryGirl.create(:user_profile_with_characters, :user => FactoryGirl.create(:user))
  end

  def self.wow
    @wow ||= FactoryGirl.create(:wow)
  end

  def self.swtor
    @swtor ||= FactoryGirl.create(:swtor)
  end

  def self.minecraft
    @minecraft ||= FactoryGirl.create(:minecraft)
  end

  def self.wow_character
    @wow_character ||= FactoryGirl.create(:wow_character)
  end

  def self.swtor_character
    @swtor_character ||= FactoryGirl.create(:swtor_character)
  end

  def self.community
    @community ||= FactoryGirl.create(:community, :name => "Default Community")
    unless @community.games.include?(DefaultObjects.wow)
      @community.community_games.create!(:game => DefaultObjects.wow)
    end
    unless @community.games.include?(DefaultObjects.swtor)
      @community.community_games.create!(:game => DefaultObjects.swtor)
    end
    unless @community.games.include?(DefaultObjects.minecraft)
      @community.community_games.create!(:game => DefaultObjects.minecraft)
    end
    unless @community.announcements.size > 0
      announcement1 = @community.announcements.new(:name => "Announcement 1",
        :body => "Herp Derp")
      announcement1.user_profile = @community.admin_profile
      announcement2 = @community.announcements.new(:name => "Announcement 2",
        :body => "Herp Derp!")
      announcement2.user_profile = @community.admin_profile
      announcement1.save!
      announcement2.save!
    end
    @community
  end

  def self.community_admin
    if @community_admin
      @community_admin
    else
      @community_admin = DefaultObjects.community.admin_profile.user
      @community_admin.owned_communities << DefaultObjects.community
      @community_admin
    end
  end

  def self.community_admin_with_stripe_in_state
    if @community_admin_with_stripe_in_state
      @community_admin_with_stripe_in_state
    else
      community = FactoryGirl.create(:community, :name => "Stripe Comm with Tax")
      @community_admin_with_stripe_in_state = community.admin_profile.user

      stripe_customer = Stripe::Customer.create(
        :description => "Customer for test@example.com",
        :card => DefaultObjects.stripe_card_token_in_state
      )
      @community_admin_with_stripe_in_state.stripe_customer_token = stripe_customer.id
      @community_admin_with_stripe_in_state.owned_communities << community
      @community_admin_with_stripe_in_state.save!
      @community_admin_with_stripe_in_state
    end
  end

  def self.community_admin_with_stripe_out_state
    if @community_admin_with_stripe_out_state
      @community_admin_with_stripe_out_state
    else
      community = FactoryGirl.create(:community, :name => "Stripe Comm with NO Tax")
      @community_admin_with_stripe_out_state = community.admin_profile.user

      stripe_customer = Stripe::Customer.create(
        :description => "Customer for test@example.com",
        :card => DefaultObjects.stripe_card_token_out_state
      )
      @community_admin_with_stripe_out_state.stripe_customer_token = stripe_customer.id
      @community_admin_with_stripe_out_state.owned_communities << community
      @community_admin_with_stripe_out_state.save!
      @community_admin_with_stripe_out_state
    end
  end

  def self.invoice
    if @invoice
      @invoice
    else
      invoice_item = FactoryGirl.create(:invoice_item)
      old_invoice = invoice_item.invoice.reload
      old_invoice.mark_paid_and_close
      @invoice = old_invoice.user.current_invoice
      user_pack = invoice_item.community.current_community_plan.community_upgrades.first
      @invoice.invoice_items.new({community: invoice_item.community, item: user_pack, quantity: 1}, without_protection: true)
      @invoice.save!
      @invoice
    end
  end

  def self.invoice_with_tax
    if @invoice_with_tax
      @invoice_with_tax
    else
      invoice_item = FactoryGirl.create(:invoice_item_with_tax)
      old_invoice = invoice_item.invoice.reload
      old_invoice.mark_paid_and_close
      @invoice_with_tax = old_invoice.user.current_invoice
      user_pack = invoice_item.community.current_community_plan.community_upgrades.first
      @invoice_with_tax.invoice_items.new({community: invoice_item.community, item: user_pack, quantity: 1}, without_protection: true)
      @invoice_with_tax.save!
      @invoice_with_tax
    end
  end

  def self.community_two
    @community_two ||= FactoryGirl.create(:community, :name => "Default Community Two")
    unless @community_two.games.include?(DefaultObjects.swtor)
      @community_two.community_games.create!(:game => DefaultObjects.swtor)
    end
    @community_two
  end

  def self.custom_form
    @custom_form ||= FactoryGirl.create(:custom_form)
  end

  def self.general_discussion_space
    @general_discussion_space ||= FactoryGirl.create(:discussion_space, :name => "General Stuff")
  end

  def self.random_discussion
    @random_discussion ||= FactoryGirl.create(:discussion,
        :discussion_space_id => self.general_discussion_space.id,
        :user_profile_id => self.community.admin_profile_id)
  end

  def self.discussion_space
    @discussion_space ||= FactoryGirl.create(:discussion_space)
  end

  def self.discussion
    @discussion ||= FactoryGirl.create(:discussion)
  end

  def self.page_space
    @page_space ||= FactoryGirl.create(:page_space)
  end

  def self.general_page_space
    @general_page_space ||= FactoryGirl.create(:page_space, :name => "General Stuff")
  end

  def self.stripe_card_token_out_state
    Stripe::Token.create(
        :card => {
        :number => "4242424242424242",
        :exp_month => 9,
        :exp_year => 2023,
        :cvc => 314,
        :address_line1 => '1421 Ducale DR SE',
        :address_city => 'Rio Rancho',
        :address_state => 'NM',
        :address_zip => '87124'
      },
    ).id
  end

  def self.stripe_card_token_in_state
    Stripe::Token.create(
        :card => {
        :number => "4242424242424242",
        :exp_month => 9,
        :exp_year => 2023,
        :cvc => 314,
        :address_line1 => '710 George Washington Way',
        :address_city => 'Richland',
        :address_state => 'WA',
        :address_zip => '99352'
      },
    ).id
  end

  def self.clean
    @user = nil
    @user_profile = nil
    @additional_community_user_profile = nil
    @fresh_user_profile = nil
    @wow = nil
    @swtor = nil
    @minecraft = nil
    @community = nil
    @community_two = nil
    @community_admin_with_stripe_in_state = nil
    @community_admin_with_stripe_out_state = nil
    @general_discussion_space = nil
    @random_discussion = nil
    @custom_form = nil
    @community_admin = nil
    @wow_character = nil
    @swtor_character= nil
    @discussion_space = nil
    @discussion = nil
    @page_space = nil
    @general_page_space = nil
    @invoice = nil
    @invoice_with_tax = nil
  end
end