# frozen_string_literal: true

RSpec.define_context "outside in_context" do
  it "works for outside context" do
    expect(true).to be_truthy
  end
end

RSpec.define_context "outside namespaced", namespace: 'outside' do
  it "works" do
    expect(true).to be_truthy
  end
end

RSpec.define_context "outside short-namespaced", ns: 'outside' do
  it "works" do
    expect(true).to be_truthy
  end
end

describe RspecInContext::InContext do
  define_context "inside in_context" do
    it "works for inside context" do
      expect(true).to be_truthy
    end
  end

  define_context :with_symbol do
    it "works both with and without symbols" do
      expect(true).to be_truthy
    end
  end

  define_context "with test block" do
    it "doesn't find unexistant variable" do
      expect(defined?(new_var)).to be_falsy
    end

    context "with new variable" do
      let(:new_var) { true }

      execute_tests
    end
  end

  define_context "with instanciate block" do
    it "doesn't find unexistant variable" do
      expect(defined?(new_var)).to be_falsy
    end

    context "with variable instanciated" do
      instanciate_context

      it "works with another variable" do
        expect(another_var).to eq(:value)
      end
    end
  end

  define_context "with argument" do |name|
    it "doesn't find #{name}" do
      expect(defined?(outside_var)).to be_falsy
    end

    context "with #{name}" do
      let(name) { true }

      execute_tests
    end
  end

  define_context :nested do
    context "with inside_var defined" do
      let(:inside_var) { true }

      it "works in nested in_context" do
        expect(outside_var).to eq(inside_var)
      end
    end
  end

  define_context "in_context in in_context" do
    in_context "with argument", :inside do
      it "works to use a in_context inside a define_context" do
        expect(inside).to be_truthy
      end
    end
  end

  describe "in_context calls" do
    in_context "outside in_context"
    in_context "inside in_context"
    in_context "with_symbol"

    in_context "with test block" do
      it "works with new_var" do
        expect(new_var).to be_truthy
      end
    end

    in_context "with instanciate block" do
      let(:another_var) { :value }
    end

    in_context "with argument", :outside_var do
      it "works with outside_var" do
        expect(outside_var).to be_truthy
      end

      in_context :nested
    end

    in_context "in_context in in_context"
  end

  describe "namespacing" do
    in_context "outside namespaced"
    in_context "outside namespaced", namespace: :outside
    in_context "outside namespaced", ns: "outside"
    in_context "outside short-namespaced", ns: :outside
    test_inexisting_context "outside namespaced", namespace: :not_exist

    define_context "inside namespaced", namespace: :inside do
      it "works" do
        expect(true).to be_truthy
      end
    end

    define_context :inside, ns: :inside do
      it "works" do
        expect(true).to be_truthy
      end
    end

    define_context "inside namespaced", ns: :inside_2 do
      it "works" do
        expect(true).to be_truthy
      end
    end

    in_context "inside namespaced"
    in_context "inside namespaced", namespace: :inside
    in_context :inside, ns: :inside
    in_context "inside namespaced", ns: :inside
    in_context "inside namespaced", ns: :inside_2
    test_inexisting_context "inside namespaced", namespace: :not_exist
    describe "context isolation still work" do
      define_context "isolated namespaced", ns: :isolated do
        it "works" do
          expect(true).to be_truthy
        end
      end
      in_context "isolated namespaced", ns: :isolated
      in_context :inside, ns: :inside
    end
    test_inexisting_context "isolated namespaced"
    test_inexisting_context "isolated namespaced", ns: :isolated
  end
end
