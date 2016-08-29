class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :update, :destroy, :to => :cud
    @user = user ||= User.new
    # Define User abilities
    if user.has_role? :admin
      global_admin_perms
    elsif user.has_role? :owner
      owner_perms
    elsif user.has_role? :editor
      editor_perms
    elsif user.has_role? :journalist
      journalist_perms
    elsif user.has_role? :contributor
      contributor_perms
    else
      anonymous_perms
    end

  end

  private

  def global_admin_perms
    can :manage, :all
  end

  def owner_perms
    can :manage, Team, :team_users => { :user_id => @user.id }
    can :manage, Project, :team_id => @user.current_team.id
    can :manage, [Media, Comment], :get_team => @user.current_team.id
    can [:update, :destroy], User, :team_users => { :team_id => @user.current_team.id, role: ['owner', 'editor', 'journalist', 'contributor'] }
    can :create, Flag, flag: ['Mark as graphic'], :get_team => @user.current_team.id
    can [:create, :destroy], Status, :get_team => @user.current_team.id
  end

  def editor_perms
    can [:create, :update], Team, :team_users => { :user_id => @user.id }
    can :manage, Project, :team_id => @user.current_team.id
    can :manage, [Media, Comment], :get_team => @user.current_team.id
    can [:update, :destroy], User, :team_users => { :team_id => @user.current_team.id, role: ['editor', 'journalist', 'contributor'] }
    can :create, Flag, flag: ['Mark as graphic'], :get_team => @user.current_team.id
    can [:create, :destroy], Status, :get_team => @user.current_team.id
  end

  def journalist_perms
    can :create, [Team, Project, Media, Comment]
    can [:update, :destroy], Project, :team_id => @user.current_team.id, :user_id => @user.id
    can [:update, :destroy], Media, :get_team => @user.current_team.id, :user_id => @user.id
    can [:update, :destroy], User, :team_users => { :team_id => @user.current_team.id, role: ['journalist', 'contributor'] }
    can [:update, :destroy], Flag, :get_team => @user.current_team.id, :annotator_id => @user.id
    can :create, Flag, flag: ['Mark as graphic'], :get_team => @user.current_team.id
    can [:create, :destroy], Status, :get_team => @user.current_team.id, :annotator_id => @user.id
  end

  def contributor_perms
    can :create, [Team, Media, Comment]
    can [:update, :destroy], Media, :get_team => @user.current_team.id, :user_id => @user.id
    can :update, User, :id => @user.id
    can [:update, :destroy], Media, :get_team => @user.current_team.id, :annotator_id => @user.id
    can :create, Flag, flag: ['Spam', 'Graphic content'], :get_team => @user.current_team.id
  end

  def anonymous_perms
    can :create, Team
  end

end
