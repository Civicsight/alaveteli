# -*- encoding : utf-8 -*-
class AddTimestampsToHolidays < !rails5? ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def change
    add_timestamps(:holidays, null: true)
  end
end
