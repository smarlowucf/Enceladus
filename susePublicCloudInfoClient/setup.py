#!/usr/bin/env python
"""Setup module for pint"""

# Copyright (c) 2015 SUSE LLC, Robert Schweikert <rjschwei@suse.com>
#
# This file is part of ec2uploadimg.
#
# ec2uploadimg is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ec2uploadimg is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ec2uploadimg. If not, see <http://www.gnu.org/licenses/>.

import os
import sys

try:
    import setuptools
except ImportError:
    sys.stderr.write('Python setuptools required, please install.')
    sys.exit(1)

version = {}
version_path = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    'lib',
    'susepubliccloudinfoclient',
    'version.py'
)
with open(version_path, 'r') as f:
    exec(f, version)

description = 'Command-line tool to access SUSE Public Cloud Information '
description += 'Service'

if __name__ == '__main__':
    setuptools.setup(
        name='susepubliccloudinfoclient',
        description=(description),
        url='https://github.com/SUSE/Enceladus',
        license='GPL-3.0+',
        author='SUSE Public Cloud Team',
        author_email='public-cloud-dev@susecloud.net',
        version=version['VERSION'],
        packages=setuptools.find_packages('lib'),
        package_dir={
            '': 'lib',
        },
        scripts=['bin/pint', 'bin/awscsvgen']
    )
