namespace :db do
  desc "Drop users"
  task :drop_users => "db:load_config" do
    begin
      config = ActiveRecord::Base.configurations[::Rails.env]
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection.execute("DELETE FROM users")
    end
  end
end
