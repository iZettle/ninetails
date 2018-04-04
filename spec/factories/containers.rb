FactoryBot.define do

  factory :container, class: Ninetails::Container do
    transient do
      sections []
      folder nil
    end

    association :current_revision, factory: :revision

    # The current_revision association is a slightly strange additon to a
    # has_many relationship in FactoryBot's world, which seems to be causing issues
    # with newly created "current_revision" revisions not having a container_id. So this
    # manually fixes that.
    after :create do |container, evaluator|
      revision_attrs = {}

      if container.current_revision.present? && container.current_revision.container_id.nil?
        revision_attrs[:container_id] = container.id
      end

      if evaluator.folder.present?
        revision_attrs[:folder_id] = evaluator.folder.id
      end

      container.current_revision.update_attributes revision_attrs

      if evaluator.sections.present?
        evaluator.sections.each do |section_name|
          section = Ninetails::ContentSection.new type: section_name
          section.elements = "Section::#{section_name}".safe_constantize.new.serialize
          section.save(validate: false)
          container.current_revision.sections << section
        end
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
  end

  factory :layout, parent: :container, class: Ninetails::Layout do
  end

end
