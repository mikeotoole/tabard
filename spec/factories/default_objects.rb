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
        :character_proxies => []
      )
      app.accept_application(DefaultObjects.community.admin_profile)
      if not @user_profile.is_member?(DefaultObjects.community_two)
      appTwo = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community_two,
          :user_profile => @user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community_two.community_application_form, :user_profile => @user_profile),
          :character_proxies => @user_profile.character_proxies
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
          :character_proxies => @additional_community_user_profile.character_proxies
        )
      app.accept_application(DefaultObjects.community.admin_profile)
    end
    if not @additional_community_user_profile.is_member?(DefaultObjects.community_two)
      appTwo = FactoryGirl.create(:community_application,
          :community => DefaultObjects.community_two,
          :user_profile => @additional_community_user_profile,
          :submission => FactoryGirl.create(:submission, :custom_form => DefaultObjects.community_two.community_application_form, :user_profile => @additional_community_user_profile),
          :character_proxies => @additional_community_user_profile.character_proxies.reject{|cp| cp.game_name != "Star Wars: The Old Republic" }
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

  def self.wow_character_proxy
    @wow_character_proxy ||= FactoryGirl.create(:character_proxy_with_wow_character)
  end

  def self.swtor_character_proxy
    @swtor_character_proxy ||= FactoryGirl.create(:character_proxy_with_swtor_character)
  end

  def self.community
    @community ||= FactoryGirl.create(:community, :name => "Default Community")
    unless @community.games.include?(DefaultObjects.wow)
      @community.supported_games.create!(:name => "Test WoW Game", :game_id => DefaultObjects.wow, :game_type => "Wow")
    end
    unless @community.games.include?(DefaultObjects.swtor)
      @community.supported_games.create!(:name => "Test SWTOR Game", :game_id => DefaultObjects.swtor, :game_type => "Swtor")
    end
    unless @community.games.include?(DefaultObjects.minecraft)
      @community.supported_games.create!(:name => "Test Minecraft Game", :game_id => DefaultObjects.minecraft, :game_type => "Minecraft")
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

  def self.community_admin_with_stripe
    if @community_admin_with_stripe
      @community_admin_with_stripe
    else
      community = FactoryGirl.create(:community, :name => "Admin with Stripe Comm")
      @community_admin_with_stripe = community.admin_profile.user

      stripe_customer = Stripe::Customer.create(
        :description => "Customer for test@example.com",
        :card => DefaultObjects.stripe_card_token.id
      )
      @community_admin_with_stripe.stripe_customer_token = stripe_customer.id
      @community_admin_with_stripe.owned_communities << community
      @community_admin_with_stripe.save!
      @community_admin_with_stripe
    end
  end

  def self.community_two
    @community_two ||= FactoryGirl.create(:community, :name => "Default Community Two")
    unless @community_two.games.include?(DefaultObjects.swtor)
      @community_two.supported_games.create!(:name => "Test Game", :game_id => DefaultObjects.swtor, :game_type => "Swtor")
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

  def self.stripe_card_token
    Stripe::Token.create(
        :card => {
        :number => "4242424242424242",
        :exp_month => 9,
        :exp_year => 2023,
        :cvc => 314
      },
    )
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
    @community_admin_with_stripe = nil
    @general_discussion_space = nil
    @random_discussion = nil
    @custom_form = nil
    @community_admin = nil
    @wow_character_proxy = nil
    @swtor_character_proxy = nil
    @discussion_space = nil
    @discussion = nil
    @page_space = nil
    @general_page_space = nil
  end
end