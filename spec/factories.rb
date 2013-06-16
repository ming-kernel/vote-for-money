FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "u#{n}"}
    password 'private'
    password_confirmation 'private'
    round_id 0
  end

  factory :group do
    users_number 1
    round_id 0
  end

  factory :proposal do    
    round_id 0
    money_a 200
    money_b 300
    money_c 400
    accept false  
  end


end