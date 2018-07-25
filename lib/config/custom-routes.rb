# -*- encoding : utf-8 -*-
# Here you can override or add to the pages in the core website

Rails.application.routes.draw do

  match '/profile/address_line/edit' => 'address_line#edit',
        :as => :user_edit_address_line,
        :via => :get

  match '/profile/address_line/show' => 'address_line#show',
        :as => :user_show_address_line,
        :via => :get


  patch '/address_line' => 'address_line#update'
		
  match '/profile/status_flag/edit' => 'user_status_flag#edit',
        :as => :user_edit_status_flag,
        :via => :get

  match '/profile/status_flag' => 'user_status_flag#update',
        :as => :user_update_status_flag,
        :via => :put		
end
