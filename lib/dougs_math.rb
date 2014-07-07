# this class is responsable for providing an object for each calculated response 
# setting the object as a property would be the responsability of the consuming object

class DougsMath

  def add(first, second)
    first = BigDecimal(first.to_s)
    second = BigDecimal(second.to_s)
    (first + second).to_s
  end

  def subtract(first, second)
    first = BigDecimal(first.to_s)
    second = BigDecimal(second.to_s)
    (first - second).to_s
  end

  def multiply(first, second)
    first = BigDecimal(first.to_s)
    second = BigDecimal(second.to_s)
    (first * second).to_s
  end

  def divide(first, second)
    first = BigDecimal(first.to_s)
    second = BigDecimal(second.to_s)
    (first / second).to_s
  end

end

