authorization do

  role :read do
    has_permission_on :catalogues, :to => [:index, :show, :changes, :grid] do
		if_attribute :users => contains {user}
		has_permission_on :movies, :to => [:index, :show, :update, :create]
        has_permission_on :apiv1, :to => [:update_many, :new_revisions]
    end
  end

  role :write do
    includes :read
    has_permission_on :catalogues, :to => :edit do
		if_attribute :users => contains {user}
    end
  end

  role :admin do
    includes :write
  end

end
