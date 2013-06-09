class must-have {
  include apt

  apt::ppa { "ppa:chris-lea/node.js": }

  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    before => Apt::Ppa["ppa:chris-lea/node.js"],
  }

  exec { 'apt-get update 2':
    command => '/usr/bin/apt-get update',
    require => Apt::Ppa["ppa:chris-lea/node.js"],
  }

  exec { 'install gem compass':
    command => '/opt/ruby/bin/gem install compass',
    creates => "/opt/ruby/bin/compass",
    require => Exec["apt-get update 2"],
  }

  exec { 'install gem sass':
    command => '/opt/ruby/bin/gem install sass',
    creates => "/opt/ruby/bin/sass",
    require => Exec["apt-get update 2"],
  }

  exec { 'install yeoman':
    command => '/usr/bin/npm install -g yo grunt-cli bower phantomjs',
    creates => [
      '/usr/lib/node_modules/bower/bin/bower',
      '/usr/lib/node_modules/yo/bin/yo',
      '/usr/lib/node_modules/grunt-cli/bin/grunt',
      '/usr/lib/node_modules/phantomjs/bin/phantomjs'
      ],
    require => [ Exec["apt-get update 2"], Package["nodejs"] ],
  }

  exec { 'install webapp generator':
    command => '/usr/bin/npm install -g generator-webapp',
    creates => '/usr/lib/node_modules/generator-webapp',
    require => Exec["install yeoman"],
  }

  file { "/home/vagrant/yeoman/webapp":
      ensure => "directory",
      before => Exec['create webapp site'],
      require => Exec['install webapp generator'],
  }

  exec { 'create webapp site':
    command => '/usr/bin/yes | /usr/lib/node_modules/yo/bin/yo webapp',
    cwd => '/home/vagrant/yeoman/webapp',
    creates => '/home/vagrant/yeoman/webapp/app',
    require => File["/home/vagrant/yeoman/webapp"],
  }

  file_line { "update hostname in gruntfile": 
    line => "                hostname: '0.0.0.0'", 
    path => "/home/vagrant/yeoman/webapp/Gruntfile.js", 
    match => "hostname: '.*'", 
    ensure => present,
    require => Exec["create webapp site"],
  }

  package { ["vim",
             "bash",
             "nodejs",
             "git-core",
             "fontconfig"]:
    ensure => present,
    require => Exec["apt-get update 2"],
  }


}

include must-have
