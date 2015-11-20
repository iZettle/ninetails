RSpec.shared_examples "having property" do |name, type|
  it "should have a #{type} property for #{name}" do
    prop = subject.class.properties.find { |p| p.name == name }
    expect(prop.type).to eq type
  end
end

RSpec.shared_examples "having element" do |name, type|
  it "should have the #{type} element for #{name}" do
    expect(subject_has_element?(subject, name, type, :single)).to be true
  end
end

RSpec.shared_examples "having many elements" do |name, type|
  it "should have many #{type} elements for #{name}" do
    expect(subject_has_element?(subject, name, type, :multiple)).to be true
  end
end

def subject_has_element?(subject, name, type, count)
  subject.class.elements.select{ |e| e.name == name && e.type == type && e.count == count }.present?
end

def it_should_have_property(name, type)
  include_examples "having property", name, type
end

def it_should_have_element(name, type)
  include_examples "having element", name, type
end

def it_should_have_many_elements(name, type)
  include_examples "having many elements", name, type
end
