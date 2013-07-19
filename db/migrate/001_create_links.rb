# Put your database migration here!
#
# Each one needs to be named correctly:
# timestamp_[action]_[class]
#
# and once a migration is run, a new one must
# be created with a later timestamp.

class CreateLinks < ActiveRecord::Migration
    # PUT MIGRATION CODE HERE TO SETUP DATABASE
  def change
    create_table :urls do |t|
      t.string  :long_url
      t.integer  :short_url
    end
  end
end