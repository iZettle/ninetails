FactoryGirl.define do

  sequence :url do |n|
    "/foo/#{n}"
  end

  factory :container, class: Ninetails::Container do
    association :current_revision, factory: :revision
    name "Home"
    url
    type :page

    factory :container_with_revisions do
      transient do
        revisions_count 5
      end

      after :create do |container, evaluator|
        # -1 because the page is created with a 'current_revision', so when you say revisions_count: 10,
        # you'll only end up with 10 revisions instead of 11..
        create_list :revision, evaluator.revisions_count - 1, container: container
      end
    end

    factory :container_with_revision do
      after :create do |container, _|
        create :revision, container: container
      end
    end
  end

end
