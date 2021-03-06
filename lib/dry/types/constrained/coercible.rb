module Dry
  module Types
    class Constrained
      class Coercible < Constrained
        # @param [Object] input
        # @param [#call] block
        # @yieldparam [Failure] failure
        # @yieldreturn [Result]
        # @return [Result]
        def try(input, &block)
          result = type.try(input)

          if result.success?
            validation = rule.(result.input)

            if validation.success?
              result
            else
              block ? yield(validation) : validation
            end
          else
            block ? yield(result) : result
          end
        end
      end
    end
  end
end
