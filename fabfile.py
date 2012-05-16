#-*- coding: utf-8 -*-
from fabric.api import run, local, put, cd

def deploy():
    local('git archive -o /tmp/tellerwaescher-deploy.tar master')
    run('mkdir -p /home/tellerwaescher/cleaner')
    with cd('/home/tellerwaescher/cleaner'):
        put('/tmp/tellerwaescher-deploy.tar', '/home/tellerwaescher/cleaner/source.tar')
        run('tar xf source.tar')
        run('rm source.tar')
        run('chown -R tellerwaescher:tellerwaescher /home/tellerwaescher')


