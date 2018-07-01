# -*- encoding : utf-8 -*-
# Here you can override or add to the pages in the core website

Rails.application.routes.draw do

  match '/profile/address_line/edit' => 'user_address_line#edit',
        :as => :user_edit_address_line,
        :via => :get

  match '/profile/address_line' => 'user_address_line#update',
        :as => :user_update_address_line,
        :via => :put
		
  match '/profile/status_flag/edit' => 'user_status_flag#edit',
        :as => :user_edit_status_flag,
        :via => :get

  match '/profile/status_flag' => 'user_status_flag#update',
        :as => :user_update_status_flag,
        :via => :put		
end
