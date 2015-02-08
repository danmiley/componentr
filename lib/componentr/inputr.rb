class Componentr::Inputr
  def initialize(inputs)
    @inputs = inputs
  end

  def hi
    case @inputs
    when "spanish"
      "hola mundo"
    when "korean"
      "anyoung ha se yo"
    else
      "hello world"
    end
  end
end
