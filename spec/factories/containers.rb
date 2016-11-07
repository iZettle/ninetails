FactoryGirl.define do

  factory :container, class: Ninetails::Container do
    association :current_revision, factory: :revision
    locale "en_US"
    
    # The current_revision association is a slightly strange additon to a 
    # has_many relationship in FactoryGirl's world, which seems to be causing issues
    # with newly created "current_revision" revisions not having a container_id. So this
    # manually fixes that.
    after :create do |container, _|
      if container.current_revision.present? && container.current_revision.container_id.nil?
        container.current_revision.update_attributes container_id: container.id
      end
    end

    trait :with_revisions do
      transient do
        revisions_count 5
      end

      # -1 because the container is created with a default "current_revision"
      after :create do |container, evaluator|
        create_list :revision, evaluator.revisions_count - 1, container: container
      end
    end
  end

  factory :page, parent: :container, class: Ninetails::Page do
    name "A page"
  end

  factory :layout, parent: :container, class: Ninetails::Layout do
    name "A layout"
  end

end
