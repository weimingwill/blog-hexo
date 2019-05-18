---
title: Python Virtualenv Set Up with Google App Engine Problems
tags:
  - 技术
  - Python
abbrlink: 61ad3714
date: 2016-05-03 17:28:20
---
<!-- more -->
**1. Import Error: from google import appengine.api**

Python is already installed in the virtualenv. Google App Engine SDK was also installed and have made symlinks. But it keep having this Import Error. The reason is that there may be several different versions of Python in the mac (The locations of Python is mentioned later) , the one Google App Engine linked to is not the same one as that I was using in the virtualenv. By setting the PATH and PYTHONPATH to have `/usr/local/google_appengine` is not useful either. What I have done was very violent. I cleared all the pythons and reinstall it and set up the virtualenv again. It solved the error.

**2. Ways to uninstall python in Mac OSX**

a. Don’t uninstall Apple’s python !!! It will mess you up with python environment, and is very hard to reset. Probably need to re-install OS X… Good luck

b. Uninstall python install with Homebrew: `brew uninstall python`

c. Uninstall python installed by other methods, e.g. downloading from official website: [](http://stackoverflow.com/questions/3819449/how-to-uninstall-python-2-7-on-a-mac-os-x-10-6-4)[http://stackoverflow.com/questions/3819449/how-to-uninstall-python-2-7-on-a-mac-os-x-10-6-4](http://stackoverflow.com/questions/3819449/how-to-uninstall-python-2-7-on-a-mac-os-x-10-6-4)

Very good post to understand the difference of the three [http://stackoverflow.com/questions/26917765/how-to-restore-python-on-os-x-yosemite-after-ive-deleted-something](http://stackoverflow.com/questions/26917765/how-to-restore-python-on-os-x-yosemite-after-ive-deleted-something)

**3. -bash: pip: command not found**

`sudo easy_install` pip runs successfully, pip is install. But when I did pip, it had that error `-bash: pip: command not found`. This is due to I deleted Apple’s python in `/System/Library/Frameworks/Python.framework/Versions/2.7`. Upgraded the system and Apple’s Python2.7 is back. Run  `sudo easy_install pip` again, it is solved.

**4. -bash: /usr/local/bin/virtualenv: /usr/local/opt/python/bin/python2.7: bad interpreter: No such file or directory**

uninstall and reinstall virtualenv. `sudo pip uninstall virtualenv`. `sudo pip install virtualenv`

Things to note, make sure you have `/usr/local/google_appengine` in your PATH before setting up the virtualenv. if not do this `export PATH=$PATH:/usr/local/google_appengine`.

Some other solutions I didn’t try:

[http://stackoverflow.com/questions/31768128/pip-installation-usr-local-opt-python-bin-python2-7-bad-interpreter-no-such-f](http://stackoverflow.com/questions/31768128/pip-installation-usr-local-opt-python-bin-python2-7-bad-interpreter-no-such-f)

[http://stackoverflow.com/questions/23319568/bash-pip-command-not-found](http://stackoverflow.com/questions/23319568/bash-pip-command-not-found)

Good to know: /usr/bin/python vs /opt/local/bin/python2.7 on OS X:

[http://stackoverflow.com/questions/27308234/usr-bin-python-vs-opt-local-bin-python2-7-on-os-x](http://stackoverflow.com/questions/27308234/usr-bin-python-vs-opt-local-bin-python2-7-on-os-x)
