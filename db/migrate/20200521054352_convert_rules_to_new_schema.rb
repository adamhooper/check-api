class ConvertRulesToNewSchema < ActiveRecord::Migration
  def change
    Team.all.find_each do |team|
      rules = team.get_rules
      unless rules.blank?
        puts "Updating rules for team #{team.name}..."
        new_rules = []
        rules.each do |rule|
          conditions = []
          rule['rules'].each do |condition|
            if condition['rule_definition'] == 'flagged_as'
              condition['rule_value'] = JSON.parse(condition['rule_value'])
            end
            conditions << condition.clone
          end
          new_rule = {
            name: rule['name'],
            project_ids: rule['project_ids'],
            actions: rule['actions'].clone,
            created_at: Time.now.to_i,
            rules: {
              operator: 'and',
              groups: [
                {
                  operator: 'and',
                  conditions: conditions
                }
              ]
            }
          }
          new_rules << new_rule
        end
        team.rules = new_rules.to_json
        team.save!
      end
    end
  end
end
