
class FolderManager
  ROOT_SITE = 'sites'

  def initialize(site)
    @site = site
  end

  def init_site
    create_directory
  end

  def dirname
    Rails.root.join(ROOT_SITE, @site.site_folder)
  end

  private

  def directory_exists?
    File.directory?(dirname)
  end

  def create_directory
    Dir.mkdir(dirname) unless directory_exists?
  end
end
