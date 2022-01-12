class Event < ApplicationRecord
    serialize :recurring, Hash

    def recurring=(value)
        if RecurringSelect.is_valid_rule?(value)
            super(RecurringSelect.dirty_hash_to_rule(value).to_hash)
        else
            super(nil)
        end
    end
end
