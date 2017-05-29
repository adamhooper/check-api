class Bot::Slack < ActiveRecord::Base

  include CheckSettings

  def self.default
    Bot::Slack.where(name: 'Slack Bot').last
  end

  def should_notify?(team, model)
    User.current.present? && team.present? && !model.skip_notifications && team.setting(:slack_notifications_enabled).to_i === 1
  end

  def should_notify_super_admin?
    User.current.present? && !self.skip_notifications && self.setting(:slack_notifications_enabled).to_i === 1
  end

  def notify_slack(model)
    t, p = self.get_team_and_project(model)
    if self.should_notify?(t, model)
      webhook = t.setting(:slack_webhook)
      channel = p.setting(:slack_channel) unless p.nil?
      channel ||= t.setting(:slack_channel)
      message = model.slack_notification_message if model.respond_to?(:slack_notification_message)
      self.send_slack_notification(model, webhook, channel, message)
    end
    self.notify_super_admin(model, t, p) if self.should_notify_super_admin?
  end

  def notify_super_admin(model, team, project)
    webhook = self.setting(:slack_webhook)
    channel = self.setting(:slack_channel)
    message = model.slack_notification_message if model.respond_to?(:slack_notification_message)
    unless message.blank?
      prefix = team.name
      prefix += ": #{project.title}" unless project.nil?
      message  = "[#{prefix}] - #{message}"
    end
    self.send_slack_notification(model, webhook, channel, message)
  end

  def send_slack_notification(model, webhook, channel, message)
    return if webhook.blank? || channel.blank? || message.blank?

      data = {
        payload: {
          channel: channel,
          text: message.gsub('\\n', "\n")
        }.to_json
      }

      Rails.env === 'test' ? self.request_slack(model, webhook, data) : SlackNotificationWorker.perform_async(webhook, YAML::dump(data), YAML::dump(User.current))
  end

  def request_slack(model, webhook, data)
    self.request(webhook, data)
    model.sent_to_slack = true
  end

  def request(webhook, data)
    url = URI.parse(webhook)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url.request_uri)
    request.set_form_data(data)
    http.request(request)
  end

  def get_team_and_project(model)
    t = model.team if model.respond_to?(:team)
    p = model if model.class.to_s == 'Project'
    if model.is_annotation? && model.annotated_type == 'ProjectMedia'
      p = model.annotated.project
      t = model.current_team
    end
    p = model.project if p.nil? && model.respond_to?(:project)
    t ||= p.team unless p.nil?
    return t, p
  end

end
