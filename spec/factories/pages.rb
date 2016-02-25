FactoryGirl.define do

  sequence :url do |n|
    "/foo/#{n}"
  end

  factory :page, class: Ninetails::Page do
    association :current_revision, factory: :page_revision
    name "Home"
    url

    factory :page_with_revisions do
      transient do
        revisions_count 5
      end

      after :create do |page, evaluator|
        # -1 because the page is created with a 'current_revision', so when you say revisions_count: 10,
        # you'll only end up with 10 revisions instead of 11..
        create_list :page_revision, evaluator.revisions_count - 1, page: page
      end
    end

    factory :page_with_revision do
      after :create do |page, _|
        create :page_revision, page: page
      end
    end
  end

end
