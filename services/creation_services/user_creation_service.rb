require_relative '../../model/user_model'

class UserCreationService
  def self.create(user_name, email, credit_limit)
    @user = User.new(user_name, email, credit_limit)
    if @user.save
      puts "User created successfully"
    else
      puts @user.errors.full_messages
    end
  end
end