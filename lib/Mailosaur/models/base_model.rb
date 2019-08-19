module Mailosaur
    module Models
      class BaseModel
        def to_json(*_args)
            hash = {}
            instance_variables.each do |var|
              key = var.to_s.delete('@').split('_').collect(&:capitalize).join
              key = key[0].downcase + key[1..-1]
              hash[key] = instance_variable_get var
            end
            hash.to_json
        end
      end
    end
end
