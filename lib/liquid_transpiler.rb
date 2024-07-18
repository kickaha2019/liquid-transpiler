# frozen_string_literal: true

Dir["#{__dir__}/liquid_transpiler/*.rb"].each { |f| require f }
Dir["#{__dir__}/liquid_transpiler/operators/*.rb"].each { |f| require f }
Dir["#{__dir__}/liquid_transpiler/parts/*.rb"].each { |f| require f }
