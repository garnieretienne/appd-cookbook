name             'appd'
maintainer       'Etienne Garnier'
maintainer_email 'garnier.etienne@gmail.com'
license          'All rights reserved'
description      'Installs/Configures Appd PaaS'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
supports         'ubuntu', '= 12.4'

depends          'sudo'
depends          'nginx'
depends          'git'
depends          'docker'

