vagrant-yeoman-env
==================

A vagrant dev environment for yeoman (http://yeoman.io) that uses a Ubuntu 12.10 Server image and Puppet for provisioning.

This repo is intended as a proof of concept for running a fully-functional Yeoman default generator ("generator-webapp") in Vagrant

## Dependencies

1. [Vagrant](http://downloads.vagrantup.com/)
2. [VirtualBox (for local servers)](https://www.virtualbox.org/wiki/Downloads)

## Usage

To create your local Yeoman environment:

        $ git clone https://github.com/lwndev/vagrant-yeoman-env.git
        $ cd vagrant-yeoman-env/vagrant
        $ vagrant up
        
This will do the following

1. Download a Vagrant 'base box' for VirtualBox.  The box in question includes Ubuntu Server 12.10 with Ruby 1.9.3p194 and Puppet 2.7.18.
2. Boot the VM and run Puppet to install additional dependencies:
    1. vim
    2. bash
    3. nodejs
    4. git
    5. fontconfig
3. Then a few gems are installed:
    1. Compass
    2. SASS
4. Then some additional dependencies for Yeoman are installed via NPM
    1. Yo
    2. Grunt
    3. Bower
    4. Phantomjs
    5. Yeoman "webapp" generator
5. The yo is called with the webapp generator as its argument and a project skeleton is created
6. And finally, a small tweak is made to Gruntfile.js in the /webapp directory that makes the webapp instance available to the host machine when it is running

This entire process will take about 10-15 minutes on a high-speed connection (20MBS+). The base box is about 430MB and there's around 300MB of dependencies that need to be downloaded once the VM boots.

Once all of this is complete, you can log in to the box and start the server

        $ vagrant ssh
        $ cd ~/yeoman/webapp
        $ grunt server
        
Then you can access the server at 192.168.40.10:9000
        
## Notes

* The VM uses 1GB of RAM.  This is probably overkill and you can adjust memory allocation in the Vagrantfile if you wish (/vagrant/Vagrantfile)
* Live refresh of the browser is not currently supported as your browser is technically on a different operating system
* Yeoman is still in beta as of this writing and I've noticed wonkyness with the webapp generator, specifically when downloading some dependencies via NPM.

Happy Coding!

        
