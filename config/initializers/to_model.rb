# http://www.jroller.com/obie/entry/to_model_a_complement_for
class String
  # used to instantiate a model based on a dom_id style
  # identifier like "person_12"
  def to_model
    parts = self.split('_')
    id = parts.pop
    class_name = parts.join('_')
    class_name.classify.constantize.find(id)
  end
  
end