# Redmine Burndowns

## Introduction

This plugin adds a 'Burndown' tab to your Project Menu for any Project with the 'Burndowns' module enabled (Settings>Modules). 

This tab will show the Burndown chart for the current Sprint (cough Version cough), and also give a sidebar listing of all previous Sprints to see their Burndown chart as well. The Burndown Chart shows the current work remaining in red and an ideal trend line in grey.

## Installation
The Redmine Burndowns plugin depends on the excellent googlecharts gems by Matt Aimonetti. This can be installed with:

    sudo gem install mattetti-googlecharts --source=http://gems.github.com
  
If you'd like, you may also unpack the gem into your Redmine deploy by adding the following to your environment.rb file:

    config.gem 'mattetti-googlecharts', :lib => 'gchart', :version => ">=1.3.6"

and then running:

    rake gems:unpack
  
Copyright (c) 2009 [Scrum Alliance](www.scrumalliance.org), released under the MIT license. 

Authored by:

* [Dan Hodos](mailto:danhodos[at]gmail[dot]com)
* [Doug Alcorn](mailto:dougalcorn[at]gmail[dot]com)