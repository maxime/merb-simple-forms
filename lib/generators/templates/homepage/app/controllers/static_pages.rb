class StaticPages < Application
  
  def homepage
    only_provides :html
    render
  end
end
