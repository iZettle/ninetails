FactoryGirl.define do

  sequence :url do |n|
    "/foo/#{n}"
  end

  factory :container, class: Ninetails::Container do
    association :current_revision, factory: :revision
    locale "en_US"

    trait :with_revisions do
      transient do
        revisions_count 5
      end

      after :create do |container, evaluator|
        # -1 because the page is created with a 'current_revision', so when you say revisions_count: 10,
        # you'll only end up with 10 revisions instead of 11..
        create_list :revision, evaluator.revisions_count - 1, container: container
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
    url
  end

  factory :layout, parent: :container, class: Ninetails::Layout do
    name "A layout"
  end

end
