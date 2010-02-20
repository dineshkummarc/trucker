module Macros
  module MongoMapper
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def model
        self.name.to_s.gsub('Test', '').constantize
      end

      def should_validate_presence_of(*keys)
        keys.each do |key|
          test "should validate presence of #{key}" do
            doc = model.new
            doc.valid?
            assert doc.errors.on(key), "Expected to have error but did not"
          end
        end
      end
      
      def should_have_many(*associations)
        associations.each do |association|
          test "should have many #{association}" do
            assoc = model.associations[association]
            assert assoc, "Association #{association} was not found"
            assert assoc.many?, "Association #{association} found, but was not many"
          end
        end
      end
      
      def should_belong_to(*associations)
        associations.each do |association|
          test "should belong to #{association}" do
            assoc = model.associations[association]
            assert assoc, "Association #{association} was not found"
            assert assoc.belongs_to?, "Association #{association} found, but was not belongs to"
          end
        end
      end
    end
    
    def model
      self.class.model
    end
  end
end