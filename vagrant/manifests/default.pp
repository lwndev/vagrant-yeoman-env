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
    require => Exec["apt-get update 2"],
  }

  exec { 'install gem sass':
    command => '/opt/ruby/bin/gem install sass',
    require => Exec["apt-get update 2"],
  }

  exec { 'install yeoman':
    command => '/usr/bin/npm install -g yo grunt-cli bower',
    require => [ Exec["apt-get update 2"], Package["nodejs"] ],
  }

  exec { 'install webapp generator':
    command => '/usr/bin/npm install -g generator-webapp',
    require => Exec["install yeoman"],
  }

  package { ["vim",
             "bash",
             "nodejs",
             "git-core",
             "apache2"]:
    ensure => present,
    require => Exec["apt-get update 2"],
  }


}

include must-have
