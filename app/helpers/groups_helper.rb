module GroupsHelper
  def render_groupdesc(group)
    simple_format(group.desc)
  end
end
