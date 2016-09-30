FactoryGirl.define do

  sequence :url do |n|
    "/foo/#{n}"
  end

  factory :container, class: Ninetails::Container do
    association :current_revision, factory: :revision
    locale "en_US"
    url

    trait :with_revisions do
      transient do
        revisions_count 5
      end

      after :create do |container, evaluator|
        create_list :revision, evaluator.revisions_count, container: container
      end
    end

    trait :with_a_revision do
      after :create do |container, _|
        create :revision, container: container
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
