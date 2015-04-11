require 'bundler/setup'
require 'rails'
require 'active_record'

require_relative 'support/benchmark_rails.rb'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name, :email
    t.timestamps null: false
  end
end

class User < ActiveRecord::Base; end

attributes = {
  name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  email: "foobar@email.com",
  created_at: Date.today
}

1000.times do
  User.create!(attributes)
end

User.create!(name: 'kir', email: 'shatrov@me.com')

Benchmark.rails("activerecord/sqlite3_finders", time: 10) do
  User.first
  User.find(1)
  User.find_by(email: 'shatrov@me.com')
  User.find_by(name: 'kir')
end